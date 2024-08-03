import 'package:app_farmacia/model/categoria_medicamento.dart';

class ValidaFormProdutos{
  static String? validaCampo<T>(T? campo) {
  if (campo == null) {
    return 'Esse campo é obrigatório';
  }

  if (campo is String) {
    if (campo.trim().isEmpty) {
      return 'Esse campo é obrigatório';
    }
    if (campo.trim().length < 3) {
      return 'Esse campo precisa no mínimo de 3 letras.';
    }
  }

  if (campo is num) {
    if (campo == 0) {
      return 'Informe um valor valido!';
    }
  }

  if(campo is CategoriaMedicamento){}

  return null;
}
}