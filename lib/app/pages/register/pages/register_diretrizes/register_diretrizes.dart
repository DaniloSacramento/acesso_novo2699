// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:acessonovo/app/pages/register/pages/register_diretrizes/sucesso_page._register.dart';
import 'package:acessonovo/app/widget/app_color.dart';
import 'package:acessonovo/app/widget/tringulo_pointer.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DiretrizesRegister extends StatefulWidget {
  final Map<String, dynamic> qrCodeConsulta;
  const DiretrizesRegister({
    Key? key,
    required this.qrCodeConsulta,
  }) : super(key: key);

  @override
  State<DiretrizesRegister> createState() => _DiretrizesRegisterState(
        qrCodeConsulta,
      );
}

class _DiretrizesRegisterState extends State<DiretrizesRegister> {
  final Map<String, dynamic> qrCodeConsulta;

  _DiretrizesRegisterState(this.qrCodeConsulta);

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
        child: CustomPaint(
          painter: TrianguloPainter(),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 25,
                ),
                Text(
                  'Suas Diretrizes',
                  style: GoogleFonts.dosis(
                    textStyle: TextStyle(color: darkBlueColor, fontSize: 26, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  height: telaHeight * 0.015,
                ),
                Text(
                  'Prezado(a) Promotor(a),',
                  style: GoogleFonts.dosis(textStyle: const TextStyle(fontSize: 18, color: Colors.grey)),
                ),
                SizedBox(
                  height: telaHeight * 0.015,
                ),
                SizedBox(
                  height: telaHeight * 0.60,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Text(
                          'Considerando o início da sua prestação de serviços em nossa empresa, precisamos de \nnormas e regras para que seja agradável a todos, abaixo informamos alguns ítens que\ndevem ser cumpridos:',
                          style: GoogleFonts.dosis(textStyle: const TextStyle(fontSize: 18, color: Colors.grey)),
                          textAlign: TextAlign.start,
                        ),
                        SizedBox(
                          height: telaHeight * 0.015,
                        ),
                        Text(
                          '1. Respeito às normas de segurança da empresa;',
                          style: GoogleFonts.dosis(textStyle: TextStyle(fontSize: 18, color: darkBlueColor, fontWeight: FontWeight.bold)),
                        ),
                        SizedBox(
                          height: telaHeight * 0.015,
                        ),
                        Text(
                          '2. Cumprimento integral do contrato de trabalho com o seu empregador, principalmente\ncom relação ao abastecimento e promoção dos itens daquela empresa;',
                          style: GoogleFonts.dosis(textStyle: TextStyle(fontSize: 18, color: darkBlueColor, fontWeight: FontWeight.bold)),
                        ),
                        SizedBox(
                          height: telaHeight * 0.015,
                        ),
                        Text(
                          '3. A relação de subordinação é única e exclusiva do supervisor imediato da sua\nempresa, não cabendo a nenhum representante do ${qrCodeConsulta['nomeFantasia']} esta função;',
                          style: GoogleFonts.dosis(textStyle: TextStyle(fontSize: 18, color: darkBlueColor, fontWeight: FontWeight.bold)),
                        ),
                        SizedBox(
                          height: telaHeight * 0.015,
                        ),
                        Text(
                          '4. O horário de trabalho em nossos \nestabelecimentos para realização de suas \natividades fica pré-estabelecido das 07h às \n18h, cabendo ao ${qrCodeConsulta['nomeFantasia']} apenas informar \nao seu empregador caso haja \nalgum descumprimento no acordo comercial firmado entre o ${qrCodeConsulta['nomeFantasia']} e o seu empregador;',
                          style: GoogleFonts.dosis(textStyle: TextStyle(fontSize: 18, color: darkBlueColor, fontWeight: FontWeight.bold)),
                        ),
                        SizedBox(
                          height: telaHeight * 0.015,
                        ),
                        Text(
                          '5. É obrigatório o uso de EPI nas dependências do ${qrCodeConsulta['nomeFantasia']}',
                          style: GoogleFonts.dosis(textStyle: TextStyle(fontSize: 18, color: darkBlueColor, fontWeight: FontWeight.bold)),
                        ),
                        SizedBox(
                          height: telaHeight * 0.015,
                        ),
                        Text(
                          'Esclarecemos que a responsabilidade de \natendimento aos clientes é exclusiva \ndos colaboradores do ${qrCodeConsulta['nomeFantasia']} apenas informar \nao seu empregador caso haja \nalgum descumprimento no acordo comercial firmado entre o ${qrCodeConsulta['nomeFantasia']}. Caso seja \nabordado por algum cliente, solicitamos que o \nencaminhe ao colaborador mais próximo.',
                          style: GoogleFonts.dosis(textStyle: const TextStyle(fontSize: 18, color: Colors.grey)),
                        ),
                        SizedBox(
                          height: telaHeight * 0.015,
                        ),
                        Text(
                          'Por fim, o ${qrCodeConsulta['nomeFantasia']} apenas informar \nao seu empregador caso haja \nalgum descumprimento no acordo comercial firmado entre o ${qrCodeConsulta['nomeFantasia']} esclarece que não exerce \nnenhuma ação para impedir a suaentrada ou \nsaída durante os horários de funcionamento \nde suas lojas, desde que ocorra nos horários \nacima descritos.',
                          style: GoogleFonts.dosis(textStyle: const TextStyle(fontSize: 18, color: Colors.grey)),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: telaHeight * 0.001,
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
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SucessoRegisterPage(
                                qrCodeConsulta: widget.qrCodeConsulta,
                              ),
                            ),
                          );
                        },
                        child: Text(
                          'Continuar',
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
    );
  }
}
