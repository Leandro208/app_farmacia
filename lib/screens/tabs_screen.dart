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

  @override
  void initState() {
    super.initState();
    _pages = [
      FormProduto(),
      HomePage(),
      FormVenda(),
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
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: AppColors.colorPrimary,

        showSelectedLabels:
            _showLabels, // Mostra o rótulo apenas do item selecionado
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
    );
  }
}