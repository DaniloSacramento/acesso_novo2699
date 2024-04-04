import 'dart:convert';

import 'package:acessonovo/app/const/const.dart';
import 'package:acessonovo/app/models/termo.dart';
import 'package:acessonovo/app/models/user_promote.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class TermoPromotor {
  Future<Termo?> termoService({required String email}) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final result = sharedPreferences.getString('data');
    final user = UserPromote.fromMap(jsonDecode(result!)['data']);
    var url = Uri.parse(ConstsApi.termoPromotor);
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
      return Termo.fromJson(responseData);
    } else {
      print('Erro');
      return null;
    }
  }
}
