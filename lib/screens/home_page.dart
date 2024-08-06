import 'package:app_farmacia/components/grafico.dart';
import 'package:app_farmacia/model/farmacia_provider.dart';
import 'package:app_farmacia/model/produto.dart';
import 'package:app_farmacia/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});
  late FarmaciaProvider controller;

  @override
  Widget build(BuildContext context) {
    controller = Provider.of<FarmaciaProvider>(context);
    Map<String, double> dataMapValidade = controller.mapDashboardValidade;
    Map<String, double> dataMapEstoque = controller.mapDashboardEstoque;
    List<Produto> topProdutosVendidos = controller.topProdutosVendidos;

    return Scaffold(
      body: (controller.isLoadDashboard)
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  Container(
                      margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                      padding: const EdgeInsets.all(20.0),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: AppColors.colorPrimary, // Cor da borda
                          width: 2.0, // Largura da borda
                        ),
                      ),
                      child: Grafico(
                          dataMap: dataMapValidade,
                          colorList: AppColors.colorsValidade,
                          labelCenter: '')),
                  const SizedBox(height: 40),
                  Container(
                      margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                      padding: const EdgeInsets.all(20.0),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: AppColors.colorPrimary, // Cor da borda
                          width: 2.0, // Largura da borda
                        ),
                      ),
                      child: Grafico(
                          dataMap: dataMapEstoque,
                          colorList: AppColors.colorsEstoque,
                          labelCenter: '')),
                  const SizedBox(height: 40),
                  Container(
                    margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                    padding: const EdgeInsets.all(20.0),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: AppColors.colorPrimary, // Cor da borda
                        width: 2.0, // Largura da borda
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Produtos mais vendidos',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Column(
                          children:
                              topProdutosVendidos.asMap().entries.map((entry) {
                            int index = entry.key;
                            Produto produto = entry.value;
                            Color? corTrofeu;
                            IconData? icon;

                            switch (index) {
                              case 0:
                                icon = Icons.emoji_events;
                                corTrofeu = const Color(0xFFFFD700);
                                break;
                              case 1:
                                icon = Icons.emoji_events;
                                corTrofeu = const Color(0xFFC0C0C0);
                                break;
                              case 2:
                                icon = Icons.emoji_events;
                                corTrofeu = const Color(0xFFCD7F32);
                                break;
                              default:
                                icon = null;
                            }

                            return ListTile(
                              leading: icon != null
                                  ? Icon(icon, color: corTrofeu)
                                  : null,
                              title: Text(produto.nome),
                              subtitle: Text(
                                  'Quantidade Vendida: ${produto.quantidadeVendida}'),
                              //trailing: Text(posicao, style: TextStyle(fontSize: 15),),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
