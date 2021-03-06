import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:oku_sanga/modelos/plano_curricular.dart';
import 'package:oku_sanga/recursos/contantes.dart';
import 'package:oku_sanga/solucoes_uteis/funcionais/provedor_codigo.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:oku_sanga/vista/componentes_visuais/janela_dialogos.dart';
import 'package:oku_sanga/vista/componentes_visuais/sub_app_bar.dart';

class SubJanelaEstudantes extends StatelessWidget {
  NivelNavegacao nivelNavegacao;
  SubJanelaEstudantes({this.nivelNavegacao}) {
    log("$nivelNavegacao - Tamanho da Pilha: ${observadorSistema.pilhaDeniveisNavegacaoEdadoActual.length}");
  }
  @override
  Widget build(BuildContext context) {
    String subTitulo = gerarTextoParaButao(nivelNavegacao).contains("Nova")
        ? gerarTextoParaButao(nivelNavegacao).replaceAll("Nova", "")
        : gerarTextoParaButao(nivelNavegacao).replaceAll("Novo", "");
    return Column(
      children: [
        gerarSubAppBar(context, "Plano Curricular - " + subTitulo + "s"),
        Observer(builder: (_) {
          if (observadorSistema.planoCurricular == null) {
            return LinearProgressIndicator();
          }
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(top: 20),
              child: ListaDadosPlanoCurricular(),
            ),
          );
        }),
      ],
    );
  }

  static String gerarTextoParaButao(NivelNavegacao nivelNavegacao) {
    if (NivelNavegacao.cursos == nivelNavegacao) {
      return "Novo Curso";
    } else if (NivelNavegacao.anos == nivelNavegacao) {
      return "Novo Ano";
    } else if (NivelNavegacao.semestres == nivelNavegacao) {
      return "Novo Semestre";
    } else if (NivelNavegacao.cadeiras == nivelNavegacao) {
      return "Nova Cadeira";
    }
    return "Novo Período";
  }
}

class ListaDadosPlanoCurricular extends StatelessWidget {
  List listaDadosAtomicosAseremExibidos;
  ListaDadosPlanoCurricular({
    Key key,
  }) : super(key: key) {
    listaDadosAtomicosAseremExibidos = definirListaDadosAtomicosAseremExibidos(
        observadorSistema.pilhaDeniveisNavegacaoEdadoActual
            .top()["nivelNavegacao"]);
  }

  @override
  Widget build(BuildContext context) {
    return (listaDadosAtomicosAseremExibidos != null &&
            listaDadosAtomicosAseremExibidos.length != 0)
        ? Column(
            mainAxisSize: MainAxisSize.max,
            children: listaDadosAtomicosAseremExibidos.map((cada) {
              return CadaItemNaLista(
                  cada,
                  observadorSistema.pilhaDeniveisNavegacaoEdadoActual
                      .top()["nivelNavegacao"]);
            }).toList(),
          )
        : Center(
            child: Text("Nenhum dado adicionado"),
          );
  }

  List definirListaDadosAtomicosAseremExibidos(NivelNavegacao nivelNavegacao) {
    if (NivelNavegacao.periodos == nivelNavegacao) {
      return observadorSistema.planoCurricular.periodos;
    } else if (NivelNavegacao.cursos == nivelNavegacao) {
      return Periodos.pegarPeriodoDeNome(observadorSistema
              .pilhaDeniveisNavegacaoEdadoActual
              .top()["criterioNavegacao"])
          .cursos;
    } else if (NivelNavegacao.anos == nivelNavegacao) {
      return (PlanoCurricular.pegarObjectoComBaseCaminhoAteUltimoNivel()
              as Cursos)
          .anos;
    } else if (NivelNavegacao.semestres == nivelNavegacao) {
      return (PlanoCurricular.pegarObjectoComBaseCaminhoAteUltimoNivel()
              as Anos)
          .semestres;
    } else if (NivelNavegacao.cadeiras == nivelNavegacao) {
      return (PlanoCurricular.pegarObjectoComBaseCaminhoAteUltimoNivel()
              as Semestres)
          .cadeiras;
    }
  }
}

class CadaItemNaLista extends StatelessWidget {
  NivelNavegacao nivelNavegacao;
  bool actualizarVista = true;
  var cadaDadoAtomico;
  CadaItemNaLista(this.cadaDadoAtomico, this.nivelNavegacao);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (NivelNavegacao.periodos == nivelNavegacao) {
          observadorSistema.mudarValorNivelNavegacaoActual({
            "nivelNavegacao": NivelNavegacao.cursos,
            "criterioNavegacao":
                definirTextoAserExibidoBaseadoNoTipoDado(cadaDadoAtomico)
          });
        } else if (NivelNavegacao.cursos == nivelNavegacao) {
          observadorSistema.mudarValorNivelNavegacaoActual({
            "nivelNavegacao": NivelNavegacao.anos,
            'criterioNavegacao':
                definirTextoAserExibidoBaseadoNoTipoDado(cadaDadoAtomico)
          });
        } else if (NivelNavegacao.anos == nivelNavegacao) {
          observadorSistema.mudarValorNivelNavegacaoActual({
            "nivelNavegacao": NivelNavegacao.semestres,
            "criterioNavegacao":
                definirTextoAserExibidoBaseadoNoTipoDado(cadaDadoAtomico)
          });
        } else if (NivelNavegacao.semestres == nivelNavegacao) {
          observadorSistema.mudarValorNivelNavegacaoActual({
            "nivelNavegacao": NivelNavegacao.cadeiras,
            "criterioNavegacao":
                definirTextoAserExibidoBaseadoNoTipoDado(cadaDadoAtomico)
          });
        }else if (NivelNavegacao.cadeiras == nivelNavegacao) {
          actualizarVista = false;
          observadorSistema.mudarValorMudadoraSubJanelasDoPainel("ir_para_sub_janela_visualizacao_estudantes");
        }

        if(actualizarVista == true){
          // PARA ACTUALIZAR A VIEW APOS CLICAR NUM ITEM NO NIVEL ACTUAL
          observadorSistema.mudarValorMudadoraSubJanelasDoPainel(
              observadorSistema.mudadoraSubJanelasDoPainel);
        }
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: Card(
          elevation: 8,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          margin: EdgeInsets.all(8),
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: [
                Text(
                    "${definirTextoAserExibidoBaseadoNoTipoDado(cadaDadoAtomico)}"),
                InkWell(
                    onTap: () {
                      gerarDialogoRemoverPlanoCurricular(
                          context,
                          observadorSistema.pilhaDeniveisNavegacaoEdadoActual
                              .top()["nivelNavegacao"],
                          definirTextoAserExibidoBaseadoNoTipoDado(
                              cadaDadoAtomico));
                    },
                    child: Icon(
                      Icons.delete,
                      color: COR_ACCENT,
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}

definirTextoAserExibidoBaseadoNoTipoDado(var dado) {
  if (dado is Periodos) {
    return dado.periodo;
  } else if (dado is Cursos) {
    return dado.curso;
  } else if (dado is Anos) {
    return dado.ano;
  } else if (dado is Semestres) {
    return dado.semestre;
  } else if (dado is Cadeiras) {
    return dado.cadeira;
  }
  return dado;
}

enum NivelNavegacao { periodos, cursos, anos, semestres, cadeiras }
