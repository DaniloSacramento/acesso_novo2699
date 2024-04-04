// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class RegisterFotoTirar extends StatefulWidget {
  final String userEmail;
  const RegisterFotoTirar({
    Key? key,
    required this.userEmail,
  }) : super(key: key);

  @override
  State<RegisterFotoTirar> createState() => _RegisterFotoTirarState();
}

class _RegisterFotoTirarState extends State<RegisterFotoTirar> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        backgroundColor: Colors.blue[900],
        title: const Text(
          "Acesso Novo",
          style: TextStyle(fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: const Column(
        children: [
          SizedBox(
            height: 45,
          ),
          Center(
            child: Text(
              "Posicione o seu rosto e ombros no \nretangulo abaixo",
              style: TextStyle(color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
