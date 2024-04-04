// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:acessonovo/app/const/const.dart';
import 'package:acessonovo/app/pages/register/pages/register_email/sucesso_page_email.dart';
import 'package:acessonovo/app/services/validar_codigo_empresa_service.dart';
import 'package:acessonovo/app/widget/app_color.dart';
import 'package:acessonovo/app/widget/tringulo_pointer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import 'package:google_fonts/google_fonts.dart';

class RegisterEmail extends StatefulWidget {
  final Map<String, dynamic> qrCodeConsulta;
  final String codigo;
  const RegisterEmail({
    Key? key,
    required this.qrCodeConsulta,
    required this.codigo,
  }) : super(key: key);

  @override
  State<RegisterEmail> createState() =>
      _RegisterEmailState(qrCodeConsulta, codigo);
}

class _RegisterEmailState extends State<RegisterEmail> {
  final emailController = TextEditingController();
  bool isLoading = false;
  final _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> qrCodeConsulta;
  _RegisterEmailState(this.qrCodeConsulta, String codigo);

  @override
  Widget build(BuildContext context) {
    final double buttonWidth = MediaQuery.of(context).size.width * 0.95;
    final double buttonHeight = MediaQuery.of(context).size.height * 0.07;
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
              padding: const EdgeInsets.all(12.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: telaHeight * 0.015,
                    ),
                    Text(
                      'Antes de tudo, \nvamos criar \nsua conta.',
                      style: GoogleFonts.dosis(
                        textStyle: TextStyle(
                            color: darkBlueColor,
                            fontSize: 26,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: telaHeight * 0.06,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 2.0),
                            child: Text(
                              'E-mail',
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
                            controller: emailController,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Por favor, insira um endereço de e-mail.';
                              }
                              if (!RegExp(r"^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+$")
                                  .hasMatch(value)) {
                                return 'Insira um endereço de e-mail válido.';
                              }
                              return null;
                            },
                            cursorColor: Colors.black,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.grey[300],
                              hintText: "E-mail",
                              hintStyle: GoogleFonts.dosis(),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                  12.0,
                                ),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: telaHeight * 0.013,
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: Container(
                              color: Colors.white,
                              child: Card(
                                elevation: 10,
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(8, 5, 8, 20),
                                  child: Column(
                                    children: [
                                      qrCodeConsulta['logoMarca'] != null
                                          ? SizedBox(
                                              height: 50,
                                              width: 100,
                                              child: Image.network(
                                                ConstsApi.fotoURL +
                                                    qrCodeConsulta['logoMarca'],
                                              ))
                                          : const Icon(Icons.camera_alt,
                                              size: 48, color: Colors.grey),
                                      Text(
                                        qrCodeConsulta['nomeFantasia'],
                                        style: GoogleFonts.dosis(
                                          textStyle: const TextStyle(
                                            color: Colors.grey,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 17,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        qrCodeConsulta['razaoSocial']
                                            .toString(),
                                        style: GoogleFonts.dosis(
                                          textStyle: const TextStyle(
                                              fontSize: 14, color: Colors.grey),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: telaHeight * 0.08,
                          ),
                          Padding(
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
                                          final success =
                                              await CodigoEmpresaService()
                                                  .codigoEmpresa(
                                            email: emailController.text,
                                            codigo: widget.codigo,
                                          );
                                          setState(() {
                                            isLoading = false;
                                          });
                                          if (success) {
                                            // ignore: use_build_context_synchronously
                                            Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    EmailSucesso(
                                                  userEmail:
                                                      emailController.text,
                                                  qrCodeConsulta:
                                                      widget.qrCodeConsulta,
                                                ),
                                              ),
                                            );
                                          } else {
                                            // ignore: use_build_context_synchronously
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(snackBar);
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
                          )
                        ],
                      ),
                    ),
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
      'E-mail já cadastrado',
      textAlign: TextAlign.center,
    ),
    backgroundColor: Colors.red,
  );
}
