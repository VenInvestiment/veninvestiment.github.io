import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:oku_sanga/solucoes_uteis/funcionais/provedor_codigo.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:oku_sanga/vista/janelas/tipo_usuario/ensino_superior/sub_janelas_painel/estudantes/sub_janela_visualizacao_estudantes.dart';
import 'package:oku_sanga/vista/janelas/tipo_usuario/ensino_superior/sub_janelas_painel/sub_janela_docentes.dart';
import 'package:oku_sanga/vista/janelas/tipo_usuario/ensino_superior/sub_janelas_painel/sub_janela_estudantes.dart';
import 'package:oku_sanga/vista/janelas/tipo_usuario/ensino_superior/sub_janelas_painel/sub_janela_plano_curricular.dart';
import 'package:oku_sanga/vista/janelas/tipo_usuario/ensino_superior/sub_janelas_painel/sub_janela_principal.dart';

class PainelEninoSuperior extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) {
        return definirSubJanelaAserExibida();
      },
    );
  }
  definirSubJanelaAserExibida(){
    if (observadorSistema.mudadoraSubJanelasDoPainel is String && observadorSistema.mudadoraSubJanelasDoPainel == "ir_para_sub_janela_plano_curricular") {
      return SubJanelaPlanoCurricular(nivelNavegacao: observadorSistema.pilhaDeniveisNavegacaoEdadoActual.top()["nivelNavegacao"],);
    }else if (observadorSistema.mudadoraSubJanelasDoPainel is String && observadorSistema.mudadoraSubJanelasDoPainel == "ir_para_sub_janela_docentes") {
      return SubJanelaManipulacaoDocentes();
    }else if (observadorSistema.mudadoraSubJanelasDoPainel is String && observadorSistema.mudadoraSubJanelasDoPainel == "ir_para_sub_janela_estudantes") {
      return SubJanelaEstudantes();
    }else if (observadorSistema.mudadoraSubJanelasDoPainel is String && observadorSistema.mudadoraSubJanelasDoPainel == "ir_para_sub_janela_visualizacao_estudantes") {
      return SubJanelaManipulacaoEstudantes();
    } 
    return SubJanelaPrincipal();
  }
}

