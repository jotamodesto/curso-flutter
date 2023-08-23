import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop/exceptions/http_exception.dart';
// import 'package:shop/data/dummy_data.dart';
import 'package:shop/models/product.dart';

class ProductList with ChangeNotifier {
  static const firebaseUrl = 'shop-fluuter-course-default-rtdb.firebaseio.com';

  final String _token;
  final List<Product> _items;
  // final List<Product> _items = dummyProducts;

  ProductList()
      : _token = '',
        _items = [];

  ProductList.withToken(this._token, this._items);

  List<Product> get items => [..._items];
  List<Product> get favoriteItems =>
      _items.where((prod) => prod.isFavorite).toList();

  int get itemsCount {
    return _items.length;
  }

  Future<void> addProduct(Product product) async {
    final response = await http.post(
      Uri.https(
        firebaseUrl,
        'products.json',
        {'auth': _token},
      ),
      body: jsonEncode(
        {
          "name": product.name,
          "description": product.description,
          "price": product.price,
          "imageUrl": product.imageUrl,
          "isFavorite": product.isFavorite,
        },
      ),
    );

    final String id = jsonDecode(response.body)['name'];
    _items.add(
      Product(
        id: id,
        name: product.name,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
      ),
    );
    notifyListeners();
  }

  Future<void> updateProduct(Product product) async {
    int index = _items.indexWhere((p) => p.id == product.id);

    if (index >= 0) {
      await http.patch(
        Uri.https(
          firebaseUrl,
          'products/${product.id}.json',
          {'auth': _token},
        ),
        body: jsonEncode(
          {
            "name": product.name,
            "description": product.description,
            "price": product.price,
            "imageUrl": product.imageUrl,
          },
        ),
      );

      _items[index] = product;
      notifyListeners();
    }
  }

  Future<void> removeProduct(Product product) async {
    int index = _items.indexWhere((p) => p.id == product.id);

    if (index >= 0) {
      final currentProduct = _items[index];
      _items.remove(currentProduct);
      notifyListeners();

      final response = await http.delete(
        Uri.https(
          firebaseUrl,
          'products/${product.id}.json',
          {'auth': _token},
        ),
      );

      if (response.statusCode >= 400) {
        _items.insert(index, currentProduct);
        notifyListeners();

        throw HttpException(
          msg: 'Não foi possível excluir o produto',
          statusCode: response.statusCode,
        );
      }
    }
  }

  Future<void> loadProducts() async {
    _items.clear();

    final response = await http.get(
      Uri.https(
        firebaseUrl,
        'products.json',
        {'auth': _token},
      ),
    );

    if (response.body == 'null') return;

    Map<String, dynamic> data = jsonDecode(response.body);

    data.forEach((productId, productData) {
      _items.add(
        Product(
          id: productId,
          name: productData['name'],
          description: productData['description'],
          price: productData['price'],
          imageUrl: productData['imageUrl'],
          isFavorite: productData['isFavorite'],
        ),
      );
    });

    notifyListeners();
  }

  Future<void> saveProduct(Map<String, Object> productData) {
    bool hasId = productData['id'] != null;

    final newProduct = Product(
      id: hasId
          ? productData['id'] as String
          : Random().nextDouble().toString(),
      name: productData['name'] as String,
      description: productData['description'] as String,
      price: productData['price'] as double,
      imageUrl: productData['imageUrl'] as String,
    );

    if (hasId) {
      return updateProduct(newProduct);
    } else {
      return addProduct(newProduct);
    }
  }
}
