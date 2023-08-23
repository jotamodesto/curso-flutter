import 'package:flutter/material.dart';
import 'package:shop/routes/app_routes.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: const Text('Bem vindo pessoa!'),
            automaticallyImplyLeading: false,
          ),
          const Divider(),
          ListTile(
            onTap: () {
              Navigator.of(context).pushReplacementNamed(
                AppRoutes.authOrHome,
              );
            },
            leading: const Icon(Icons.shop),
            title: const Text('Loja'),
          ),
          const Divider(),
          ListTile(
            onTap: () {
              Navigator.of(context).pushReplacementNamed(
                AppRoutes.orders,
              );
            },
            leading: const Icon(Icons.payment),
            title: const Text('Pedidos'),
          ),
          ListTile(
            onTap: () {
              Navigator.of(context).pushReplacementNamed(
                AppRoutes.products,
              );
            },
            leading: const Icon(Icons.edit),
            title: const Text('Gerenciar Produtos'),
          ),
        ],
      ),
    );
  }
}
