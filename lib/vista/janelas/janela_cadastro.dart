import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:oku_sanga/modelos/usuario.dart';
import 'package:oku_sanga/solucoes_uteis/funcionais/obtencao_conexao_na_net.dart';
import 'package:oku_sanga/solucoes_uteis/funcionais/provedor_codigo.dart';

import 'package:oku_sanga/vista/componentes_visuais/butao.dart';
import 'package:oku_sanga/vista/componentes_visuais/campo_texto.dart';
import 'package:oku_sanga/vista/componentes_visuais/label_erros.dart';
import 'package:oku_sanga/vista/componentes_visuais/menu_drop_down.dart';
import 'package:oku_sanga/vista/componentes_visuais/observadores/observador_butoes.dart';
import 'package:oku_sanga/vista/componentes_visuais/observadores/observador_campo_texto.dart';
import 'package:oku_sanga/vista/componentes_visuais/observadores/observador_lista_tipo_instituicoes.dart';
import 'package:oku_sanga/vista/componentes_visuais/observadores/validadores/validadcao_campos.dart';
import 'package:oku_sanga/vista/janelas/controladores/controlador_autenticacao.dart';

class JanelaCadastro extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Cadastrar")),
      body: CorpoJanelaCadastro(),
    );
  }
}

class CorpoJanelaCadastro extends StatelessWidget {
  ObservadorCampoTexto observadorCampoTexto = ObservadorCampoTexto();
  ObservadorCampoTexto observadorCampoTexto2 = ObservadorCampoTexto();
  ObservadorListaTipoInstituicoes observadorListaTipoInstituicoes = ObservadorListaTipoInstituicoes();
  ObservadorButoes observadorButoes = ObservadorButoes();
  String nome = "", email  = "", palavraPasse  = "", confirmePalavraPasse  = "", valorSeleccionadoMenuDropDown = "";
  ControladorAutenticacao controladorAutenticacao = ControladorAutenticacao();
  BuildContext context;

  CorpoJanelaCadastro(){
    controladorAutenticacao.orientarTarefaBaixarListaTiposUsuario();
  }

  @override
  Widget build(BuildContext context) {
    this.context = context;
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: CampoTexto(
              campoBordado: false,
              icone: Icon(Icons.text_fields),
              dicaParaCampo: "Nome da Entidade",
              metodoChamadoNaInsersao: (String valor) {
                nome = valor;
                observadorCampoTexto.observarCampo(valor, TipoCampoTexto.nome);
                if (valor.isEmpty) {
                  observadorCampoTexto.mudarValorValido(
                      true, TipoCampoTexto.nome);
                }
                observadorButoes.mudarValorFinalizarCadastroInstituicao([nome, email, valorSeleccionadoMenuDropDown, palavraPasse, confirmePalavraPasse],[observadorCampoTexto.valorNomeValido, observadorCampoTexto.valorEmailValido, observadorCampoTexto.valorPalavraPasseValido, observadorCampoTexto2.valorPalavraPasseValido]);
              },
            ),
          ),
          Observer(builder: (_) {
            return observadorCampoTexto.valorNomeValido == true
                ? Container()
                : LabelErros(
                    sms: "Este Nome de Entidade ainda é inválido!",
                  );
          }),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: CampoTexto(
              campoBordado: false,
              icone: Icon(Icons.email),
              dicaParaCampo: "Email da Entidade",
              metodoChamadoNaInsersao: (String valor) {
                email = valor;
                observadorCampoTexto.observarCampo(valor, TipoCampoTexto.email);
                if (valor.isEmpty) {
                  observadorCampoTexto.mudarValorValido(
                      true, TipoCampoTexto.email);
                }
                observadorButoes.mudarValorFinalizarCadastroInstituicao([nome, email, valorSeleccionadoMenuDropDown, palavraPasse, confirmePalavraPasse],[observadorCampoTexto.valorNomeValido, observadorCampoTexto.valorEmailValido, observadorCampoTexto.valorPalavraPasseValido, observadorCampoTexto2.valorPalavraPasseValido]);
              },
            ),
          ),
          Observer(builder: (_) {
            return observadorCampoTexto.valorEmailValido == true
                ? Container()
                : LabelErros(
                    sms: "Este email ainda é inválido!",
                  );
          }),
          SizedBox(
            height: 10,
          ),
          Observer(builder: (_) {
            return observadorSistema.mudadoraEstadoDoSistema is Map && observadorSistema.mudadoraEstadoDoSistema != null && observadorSistema.mudadoraEstadoDoSistema["nome"] == "mapa_lista_tipos_instituicao"
                ? 
                MenuDropDown(
                  metodoChamadoNaInsersao: (valorSeleccionado){
                    valorSeleccionadoMenuDropDown = valorSeleccionado;
                    observadorButoes.mudarValorFinalizarCadastroInstituicao([nome, email, valorSeleccionadoMenuDropDown, palavraPasse, confirmePalavraPasse],[observadorCampoTexto.valorNomeValido, observadorCampoTexto.valorEmailValido, observadorCampoTexto.valorPalavraPasseValido, observadorCampoTexto2.valorPalavraPasseValido]);
                  },
                  labelMenuDropDown: "Selecione o tipo de Entidade",
                  listaItens:
                      observadorSistema.mudadoraEstadoDoSistema["lista"],
                )
                :
                  observadorSistema.listaTipoInstituicaoDeReserva.isEmpty 
                  ?
                  Container(
                      width: MediaQuery.of(context).size.width * .5,
                      child: LinearProgressIndicator())
                  :    
                  MenuDropDown(
                    metodoChamadoNaInsersao: (valorSeleccionado){
                      valorSeleccionadoMenuDropDown = valorSeleccionado;
                      observadorButoes.mudarValorFinalizarCadastroInstituicao([nome, email, valorSeleccionadoMenuDropDown, palavraPasse, confirmePalavraPasse],[observadorCampoTexto.valorNomeValido, observadorCampoTexto.valorEmailValido, observadorCampoTexto.valorPalavraPasseValido, observadorCampoTexto2.valorPalavraPasseValido]);
                    },
                    labelMenuDropDown: "Selecione o tipo de Entidade",
                    listaItens:
                        observadorSistema.listaTipoInstituicaoDeReserva,
                  );
          }),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: CampoTexto(
              campoBordado: false,
              icone: Icon(Icons.lock),
              tipoCampoTexto: TipoCampoTexto.palavra_passe,
              dicaParaCampo: "Palavra-Passe",
              metodoChamadoNaInsersao: (String valor) {
                palavraPasse= valor;
                observadorCampoTexto.observarCampo(
                    valor, TipoCampoTexto.palavra_passe);
                if (valor.isEmpty) {
                  observadorCampoTexto.mudarValorValido(
                      true, TipoCampoTexto.palavra_passe);
                }
                observadorButoes.mudarValorFinalizarCadastroInstituicao([nome, email, valorSeleccionadoMenuDropDown, palavraPasse, confirmePalavraPasse],[observadorCampoTexto.valorNomeValido, observadorCampoTexto.valorEmailValido, observadorCampoTexto.valorPalavraPasseValido, observadorCampoTexto2.valorPalavraPasseValido]);
              },
            ),
          ),
          Observer(builder: (_) {
            return observadorCampoTexto.valorPalavraPasseValido == true
                ? Container()
                : LabelErros(
                    sms: "A palavra-passe deve ter mais de 7 caracteres!",
                  );
          }),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: CampoTexto(
              campoBordado: false,
              icone: Icon(Icons.lock),
              tipoCampoTexto: TipoCampoTexto.palavra_passe,
              dicaParaCampo: "Confirmar Palavra-Passe",
              metodoChamadoNaInsersao: (String valor) {
                confirmePalavraPasse = valor;
                observadorCampoTexto2.observarCampo(
                    valor, TipoCampoTexto.palavra_passe);
                if (valor.isEmpty) {
                  observadorCampoTexto2.mudarValorValido(
                      true, TipoCampoTexto.palavra_passe);
                }
                observadorButoes.mudarValorFinalizarCadastroInstituicao([nome, email, valorSeleccionadoMenuDropDown, palavraPasse, confirmePalavraPasse],[observadorCampoTexto.valorNomeValido, observadorCampoTexto.valorEmailValido, observadorCampoTexto.valorPalavraPasseValido, observadorCampoTexto2.valorPalavraPasseValido, palavraPasse == confirmePalavraPasse]);
              },
            ),
          ),
          Observer(builder: (_) {
            return observadorCampoTexto2.valorPalavraPasseValido == true
                ? Container()
                : LabelErros(
                    sms: "Esta palavra-passe de ser igual ao campo anterior!",
                  );
          }),
          SizedBox(
            height: 10,
          ),
          Observer(builder: (_) {
            return Container(
              width: MediaQuery.of(context).size.width * .7,
              child: Butao(
                butaoHabilitado:observadorButoes.butaoFinalizarCadastroInstituicao,
                tituloButao: "Finalizar",
                metodoChamadoNoClique:()async{
                  if(observadorSistema.loginSistemaFeito == true){
                    observadorSistema.mudarValorDaMudadoraEstadoDoSistema("pedido_adesao_em_processo");
                    if(await obeterConexaoInternet()){
                      finalizar();
                    }
                  }else{
                    observadorSistema.mudarValorDaMudadoraEstadoDoSistema("sistema_nao_autenticado");
                  }
                },
              ),
            );
          }),
          SizedBox(
            height: 20,
          ),
          Container(
              width: MediaQuery.of(context).size.width * .7,
              child: Butao(
                butaoHabilitado:true,
                tituloButao: "Voltar",
                metodoChamadoNoClique:(){
                  observadorSistema.mudarValorDaMudadoraJanelasDoAplicativo("ir_para_janela_login");
                },
              ),
            )
        ],
      ),
    );
  }

  finalizar()async{
    if(await obeterConexaoInternet()){
      var usuario = Usuario(
        nomeUsuario: nome,
        emailUsuario: email,
        palavraPasse: palavraPasse,
        tipoUsuario: valorSeleccionadoMenuDropDown,
        posicaoNaLista: -1
      );
      observadorSistema.mudarValorUsuarioActual(usuario);
      controladorAutenticacao.orientarTarefaValidacaoPedidoCadastroUsuario();
    }
  }
}
