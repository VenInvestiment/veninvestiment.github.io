// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'observador_sistema.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$ObservadorSistema on _ObservadorSistemaBase, Store {
  final _$mudadoraEstadoDoSistemaAtom =
      Atom(name: '_ObservadorSistemaBase.mudadoraEstadoDoSistema');

  @override
  dynamic get mudadoraEstadoDoSistema {
    _$mudadoraEstadoDoSistemaAtom.reportRead();
    return super.mudadoraEstadoDoSistema;
  }

  @override
  set mudadoraEstadoDoSistema(dynamic value) {
    _$mudadoraEstadoDoSistemaAtom
        .reportWrite(value, super.mudadoraEstadoDoSistema, () {
      super.mudadoraEstadoDoSistema = value;
    });
  }

  final _$mudadoraJanelasDoAplicativoAtom =
      Atom(name: '_ObservadorSistemaBase.mudadoraJanelasDoAplicativo');

  @override
  dynamic get mudadoraJanelasDoAplicativo {
    _$mudadoraJanelasDoAplicativoAtom.reportRead();
    return super.mudadoraJanelasDoAplicativo;
  }

  @override
  set mudadoraJanelasDoAplicativo(dynamic value) {
    _$mudadoraJanelasDoAplicativoAtom
        .reportWrite(value, super.mudadoraJanelasDoAplicativo, () {
      super.mudadoraJanelasDoAplicativo = value;
    });
  }

  final _$mudadoraSubJanelasDoPainelAtom =
      Atom(name: '_ObservadorSistemaBase.mudadoraSubJanelasDoPainel');

  @override
  dynamic get mudadoraSubJanelasDoPainel {
    _$mudadoraSubJanelasDoPainelAtom.reportRead();
    return super.mudadoraSubJanelasDoPainel;
  }

  @override
  set mudadoraSubJanelasDoPainel(dynamic value) {
    _$mudadoraSubJanelasDoPainelAtom
        .reportWrite(value, super.mudadoraSubJanelasDoPainel, () {
      super.mudadoraSubJanelasDoPainel = value;
    });
  }

  final _$linkActualAtom = Atom(name: '_ObservadorSistemaBase.linkActual');

  @override
  String get linkActual {
    _$linkActualAtom.reportRead();
    return super.linkActual;
  }

  @override
  set linkActual(String value) {
    _$linkActualAtom.reportWrite(value, super.linkActual, () {
      super.linkActual = value;
    });
  }

  final _$usuarioActualAtom =
      Atom(name: '_ObservadorSistemaBase.usuarioActual');

  @override
  Usuario get usuarioActual {
    _$usuarioActualAtom.reportRead();
    return super.usuarioActual;
  }

  @override
  set usuarioActual(Usuario value) {
    _$usuarioActualAtom.reportWrite(value, super.usuarioActual, () {
      super.usuarioActual = value;
    });
  }

  final _$ignorarAccoesNaViewDoUsuarioAtom =
      Atom(name: '_ObservadorSistemaBase.ignorarAccoesNaViewDoUsuario');

  @override
  bool get ignorarAccoesNaViewDoUsuario {
    _$ignorarAccoesNaViewDoUsuarioAtom.reportRead();
    return super.ignorarAccoesNaViewDoUsuario;
  }

  @override
  set ignorarAccoesNaViewDoUsuario(bool value) {
    _$ignorarAccoesNaViewDoUsuarioAtom
        .reportWrite(value, super.ignorarAccoesNaViewDoUsuario, () {
      super.ignorarAccoesNaViewDoUsuario = value;
    });
  }

  final _$bancoDadosDocentesAtom =
      Atom(name: '_ObservadorSistemaBase.bancoDadosDocentes');

  @override
  BaseDadosDocentes get bancoDadosDocentes {
    _$bancoDadosDocentesAtom.reportRead();
    return super.bancoDadosDocentes;
  }

  @override
  set bancoDadosDocentes(BaseDadosDocentes value) {
    _$bancoDadosDocentesAtom.reportWrite(value, super.bancoDadosDocentes, () {
      super.bancoDadosDocentes = value;
    });
  }

  final _$planoCurricularAtom =
      Atom(name: '_ObservadorSistemaBase.planoCurricular');

  @override
  PlanoCurricular get planoCurricular {
    _$planoCurricularAtom.reportRead();
    return super.planoCurricular;
  }

  @override
  set planoCurricular(PlanoCurricular value) {
    _$planoCurricularAtom.reportWrite(value, super.planoCurricular, () {
      super.planoCurricular = value;
    });
  }

  final _$bancoDadosEstudantesAtom =
      Atom(name: '_ObservadorSistemaBase.bancoDadosEstudantes');

  @override
  Map<dynamic, dynamic> get bancoDadosEstudantes {
    _$bancoDadosEstudantesAtom.reportRead();
    return super.bancoDadosEstudantes;
  }

  @override
  set bancoDadosEstudantes(Map<dynamic, dynamic> value) {
    _$bancoDadosEstudantesAtom.reportWrite(value, super.bancoDadosEstudantes,
        () {
      super.bancoDadosEstudantes = value;
    });
  }

  final _$_ObservadorSistemaBaseActionController =
      ActionController(name: '_ObservadorSistemaBase');

  @override
  dynamic mudarValorDaMudadoraEstadoDoSistema(dynamic novo) {
    final _$actionInfo = _$_ObservadorSistemaBaseActionController.startAction(
        name: '_ObservadorSistemaBase.mudarValorDaMudadoraEstadoDoSistema');
    try {
      return super.mudarValorDaMudadoraEstadoDoSistema(novo);
    } finally {
      _$_ObservadorSistemaBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic mudarValorDaMudadoraJanelasDoAplicativo(dynamic novo) {
    final _$actionInfo = _$_ObservadorSistemaBaseActionController.startAction(
        name: '_ObservadorSistemaBase.mudarValorDaMudadoraJanelasDoAplicativo');
    try {
      return super.mudarValorDaMudadoraJanelasDoAplicativo(novo);
    } finally {
      _$_ObservadorSistemaBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic mudarValorDaPlanoCurricular(PlanoCurricular novo) {
    final _$actionInfo = _$_ObservadorSistemaBaseActionController.startAction(
        name: '_ObservadorSistemaBase.mudarValorDaPlanoCurricular');
    try {
      return super.mudarValorDaPlanoCurricular(novo);
    } finally {
      _$_ObservadorSistemaBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic mudarValorLinkActual(dynamic novo) {
    final _$actionInfo = _$_ObservadorSistemaBaseActionController.startAction(
        name: '_ObservadorSistemaBase.mudarValorLinkActual');
    try {
      return super.mudarValorLinkActual(novo);
    } finally {
      _$_ObservadorSistemaBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic mudarValorIgnorarAccoesNaViewDoUsuario(bool novo) {
    final _$actionInfo = _$_ObservadorSistemaBaseActionController.startAction(
        name: '_ObservadorSistemaBase.mudarValorIgnorarAccoesNaViewDoUsuario');
    try {
      return super.mudarValorIgnorarAccoesNaViewDoUsuario(novo);
    } finally {
      _$_ObservadorSistemaBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic mudarValorUsuarioActual(Usuario novo) {
    final _$actionInfo = _$_ObservadorSistemaBaseActionController.startAction(
        name: '_ObservadorSistemaBase.mudarValorUsuarioActual');
    try {
      return super.mudarValorUsuarioActual(novo);
    } finally {
      _$_ObservadorSistemaBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic mudarValorBancoDadosDocentes(BaseDadosDocentes novo) {
    final _$actionInfo = _$_ObservadorSistemaBaseActionController.startAction(
        name: '_ObservadorSistemaBase.mudarValorBancoDadosDocentes');
    try {
      return super.mudarValorBancoDadosDocentes(novo);
    } finally {
      _$_ObservadorSistemaBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic mudarValorBancoDadosEstudantes(Map<dynamic, dynamic> novo) {
    final _$actionInfo = _$_ObservadorSistemaBaseActionController.startAction(
        name: '_ObservadorSistemaBase.mudarValorBancoDadosEstudantes');
    try {
      return super.mudarValorBancoDadosEstudantes(novo);
    } finally {
      _$_ObservadorSistemaBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic mudarValorMudadoraSubJanelasDoPainel(dynamic novo) {
    final _$actionInfo = _$_ObservadorSistemaBaseActionController.startAction(
        name: '_ObservadorSistemaBase.mudarValorMudadoraSubJanelasDoPainel');
    try {
      return super.mudarValorMudadoraSubJanelasDoPainel(novo);
    } finally {
      _$_ObservadorSistemaBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
mudadoraEstadoDoSistema: ${mudadoraEstadoDoSistema},
mudadoraJanelasDoAplicativo: ${mudadoraJanelasDoAplicativo},
mudadoraSubJanelasDoPainel: ${mudadoraSubJanelasDoPainel},
linkActual: ${linkActual},
usuarioActual: ${usuarioActual},
ignorarAccoesNaViewDoUsuario: ${ignorarAccoesNaViewDoUsuario},
bancoDadosDocentes: ${bancoDadosDocentes},
planoCurricular: ${planoCurricular},
bancoDadosEstudantes: ${bancoDadosEstudantes}
    ''';
  }
}
