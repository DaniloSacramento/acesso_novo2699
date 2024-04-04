import 'dart:convert';
import 'package:acessonovo/app/const/const.dart';
import 'package:acessonovo/app/models/user_promote.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

Future<bool> redefineUser({required String nome, required String dtNascimento, required String telefone, required String foto}) async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  final result = sharedPreferences.getString('data');
  final user = UserPromote.fromMap(jsonDecode(result!)['data']);
  final response = await http.post(
    Uri.parse(ConstsApi.alterarDados),
    headers: <String, String>{
      'Content-Type': 'application/json',
      'authorization': ConstsApi.basicAuth,
    },
    body: jsonEncode(<String, String>{
      'email': user.email,
      'nome': nome,
      'dtNascimento': dtNascimento,
      'telefone': telefone,
    }),
  );
  if (response.statusCode == 200) {
    final responseData = json.decode(response.body);
    if (responseData["data"] == "ok") {
      final newUser = UserPromote(
          id: user.id,
          cpf: user.cpf,
          nome: nome,
          dtNascimento: dtNascimento,
          email: user.email,
          telefone: telefone,
          foto: foto,
          status: user.status,
          empresa: user.empresa);
      var jsonData = newUser.toJson();
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('data', jsonData);
      return true;
    } else {
      return false;
    }
  } else {
    return false;
  }
}
