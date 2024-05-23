import 'package:app_farmacia/components/grafico.dart';
import 'package:app_farmacia/utils/app_colors.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
      Map<String, double> dataMapValidade = {
      "Vencem em 1 semana": 4,
      "Produto em validade": 6,
    };

    Map<String, double> dataMapEstoque = {
      "Acabando estoque": 7,
      "Bom estoque": 3,
    };
    return Scaffold(
      body: Column(
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
              labelCenter: 'Validade')
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
              labelCenter: 'Estoque')
              ),
        ],
      ),
    );
  }


}