import 'dart:developer';

import 'package:mobx/mobx.dart';
import 'package:oku_sanga/modelos/base_dados_docentes.dart';
import 'package:oku_sanga/modelos/plano_curricular.dart';
import 'package:oku_sanga/modelos/usuario.dart';
import 'package:oku_sanga/vista/janelas/tipo_usuario/ensino_superior/sub_janelas_painel/sub_janela_plano_curricular.dart';
import 'package:stack/stack.dart';
part 'observador_sistema.g.dart';

class ObservadorSistema = _ObservadorSistemaBase with _$ObservadorSistema;

abstract class _ObservadorSistemaBase with Store {
  @observable
  dynamic mudadoraEstadoDoSistema;
  @observable
  dynamic mudadoraJanelasDoAplicativo;
  @observable
  dynamic mudadoraSubJanelasDoPainel;
  @observable
  String linkActual;
  @observable
  Usuario usuarioActual;
  @observable
  bool ignorarAccoesNaViewDoUsuario = false;
  @observable
  BaseDadosDocentes bancoDadosDocentes;
  @observable
  PlanoCurricular planoCurricular;
  @observable
  Map bancoDadosEstudantes;

  List<String> listaTipoInstituicaoDeReserva = [];
  bool loginSistemaFeito = false;
  Stack<Map> pilhaDeniveisNavegacaoEdadoActual = Stack();
  List<String> listaCaminhosAteNivelActual = List();
  bool temConexaoAnet = false;
  bool janlaDialogoAberta = false;
  bool metodoConexaoAoServidorEstimulado = false;
  String dadosUsuarioComoJsonEmString;
  AccaoDoRepositorio tipoAccaoDoRepositorio;
  SubAccaoDoRepositorio subAccaoDoRepositorio;
  
  @action
  mudarValorDaMudadoraEstadoDoSistema(dynamic novo){
    mudadoraEstadoDoSistema = novo;
  }

  @action
  mudarValorDaMudadoraJanelasDoAplicativo(dynamic novo){
    mudadoraJanelasDoAplicativo = novo;
  }

  @action
  mudarValorDaPlanoCurricular(PlanoCurricular novo){
    planoCurricular = novo;
  }

  @action
  mudarValorLinkActual(dynamic novo){
    linkActual = novo;
  }

  mudarValorJanlaDialogoAberta(bool novo){
    janlaDialogoAberta = novo;
  }

  mudarValorloginSistemaFeito(bool novo){
    loginSistemaFeito = novo;
  }

  mudarValorTemConexaoAnet(bool novo){
    temConexaoAnet = novo;
  }

  mudarValormetodoConexaoAoServidorEstimulado(bool novo){
    metodoConexaoAoServidorEstimulado = novo;
  }

  mudarValorNivelNavegacaoActual(Map novoNivelNavegacaoEdadoActual){
    pilhaDeniveisNavegacaoEdadoActual.push(novoNivelNavegacaoEdadoActual);
    String criterioNavegacao = novoNivelNavegacaoEdadoActual["criterioNavegacao"];
    if(criterioNavegacao != null){
      listaCaminhosAteNivelActual.add(criterioNavegacao);
    }
    log("Elementos na Lista: $listaCaminhosAteNivelActual");
    log("Tamanho da Lista: ${listaCaminhosAteNivelActual.length}");
    pilhaDeniveisNavegacaoEdadoActual.print();
    log("Tamanho da Pilha: ${pilhaDeniveisNavegacaoEdadoActual.length}");
  }
  
  @action
  mudarValorIgnorarAccoesNaViewDoUsuario(bool novo){
    ignorarAccoesNaViewDoUsuario = novo;
  }
  
  mudarValorListaTipoInstituicaoDeReserva(List<String> novo){
    listaTipoInstituicaoDeReserva = novo;
  }

  @action
  mudarValorUsuarioActual(Usuario novo){
    usuarioActual = novo;
  }

  @action
  mudarValorBancoDadosDocentes(BaseDadosDocentes novo){
    bancoDadosDocentes = novo;
  }

  @action
  mudarValorBancoDadosEstudantes(Map novo){
    bancoDadosEstudantes = novo;
  }

  @action
  mudarValorMudadoraSubJanelasDoPainel(dynamic novo){
    mudadoraSubJanelasDoPainel = novo;
  }

  mudarValorDadosUsuarioComoJsonEmString(String novo){
    dadosUsuarioComoJsonEmString = novo;
  }

  mudarValorAccaoDoRepositorio(AccaoDoRepositorio novo){
    tipoAccaoDoRepositorio = novo;
  } 

  mudarValorSubAccaoDoRepositorio(SubAccaoDoRepositorio novo){
    subAccaoDoRepositorio = novo;
  } 

  terminarSessaoUsuario(){
    mudadoraSubJanelasDoPainel = "ir_para_sub_janela_principal";
    usuarioActual = null;
    bancoDadosDocentes = null;
    planoCurricular = null;
    bancoDadosEstudantes = null;
    limparPilhaElista();
  }

  limparPilhaElista(){
    pilhaDeniveisNavegacaoEdadoActual = Stack();
    listaCaminhosAteNivelActual = [];
    log("Tamanho da Pihla: ${pilhaDeniveisNavegacaoEdadoActual.length}");
    log("Pihla Vazia: ${pilhaDeniveisNavegacaoEdadoActual.isEmpty}");
  }
}

enum SubAccaoDoRepositorio{
  nenhumaAccao,
  salvarAlteracoesDadosNaAreaUsuario,
  salvarAlteracoesDadosNaListaCadstrados,
  irParaAreaUsuario,
  irParaAreaUploadFotos,
  pegarDadosUsuario,
  clicarNaFotoSeleccionadaRecentemente,
  clicarNoButaoParaDescargaDaFoto,
  capturarLinkDaFoto,
  pegarBancoDadosDocentes,
  actualizarBancoDadosDocentes,
  actualizarPlanoCurricular,
  pegarBancoDadosEstudantes,
  pegarPlanoCurricular,
  pegarUsuariosTipoPessoaIndividual,
}

enum AccaoDoRepositorio{
  nenhumaAccao,
  autenticacaoSistema,
  loginUsuario,
  actualizacaoPerfil,
  actualizacaoFotoUsuario,
  cadastroUsuario,
  salvarAlteracoesNosDadosDoUsuario,
  requisitarListaTipoUsuario,
  manipularBancosDadosRelaccionadoAoUsuario,
  obterListaUsuariosTipoPessoaIndividual
}

enum TipoAccaoNaPilhaNivelNavegacaoEdadoActual{
  nenhumaAccao,
  removerUltimoNivelNavegacaoEdadoActual,
  adicionarNivelNavegacaoEdadoActual
}