import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:oku_sanga/recursos/contantes.dart';
import 'package:oku_sanga/repositorio/interface_repositorio.dart';
import 'package:oku_sanga/solucoes_uteis/funcionais/algoritmo_exequiveis_no_momento_a_especificar.dart';
import 'package:oku_sanga/solucoes_uteis/funcionais/provedor_codigo.dart';
import 'package:oku_sanga/vista/componentes_visuais/observadores/observador_sistema.dart';

InAppWebViewController manipuladorDoRepositorioDoSegundoplano;

HeadlessInAppWebView repositorioDoSegundoplano = HeadlessInAppWebView(
  initialUrl: URL_BASE_SISTEMA,
    onWebViewCreated: (controlador){
      manipuladorDoRepositorioDoSegundoplano = controlador;
    },
    onLoadStop: (controlador,linkActual)async{
      log("HeadlessInAppWebView LINK ACTUAL ---> $linkActual");

      _executarQuandoForAuteticacaoSistema(manipuladorDoRepositorioDoSegundoplano,linkActual);

      _executarQuandoManipularBancosDadosRelaccionadoAoUsuario(linkActual);
    },
    onConsoleMessage: (controlador,console){
      log("HeadlessInAppWebView SMS JS CONSOLE: ${console.message}");
    },
);

InAppWebViewController manipuladorDoRepositorio;

Widget repositorio = GestureDetector(
  onVerticalDragDown: (dragDownDetails){
    observadorSistema.mudarValorIgnorarAccoesNaViewDoUsuario(false);
  },
  child: InAppWebView(
    initialUrl: URL_BASE_SISTEMA,
    onWebViewCreated: (controlador){
      manipuladorDoRepositorio = controlador;
    },
    onLoadStop: (controlador,linkActual)async{
      log("LINK ACTUAL ---> $linkActual");

      _executarQuandoForAuteticacaoSistema(manipuladorDoRepositorio ,linkActual);

      _executarQuandoForRequisitarListaTipoUsuario(linkActual);

      _executarQuandoForCadastrarUsuario(linkActual);
      _executarQuandoForLoginUsuario(linkActual);
      _executarQuandoForActualizacaoDadosUsuario(linkActual);
      _executarQuandoForActualizacaoFotoUsuario(linkActual);

      _executarQuandoManipularBancosDadosRelaccionadoAoUsuario(linkActual);

      _executarQuandoObterListaUsuariosTipoPessoaIndividual(linkActual);
    },
    onConsoleMessage: (controlador,console){
      if(console.message.contains("File chooser dialog can only be shown with a user activation")){
        observadorSistema.mudarValorDaMudadoraEstadoDoSistema("exigir_click_para_upload_foto");
        observadorSistema.mudarValorIgnorarAccoesNaViewDoUsuario(true);
      }
      log("SMS JS CONSOLE: ${console.message}");
    },
  ),
);

limparTodosDadosCacheDoRepositorio()async{
  await manipuladorDoRepositorio.clearCache();
  log("OS DADOS DA MEMORIA CACHE FORAM ESVAZIADOS");
}

Future executarComandoJavaScrip(InAppWebViewController controller, String codigo)async{
  return await controller.evaluateJavascript(source: codigo);
}

getUrlActual()async{
  return await manipuladorDoRepositorio.getUrl();
}

carregarPaginaDeLink(String url)async{
  // ATRAZAR 10 MILISECONS NO CARREGAMENTO DE UMA NOVA PAGE PARA EVITAR BLOQUEIOS PELO SERVIDOR
  await executarMetodoNoInstanteDeTempo(10, ()async{
    await manipuladorDoRepositorio.loadUrl(url: url);
  });
}

Future<bool> pegarSeRepositorioEstaEmModoCarregando()async{
  return await manipuladorDoRepositorioDoSegundoplano.isLoading();
}

carregarPaginaDeLinkNoSegundoPlano(String url)async{
  // ATRAZAR 10 MILISECONS NO CARREGAMENTO DE UMA NOVA PAGE PARA EVITAR BLOQUEIOS PELO SERVIDOR
  await executarMetodoNoInstanteDeTempo(10, ()async{
    await manipuladorDoRepositorioDoSegundoplano.loadUrl(url: url);
  });
}

recarregarPaginaDeConexaoAoServidor()async{
  await executarMetodoNoInstanteDeTempo(10, ()async{
    await manipuladorDoRepositorio.reload();
  });
}

Future<String> obterCodigoFonte(InAppWebViewController controller)async{
  return await controller.getHtml();
}

_executarQuandoForAuteticacaoSistema(InAppWebViewController controller, linkActual)async{
  if(AccaoDoRepositorio.autenticacaoSistema == observadorSistema.tipoAccaoDoRepositorio){
    await irParaAreaGarantiaAutenticacaoSistema(controller);
    await garantirAutenticidadeSistema(controller, linkActual);

    if(observadorSistema.metodoConexaoAoServidorEstimulado == true){
      // FORCAR APOS AVISAR USUARIO
      await executarMetodoNoInstanteDeTempo(10, ()async{ 
        await fazerConexaoAoServidor(EMAIL_SISTEMA, PALAVRA_PASSE_SISTEMA, manipuladorDoRepositorio);        
        await fazerConexaoAoServidor(EMAIL_SISTEMA, PALAVRA_PASSE_SISTEMA, manipuladorDoRepositorioDoSegundoplano);        
        observadorSistema.mudarValormetodoConexaoAoServidorEstimulado(false);
      });
    }
  }
}

_executarQuandoForRequisitarListaTipoUsuario(linkActual)async{
  if(AccaoDoRepositorio.requisitarListaTipoUsuario == observadorSistema.tipoAccaoDoRepositorio){
    await requisitarListaTipoUsuario(linkActual);
  }
}

_executarQuandoForCadastrarUsuario(linkActual)async{
  if(AccaoDoRepositorio.cadastroUsuario == observadorSistema.tipoAccaoDoRepositorio){
    await fazerPedidoCadastroUsuario(linkActual);
  }
}

_executarQuandoForLoginUsuario(linkActual)async{
  if(AccaoDoRepositorio.loginUsuario == observadorSistema.tipoAccaoDoRepositorio){
    
    await fazerLoginUsuario(linkActual);

    if(SubAccaoDoRepositorio.pegarDadosUsuario == observadorSistema.subAccaoDoRepositorio){
      await pegarDadosUsuarioActual(linkActual);
    }
  }
}

_executarQuandoForActualizacaoDadosUsuario(linkActual)async{
  if(AccaoDoRepositorio.actualizacaoPerfil == observadorSistema.tipoAccaoDoRepositorio){

    if(SubAccaoDoRepositorio.salvarAlteracoesDadosNaListaCadstrados == observadorSistema.subAccaoDoRepositorio){
      await alterarInformacoesUsuarioNaListaDeTodosCadastrados(linkActual);
    }

    if(SubAccaoDoRepositorio.salvarAlteracoesDadosNaAreaUsuario == observadorSistema.subAccaoDoRepositorio){
      await alterarInformacoesUsuarioNaSuaArea(linkActual);
    }

    if(SubAccaoDoRepositorio.irParaAreaUsuario == observadorSistema.subAccaoDoRepositorio){
      observadorSistema.mudarValorSubAccaoDoRepositorio(SubAccaoDoRepositorio.salvarAlteracoesDadosNaAreaUsuario);
      await irParaAreaUsuario();
    }

    if(SubAccaoDoRepositorio.pegarDadosUsuario == observadorSistema.subAccaoDoRepositorio){
      await pegarDadosUsuarioActual(linkActual);
    }
  }
}

_executarQuandoForActualizacaoFotoUsuario(linkActual)async{
  if(AccaoDoRepositorio.actualizacaoFotoUsuario == observadorSistema.tipoAccaoDoRepositorio){
    log("observadorSistema.usuarioActual.imagemPerfil = ${observadorSistema.usuarioActual.imagemPerfil}");
    substituirComponentesHtmlPrevios(linkActual);
    
    if(SubAccaoDoRepositorio.clicarNaFotoSeleccionadaRecentemente == observadorSistema.subAccaoDoRepositorio){
      clicarNaFotoEirParaAreaDescargaDaFoto();
    }

    if(SubAccaoDoRepositorio.clicarNoButaoParaDescargaDaFoto == observadorSistema.subAccaoDoRepositorio){
      executarMetodoNoInstanteDeTempo(1000, (){
        clicarNoButaoIndoParaAreaLinkDaFoto();
      });
    }

    if(SubAccaoDoRepositorio.capturarLinkDaFoto == observadorSistema.subAccaoDoRepositorio){
      capturarLinkDaFoto(linkActual);
    }
  }
}

_executarQuandoManipularBancosDadosRelaccionadoAoUsuario(linkActual)async{
  if(AccaoDoRepositorio.manipularBancosDadosRelaccionadoAoUsuario == observadorSistema.tipoAccaoDoRepositorio){
    
    if(SubAccaoDoRepositorio.pegarBancoDadosDocentes == observadorSistema.subAccaoDoRepositorio){
      await pegarBancoDadosDocentes(linkActual);
    }

    if(SubAccaoDoRepositorio.actualizarBancoDadosDocentes == observadorSistema.subAccaoDoRepositorio){
      await actualizarBancoDadosDocentes(linkActual);
    }

    if(SubAccaoDoRepositorio.pegarPlanoCurricular == observadorSistema.subAccaoDoRepositorio){
      await pegarPlanoCurricularNoSegundoPlano(linkActual);
    }

    if(SubAccaoDoRepositorio.actualizarPlanoCurricular == observadorSistema.subAccaoDoRepositorio){
      await actualizarPlanoCurricular(linkActual);
    }
  }
}

_executarQuandoObterListaUsuariosTipoPessoaIndividual(linkActual)async{
  if(AccaoDoRepositorio.obterListaUsuariosTipoPessoaIndividual == observadorSistema.tipoAccaoDoRepositorio){
    
    if(SubAccaoDoRepositorio.pegarUsuariosTipoPessoaIndividual == observadorSistema.subAccaoDoRepositorio){
      await pegarUsuariosTipoPessoaIndividual(linkActual);
    }
  }
}