import 'dart:convert';
import 'package:acessonovo/app/const/const.dart';
import 'package:http/http.dart' as http;

class VerificarEmailService {
  Future<Map<String, dynamic>>  verificarEmail({
    required String email,
  }) async {
    final response = await http.post(
      Uri.parse(ConstsApi.validarEmail),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'authorization': ConstsApi.basicAuth,
      },
      body: jsonEncode(
        <String, String>{
          'email': email,
        },
      ),
    );
     if (response.statusCode == 200) {
      return json.decode(utf8.decode(response.bodyBytes));
    } else {
      throw Exception('Erro ao verificar o token');
    }
  }
}