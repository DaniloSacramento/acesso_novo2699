import 'dart:convert';
import 'package:acessonovo/app/const/const.dart';
import 'package:acessonovo/app/models/escala_promotor_ponto.dart';
import 'package:http/http.dart' as http;

Future<List<PromotorEscalaPonto>> pontoPromotor({
  required email,
  required String data1Filter,
  required String data2Filter,
  String? lojaFilter,
  required String faltasFilter,
}) async {
  final response = await http.post(
    Uri.parse(ConstsApi.ponto),
    headers: <String, String>{
      'Content-Type': 'application/json',
      'authorization': ConstsApi.basicAuth,
    },
    body: jsonEncode(<String, String>{
      'email': email,
      'data1Filter': data1Filter,
      'data2Filter': data2Filter,
      'faltasFilter': faltasFilter,
    }),
  );
  print(response.body);
  if (response.statusCode == 200) {
    List<dynamic> responseData = json.decode(response.body)['data'];
    return responseData.map((json) => PromotorEscalaPonto.fromMap(json)).toList();
  } else {
    throw Exception('Falha ao carregar os pontos');
  }
}
