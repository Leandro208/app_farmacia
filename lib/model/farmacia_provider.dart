import 'dart:convert';
import 'dart:math';

import 'package:app_farmacia/model/categoria_medicamento.dart';
import 'package:app_farmacia/model/produto.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class FarmaciaProvider extends ChangeNotifier {
    final _baseUrl = 'https://farmacia-78f3f-default-rtdb.firebaseio.com/';
    List<Produto> _produtos = [];

    Map<String, double> _mapDashboardValidade = Map();
    Map<String, double> _mapDashboardEstoque = Map();

    bool isLoadDashboard = false;

    FarmaciaProvider(){
     _init();
    }

    _init() async{
      isLoadDashboard = true;
      notifyListeners();
      await fetchProdutos();
      //loadDashboard();
      isLoadDashboard = false;
      notifyListeners();
    }

    List<Produto> get produtos {
    return [..._produtos];
    }

    Map<String, double> get mapDashboardEstoque => _mapDashboardEstoque;
    Map<String, double> get mapDashboardValidade => _mapDashboardValidade;

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
      fetchProdutos();
    });
  }
  Future<void> updateProduto(Produto produto) async {
  final url = '$_baseUrl/produto/${produto.id}.json';

  try {
    final response = await http.put(
      Uri.parse(url),
      body: jsonEncode({
        "nome": produto.nome,
        "categoria": produto.categoria.toString().split('.').last,
        "preco": produto.preco,
        "validade": produto.validade.toIso8601String(),
        "estoque": produto.estoque,
        "fornecedor": produto.fornecedor,
      }),
    );

    if (response.statusCode == 200) {
      // Produto atualizado com sucesso
      notifyListeners();
      fetchProdutos();
    } else {
      // Se a resposta não for bem-sucedida, lance uma exceção
      throw 'Falha ao atualizar o produto. Status code: ${response.statusCode}';
    }
  } catch (error) {
    // Capture qualquer exceção e lance novamente
    throw 'Falha ao atualizar o produto: $error';
  }
}


  Future<void> deleteProduct(Produto produto) async {
  final url = '$_baseUrl/produto/${produto.id}.json';

  try {
    final response = await http.delete(Uri.parse(url));
    if (response.statusCode == 200) {
      _produtos.removeWhere((p) => p.id == produto.id);
      notifyListeners();
      fetchProdutos();
    } else {
      throw 'Falha ao deletar o produto. Status code: ${response.statusCode}';
    }
  } catch (error) {
    throw 'Falha ao deletar o produto: $error';
  }
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
      loadDashboard();
    } else {
      throw Exception('Falha ao ler os produtos');
    }
  }

  void loadDashboard(){
    double bomEstoque = 0;
    double acabandoEstoque = 0;

    double pertoDeVencer = 0;
    double emValidade = 0;

     DateTime hoje = DateTime.now();

     // Calcula a data daqui a uma semana
     DateTime umaSemanaDepois = hoje.add(Duration(days: 7));
    for (var produto in _produtos) {
      if(produto.estoque >= 2){
        bomEstoque++;
      } else acabandoEstoque++;

      if(produto.validade.isAfter(umaSemanaDepois)){
        emValidade++;
      } else if (produto.validade.isBefore(umaSemanaDepois)){
        pertoDeVencer++;
      }
    }
     _mapDashboardEstoque['Acabando estoque'] = acabandoEstoque;
    _mapDashboardEstoque['Bom estoque'] = bomEstoque;

    _mapDashboardValidade['Vencem em 1 semana'] = pertoDeVencer;
    _mapDashboardValidade['Produto em validade'] = emValidade;
    notifyListeners();
  }
}