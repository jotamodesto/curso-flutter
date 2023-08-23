import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/components/app_drawer.dart';
import 'package:shop/components/order.dart';
import 'package:shop/models/order_list.dart';

class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key});

  Future<void> _refreshOrders(BuildContext context) async {
    return Provider.of<OrderList>(context, listen: false).loadOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meus Pedidos'),
      ),
      drawer: const AppDrawer(),
      body: FutureBuilder(
        future: _refreshOrders(context),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return Consumer<OrderList>(
            builder: (ctx, orders, child) => RefreshIndicator(
              onRefresh: () => _refreshOrders(ctx),
              child: ListView.builder(
                itemCount: orders.itemsCount,
                itemBuilder: (context, index) {
                  return OrderWidget(order: orders.items[index]);
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
