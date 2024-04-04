import 'dart:async';
import 'package:acessonovo/app/pages/login/login_page.dart';
import 'package:acessonovo/app/pages/register/pages/qrCode/qrCode_page.dart';
import 'package:acessonovo/app/widget/app_color.dart';
import 'package:acessonovo/app/widget/tringulo_pointer.dart';

import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';

class InputScreen extends StatefulWidget {
  const InputScreen({super.key});

  @override
  State<InputScreen> createState() => _InputScreenState();
}

class _InputScreenState extends State<InputScreen> {
  @override
  Widget build(BuildContext context) {
    double telaHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(automaticallyImplyLeading: false, backgroundColor: darkBlueColor),
      body: Container(
        color: Colors.white,
        child: CustomPaint(
          painter: TrianguloPainter(),
          child: Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset(
                    'assets/Captura de tela 2023-09-19 181258.png',
                    height: 100,
                    width: 250,
                  ),
                  const SizedBox(height: 20),
                  Image.network(
                    'http://acesso.novoatacarejo.com/resources/rede/img/novoImgBemVindo.jpg',
                    height: 150,
                    width: 150,
                  ),
                  SizedBox(
                    height: telaHeight * 0.15,
                  ),
                  SizedBox(
                    height: telaHeight * 0.18,
                    child: Column(
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: yellowColor,
                            minimumSize: const Size(double.infinity, 50), // Largura total e altura mínima
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const QrCodePage(),
                              ),
                            );
                          },
                          child: Text(
                            "Quero me cadastrar",
                            style: GoogleFonts.dosis(
                              textStyle: const TextStyle(
                                color: Colors.black,
                                fontSize: 17,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            minimumSize: const Size(double.infinity, 50), // Largura total e altura mínima
                          ),
                          onPressed: () async {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LoginPage(
                                  qrCodeConsulta: {},
                                ),
                              ),
                            );
                          },
                          child: Text(
                            "Já tenho conta",
                            style: GoogleFonts.dosis(
                              textStyle: const TextStyle(
                                color: Colors.black,
                                fontSize: 17,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
