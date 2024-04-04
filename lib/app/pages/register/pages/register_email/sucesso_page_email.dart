// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:acessonovo/app/pages/register/pages/register_data/register_page_data.dart';
import 'package:acessonovo/app/pages/register/pages/register_email/error_page.dart';
import 'package:acessonovo/app/services/validar_email_service.dart';
import 'package:acessonovo/app/widget/app_color.dart';
import 'package:acessonovo/app/widget/tringulo_pointer.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EmailSucesso extends StatefulWidget {
  final Map<String, dynamic> qrCodeConsulta;
  final String userEmail;
  EmailSucesso({
    Key? key,
    required this.userEmail,
    required this.qrCodeConsulta,
  }) : super(key: key);

  @override
  State<EmailSucesso> createState() => _EmailSucessoState(qrCodeConsulta);
}

class _EmailSucessoState extends State<EmailSucesso> {
  bool isLoading = false;
  final Map<String, dynamic> qrCodeConsulta;

  _EmailSucessoState(this.qrCodeConsulta);
  bool apiSuccess = false;
  Map<String, dynamic>? apiResponse;
  String? errorMessage;
  @override
  Widget build(BuildContext context) {
    final double buttonWidth = MediaQuery.of(context).size.width * 0.95;
    final double buttonHeight = MediaQuery.of(context).size.height * 0.07;
    double telaHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: darkBlueColor,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        title: Image.asset(
          'assets/Captura de tela 2023-09-19 181800.png',
          fit: BoxFit.contain,
          height: 62,
        ),
        centerTitle: true,
      ),
      body: Container(
        color: Colors.white,
        child: CustomPaint(
          painter: TrianguloPainter(),
          child: Column(
            children: [
              const SizedBox(height: 15),
              SizedBox(
                height: telaHeight * 0.35,
                width: 200,
                child: Image.network('http://acesso.novoatacarejo.com/resources/rede/img/novoImgBemVindo.jpg'),
              ),
              SizedBox(
                height: telaHeight * 0.07,
              ),
              Center(
                child: Text(
                  'Conta criada!',
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
                height: telaHeight * 0.02,
              ),
              Text(
                'Verifique seu e-mail para valida-lo \n antes de continuar',
                style: GoogleFonts.dosis(
                  textStyle: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: telaHeight * 0.1,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10.0, right: 10),
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
                            setState(() {
                              isLoading = true;
                            });
                            apiResponse = await VerificarEmailService().verificarEmail(
                              email: widget.userEmail,
                            );
                            setState(() {
                              isLoading = false;
                            });
                            if (apiResponse!['data'] == 'ok') {
                              // ignore: use_build_context_synchronously
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => RegisterData(
                                    userEmail: widget.userEmail,
                                    qrCodeConsulta: widget.qrCodeConsulta,
                                  ),
                                ),
                              );
                            } else {
                              // ignore: use_build_context_synchronously
                              setState(() {
                                          errorMessage = apiResponse!['errors'][0];
                                        });
                            }
                          },
                    child: isLoading
                        ? const CircularProgressIndicator() // Mostrar indicador de carregamento
                        : Text(
                            "Continuar",
                            style: GoogleFonts.dosis(
                              textStyle: const TextStyle(
                                fontSize: 17,
                              ),
                            ),
                          ),
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
      ),
    );
  }
}
