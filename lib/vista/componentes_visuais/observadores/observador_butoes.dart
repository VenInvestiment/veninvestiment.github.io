import 'dart:developer';

import 'package:mobx/mobx.dart';
part 'observador_butoes.g.dart';

class ObservadorButoes = _ObservadorButoesBase with _$ObservadorButoes;

abstract class _ObservadorButoesBase with Store {
  @observable
  bool butaoFinalizarCadastroInstituicao = false;
  @observable
  bool butaoInterruptorHabilitado = true;

  @action
  mudarValorFinalizarCadastroInstituicao(List<String> listaValoresFormulario, List<bool> listaValoresFormularioValidados){
    bool contorlador = true;
    listaValoresFormularioValidados.forEach((element) {
      if(element == false){
        contorlador = false;
      }
    });
    listaValoresFormulario.forEach((element) {
      if(element.isEmpty){
        contorlador = false;
      }
    });
    butaoFinalizarCadastroInstituicao = contorlador;
  }

  @action
  mudarValorButaoInterruptorHabilitado(bool novo){
    butaoInterruptorHabilitado = novo;
  }
}