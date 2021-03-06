// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'observador_campo_texto.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$ObservadorCampoTexto on _ObservadorCampoTextoBase, Store {
  final _$valorEmailValidoAtom =
      Atom(name: '_ObservadorCampoTextoBase.valorEmailValido');

  @override
  bool get valorEmailValido {
    _$valorEmailValidoAtom.reportRead();
    return super.valorEmailValido;
  }

  @override
  set valorEmailValido(bool value) {
    _$valorEmailValidoAtom.reportWrite(value, super.valorEmailValido, () {
      super.valorEmailValido = value;
    });
  }

  final _$valorPalavraPasseValidoAtom =
      Atom(name: '_ObservadorCampoTextoBase.valorPalavraPasseValido');

  @override
  bool get valorPalavraPasseValido {
    _$valorPalavraPasseValidoAtom.reportRead();
    return super.valorPalavraPasseValido;
  }

  @override
  set valorPalavraPasseValido(bool value) {
    _$valorPalavraPasseValidoAtom
        .reportWrite(value, super.valorPalavraPasseValido, () {
      super.valorPalavraPasseValido = value;
    });
  }

  final _$valorNomeValidoAtom =
      Atom(name: '_ObservadorCampoTextoBase.valorNomeValido');

  @override
  bool get valorNomeValido {
    _$valorNomeValidoAtom.reportRead();
    return super.valorNomeValido;
  }

  @override
  set valorNomeValido(bool value) {
    _$valorNomeValidoAtom.reportWrite(value, super.valorNomeValido, () {
      super.valorNomeValido = value;
    });
  }

  final _$_ObservadorCampoTextoBaseActionController =
      ActionController(name: '_ObservadorCampoTextoBase');

  @override
  dynamic observarCampo(String valor, TipoCampoTexto tipoCampoTexto) {
    final _$actionInfo = _$_ObservadorCampoTextoBaseActionController
        .startAction(name: '_ObservadorCampoTextoBase.observarCampo');
    try {
      return super.observarCampo(valor, tipoCampoTexto);
    } finally {
      _$_ObservadorCampoTextoBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic observarCampoAlteracaoPalavraPasse(
      List<String> lista_palavra_passe_e_antiga,
      TipoCampoTexto tipoCampoTexto) {
    final _$actionInfo =
        _$_ObservadorCampoTextoBaseActionController.startAction(
            name:
                '_ObservadorCampoTextoBase.observarCampoAlteracaoPalavraPasse');
    try {
      return super.observarCampoAlteracaoPalavraPasse(
          lista_palavra_passe_e_antiga, tipoCampoTexto);
    } finally {
      _$_ObservadorCampoTextoBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic mudarValorValido(bool valor, TipoCampoTexto tipoCampoTexto) {
    final _$actionInfo = _$_ObservadorCampoTextoBaseActionController
        .startAction(name: '_ObservadorCampoTextoBase.mudarValorValido');
    try {
      return super.mudarValorValido(valor, tipoCampoTexto);
    } finally {
      _$_ObservadorCampoTextoBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
valorEmailValido: ${valorEmailValido},
valorPalavraPasseValido: ${valorPalavraPasseValido},
valorNomeValido: ${valorNomeValido}
    ''';
  }
}
