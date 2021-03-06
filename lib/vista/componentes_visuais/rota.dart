import 'package:flutter/material.dart';

class Rota extends MaterialPageRoute<void> {
  Widget janelaParaRota;
  Function metodoChamadoNaSaidaDaRota;
  Rota({this.janelaParaRota, this.metodoChamadoNaSaidaDaRota}): super(builder: (context) {
    return WillPopScope(
      onWillPop: (){
        metodoChamadoNaSaidaDaRota();
        Navigator.pop(context);
      },
      child: janelaParaRota,
    );
  });
}