import 'dart:convert';
import 'dart:typed_data';
import 'package:acessonovo/app/const/const.dart';
import 'package:acessonovo/app/models/user_promote.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http_parser/http_parser.dart';

class AlterarFoto {
  Future<String?> fotoPromotor({required String email, required Uint8List file}) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final result = sharedPreferences.getString('data');
    final user = UserPromote.fromMap(jsonDecode(result!)['data']);
    Map<String, String> headers = {
      'authorization': ConstsApi.basicAuth,
      'Content-Type': 'multipart/form-data',
    };
    var request = http.MultipartRequest(
      'POST',
      Uri.parse(ConstsApi.fotoPromotor),
    );

    request.headers.addAll(headers);
    request.files.add(http.MultipartFile.fromBytes("file", file, filename: "image.jpg", contentType: MediaType.parse("image/jpg")));
    request.fields.addAll({'email': user.email});
    return request.send().then(
      (response) async {
        if (response.statusCode == 200) {
          return jsonDecode(await response.stream.bytesToString())["data"];
        } else {
          return null;
        }
      },
    );
  }
}
