import 'package:app_farmacia/components/main_drawer.dart';
import 'package:app_farmacia/screens/form_produto.dart';
import 'package:app_farmacia/screens/form_venda.dart';
import 'package:app_farmacia/screens/home_page.dart';
import 'package:app_farmacia/utils/app_colors.dart';
import 'package:flutter/material.dart';

class TabsScreen extends StatefulWidget {
  const TabsScreen({super.key});

  @override
  State<TabsScreen> createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  int _selectedIndex = 1;
  bool _showLabels = true;
  late final List<Widget> _pages;
  final List<String> _titles = [
    'Cadastrar Medicamento',
    'Farmacia',
    'Cadastrar Venda'
  ];

  @override
  void initState() {
    super.initState();
    _pages = [
      const FormProduto(),
      HomePage(),
      const FormVenda(),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _showLabels = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _titles[_selectedIndex],
        ),
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: AppColors.colorPrimary,
        showSelectedLabels: _showLabels,
        showUnselectedLabels: false,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.health_and_safety_outlined),
            label: 'Cadastrar Medicamento',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopify),
            label: 'Cadastrar Venda',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: AppColors.colorSecondary,
        unselectedItemColor: Colors.white,
        onTap: _onItemTapped,
      ),
      drawer: const MainDrawer(),
    );
  }
}
