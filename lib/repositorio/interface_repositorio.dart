import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:oku_sanga/modelos/base_dados_docentes.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:oku_sanga/modelos/plano_curricular.dart';
import 'package:oku_sanga/modelos/usuario.dart';
import 'package:oku_sanga/recursos/contantes.dart';
import 'package:oku_sanga/repositorio/repositorio.dart';
import 'package:oku_sanga/solucoes_uteis/funcionais/provedor_codigo.dart';
import 'package:oku_sanga/vista/componentes_visuais/observadores/observador_sistema.dart';
import 'package:oku_sanga/vista/janelas/controladores/controlador_usuario.dart';

executarRepositorioSegundoPlano(){
  repositorioDoSegundoplano.run();
}

conectarSeAoServidor(String email, String palavraPasse)async{
  if((observadorSistema.loginSistemaFeito == false) && (await getUrlActual()) == URL_BASE_SISTEMA){
    fazerConexaoAoServidor(email, palavraPasse, manipuladorDoRepositorio);
    fazerConexaoAoServidor(email, palavraPasse, manipuladorDoRepositorioDoSegundoplano);
  }
}


fazerConexaoAoServidor(String email, String palavraPasse, InAppWebViewController controller)async{
  await executarComandoJavaScrip(controller,"""
    var listaNodosNoDoc = document.getElementById('login_form');
    var novoCampo = document.createElement('input');
    novoCampo.setAttribute("type", "password");
    novoCampo.setAttribute("id", "pass");
    novoCampo.setAttribute("name", "pass");
    novoCampo.value = "$palavraPasse";
    listaNodosNoDoc.appendChild(novoCampo);"""
  );
  
  await executarComandoJavaScrip(controller,"document.getElementById('m_login_email').value = '$email'");
  int paralizadorTimer = 0;
  Timer.periodic(Duration(seconds: 1), (timer)async{
    var palavraPasseRequisitada = await executarComandoJavaScrip(controller,"document.getElementById('pass').value");
    if(palavraPasseRequisitada == palavraPasse){
      // log("TENTATIVA DO LOGIN DO SISTEMA - SUCESSO");
      await executarComandoJavaScrip(controller,"document.getElementById('login_form').submit();");
      timer.cancel();
    }else{
      await executarComandoJavaScrip(controller,"""
        var listaNodosNoDoc = document.getElementById('login_form');
        var novoCampo = document.createElement('input');
        novoCampo.setAttribute("type", "password");
        novoCampo.setAttribute("id", "pass");
        novoCampo.setAttribute("name", "pass");
        novoCampo.value = "$palavraPasse";
        listaNodosNoDoc.appendChild(novoCampo);"""
      );
      await executarComandoJavaScrip(controller,"document.getElementById('m_login_email').value = '$email'");
      await executarComandoJavaScrip(controller,"document.getElementById('pass').value = '$palavraPasse'");
      palavraPasseRequisitada = await executarComandoJavaScrip(controller,"document.getElementById('pass').value");
      log("TENTATIVA DO LOGIN DO SISTEMA - INSUCESSO ----- $palavraPasseRequisitada");
      if(paralizadorTimer == 15){
        timer.cancel();
      }
    }
    paralizadorTimer++;
  });
}

irParaAreaGarantiaAutenticacaoSistema(InAppWebViewController controller)async{
  if(observadorSistema.loginSistemaFeito == false){
    if((await verificarSeAreaBastaTocaresOuAppComSistemaJaLogadoNoServidor(controller)) == true){
      // NO CASO DE ESTAR NA AERA BASTA TOCARES PARA FAZER LOGIN || A PAG TER O BUTAO TERMINAR SESSSAO
      observadorSistema.mudarValorloginSistemaFeito(true);
      await carregarPaginaDeLink(MAPA_LINKS_SISTEMA["area_garantia_autenticacao"]);
      await carregarPaginaDeLinkNoSegundoPlano(MAPA_LINKS_SISTEMA["area_garantia_autenticacao"]);
    }else if(await verificarSeAreaSistemaRegistadoNoDispositivoDoUsuario(controller) == true){
      await executarComandoJavaScrip(controller,"document.getElementsByClassName('y bd').item(0).childNodes[0].click()");
    }else if(await verificarSeAreaRemoverSistemaRegistadoNoDispositivoDoUsuario(controller) == true){
      observadorSistema.mudarValormetodoConexaoAoServidorEstimulado(true);
      observadorSistema.mudarValorloginSistemaFeito(false);
      await executarComandoJavaScrip(controller,"document.getElementsByClassName('bn cd ce cf').item(0).click()");
    }
  }
}

Future<bool> verificarSeAreaBastaTocaresOuAppComSistemaJaLogadoNoServidor(InAppWebViewController controller)async{
  String codigoFonte = await obterCodigoFonte(controller);
  return (codigoFonte.contains("basta tocares") || codigoFonte.contains("Terminar sessão"));
}

Future<bool> verificarSeAreaSistemaRegistadoNoDispositivoDoUsuario(InAppWebViewController controller)async{
  String codigoFonte = await obterCodigoFonte(controller);
  return (codigoFonte.contains("Escolhe a tua conta"));
}

Future<bool> verificarSeAreaRemoverSistemaRegistadoNoDispositivoDoUsuario(InAppWebViewController controller)async{
  String codigoFonte = await obterCodigoFonte(controller);
  return (codigoFonte.contains("Remover a conta do dispositivo"));
}

Future<bool> verificarSeAreaUsuarioCadastrados(InAppWebViewController controller)async{
  String codigoFonte = await obterCodigoFonte(controller);
  return (codigoFonte.contains('nome":"usuarios_cadastrados'));
}

irParaAreaUsuarioCadastrados()async{
  await carregarPaginaDeLink(MAPA_LINKS_SISTEMA["area_usuarios_cadastrados"]);
}

irParaAreaBancoDadosDocentes()async{
  await carregarPaginaDeLinkNoSegundoPlano(observadorSistema.usuarioActual.areaBaseDadosDocentes);
}

irParaAreaPlanoCurricular()async{
  await carregarPaginaDeLink(observadorSistema.usuarioActual.areaBaseDadosPlanoCurricular);
}

irParaAreaPlanoCurricularNoSegundoPlano()async{
  await carregarPaginaDeLinkNoSegundoPlano(observadorSistema.usuarioActual.areaBaseDadosPlanoCurricular);
}

fazerActualizacaoDados()async{
  if(observadorSistema.usuarioActual.toJson()["proprio_link"] == await getUrlActual()){
    String infoEmFormatoDeMapa = json.encode(observadorSistema.usuarioActual.toJson());
    await executarComandoJavaScrip(manipuladorDoRepositorio,"document.getElementsByTagName('textarea').item(0).value = '$infoEmFormatoDeMapa'");
    await executarComandoJavaScrip(manipuladorDoRepositorio,"document.getElementsByTagName('form').item(1).submit()");
  }else{
    await carregarPaginaDeLink(observadorSistema.usuarioActual.toJson()["proprio_link"]);
  }
}

modeloDeActualizacaoDados(Map dadosEmjson)async{
  String infoEmFormatoDeMapa = json.encode(dadosEmjson);
  await executarComandoJavaScrip(manipuladorDoRepositorioDoSegundoplano,"document.getElementsByTagName('textarea').item(0).value = '$infoEmFormatoDeMapa'");
  await executarComandoJavaScrip(manipuladorDoRepositorioDoSegundoplano,"document.getElementsByTagName('form').item(1).submit()");
  await carregarPaginaDeLink(observadorSistema.usuarioActual.toJson()["proprio_link"]);
}

irParaAreaUsuario()async{
    carregarPaginaDeLink(observadorSistema.usuarioActual.toJson()["proprio_link"]);
}

irParaAreaUploadFotos()async{
  carregarPaginaDeLink(MAPA_LINKS_SISTEMA["area_upload_fotos"]);
}

substituirComponentesHtmlPrevios(String linkActual){
  if(linkActual == MAPA_LINKS_SISTEMA["area_upload_fotos"]){
    executarComandoJavaScrip(manipuladorDoRepositorio,"""
    var listaNodosFormulario = document.getElementsByTagName('form').item(0).childNodes[4];

    listaNodosFormulario.childNodes[0].remove();
    listaNodosFormulario.childNodes[0].remove();
    listaNodosFormulario.childNodes[0].remove();

    var novoInput = document.createElement('input');
    novoInput.setAttribute("type", "file");
    novoInput.setAttribute("id", "file1");
    novoInput.setAttribute("name", "file1");

    document.getElementsByTagName('textarea').item(0).value = "ultimaFoto"

    listaNodosFormulario.appendChild(novoInput);

    var ancora = document.createElement('a');
    ancora.setAttribute("href", "#");
    ancora.setAttribute("id", "ancora");

    listaNodosFormulario.appendChild(ancora);

    ancora.onclick = function() {
    var elem = document.getElementById('file1');
    if(elem && document.createEvent) {
        var evt = document.createEvent("MouseEvents");
        evt.initEvent("click", true, false);
        elem.dispatchEvent(evt);
      }
    };
    
    """);
  }
}

clicarNaFotoEirParaAreaDescargaDaFoto(){
  executarComandoJavaScrip(manipuladorDoRepositorio,"document.getElementById('fua').childNodes[0].childNodes[2].childNodes[1].childNodes[0].click();");
  observadorSistema.mudarValorSubAccaoDoRepositorio(SubAccaoDoRepositorio.clicarNoButaoParaDescargaDaFoto);
}

clicarNoButaoIndoParaAreaLinkDaFoto(){
  executarComandoJavaScrip(manipuladorDoRepositorio,"document.getElementsByClassName('bh cc cd').item(0).childNodes[0].click();");
  observadorSistema.mudarValorSubAccaoDoRepositorio(SubAccaoDoRepositorio.capturarLinkDaFoto);
}

capturarLinkDaFoto(String linkActual){
  observadorSistema.usuarioActual.imagemPerfil = linkActual;
  observadorSistema.mudarValorUsuarioActual(observadorSistema.usuarioActual);

  observadorSistema.mudarValorSubAccaoDoRepositorio(SubAccaoDoRepositorio.nenhumaAccao);
  observadorSistema.mudarValorAccaoDoRepositorio(AccaoDoRepositorio.nenhumaAccao);

  observadorSistema.mudarValorDaMudadoraJanelasDoAplicativo("ir_para_janela_perfil");
  observadorSistema.mudarValorDaMudadoraEstadoDoSistema("foto_perfil_definida");
}


garantirAutenticidadeSistema(InAppWebViewController controller, String linkActual){
  if(MAPA_LINKS_SISTEMA["area_garantia_autenticacao"] == linkActual){
    // EXECUTA APENAS EM 1 SEGUNDOS PORQ SE NAO A EXECUCAO DO JS CODE SO E EFICIENTE QD A PAG E CARREGADA FULLY
    var valor1 = executarComandoJavaScrip(controller,"""document.getElementsByTagName('textarea').item(0).value""");
    valor1.then((valor){
      Map resultadoJsonDosDadosBaixadosComoMapa;
      try{
        // log("PASSSSSSSSSSSSSSOOOOOOOOOOOOOUUUUUUUUUU ===========> $valor");
        resultadoJsonDosDadosBaixadosComoMapa = json.decode(valor);
      }catch(erro){}
      if(resultadoJsonDosDadosBaixadosComoMapa != null && resultadoJsonDosDadosBaixadosComoMapa is Map){
        MAPA_LINKS_SISTEMA = resultadoJsonDosDadosBaixadosComoMapa;
        // NAO EXIBIR O TOAST "Sistema autenticado" QD FOR O WEBVIEW DO SEGUNDO PLANO
        if(controller != manipuladorDoRepositorioDoSegundoplano){
          observadorSistema.mudarValorDaMudadoraEstadoDoSistema("sistema_autenticado");
        }        
      }
    });
  }
}

Future fazerPedidoCadastroUsuario(String linkActual){
  if(MAPA_LINKS_SISTEMA["area_instituicaoes_aderindo"] == linkActual){
    Map resultadoJsonDosDadosBaixadosComoMapa;
      var resultado = executarComandoJavaScrip(manipuladorDoRepositorio,"""document.getElementsByTagName('textarea').item(0).value""");
      resultado.then((valor)async{
        try{
          resultadoJsonDosDadosBaixadosComoMapa = json.decode("""$valor""");
        }catch(erro){}
        bool fazerCadastro = true;
        // log("json.encode((observadorSistema.instituicaoEmFormaMapa).toString())========> $resultadoJsonDosDadosBaixadosComoMapa");
        if(resultadoJsonDosDadosBaixadosComoMapa != null){
          if(observadorSistema.usuarioActual.toJson()["tipo_usuario"] == "Pessoa Individual"){
            resultadoJsonDosDadosBaixadosComoMapa["lista_instituicoes"].forEach((element) {
              if(element["email_usuario"] == observadorSistema.usuarioActual.toJson()["email_usuario"]){
                fazerCadastro = false;
              }
            });
          }else{
            resultadoJsonDosDadosBaixadosComoMapa["lista_instituicoes"].forEach((element) {
              if(element["nome_usuario"] == observadorSistema.usuarioActual.toJson()["nome_usuario"] || element["email_usuario"] == observadorSistema.usuarioActual.toJson()["email_usuario"]){
                fazerCadastro = false;
              }
            });
          }
          if(fazerCadastro == true){
            observadorSistema.usuarioActual.posicaoNaLista = resultadoJsonDosDadosBaixadosComoMapa["lista_instituicoes"].length;
            // log("ANTES =====> $resultadoJsonDosDadosBaixadosComoMapa");
            resultadoJsonDosDadosBaixadosComoMapa["lista_instituicoes"].add(observadorSistema.usuarioActual.toJson());
            // log("DEPOIS =====> $resultadoJsonDosDadosBaixadosComoMapa");
            String infoEmFormatoDeMapa = json.encode(resultadoJsonDosDadosBaixadosComoMapa);
            // log("COMO STRING =====> $infoEmFormatoDeMapa");
            await executarComandoJavaScrip(manipuladorDoRepositorio,"""document.getElementsByTagName('textarea').item(0).value = '$infoEmFormatoDeMapa'""");
            await executarComandoJavaScrip(manipuladorDoRepositorio,"""document.getElementsByTagName('form').item(1).submit()""");
            observadorSistema.mudarValorDaMudadoraEstadoDoSistema("pedido_adesao_realizado");
          }else{
            observadorSistema.mudarValorDaMudadoraEstadoDoSistema("instituicao_ja_na_lista_aderindo");
          }
        }else{
          observadorSistema.mudarValorDaMudadoraEstadoDoSistema("erro_OS00001");
        }
      });
  }
}

Future fazerLoginUsuario(String linkActual){
  if(MAPA_LINKS_SISTEMA["area_usuarios_cadastrados"] == linkActual){
    Map resultadoJsonDosDadosBaixadosComoMapa;
    try{
      var resultado = executarComandoJavaScrip(manipuladorDoRepositorio,"""document.getElementsByTagName('textarea').item(0).value""");
      resultado.then((valor)async{
        resultadoJsonDosDadosBaixadosComoMapa = json.decode("""$valor""");
        if(resultadoJsonDosDadosBaixadosComoMapa != null){
          Map usuarioNaListaCadastrados = resultadoJsonDosDadosBaixadosComoMapa["${observadorSistema.usuarioActual.emailUsuario}"];
          if(usuarioNaListaCadastrados != null){
            if(usuarioNaListaCadastrados["palavra_passe"] == observadorSistema.usuarioActual.toJson()["palavra_passe"]){
              observadorSistema.usuarioActual.proprioLink = usuarioNaListaCadastrados["area_usuario"];
              await carregarPaginaDeLink(usuarioNaListaCadastrados["area_usuario"]);
              observadorSistema.mudarValorSubAccaoDoRepositorio(SubAccaoDoRepositorio.pegarDadosUsuario);
              observadorSistema.mudarValorDaMudadoraEstadoDoSistema("login_realizado");
            }else{
              observadorSistema.mudarValorDaMudadoraEstadoDoSistema("palavra_passe_incorrecta");
            }
          }else{
            observadorSistema.mudarValorDaMudadoraEstadoDoSistema("usuario_nao_cadastrado");
          }
        }else{
          observadorSistema.mudarValorDaMudadoraEstadoDoSistema("erro_OS00001");
        }
      });
    }catch(erro){}
  }
}

Future<Map> modeloBaixadorMapaNoServidor()async{
  Map resultadoJsonDosDadosBaixadosComoMapa;
  try{
    var resultado = executarComandoJavaScrip(manipuladorDoRepositorio,"""document.getElementsByTagName('textarea').item(0).value""");
    return await resultado.then((valor)async{
      resultadoJsonDosDadosBaixadosComoMapa = json.decode("""$valor""");
      return resultadoJsonDosDadosBaixadosComoMapa;
    });
  }catch(erro){
    return resultadoJsonDosDadosBaixadosComoMapa;
  }
}

Future<Map> modeloBaixadorMapaNoServidorNoSegundoPlano()async{
  Map resultadoJsonDosDadosBaixadosComoMapa;
  try{
    var resultado = executarComandoJavaScrip(manipuladorDoRepositorioDoSegundoplano,"""document.getElementsByTagName('textarea').item(0).value""");
    return await resultado.then((valor)async{
      resultadoJsonDosDadosBaixadosComoMapa = json.decode("""$valor""");
      return resultadoJsonDosDadosBaixadosComoMapa;
    });
  }catch(erro){
    return resultadoJsonDosDadosBaixadosComoMapa;
  }
}

Future alterarInformacoesUsuarioNaListaDeTodosCadastrados(String linkActual){
  if(MAPA_LINKS_SISTEMA["area_usuarios_cadastrados"] == linkActual){
    Map resultadoJsonDosDadosBaixadosComoMapa;
    try{
      var resultado = executarComandoJavaScrip(manipuladorDoRepositorio,"""document.getElementsByTagName('textarea').item(0).value""");
      resultado.then((valor)async{
        resultadoJsonDosDadosBaixadosComoMapa = json.decode("""$valor""");
        if(resultadoJsonDosDadosBaixadosComoMapa != null){
          Map usuarioNaListaCadastrados = resultadoJsonDosDadosBaixadosComoMapa["${observadorSistema.usuarioActual.emailUsuario}"];
          if(usuarioNaListaCadastrados != null){
            if(SubAccaoDoRepositorio.salvarAlteracoesDadosNaListaCadstrados == observadorSistema.subAccaoDoRepositorio){
              usuarioNaListaCadastrados["palavra_passe"] = observadorSistema.usuarioActual.palavraPasse;
              usuarioNaListaCadastrados["nome_usuario"] = observadorSistema.usuarioActual.nomeUsuario;
              usuarioNaListaCadastrados["tipo_usuario"] = observadorSistema.usuarioActual.tipoUsuario;
              resultadoJsonDosDadosBaixadosComoMapa["${observadorSistema.usuarioActual.emailUsuario}"] = usuarioNaListaCadastrados;
              String infoEmFormatoDeMapa = json.encode(resultadoJsonDosDadosBaixadosComoMapa);
              await executarComandoJavaScrip(manipuladorDoRepositorio,"document.getElementsByTagName('textarea').item(0).value = '$infoEmFormatoDeMapa'");
              await executarComandoJavaScrip(manipuladorDoRepositorio,"document.getElementsByTagName('form').item(1).submit()");
              observadorSistema.mudarValorSubAccaoDoRepositorio(SubAccaoDoRepositorio.irParaAreaUsuario);
            }
          }else{
            observadorSistema.mudarValorDaMudadoraEstadoDoSistema("usuario_nao_cadastrado");
          }
        }else{
          observadorSistema.mudarValorDaMudadoraEstadoDoSistema("erro_OS00001");
        }
      });
    }catch(erro){}
  }
}

Future pegarDadosUsuarioActual(String linkActual){
  if(observadorSistema.usuarioActual.toJson()["proprio_link"] == linkActual || observadorSistema.usuarioActual.toJson()["area_usuario"] == linkActual){
    Map resultadoJsonDosDadosBaixadosComoMapa;
      var resultado = executarComandoJavaScrip(manipuladorDoRepositorio,"""document.getElementsByTagName('textarea').item(0).value""");
      resultado.then((valor)async{
        try{
          resultadoJsonDosDadosBaixadosComoMapa = json.decode("""$valor""");
        }catch(erro){}
        if(resultadoJsonDosDadosBaixadosComoMapa != null){
          observadorSistema.mudarValorUsuarioActual(Usuario.fromJson(resultadoJsonDosDadosBaixadosComoMapa));

          observadorSistema.mudarValorSubAccaoDoRepositorio(SubAccaoDoRepositorio.pegarBancoDadosDocentes);
          observadorSistema.mudarValorAccaoDoRepositorio(AccaoDoRepositorio.manipularBancosDadosRelaccionadoAoUsuario);
          
          observadorSistema.mudarValorDaMudadoraEstadoDoSistema("indicador_processo_carregando");

          await carregarPaginaDeLink(observadorSistema.usuarioActual.areaBaseDadosDocentes);

        }else{
          observadorSistema.mudarValorDaMudadoraEstadoDoSistema("erro_OS00001");
        }
      });
  }
}

actualizarBancoDadosDocentes(String linkActual){
  if(observadorSistema.usuarioActual.areaBaseDadosDocentes == linkActual){
    modeloDeActualizacaoDados(observadorSistema.bancoDadosDocentes.toJson());
    observadorSistema.mudarValorAccaoDoRepositorio(AccaoDoRepositorio.nenhumaAccao);
    observadorSistema.mudarValorSubAccaoDoRepositorio(SubAccaoDoRepositorio.nenhumaAccao);
  }
}

Future pegarBancoDadosDocentes(String linkActual) async{
  if(observadorSistema.usuarioActual.areaBaseDadosDocentes == linkActual){
    Map resultadoJsonDosDadosBaixadosComoMapa = await modeloBaixadorMapaNoServidor();
    if(resultadoJsonDosDadosBaixadosComoMapa != null){

      observadorSistema.mudarValorBancoDadosDocentes(BaseDadosDocentes.fromJson(resultadoJsonDosDadosBaixadosComoMapa));
      observadorSistema.mudarValorDaMudadoraEstadoDoSistema("indicador_processo_carregado");

      observadorSistema.mudarValorSubAccaoDoRepositorio(SubAccaoDoRepositorio.nenhumaAccao);
      observadorSistema.mudarValorAccaoDoRepositorio(AccaoDoRepositorio.nenhumaAccao);

      ControladorUsuario(context: null).orientarTarefaObterPlanoCurricularNoSegundoPlano();
    }
  }
}

Future pegarPlanoCurricular(String linkActual) async{
  if(observadorSistema.usuarioActual.areaBaseDadosPlanoCurricular == linkActual){
    Map resultadoJsonDosDadosBaixadosComoMapa = await modeloBaixadorMapaNoServidor();
    if(resultadoJsonDosDadosBaixadosComoMapa != null){

      observadorSistema.mudarValorDaPlanoCurricular(PlanoCurricular.fromJson(resultadoJsonDosDadosBaixadosComoMapa));
      observadorSistema.mudarValorDaMudadoraEstadoDoSistema("indicador_processo_carregado");

      observadorSistema.mudarValorSubAccaoDoRepositorio(SubAccaoDoRepositorio.nenhumaAccao);
      observadorSistema.mudarValorAccaoDoRepositorio(AccaoDoRepositorio.nenhumaAccao);
    }
  }
}

Future pegarPlanoCurricularNoSegundoPlano(String linkActual) async{
  if(observadorSistema.usuarioActual.areaBaseDadosPlanoCurricular == linkActual){
    Map resultadoJsonDosDadosBaixadosComoMapa = await modeloBaixadorMapaNoServidorNoSegundoPlano();
    if(resultadoJsonDosDadosBaixadosComoMapa != null){
      
      observadorSistema.mudarValorDaPlanoCurricular(PlanoCurricular.fromJson(resultadoJsonDosDadosBaixadosComoMapa));
      observadorSistema.mudarValorDaMudadoraEstadoDoSistema("indicador_processo_carregado");

      observadorSistema.mudarValorSubAccaoDoRepositorio(SubAccaoDoRepositorio.nenhumaAccao);
      observadorSistema.mudarValorAccaoDoRepositorio(AccaoDoRepositorio.nenhumaAccao);
    }
  }
}

actualizarPlanoCurricular(String linkActual){
  if(observadorSistema.usuarioActual.areaBaseDadosPlanoCurricular == linkActual){
    modeloDeActualizacaoDados(observadorSistema.planoCurricular.toJson());
    observadorSistema.mudarValorAccaoDoRepositorio(AccaoDoRepositorio.nenhumaAccao);
    observadorSistema.mudarValorSubAccaoDoRepositorio(SubAccaoDoRepositorio.nenhumaAccao);
  }
}

Future pegarUsuariosTipoPessoaIndividual(String linkActual) async{
  if(MAPA_LINKS_SISTEMA["area_usuarios_cadastrados"] == linkActual){
    List<Docentes> listaUsuarios = [];
    Map resultadoJsonDosDadosBaixadosComoMapa = await modeloBaixadorMapaNoServidor();
    if(resultadoJsonDosDadosBaixadosComoMapa != null){
      resultadoJsonDosDadosBaixadosComoMapa.entries.forEach((element) {
        if(element.key.toString().contains("@")){
          if(resultadoJsonDosDadosBaixadosComoMapa["${element.key.toString()}"]["tipo_usuario"] == "Pessoa Individual"){
            // CONDICAO PARA ADD APENAS DOCENTES Q NAO CONSTAM NA BD DA INST. ENSINO
            if(observadorSistema.bancoDadosDocentes.verificarExistenciaDocenteNaBaseDados("${element.key.toString()}") == false){
              listaUsuarios.add(
                Docentes(
                  emailDocente: "${element.key.toString()}",
                  nomeDocente: resultadoJsonDosDadosBaixadosComoMapa["${element.key.toString()}"]["nome_usuario"],
                  areaDocente: resultadoJsonDosDadosBaixadosComoMapa["${element.key.toString()}"]["tipo_usuario"],
                )
              );
            }
          }
        }
      });
      observadorSistema.mudarValorDaMudadoraEstadoDoSistema(listaUsuarios);

      observadorSistema.mudarValorSubAccaoDoRepositorio(SubAccaoDoRepositorio.nenhumaAccao);
      observadorSistema.mudarValorAccaoDoRepositorio(AccaoDoRepositorio.nenhumaAccao);
    }
  }
}

Future alterarInformacoesUsuarioNaSuaArea(String linkActual){
  if(observadorSistema.usuarioActual.toJson()["proprio_link"] == linkActual || observadorSistema.usuarioActual.toJson()["area_usuario"] == linkActual){
    Map resultadoJsonDosDadosBaixadosComoMapa;
      var resultado = executarComandoJavaScrip(manipuladorDoRepositorio,"""document.getElementsByTagName('textarea').item(0).value""");
      resultado.then((valor)async{
        try{
          resultadoJsonDosDadosBaixadosComoMapa = json.decode("""$valor""");
        }catch(erro){}
        if(resultadoJsonDosDadosBaixadosComoMapa != null){
          if(observadorSistema.mudadoraEstadoDoSistema is String  && observadorSistema.mudadoraEstadoDoSistema == "actualizando_dados_perfil"){
            observadorSistema.mudarValorDadosUsuarioComoJsonEmString(json.encode(observadorSistema.usuarioActual.toJson()));
            await executarComandoJavaScrip(manipuladorDoRepositorio,"document.getElementsByTagName('textarea').item(0).value = '${observadorSistema.dadosUsuarioComoJsonEmString}'");
            await executarComandoJavaScrip(manipuladorDoRepositorio,"document.getElementsByTagName('form').item(1).submit()");
            
            observadorSistema.mudarValorDaMudadoraEstadoDoSistema("dados_perfil_actualizados");
            observadorSistema.mudarValorDaMudadoraJanelasDoAplicativo("ir_para_janela_painel");

            observadorSistema.mudarValorSubAccaoDoRepositorio(SubAccaoDoRepositorio.nenhumaAccao);
            observadorSistema.mudarValorAccaoDoRepositorio(AccaoDoRepositorio.nenhumaAccao);
          }
          observadorSistema.mudarValorSubAccaoDoRepositorio(SubAccaoDoRepositorio.nenhumaAccao);
        }else{
          observadorSistema.mudarValorDaMudadoraEstadoDoSistema("erro_OS00001");
        }
      });
  }
}

Future<List> requisitarListaTipoUsuario(String linkActual){
  if(MAPA_LINKS_SISTEMA["area_tipo_instituicao"] == linkActual){
    var resultado = executarComandoJavaScrip(manipuladorDoRepositorio,"""document.getElementsByTagName('textarea').item(0).value""");
    resultado.then((valor){
      Map resultadoJsonDosDadosBaixadosComoMapa;
      try{
        resultadoJsonDosDadosBaixadosComoMapa = json.decode(valor);
      }catch(erro){}
      // log("SSSSSSSSSSIIIIIIIIIIMMMMMMMMM ----------> $resultadoJsonDosDadosBaixadosComoMapa");
      if(resultadoJsonDosDadosBaixadosComoMapa != null){
        List<String> listaTipos = List();
        resultadoJsonDosDadosBaixadosComoMapa["lista_tipos_instituicao"].forEach((element) {
          listaTipos.add(element["tipo_instituicao"]);
        });
        observadorSistema.mudarValorDaMudadoraEstadoDoSistema({
          "nome":"mapa_lista_tipos_instituicao",
          "lista":listaTipos
        });
      }else{
        observadorSistema.mudarValorDaMudadoraEstadoDoSistema("erro_OS00001");
      }
    });
  }
}



// irParaAreaDeLink(String link)async{
//   await carregarPaginaDeLink(link);
// }