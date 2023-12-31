import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop/exceptions/auth_exception.dart';

class Auth with ChangeNotifier {
  static const _firebaseUrl =
      'https://identitytoolkit.googleapis.com/v1/accounts:[ACTION]?key=AIzaSyCDV70Ku4hoMbOV1p3g1XZq31SgeSUQtAY';
  static const _signUp = 'signUp';
  static const _signIn = 'signInWithPassword';

  String? _token;
  String? _email;
  String? _uid;
  DateTime? _expiryDate;

  bool get isAuth {
    final isValid = _expiryDate?.isAfter(DateTime.now()) ?? false;

    return _token != null && isValid;
  }

  String? get token {
    return isAuth ? _token : null;
  }

  String? get email {
    return isAuth ? _email : null;
  }

  String? get uid {
    return isAuth ? _uid : null;
  }

  Future<void> _authenticate(
      String email, String password, String actionFragment) async {
    final response = await http.post(
      Uri.parse(_firebaseUrl.replaceAll('[ACTION]', actionFragment)),
      body: jsonEncode({
        'email': email,
        'password': password,
        'returnSecureToken': true,
      }),
    );

    final body = jsonDecode(response.body);

    if (body['error'] != null) {
      throw AuthException(body['error']['message']!);
    }

    _token = body['idToken'];
    _email = body['email'];
    _uid = body['localId'];

    _expiryDate = DateTime.now().add(Duration(
      seconds: int.parse(body['expiresIn']),
    ));

    notifyListeners();
  }

  Future<void> signup(String email, String password) async {
    return _authenticate(email, password, _signUp);
  }

  Future<void> login(String email, String password) async {
    return _authenticate(email, password, _signIn);
  }
}
