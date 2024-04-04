import 'package:acessonovo/app/const/const.dart';
import 'package:acessonovo/app/models/user_promote.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class StatusDataSorce {
  Future<String?> statusService({required String email}) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final result = sharedPreferences.getString('data');
    final user = UserPromote.fromMap(jsonDecode(result!)['data']);
    var url = Uri.parse(ConstsApi.statusService);
    var response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'authorization': ConstsApi.basicAuth,
      },
      body: jsonEncode(
        <String, String>{
          'email': user.email,
        },
      ),
    );
    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      final status = utf8.decode(responseData['data']['status']);
      print('Status da resposta: $status');
    } else {
      throw Exception('Falha ao enviar a solicitação POST');
    }
    return null;
  }
}