import 'package:app_farmacia/model/farmacia_provider.dart';
import 'package:app_farmacia/model/produto.dart';
import 'package:app_farmacia/utils/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
        title: const Text('Buscar Produtos'),
        leading: IconButton(
          onPressed: () => Navigator.pushNamed(context, AppRoutes.HOME),
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(
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
                  return const Center(
                    child: Text('Nenhum produto encontrado.'),
                  );
                }

                return ListView.builder(
                  itemCount: produtos.length,
                  itemBuilder: (context, index) {
                    final produto = produtos[index];
                    return ListTile(
                      title: Text(produto.nome),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              'Validade: ${DateFormat('dd/MM/yyyy').format(produto.validade)}'),
                          Text('Preço: ${produto.preco.toString()}'),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: () {
                              Navigator.pushNamed(
                                context,
                                AppRoutes.CADASTRAR_PRODUTO,
                                arguments: produto,
                              );
                            },
                            icon: const Icon(Icons.edit),
                          ),
                          IconButton(
                            onPressed: () {
                              Provider.of<FarmaciaProvider>(context,
                                      listen: false)
                                  .deleteProduct(produto);
                            },
                            icon: const Icon(Icons.delete),
                          ),
                        ],
                      ),
                      onTap: () {
                        // Navegar para a tela de detalhes do produto
                        Navigator.pushNamed(
                          context,
                          AppRoutes.DETALHES_PRODUTO,
                          arguments: produto,
                        );
                      },
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
