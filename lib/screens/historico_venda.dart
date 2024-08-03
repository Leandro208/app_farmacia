import 'package:app_farmacia/model/farmacia_provider.dart';
import 'package:app_farmacia/model/produto.dart';
import 'package:app_farmacia/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:app_farmacia/utils/app_routes.dart';

class HistoricoVendas extends StatelessWidget {
  const HistoricoVendas({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todas as vendas'),
        leading: IconButton(
          onPressed: () => Navigator.pushNamed(context, AppRoutes.HOME),
          icon: const Icon(Icons.arrow_back),
        ),
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
              return Container(
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.colorPrimary, width: 2),
                  borderRadius: BorderRadius.circular(8),
                ),
                margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Data da venda: ${produtos[index].dataVenda.substring(0, 10)}'),
                        IconButton(
                          onPressed: () {
                            Provider.of<FarmaciaProvider>(context, listen: false)
                                .deleteHistoricoVenda(produtos[index]);
                          },
                          icon: const Icon(Icons.delete),
                        ),
                      ],
                    ),
                    _buildarDadosInternos(produtos[index]),
                    if (index != produtos.length - 1) const Divider()
                  ],
                ),
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
        return Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8),
          ),
          margin: const EdgeInsets.symmetric(vertical: 5),
          padding: const EdgeInsets.all(10),
          child: ListTile(
            title: Text(produtoFinal.nome),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Validade: ${DateFormat('dd/MM/yyyy').format(produtoFinal.validade)}'),
                Text('Quantidade: ${produtoFinal.quantidadeVendida}'),
                Text('Preço: ${produtoFinal.preco.toString()}'),
              ],
            ),
          ),
        );
      },
    );
  }
}
