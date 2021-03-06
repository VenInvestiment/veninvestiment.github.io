import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:oku_sanga/controladores/controlador_servicos_sistema.dart';
import 'package:oku_sanga/recursos/contantes.dart';
import 'package:oku_sanga/repositorio/interface_repositorio.dart';
import 'package:oku_sanga/repositorio/repositorio.dart';
import 'package:oku_sanga/solucoes_uteis/funcionais/algoritmo_exequiveis_no_momento_a_especificar.dart';
import 'package:oku_sanga/solucoes_uteis/funcionais/obtencao_conexao_na_net.dart';
import 'package:oku_sanga/solucoes_uteis/funcionais/provedor_codigo.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:oku_sanga/vista/componentes_visuais/observadores/observador_sistema.dart';
import 'package:oku_sanga/vista/componentes_visuais/widget_observador_sistema.dart';
import 'package:oku_sanga/vista/janelas/janela_cadastro.dart';
import 'package:oku_sanga/vista/janelas/janela_login.dart';
import 'package:oku_sanga/vista/janelas/janela_mudanca_foto.dart';
import 'package:oku_sanga/vista/janelas/janela_painel_usuario.dart';
import 'package:oku_sanga/vista/janelas/janela_perfil_usuario.dart';

class Aplicacao extends StatelessWidget {
  String _titulo;
  BuildContext context;
  ControladorServicosSistema controladorServicosSistema;
  Aplicacao(this._titulo) {
    observadorSistema
        .mudarValorDaMudadoraJanelasDoAplicativo("ir_para_janela_login");
    iniciarServicosSistema();
  }

  iniciarServicosSistema() async {
    await executarRepositorioSegundoPlano();
    observadorSistema
        .mudarValorAccaoDoRepositorio(AccaoDoRepositorio.autenticacaoSistema);
    observadorSistema
        .mudarValorDaMudadoraEstadoDoSistema("autenticando_sistema");
    if (await obeterConexaoInternet() == true) {
      controladorServicosSistema = ControladorServicosSistema();
      executarMetodoNoInstanteDeTempo(10, () async {
        await controladorServicosSistema.inciarServicosSistema();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    this.context = context;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: _titulo,
      theme: ThemeData(
        accentColor: COR_ACCENT,
        focusColor: COR_ACCENT,
        cursorColor: COR_ACCENT,
        hoverColor: COR_ACCENT,
        primaryColor: COR_PRIMARIA,
      ),
      home: Container(
        child: Stack(
          alignment: Alignment.centerLeft,
          children: [
            WidgetObservadorSistema(),
            repositorio,
            Observer(builder: (_) {
              print(observadorSistema.ignorarAccoesNaViewDoUsuario);
              return IgnorePointer(
                ignoring: observadorSistema.ignorarAccoesNaViewDoUsuario,
                child: Opacity(
                  opacity: 1,
                  child: Observer(builder: (_) {
                    return definirJanelaAserExibida(
                        observadorSistema.mudadoraJanelasDoAplicativo);
                  }),
                )
              );
            })
          ],
        ),
      ),
    );
  }

  Widget definirJanelaAserExibida(dynamic mudadoraJanelasDoAplicativo) {
    if (mudadoraJanelasDoAplicativo is String &&
        mudadoraJanelasDoAplicativo == "ir_para_janela_login") {
      return JanelaLogin();
    }
    if (mudadoraJanelasDoAplicativo is String &&
        mudadoraJanelasDoAplicativo == "ir_para_janela_cadastro") {
      return JanelaCadastro();
    }
    if (mudadoraJanelasDoAplicativo is String &&
        mudadoraJanelasDoAplicativo == "ir_para_janela_painel") {
      return JanelaPainelUsuario();
    }
    if (mudadoraJanelasDoAplicativo is String &&
        mudadoraJanelasDoAplicativo == "ir_para_janela_perfil") {
      return JanelaPerfilUsuario();
    }
    if (mudadoraJanelasDoAplicativo is String &&
        mudadoraJanelasDoAplicativo == "ir_para_janela_mudanca_foto") {
      return JanelaMudancaFoto();
    }
  }
}
