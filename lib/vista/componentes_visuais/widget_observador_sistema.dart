import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:oku_sanga/recursos/contantes.dart';
import 'package:oku_sanga/repositorio/repositorio.dart';
import 'package:oku_sanga/solucoes_uteis/funcionais/algoritmo_exequiveis_no_momento_a_especificar.dart';
import 'package:oku_sanga/solucoes_uteis/funcionais/provedor_codigo.dart';
import 'package:oku_sanga/vista/componentes_visuais/janela_dialogos.dart';
import 'package:fluttertoast/fluttertoast.dart';

class WidgetObservadorSistema extends StatelessWidget {
  
  causarMudancasVisuaisNoSistema(BuildContext context){
    if(observadorSistema.janlaDialogoAberta == true){
      Navigator.of(context).pop();
      observadorSistema.mudarValorJanlaDialogoAberta(false);
    }
    if(observadorSistema.mudadoraEstadoDoSistema is String && observadorSistema.mudadoraEstadoDoSistema == "validando_pedido_cadastro_instituicao"){
      gerarDialogoCarregarRede(context, "Validando pedido de cadastramento.", observadorSistema.loginSistemaFeito == true);
      observadorSistema.mudarValorJanlaDialogoAberta(true);
    }
    
    if(observadorSistema.mudadoraEstadoDoSistema is String && observadorSistema.mudadoraEstadoDoSistema == "instituicao_ja_na_lista_aderindo"){
      if(observadorSistema.usuarioActual.toJson()["tipo_istituicao"] == "Pessoa Individual"){
        gerarDialogoComUmaAccaoDeSaida(context, "Já foi feito um pedido de cadastramento com este Email!");
      }else{
        gerarDialogoComUmaAccaoDeSaida(context, "Já foi feito um pedido de cadastramento com este Email ou Nome de Entidade!");
      }
      observadorSistema.mudarValorJanlaDialogoAberta(true);
    }
    
    if(observadorSistema.mudadoraEstadoDoSistema is String && observadorSistema.mudadoraEstadoDoSistema == "pedido_adesao_realizado"){
      observadorSistema.mudarValorDaMudadoraJanelasDoAplicativo("ir_para_janela_login");
      gerarDialogoComUmaAccaoDeSaida(context, "Seu pedido de cadastramento foi realizado com sucesso!\nEnviaremos uma confirmação em seu Email, o mais rápido possível, para poderes ter acesso a sua conta.\nObrigado!");
      observadorSistema.mudarValorJanlaDialogoAberta(true);
    }

    if(observadorSistema.mudadoraEstadoDoSistema is String && observadorSistema.mudadoraEstadoDoSistema == "pedido_adesao_em_processo"){
      gerarDialogoCarregarRede(context, "Enviando pedido de cadastramento.", observadorSistema.loginSistemaFeito == true);
      observadorSistema.mudarValorJanlaDialogoAberta(true);
    }
    
    if(observadorSistema.mudadoraEstadoDoSistema is String && observadorSistema.mudadoraEstadoDoSistema == "sem_conexao_net"){
      gerarDialogoComUmaAccaoDeSaida(context, "Não foi possível ligar-se ao servidor!\nPor favor, verifique a sua ligação de internet!");
      observadorSistema.mudarValorJanlaDialogoAberta(true);
    }

    if(observadorSistema.mudadoraEstadoDoSistema is String && observadorSistema.mudadoraEstadoDoSistema == "autenticando_sistema"){
      gerarDialogoCarregarRede(context, "Autenticando Sistema", observadorSistema.loginSistemaFeito == true);
      observadorSistema.mudarValorJanlaDialogoAberta(true);
    }

    if(observadorSistema.mudadoraEstadoDoSistema is String && observadorSistema.mudadoraEstadoDoSistema == "sistema_autenticado"){
      Fluttertoast.showToast(msg: "Sistema Autenticado!");
      observadorSistema.mudarValorJanlaDialogoAberta(false);
    }

    if(observadorSistema.mudadoraEstadoDoSistema is String && observadorSistema.mudadoraEstadoDoSistema == "sistema_nao_autenticado"){
      gerarDialogoRepetirAutenticacaoSistema(context, "Sistema não autenticado!\nPara poder usar os nossos serviços, A App Oku Sanga deve estar sincronizada ao servidor.");
      observadorSistema.mudarValorJanlaDialogoAberta(false);
    }

    if(observadorSistema.mudadoraEstadoDoSistema is String && observadorSistema.mudadoraEstadoDoSistema == "fazendo_login"){
      gerarDialogoCarregarRede(context, "Fazendo login!", observadorSistema.loginSistemaFeito == true);
      observadorSistema.mudarValorJanlaDialogoAberta(true);
    }

    if(observadorSistema.mudadoraEstadoDoSistema is String && observadorSistema.mudadoraEstadoDoSistema == "palavra_passe_incorrecta"){
      gerarDialogoComUmaAccaoDeSaida(context, "Palavra-Passe incorrecta!\n Por favor, verifique se a palavra-passe inserida está bem escrita.");
      observadorSistema.mudarValorJanlaDialogoAberta(true);
    }

    if(observadorSistema.mudadoraEstadoDoSistema is String && observadorSistema.mudadoraEstadoDoSistema == "usuario_nao_cadastrado"){
      gerarDialogoComUmaAccaoDeSaida(context, "Não existe nenhum usuário com este email!\n Por favor, verifique se o email inserido está bem escrito.");
      observadorSistema.mudarValorJanlaDialogoAberta(true);
    }

    if(observadorSistema.mudadoraEstadoDoSistema is String && observadorSistema.mudadoraEstadoDoSistema == "erro_OS00001"){
      gerarDialogoComUmaAccaoDeSaida(context, "Por razões técnicas não foi possível aceder aos seus dados no servidor.\nPor favor, reinicie a aplicação e tente novamente.\nSe o erro persistir reporte em nossa página do Facebook, Twitter ou no nosso Whattapp.");
      observadorSistema.mudarValorJanlaDialogoAberta(true);
    }

    if(observadorSistema.mudadoraEstadoDoSistema is String && observadorSistema.mudadoraEstadoDoSistema == "login_realizado"){
      observadorSistema.mudarValorDaMudadoraJanelasDoAplicativo("ir_para_janela_painel");
    }

    if(observadorSistema.mudadoraEstadoDoSistema is Map && observadorSistema.mudadoraEstadoDoSistema["nome"] == "mudando_dado"){
      gerarDialogoAlterarDado(context, observadorSistema.mudadoraEstadoDoSistema["dado"], observadorSistema.mudadoraEstadoDoSistema["tipo_dado_em_alteracao"]);
    }

    if(observadorSistema.mudadoraEstadoDoSistema is Map && observadorSistema.mudadoraEstadoDoSistema["nome"] == "adicionando_dado"){
      gerarDialogoAddEnderecoOuContacto(context, observadorSistema.mudadoraEstadoDoSistema["tipo_dado_em_adicao"]);
    }

    if(observadorSistema.mudadoraEstadoDoSistema is String && observadorSistema.mudadoraEstadoDoSistema == "actualizando_dados_perfil"){
      gerarDialogoCarregarRede(context, "Actualizando dados!", false);
      observadorSistema.mudarValorJanlaDialogoAberta(true);
    }

    if(observadorSistema.mudadoraEstadoDoSistema is String && observadorSistema.mudadoraEstadoDoSistema == "dados_perfil_actualizados"){
      Fluttertoast.showToast(msg: "Feito!");
      Navigator.of(context).pop();
    }

    if(observadorSistema.mudadoraEstadoDoSistema is String && observadorSistema.mudadoraEstadoDoSistema == "exigir_click_para_upload_foto"){
      gerarDialogoComUmaAccaoDeSaida(context, "Dê dois cliques para selecionar a foto de seu despositivo!");
    }

    if(observadorSistema.mudadoraEstadoDoSistema is String && observadorSistema.mudadoraEstadoDoSistema == "defindo_foto_perfil"){
      gerarDialogoCarregarRede(context, "Definindo foto!", false);
      observadorSistema.mudarValorJanlaDialogoAberta(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (_) {
      executarMetodoNoInstanteDeTempo(10, (){causarMudancasVisuaisNoSistema(context);});
      return observadorSistema.mudadoraEstadoDoSistema is int ? Container() : Container();
    });
  }
}
