import 'package:app_farmacia/model/farmacia_provider.dart';
import 'package:app_farmacia/screens/detail_produto.dart';
import 'package:app_farmacia/screens/form_produto.dart';
import 'package:app_farmacia/screens/manage_produtos.dart';
import 'package:app_farmacia/screens/tabs_screen.dart';
import 'package:app_farmacia/utils/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main(){
  runApp(MyApp());
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
          AppRoutes.HOME: (ctx) => TabsScreen(),
          AppRoutes.MANAGE_PRODUTOS: (ctx) => ManageProduto(),
          AppRoutes.DETALHES_PRODUTO: (ctx) => DetalhesProduto(),
          AppRoutes.CADASTRAR_PRODUTO: (ctx) => FormProduto()
        },
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}