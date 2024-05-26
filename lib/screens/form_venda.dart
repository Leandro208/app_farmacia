import 'package:app_farmacia/model/categoria_medicamento.dart';
import 'package:app_farmacia/model/farmacia_provider.dart';
import 'package:app_farmacia/model/produto.dart';
import 'package:app_farmacia/utils/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class FormVenda extends StatefulWidget {
  const FormVenda({super.key});

  @override
  State<FormVenda> createState() => _FormVendaState();
}

class _FormVendaState extends State<FormVenda> {
  String _filtro = '';
  List<Produto> produtos = [];
  List<Produto> produtosVendidos = [];
  bool isCarregando = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                produtos = farmaciaProvider.produtos;
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
                            onPressed: isCarregando
                                ? null
                                : () {
                                    String idRemocao = '';
                                    for (Produto pd in produtosVendidos) {
                                      if (pd.id == produto.id &&
                                          pd.quantidadeVendida > 0) {
                                        pd.quantidadeVendida -= 1;
                                      }

                                      if (pd.quantidadeVendida == 0) {
                                        idRemocao = pd.id;
                                      }
                                    }
                                    setState(() {
                                      produtosVendidos.removeWhere(
                                          (pd) => pd.id == idRemocao);
                                    });
                                  },
                            icon: const Icon(Icons.remove),
                          ),
                          Text(produtosVendidos
                              .firstWhere(
                                (pd) => pd.id == produto.id,
                                orElse: () => Produto(
                                    id: '0',
                                    nome: 'nome',
                                    categoria: CategoriaMedicamento.ANALGESICO,
                                    preco: 0,
                                    validade: DateTime.now(),
                                    estoque: 0,
                                    fornecedor: '',
                                    quantidadeVendida: 0),
                              )
                              .quantidadeVendida
                              .toString()),
                          IconButton(
                            onPressed: isCarregando
                                ? null
                                : () {
                                    bool idEncontrado = false;
                                    bool podeAdicionar = true;
                                    for (Produto pd in produtosVendidos) {
                                      if (pd.id != produto.id) continue;
                                      if (pd.quantidadeVendida < pd.estoque) {
                                        pd.quantidadeVendida++;
                                        idEncontrado = true;
                                      }
                                      if (pd.quantidadeVendida == pd.estoque) {
                                        podeAdicionar = false;
                                      }
                                    }
                                    if (!idEncontrado &&
                                        podeAdicionar &&
                                        produto.estoque > 0) {
                                      produtosVendidos.add(
                                        Produto(
                                          id: produto.id,
                                          nome: produto.nome,
                                          categoria: produto.categoria,
                                          preco: produto.preco,
                                          validade: produto.validade,
                                          estoque: produto.estoque,
                                          fornecedor: produto.fornecedor,
                                          quantidadeVendida: 1,
                                        ),
                                      );
                                    }
                                    setState(() {});
                                  },
                            icon: const Icon(Icons.add),
                          ),
                        ],
                      ),
                      onTap: isCarregando
                          ? null
                          : () {
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
          if (produtosVendidos.isNotEmpty)
            InkWell(
              onTap: () {
                setState(() {
                  isCarregando = true;
                });
                final vendasMap = {for (var pd in produtosVendidos) pd.id: pd};
                List idAtualizar = [];
                for (int i = 0; i < produtos.length; i++) {
                  if (vendasMap.containsKey(produtos[i].id)) {
                    var venda = vendasMap[produtos[i].id];
                    produtos[i].estoque -= venda!.quantidadeVendida;
                    idAtualizar.add(i);
                  }
                }
                if (idAtualizar.isNotEmpty) {
                  for (var id in idAtualizar) {
                    Provider.of<FarmaciaProvider>(
                      context,
                      listen: false,
                    ).updateProduto(produtos[id]);
                  }
                }
                // log(jsonEncode(
                //     produtosVendidos.map((e) => e.toJson()).toList()));

                Provider.of<FarmaciaProvider>(
                  context,
                  listen: false,
                )
                    .addVenda(ProdutoPost(
                      id: '',
                      dataVenda: DateTime.now().toString(),
                      listaProduto: produtosVendidos,
                    ))
                    .then(
                      (teste) => setState(
                        () {
                          isCarregando = false;
                          produtosVendidos.clear();
                          Provider.of<FarmaciaProvider>(context, listen: false)
                              .getProdutosVendidos()
                              .then((_) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content:
                                      Text('Venda concluída com sucesso!')),
                            );
                            Navigator.pushNamed(
                                context, AppRoutes.HISTORICO_VENDAS);
                          });
                        },
                      ),
                    );
              },
              child: Container(
                height: 50,
                color: const Color.fromARGB(255, 14, 172, 96),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Finalizar venda',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                    const SizedBox(width: 20),
                    isCarregando
                        ? const CircularProgressIndicator(
                            color: Colors.white, strokeWidth: 2)
                        : const Icon(Icons.keyboard_arrow_right,
                            color: Colors.white)
                  ],
                ),
              ),
            )
        ],
      ),
    );
  }
}
