import 'dart:convert';

import 'package:acessonovo/app/const/const.dart';
import 'package:http/http.dart' as http;

class EsqueciSenhaDataSorce {
  Future<Map<String, dynamic>> esqueciSenhaService({
    required String email,
  }) async {
    var url = Uri.parse(ConstsApi.esqueciSenha);
    var response = await http.post(
      url,
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