import 'dart:convert';

import 'package:acessonovo/app/models/user_promote.dart';
import 'package:acessonovo/app/pages/sucesso_page/sucesso_page_alterar_senha.dart';
import 'package:acessonovo/app/services/alterar_senha_service.dart';
import 'package:acessonovo/app/widget/app_color.dart';
import 'package:acessonovo/app/widget/tringulo_pointer.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AlterarSenha extends StatefulWidget {
  const AlterarSenha({super.key});

  @override
  State<AlterarSenha> createState() => _AlterarSenhaState();
}

class _AlterarSenhaState extends State<AlterarSenha> {
  final _formKey = GlobalKey<FormState>();
  bool _showPassword = false;
  TextEditingController confirmarSenha = TextEditingController();
  TextEditingController senhaAtual = TextEditingController();
  TextEditingController novaSenha = TextEditingController();

  Future<void> _checkInternetConnection() async {
    var connectivityResult = await (Connectivity().checkConnectivity());

    if (connectivityResult == ConnectivityResult.none) {
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'Sem conexão com a internet',
              style: GoogleFonts.dosis(
                  textStyle: TextStyle(
                fontSize: 17,
                color: darkBlueColor,
                fontWeight: FontWeight.bold,
              )),
            ),
            content: Text(
              'Verifique sua conexão com a internet e tente novamente.',
              style: GoogleFonts.dosis(
                textStyle: const TextStyle(
                  fontSize: 17,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text(
                  'OK',
                  style: GoogleFonts.dosis(
                    textStyle: TextStyle(
                      fontSize: 17,
                      color: darkBlueColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
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

  String? _validatePasswordMatch(String value) {
    if (value != novaSenha.text) {
      return 'As senhas não coincidem';
    }
    return null;
  }

  UserPromote? user;
  _getUser() async {
    final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final result = sharedPreferences.getString('data');
    user = UserPromote.fromMap(jsonDecode(result!)['data']);
    setState(() {});
  }

  bool validarSenha(String senha) {
    if (senha.length < 6) {
      return false;
    }

    if (!senha.contains(RegExp(r'\d'))) {
      return false;
    }

    if (!senha.contains(RegExp(r'[A-Z]'))) {
      return false;
    }

    if (!senha.contains(RegExp(r'[a-z]'))) {
      return false;
    }

    if (!senha.contains(RegExp(r'[!@#\$%^&*(),.?":{}|<>]'))) {
      return false;
    }

    if (senha.contains(RegExp(r'\s'))) {
      return false;
    }

    return true;
  }

  String errorMessage = '';

  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    double telaHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        backgroundColor: darkBlueColor,
        title: Image.asset(
          'assets/Captura de tela 2023-09-19 181800.png',
          fit: BoxFit.contain,
          height: 62,
        ),
        centerTitle: true,
      ),
      body: CustomPaint(
        painter: TrianguloPainter(),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 60, left: 10, right: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 2.0),
                        child: Text(
                          'Senha atual',
                          style: GoogleFonts.dosis(
                            textStyle: TextStyle(fontSize: 18, color: darkBlueColor, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      TextFormField(
                        controller: senhaAtual,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, insira uma senha.';
                          }
                          if (!validarSenha(value)) {
                            return 'A senha não atende aos critérios de validação.';
                          }
                          return null; // A senha é válida
                        },
                        obscureText: _showPassword == false ? true : false,
                        cursorColor: Colors.black,
                        decoration: InputDecoration(
                          suffixIcon: GestureDetector(
                            child: Icon(_showPassword == false ? Icons.visibility_off : Icons.visibility, color: Colors.grey),
                            onTap: () {
                              setState(() {
                                _showPassword = !_showPassword;
                              });
                            },
                          ),
                          hintText: 'Senha atual',
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
                      Text(
                        errorMessage,
                        style: TextStyle(color: Colors.red),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                                padding: const EdgeInsets.only(left: 2.0),
                                child: Text(
                                  'Nova Senha',
                                  style: GoogleFonts.dosis(
                                    textStyle: TextStyle(fontSize: 18, color: darkBlueColor, fontWeight: FontWeight.bold),
                                  ),
                                )),
                            TextFormField(
                              controller: novaSenha,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Por favor, insira uma senha.';
                                }
                                if (!validarSenha(value)) {
                                  return 'A senha não atende aos critérios de validação.';
                                }
                                return null; // A senha é válida
                              },
                              obscureText: _showPassword == false ? true : false,
                              cursorColor: Colors.black,
                              decoration: InputDecoration(
                                suffixIcon: GestureDetector(
                                  child: Icon(_showPassword == false ? Icons.visibility_off : Icons.visibility, color: Colors.grey),
                                  onTap: () {
                                    setState(() {
                                      _showPassword = !_showPassword;
                                    });
                                  },
                                ),
                                hintText: 'Nova senha',
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
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: TextFormField(
                          controller: confirmarSenha,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor, insira uma senha.';
                            }
                            if (!validarSenha(value)) {
                              return 'A senha não atende aos critérios de validação.';
                            }
                            if (_validatePasswordMatch(value) != null) {
                              return 'Senhas diferentes';
                            }

                            return null; // A senha é válida
                          },
                          obscureText: _showPassword == false ? true : false,
                          cursorColor: Colors.black,
                          decoration: InputDecoration(
                            suffixIcon: GestureDetector(
                              child: Icon(_showPassword == false ? Icons.visibility_off : Icons.visibility, color: Colors.grey),
                              onTap: () {
                                setState(() {
                                  _showPassword = !_showPassword;
                                });
                              },
                            ),
                            hintText: 'Nova Senha',
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
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: Card(
                            elevation: 10,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(8, 5, 8, 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Regras para criação da senha',
                                    style: GoogleFonts.dosis(
                                      textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Text(
                                    '• Conter pelo menos 6 caracteres',
                                    style: GoogleFonts.dosis(
                                      textStyle: const TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    '• Conter ao menos um dígito',
                                    style: GoogleFonts.dosis(
                                      textStyle: const TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    '• Conter uma letra minúscula',
                                    style: GoogleFonts.dosis(
                                      textStyle: const TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    '• Conter uma letra maiúscula',
                                    style: GoogleFonts.dosis(
                                      textStyle: const TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    '• Conter um caractere especial ',
                                    style: GoogleFonts.dosis(
                                      textStyle: const TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    '• Nao conter nenhum espaco em branco',
                                    style: GoogleFonts.dosis(
                                      textStyle: const TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: telaHeight * 0.020,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 0, left: 10, right: 10),
                  child: SizedBox(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: yellowColor,
                        minimumSize: const Size(
                          double.infinity,
                          50,
                        ),
                      ),
                      onPressed: isLoading
                          ? null
                          : () async {
                              _checkInternetConnection();
                              if (_formKey.currentState!.validate()) {
                                FocusScope.of(context).unfocus();
                                setState(() {
                                  isLoading = true;
                                });

                                bool apiSuccess = await AlterarSenhaDataSorce().alterarSenhaService(passwordNew: novaSenha.text, passwordOld: senhaAtual.text);
                                if (!apiSuccess) {
                                  setState(() {
                                    errorMessage = 'Senha antiga inválida';
                                  });
                                }
                                setState(() {
                                  isLoading = false;
                                });
                                if (apiSuccess) {
                                  // ignore: use_build_context_synchronously
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => SucessoPage(),
                                    ),
                                  );
                                }
                              }
                              novaSenha.clear();
                              confirmarSenha.clear();
                              senhaAtual.clear();
                            },
                      child: isLoading
                          ? const CircularProgressIndicator() // Mostrar indicador de carregamento
                          : Text(
                              'Confirmar',
                              style: GoogleFonts.dosis(
                                textStyle: const TextStyle(
                                  fontSize: 17,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                    ),
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
