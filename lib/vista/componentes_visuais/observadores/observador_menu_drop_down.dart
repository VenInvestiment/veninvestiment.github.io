import 'package:flutter/widgets.dart';
import 'package:mobx/mobx.dart';
part 'observador_menu_drop_down.g.dart';

class ObservadorMenuDropDown = _ObservadorMenuDropDownBase with _$ObservadorMenuDropDown;

abstract class _ObservadorMenuDropDownBase with Store {
  @observable
  String valorDropdownButtonSeleccionado;

  @action
  mudarValorItemDropdown(String novo){
    valorDropdownButtonSeleccionado = novo;
  }
}