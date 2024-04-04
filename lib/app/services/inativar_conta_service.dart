import 'dart:convert';
import 'package:acessonovo/app/const/const.dart';
import 'package:http/http.dart' as http;

class DeixarUserInativo {
  Future<bool> deixarUserInativo({
    required String email,
  }) async {
    var url = Uri.parse(ConstsApi.inativarConta);
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
      final responseData = json.decode(response.body);
      if (responseData['data'] == 'ok') {
        print('Sucesso');
        return true;
      } else {
        final errors = responseData['errors'];
        print('Erro: $errors');
        return false;
      }
    }
    return false;
  }
}
