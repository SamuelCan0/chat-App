import 'dart:convert';

import 'package:chat_app/global/enviroment.dart';
import 'package:chat_app/models/models.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService with ChangeNotifier {
  late Usuario usuario;
  bool _autenticando = false;
  final _storage = FlutterSecureStorage();

  bool get autenticando => _autenticando;
  set autenticando(bool value) {
    _autenticando = value;
    notifyListeners();
  }

  static Future<String> getToken() async {
    final _storage = FlutterSecureStorage();
    final token = await _storage.read(key: 'token');
    return token!;
  }

  static Future<void> deleteToken() async {
    final _storage = FlutterSecureStorage();
    await _storage.delete(key: 'token');
  }

  Future register(String email, String password, String nombre) async {
    autenticando = true;
    final data = {'email': email, 'password': password, 'nombre': nombre};

    final url = Uri.http(Environment.apiUrl, '/api/login/new');
    final resp = await http.post(
      url,
      body: jsonEncode(data),
      headers: {'Content-Type': 'application/json'},
    );
    print(resp.body);
    if (resp.statusCode == 200) {
      final registerResp = registerResponseFromJson(resp.body);
      usuario = registerResp.usuario;
      await _guardarToken(registerResp.token);
      await Future.delayed(Duration(seconds: 3));
      autenticando = false;
      return true;
    } else {
      autenticando = false;
      final respBody = jsonDecode(resp.body);
      return respBody['msg'];
    }
  }

  Future<bool> login(String email, String password) async {
    autenticando = true;
    final data = {'email': email, 'password': password};

    final url = Uri.http(Environment.apiUrl, '/api/login');
    final resp = await http.post(
      url,
      body: jsonEncode(data),
      headers: {'Content-Type': 'application/json'},
    );
    print(resp.body);
    if (resp.statusCode == 200) {
      final loginResp = loginResponseFromJson(resp.body);
      usuario = loginResp.usuario;

      await _guardarToken(loginResp.token);
      autenticando = false;
      return true;
    } else {
      autenticando = false;
      return false;
    }
  }

  Future<bool> isLoggedIn() async {
    final token = await _storage.read(key: 'token');

    final url = Uri.http(Environment.apiUrl, '/api/login/renew');
    final resp = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'x-token': '$token',
      },
    );
    print(resp.body);
    if (resp.statusCode == 200) {
      final loginResp = loginResponseFromJson(resp.body);
      usuario = loginResp.usuario;

      await _guardarToken(loginResp.token);
      return true;
    } else {
      logout();
      return false;
    }
  }

  Future _guardarToken(String token) async {
    return await _storage.write(key: 'token', value: token);
  }

  Future logout() async {
    await _storage.delete(key: 'token');
  }
}
