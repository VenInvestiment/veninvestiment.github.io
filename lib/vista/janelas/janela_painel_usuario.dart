import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:oku_sanga/recursos/contantes.dart';
import 'package:oku_sanga/solucoes_uteis/funcionais/provedor_codigo.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:oku_sanga/vista/componentes_visuais/barra_de_baixo_da_app.dart';
import 'package:oku_sanga/vista/componentes_visuais/butao.dart';
import 'package:oku_sanga/vista/componentes_visuais/imagem_rede.dart';
import 'package:oku_sanga/vista/componentes_visuais/janela_dialogos.dart';
import 'package:oku_sanga/vista/componentes_visuais/layouts/layouts_para_dialogos.dart';
import 'package:oku_sanga/vista/componentes_visuais/observadores/observador_sistema.dart';
import 'package:oku_sanga/vista/janelas/tipo_usuario/ensino_superior/ensino_superior.dart';
import 'package:oku_sanga/vista/janelas/tipo_usuario/ensino_superior/sub_janelas_painel/sub_janela_plano_curricular.dart';
import 'package:oku_sanga/vista/janelas/tipo_usuario/ensino_superior/sub_janelas_painel/sub_janela_principal.dart';

import 'controladores/controlador_usuario.dart';

class JanelaPainelUsuario extends StatelessWidget {
  JanelaPainelUsuario() {
    observadorSistema.mudarValorDadosUsuarioComoJsonEmString(json.encode(observadorSistema.usuarioActual.toJson()));

    // COMO A ABERTURA DESSA TELA IMPLICOU O FECHAMENTO DA ULTIMA TELA DE DIALOGO
    observadorSistema.mudarValorJanlaDialogoAberta(false);
  }

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          actions: listaAccoesDaAppBar(),
          title: Observer(builder: (_) {
            return Text(
                "${observadorSistema.usuarioActual.toJson()['nome_usuario'] == null ? 'Painel' : observadorSistema.usuarioActual.toJson()['nome_usuario']}");
          }),
        ),
        drawer: GavetaNavegacao(),
        body: CorpoPainelUsuario(),
        floatingActionButton: definirFabQueVaiSerExibido(context),
        floatingActionButtonLocation: definirLocalizacaoDoFab(),
        bottomNavigationBar: definirSeBarraBaixoAppVaiSerExibida()
      );
    });
  }

  definirSeBarraBaixoAppVaiSerExibida() {
    if (observadorSistema.mudadoraSubJanelasDoPainel is String && observadorSistema.mudadoraSubJanelasDoPainel != "ir_para_sub_janela_principal") {
      return null;
    }
    return BarraBaixoDaApp(shape: CircularNotchedRectangle());
  }

  definirFabQueVaiSerExibido(BuildContext context) {
    if(observadorSistema.mudadoraSubJanelasDoPainel is String && observadorSistema.mudadoraSubJanelasDoPainel == "ir_para_sub_janela_plano_curricular"){
      return ButaoFlutuante(
        tituloButao: definirTituloDoFab(),
        metodoChamadoNoClique: (){
          ControladorUsuario(context: context).verificarPermissaoDeAddDadoNoPlanoCurricular(observadorSistema.pilhaDeniveisNavegacaoEdadoActual.top()["nivelNavegacao"]);
        },
      );
    }else if(observadorSistema.mudadoraSubJanelasDoPainel is String && observadorSistema.mudadoraSubJanelasDoPainel == "ir_para_sub_janela_estudantes"){
      return observadorSistema.pilhaDeniveisNavegacaoEdadoActual.length < 6
      ?
      Container()
      :
      ButaoFlutuante(
        tituloButao: definirTituloDoFab(),
        metodoChamadoNoClique: (){
          ControladorUsuario(context: context).verificarPermissaoDeAddDadoNoPlanoCurricular(observadorSistema.pilhaDeniveisNavegacaoEdadoActual.top()["nivelNavegacao"]);
        },
      );
    }
    if(observadorSistema.mudadoraSubJanelasDoPainel is String && observadorSistema.mudadoraSubJanelasDoPainel == "ir_para_sub_janela_docentes"){
      return ButaoFlutuante(
        tituloButao: definirTituloDoFab(),
        metodoChamadoNoClique: (){
          ControladorUsuario(context: context).exibirDialogoParaAddCadeiraAdocente(context);
        },
      );
    }
    return ButaoFlutuante(
      tituloButao: definirTituloDoFab(),
      metodoChamadoNoClique: (){
        ControladorUsuario().orientarTarefaObterListaUsuariosTipoPessoaIndividual();
        observadorSistema.mudarValorDaMudadoraEstadoDoSistema("indicador_processo_carregando");
        gerarDialogoComLayoutAseguirParaAdicaoDocentesOuEstudantes(context, layoutParaListaPessoasIndividuaisNoDialogo(context));
      },
    );
  }

  definirLocalizacaoDoFab() {
    if (observadorSistema.mudadoraSubJanelasDoPainel is String && observadorSistema.mudadoraSubJanelasDoPainel != "ir_para_sub_janela_principal") {
      return FloatingActionButtonLocation.endFloat;
    }
    return FloatingActionButtonLocation.centerDocked;
  }

  String definirTituloDoFab() {
    if (observadorSistema.mudadoraSubJanelasDoPainel is String && observadorSistema.mudadoraSubJanelasDoPainel == "ir_para_sub_janela_docentes") {
      return "Nova Cadeira";
    }else if (observadorSistema.mudadoraSubJanelasDoPainel is String && observadorSistema.mudadoraSubJanelasDoPainel == "ir_para_sub_janela_estudantes") {
      return "Novo Estudante";
    }else if (observadorSistema.mudadoraSubJanelasDoPainel is String && observadorSistema.mudadoraSubJanelasDoPainel == "ir_para_sub_janela_plano_curricular") {
      return SubJanelaPlanoCurricular.gerarTextoParaButao(observadorSistema.pilhaDeniveisNavegacaoEdadoActual.top()["nivelNavegacao"]);
    }
    return "Adicionar Docente";
  }
}

List<Widget> listaAccoesDaAppBar() {
  return [
    ItemDaAppBar(icone: Icons.book, metodoQuandoItemClicado: () {}),
    SizedBox(
      width: 10,
    ),
    ItemDaAppBar(icone: Icons.school, metodoQuandoItemClicado: () {}),
    SizedBox(
      width: 10,
    ),
  ];
}

class GavetaNavegacao extends StatelessWidget {
  const GavetaNavegacao({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          children: [
            CabecalhoGaveta(),
            Padding(
              padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
              child: Divider(
                color: Colors.pink,
              ),
            ),
            ItemDaGaveta(
                icone: Icons.person,
                titulo: "Perfil",
                metodoQuandoItemClicado: () {
                  observadorSistema.mudarValorDaMudadoraJanelasDoAplicativo(
                      "ir_para_janela_perfil");
                }),
            ItemDaGaveta(
                icone: Icons.book,
                titulo: "Plano Curricular",
                metodoQuandoItemClicado: () {
                  observadorSistema.mudarValorDaMudadoraJanelasDoAplicativo(
                      "ir_para_janela_plano_curricular");
                }),
            ItemDaGaveta(
                icone: Icons.school,
                titulo: "Estudantes",
                metodoQuandoItemClicado: () {
                  observadorSistema.mudarValorDaMudadoraJanelasDoAplicativo(
                      "ir_para_janela_perfil");
                }),
            ItemDaGaveta(
                icone: Icons.logout,
                titulo: "Sair",
                metodoQuandoItemClicado: () {
                  observadorSistema.mudarValorDaMudadoraJanelasDoAplicativo(
                      "ir_para_janela_login");
                  observadorSistema.terminarSessaoUsuario();
                  observadorSistema.limparPilhaElista();
                })
          ],
        ),
      ),
    );
  }
}

class ItemDaGaveta extends StatelessWidget {
  IconData icone;
  String titulo;
  Function metodoQuandoItemClicado;
  ItemDaGaveta({
    this.metodoQuandoItemClicado,
    this.icone,
    this.titulo,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      splashColor: COR_ACCENT.withOpacity(.5),
      padding: EdgeInsets.all(20),
      onPressed: () {
        metodoQuandoItemClicado();
      },
      child: Row(
        children: [
          SizedBox(
            width: 20,
          ),
          Icon(icone),
          SizedBox(
            width: 20,
          ),
          Text("$titulo"),
          SizedBox(
            width: 20,
          )
        ],
      ),
    );
  }
}

class ItemDaAppBar extends StatelessWidget {
  IconData icone;
  Function metodoQuandoItemClicado;
  ItemDaAppBar({
    this.metodoQuandoItemClicado,
    this.icone,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: COR_BRANCA.withOpacity(.5),
      onTap: () {
        metodoQuandoItemClicado();
      },
      child: Icon(
        icone,
        color: COR_BRANCA,
      ),
    );
  }
}

class CabecalhoGaveta extends StatelessWidget {
  const CabecalhoGaveta({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
            margin: EdgeInsets.only(top: 50),
            height: 120,
            width: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.blue,
            ),
            child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(120.0)),
                child: Observer(builder: (_) {
                  return (observadorSistema
                              .usuarioActual.imagemPerfil.isEmpty ||
                          observadorSistema.usuarioActual.imagemPerfil == null)
                      ? Icon(
                          Icons.person,
                          size: 60,
                          color: Colors.white,
                        )
                      : ImagemRede(
                          link_imagem:
                              observadorSistema.usuarioActual.imagemPerfil,
                          altura: 100,
                          largura: 100,
                          alturaErro: 100,
                          larguraErro: 100,
                          tamanhoImogiErro: 15,
                          tamanhoTextoErro: 15,
                        );
                }))),
        Padding(
          padding: const EdgeInsets.all(10),
          child:
              Text(observadorSistema.usuarioActual.toJson()["email_usuario"]),
        )
      ],
    );
  }
}

class CorpoPainelUsuario extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return definirPainelDeAcordoTipoUsuario();
  }

  Widget definirPainelDeAcordoTipoUsuario() {
    if (observadorSistema.usuarioActual.tipoUsuario ==
        "Instituição de Ensino Superior") {
      return PainelEninoSuperior();
    }
    return PainelEninoSuperior();
  }
}
