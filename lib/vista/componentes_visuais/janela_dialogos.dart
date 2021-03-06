import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:oku_sanga/modelos/plano_curricular.dart';
import 'package:oku_sanga/modelos/base_dados_docentes.dart' as base_dados_docentes;
import 'package:oku_sanga/modelos/usuario.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:oku_sanga/recursos/contantes.dart';
import 'package:oku_sanga/repositorio/repositorio.dart';
import 'package:oku_sanga/solucoes_uteis/funcionais/obtencao_conexao_na_net.dart';
import 'package:oku_sanga/solucoes_uteis/funcionais/provedor_codigo.dart';
import 'package:oku_sanga/vista/componentes_visuais/butao.dart';
import 'package:oku_sanga/vista/componentes_visuais/campo_texto.dart';
import 'package:oku_sanga/vista/componentes_visuais/label_erros.dart';
import 'package:oku_sanga/vista/componentes_visuais/menu_drop_down.dart';
import 'package:oku_sanga/vista/componentes_visuais/observadores/observador_butoes.dart';
import 'package:oku_sanga/vista/componentes_visuais/observadores/observador_campo_texto.dart';
import 'package:oku_sanga/vista/componentes_visuais/observadores/validadores/validadcao_campos.dart';
import 'package:oku_sanga/vista/janelas/controladores/controlador_autenticacao.dart';
import 'package:oku_sanga/vista/janelas/controladores/controlador_usuario.dart';
import 'package:oku_sanga/vista/janelas/janela_perfil_usuario.dart';
import 'package:oku_sanga/vista/janelas/tipo_usuario/ensino_superior/sub_janelas_painel/sub_janela_plano_curricular.dart';

import 'layouts/layouts_para_dialogos.dart';

gerarDialogoCarregarRede(
    BuildContext context, String info, bool criterioDeSaidaDoDialogo) {
  showDialog(
      context: context,
      builder: (context) {
        return WillPopScope(
          onWillPop: () {
            if (criterioDeSaidaDoDialogo) {
              Navigator.of(context).pop();
            }
          },
          child: SimpleDialog(
            contentPadding: const EdgeInsets.only(top: 40),
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20, bottom: 20, right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [Text(info), CircularProgressIndicator()],
                ),
              ),
            ],
          ),
        );
      });
}

gerarDialogoComLayoutAseguirParaAdicaoDocentesOuEstudantes(BuildContext context, List<Widget> layout) {
  novoDado = "";
  observadorButoes = ObservadorButoes();
  observadorCampoTexto = ObservadorCampoTexto();
  numeroEstudnte = "";
  showDialog(
      context: context,
      builder: (context) {
        return WillPopScope(
          onWillPop: () {
            Navigator.of(context).pop();
          },
          child: SimpleDialog(
              contentPadding: const EdgeInsets.all(0), children: layout),
        );
      });
}

gerarDialogoComUmaAccaoDeSaida(BuildContext context, String info) {
  showDialog(
      context: context,
      builder: (context) {
        return WillPopScope(
          onWillPop: () {
            observadorSistema.mudarValorJanlaDialogoAberta(false);
            Navigator.of(context).pop();
          },
          child: SimpleDialog(
            contentPadding: const EdgeInsets.only(top: 40),
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  info,
                  textAlign:
                      info.contains("+") ? TextAlign.left : TextAlign.center,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: MaterialButton(
                  color: Colors.blue,
                  onPressed: () {
                    observadorSistema.mudarValorJanlaDialogoAberta(false);
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    "Ok",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              )
            ],
          ),
        );
      });
}

gerarDialogoRepetirAutenticacaoSistema(
    BuildContext context, String info) async {
  showDialog(
      context: context,
      builder: (context) {
        return WillPopScope(
          onWillPop: () {
            observadorSistema.mudarValorJanlaDialogoAberta(false);
            Navigator.of(context).pop();
          },
          child: SimpleDialog(
            contentPadding: const EdgeInsets.only(top: 40),
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  info,
                  textAlign:
                      info.contains("+") ? TextAlign.left : TextAlign.center,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: MaterialButton(
                  color: Colors.blue,
                  onPressed: () async {
                    if (await obeterConexaoInternet()) {
                      observadorSistema.mudarValorDaMudadoraEstadoDoSistema(
                          "autenticando_sistema");
                      await limparTodosDadosCacheDoRepositorio();
                      SystemNavigator.pop();
                    }
                  },
                  child: Text(
                    "Repetir Autenticação",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              )
            ],
          ),
        );
      });
}

gerarDialogoAlterarDado(BuildContext context, String dado,
    TipoDadoEmAlteracao tipoDadoEmAlteracao) async {
  if (tipoDadoEmAlteracao == TipoDadoEmAlteracao.tipoUsuario) {
    ControladorAutenticacao().orientarTarefaBaixarListaTiposUsuario();
  }

  String novoDado = "", valorSeleccionadoMenuDropDown = "";
  ObservadorButoes observadorButoes = ObservadorButoes();
  ObservadorCampoTexto observadorCampoTexto = ObservadorCampoTexto();

  showDialog(
      context: context,
      builder: (context) {
        return WillPopScope(
          onWillPop: () {
            observadorSistema.mudarValorJanlaDialogoAberta(false);
            Navigator.of(context).pop();
          },
          child: SimpleDialog(
            contentPadding: const EdgeInsets.only(top: 40),
            children: [
              Center(
                child: Observer(builder: (_) {
                  return observadorCampoTexto.valorNomeValido == true
                      ? Container()
                      : LabelErros(
                          sms: "Este Nome de Entidade ainda é inválido!",
                        );
                }),
              ),
              tipoDadoEmAlteracao == TipoDadoEmAlteracao.nome
                  ? Padding(
                      padding: const EdgeInsets.all(20),
                      child: CampoTexto(
                        icone: Icon(Icons.text_fields),
                        campoBordado: true,
                        textoPadrao: dado,
                        metodoChamadoNaInsersao: (valor) {
                          novoDado = valor;
                          observadorCampoTexto.observarCampo(
                              novoDado, TipoCampoTexto.nome);
                          if (novoDado.isEmpty) {
                            observadorCampoTexto.mudarValorValido(
                                true, TipoCampoTexto.nome);
                          }
                          observadorButoes
                              .mudarValorFinalizarCadastroInstituicao(
                                  [novoDado],
                                  [observadorCampoTexto.valorNomeValido]);
                        },
                      ),
                    )
                  : Observer(builder: (_) {
                      return observadorSistema.mudadoraEstadoDoSistema is Map &&
                              observadorSistema.mudadoraEstadoDoSistema !=
                                  null &&
                              observadorSistema
                                      .mudadoraEstadoDoSistema["nome"] ==
                                  "mapa_lista_tipos_instituicao"
                          ? Container(
                              margin: EdgeInsets.only(left: 10, right: 10),
                              child: MenuDropDown(
                                metodoChamadoNaInsersao: (valorSeleccionado) {
                                  valorSeleccionadoMenuDropDown =
                                      valorSeleccionado;
                                  observadorButoes
                                      .mudarValorFinalizarCadastroInstituicao(
                                          [valorSeleccionadoMenuDropDown],
                                          [true]);
                                  novoDado = valorSeleccionado;
                                },
                                labelMenuDropDown: dado,
                                listaItens: observadorSistema
                                    .mudadoraEstadoDoSistema["lista"],
                              ),
                            )
                          : observadorSistema
                                  .listaTipoInstituicaoDeReserva.isEmpty
                              ? Container(
                                  width: MediaQuery.of(context).size.width * .5,
                                  child: LinearProgressIndicator())
                              : MenuDropDown(
                                  metodoChamadoNaInsersao: (valorSeleccionado) {
                                    valorSeleccionadoMenuDropDown =
                                        valorSeleccionado;
                                    novoDado = valorSeleccionado;
                                    observadorButoes
                                        .mudarValorFinalizarCadastroInstituicao(
                                            [valorSeleccionadoMenuDropDown],
                                            [true]);
                                  },
                                  labelMenuDropDown: dado,
                                  listaItens: observadorSistema
                                      .listaTipoInstituicaoDeReserva,
                                );
                    }),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Observer(builder: (_) {
                      return Butao(
                        tituloButao: "Salvar",
                        butaoHabilitado:
                            observadorButoes.butaoFinalizarCadastroInstituicao,
                        metodoChamadoNoClique: () {
                          if (tipoDadoEmAlteracao == TipoDadoEmAlteracao.nome) {
                            observadorSistema.usuarioActual.nomeUsuario =
                                novoDado;
                            observadorSistema.mudarValorUsuarioActual(
                                observadorSistema.usuarioActual);
                            observadorSistema
                                .mudarValorDaMudadoraEstadoDoSistema({
                              "nome": "dado_mudado_nome",
                              "novo_dado": novoDado
                            });
                          } else {
                            observadorSistema.usuarioActual.tipoUsuario =
                                novoDado;
                            observadorSistema.mudarValorUsuarioActual(
                                observadorSistema.usuarioActual);
                            observadorSistema
                                .mudarValorDaMudadoraEstadoDoSistema({
                              "nome": "dado_mudado_tipo_usuario",
                              "novo_dado": novoDado
                            });
                          }
                          Navigator.of(context).pop();
                        },
                      );
                    }),
                    SizedBox(
                      width: 20,
                    ),
                    Butao(
                      butaoHabilitado: true,
                      tituloButao: "Cancelar",
                      metodoChamadoNoClique: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              )
            ],
          ),
        );
      });
}

gerarDialogoAdicionarDadoNoPlanoCurricular(BuildContext context, NivelNavegacao nivelNavegacao) async {
  novoDado = "";
  observadorButoes = ObservadorButoes();
  observadorCampoTexto = ObservadorCampoTexto();

  showDialog(
      context: context,
      builder: (context) {
        return WillPopScope(
          onWillPop: () {
            observadorSistema.mudarValorJanlaDialogoAberta(false);
            Navigator.of(context).pop();
          },
          child: SimpleDialog(
            contentPadding: const EdgeInsets.only(top: 40),
            children: [
              Center(
                child: Observer(builder: (_) {
                  return observadorCampoTexto.valorNomeValido == true
                      ? Container()
                      : LabelErros(
                          sms:
                              "${SubJanelaPlanoCurricular.gerarTextoParaButao(nivelNavegacao)} ainda é inválido!",
                        );
                }),
              ),
              definirViewComBaseNivelNavegacao(context, nivelNavegacao),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    (NivelNavegacao.periodos == nivelNavegacao ||
                            NivelNavegacao.anos == nivelNavegacao)
                        ? Container()
                        : Observer(builder: (_) {
                            return Butao(
                              tituloButao: "Adicionar",
                              butaoHabilitado: observadorButoes
                                  .butaoFinalizarCadastroInstituicao,
                              metodoChamadoNoClique: () {
                                if (nivelNavegacao == NivelNavegacao.periodos) {
                                } else if (nivelNavegacao ==
                                    NivelNavegacao.cursos) {
                                  adicionarDadoSeNaoConstaNoPlanoCurricular(
                                      context,
                                      nivelNavegacao,
                                      novoDado,
                                      observadorSistema
                                          .pilhaDeniveisNavegacaoEdadoActual
                                          .top()["criterioNavegacao"]);
                                } else if (nivelNavegacao ==
                                    NivelNavegacao.cadeiras) {
                                  adicionarDadoSeNaoConstaNoPlanoCurricular(
                                      context,
                                      nivelNavegacao,
                                      novoDado + "|" + proximaCadeira,
                                      observadorSistema
                                          .pilhaDeniveisNavegacaoEdadoActual
                                          .top()["criterioNavegacao"]);
                                }
                                // ACTUALIZANDO VIEW DESTA FORMA
                                observadorSistema.mudarValorDaPlanoCurricular(
                                    observadorSistema.planoCurricular);
                              },
                            );
                          }),
                    SizedBox(
                      width: 20,
                    ),
                    Butao(
                      butaoHabilitado: true,
                      tituloButao: "Cancelar",
                      metodoChamadoNoClique: () {
                        novoDado = "";
                        proximaCadeira = "";
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              )
            ],
          ),
        );
      });
}

gerarDialogoAdicionarCadeiraDeDocente(BuildContext context,List<String> listaTitulosItens, NivelNavegacao nivelNavegacao) async {
  showDialog(
      context: context,
      builder: (context) {
        return WillPopScope(
          onWillPop: () {
            observadorSistema.mudarValorJanlaDialogoAberta(false);
            Navigator.of(context).pop();
          },
          child: SimpleDialog(
            contentPadding: EdgeInsets.all(0),
            children: <Widget>[
              Container(width: double.infinity, height: 30,
              color: COR_ACCENT,
              child: Center(child: Text((SubJanelaPlanoCurricular.gerarTextoParaButao(nivelNavegacao).contains("Nova") ? SubJanelaPlanoCurricular.gerarTextoParaButao(nivelNavegacao).replaceAll("Nova", "") : SubJanelaPlanoCurricular.gerarTextoParaButao(nivelNavegacao).replaceAll("Novo", "")) + "s",style: TextStyle(color: COR_BRANCA),)),),
              definirParaAddCadeiraDeDocente(context, listaTitulosItens, nivelNavegacao),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Butao(
                      butaoHabilitado: true,
                      tituloButao: "Cancelar",
                      metodoChamadoNoClique: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              )
            ],
          ),
        );
      });
}

Widget definirParaAddCadeiraDeDocente(BuildContext context,List<String> listaTitulosItens, NivelNavegacao nivelNavegacao){
  return ListaPeriodosAnosOuSemestres(
    agirComoAdderDadoNoPlanoCurricularOuComoAdderCadeiraAdocente: false,
    nivelNavegacao: nivelNavegacao,
    listaTitulosItens: listaTitulosItens,
  );
}


gerarDialogoAddEnderecoOuContacto(
    BuildContext context, TipoDadoEmAdicao tipoDadoEmAdicao) async {
  String novoDado = "", valorSeleccionadoMenuDropDown = "";
  ObservadorButoes observadorButoes = ObservadorButoes();
  showDialog(
      context: context,
      builder: (context) {
        return WillPopScope(
          onWillPop: () {
            observadorSistema.mudarValorJanlaDialogoAberta(false);
            Navigator.of(context).pop();
          },
          child: SimpleDialog(
            contentPadding: const EdgeInsets.only(top: 40),
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: CampoTexto(
                  dicaParaCampo: "Novo " +
                      ((tipoDadoEmAdicao == TipoDadoEmAdicao.contacto)
                          ? "contacto."
                          : "endereço."),
                  icone: ((tipoDadoEmAdicao == TipoDadoEmAdicao.contacto)
                      ? Icon(Icons.phone)
                      : Icon(Icons.location_city)),
                  campoBordado: true,
                  metodoChamadoNaInsersao: (valor) {
                    novoDado = valor;
                    observadorButoes.mudarValorFinalizarCadastroInstituicao(
                        [novoDado], [true]);
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Observer(builder: (_) {
                      return Butao(
                        tituloButao: "Adicionar",
                        butaoHabilitado:
                            observadorButoes.butaoFinalizarCadastroInstituicao,
                        metodoChamadoNoClique: () {
                          if (tipoDadoEmAdicao == TipoDadoEmAdicao.contacto) {
                            observadorSistema.usuarioActual.contactos
                                .add(novoDado);
                            // O FACTO DA VAR USUARIO ACTUAL SER OBSERVAVEL PERMITE ACTUALIZAR A VIEW DESSE  JEITO
                            observadorSistema.mudarValorUsuarioActual(
                                observadorSistema.usuarioActual);
                            observadorSistema
                                .mudarValorDaMudadoraEstadoDoSistema(
                                    {"nome": "dado_adicionado"});
                          } else {
                            observadorSistema.usuarioActual.enderecos
                                .add(novoDado);
                            // O FACTO DA VAR USUARIO ACTUAL SER OBSERVAVEL PERMITE ACTUALIZAR A VIEW DESSE  JEITO
                            observadorSistema.mudarValorUsuarioActual(
                                observadorSistema.usuarioActual);
                            observadorSistema
                                .mudarValorDaMudadoraEstadoDoSistema(
                                    {"nome": "dado_adicionado"});
                          }
                          Navigator.of(context).pop();
                        },
                      );
                    }),
                    SizedBox(
                      width: 20,
                    ),
                    Butao(
                      butaoHabilitado: true,
                      tituloButao: "Cancelar",
                      metodoChamadoNoClique: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              )
            ],
          ),
        );
      });
}

gerarDialogoRemover(BuildContext context, TipoDadoEmRemocao tipoDadoEmRemocao,
    {String emailDocente, base_dados_docentes.Cadeiras cadeira}) async {
  showDialog(
      context: context,
      builder: (context) {
        return WillPopScope(
          onWillPop: () {
            observadorSistema.mudarValorJanlaDialogoAberta(false);
            Navigator.of(context).pop();
          },
          child: SimpleDialog(
            children: [
              Center(
                  child: Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  (tipoDadoEmRemocao == TipoDadoEmRemocao.docente)
                      ? "Deseja mesmo remover este Docente?"
                      : (tipoDadoEmRemocao == TipoDadoEmRemocao.cadeiraDeDocente)
                          ? "Deseja mesmo remover esta Cadeira?"
                          : "Deseja mesmo remover o último item?"
                        ,
                  style: TextStyle(fontSize: 20),
                  textAlign: TextAlign.center,
                ),
              )),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Butao(
                      tituloButao: "Sim",
                      metodoChamadoNoClique: () {
                        if (tipoDadoEmRemocao == TipoDadoEmRemocao.contacto) {
                          observadorSistema.usuarioActual.contactos.removeAt(
                              observadorSistema.usuarioActual.contactos.length -
                                  1);
                          // O FACTO DA VAR USUARIO ACTUAL SER OBSERVAVEL PERMITE ACTUALIZAR A VIEW DESSE  JEITO
                          observadorSistema.mudarValorUsuarioActual(
                              observadorSistema.usuarioActual);
                          observadorSistema.mudarValorDaMudadoraEstadoDoSistema(
                              {"nome": "dado_adicionado"});
                        } else if (tipoDadoEmRemocao ==
                            TipoDadoEmRemocao.endereco) {
                          observadorSistema.usuarioActual.enderecos.removeAt(
                              observadorSistema.usuarioActual.enderecos.length -
                                  1);
                          // O FACTO DA VAR USUARIO ACTUAL SER OBSERVAVEL PERMITE ACTUALIZAR A VIEW DESSE  JEITO
                          observadorSistema.mudarValorUsuarioActual(
                              observadorSistema.usuarioActual);
                          observadorSistema.mudarValorDaMudadoraEstadoDoSistema(
                              {"nome": "dado_adicionado"});
                        } else  if (tipoDadoEmRemocao == TipoDadoEmRemocao.docente){
                          observadorSistema.bancoDadosDocentes.eliminarDocenteNaBaseDados(
                              emailDocente);
                          observadorSistema.mudarValorBancoDadosDocentes(
                              observadorSistema.bancoDadosDocentes);
                          ControladorUsuario()
                              .orientarTarefaActualizarBancoDadosDocentes();
                        } else  if (tipoDadoEmRemocao == TipoDadoEmRemocao.cadeiraDeDocente){
                          observadorSistema.bancoDadosDocentes.eliminarDocenteNaBaseDados(
                              emailDocente);
                          observadorSistema.mudarValorBancoDadosDocentes(
                              observadorSistema.bancoDadosDocentes);
                          ControladorUsuario()
                              .eliminarCadeiraDedocente(cadeira);
                        }
                        Navigator.of(context).pop();
                      },
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Butao(
                      butaoHabilitado: true,
                      tituloButao: "Cancelar",
                      metodoChamadoNoClique: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              )
            ],
          ),
        );
      });
}

gerarDialogoRemoverPlanoCurricular(BuildContext context,
    NivelNavegacao nivelNavegacao, String dadoAserRemovido) async {
  showDialog(
      context: context,
      builder: (context) {
        return WillPopScope(
          onWillPop: () {
            observadorSistema.mudarValorJanlaDialogoAberta(false);
            Navigator.of(context).pop();
          },
          child: SimpleDialog(
            children: [
              Center(
                  child: Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  "Deseja mesmo remover?",
                  style: TextStyle(fontSize: 20),
                  textAlign: TextAlign.center,
                ),
              )),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Butao(
                      tituloButao: "Sim",
                      metodoChamadoNoClique: () {
                        ControladorUsuario()
                            .eliminarDadoNoPlanoCurricularComBaseNivelNavegacao(
                                nivelNavegacao, dadoAserRemovido);
                        Navigator.of(context).pop();
                      },
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Butao(
                      butaoHabilitado: true,
                      tituloButao: "Cancelar",
                      metodoChamadoNoClique: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              )
            ],
          ),
        );
      });
}

gerarDialogoMudarPalavraPasse(BuildContext context) async {
  ObservadorCampoTexto observadorCampoTexto = ObservadorCampoTexto();
  ObservadorCampoTexto observadorCampoTexto2 = ObservadorCampoTexto();
  ObservadorButoes observadorButoes = ObservadorButoes();
  String palavra_passe_antiga = "", palavra_passe_nova = "";

  showDialog(
      context: context,
      builder: (context) {
        return WillPopScope(
          onWillPop: () {
            observadorSistema.mudarValorJanlaDialogoAberta(false);
            Navigator.of(context).pop();
          },
          child: SimpleDialog(
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: CampoTexto(
                  campoBordado: false,
                  icone: Icon(Icons.lock),
                  tipoCampoTexto: TipoCampoTexto.palavra_passe,
                  dicaParaCampo: "Palavra-Passe antiga",
                  metodoChamadoNaInsersao: (String valor) {
                    palavra_passe_antiga = valor;
                    observadorCampoTexto.observarCampoAlteracaoPalavraPasse([
                      palavra_passe_antiga,
                      observadorSistema.usuarioActual.palavraPasse
                    ], TipoCampoTexto.palavra_passe);
                    if (valor.isEmpty) {
                      observadorCampoTexto.mudarValorValido(
                          true, TipoCampoTexto.palavra_passe);
                    }
                    observadorButoes.mudarValorFinalizarCadastroInstituicao([
                      palavra_passe_nova,
                      palavra_passe_antiga
                    ], [
                      observadorCampoTexto.valorPalavraPasseValido,
                      observadorCampoTexto2.valorPalavraPasseValido,
                      (palavra_passe_antiga ==
                          observadorSistema.usuarioActual.palavraPasse)
                    ]);
                  },
                ),
              ),
              Observer(builder: (_) {
                return observadorCampoTexto.valorPalavraPasseValido == true
                    ? Container()
                    : LabelErros(
                        sms:
                            "A palavra-passe deve ter mais de 7 caracteres e ser igual a palavra-passe antiga!",
                      );
              }),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
                child: CampoTexto(
                  campoBordado: false,
                  icone: Icon(Icons.lock),
                  tipoCampoTexto: TipoCampoTexto.palavra_passe,
                  dicaParaCampo: "Nova palavra-passe",
                  metodoChamadoNaInsersao: (String valor) {
                    palavra_passe_nova = valor;
                    observadorCampoTexto2.observarCampo(
                        valor, TipoCampoTexto.palavra_passe);
                    if (valor.isEmpty) {
                      observadorCampoTexto2.mudarValorValido(
                          true, TipoCampoTexto.palavra_passe);
                    }
                    observadorButoes.mudarValorFinalizarCadastroInstituicao([
                      palavra_passe_nova,
                      palavra_passe_antiga
                    ], [
                      observadorCampoTexto.valorPalavraPasseValido,
                      observadorCampoTexto2.valorPalavraPasseValido,
                      (palavra_passe_antiga ==
                          observadorSistema.usuarioActual.palavraPasse)
                    ]);
                  },
                ),
              ),
              Observer(builder: (_) {
                return observadorCampoTexto2.valorPalavraPasseValido == true
                    ? Container()
                    : LabelErros(
                        sms: "A palavra-passe deve ter mais de 7 caracteres!",
                      );
              }),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Observer(builder: (_) {
                      return Butao(
                        butaoHabilitado:
                            observadorButoes.butaoFinalizarCadastroInstituicao,
                        tituloButao: "Alterar",
                        metodoChamadoNoClique: () async {
                          observadorSistema.usuarioActual.palavraPasse =
                              palavra_passe_nova;
                          // O FACTO DA VAR USUARIO ACTUAL SER OBSERVAVEL PERMITE ACTUALIZAR A VIEW DESSE  JEITO
                          observadorSistema.mudarValorUsuarioActual(
                              observadorSistema.usuarioActual);
                          Navigator.of(context).pop();
                        },
                      );
                    }),
                    SizedBox(
                      width: 20,
                    ),
                    Butao(
                      butaoHabilitado: true,
                      tituloButao: "Cancelar",
                      metodoChamadoNoClique: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              )
            ],
          ),
        );
      });
}

gerarDialogoDescartarAlteracoes(BuildContext context) async {
  showDialog(
      context: context,
      builder: (context) {
        return WillPopScope(
          onWillPop: () {
            Navigator.of(context).pop();
          },
          child: SimpleDialog(
            children: [
              Center(
                  child: Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  "Deseja descartar as alterações?",
                  style: TextStyle(fontSize: 20),
                  textAlign: TextAlign.center,
                ),
              )),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Butao(
                      tituloButao: "Descartar",
                      metodoChamadoNoClique: () {
                        observadorSistema.usuarioActual = Usuario.fromJson(
                            json.decode(
                                "${observadorSistema.dadosUsuarioComoJsonEmString}"));
                        observadorSistema
                            .mudarValorDaMudadoraJanelasDoAplicativo(
                                "ir_para_janela_painel");
                        Navigator.of(context).pop();
                      },
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Butao(
                      butaoHabilitado: true,
                      tituloButao: "Salvar",
                      metodoChamadoNoClique: () {
                        Navigator.of(context).pop();
                        observadorSistema.mudarValorDaMudadoraEstadoDoSistema(
                            "actualizando_dados_perfil");
                        ControladorUsuario()
                            .orientarTarefaAlterarInformacoesUsuario();
                      },
                    ),
                  ],
                ),
              )
            ],
          ),
        );
      });
}
