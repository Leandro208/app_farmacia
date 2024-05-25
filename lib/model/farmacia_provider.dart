import 'dart:convert';
import 'dart:math';

import 'package:app_farmacia/model/categoria_medicamento.dart';
import 'package:app_farmacia/model/produto.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class FarmaciaProvider extends ChangeNotifier {
    final _baseUrl = 'https://farmacia-78f3f-default-rtdb.firebaseio.com/';
    List<Produto> _produtos = [];


    FarmaciaProvider(){
      fetchProdutos();
    }

    List<Produto> get produtos {
    return [..._produtos];
  }

    Future<void> addProduto(Produto produto) {
    final future = http.post(Uri.parse('$_baseUrl/produto.json'),
        body: jsonEncode({
          "nome": produto.nome,
          "categoria": produto.categoria.toString().split('.').last,
          "preco": produto.preco,
          "validade": produto.validade.toIso8601String(),
          "estoque": produto.estoque,
          "fornecedor": produto.fornecedor
        }));
    return future.then((response) {
      //print('espera a requisição acontecer');
      print(jsonDecode(response.body));
      final id = jsonDecode(response.body)['name'];
      print(response.statusCode);
      _produtos.add(Produto(
          id: id,
          nome: produto.nome,
          categoria: produto.categoria,
          preco: produto.preco,
          validade: produto.validade,
          estoque: produto.estoque,
          fornecedor: produto.fornecedor
          ));
      notifyListeners();
    });
    // print('executa em sequencia');
  }
  Future<void> updateProduto(Produto produto) {
    int index = _produtos.indexWhere((p) => p.id == produto.id);

    if (index >= 0) {
      _produtos[index] = produto;
      notifyListeners();
    }
    return Future.value();
  }
  Future<void> saveProduto(Map<String, Object> data) {
    bool hasId = data['id'] != null;

    final produto = Produto(
      id: hasId ? data['id'] as String : Random().nextDouble().toString(),
      nome: data['nome'] as String,
      categoria: data['categoria'] as CategoriaMedicamento,
      preco: data['preco'] as double,
      validade: data['validade'] as DateTime,
      estoque: data['estoque'] as int,
      fornecedor: data['fornecedor'] as String
    );

    if (hasId) {
      return updateProduto(produto);
    } else {
      return addProduto(produto);
    }
  }

   Future<void> fetchProdutos() async {
    final response = await http.get(Uri.parse('$_baseUrl/produto.json'));

    if (response.statusCode == 200) {
      final extractedData = jsonDecode(response.body) as Map<String, dynamic>;
      final List<Produto> loadedProdutos = [];
      extractedData.forEach((prodId, prodData) {
        loadedProdutos.add(Produto(
          id: prodId,
          nome: prodData['nome'],
          categoria: CategoriaMedicamento.values.firstWhere(
            (cat) => cat.toString().split('.').last == prodData['categoria'],
          ),
          preco: prodData['preco'],
          validade: DateTime.parse(prodData['validade']),
          estoque: prodData['estoque'],
          fornecedor: prodData['fornecedor'],
        ));
      });
      _produtos = loadedProdutos;
      notifyListeners();
    } else {
      throw Exception('Falha ao ler os produtos');
    }
  }
}