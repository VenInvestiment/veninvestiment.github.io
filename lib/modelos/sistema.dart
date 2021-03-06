import 'dart:async';
import 'dart:developer';

import 'package:oku_sanga/repositorio/repositorio.dart';
import 'package:oku_sanga/modelos/usuario.dart';
import 'package:oku_sanga/recursos/contantes.dart';
import 'package:oku_sanga/repositorio/interface_repositorio.dart';
import 'package:oku_sanga/solucoes_uteis/funcionais/provedor_codigo.dart';
import 'package:oku_sanga/vista/componentes_visuais/observadores/observador_sistema.dart';

class Sistema{
  Map _credencial = {
    "email":EMAIL_SISTEMA,
    "palavra_passe":PALAVRA_PASSE_SISTEMA
  };

  Map get credencial => _credencial;

  Sistema();
  
  autenticarSeNoServidor()async{
    await conectarSeAoServidor(_credencial["email"], _credencial["palavra_passe"]);
  }

  realizarTarefaPedidoCadastroUsuario()async{
    await carregarPaginaDeLink(MAPA_LINKS_SISTEMA["area_instituicaoes_aderindo"]);
  }

  Future<void> realizarTarefaBuscarListaTipoUsuario()async{
    await carregarPaginaDeLink(MAPA_LINKS_SISTEMA["area_tipo_instituicao"]);
  }

  Future<void> realizarTarefaFazerLoginUsuario()async{
    await carregarPaginaDeLink(MAPA_LINKS_SISTEMA["area_usuarios_cadastrados"]);
  }
}