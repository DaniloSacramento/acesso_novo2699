import 'package:acessonovo/app/pages/register/pages/register_email/register_email_page.dart';
import 'package:acessonovo/app/services/validar_codigo_qrcode_service.dart';
import 'package:acessonovo/app/widget/app_color.dart';
import 'package:acessonovo/app/widget/tringulo_pointer.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QrCodePage extends StatefulWidget {
  const QrCodePage({super.key});

  @override
  State<QrCodePage> createState() => _QrCodePageState();
}

class _QrCodePageState extends State<QrCodePage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  late QRViewController controller;
  bool isError = false;
  Barcode? result;
  String scannedCode = '';
  String errorMessage = '';
  var scanArea = 290.0;

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) async {
      setState(() {
        scannedCode = scanData.code ?? '';
      });
      controller.pauseCamera();
      try {
        final apiResponse = await ValidarCodigoEmpresa().validarCodigoQr(scannedCode);

        // ignore: use_build_context_synchronously
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RegisterEmail(
              qrCodeConsulta: apiResponse,
              codigo: scannedCode,
            ),
          ),
        );
      } catch (e) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(
                'Código QR Inválido',
                style: GoogleFonts.dosis(
                  textStyle: TextStyle(
                    fontSize: 17,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              content: Text(
              'O código QR lido não é válido. Tente novamente.',
              style: GoogleFonts.dosis(
                textStyle: TextStyle(
                 fontSize: 17,
                 color: darkBlueColor,
                 fontWeight: FontWeight.bold,
              ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    controller.resumeCamera();
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      }
    });
  }

  void dispose() {
    controller.dispose();
    super.dispose();
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
        child: CustomPaint(
          painter: TrianguloPainter(),
          child: Center(
            child: Column(
              children: [
                SizedBox(
                  height: telaHeight * 0.2,
                ),
                Text(
                  "Centralize o QR Code \ndo Fornecedor/Agência",
                  style: GoogleFonts.dosis(
                    textStyle: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: darkBlueColor,
                    ),
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: telaHeight * 0.02,
                ),
                SizedBox(
                  width: 300,
                  height: 300,
                  child: QRView(
                    key: qrKey,
                    onQRViewCreated: _onQRViewCreated,
                    overlay: QrScannerOverlayShape(
                      cutOutSize: scanArea,
                      borderWidth: 10,
                      borderLength: 40,
                      borderRadius: 5.0,
                      borderColor: const Color(
                        0xffF7524F,
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
