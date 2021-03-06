import 'package:flutter/material.dart';
import 'package:oku_sanga/modelos/plano_curricular.dart';
import 'package:oku_sanga/modelos/plano_curricular.dart' as plano_curricular;
import 'package:oku_sanga/vista/componentes_visuais/janela_dialogos.dart';
import 'package:oku_sanga/modelos/base_dados_docentes.dart';
import 'package:oku_sanga/solucoes_uteis/funcionais/provedor_codigo.dart';
import 'package:oku_sanga/vista/componentes_visuais/campo_texto.dart';
import 'package:oku_sanga/vista/componentes_visuais/indicador_processo_execucao.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:oku_sanga/vista/componentes_visuais/observadores/observador_butoes.dart';
import 'package:oku_sanga/vista/componentes_visuais/observadores/observador_campo_texto.dart';
import 'package:oku_sanga/vista/componentes_visuais/observadores/validadores/validadcao_campos.dart';
import 'package:oku_sanga/vista/janelas/controladores/controlador_usuario.dart';
import 'package:oku_sanga/vista/janelas/tipo_usuario/ensino_superior/sub_janelas_painel/sub_janela_plano_curricular.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../butao.dart';
import '../label_erros.dart';

List<Widget> layoutParaListaPessoasIndividuaisNoDialogo(BuildContext context) {
  return [
    IndicadorProcessoEmExecucao(),
    Padding(
      padding: const EdgeInsets.all(20),
      child: Text("Seleccione o novo docente:"),
    ),
    Container(
        margin: EdgeInsets.only(bottom: 20, left: 20, right: 20, top: 0),
        height: MediaQuery.of(context).size.height * 0.6,
        width: MediaQuery.of(context).size.width * 0.8,
        child: Observer(builder: (_) {
          return observadorSistema.mudadoraEstadoDoSistema.length == 0
              ? Center(
                  child: Text(
                    "Nenhum docente disponível!\nOBS: Nesta lista não constará docentes presentes em sua Base de Dados!",
                    textAlign: TextAlign.center,
                  ),
                )
              : ListView(
                  children: List.generate(
                      ((observadorSistema.mudadoraEstadoDoSistema
                                  is List<Docentes>) &&
                              observadorSistema.mudadoraEstadoDoSistema != null)
                          ? observadorSistema.mudadoraEstadoDoSistema.length
                          : 0,
                      (index) => GestureDetector(
                            onTap: () {
                              observadorSistema.bancoDadosDocentes.docentes.add(
                                  observadorSistema
                                      .mudadoraEstadoDoSistema[index]);
                              observadorSistema.mudarValorBancoDadosDocentes(
                                  observadorSistema.bancoDadosDocentes);

                              ControladorUsuario()
                                  .orientarTarefaActualizarBancoDadosDocentes();
                              Navigator.of(context).pop();
                            },
                            child: Card(
                              elevation: 8,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                              margin: EdgeInsets.all(8),
                              child: Padding(
                                padding: const EdgeInsets.all(15),
                                child: Text(
                                    "${observadorSistema.mudadoraEstadoDoSistema[index].nomeDocente}"),
                              ),
                            ),
                          )),
                );
        }))
  ];
}

List<Widget> layoutParaAddEstudante(BuildContext context) {
  return [
    Center(
      child: Observer(builder: (_) {
        return observadorCampoTexto.valorNomeValido == true
            ? Container()
            : LabelErros(
                sms: "Este Nome de Entidade ainda é inválido!",
              );
      }),
    ),
    Padding(
      padding: const EdgeInsets.all(20),
      child: CampoTexto(
        dicaParaCampo: "Nome do Estudante",
        icone: Icon(Icons.text_fields),
        campoBordado: true,
        metodoChamadoNaInsersao: (valor) {
          novoDado = valor;
          observadorCampoTexto.observarCampo(novoDado, TipoCampoTexto.nome);
          if (novoDado.isEmpty) {
            observadorCampoTexto.mudarValorValido(true, TipoCampoTexto.nome);
          }
          observadorButoes.mudarValorFinalizarCadastroInstituicao(
              [novoDado], [observadorCampoTexto.valorNomeValido]);
        },
      ),
    ),
    Padding(
      padding: const EdgeInsets.all(20),
      child: CampoTexto(
        dicaParaCampo: "Número de Estudante",
        icone: Icon(Icons.text_fields),
        campoBordado: true,
        metodoChamadoNaInsersao: (valor) {
          novoDado = valor;
          observadorCampoTexto.observarCampo(novoDado, TipoCampoTexto.nome);
          if (novoDado.isEmpty) {
            observadorCampoTexto.mudarValorValido(true, TipoCampoTexto.nome);
          }
          observadorButoes.mudarValorFinalizarCadastroInstituicao(
              [novoDado], [observadorCampoTexto.valorNomeValido]);
        },
      ),
    ),
    Observer(builder: (_) {
      return Padding(
        padding: const EdgeInsets.all(20),
        child: Butao(
          tituloButao: "Salvar",
          butaoHabilitado: observadorButoes.butaoFinalizarCadastroInstituicao,
          metodoChamadoNoClique: () {
            Navigator.of(context).pop();
          },
        ),
      );
    }),
  ];
}

String novoDado = "", numeroEstudnte = "", proximaCadeira = "";
ObservadorButoes observadorButoes;
ObservadorCampoTexto observadorCampoTexto;

Widget definirViewComBaseNivelNavegacao(
    BuildContext context, NivelNavegacao nivelNavegacao) {
  if (nivelNavegacao == NivelNavegacao.cursos) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: CampoTexto(
        dicaParaCampo: SubJanelaPlanoCurricular.gerarTextoParaButao(nivelNavegacao),
        icone: Icon(Icons.text_fields),
        campoBordado: true,
        metodoChamadoNaInsersao: (valor) {
          novoDado = valor;
          observadorCampoTexto.observarCampo(novoDado, TipoCampoTexto.nome);
          if (novoDado.isEmpty) {
            observadorCampoTexto.mudarValorValido(true, TipoCampoTexto.nome);
          }
          observadorButoes.mudarValorFinalizarCadastroInstituicao(
              [novoDado], [observadorCampoTexto.valorNomeValido]);
        },
      ),
    );
  } else if (nivelNavegacao == NivelNavegacao.anos) {
    return ListaPeriodosAnosOuSemestres(
      agirComoAdderDadoNoPlanoCurricularOuComoAdderCadeiraAdocente: true,
      nivelNavegacao: nivelNavegacao,
      listaTitulosItens: [
        "1* Ano",
        "2* Ano",
        "3* Ano",
        "4* Ano",
        "5* Ano",
        "6* Ano"
      ],
    );
  } else if (nivelNavegacao == NivelNavegacao.semestres) {
    return ListaPeriodosAnosOuSemestres(
      agirComoAdderDadoNoPlanoCurricularOuComoAdderCadeiraAdocente: true,
      nivelNavegacao: nivelNavegacao,
      listaTitulosItens: ["1* Semestre", "2* Semestre"],
    );
  } else if (nivelNavegacao == NivelNavegacao.cadeiras) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          CampoTexto(
            dicaParaCampo:
                SubJanelaPlanoCurricular.gerarTextoParaButao(nivelNavegacao),
            icone: Icon(Icons.text_fields),
            campoBordado: true,
            metodoChamadoNaInsersao: (valor) {
              novoDado = valor;
              observadorCampoTexto.observarCampo(novoDado, TipoCampoTexto.nome);
              if (novoDado.isEmpty) {
                observadorCampoTexto.mudarValorValido(
                    true, TipoCampoTexto.nome);
              }
              observadorButoes.mudarValorFinalizarCadastroInstituicao(
                  [novoDado, proximaCadeira],
                  [observadorCampoTexto.valorNomeValido]);
            },
          ),
          Row(
            children: [
              Observer(builder: (_) {
                return Switch(
                    value: observadorButoes.butaoInterruptorHabilitado,
                    onChanged: (v) {
                      if (v == false) {
                        proximaCadeira = "sem_proxima_cadeira";
                        observadorButoes.mudarValorFinalizarCadastroInstituicao(
                            [novoDado, "SoParaHabilitarButao"],
                            [observadorCampoTexto.valorNomeValido]);
                      } else {
                        proximaCadeira = "";
                        observadorButoes.mudarValorFinalizarCadastroInstituicao(
                            [novoDado, proximaCadeira],
                            [observadorCampoTexto.valorNomeValido]);
                      }
                      observadorButoes.mudarValorButaoInterruptorHabilitado(v);
                    });
              }),
              Text("Possui Cadeira sucessora?")
            ],
          ),
          Observer(builder: (_) {
            return CampoTexto(
              textoPadrao: observadorButoes.butaoInterruptorHabilitado
                  ? null
                  : "Sem Cadeira sucessora",
              campoNaoEditavel: !observadorButoes.butaoInterruptorHabilitado,
              dicaParaCampo: "Cadeira Sucessora",
              icone: Icon(Icons.text_fields),
              campoBordado: true,
              metodoChamadoNaInsersao: (valor) {
                proximaCadeira = valor;
                observadorCampoTexto.observarCampo(
                    proximaCadeira, TipoCampoTexto.nome);
                if (proximaCadeira.isEmpty) {
                  observadorCampoTexto.mudarValorValido(
                      true, TipoCampoTexto.nome);
                }
                observadorButoes.mudarValorFinalizarCadastroInstituicao(
                    [novoDado, proximaCadeira],
                    [observadorCampoTexto.valorNomeValido]);
              },
            );
          }),
        ],
      ),
    );
  }
  return ListaPeriodosAnosOuSemestres(
    agirComoAdderDadoNoPlanoCurricularOuComoAdderCadeiraAdocente: true,
    nivelNavegacao: nivelNavegacao,
    listaTitulosItens: ["Período Regular", "Período Pós-Laboral"],
  );
}

class ListaPeriodosAnosOuSemestres extends StatelessWidget {
  NivelNavegacao nivelNavegacao;
  bool agirComoAdderDadoNoPlanoCurricularOuComoAdderCadeiraAdocente;
  List<String> listaTitulosItens;
  ListaPeriodosAnosOuSemestres({
    @required this.agirComoAdderDadoNoPlanoCurricularOuComoAdderCadeiraAdocente,
    this.listaTitulosItens,
    this.nivelNavegacao,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: listaTitulosItens
            .map((e) => CadaItemNaListaPeriodosAnosOuSemestres(
                agirComoAdderDadoNoPlanoCurricularOuComoAdderCadeiraAdocente:
                    agirComoAdderDadoNoPlanoCurricularOuComoAdderCadeiraAdocente,
                nivelNavegacao: nivelNavegacao,
                tituloItem: e))
            .toList(),
      ),
    );
  }
}

class CadaItemNaListaPeriodosAnosOuSemestres extends StatelessWidget {
  CadaItemNaListaPeriodosAnosOuSemestres({
    Key key,
    @required this.agirComoAdderDadoNoPlanoCurricularOuComoAdderCadeiraAdocente,
    @required this.nivelNavegacao,
    @required this.tituloItem,
  }) : super(key: key);

  final NivelNavegacao nivelNavegacao;
  final bool agirComoAdderDadoNoPlanoCurricularOuComoAdderCadeiraAdocente;
  String tituloItem;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (agirComoAdderDadoNoPlanoCurricularOuComoAdderCadeiraAdocente ==
            true) {
          adicionarDadoSeNaoConstaNoPlanoCurricular(
              context,
              nivelNavegacao,
              tituloItem.contains("|") ? tituloItem.split("|")[0] : tituloItem,
              observadorSistema.pilhaDeniveisNavegacaoEdadoActual
                  .top()["criterioNavegacao"]);
        } else {
          if (NivelNavegacao.periodos == nivelNavegacao) {
            // ESTA CHAMADA E FEITA APENAS PARA EMPILHAR E ELISTAR O CRITERIO DE PESQUISA Q SERA USADO
            // NA PROXIMA PESQUISA
            observadorSistema.mudarValorNivelNavegacaoActual({
              "nivelNavegacao": NivelNavegacao.cursos,
              "criterioNavegacao":
                  definirTextoAserExibidoBaseadoNoTipoDado(tituloItem)
            });
            Navigator.of(context).pop();
            if ((PlanoCurricular.pegarObjectoComBaseCaminhoAteUltimoNivel()
                        as Periodos)
                    .cursos !=
                null) {
              gerarDialogoAdicionarCadeiraDeDocente(
                  context,
                  (PlanoCurricular.pegarObjectoComBaseCaminhoAteUltimoNivel()
                          as Periodos)
                      .cursos
                      .map((e) => "${e.curso}")
                      .toList(),
                  NivelNavegacao.cursos);
            } else {
              Fluttertoast.showToast(
                  msg: "Este Período anida não possui Cursos!",
                  toastLength: Toast.LENGTH_LONG);
            }
          } else if (NivelNavegacao.cursos == nivelNavegacao) {
            // ESTA CHAMADA E FEITA APENAS PARA EMPILHAR E ELISTAR O CRITERIO DE PESQUISA Q SERA USADO
            // NA PROXIMA PESQUISA
            observadorSistema.mudarValorNivelNavegacaoActual({
              "nivelNavegacao": NivelNavegacao.cursos,
              "criterioNavegacao":
                  definirTextoAserExibidoBaseadoNoTipoDado(tituloItem)
            });
            Navigator.of(context).pop();
            if ((PlanoCurricular.pegarObjectoComBaseCaminhoAteUltimoNivel()
                        as Cursos)
                    .anos !=
                null) {
              gerarDialogoAdicionarCadeiraDeDocente(
                  context,
                  (PlanoCurricular.pegarObjectoComBaseCaminhoAteUltimoNivel()
                          as Cursos)
                      .anos
                      .map((e) => "${e.ano}")
                      .toList(),
                  NivelNavegacao.anos);
            } else {
              Fluttertoast.showToast(
                  msg: "Este Curso anida não possui Anos!",
                  toastLength: Toast.LENGTH_LONG);
            }
          } else if (NivelNavegacao.anos == nivelNavegacao) {
            // ESTA CHAMADA E FEITA APENAS PARA EMPILHAR E ELISTAR O CRITERIO DE PESQUISA Q SERA USADO
            // NA PROXIMA PESQUISA
            observadorSistema.mudarValorNivelNavegacaoActual({
              "nivelNavegacao": NivelNavegacao.cursos,
              "criterioNavegacao":
                  definirTextoAserExibidoBaseadoNoTipoDado(tituloItem)
            });
            Navigator.of(context).pop();
            if ((PlanoCurricular.pegarObjectoComBaseCaminhoAteUltimoNivel()
                        as Anos)
                    .semestres !=
                null) {
              gerarDialogoAdicionarCadeiraDeDocente(
                  context,
                  (PlanoCurricular.pegarObjectoComBaseCaminhoAteUltimoNivel()
                          as Anos)
                      .semestres
                      .map((e) => "${e.semestre}")
                      .toList(),
                  NivelNavegacao.semestres);
            } else {
              Fluttertoast.showToast(
                  msg: "Este Ano anida não possui Semestres!",
                  toastLength: Toast.LENGTH_LONG);
            }
          } else if (NivelNavegacao.semestres == nivelNavegacao) {
            // ESTA CHAMADA E FEITA APENAS PARA EMPILHAR E ELISTAR O CRITERIO DE PESQUISA Q SERA USADO
            // NA PROXIMA PESQUISA
            observadorSistema.mudarValorNivelNavegacaoActual({
              "nivelNavegacao": NivelNavegacao.cursos,
              "criterioNavegacao":
                  definirTextoAserExibidoBaseadoNoTipoDado(tituloItem)
            });
            Navigator.of(context).pop();
            if ((PlanoCurricular.pegarObjectoComBaseCaminhoAteUltimoNivel()
                        as Semestres)
                    .cadeiras !=
                null) {
              gerarDialogoAdicionarCadeiraDeDocente(
                  context,
                  (PlanoCurricular.pegarObjectoComBaseCaminhoAteUltimoNivel()
                          as Semestres)
                      .cadeiras
                      .map((e) => "${e.cadeira}|${e.proximaCadeira}")
                      .toList(),
                  NivelNavegacao.cadeiras);
            } else {
              Fluttertoast.showToast(
                  msg: "Este Semestre anida não possui Cadeiras!",
                  toastLength: Toast.LENGTH_LONG);
            }
          } else if (NivelNavegacao.cadeiras == nivelNavegacao) {
            ControladorUsuario(context: context).addCadeiraAdocente(tituloItem);
          }
        }
      },
      child: Container(
        width: MediaQuery.of(context).size.width * 0.6,
        child: Card(
          elevation: 8,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          margin: EdgeInsets.all(8),
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Text(
                "${tituloItem.contains("|") ? tituloItem.split("|")[0] : tituloItem}"),
          ),
        ),
      ),
    );
  }
}

void adicionarDadoSeNaoConstaNoPlanoCurricular(
    BuildContext context,
    NivelNavegacao nivelNavegacao,
    String dadoAsalvar,
    String criterioNavegacao) {
  if (!verificarExistenciaPeriodoComBaseTipoDadoEmAdicao(
      nivelNavegacao, dadoAsalvar)) {
    if (NivelNavegacao.periodos == nivelNavegacao) {
      if (observadorSistema.planoCurricular.periodos == null) {
        observadorSistema.planoCurricular.periodos = [];
      }
      observadorSistema.planoCurricular.periodos
          .add(Periodos(periodo: dadoAsalvar));
    } else if (NivelNavegacao.cursos == nivelNavegacao) {
      if ((PlanoCurricular.pegarObjectoComBaseCaminhoAteUltimoNivel()
                  as Periodos)
              .cursos !=
          null) {
        (PlanoCurricular.pegarObjectoComBaseCaminhoAteUltimoNivel() as Periodos)
            .cursos
            .add(Cursos(curso: dadoAsalvar));
      } else {
        (PlanoCurricular.pegarObjectoComBaseCaminhoAteUltimoNivel() as Periodos)
            .cursos = [];
        (PlanoCurricular.pegarObjectoComBaseCaminhoAteUltimoNivel() as Periodos)
            .cursos
            .add(Cursos(curso: dadoAsalvar));
      }
    } else if (NivelNavegacao.anos == nivelNavegacao) {
      if ((PlanoCurricular.pegarObjectoComBaseCaminhoAteUltimoNivel() as Cursos)
              .anos !=
          null) {
        (PlanoCurricular.pegarObjectoComBaseCaminhoAteUltimoNivel() as Cursos)
            .anos
            .add(Anos(ano: dadoAsalvar));
      } else {
        (PlanoCurricular.pegarObjectoComBaseCaminhoAteUltimoNivel() as Cursos)
            .anos = [];
        (PlanoCurricular.pegarObjectoComBaseCaminhoAteUltimoNivel() as Cursos)
            .anos
            .add(Anos(ano: dadoAsalvar));
      }
    } else if (NivelNavegacao.semestres == nivelNavegacao) {
      if ((PlanoCurricular.pegarObjectoComBaseCaminhoAteUltimoNivel() as Anos)
              .semestres !=
          null) {
        (PlanoCurricular.pegarObjectoComBaseCaminhoAteUltimoNivel() as Anos)
            .semestres
            .add(Semestres(semestre: dadoAsalvar));
      } else {
        (PlanoCurricular.pegarObjectoComBaseCaminhoAteUltimoNivel() as Anos)
            .semestres = [];
        (PlanoCurricular.pegarObjectoComBaseCaminhoAteUltimoNivel() as Anos)
            .semestres
            .add(Semestres(semestre: dadoAsalvar));
      }
    } else if (NivelNavegacao.cadeiras == nivelNavegacao) {
      if ((PlanoCurricular.pegarObjectoComBaseCaminhoAteUltimoNivel()
                  as Semestres)
              .cadeiras !=
          null) {
        (PlanoCurricular.pegarObjectoComBaseCaminhoAteUltimoNivel()
                as Semestres)
            .cadeiras
            .add(plano_curricular.Cadeiras(
                cadeira: dadoAsalvar.split("|")[0],
                proximaCadeira: dadoAsalvar.split("|")[1]));
      } else {
        (PlanoCurricular.pegarObjectoComBaseCaminhoAteUltimoNivel()
                as Semestres)
            .cadeiras = [];
        (PlanoCurricular.pegarObjectoComBaseCaminhoAteUltimoNivel()
                as Semestres)
            .cadeiras
            .add(plano_curricular.Cadeiras(
                cadeira: dadoAsalvar.split("|")[0],
                proximaCadeira: dadoAsalvar.split("|")[1]));
      }
    }
    ControladorUsuario().orientarTarefaActualizarPlanoCurricular();
  } else {
    Fluttertoast.showToast(msg: "Dado já existente!");
  }
  // ACTUALIZANDO VIEW DESTA FORMA
  observadorSistema
      .mudarValorDaPlanoCurricular(observadorSistema.planoCurricular);
  Navigator.of(context).pop();
}

verificarExistenciaPeriodoComBaseTipoDadoEmAdicao(
    NivelNavegacao nivelNavegacao, String dado) {
  if (NivelNavegacao.periodos == nivelNavegacao) {
    return Periodos.verificarExistenciaPeriodo(dado);
  } else if (NivelNavegacao.cursos == nivelNavegacao) {
    return Cursos.verificarExistenciaCurso(
        dado,
        observadorSistema.pilhaDeniveisNavegacaoEdadoActual
            .top()["criterioNavegacao"]);
  } else if (NivelNavegacao.anos == nivelNavegacao) {
    return Anos.verificarExistenciaAno(dado);
  } else if (NivelNavegacao.semestres == nivelNavegacao) {
    return Semestres.verificarExistenciaSemestre(dado);
  } else if (NivelNavegacao.cadeiras == nivelNavegacao) {
    return plano_curricular.Cadeiras.verificarExistenciaCadeira(dado);
  }
}
