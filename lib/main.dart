import 'package:app_farmacia/screens/home_page.dart';
import 'package:app_farmacia/utils/app_routes.dart';
import 'package:flutter/material.dart';

void main(){
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Farmacia',
      initialRoute: AppRoutes.HOME,
      routes: {
        AppRoutes.HOME: (ctx) => HomePage()
      },
      debugShowCheckedModeBanner: false,
    );
  }
}