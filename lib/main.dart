import 'package:app_farmacia/model/farmacia_provider.dart';
import 'package:app_farmacia/screens/detail_produto.dart';
import 'package:app_farmacia/screens/form_produto.dart';
import 'package:app_farmacia/screens/historico_venda.dart';
import 'package:app_farmacia/screens/manage_produtos.dart';
import 'package:app_farmacia/screens/tabs_screen.dart';
import 'package:app_farmacia/utils/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => FarmaciaProvider(),
      child: MaterialApp(
        title: 'Farmacia',
        initialRoute: AppRoutes.HOME,
        routes: {
          AppRoutes.HOME: (ctx) => const TabsScreen(),
          AppRoutes.MANAGE_PRODUTOS: (ctx) => const ManageProduto(),
          AppRoutes.DETALHES_PRODUTO: (ctx) => const DetalhesProduto(),
          AppRoutes.CADASTRAR_PRODUTO: (ctx) => const FormProduto(),
          AppRoutes.HISTORICO_VENDAS: (ctx) => const HistoricoVendas(),
        },
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
