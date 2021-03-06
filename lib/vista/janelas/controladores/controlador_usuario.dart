import 'dart:developer';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/cupertino.dart';
import 'package:oku_sanga/modelos/plano_curricular.dart';
import 'package:oku_sanga/modelos/base_dados_docentes.dart' as base_dados_docentes;
import 'package:oku_sanga/repositorio/interface_repositorio.dart';
import 'package:oku_sanga/solucoes_uteis/funcionais/provedor_codigo.dart';
import 'package:oku_sanga/vista/componentes_visuais/janela_dialogos.dart';
import 'package:oku_sanga/vista/componentes_visuais/layouts/layouts_para_dialogos.dart';
import 'package:oku_sanga/vista/componentes_visuais/observadores/observador_sistema.dart';
import 'package:oku_sanga/vista/janelas/tipo_usuario/ensino_superior/sub_janelas_painel/sub_janela_plano_curricular.dart';
import 'package:oku_sanga/vista/janelas/tipo_usuario/ensino_superior/sub_janelas_painel/sub_janela_principal.dart';

class ControladorUsuario{
  BuildContext context;
  ControladorUsuario({this.context});

  orientarTarefaAlterarInformacoesUsuario(){
    observadorSistema.mudarValorAccaoDoRepositorio(AccaoDoRepositorio.actualizacaoPerfil);
    observadorSistema.mudarValorSubAccaoDoRepositorio(SubAccaoDoRepositorio.salvarAlteracoesDadosNaListaCadstrados);
    irParaAreaUsuarioCadastrados();
  }

  orientarTarefaAlterarFotoUsuario(){
    observadorSistema.mudarValorAccaoDoRepositorio(AccaoDoRepositorio.actualizacaoFotoUsuario);
    observadorSistema.mudarValorSubAccaoDoRepositorio(SubAccaoDoRepositorio.nenhumaAccao);
    irParaAreaUploadFotos();
  }

  orientarTarefaClicarNaFotoRecentementeSelecionada(){
    observadorSistema.mudarValorSubAccaoDoRepositorio(SubAccaoDoRepositorio.clicarNaFotoSeleccionadaRecentemente);
  }

  orientarTarefaObterListaUsuariosTipoPessoaIndividual(){
    observadorSistema.mudarValorAccaoDoRepositorio(AccaoDoRepositorio.obterListaUsuariosTipoPessoaIndividual);
    observadorSistema.mudarValorSubAccaoDoRepositorio(SubAccaoDoRepositorio.pegarUsuariosTipoPessoaIndividual);
    irParaAreaUsuarioCadastrados();
  }

  orientarTarefaActualizarBancoDadosDocentes(){
    observadorSistema.mudarValorAccaoDoRepositorio(AccaoDoRepositorio.manipularBancosDadosRelaccionadoAoUsuario);
    observadorSistema.mudarValorSubAccaoDoRepositorio(SubAccaoDoRepositorio.actualizarBancoDadosDocentes);
    irParaAreaBancoDadosDocentes();
  }

  orientarTarefaObterPlanoCurricular(){
    observadorSistema.mudarValorAccaoDoRepositorio(AccaoDoRepositorio.manipularBancosDadosRelaccionadoAoUsuario);
    observadorSistema.mudarValorSubAccaoDoRepositorio(SubAccaoDoRepositorio.pegarPlanoCurricular);
    irParaAreaPlanoCurricular();
  }

  orientarTarefaObterPlanoCurricularNoSegundoPlano(){
    observadorSistema.mudarValorAccaoDoRepositorio(AccaoDoRepositorio.manipularBancosDadosRelaccionadoAoUsuario);
    observadorSistema.mudarValorSubAccaoDoRepositorio(SubAccaoDoRepositorio.pegarPlanoCurricular);
    irParaAreaPlanoCurricularNoSegundoPlano();
  }

  orientarTarefaActualizarPlanoCurricular(){
    observadorSistema.mudarValorAccaoDoRepositorio(AccaoDoRepositorio.manipularBancosDadosRelaccionadoAoUsuario);
    observadorSistema.mudarValorSubAccaoDoRepositorio(SubAccaoDoRepositorio.actualizarPlanoCurricular);
    irParaAreaPlanoCurricularNoSegundoPlano();
  }

  exibirDialogoParaAddCadeiraAdocente(BuildContext context){
    observadorSistema.limparPilhaElista();
    gerarDialogoAdicionarCadeiraDeDocente(context, observadorSistema.planoCurricular.periodos.map((e) => "${e.periodo}").toList(), NivelNavegacao.periodos);
  }

  eliminarCadeiraDedocente(base_dados_docentes.Cadeiras cadeira){
    base_dados_docentes.Docentes docente = observadorSistema.bancoDadosDocentes.pegarDocenteNaBaseDados(observadorSistema.bancoDadosDocentes.emailDocenteActual);
    docente.eliminarCadeira(cadeira);

    
    observadorSistema.mudarValorMudadoraSubJanelasDoPainel(observadorSistema.mudadoraSubJanelasDoPainel);
    orientarTarefaActualizarBancoDadosDocentes();
  }

  addCadeiraAdocente(String nomeCadeiraSucessora){

    base_dados_docentes.Cadeiras cadeira = base_dados_docentes.Cadeiras(
      nomeCadeiraSucessora: nomeCadeiraSucessora.split("|")[1],
      periodo: observadorSistema.listaCaminhosAteNivelActual[0],
      curso: observadorSistema.listaCaminhosAteNivelActual[1],
      ano: observadorSistema.listaCaminhosAteNivelActual[2],
      semestre: observadorSistema.listaCaminhosAteNivelActual[3],
      nomeCadeira: nomeCadeiraSucessora.split("|")[0],
    );

    bool resultado = observadorSistema.bancoDadosDocentes.pegarDocenteNaBaseDados(observadorSistema.bancoDadosDocentes.emailDocenteActual).verificarExistenciaCadeira(cadeira);
    if(resultado == false){
      observadorSistema.bancoDadosDocentes.pegarDocenteNaBaseDados(observadorSistema.bancoDadosDocentes.emailDocenteActual).cadeiras.add(cadeira);
      observadorSistema.mudarValorMudadoraSubJanelasDoPainel(observadorSistema.mudadoraSubJanelasDoPainel);
      orientarTarefaActualizarBancoDadosDocentes();
      Navigator.of(context).pop();
    }else{
      Fluttertoast.showToast(msg: "Já existe uma Cadeira com estes dados!");
    }
  }

  exibirDialogoParaAddEstudanteNoRespectivoBancoDados(){
    gerarDialogoComLayoutAseguirParaAdicaoDocentesOuEstudantes(context, layoutParaAddEstudante(context));
  }

  verificarPermissaoDeAddDadoNoPlanoCurricular(NivelNavegacao nivelNavegacao){
    if(NivelNavegacao.periodos == nivelNavegacao){
      if(observadorSistema.planoCurricular.periodos == null || observadorSistema.planoCurricular.periodos.length <2){
        gerarDialogoAdicionarDadoNoPlanoCurricular(context, observadorSistema.pilhaDeniveisNavegacaoEdadoActual.top()["nivelNavegacao"]);
      }else{
        Fluttertoast.showToast(msg: "Apenas 2 Períodos são permitidos!");
      }
    }else if(NivelNavegacao.cursos == nivelNavegacao){
      gerarDialogoAdicionarDadoNoPlanoCurricular(context, observadorSistema.pilhaDeniveisNavegacaoEdadoActual.top()["nivelNavegacao"]);
    }else if(NivelNavegacao.anos == nivelNavegacao){
      if((PlanoCurricular.pegarObjectoComBaseCaminhoAteUltimoNivel() as Cursos).anos == null || (PlanoCurricular.pegarObjectoComBaseCaminhoAteUltimoNivel() as Cursos).anos.length < 6){
        gerarDialogoAdicionarDadoNoPlanoCurricular(context, observadorSistema.pilhaDeniveisNavegacaoEdadoActual.top()["nivelNavegacao"]);
      }else{
        Fluttertoast.showToast(msg: "Apenas 6 Anos são permitidos!");
      }
    }else if(NivelNavegacao.semestres == nivelNavegacao){
      if((PlanoCurricular.pegarObjectoComBaseCaminhoAteUltimoNivel() as Anos).semestres == null || (PlanoCurricular.pegarObjectoComBaseCaminhoAteUltimoNivel() as Anos).semestres.length < 2){
        gerarDialogoAdicionarDadoNoPlanoCurricular(context, observadorSistema.pilhaDeniveisNavegacaoEdadoActual.top()["nivelNavegacao"]);
      }else{
        Fluttertoast.showToast(msg: "Apenas 2 Semestres são permitidos!");
      }
    }else if(NivelNavegacao.cadeiras == nivelNavegacao){
      gerarDialogoAdicionarDadoNoPlanoCurricular(context, observadorSistema.pilhaDeniveisNavegacaoEdadoActual.top()["nivelNavegacao"]);
    }
  }

  eliminarDadoNoPlanoCurricularComBaseNivelNavegacao(NivelNavegacao nivelNavegacao, String dado){
    if(NivelNavegacao.periodos == nivelNavegacao){
      observadorSistema.planoCurricular.periodos.removeWhere((element) => element.periodo == dado); 
    }else if(NivelNavegacao.cursos == nivelNavegacao){
      (PlanoCurricular.pegarObjectoComBaseCaminhoAteUltimoNivel() as  Periodos).cursos.removeWhere((element) => element.curso == dado);
    }else if(NivelNavegacao.anos == nivelNavegacao){
      (PlanoCurricular.pegarObjectoComBaseCaminhoAteUltimoNivel() as  Cursos).anos.removeWhere((element) => element.ano == dado);
    }else if(NivelNavegacao.semestres == nivelNavegacao){
      (PlanoCurricular.pegarObjectoComBaseCaminhoAteUltimoNivel() as  Anos).semestres.removeWhere((element) => element.semestre == dado);
    }else if(NivelNavegacao.cadeiras == nivelNavegacao){
      (PlanoCurricular.pegarObjectoComBaseCaminhoAteUltimoNivel() as  Semestres).cadeiras.removeWhere((element) => element.cadeira == dado);
    }
    observadorSistema.mudarValorDaPlanoCurricular(observadorSistema.planoCurricular);
    orientarTarefaActualizarPlanoCurricular();
  }
}