import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:oku_sanga/repositorio/repositorio.dart';
import 'package:oku_sanga/solucoes_uteis/funcionais/provedor_codigo.dart';
import 'package:oku_sanga/vista/componentes_visuais/butao.dart';
import 'package:oku_sanga/vista/componentes_visuais/butao_voltar.dart';
import 'package:oku_sanga/vista/componentes_visuais/janela_dialogos.dart';
import 'package:oku_sanga/vista/componentes_visuais/observadores/observador_butoes.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:oku_sanga/vista/janelas/controladores/controlador_usuario.dart';

class JanelaMudancaFoto extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Mudando foto"),
        leading: ButaoVoltarTelaAnterior(
          metodoChamadoNoVlique: (){
            observadorSistema.mudarValorDaMudadoraJanelasDoAplicativo("ir_para_janela_perfil");
          },
        ),
      ),
      body: CorpoJanelaMudancaFoto(),
    );
  }
}

class CorpoJanelaMudancaFoto extends StatelessWidget{
  ObservadorButoes observadorButoes = ObservadorButoes();
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        GestureDetector(
          onTap: () {
            executarComandoJavaScrip(manipuladorDoRepositorio, "document.getElementById('ancora').click();");
          },
          child: Container(
            margin: EdgeInsets.only(top: 20, left: 20, right: 20),
            height: 120,
            width: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.blue,
            ),
            child: ClipRRect(
              borderRadius:
                  const BorderRadius.all(Radius.circular(120.0)),
              child: Icon(
                Icons.add_a_photo,
                size: 60,
                color: Colors.white,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Butao(
                tituloButao: "Definir foto",
                butaoHabilitado: true,
                metodoChamadoNoClique: () async{
                  String caminhoFoto = await executarComandoJavaScrip(manipuladorDoRepositorio, "document.getElementById('file1').value");
                  if(caminhoFoto.isNotEmpty){
                    observadorSistema.mudarValorDaMudadoraEstadoDoSistema("defindo_foto_perfil");
                    ControladorUsuario().orientarTarefaClicarNaFotoRecentementeSelecionada();
                    executarComandoJavaScrip(manipuladorDoRepositorio, "document.getElementsByTagName('form').item(0).submit();");
                  }else{
                    gerarDialogoComUmaAccaoDeSaida(context, "Primeiro faça a selecção de uma foto!");
                  }
                },
              ),
              SizedBox(
                width: 20,
              ),
              Butao(
                butaoHabilitado: true,
                tituloButao: "Cancelar",
                metodoChamadoNoClique: () {
                  observadorSistema.mudarValorDaMudadoraJanelasDoAplicativo("ir_para_janela_prfil");
                },
              ),
            ],
          ),
        )
      ],
    );
  }

}