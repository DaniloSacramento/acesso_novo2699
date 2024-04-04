import 'dart:convert';
import 'package:acessonovo/app/const/const.dart';
import 'package:acessonovo/app/models/user_promote.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class TermoAceitePromotor {
  Future<void> termoAceiteService() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final result = sharedPreferences.getString('data');
    final user = UserPromote.fromMap(jsonDecode(result!)['data']);
    var url = Uri.parse(ConstsApi.termoAceite);
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
    print(response.body);
    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);

      if (responseData['data'] == 'success') {
        print('Sucesso');
      } else {
        final errors = responseData['errors'];
        print('Erro: $errors');
      }
    }
  }
}
