import 'dart:convert';
import 'package:acessonovo/app/const/const.dart';
import 'package:http/http.dart' as http;

class CodigoEmpresaService {
  Future<bool> codigoEmpresa({required String email, required String codigo}) async {
    final response = await http.post(
      Uri.parse(ConstsApi.codigoAuth),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'authorization': ConstsApi.basicAuth,
      },
      body: jsonEncode(
        <String, String>{
          'email': email,
          'codigo': codigo,
        },
      ),
    );
    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      if (responseData['data'] == 'ok') {
        print('Email verificado com sucesso');
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
