// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:acessonovo/app/pages/register/pages/register_foto/register_foto.dart';
import 'package:acessonovo/app/services/registar_usuario_service.dart';
import 'package:acessonovo/app/widget/app_color.dart';
import 'package:acessonovo/app/widget/tringulo_pointer.dart';
import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';

class RegisterSenha extends StatefulWidget {
  final String userNome;
  final String userCpf;
  final String userDtNascimento;
  final String userTelefone;
  final String userEmail;
  final Map<String, dynamic> qrCodeConsulta;

  const RegisterSenha({
    Key? key,
    required this.userNome,
    required this.userCpf,
    required this.userDtNascimento,
    required this.userTelefone,
    required this.userEmail,
    required this.qrCodeConsulta,
  }) : super(key: key);

  @override
  State<RegisterSenha> createState() => _RegisterSenhaState();
}

class _RegisterSenhaState extends State<RegisterSenha> {
  String? _validatePasswordMatch(String value) {
    if (value != suaSenha.text) {
      return 'As senhas não coincidem';
    }
    return null;
  }

  bool _showPassword = false;
  TextEditingController confirmarSenha = TextEditingController();
  TextEditingController suaSenha = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  Color darkBlueColor = const Color(0xFF0C2356);
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
      body: Container(
        color: Colors.white,
        child: SingleChildScrollView(
          child: CustomPaint(
            painter: TrianguloPainter(),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 30,
                    ),
                    Text(
                      'Cria sua senha',
                      style: GoogleFonts.dosis(
                        textStyle: TextStyle(color: darkBlueColor, fontSize: 26, fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(
                      height: telaHeight * 0.04,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 2.0),
                      child: Text(
                        'Senha',
                        style: GoogleFonts.dosis(
                          textStyle: TextStyle(
                            fontSize: 18,
                            color: darkBlueColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    TextFormField(
                      controller: suaSenha,
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
                      cursorColor: Colors.grey,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey[300],
                        suffixIcon: GestureDetector(
                          child: Icon(_showPassword == false ? Icons.visibility_off : Icons.visibility, color: Colors.grey),
                          onTap: () {
                            setState(() {
                              _showPassword = !_showPassword;
                            });
                          },
                        ),
                        hintText: "Senha",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            12.0,
                          ),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: telaHeight * 0.03,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 2.0),
                      child: Text(
                        'Confirmar Senha',
                        style: GoogleFonts.dosis(
                          textStyle: TextStyle(
                            fontSize: 18,
                            color: darkBlueColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    TextFormField(
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
                        return null;
                      },
                      obscureText: _showPassword == false ? true : false,
                      cursorColor: Colors.grey,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey[300],
                        suffixIcon: GestureDetector(
                          child: Icon(_showPassword == false ? Icons.visibility_off : Icons.visibility, color: Colors.grey),
                          onTap: () {
                            setState(() {
                              _showPassword = !_showPassword;
                            });
                          },
                        ),
                        hintText: "Confirmar senha",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            12.0,
                          ),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ), 
                    
                    SizedBox(
                      height: telaHeight * 0.02,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 0),
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
                                  'Regras para criacao da senha',
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
                    SizedBox(
                      height: telaHeight * 0.07,
                    ),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 0, right: 0),
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
                                    if (_formKey.currentState!.validate()) {
                                      FocusScope.of(context).unfocus();
                                      setState(() {
                                        isLoading = true;
                                      });
                                      final success = await RegistrarUsuarioService().registarUsuario(
                                        email: widget.userEmail,
                                        nome: widget.userNome,
                                        cpf: widget.userCpf,
                                        dtNascimento: widget.userDtNascimento,
                                        password: suaSenha.text,
                                        telefone: widget.userTelefone,
                                      );
                                      setState(() {
                                        isLoading = false;
                                      });
                                      if (success) {
                                        // ignore: use_build_context_synchronously
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => RegisterFoto(
                                              userEmail: widget.userEmail,
                                              qrCodeConsulta: widget.qrCodeConsulta,
                                            ),
                                          ),
                                        );
                                      } else {
                                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                      }
                                    }
                                  },
                            child: isLoading
                                ? const CircularProgressIndicator() // Mostrar indicador de carregamento
                                : Text(
                                    "Continuar",
                                    style: GoogleFonts.dosis(
                                      textStyle: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 17,
                                      ),
                                    ),
                                  ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  final snackBar = const SnackBar(
    content: Text(
      'Algo deu errado, revise seus dados cadastrais',
      textAlign: TextAlign.center,
    ),
    backgroundColor: Colors.red,
  );
}
