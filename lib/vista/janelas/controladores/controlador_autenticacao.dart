
import 'dart:developer';

import 'package:oku_sanga/modelos/usuario.dart';
import 'package:oku_sanga/modelos/sistema.dart';
import 'package:oku_sanga/solucoes_uteis/funcionais/provedor_codigo.dart';
import 'package:oku_sanga/vista/componentes_visuais/observadores/observador_sistema.dart';
import 'package:oku_sanga/vista/janelas/controladores/controlador_usuario.dart';

class ControladorAutenticacao{
  Sistema sistema;
  ControladorAutenticacao(){
    sistema = Sistema();
  }

  orientarTarefaValidacaoPedidoCadastroUsuario(){
    observadorSistema.mudarValorAccaoDoRepositorio(AccaoDoRepositorio.cadastroUsuario);
    sistema.realizarTarefaPedidoCadastroUsuario();
  }

  orientarTarefaBaixarListaTiposUsuario(){
    observadorSistema.mudarValorAccaoDoRepositorio(AccaoDoRepositorio.requisitarListaTipoUsuario);
    sistema.realizarTarefaBuscarListaTipoUsuario();
  }

  orientarTarefaLogarUsuario(){
    observadorSistema.mudarValorAccaoDoRepositorio(AccaoDoRepositorio.loginUsuario);
    sistema.realizarTarefaFazerLoginUsuario();
  }

}