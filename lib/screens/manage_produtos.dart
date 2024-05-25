import 'package:app_farmacia/model/farmacia_provider.dart';
import 'package:app_farmacia/model/produto.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ManageProduto extends StatefulWidget {
  const ManageProduto({super.key});

  @override
  State<ManageProduto> createState() => _ManageProdutoState();
}

class _ManageProdutoState extends State<ManageProduto> {
 String _filtro = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Buscar Produtos'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Buscar por nome',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                setState(() {
                  _filtro = value;
                });
              },
            ),
          ),
          Expanded(
            child: Consumer<FarmaciaProvider>(
              builder: (context, farmaciaProvider, child) {
                List<Produto> produtos = farmaciaProvider.produtos;
                if (_filtro.isNotEmpty) {
                  produtos = produtos
                      .where((produto) => produto.nome
                          .toLowerCase()
                          .contains(_filtro.toLowerCase()))
                      .toList();
                }

                if (produtos.isEmpty) {
                  return Center(
                    child: Text('Nenhum produto encontrado.'),
                  );
                }

                return ListView.builder(
                  itemCount: produtos.length,
                  itemBuilder: (context, index) {
                    final produto = produtos[index];
                    return ListTile(
                      title: Text(produto.nome),
                      subtitle: Text('Categoria: ${produto.categoria}'),
                      trailing: Text('Preço: ${produto.preco.toString()}'),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}