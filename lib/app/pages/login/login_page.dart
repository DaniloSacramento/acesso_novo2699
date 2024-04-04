// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:acessonovo/app/pages/home/home_page.dart';
import 'package:acessonovo/app/pages/redefine_password/redefine_password_page.dart';
import 'package:acessonovo/app/pages/termo/termo_page.dart';
import 'package:acessonovo/app/services/auth_promoter.dart';
import 'package:acessonovo/app/widget/app_color.dart';
import 'package:acessonovo/app/widget/tringulo_pointer.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

enum LoginPageRota { login }

extension InitialHomePageExt on InitialHomePage {
  // ignore: unrelated_type_equality_checks
  bool get isLogin => this == LoginPageRota.login;
}

class LoginPage extends StatefulWidget {
  final Map<String, dynamic> qrCodeConsulta;
  const LoginPage({
    Key? key,
    required this.qrCodeConsulta,
  }) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  Future<void> _checkInternetConnection() async {
    var connectivityResult = await (Connectivity().checkConnectivity());

    if (connectivityResult == ConnectivityResult.none) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            // ignore: prefer_const_constructors
            title: Text('Sem conexão com a internet'),
            content:
                Text('Verifique sua conexão com a internet e tente novamente.'),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
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

  String? errorMessage;
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

  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _showPassword = false;
  bool _isLoading = false;
  bool _isFormValid = false;
  bool _isButtonDisabled = false;
  final bool _buttonClicked = false;

  @override
  Widget build(BuildContext context) {
    const double buttonWidthPercentage = 0.95;
    const double buttonHeightPercentage = 0.07;
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
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () async {
              FocusScope.of(context).unfocus();
              await Future.delayed(const Duration(milliseconds: 200));
              // ignore: use_build_context_synchronously
              Navigator.pop(context);
            },
          ),
        ),
        body: SingleChildScrollView(
          child: CustomPaint(
            painter: TrianguloPainter(),
            child: Column(
              children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 50,
                        left: 15,
                      ),
                      child: Text("Seja, bem-vindo!",
                          style: GoogleFonts.dosis(
                            textStyle: TextStyle(
                              fontSize: 24,
                              color: darkBlueColor,
                              fontWeight: FontWeight.bold,
                            ),
                          )),
                    )
                  ],
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Padding(
                        padding:
                            const EdgeInsets.only(top: 30, left: 10, right: 10),
                        child: TextFormField(
                          cursorColor: Colors.black,
                          decoration: InputDecoration(
                            // labelText: "E-mail",
                            // labelStyle: const TextStyle(
                            //   color: Colors.black,
                            // ),
                            hintText: 'E-mail', hintStyle: GoogleFonts.dosis(),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                12.0,
                              ),
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            fillColor: Colors.grey[300],
                            prefixIcon: const Icon(
                              Icons.email,
                              color: Colors.grey,
                            ),
                          ),
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          validator: (email) {
                            if (email == null || email.isEmpty) {
                              return 'Por favor, insira um e-mail.';
                            } else if (!RegExp(
                                    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                .hasMatch(_emailController.text)) {
                              return 'Digite um e-mail correto ';
                            }
                            return null;
                          },
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(top: 10, left: 10, right: 10),
                        child: TextFormField(
                          cursorColor: Colors.black,
                          decoration: InputDecoration(
                            // labelText: "Senha",
                            // labelStyle: const TextStyle(
                            //   color: Colors.black,
                            // ),
                            hintText: 'Senha', hintStyle: GoogleFonts.dosis(),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                12.0,
                              ),
                              borderSide: BorderSide.none,
                            ),
                            suffixIcon: GestureDetector(
                              child: Icon(
                                  _showPassword == false
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: Colors.grey),
                              onTap: () {
                                setState(() {
                                  _showPassword = !_showPassword;
                                });
                              },
                            ),
                            filled: true,
                            fillColor: Colors.grey[300],
                            prefixIcon: const Icon(
                              Icons.lock,
                              color: Colors.grey,
                            ),
                          ),
                          obscureText: _showPassword == false ? true : false,
                          controller: _passwordController,
                          keyboardType: TextInputType.text,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor, insira uma senha.';
                            }
                            if (!validarSenha(value)) {
                              return 'A senha não atende aos critérios de validação.';
                            }
                            return null;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const RedefinePassword(),
                                    ));
                              },
                              child: Text(
                                "Esqueceu sua senha",
                                style: GoogleFonts.dosis(
                                  textStyle: const TextStyle(
                                      color: Colors.grey, fontSize: 16),
                                ),
                                softWrap: false,
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0, right: 10),
                  child: SizedBox(
                    child: SizedBox(
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: yellowColor,
                          minimumSize: const Size(double.infinity, 50),
                        ),
                        onPressed: _isLoading
                            ? null
                            : () async {
                                FocusScope.of(context).unfocus();
                                _checkInternetConnection();
                                if (_formKey.currentState!.validate()) {
                                  setState(() {
                                    _isLoading = true;
                                  });
                                  FocusScopeNode currentFocus =
                                      FocusScope.of(context);
                                  String? deuCerto = await login(
                                      _emailController.text,
                                      _passwordController.text);
                                  if (!currentFocus.hasPrimaryFocus) {
                                    currentFocus.unfocus();
                                  }

                                  if (deuCerto == null) {
                                   
                                    Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => TermoPage()),
                                      (r) => false,
                                    );
                                  } else {
                                                           
                                    setState(() {
                                      errorMessage = deuCerto;
                                    });
                                    _passwordController.clear();
                                  }
                                  setState(() {
                                    _isLoading = false;
                                  });
                                }
                              },
                        child: _isLoading
                            ? const CircularProgressIndicator() // Exibe o indicador de progresso.
                            : Text(
                                'Entrar',
                                style: GoogleFonts.dosis(
                                  textStyle: const TextStyle(
                                      color: Colors.black, fontSize: 17),
                                ),
                              ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                  child: errorMessage != null
                      ? Text(
                          errorMessage!,
                          style: TextStyle(color: Colors.red, fontSize: 16),
                        )
                      : SizedBox(),
                ),
              ],
            ),
          ),
        ));
  }


}
