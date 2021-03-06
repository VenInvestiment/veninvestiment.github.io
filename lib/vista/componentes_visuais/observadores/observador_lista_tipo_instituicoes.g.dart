// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'observador_lista_tipo_instituicoes.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$ObservadorListaTipoInstituicoes
    on _ObservadorListaTipoInstituicoesBase, Store {
  final _$listaTipoInstituicoesAtom =
      Atom(name: '_ObservadorListaTipoInstituicoesBase.listaTipoInstituicoes');

  @override
  List<String> get listaTipoInstituicoes {
    _$listaTipoInstituicoesAtom.reportRead();
    return super.listaTipoInstituicoes;
  }

  @override
  set listaTipoInstituicoes(List<String> value) {
    _$listaTipoInstituicoesAtom.reportWrite(value, super.listaTipoInstituicoes,
        () {
      super.listaTipoInstituicoes = value;
    });
  }

  final _$_ObservadorListaTipoInstituicoesBaseActionController =
      ActionController(name: '_ObservadorListaTipoInstituicoesBase');

  @override
  dynamic alterarLista(List<dynamic> novaLista) {
    final _$actionInfo = _$_ObservadorListaTipoInstituicoesBaseActionController
        .startAction(name: '_ObservadorListaTipoInstituicoesBase.alterarLista');
    try {
      return super.alterarLista(novaLista);
    } finally {
      _$_ObservadorListaTipoInstituicoesBaseActionController
          .endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
listaTipoInstituicoes: ${listaTipoInstituicoes}
    ''';
  }
}
