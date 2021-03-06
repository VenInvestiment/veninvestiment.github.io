
import 'package:flutter/material.dart';
import 'package:oku_sanga/recursos/contantes.dart';

class ButaoVoltarTelaAnterior extends StatelessWidget {
  Function metodoChamadoNoVlique;
  ButaoVoltarTelaAnterior({
    Key key,
    this.metodoChamadoNoVlique
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        metodoChamadoNoVlique();
      },
      child: Icon(Icons.arrow_back),
      splashColor: COR_BRANCA,
    );
  }
}