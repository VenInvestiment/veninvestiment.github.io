// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'observador_menu_drop_down.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$ObservadorMenuDropDown on _ObservadorMenuDropDownBase, Store {
  final _$valorDropdownButtonSeleccionadoAtom =
      Atom(name: '_ObservadorMenuDropDownBase.valorDropdownButtonSeleccionado');

  @override
  String get valorDropdownButtonSeleccionado {
    _$valorDropdownButtonSeleccionadoAtom.reportRead();
    return super.valorDropdownButtonSeleccionado;
  }

  @override
  set valorDropdownButtonSeleccionado(String value) {
    _$valorDropdownButtonSeleccionadoAtom
        .reportWrite(value, super.valorDropdownButtonSeleccionado, () {
      super.valorDropdownButtonSeleccionado = value;
    });
  }

  final _$_ObservadorMenuDropDownBaseActionController =
      ActionController(name: '_ObservadorMenuDropDownBase');

  @override
  dynamic mudarValorItemDropdown(String novo) {
    final _$actionInfo =
        _$_ObservadorMenuDropDownBaseActionController.startAction(
            name: '_ObservadorMenuDropDownBase.mudarValorItemDropdown');
    try {
      return super.mudarValorItemDropdown(novo);
    } finally {
      _$_ObservadorMenuDropDownBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
valorDropdownButtonSeleccionado: ${valorDropdownButtonSeleccionado}
    ''';
  }
}
