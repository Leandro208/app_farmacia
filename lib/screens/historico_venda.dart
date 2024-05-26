import 'package:app_farmacia/model/farmacia_provider.dart';
import 'package:app_farmacia/model/produto.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class HistoricoVendas extends StatelessWidget {
  const HistoricoVendas({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todas as vendas'),
      ),
      body: Consumer<FarmaciaProvider>(
        builder: (context, farmaciaProvider, child) {
          List<ProdutoPost> produtos = farmaciaProvider.historicoVendas;

          if (produtos.isEmpty) {
            return const Center(
              child: Text('Nenhum produto encontrado.'),
            );
          }

          return ListView.builder(
            itemCount: produtos.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 15),
                    child: Row(
                      children: [
                        Text(
                            'Data da venda:${produtos[index].dataVenda.substring(0, 10)}'),
                        IconButton(
                          onPressed: () {
                            Provider.of<FarmaciaProvider>(context,
                                    listen: false)
                                .deleteHistoricoVenda(produtos[index]);
                          },
                          icon: const Icon(Icons.delete),
                        ),
                      ],
                    ),
                  ),
                  _buildarDadosInternos(produtos[index]),
                  if (index != produtos.length - 1) const Divider()
                ],
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildarDadosInternos(ProdutoPost produto) {
    return ListView.builder(
      itemCount: produto.listaProduto.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        var produtoFinal = produto.listaProduto[index];
        return ListTile(
          title: Text(produtoFinal.nome),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                  'Validade: ${DateFormat('dd/MM/yyyy').format(produtoFinal.validade)}'),
              Text('Quantidade: ${produtoFinal.quantidadeVendida}'),
              Text('Preço: ${produtoFinal.preco.toString()}'),
            ],
          ),

          // onTap: () {
          //   // Navegar para a tela de detalhes do produto
          //   Navigator.pushNamed(
          //     context,
          //     AppRoutes.DETALHES_PRODUTO,
          //     arguments: produtoFinal,
          //   );
          // },
        );
      },
    );
  }
}
