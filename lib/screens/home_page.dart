import 'package:app_farmacia/components/grafico.dart';
import 'package:app_farmacia/model/farmacia_provider.dart';
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
    return Scaffold(
      body: (controller.isLoadDashboard) 
      ? const Center(child: CircularProgressIndicator(),)
      : Column(
        children: [
          SizedBox(height: 20,),
          Container(
            margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
            padding: EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              border: Border.all(
                color: AppColors.colorPrimary, // Cor da borda
                width: 2.0, // Largura da borda
              ),
            ),
            child: Grafico(
              dataMap: dataMapValidade, 
              colorList: AppColors.colorsValidade, 
              labelCenter: '')
              ),
           SizedBox(height: 40,),
          Container(
            margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
            padding: EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              border: Border.all(
                color: AppColors.colorPrimary, // Cor da borda
                width: 2.0, // Largura da borda
              ),
            ),
            child: Grafico(
              dataMap: dataMapEstoque, 
              colorList: AppColors.colorsEstoque, 
              labelCenter: '')
              ),
        ],
      ) ,
    );
  }
}