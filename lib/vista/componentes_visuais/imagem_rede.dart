import 'package:flutter/material.dart';

class ImagemRede extends StatelessWidget{
  String link_imagem;
  double altura, largura, alturaErro, larguraErro, tamanhoTextoErro,tamanhoImogiErro;
  ImagemRede({this.link_imagem, this.largura, this.altura, this.larguraErro, this.alturaErro, this.tamanhoTextoErro, this.tamanhoImogiErro});
  @override
  Widget build(BuildContext context) {
    return Image.network(
      link_imagem,
      fit: BoxFit.fill,
      loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent loadingProgress) {
            if (loadingProgress == null)
              return child;
            return Container(
              height: altura,
              width: largura,
              child: Center(
              child: CircularProgressIndicator(
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes
                      : null,
              ),
              ),
            );
        },
        errorBuilder: (BuildContext context, Object exception, StackTrace stackTrace) {
          return Container(
            color: Colors.black54,
            height: alturaErro,
            width: larguraErro,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: TextStyle(fontSize: tamanhoTextoErro, fontWeight: FontWeight.bold, color: Colors.black),
                  children: [
                    TextSpan(text: '😢', style: TextStyle(fontSize: tamanhoImogiErro,)),
                    TextSpan(text: "\nImagem indisponível!", style: TextStyle(color: Colors.red)),
                  ]
                ),
              )),
            ),
          );
        }
      );
  }

}