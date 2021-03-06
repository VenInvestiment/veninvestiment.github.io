import 'dart:async';
import 'dart:developer';

import 'package:oku_sanga/modelos/sistema.dart';
import 'package:oku_sanga/repositorio/repositorio.dart';
import 'package:oku_sanga/solucoes_uteis/funcionais/algoritmo_exequiveis_no_momento_a_especificar.dart';
import 'package:oku_sanga/solucoes_uteis/funcionais/provedor_codigo.dart';
import 'package:oku_sanga/vista/componentes_visuais/observadores/observador_sistema.dart';

class ControladorServicosSistema {
  Sistema _sistema;
  ControladorServicosSistema(){
    this._sistema = Sistema();
  }

  Future inciarServicosSistema()async{
    
    // ATRASAR EXECUCAO EM 10ms
    executarMetodoNoInstanteDeTempo(10, ()async{
      await _sistema.autenticarSeNoServidor();
    });
  }
}
