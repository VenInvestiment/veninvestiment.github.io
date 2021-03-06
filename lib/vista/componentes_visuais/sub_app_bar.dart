import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:oku_sanga/recursos/contantes.dart';
import 'package:oku_sanga/vista/janelas/tipo_usuario/ensino_superior/sub_janelas_painel/sub_janela_plano_curricular.dart';
import 'package:oku_sanga/solucoes_uteis/funcionais/provedor_codigo.dart';

gerarSubAppBar(BuildContext context,String titulo){
    return Container(
      color: COR_ACCENT,
      width: double.infinity,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          InkWell(
            child: Padding(
              padding: const EdgeInsets.only(top:5, left: 15, bottom: 5),
              child: Icon(Icons.arrow_back, color: COR_BRANCA,),
            ),
            onTap: (){
              if(observadorSistema.mudadoraSubJanelasDoPainel is String && observadorSistema.mudadoraSubJanelasDoPainel == "ir_para_sub_janela_docentes"){
                observadorSistema.mudarValorMudadoraSubJanelasDoPainel("ir_para_sub_janela_principal");
              }else if(observadorSistema.mudadoraSubJanelasDoPainel is String && observadorSistema.mudadoraSubJanelasDoPainel == "ir_para_sub_janela_plano_curricular"){
                if(NivelNavegacao.periodos == observadorSistema.pilhaDeniveisNavegacaoEdadoActual.top()["nivelNavegacao"]){
                  observadorSistema.mudarValorMudadoraSubJanelasDoPainel("ir_para_sub_janela_principal");
                }else{
                  observadorSistema.pilhaDeniveisNavegacaoEdadoActual.pop();
                  observadorSistema.listaCaminhosAteNivelActual.removeLast();
                  // ACTUALIZANDO A VIEW
                  observadorSistema.mudarValorMudadoraSubJanelasDoPainel(observadorSistema.mudadoraSubJanelasDoPainel);
                }
              }
            },
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.8,
            child: Center(
              child: Text("$titulo", style:TextStyle(color: COR_BRANCA)),
            ),
          )
        ],
      ),
    );
  }