import 'package:flutter/material.dart';
import 'package:oku_sanga/recursos/contantes.dart';
import 'package:oku_sanga/vista/componentes_visuais/observadores/validadores/validadcao_campos.dart';

class CampoTexto extends StatelessWidget {
  
  Function metodoChamadoNaInsersao;
  String dicaParaCampo;
  String textoPadrao;
  String dicaParaErroNoCampo;
  TipoCampoTexto tipoCampoTexto;
  bool campoBordado = false;
  bool campoNaoEditavel = false;
  Icon icone;
  CampoTexto({
    Key key,
    this.icone,
    this.campoNaoEditavel,
    this.tipoCampoTexto,
    this.campoBordado,
    this.metodoChamadoNaInsersao,
    this.dicaParaCampo,
    this.dicaParaErroNoCampo,
    this.textoPadrao
  });
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        primaryColor: COR_ACCENT,
      ),
      child: Container(
        height: 50,
        decoration: campoBordado == false ? BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          color: Colors.pink.withOpacity(0.1),
        ) : BoxDecoration(),
        child: TextFormField(
          readOnly: campoNaoEditavel == true ? true : false,
          controller: TextEditingController(text: textoPadrao == null ? "" : "$textoPadrao"),
          obscureText: tipoCampoTexto == TipoCampoTexto.palavra_passe,
          decoration: InputDecoration(
            errorStyle: TextStyle(
              fontSize: 12
            ),
            icon: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: icone,
            ),
            errorText: dicaParaErroNoCampo,
            hintText: dicaParaCampo,
            border: campoBordado == false ? InputBorder.none : OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
            contentPadding: campoBordado == false ? EdgeInsets.symmetric(horizontal: -10) : EdgeInsets.symmetric(horizontal: 10) 
          ),
          onChanged: (valor) {
            metodoChamadoNaInsersao(valor);
          },
        ),
      ),
    );
  }
}
