import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../utils/constants.dart';
import '../exceptions/http_exception.dart';

class Product with ChangeNotifier {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.isFavorite = false,
  });

  Future<void> toggleFavorite(String token) async {
    isFavorite = !isFavorite;
    notifyListeners();

    final response = await http.patch(
      Uri.https(
        Constants.firebaseUrl,
        '${Constants.productsPath}/$id.json',
        {'auth': token},
      ),
      body: jsonEncode(
        {
          "isFavorite": isFavorite,
        },
      ),
    );

    if (response.statusCode >= 400) {
      isFavorite = !isFavorite;
      notifyListeners();

      throw HttpException(
        msg: 'Não foi possível adicionar favorito',
        statusCode: response.statusCode,
      );
    }
  }
}
