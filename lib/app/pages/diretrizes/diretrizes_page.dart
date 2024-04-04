import 'dart:convert';
import 'package:acessonovo/app/models/user_promote.dart';
import 'package:acessonovo/app/widget/app_color.dart';
import 'package:acessonovo/app/widget/tringulo_pointer.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Diretrizes extends StatefulWidget {
  const Diretrizes({super.key});

  @override
  State<Diretrizes> createState() => _DiretrizesState();
}

class _DiretrizesState extends State<Diretrizes> {
  UserPromote? user;

  _getUser() async {
    final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final result = sharedPreferences.getString('data');
    setState(() {
      user = UserPromote.fromMap(jsonDecode(result!)['data']);
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        _getUser();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final double buttonWidth = MediaQuery.of(context).size.width * 0.95;
    final double buttonHeight = MediaQuery.of(context).size.height * 0.07;
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
      body: SingleChildScrollView(
        child: CustomPaint(
          painter: TrianguloPainter(),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 25,
                ),
                Text(
                  'Suas Diretrizes',
                  style: GoogleFonts.dosis(
                    textStyle: TextStyle(color: darkBlueColor, fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Text(
                  'Prezado(a) Promotor(a),',
                  style: GoogleFonts.dosis(textStyle: const TextStyle(fontSize: 18, color: Colors.grey)),
                ),
                SizedBox(
                  height: 15,
                ),
                Text(
                  'Considerando o início da sua prestação de serviços em nossa empresa, precisamos de \nnormas e regras para que seja agradável a todos, abaixo informamos alguns ítens que\ndevem ser cumpridos:',
                  style: GoogleFonts.dosis(textStyle: const TextStyle(fontSize: 18, color: Colors.grey)),
                  textAlign: TextAlign.start,
                ),
                SizedBox(
                  height: 15,
                ),
                Text(
                  '1. Respeito às normas de segurança da empresa;',
                  style: GoogleFonts.dosis(textStyle: TextStyle(fontSize: 18, color: darkBlueColor, fontWeight: FontWeight.bold)),
                ),
                SizedBox(
                  height: 15,
                ),
                Text(
                  '2. Cumprimento integral do contrato de trabalho com o seu empregador, principalmente\ncom relação ao abastecimento e promoção dos itens daquela empresa;',
                  style: GoogleFonts.dosis(textStyle: TextStyle(fontSize: 18, color: darkBlueColor, fontWeight: FontWeight.bold)),
                ),
                SizedBox(
                  height: 15,
                ),
                Text(
                  '3. A relação de subordinação é única e exclusiva do supervisor imediato da sua\nempresa, não cabendo a nenhum representante do ${user!.empresa} esta função;',
                  style: GoogleFonts.dosis(textStyle: TextStyle(fontSize: 18, color: darkBlueColor, fontWeight: FontWeight.bold)),
                ),
                SizedBox(
                  height: 15,
                ),
                Text(
                  '4. O horário de trabalho em nossos \nestabelecimentos para realização de suas \natividades fica pré-estabelecido das 07h às \n18h, cabendo ao ${user!.empresa} apenas informar \nao seu empregador caso haja \nalgum descumprimento no acordo comercial firmado entre o ${user!.empresa} e o seu empregador;',
                  style: GoogleFonts.dosis(textStyle: TextStyle(fontSize: 18, color: darkBlueColor, fontWeight: FontWeight.bold)),
                ),
                SizedBox(
                  height: 15,
                ),
                Text(
                  '5. É obrigatório o uso de EPI nas \ndependências do ${user!.empresa}',
                  style: GoogleFonts.dosis(textStyle: TextStyle(fontSize: 18, color: darkBlueColor, fontWeight: FontWeight.bold)),
                ),
                SizedBox(
                  height: 15,
                ),
                Text(
                  'Esclarecemos que a responsabilidade de \natendimento aos clientes é exclusiva \ndos colaboradores do ${user!.empresa}. Caso seja \nabordado por algum cliente, solicitamos que o \nencaminhe ao colaborador mais próximo.',
                  style: GoogleFonts.dosis(textStyle: const TextStyle(fontSize: 18, color: Colors.grey)),
                ),
                SizedBox(
                  height: 15,
                ),
                Text(
                  'Por fim, o ${user!.empresa} esclarece que não exerce \nnenhuma ação para impedir a suaentrada ou \nsaída durante os horários de funcionamento \nde suas lojas, desde que ocorra nos horários \nacima descritos.',
                  style: GoogleFonts.dosis(textStyle: const TextStyle(fontSize: 18, color: Colors.grey)),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TrianguloPainterDiretrizes extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    paint.color = darkBlueColor;
    paint.style = PaintingStyle.fill;
    const scaleFactor = 0.060;
    const widthFactor = 1.9;
    final triangleWidth = size.width * scaleFactor;
    final triangleHeight = size.height * scaleFactor;

    final path = Path()
      ..moveTo(size.width, 0)
      ..lineTo(size.width, triangleHeight)
      ..lineTo(size.width - triangleWidth * widthFactor, 0)
      ..lineTo(size.width - triangleWidth, 0)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
