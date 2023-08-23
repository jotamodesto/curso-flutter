import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../exceptions/http_exception.dart';
import '../models/product.dart';
import '../models/product_list.dart';
import '../routes/app_routes.dart';

class ProductItem extends StatelessWidget {
  const ProductItem({required this.product, super.key});

  final Product product;

  void removeProduct(BuildContext context, Product product) async {
    final isConfirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Tem Certeza?'),
        content: const Text('Você deseja excluir este produto?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop(false);
            },
            child: const Text('Não'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop(true);
            },
            child: const Text('Sim'),
          ),
        ],
      ),
    );

    if (context.mounted && (isConfirmed ?? false)) {
      final msg = ScaffoldMessenger.of(context);

      try {
        await Provider.of<ProductList>(context, listen: false)
            .removeProduct(product);
      } on HttpException catch (error) {
        msg.showSnackBar(
          SnackBar(
            content: Text(error.toString()),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(product.imageUrl),
      ),
      title: Text(product.name),
      trailing: SizedBox(
        width: 100,
        child: Row(
          children: [
            IconButton(
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(AppRoutes.productForm, arguments: product);
              },
              color: Theme.of(context).colorScheme.primary,
              icon: const Icon(Icons.edit),
            ),
            IconButton(
              onPressed: () => removeProduct(context, product),
              color: Theme.of(context).colorScheme.error,
              icon: const Icon(Icons.delete),
            ),
          ],
        ),
      ),
    );
  }
}
