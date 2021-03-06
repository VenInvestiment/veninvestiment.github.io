import 'package:flutter/material.dart';
import 'package:oku_sanga/solucoes_uteis/funcionais/provedor_codigo.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class IndicadorProcessoEmExecucao extends StatelessWidget {
  const IndicadorProcessoEmExecucao({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (_) {
      if (observadorSistema.mudadoraEstadoDoSistema is String &&
          observadorSistema.mudadoraEstadoDoSistema ==
              "indicador_processo_carregando") {
        return LinearProgressIndicator();
      } else {
        return Container();
      }
    });
  }
}