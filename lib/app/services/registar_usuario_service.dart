import 'dart:convert';
import 'package:acessonovo/app/const/const.dart';
import 'package:http/http.dart' as http;

class RegistrarUsuarioService {
  Future<bool> registarUsuario(
      {required String email,
      required String nome,
      required String cpf,
      required String dtNascimento,
      required String password,
      required String telefone}) async {
    final response = await http.post(
      Uri.parse(ConstsApi.registar),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'authorization': ConstsApi.basicAuth,
      },
      body: jsonEncode(
        <String, String>{
          'email': email,
          'nome': nome,
          'cpf': cpf,
          'dtNascimento': dtNascimento,
          'password': password,
          'telefone': telefone,
        },
      ),
    );
    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      if (responseData['data'] == 'ok') {
        print('Deu tudo certo no cadastro');
        return true;
      } else {
        print('Erro: ${responseData['errors'][0]}');
        return false;
      }
    } else {
      print('Erro na chamada da API: ${response.statusCode}');
      return false;
    }
  }
}
