import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/components/cart_item.dart';

import '../models/cart.dart';
import '../models/order_list.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final Cart cart = Provider.of(context);
    final items = cart.items.values.toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Carrinho'),
      ),
      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 25,
            ),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Chip(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    label: Text(
                      'R\$${cart.totalAmount.toStringAsFixed(2)}',
                      style: TextStyle(
                        color: Theme.of(context)
                            .primaryTextTheme
                            .titleLarge
                            ?.color,
                      ),
                    ),
                  ),
                  const Spacer(),
                  PurchaseButton(cart: cart),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                return CartItemWidget(cartItem: items[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class PurchaseButton extends StatefulWidget {
  const PurchaseButton({
    super.key,
    required this.cart,
  });

  final Cart cart;

  @override
  State<PurchaseButton> createState() => _PurchaseButtonState();
}

class _PurchaseButtonState extends State<PurchaseButton> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const CircularProgressIndicator()
        : TextButton(
            onPressed: widget.cart.itemsCount == 0
                ? null
                : () async {
                    setState(() => _isLoading = true);

                    await Provider.of<OrderList>(context, listen: false)
                        .addOrder(widget.cart);

                    widget.cart.clear();
                    setState(() => _isLoading = false);
                  },
            style: TextButton.styleFrom(
              textStyle: TextStyle(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            child: const Text('COMPRAR'),
          );
  }
}
