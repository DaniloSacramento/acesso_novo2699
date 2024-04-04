// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:io';
import 'dart:typed_data';

import 'package:acessonovo/app/pages/register/pages/register_diretrizes/register_diretrizes.dart';
import 'package:acessonovo/app/services/foto_service_register.dart';
import 'package:acessonovo/app/widget/app_color.dart';
import 'package:acessonovo/app/widget/tringulo_pointer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class RegisterFoto extends StatefulWidget {
  final String userEmail;
  final Map<String, dynamic> qrCodeConsulta;
  const RegisterFoto({
    Key? key,
    required this.userEmail,
    required this.qrCodeConsulta,
  }) : super(key: key);

  @override
  State<RegisterFoto> createState() => _RegisterFotoState();
}

class _RegisterFotoState extends State<RegisterFoto> {
  bool isLoading = false;
  Uint8List? imageBytes;
  final ImagePicker _imagePicker = ImagePicker();
  File? imageFile;

  pick(ImageSource source) async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: source,
      );
      if (image != null) {
        imageFile = File(image.path);

        if (imageFile!.existsSync()) {
          final compressedImageBytes = await FlutterImageCompress.compressWithFile(
            imageFile!.path,
            quality: 85,
          );

          if (compressedImageBytes != null) {
            imageBytes = Uint8List.fromList(compressedImageBytes);
          }

          setState(() {});
        }
      }
      final respostaAPI = await Cadastrarfoto().cadastrarfotoPromotor(email: widget.userEmail, file: imageBytes!);
      if (respostaAPI != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => DiretrizesRegister(
              qrCodeConsulta: widget.qrCodeConsulta,
            ),
          ),
        );
      } else {
        Fluttertoast.showToast(
          msg: 'Erro ao enviar a foto. Tente novamente.',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      }
    } catch (e) {
      print('Erro ao selecionar a imagem: $e');
    }
  }

  Color darkBlueColor = const Color(0xFF0C2356);

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
              SizedBox(
                height: telaHeight * 0.1,
              ),
              Center(
                child: Text(
                  'Estamos quase lá!',
                  style: GoogleFonts.dosis(
                    textStyle: TextStyle(color: darkBlueColor, fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              SizedBox(
                height: telaHeight * 0.055,
              ),
              Text(
                'Agora, precisamos de uma foto sua \n tudo bem?',
                style: GoogleFonts.dosis(
                  textStyle: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: telaHeight * 0.055,
              ),
              Text(
                'Tire uma selfie com a camera \nposicionada a frente de seu rosto e \nombros',
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
                height: telaHeight * 0.097,
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
                            await pick(ImageSource.camera);

                           
                            setState(() {
                              isLoading = false;
                            });

                         
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
              )
            ],
          ),
        ),
      ),
    );
  }
}