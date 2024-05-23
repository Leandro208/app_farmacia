import 'package:app_farmacia/model/categoria_medicamento.dart';

class Produto {
  int? id;
  String nome;
  CategoriaMedicamento categoria;
  double preco;
  DateTime validade;
  int estoque;
  String fornecedor;

  Produto({
    this.id,
    required this.nome,
    required this.categoria,
    required this.preco,
    required this.validade,
    required this.estoque,
    required this.fornecedor,
  });
}