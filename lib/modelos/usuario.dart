class Usuario {
  String proprioLink;
  String areaBaseDadosDocentes;
  String areaBaseDadosEstudantes;
  String areaBaseDadosPlanoCurricular;
  int posicaoNaLista;
  String nomeUsuario;
  String emailUsuario;
  String imagemPerfil;
  String palavraPasse;
  String tipoUsuario;
  List<String> contactos;
  List<String> enderecos;

  Usuario(
      {this.proprioLink,
      this.areaBaseDadosDocentes,
      this.areaBaseDadosEstudantes,
      this.areaBaseDadosPlanoCurricular,
      this.posicaoNaLista,
      this.nomeUsuario,
      this.emailUsuario,
      this.imagemPerfil,
      this.palavraPasse,
      this.tipoUsuario,
      this.contactos,
      this.enderecos});

  Usuario.fromJson(Map<String, dynamic> json) {
    proprioLink = json['proprio_link'];
    areaBaseDadosDocentes = json['area_base_dados_docentes'];
    areaBaseDadosEstudantes = json['area_base_dados_estudantes'];
    areaBaseDadosPlanoCurricular = json['area_base_dados_plano_curricular'];
    posicaoNaLista = json['posicao_na_lista'];
    nomeUsuario = json['nome_usuario'];
    emailUsuario = json['email_usuario'];
    imagemPerfil = json['imagem_perfil'];
    palavraPasse = json['palavra_passe'];
    tipoUsuario = json['tipo_usuario'];
    contactos = json['contactos'].cast<String>();
    enderecos = json['enderecos'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['proprio_link'] = this.proprioLink;
    data['area_base_dados_docentes'] = this.areaBaseDadosDocentes;
    data['area_base_dados_estudantes'] = this.areaBaseDadosEstudantes;
    data['area_base_dados_plano_curricular'] =
        this.areaBaseDadosPlanoCurricular;
    data['posicao_na_lista'] = this.posicaoNaLista;
    data['nome_usuario'] = this.nomeUsuario;
    data['email_usuario'] = this.emailUsuario;
    data['imagem_perfil'] = this.imagemPerfil;
    data['palavra_passe'] = this.palavraPasse;
    data['tipo_usuario'] = this.tipoUsuario;
    data['contactos'] = this.contactos;
    data['enderecos'] = this.enderecos;
    return data;
  }
}
