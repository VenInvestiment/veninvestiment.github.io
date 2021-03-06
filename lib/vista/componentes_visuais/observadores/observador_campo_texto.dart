import 'package:mobx/mobx.dart';
import 'package:oku_sanga/vista/componentes_visuais/observadores/validadores/validadcao_campos.dart';
part 'observador_campo_texto.g.dart';

class ObservadorCampoTexto = _ObservadorCampoTextoBase with _$ObservadorCampoTexto;

abstract class _ObservadorCampoTextoBase with Store {
  @observable
  bool valorEmailValido = true;
  @observable
  bool valorPalavraPasseValido = true;
  @observable
  bool valorNomeValido = true;
  ValidacaoCampos _validacaoCampos;

  _ObservadorCampoTextoBase(){
    _validacaoCampos = ValidacaoCampos();
  }

  @action
  observarCampo(String valor, TipoCampoTexto tipoCampoTexto){
    if(tipoCampoTexto == TipoCampoTexto.email){
      valorEmailValido = _validacaoCampos.validarEmail(valor);
    }else if(tipoCampoTexto == TipoCampoTexto.palavra_passe){
      valorPalavraPasseValido = _validacaoCampos.validarPalavraPasse(valor);
    }else if(tipoCampoTexto == TipoCampoTexto.nome){
      valorNomeValido = _validacaoCampos.validarNome(valor);
    }
  }

  @action
  observarCampoAlteracaoPalavraPasse(List<String> lista_palavra_passe_e_antiga, TipoCampoTexto tipoCampoTexto){
    valorPalavraPasseValido = _validacaoCampos.validarAlteracaoPalavraPasse(lista_palavra_passe_e_antiga);
  }

  @action
  mudarValorValido(bool valor, TipoCampoTexto tipoCampoTexto){
    if(tipoCampoTexto == TipoCampoTexto.email){
      valorEmailValido = true;
    }else if(tipoCampoTexto == TipoCampoTexto.palavra_passe){
      valorPalavraPasseValido = true;
    }else if(tipoCampoTexto == TipoCampoTexto.nome){
      valorNomeValido = true;
    }
  }
}

