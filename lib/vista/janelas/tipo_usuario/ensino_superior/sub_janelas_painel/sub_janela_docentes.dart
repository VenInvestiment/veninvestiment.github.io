import 'package:flutter/material.dart';
import 'package:oku_sanga/modelos/base_dados_docentes.dart';
import 'package:oku_sanga/recursos/contantes.dart';
import 'package:oku_sanga/solucoes_uteis/funcionais/provedor_codigo.dart';
import 'package:oku_sanga/vista/componentes_visuais/janela_dialogos.dart';
import 'package:oku_sanga/vista/componentes_visuais/sub_app_bar.dart';
import 'package:oku_sanga/vista/janelas/janela_perfil_usuario.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:expandable/expandable.dart';

class SubJanelaManipulacaoDocentes extends StatelessWidget {
  const SubJanelaManipulacaoDocentes({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          gerarSubAppBar(context, "Docentes"),
          Padding(
            padding: const EdgeInsets.only(top: 20, left:20, right: 20),
            child: Text("Nome: ${observadorSistema.bancoDadosDocentes.pegarDocenteNaBaseDados(observadorSistema.bancoDadosDocentes.emailDocenteActual).nomeDocente}"),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Text("Cadeiras:"),
          ),
          ListaCadeiras(),
        ],
      ),
    );
  }
}

class ListaCadeiras extends StatelessWidget {
  List<Cadeiras> listaCadeiras = observadorSistema.bancoDadosDocentes.pegarDocenteNaBaseDados(observadorSistema.bancoDadosDocentes.emailDocenteActual).cadeiras;
  ListaCadeiras({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(bottom: 20, left: 20, right: 20, top: 0),
        height: MediaQuery.of(context).size.height * 0.7,
        child: Observer(builder: (_) {
          // ESTA LINHA FOI POSTA AQUI APENAS PARA OObserver TER UMA VAR 
          // OBSERVAVEL DENTRO DO ESCOPO DELE
          observadorSistema.mudarValorBancoDadosDocentes(observadorSistema.bancoDadosDocentes);

          if(listaCadeiras == null || listaCadeiras.length == 0){
            return Center(child: Text("Nenhuma cadeira adicionada!", textAlign: TextAlign.center,),);
          }
          return ListView(
            children: List.generate(
              listaCadeiras.length,
              (index) => Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                margin: EdgeInsets.all(8),
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: CadaCadeiraDeUmDocente(listaCadeiras: listaCadeiras,index: index),                  
                ),
              )
            ),
          );
        }));
  }
}

class CadaCadeiraDeUmDocente extends StatelessWidget {
  const CadaCadeiraDeUmDocente({
    Key key,
    @required this.listaCadeiras, this.index,
  }) : super(key: key);

  final List<Cadeiras> listaCadeiras;
  final int index;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap:(){

      },
      child: ExpandablePanel(
        tapHeaderToExpand: true,
        header: CabecalhoItem(listaCadeiras: listaCadeiras, index: index),
        expanded: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Divider(color: COR_PRIMARIA,),
            Text("Período: ${listaCadeiras[index].periodo}"),
            Text("Curso: ${listaCadeiras[index].curso}"),
            Text("Ano: ${listaCadeiras[index].ano}"),
            Text("Semestre: ${listaCadeiras[index].semestre}"),
            Text("Cadeira Sucessora: ${listaCadeiras[index].nomeCadeiraSucessora == "sem_proxima_cadeira" ? "Sem Cadeira" : listaCadeiras[index].nomeCadeiraSucessora}"),
          ],
        ),
      ),
    );
  }
}

class CabecalhoItem extends StatelessWidget {
  const CabecalhoItem({
    Key key,
    @required this.listaCadeiras,
    @required this.index,
  }) : super(key: key);

  final List<Cadeiras> listaCadeiras;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.max,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Text("${listaCadeiras[index].nomeCadeira}"),
        ),
        InkWell(
          onTap: (){
            gerarDialogoRemover(context, TipoDadoEmRemocao.cadeiraDeDocente, cadeira: listaCadeiras[index]);
          },
          child: Padding(
            padding: const EdgeInsets.only(right: 10, top: 10),
            child: Icon(
              Icons.delete,
              color: COR_ACCENT,
            ),
          )
        )
      ],
    );
  }
}