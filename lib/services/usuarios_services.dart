import 'package:chat_app/global/enviroment.dart';
import 'package:chat_app/models/models.dart';
import 'package:chat_app/services/services.dart';
import 'package:http/http.dart' as http;

class UsuariosServices {
  Future<List<Usuario>> getUsuarios() async {
    try {
      final url = Uri.http(Environment.apiUrl, '/api/usuarios');
      final resp = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'x-token': await AuthService.getToken(),
        },
      );
      final usuariosResponse = usuariosResponseFromJson(resp.body);
      return usuariosResponse.usuarios;
    } catch (e) {
      return [];
    }
  }
}
