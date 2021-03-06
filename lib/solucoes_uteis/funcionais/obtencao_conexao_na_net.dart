import 'dart:async';
import 'dart:developer';

import 'package:http/http.dart' as httpVenceslauMoreira;
import 'package:oku_sanga/recursos/contantes.dart';
import 'package:oku_sanga/solucoes_uteis/funcionais/provedor_codigo.dart';

Timer timer;

Future<bool> obeterConexaoInternet() async{
  bool temConexao = false;
  try{
    observarConexaoComTemporizador();
    var respostaHttp = await httpVenceslauMoreira.get(Uri.parse(URL_BASE_SISTEMA));
    if(respostaHttp.statusCode == 200){
      temConexao = true;
    }else{
      temConexao = false;
    }
  }catch(erro){
    temConexao = false;
  }
  
  if(temConexao == false){
    observadorSistema.mudarValorDaMudadoraEstadoDoSistema("sem_conexao_net");
  }
  timer.cancel();
  return temConexao;
}

observarConexaoComTemporizador(){
  int c = 1;
  timer = Timer.periodic(Duration(seconds: 1), (timer){
    if(c==10){
      observadorSistema.mudarValorDaMudadoraEstadoDoSistema("sem_conexao_net");
      timer.cancel();
    }
    c++;
  });
}