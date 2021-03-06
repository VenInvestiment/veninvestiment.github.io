import 'package:flutter/material.dart';
import 'package:oku_sanga/recursos/contantes.dart';
import 'package:oku_sanga/solucoes_uteis/funcionais/provedor_codigo.dart';
import 'package:oku_sanga/vista/janelas/controladores/controlador_usuario.dart';
import 'package:oku_sanga/vista/janelas/tipo_usuario/ensino_superior/sub_janelas_painel/sub_janela_principal.dart';

import 'janela_dialogos.dart';

class Butao extends StatelessWidget {
  Function metodoChamadoNoClique;
  String tituloButao;
  BuildContext contexto;
  bool butaoHabilitado;
  IconData icone;
  Color corButao;
  bool butaoNaoArredondado = false;

  Butao({
    this.contexto,
    this.corButao,
    this.butaoNaoArredondado,
    this.tituloButao,
    this.icone,
    this.butaoHabilitado,
    this.metodoChamadoNoClique,
  });

  @override
  Widget build(contexto) {
    return Container(
      height: 50,
      child: RaisedButton(
        child: icone == null
            ? Text(
                tituloButao,
                style: TextStyle(color: COR_BRANCA),
              )
            : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
                children: [
                  Text(
                    tituloButao,
                    style: TextStyle(color: COR_BRANCA),
                  ),
                  SizedBox(width:10),
                  Icon(icone, color: COR_BRANCA,)
                ],
              ),
        color: corButao == null ? COR_PRIMARIA : corButao,
        shape: RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(butaoNaoArredondado == false ? 0 : 20),
        ),
        onPressed:
            butaoHabilitado == false ? null : () => metodoChamadoNoClique(),
      ),
    );
  }
}


class ButaoBarraBaixoApp extends StatelessWidget {
  Function metodoChamadoNoClique;
  String tituloButao;
  BuildContext contexto;
  bool butaoHabilitado;
  IconData icone;
  Color corButao;
  bool butaoNaoArredondado = false;

  ButaoBarraBaixoApp({
    this.contexto,
    this.corButao,
    this.butaoNaoArredondado,
    this.tituloButao,
    this.icone,
    this.butaoHabilitado,
    this.metodoChamadoNoClique,
  });

  @override
  Widget build(contexto) {
    return Container(
      height: 50,
      child: FlatButton(
        child: icone == null
            ? Text(
                tituloButao,
                style: TextStyle(color: COR_BRANCA),
              )
            : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
                children: [
                  Icon(icone, color: COR_BRANCA,),
                  Text(
                    tituloButao,
                    style: TextStyle(color: COR_BRANCA, fontSize: 10,)
                  ),                  
                ],
              ),
        color: corButao == null ? COR_PRIMARIA : corButao,
        shape: RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(butaoNaoArredondado == false ? 0 : 20),
        ),
        onPressed:
            butaoHabilitado == false ? null : () => metodoChamadoNoClique(),
      ),
    );
  }
}


class ButaoFlutuante extends StatelessWidget {
  
  Function metodoChamadoNoClique;
  String tituloButao;

  ButaoFlutuante({
    this.metodoChamadoNoClique,
    this.tituloButao,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text("$tituloButao",textAlign: TextAlign.center , style: TextStyle(fontSize: 8, color: COR_ACCENT),),
        FloatingActionButton(
          backgroundColor: COR_BRANCA,
          onPressed: () {
            metodoChamadoNoClique();
          },
          child: Icon(
            Icons.add,
            color: COR_ACCENT,
          ),
        ),
      ],
    );
  }
}