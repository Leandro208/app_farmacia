// ignore_for_file: public_member_api_docs, sort_constructors_first
import "package:app_farmacia/model/categoria_medicamento.dart";

class Produto {
  String id;
  String nome;
  CategoriaMedicamento categoria;
  double preco;
  DateTime validade;
  int estoque;
  String fornecedor;
  int quantidadeVendida;
  Produto({
    required this.id,
    required this.nome,
    required this.categoria,
    required this.preco,
    required this.validade,
    required this.estoque,
    required this.fornecedor,
    this.quantidadeVendida = 0,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      "id": id,
      "nome": nome,
      "categoria": categoria.toJson(),
      "preco": preco,
      "validade": validade.millisecondsSinceEpoch,
      "estoque": estoque,
      "fornecedor": fornecedor,
      "quantidadeVendida": quantidadeVendida,
    };
  }

  factory Produto.fromJson(Map<String, dynamic> map) {
    return Produto(
      id: map["id"] as String,
      nome: map["nome"] as String,
      categoria: CategoriaMedicamento.values
          .firstWhere((e) => e.toString().split(".").last == map["categoria"]),
      preco: map["preco"] as double,
      validade: DateTime.fromMillisecondsSinceEpoch(map["validade"] as int),
      estoque: map["estoque"] as int,
      fornecedor: map["fornecedor"] as String,
      quantidadeVendida: map["quantidadeVendida"] as int,
    );
  }
}

class ProdutoPost {
  List listaProduto;
  String dataVenda;
  ProdutoPost({
    required this.listaProduto,
    required this.dataVenda,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      "listaProduto": listaProduto.map((x) => x.toJson()).toList(),
      "dataVenda": dataVenda,
    };
  }

  factory ProdutoPost.fromJson(Map<String, dynamic> map) {
    return ProdutoPost(
      listaProduto: List<Produto>.from(
        (map['listaProduto'] as List).map<Produto>(
          (x) => Produto.fromJson(x as Map<String, dynamic>),
        ),
      ),
      dataVenda: map['dataVenda'] as String,
    );
  }
}

class Teste {
  ProdutoPost produtoPost;
  Teste({
    required this.produtoPost,
  });

  Teste copyWith({
    ProdutoPost? produtoPost,
  }) {
    return Teste(
      produtoPost: produtoPost ?? this.produtoPost,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'produtoPost': produtoPost.toJson(),
    };
  }

  factory Teste.fromJson(Map<String, dynamic> map) {
    return Teste(
      produtoPost:
          ProdutoPost.fromJson(map['produtoPost'] as Map<String, dynamic>),
    );
  }

  @override
  String toString() => 'Teste(produtoPost: $produtoPost)';

  @override
  bool operator ==(covariant Teste other) {
    if (identical(this, other)) return true;

    return other.produtoPost == produtoPost;
  }

  @override
  int get hashCode => produtoPost.hashCode;
}
