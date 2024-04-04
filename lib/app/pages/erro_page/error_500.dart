import 'package:flutter/material.dart';

class ServerErrorScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Erro de Servidor'),
      ),
      body: Center(
        child: Text('Ocorreu um erro no servidor. Por favor, tente novamente mais tarde.'),
      ),
    );
  }
}
