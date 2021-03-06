import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:oku_sanga/solucoes_uteis/funcionais/provedor_codigo.dart';
import 'package:oku_sanga/vista/componentes_visuais/observadores/observador_menu_drop_down.dart';

class MenuDropDown extends StatelessWidget {
  ObservadorMenuDropDown observadorMenuDropDown = ObservadorMenuDropDown();
  Function metodoChamadoNaInsersao;
  String labelMenuDropDown, valorDropdownButtonSeleccionado;
  List<String> listaItens;
  List<DropdownMenuItem<String>> listaDropdownMenuItem;
  MenuDropDown({
    Key key,
    this.labelMenuDropDown,
    this.metodoChamadoNaInsersao,
    this.listaItens,
  }) : super(key: key) {
    if(listaItens.isNotEmpty){
      observadorSistema.mudarValorListaTipoInstituicaoDeReserva(listaItens);
    }
    
    listaDropdownMenuItem = listaItens
        .map((String valor) => DropdownMenuItem<String>(
              value: valor,
              child: Text(valor),
            ))
        .toList();
  }
  @override
  Widget build(BuildContext context) {
    return Observer(builder: (_) {
      return DropdownButton<String>(
        items: listaDropdownMenuItem,
        value: observadorMenuDropDown.valorDropdownButtonSeleccionado,
        hint: Text(labelMenuDropDown),
        onChanged: (novoValor) {
          metodoChamadoNaInsersao(novoValor);
          observadorMenuDropDown.mudarValorItemDropdown(novoValor);
        },
      );
    });
  }
}
