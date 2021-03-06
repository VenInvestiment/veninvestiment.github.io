import 'package:flutter/material.dart';

class LogoNoCirculo extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      height: MediaQuery.of(context).size.width*0.6,
      width: MediaQuery.of(context).size.width*0.6,
      child: CircleAvatar(
        child: Image.asset(
          "lib/recursos/imagens/icones/logo.png",
        ),
        backgroundColor: Colors.pink.withOpacity(0.1),
      )
    );
  }

}