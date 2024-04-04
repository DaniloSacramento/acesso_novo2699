// ignore_for_file: use_build_context_synchronously

import 'package:acessonovo/app/pages/sucesso_page/sucesso_page_esqueci_senha.dart';
import 'package:acessonovo/app/services/esqueci_senha_service.dart';
import 'package:acessonovo/app/widget/app_color.dart';
import 'package:acessonovo/app/widget/tringulo_pointer.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RedefinePassword extends StatefulWidget {
  const RedefinePassword({Key? key}) : super(key: key);

  @override
  State<RedefinePassword> createState() => _RedefinePasswordState();
}

class _RedefinePasswordState extends State<RedefinePassword> {
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isButtonEnabled = true;
  bool apiSuccess = false;
  Map<String, dynamic>? apiResponse;
  String? errorMessage;
  Future<void> _checkInternetConnection() async {
    var connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult == ConnectivityResult.none) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Sem conexão com a internet'),
            content: const Text('Verifique sua conexão com a internet e tente novamente.'),
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double telaHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        backgroundColor: darkBlueColor,
        centerTitle: true,
        title: Image.asset(
          'assets/Captura de tela 2023-09-19 181800.png',
          fit: BoxFit.contain,
          height: 62,
        ),
      ),
      body: CustomPaint(
        painter: TrianguloPainter(),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: telaHeight * 0.015,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 0),
                  child: Text(
                    'Esqueceu?\nTudo bem.',
                    style: GoogleFonts.dosis(
                      textStyle: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: darkBlueColor,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: telaHeight * 0.030,
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 0,
                  ),
                  child: Text(
                    'Digite seu endereco de e-mail para redefinir sua \nsenha. Enviaremos um e-mail com o passo a passo, portanto, não esqueça de conferir\ntambém a sua caixa de spam.',
                    textAlign: TextAlign.start,
                    style: GoogleFonts.dosis(
                      textStyle: const TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      SizedBox(
                        height: telaHeight * 0.020,
                      ),
                      TextFormField(
                        controller: _emailController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Por favor, insira um endereço de e-mail.';
                          }
                          if (!RegExp(r"^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+$").hasMatch(value)) {
                            return 'Por favor, insira um endereço de e-mail válido.';
                          }
                          return null;
                        },
                        cursorColor: Colors.grey,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          hintText: "E-mail",
                          hintStyle: GoogleFonts.dosis(),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                              12.0,
                            ),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.grey[300],
                        ),
                      ),
                      SizedBox(
                        height: telaHeight * 0.080,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 1.0, right: 1, top: 0),
                        child: SizedBox(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: yellowColor,
                              minimumSize: const Size(double.infinity, 50),
                            ),
                            onPressed: _isButtonEnabled
                                ? () async {
                                    _checkInternetConnection();
                                    if (_formKey.currentState!.validate()) {
                                      setState(() {
                                        _isButtonEnabled = false;
                                      });
                                      apiResponse = await EsqueciSenhaDataSorce().esqueciSenhaService(email: _emailController.text);

                                      if (apiResponse!['data'] == 'ok') {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) => EsqueciSenhaSucesso(),
                                          ),
                                        );
                                      } else {
                                        setState(() {
                                          errorMessage = apiResponse!['errors'][0];
                                        });
                                      }

                                      setState(() {
                                        _isButtonEnabled = true;
                                      });
                                    }
                                  }
                                : null,
                            child: _isButtonEnabled
                                ? Text(
                                    "Redefinir minha senha",
                                    style: GoogleFonts.dosis(
                                      textStyle: const TextStyle(
                                        fontSize: 17,
                                        color: Colors.black,
                                      ),
                                    ),
                                  )
                                : const CircularProgressIndicator(),
                          ),
                        ),
                      ),
                      errorMessage != null
                          ? Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                errorMessage!,
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 16,
                                ),
                              ),
                            )
                          : Container(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}