import 'dart:convert';
import 'dart:developer';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:oku_sanga/recursos/contantes.dart';
import 'package:oku_sanga/repositorio/repositorio.dart';
import 'package:oku_sanga/solucoes_uteis/funcionais/provedor_codigo.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:oku_sanga/vista/componentes_visuais/butao_voltar.dart';
import 'package:oku_sanga/vista/componentes_visuais/imagem_rede.dart';
import 'package:oku_sanga/vista/componentes_visuais/janela_dialogos.dart';
import 'package:oku_sanga/vista/componentes_visuais/campo_texto.dart';
import 'package:oku_sanga/vista/componentes_visuais/butao.dart';
import 'package:oku_sanga/vista/componentes_visuais/observadores/observador_butoes.dart';
import 'package:oku_sanga/vista/janelas/controladores/controlador_usuario.dart';
import 'package:oku_sanga/vista/componentes_visuais/observadores/validadores/validadcao_campos.dart';

class JanelaPerfilUsuario extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Perfil"),
        leading: ButaoVoltarTelaAnterior(
          metodoChamadoNoVlique: () {
            String infoEmFormatoDeMapa =
                json.encode(observadorSistema.usuarioActual.toJson());
            if (infoEmFormatoDeMapa ==
                observadorSistema.dadosUsuarioComoJsonEmString) {
              observadorSistema.mudarValorDaMudadoraJanelasDoAplicativo(
                  "ir_para_janela_painel");
            } else {
              gerarDialogoDescartarAlteracoes(context);
            }
          },
        ),
      ),
      body: CorpoJanelaPerfilUsuario(),
    );
  }
}

class CorpoJanelaPerfilUsuario extends StatelessWidget {
  String dadosUsuarioComoJsonEmString;
  CorpoJanelaPerfilUsuario({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AreaImagemUsuario(),
          AreaInformacoesUsuario([
            {"label_contacto": "Unitel", "contacto": "+244926886839"},
            {"label_contacto": "Movicel", "contacto": "+244916886839"},
          ], [
            "Bairro Fátima",
            "Rua Sagrada Esperança"
          ]),
          AreaSeguranca(),
          Center(
              child: Padding(
            padding: const EdgeInsets.all(20),
            child: AreaSalvacaoAlteracoes(),
          ))
        ],
      ),
    );
  }
}

class AreaImagemUsuario extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Card(
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: 20, left: 20, right: 20),
              height: 120,
              width: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blue,
              ),
              child: Observer(builder: (_) {
                return ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(120.0)),
                  child: (observadorSistema.usuarioActual.imagemPerfil.isEmpty || observadorSistema.usuarioActual.imagemPerfil == null) 
                  ? 
                  Icon(
                    Icons.photo,
                    size: 60,
                    color: Colors.white,
                  )
                  :
                  ImagemRede(
                    link_imagem: observadorSistema.usuarioActual.imagemPerfil,
                    altura: 100,
                    largura: 100,
                    alturaErro: 100,
                    larguraErro: 100,
                    tamanhoImogiErro: 15,
                    tamanhoTextoErro: 15,
                  )
                );
              }),
            ),
            SizedBox(
              height: 10,
            ),
            MaterialButton(
              onPressed: () {
                ControladorUsuario().orientarTarefaAlterarFotoUsuario();
                observadorSistema.mudarValorDaMudadoraJanelasDoAplicativo(
                    "ir_para_janela_mudanca_foto");
              },
              child: Text("Alterar foto de perfil"),
            ),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}

class AreaInformacoesUsuario extends StatelessWidget {
  List<Map> listaContactos;
  List<String> listaEnderecos;
  AreaInformacoesUsuario(this.listaContactos, this.listaEnderecos);
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: EdgeInsets.all(20),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: Text(
                  "Informações gerais",
                  style: TextStyle(color: Colors.white, fontSize: 10),
                ),
              ),
              color: COR_ACCENT,
              width: double.infinity,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Flexible(
                    child: Observer(builder: (_) {
                      return (observadorSistema.mudadoraEstadoDoSistema
                                  is Map &&
                              observadorSistema
                                      .mudadoraEstadoDoSistema["nome"] ==
                                  "dado_mudado_nome")
                          ? Text(
                              "Nome: ${observadorSistema.mudadoraEstadoDoSistema["novo_dado"]}")
                          : Text("Nome: " +
                              '${observadorSistema.usuarioActual.toJson()["nome_usuario"]}');
                    }),
                  ),
                  MaterialButton(
                    onPressed: () {
                      observadorSistema.mudarValorDaMudadoraEstadoDoSistema({
                        "nome": "mudando_dado",
                        "dado": observadorSistema.usuarioActual
                            .toJson()["nome_usuario"],
                        "tipo_dado_em_alteracao": TipoDadoEmAlteracao.nome
                      });
                    },
                    child: Icon(Icons.edit),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Flexible(
                    child: Observer(builder: (_) {
                      return (observadorSistema.mudadoraEstadoDoSistema
                                  is Map &&
                              observadorSistema
                                      .mudadoraEstadoDoSistema["nome"] ==
                                  "dado_mudado_tipo_usuario")
                          ? Text(
                              "Tipo de Entidade: ${observadorSistema.mudadoraEstadoDoSistema["novo_dado"]}")
                          : Text("Tipo de Entidade: " +
                              '${observadorSistema.usuarioActual.toJson()["tipo_usuario"]}');
                    }),
                  ),
                  MaterialButton(
                    onPressed: () {
                      observadorSistema.mudarValorDaMudadoraEstadoDoSistema({
                        "nome": "mudando_dado",
                        "dado": observadorSistema.usuarioActual
                            .toJson()["tipo_usuario"],
                        "tipo_dado_em_alteracao":
                            TipoDadoEmAlteracao.tipoUsuario
                      });
                    },
                    child: Icon(Icons.edit),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
              child: Row(
                children: [
                  Text(
                    "Endereços",
                    style: TextStyle(color: COR_PRIMARIA),
                  ),
                  Container(
                    width: 50,
                    child: MaterialButton(
                      onPressed: () {
                        observadorSistema.mudarValorDaMudadoraEstadoDoSistema({
                          "nome": "adicionando_dado",
                          "tipo_dado_em_adicao": TipoDadoEmAdicao.endereco
                        });
                      },
                      child: Icon(Icons.add),
                    ),
                  ),
                  MaterialButton(
                    onPressed: () {
                      gerarDialogoRemover(context, TipoDadoEmRemocao.endereco);
                    },
                    child: Icon(Icons.remove),
                  )
                ],
              ),
            ),
            Observer(builder: (_) {
              return Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(
                    observadorSistema.usuarioActual
                        .toJson()["enderecos"]
                        .length,
                    (index) => Padding(
                          padding: const EdgeInsets.only(
                              top: 10, left: 10, right: 10),
                          child: Text(
                              "   ${observadorSistema.usuarioActual.toJson()["enderecos"][index]}"),
                        )),
              );
            }),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
              child: Row(
                children: [
                  Text(
                    "Contactos",
                    style: TextStyle(color: COR_PRIMARIA),
                  ),
                  Container(
                    width: 50,
                    child: MaterialButton(
                      onPressed: () {
                        observadorSistema.mudarValorDaMudadoraEstadoDoSistema({
                          "nome": "adicionando_dado",
                          "tipo_dado_em_adicao": TipoDadoEmAdicao.contacto
                        });
                      },
                      child: Icon(Icons.add),
                    ),
                  ),
                  MaterialButton(
                    onPressed: () {
                      gerarDialogoRemover(context, TipoDadoEmRemocao.contacto);
                    },
                    child: Icon(Icons.remove),
                  )
                ],
              ),
            ),
            Observer(builder: (_) {
              return Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(
                    observadorSistema.usuarioActual
                        .toJson()["contactos"]
                        .length,
                    (index) => Padding(
                          padding: const EdgeInsets.only(
                              top: 10, left: 10, right: 10),
                          child: Text(
                              "   ${observadorSistema.usuarioActual.toJson()["contactos"][index]}"),
                        )),
              );
            }),
            SizedBox(
              height: 10,
            ),
          ]),
    );
  }
}

class AreaSeguranca extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Card(
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: EdgeInsets.all(20),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: Text(
                  "Segurança",
                  style: TextStyle(color: Colors.white, fontSize: 10),
                ),
              ),
              color: COR_ACCENT,
              width: double.infinity,
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Observer(builder: (_) {
                  return Container(
                    margin: EdgeInsets.all(20),
                    width: MediaQuery.of(context).size.width * .5,
                    child: CampoTexto(
                      campoNaoEditavel: true,
                      textoPadrao: observadorSistema.usuarioActual.palavraPasse,
                      campoBordado: false,
                      icone: Icon(Icons.lock),
                      tipoCampoTexto: TipoCampoTexto.palavra_passe,
                      dicaParaCampo: "Palavra-Passe",
                      metodoChamadoNaInsersao: (String valor) {},
                    ),
                  );
                }),
                MaterialButton(
                  onPressed: () {
                    gerarDialogoMudarPalavraPasse(context);
                  },
                  child: Icon(Icons.edit),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class AreaSalvacaoAlteracoes extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Butao(
      tituloButao: "Salvar alterações",
      metodoChamadoNoClique: () {
        String infoEmFormatoDeMapa =
            json.encode(observadorSistema.usuarioActual.toJson());
        if (infoEmFormatoDeMapa ==
            observadorSistema.dadosUsuarioComoJsonEmString) {
          gerarDialogoComUmaAccaoDeSaida(context, "Nenhum dado foi alterado!");
        } else {
          observadorSistema
              .mudarValorDaMudadoraEstadoDoSistema("actualizando_dados_perfil");
          ControladorUsuario().orientarTarefaAlterarInformacoesUsuario();
        }
      },
    );
  }
}

enum TipoDadoEmAlteracao { nome, tipoUsuario }
enum TipoDadoEmAdicao { contacto, endereco }
enum TipoDadoEmRemocao { contacto, endereco, docente, cadeiraDeDocente}
