import 'dart:async';

executarMetodoNoInstanteDeTempo(int instanteEmMilissegundos, Function metodo){
  Timer.periodic(Duration(milliseconds: instanteEmMilissegundos), (timer){
    metodo();
    timer.cancel();
  });
}