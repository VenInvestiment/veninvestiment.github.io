import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:oku_sanga/modelos/usuario.dart';
import 'package:oku_sanga/recursos/contantes.dart';
import 'package:oku_sanga/repositorio/interface_repositorio.dart';
import 'package:oku_sanga/solucoes_uteis/funcionais/obtencao_conexao_na_net.dart';
import 'package:oku_sanga/solucoes_uteis/funcionais/provedor_codigo.dart';

import 'package:oku_sanga/vista/componentes_visuais/butao.dart';
import 'package:oku_sanga/vista/componentes_visuais/campo_texto.dart';
import 'package:oku_sanga/vista/componentes_visuais/janela_dialogos.dart';
import 'package:oku_sanga/vista/componentes_visuais/label_erros.dart';
import 'package:oku_sanga/vista/componentes_visuais/logo_no_circulo.dart';
import 'package:oku_sanga/vista/componentes_visuais/observadores/observador_butoes.dart';
import 'package:oku_sanga/vista/componentes_visuais/observadores/observador_campo_texto.dart';
import 'package:oku_sanga/vista/componentes_visuais/observadores/validadores/validadcao_campos.dart';
import 'package:oku_sanga/vista/componentes_visuais/rota.dart';
import 'package:oku_sanga/vista/janelas/controladores/controlador_autenticacao.dart';
import 'package:oku_sanga/vista/janelas/janela_cadastro.dart';

class JanelaLogin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Login")),
      body: CorpoJanelaLogin(),
    );
  }
}

class CorpoJanelaLogin extends StatelessWidget {
  CorpoJanelaLogin();
  ObservadorCampoTexto observadorCampoTexto = ObservadorCampoTexto();
  ObservadorButoes observadorButoes = ObservadorButoes();
  String email = "", palavraPasse  = "";
  ControladorAutenticacao controladorServicosSistema = ControladorAutenticacao();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(child: LogoNoCirculo()),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: CampoTexto(
              campoBordado: false,
              icone: Icon(Icons.email),
              dicaParaCampo: "Email",
              metodoChamadoNaInsersao: (String valor) {
                email = valor;
                observadorCampoTexto.observarCampo(valor, TipoCampoTexto.email);
                if (valor.isEmpty) {
                  observadorCampoTexto.mudarValorValido(
                      true, TipoCampoTexto.email);
                }
                observadorButoes.mudarValorFinalizarCadastroInstituicao([email, palavraPasse],[observadorCampoTexto.valorEmailValido, observadorCampoTexto.valorPalavraPasseValido]);
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: CampoTexto(
              campoBordado: false,
              icone: Icon(Icons.lock),
              tipoCampoTexto: TipoCampoTexto.palavra_passe,
              dicaParaCampo: "Palavra-Passe",
              metodoChamadoNaInsersao: (String valor) {
                palavraPasse = valor;
                observadorCampoTexto.observarCampo(
                    valor, TipoCampoTexto.palavra_passe);
                if (valor.isEmpty) {
                  observadorCampoTexto.mudarValorValido(
                      true, TipoCampoTexto.palavra_passe);
                }
                observadorButoes.mudarValorFinalizarCadastroInstituicao([email, palavraPasse],[observadorCampoTexto.valorEmailValido, observadorCampoTexto.valorPalavraPasseValido]);
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
          Container(
            width: MediaQuery.of(context).size.width * .7,
            child: Observer(builder: (_) {
              return Butao(
                butaoHabilitado: observadorButoes.butaoFinalizarCadastroInstituicao,
                tituloButao: "Entrar",
                metodoChamadoNoClique: ()async {
                  if(observadorSistema.loginSistemaFeito == true){
                    observadorSistema.mudarValorDaMudadoraEstadoDoSistema("fazendo_login");
                    if(await obeterConexaoInternet()){
                      fazerLogin();
                    }
                  }else{
                    observadorSistema.mudarValorDaMudadoraEstadoDoSistema("sistema_nao_autenticado");
                  }
                },
              );
            }),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            width: MediaQuery.of(context).size.width * .7,
            child: Butao(
              icone: Icons.qr_code,
              tituloButao: "Entrar com QR",
              metodoChamadoNoClique: () {
                observadorSistema.mudarValorUsuarioActual(Usuario(
                  emailUsuario: "veninvestiment@gmail.com",
                  palavraPasse: "11111111"
                ));
                observadorSistema.mudarValorDaMudadoraEstadoDoSistema("fazendo_login");
                controladorServicosSistema.orientarTarefaLogarUsuario();
              },
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Text("Ou"),
          SizedBox(
            height: 10,
          ),
          Container(
            width: MediaQuery.of(context).size.width * .7,
            child: Butao(
              corButao: COR_ACCENT,
              tituloButao: "Cadastrar-se",
              metodoChamadoNoClique: () {
                if (observadorSistema.loginSistemaFeito == true) {
                  observadorSistema.mudarValorDaMudadoraJanelasDoAplicativo("ir_para_janela_cadastro");
                } else {
                  gerarDialogoComUmaAccaoDeSaida(context,
                      "O sistema não foi autenticado ainda!\nFeche a App e inicie novamente!");
                }
              },
            ),
          ),
          SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }

  fazerLogin(){
    observadorSistema.mudarValorUsuarioActual(Usuario(
      emailUsuario: email,
      palavraPasse: palavraPasse
    ));
    controladorServicosSistema.orientarTarefaLogarUsuario();
  }
}
