import 'dart:developer';

import 'package:oku_sanga/solucoes_uteis/funcionais/provedor_codigo.dart';

class PlanoCurricular {
  String nome;
  String instituicao;
  String proprioLink;
  List<Periodos> periodos;

  PlanoCurricular(
      {this.nome, this.instituicao, this.proprioLink, this.periodos});

  static dynamic pegarObjectoComBaseCaminhoAteUltimoNivel(){
    log("Tamanho da Lista: ${observadorSistema.listaCaminhosAteNivelActual.length} -- Valores na lista: ${observadorSistema.listaCaminhosAteNivelActual[0]}");
    dynamic objecto;
    if(observadorSistema.listaCaminhosAteNivelActual.length == 1){
      objecto = Periodos.pegarPeriodoDeNome(observadorSistema.listaCaminhosAteNivelActual[0]);
    }else if(observadorSistema.listaCaminhosAteNivelActual.length == 2){
      Periodos.pegarPeriodoDeNome(observadorSistema.listaCaminhosAteNivelActual[0]).cursos.forEach((element) {
        if(element.curso == observadorSistema.listaCaminhosAteNivelActual[1]){
          objecto = element;
        }
      });
    }else if(observadorSistema.listaCaminhosAteNivelActual.length == 3){
      Periodos.pegarPeriodoDeNome(observadorSistema.listaCaminhosAteNivelActual[0]).cursos.forEach((element) {
        if(element.curso == observadorSistema.listaCaminhosAteNivelActual[1]){
          element.anos.forEach((element) {
            if(element.ano == observadorSistema.listaCaminhosAteNivelActual[2]){
              objecto = element;
            }
          });
        }
      });
    }else if(observadorSistema.listaCaminhosAteNivelActual.length == 4){
      Periodos.pegarPeriodoDeNome(observadorSistema.listaCaminhosAteNivelActual[0]).cursos.forEach((element) {
        if(element.curso == observadorSistema.listaCaminhosAteNivelActual[1]){
          element.anos.forEach((element) {
            if(element.ano == observadorSistema.listaCaminhosAteNivelActual[2]){
              element.semestres.forEach((element) {
                if(element.semestre == observadorSistema.listaCaminhosAteNivelActual[3]){
                  objecto = element;
                }
              });
            }
          });
        }
      });
    }else if(observadorSistema.listaCaminhosAteNivelActual.length == 5){
      Periodos.pegarPeriodoDeNome(observadorSistema.listaCaminhosAteNivelActual[0]).cursos.forEach((element) {
        if(element.curso == observadorSistema.listaCaminhosAteNivelActual[1]){
          element.anos.forEach((element) {
            if(element.ano == observadorSistema.listaCaminhosAteNivelActual[2]){
              element.semestres.forEach((element) {
                if(element.semestre == observadorSistema.listaCaminhosAteNivelActual[3]){
                  element.cadeiras.forEach((element) {
                    if(element.cadeira == observadorSistema.listaCaminhosAteNivelActual[3]){
                      objecto = element;
                    }
                  });
                }
              });
            }
          });
        }
      });
    }
    return objecto;
  }

  PlanoCurricular.fromJson(Map<String, dynamic> json) {
    nome = json['nome'];
    instituicao = json['instituicao'];
    proprioLink = json['proprio_link'];
    if (json['periodos'] != null) {
      periodos = new List<Periodos>();
      json['periodos'].forEach((v) {
        periodos.add(new Periodos.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['nome'] = this.nome;
    data['instituicao'] = this.instituicao;
    data['proprio_link'] = this.proprioLink;
    if (this.periodos != null) {
      data['periodos'] = this.periodos.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Periodos {
  String periodo;
  List<Cursos> cursos;

  Periodos({this.periodo, this.cursos});

  Periodos.fromJson(Map<String, dynamic> json) {
    periodo = json['periodo'];
    if (json['cursos'] != null) {
      cursos = new List<Cursos>();
      json['cursos'].forEach((v) {
        cursos.add(new Cursos.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['periodo'] = this.periodo;
    if (this.cursos != null) {
      data['cursos'] = this.cursos.map((v) => v.toJson()).toList();
    }
    return data;
  }

  static bool verificarExistenciaPeriodo(String periodo){
    bool verificacao = false;
    if(observadorSistema.planoCurricular.periodos == null){
      verificacao = false;
    }else{
      observadorSistema.planoCurricular.periodos.forEach((element) {
        if(element.periodo == periodo){
          verificacao = true;
        }
      });
    }
    return verificacao;
  }

  static Periodos pegarPeriodoDeNome(String periodo){
    Periodos verificacao;
    observadorSistema.planoCurricular.periodos.forEach((element) {
      if(element.periodo == periodo){
        verificacao = element;
      }
    });
    return verificacao;
  }
}

class Cursos {
  String curso;
  List<Anos> anos;

  Cursos({this.curso, this.anos});

  static bool verificarExistenciaCurso(String curso, String periodo){
    bool verificacao = false;
    List lista = Periodos.pegarPeriodoDeNome(periodo).cursos;
    if(lista == null){
      verificacao = false;
    }else{
      (lista as List<Cursos>).forEach((element) {
        if(element.curso == curso){
          verificacao = true;
        }
      });
    }
    return verificacao;
  }

  Cursos.fromJson(Map<String, dynamic> json) {
    curso = json['curso'];
    if (json['anos'] != null) {
      anos = new List<Anos>();
      json['anos'].forEach((v) {
        anos.add(new Anos.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['curso'] = this.curso;
    if (this.anos != null) {
      data['anos'] = this.anos.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Anos {
  String ano;
  List<Semestres> semestres;

  Anos({this.ano, this.semestres});

  static bool verificarExistenciaAno(String anoP){
    bool verificacao = false;
    Periodos.pegarPeriodoDeNome(observadorSistema.listaCaminhosAteNivelActual[0]).cursos.forEach((element) {
      if(element.curso == observadorSistema.listaCaminhosAteNivelActual[1]){
        if(element.anos != null){
          element.anos.forEach((element) {
            if(element.ano == anoP){
              verificacao = true;
            }
          });
        }
      }
    });
    return verificacao;
  }

  Anos.fromJson(Map<String, dynamic> json) {
    ano = json['ano'];
    if (json['semestres'] != null) {
      semestres = new List<Semestres>();
      json['semestres'].forEach((v) {
        semestres.add(new Semestres.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ano'] = this.ano;
    if (this.semestres != null) {
      data['semestres'] = this.semestres.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Semestres {
  String semestre;
  List<Cadeiras> cadeiras;

  Semestres({this.semestre, this.cadeiras});

  static bool verificarExistenciaSemestre(String semestreP){
    bool verificacao = false;
    Periodos.pegarPeriodoDeNome(observadorSistema.listaCaminhosAteNivelActual[0]).cursos.forEach((element) {
      if(element.curso == observadorSistema.listaCaminhosAteNivelActual[1]){
        element.anos.forEach((element) {
          if(element.ano == observadorSistema.listaCaminhosAteNivelActual[2]){
            if(element.semestres != null){
              element.semestres.forEach((element) {
                if(element.semestre == semestreP){
                  verificacao = true;
                }
              });
            }
          }
        });
      }
    });
    return verificacao;
  }

  Semestres.fromJson(Map<String, dynamic> json) {
    semestre = json['semestre'];
    if (json['cadeiras'] != null) {
      cadeiras = new List<Cadeiras>();
      json['cadeiras'].forEach((v) {
        cadeiras.add(new Cadeiras.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['semestre'] = this.semestre;
    if (this.cadeiras != null) {
      data['cadeiras'] = this.cadeiras.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Cadeiras {
  String cadeira;
  String proximaCadeira;

  Cadeiras({this.cadeira, this.proximaCadeira});

  static bool verificarExistenciaCadeira(String cadeiraP){
    bool verificacao = false;
    Periodos.pegarPeriodoDeNome(observadorSistema.listaCaminhosAteNivelActual[0]).cursos.forEach((element) {
      if(element.curso == observadorSistema.listaCaminhosAteNivelActual[1]){
        element.anos.forEach((element) {
          if(element.ano == observadorSistema.listaCaminhosAteNivelActual[2]){
            element.semestres.forEach((element) {
              if(element.semestre == observadorSistema.listaCaminhosAteNivelActual[3]){
                if(element.cadeiras != null){
                  element.cadeiras.forEach((element) {
                    if(element.cadeira == cadeiraP){
                      verificacao = true;
                    }
                  });
                }
              }
            });
          }
        });
      }
    });
    return verificacao;
  }

  Cadeiras.fromJson(Map<String, dynamic> json) {
    cadeira = json['cadeira'];
    proximaCadeira = json['proxima_cadeira'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cadeira'] = this.cadeira;
    data['proxima_cadeira'] = this.proximaCadeira;
    return data;
  }
}
