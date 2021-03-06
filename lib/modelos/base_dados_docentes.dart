import 'dart:developer';

import 'package:oku_sanga/solucoes_uteis/funcionais/provedor_codigo.dart';
import 'package:fluttertoast/fluttertoast.dart';

class BaseDadosDocentes {
  String nome, emailDocenteActual;
  String proprioLink;
  List<Docentes> docentes;

  BaseDadosDocentes({this.nome, this.proprioLink, this.docentes});

  BaseDadosDocentes.fromJson(Map<String, dynamic> json) {
    nome = json['nome'];
    proprioLink = json['proprio_link'];
    if (json['docentes'] != null) {
      docentes = new List<Docentes>();
      json['docentes'].forEach((v) {
        docentes.add(new Docentes.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['nome'] = this.nome;
    data['proprio_link'] = this.proprioLink;
    if (this.docentes != null) {
      data['docentes'] = this.docentes.map((v) => v.toJson()).toList();
    }
    return data;
  }

  bool verificarExistenciaDocenteNaBaseDados(String emailDocente){
    bool controlador = false;
    observadorSistema.bancoDadosDocentes.docentes.forEach((element) {
      if(element.emailDocente == emailDocente){
        controlador = true;
      }
    });
    return controlador;
  }

  Docentes pegarDocenteNaBaseDados(String emailDocente){
    return observadorSistema.bancoDadosDocentes.docentes.firstWhere((element) => element.emailDocente == emailDocente);
  }

  void eliminarDocenteNaBaseDados(String emailDocente){
    observadorSistema.bancoDadosDocentes.docentes.removeWhere((element) => element.emailDocente == emailDocente);
  }

  void mudarValorEmailDocenteActual(String emailDocente){
    emailDocenteActual = emailDocente;
  }
}

class Docentes {
  String emailDocente;
  String areaDocente;
  String nomeDocente;
  List<Cadeiras> cadeiras;

  Docentes(
      {this.emailDocente, this.areaDocente, this.nomeDocente, this.cadeiras});

  Docentes.fromJson(Map<String, dynamic> json) {
    emailDocente = json['email_docente'];
    areaDocente = json['area_docente'];
    nomeDocente = json['nome_docente'];
    if (json['cadeiras'] != null) {
      cadeiras = new List<Cadeiras>();
      json['cadeiras'].forEach((v) {
        cadeiras.add(new Cadeiras.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['email_docente'] = this.emailDocente;
    data['area_docente'] = this.areaDocente;
    data['nome_docente'] = this.nomeDocente;
    if (this.cadeiras != null) {
      data['cadeiras'] = this.cadeiras.map((v) => v.toJson()).toList();
    }
    return data;
  }

  bool verificarExistenciaCadeira(Cadeiras cadeira){
    bool controlador = false;
    if(cadeiras != null){
      cadeiras.forEach((element) {
        print("cadeira: ${cadeira.toJson()}");
        print("element: ${element.toJson()}");
        print("Teste: ${element.toJson().toString() == cadeira.toJson().toString()}");
        if(element.toJson().toString() == cadeira.toJson().toString()){
          controlador = true;
        }
      });
    }else{
      cadeiras = [];
    }
    return controlador;
  }

  void eliminarCadeira(Cadeiras cadeira){
    cadeiras.removeWhere((element) => element.toJson().toString() == cadeira.toJson().toString());
  }
}

class Cadeiras {
  String nomeCadeira;
  String nomeCadeiraSucessora;
  String periodo;
  String curso;
  String ano;
  String semestre;

  Cadeiras(
      {this.nomeCadeira,
      this.nomeCadeiraSucessora,
      this.periodo,
      this.curso,
      this.ano,
      this.semestre});

  Cadeiras.fromJson(Map<String, dynamic> json) {
    nomeCadeira = json['nome_cadeira'];
    nomeCadeiraSucessora = json['nome_cadeira_sucessora'];
    periodo = json['periodo'];
    curso = json['curso'];
    ano = json['ano'];
    semestre = json['semestre'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['nome_cadeira'] = this.nomeCadeira;
    data['nome_cadeira_sucessora'] = this.nomeCadeiraSucessora;
    data['periodo'] = this.periodo;
    data['curso'] = this.curso;
    data['ano'] = this.ano;
    data['semestre'] = this.semestre;
    return data;
  }
}