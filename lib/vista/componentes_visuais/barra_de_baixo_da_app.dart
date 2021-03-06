import 'package:flutter/material.dart';
import 'package:oku_sanga/recursos/contantes.dart';
import 'package:oku_sanga/solucoes_uteis/funcionais/provedor_codigo.dart';
import 'package:oku_sanga/vista/componentes_visuais/butao.dart';
import 'package:oku_sanga/vista/janelas/controladores/controlador_usuario.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:oku_sanga/vista/janelas/tipo_usuario/ensino_superior/sub_janelas_painel/sub_janela_plano_curricular.dart';

import 'package:stack/stack.dart' as estruturaDados;

class BarraBaixoDaApp extends StatelessWidget {
  BarraBaixoDaApp({
    this.shape,
  });

  final NotchedShape shape;

  static final centerLocations = <FloatingActionButtonLocation>[
    FloatingActionButtonLocation.centerDocked,
    FloatingActionButtonLocation.centerFloat,
  ];

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: COR_ACCENT,
      shape: shape,
      child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ButaoBarraBaixoApp(
              butaoNaoArredondado: false,
              corButao: COR_ACCENT,
              tituloButao: "Plano Curricular",
              icone: Icons.book,
              metodoChamadoNoClique: (){
                // REINICIANDO PILHA PARA NAO ACOMULA VALORES
                observadorSistema.limparPilhaElista();

                observadorSistema.mudarValorNivelNavegacaoActual({
                  "nivelNavegacao" : NivelNavegacao.periodos
                });
                
                observadorSistema.mudarValorMudadoraSubJanelasDoPainel("ir_para_sub_janela_plano_curricular");
                ControladorUsuario().orientarTarefaObterPlanoCurricular();
              },
            ),
            Spacer(),
            ButaoBarraBaixoApp(
              butaoNaoArredondado: false,
              corButao: COR_ACCENT,
              tituloButao: "Estudantes",
              icone: Icons.school,
              metodoChamadoNoClique: (){
                // REINICIANDO PILHA PARA NAO ACOMULA VALORES
                observadorSistema.limparPilhaElista();

                observadorSistema.mudarValorNivelNavegacaoActual({
                  "nivelNavegacao" : NivelNavegacao.periodos
                });
                
                observadorSistema.mudarValorMudadoraSubJanelasDoPainel("ir_para_sub_janela_estudantes");
                ControladorUsuario().orientarTarefaObterPlanoCurricular();
              },
            )
          ],
        )
    );
  }
}