// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:acessonovo/app/pages/login/login_page.dart';
import 'package:acessonovo/app/widget/app_color.dart';
import 'package:acessonovo/app/widget/tringulo_pointer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SucessoRegisterPage extends StatefulWidget {
  final Map<String, dynamic> qrCodeConsulta;
  const SucessoRegisterPage({
    Key? key,
    required this.qrCodeConsulta,
  }) : super(key: key);

  @override
  State<SucessoRegisterPage> createState() => _SucessoRegisterPageState();
}

class _SucessoRegisterPageState extends State<SucessoRegisterPage> {
  @override
  Widget build(BuildContext context) {
    final double buttonWidth = MediaQuery.of(context).size.width * 0.95;
    final double buttonHeight = MediaQuery.of(context).size.height * 0.07;
    double screenHeight = MediaQuery.of(context).size.height;
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
              const SizedBox(height: 10),
              SizedBox(
                height: screenHeight * 0.4,
                width: 250,
                child: Image.network('http://acesso.novoatacarejo.com/resources/rede/img/novoImgCadSucesso.jpg'),
              ),
              SizedBox(
                height: screenHeight * 0.02,
              ),
              Center(
                child: Text(
                  'Maravilha!',
                  style: GoogleFonts.dosis(
                    textStyle: TextStyle(color: darkBlueColor, fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              SizedBox(
                height: screenHeight * 0.04,
              ),
              Text(
                'O seu cadastro foi realizado com \nsucesso e enviado para aprovacao',
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
                height: screenHeight * 0.09,
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: SizedBox(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: yellowColor,
                        minimumSize: const Size(
                          double.infinity,
                          50,
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LoginPage(
                              qrCodeConsulta: widget.qrCodeConsulta,
                            ),
                          ),
                        );
                      },
                      child: Text(
                        'Ir para o login',
                        style: GoogleFonts.dosis(
                          textStyle: const TextStyle(fontSize: 17, color: Colors.black),
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
    );
  }
}
