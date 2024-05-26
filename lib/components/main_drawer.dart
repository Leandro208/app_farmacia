import 'package:app_farmacia/utils/app_colors.dart';
import 'package:app_farmacia/utils/app_routes.dart';
import 'package:flutter/material.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({super.key});

  Widget _createItem(IconData icon, String label, Function() onTap) {
    return ListTile(
      leading: Icon(
        icon,
        size: 26,
      ),
      title: Text(
        label,
        style: const TextStyle(
          fontFamily: 'RobotoCondensed',
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Container(
            height: 120,
            width: double.infinity,
            padding: const EdgeInsets.all(40),
            color: AppColors.colorPrimary,
            alignment: Alignment.bottomRight,
            child: Text(
              'Menu',
              style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 30,
                  color: AppColors.colorSecondary),
            ),
          ),
          _createItem(Icons.home, 'Inicio',
              () => Navigator.of(context).pushReplacementNamed(AppRoutes.HOME)),
          _createItem(
              Icons.manage_search,
              'Gerenciar Medicamentos',
              () => Navigator.of(context)
                  .pushReplacementNamed(AppRoutes.MANAGE_PRODUTOS)),
          _createItem(
              Icons.history,
              'Histórico de vendas',
              () => Navigator.of(context)
                  .pushReplacementNamed(AppRoutes.HISTORICO_VENDAS)),
        ],
      ),
    );
  }
}
