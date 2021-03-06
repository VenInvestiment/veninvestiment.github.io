import 'package:flutter/widgets.dart';
import 'package:mobx/mobx.dart';
part 'observador_lista_tipo_instituicoes.g.dart';

class ObservadorListaTipoInstituicoes = _ObservadorListaTipoInstituicoesBase with _$ObservadorListaTipoInstituicoes;

abstract class _ObservadorListaTipoInstituicoesBase with Store {

  @observable
  List<String> listaTipoInstituicoes;

  @action
  alterarLista(List novaLista){
    listaTipoInstituicoes = novaLista;
  }
  
}