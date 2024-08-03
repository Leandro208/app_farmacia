import 'dart:ui';

import 'package:flutter/material.dart';

class AppColors {
  static Color colorPrimary = Colors.purple;
  static Color colorSecondary = Colors.yellow;
  static List<Color> colorsValidade = <Color>[Colors.red, Colors.yellow];

  static List<Color> colorsEstoque = <Color>[Colors.orange, Colors.yellow];

  static Color corRanking(int posicao) {
    
    if(posicao == 1){
      return Color(0xFFFFD700);
    } else if (posicao == 2){
      return Color(0xFFC0C0C0);
    }
    else {
      return Color(0xFFCD7F32);
    }
  }
}
