import 'package:chat_app/models/models.dart';
import 'package:chat_app/services/auth_services.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../global/enviroment.dart';

class ChatService with ChangeNotifier {
  late Usuario usuarioPara;

  Future<List<Mensaje>> getChat(String usuarioId) async {
    final url = Uri.http(Environment.apiUrl, '/api/mensajes/$usuarioId');
    final resp = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'x-token': await AuthService.getToken(),
    });
    final mensajesResp = mensajesResponseFromJson(resp.body);
    return mensajesResp.mensajes;
  }
}
