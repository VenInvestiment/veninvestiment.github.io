import 'package:flutter/material.dart';
import 'package:oku_sanga/modelos/base_dados_docentes.dart';
import 'package:oku_sanga/recursos/contantes.dart';
import 'package:oku_sanga/solucoes_uteis/funcionais/provedor_codigo.dart';
import 'package:oku_sanga/vista/componentes_visuais/campo_texto.dart';
import 'package:oku_sanga/vista/componentes_visuais/indicador_processo_execucao.dart';
import 'package:oku_sanga/vista/componentes_visuais/janela_dialogos.dart';
import 'package:oku_sanga/vista/janelas/controladores/controlador_usuario.dart';
import 'package:oku_sanga/vista/janelas/janela_perfil_usuario.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class SubJanelaPrincipal extends StatelessWidget {
  const SubJanelaPrincipal({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IndicadorProcessoEmExecucao(),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: CampoTexto(
              icone: Icon(Icons.search),
              campoBordado: false,
              dicaParaCampo: "Pesquisar",
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 30),
            child: Text("Docentes"),
          ),
          ListaDocentes()
        ],
      ),
    );
  }
}

class ListaDocentes extends StatelessWidget {
  ListaDocentes({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(bottom: 20, left: 20, right: 20, top: 0),
        height: MediaQuery.of(context).size.height * 0.7,
        child: Observer(builder: (_) {
          if(observadorSistema.bancoDadosDocentes == null || observadorSistema.bancoDadosDocentes.docentes == null){
            return Center(child: Text("Carregando...", textAlign: TextAlign.center,),);
          }else if(observadorSistema.bancoDadosDocentes.docentes.length == 0){
            return Center(child: Text("Nenhum docente adicionado!", textAlign: TextAlign.center,),);
          }
          return ListView(
            children: List.generate(
              observadorSistema.bancoDadosDocentes == null ? 0 : observadorSistema.bancoDadosDocentes.docentes.length,
              (index) => Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                margin: EdgeInsets.all(8),
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: InkWell(
                    onTap:(){
                      observadorSistema.bancoDadosDocentes.mudarValorEmailDocenteActual(observadorSistema.bancoDadosDocentes.docentes[index].emailDocente);
                      observadorSistema.mudarValorMudadoraSubJanelasDoPainel("ir_para_sub_janela_docentes");
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text("${observadorSistema.bancoDadosDocentes.docentes[index].nomeDocente}"),
                        InkWell(
                          onTap: (){
                            gerarDialogoRemover(context, TipoDadoEmRemocao.docente, emailDocente: observadorSistema.bancoDadosDocentes.docentes[index].emailDocente);
                          },
                          child: Icon(
                            Icons.delete,
                            color: COR_ACCENT,
                          )
                        )
                      ],
                    ),
                  ),                  
                ),
              )
            ),
          );
        }));
  }
}