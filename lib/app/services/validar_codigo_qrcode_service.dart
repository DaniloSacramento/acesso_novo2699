import 'dart:convert';
import 'package:acessonovo/app/const/const.dart';
import 'package:http/http.dart' as http;

class ValidarCodigoEmpresa {
  Future<Map<String, dynamic>> validarCodigoQr(String codigo) async {
    var url = ConstsApi.validarCodigoEmpresa;
    final response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'authorization': ConstsApi.basicAuth,
      },
      body: jsonEncode(
        <String, String>{
          'codigo': codigo,
        },
      ),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      final errors = responseData['errors'];
      if (errors.isNotEmpty) {
        throw Exception('Falha na chamada da API ${errors[0]}');
      }
      return responseData['data'];
    } else if (response.statusCode == 401) {
      throw Exception('Não autorizado');
    } else if (response.statusCode == 404) {
      throw Exception('Recurso não encontrado');
    } else if (response.statusCode == 500) {
      throw Exception('Erro interno do servidor');
    } else {
      throw Exception('Falha na chamada da API com status ${response.statusCode}');
    }
  }
}
