import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';

import 'package:acessonovo/app/const/const.dart';
import 'package:acessonovo/app/models/escala_promotor.dart';

Future<List<EscalaPromotor>> fetchEscalas(String email) async {
  final response = await http.post(
    Uri.parse(ConstsApi.escala),
    headers: <String, String>{
      'Content-Type': 'application/json',
      'authorization': ConstsApi.basicAuth,
    },
    body: jsonEncode(<String, String>{
      'email': email,
    }),
  );

  if (response.statusCode == 200) {
    List<dynamic> responseData = json.decode(response.body)['data'];
    return responseData.map((json) => EscalaPromotor.fromMap(json)).toList();
  } else {
    throw Exception('Falha ao carregar as escalas');
  }
}
