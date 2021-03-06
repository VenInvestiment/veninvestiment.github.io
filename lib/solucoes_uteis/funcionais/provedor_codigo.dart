import 'dart:async';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:oku_sanga/controladores/controlador_servicos_sistema.dart';
import 'package:oku_sanga/recursos/contantes.dart';
import 'package:oku_sanga/repositorio/interface_repositorio.dart';
import 'package:oku_sanga/repositorio/repositorio.dart';
import 'package:oku_sanga/solucoes_uteis/funcionais/algoritmo_exequiveis_no_momento_a_especificar.dart';
import 'package:oku_sanga/solucoes_uteis/funcionais/obtencao_conexao_na_net.dart';
import 'package:oku_sanga/vista/componentes_visuais/janela_dialogos.dart';
import 'package:oku_sanga/vista/componentes_visuais/observadores/observador_sistema.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:oku_sanga/vista/janelas/janela_login.dart';

ObservadorSistema observadorSistema = ObservadorSistema();

class ProvedorCodigo extends StatelessWidget {
  String _titulo;
  BuildContext context;
  ControladorServicosSistema controladorServicosSistema;
  ProvedorCodigo(this._titulo,){
    controladorServicosSistema = ControladorServicosSistema();
  }

  @override
  Widget build(BuildContext context) {
    this.context = context;
    return MultiProvider(
      providers: [
        Provider<Widget>(create: (_) => Container()),
      ],
      child: JanelaLogin()
    );
  }

  int contadorSegundosAutenticacao = 1;
  int contadorEmSegundosTentativasAutenticacao = 1;
  paraExibicaoDialogoAposAutenticacao(){
    Timer.periodic(Duration(seconds: 1), (timer)async{
      if(observadorSistema.loginSistemaFeito == true){
        timer.cancel();
      }
      // if(contadorSegundosAutenticacao == 15){
      //   await manipuladorDoRepositorio.clearCache();
      //   await carregarPaginaDeLink(URL_BASE_SISTEMA);
      //   observadorSistema.mudarValorloginSistemaFeito(false);
      //   observadorSistema.mudarValorDaMudadoraEstadoDoSistema("autenticando_sistema");
      //   await controladorServicosSistema.inciarServicosSistema();
      //   timer.cancel();
      // }
      log("$contadorSegundosAutenticacao");
      contadorSegundosAutenticacao++;
    });
  }
}
