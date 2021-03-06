// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'observador_butoes.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$ObservadorButoes on _ObservadorButoesBase, Store {
  final _$butaoFinalizarCadastroInstituicaoAtom =
      Atom(name: '_ObservadorButoesBase.butaoFinalizarCadastroInstituicao');

  @override
  bool get butaoFinalizarCadastroInstituicao {
    _$butaoFinalizarCadastroInstituicaoAtom.reportRead();
    return super.butaoFinalizarCadastroInstituicao;
  }

  @override
  set butaoFinalizarCadastroInstituicao(bool value) {
    _$butaoFinalizarCadastroInstituicaoAtom
        .reportWrite(value, super.butaoFinalizarCadastroInstituicao, () {
      super.butaoFinalizarCadastroInstituicao = value;
    });
  }

  final _$butaoInterruptorHabilitadoAtom =
      Atom(name: '_ObservadorButoesBase.butaoInterruptorHabilitado');

  @override
  bool get butaoInterruptorHabilitado {
    _$butaoInterruptorHabilitadoAtom.reportRead();
    return super.butaoInterruptorHabilitado;
  }

  @override
  set butaoInterruptorHabilitado(bool value) {
    _$butaoInterruptorHabilitadoAtom
        .reportWrite(value, super.butaoInterruptorHabilitado, () {
      super.butaoInterruptorHabilitado = value;
    });
  }

  final _$_ObservadorButoesBaseActionController =
      ActionController(name: '_ObservadorButoesBase');

  @override
  dynamic mudarValorFinalizarCadastroInstituicao(
      List<String> listaValoresFormulario,
      List<bool> listaValoresFormularioValidados) {
    final _$actionInfo = _$_ObservadorButoesBaseActionController.startAction(
        name: '_ObservadorButoesBase.mudarValorFinalizarCadastroInstituicao');
    try {
      return super.mudarValorFinalizarCadastroInstituicao(
          listaValoresFormulario, listaValoresFormularioValidados);
    } finally {
      _$_ObservadorButoesBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic mudarValorButaoInterruptorHabilitado(bool novo) {
    final _$actionInfo = _$_ObservadorButoesBaseActionController.startAction(
        name: '_ObservadorButoesBase.mudarValorButaoInterruptorHabilitado');
    try {
      return super.mudarValorButaoInterruptorHabilitado(novo);
    } finally {
      _$_ObservadorButoesBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
butaoFinalizarCadastroInstituicao: ${butaoFinalizarCadastroInstituicao},
butaoInterruptorHabilitado: ${butaoInterruptorHabilitado}
    ''';
  }
}
