import 'dart:convert';
import 'package:acessonovo/app/models/escala_promotor.dart';
import 'package:acessonovo/app/models/user_promote.dart';
import 'package:acessonovo/app/services/escala_service.dart';
import 'package:acessonovo/app/widget/app_color.dart';
import 'package:acessonovo/app/widget/tringulo_pointer.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override

  // ignore: library_private_types_in_public_api
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<EscalaPromotor>? escalas;
  bool _isLoading = false;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        _getUser();
      },
    );
  }

  String formatarCPF(String cpf) {
    // Limpa o CPF, removendo caracteres não numéricos
    cpf = cpf.replaceAll(RegExp(r'\D'), '');

    // Adiciona pontos e traço ao CPF
    return "${cpf.substring(0, 3)}.${cpf.substring(3, 6)}.${cpf.substring(6, 9)}-${cpf.substring(9)}";
  }

  UserPromote? user;
  _getUser() async {
    final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final result = sharedPreferences.getString('data');
    user = UserPromote.fromMap(jsonDecode(result!)['data']);
    escalas = await fetchEscalas(user!.email);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    
    final screenWidth = MediaQuery.of(context).size.width;
    final fontSize = screenWidth * 0.040;
    final isLoading = this.user == null;

    if (isLoading) {
      return const Material(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    UserPromote user = this.user!;
    if (escalas == null || escalas!.isEmpty) {
       double telaHeight = MediaQuery.of(context).size.height;
      return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                          iconPadding: EdgeInsets.zero,
                          icon: Row(
                            children: [
                              IconButton(
                                onPressed: () => Navigator.pop(context),
                                icon: const Icon(Icons.close),
                              ),
                            ],
                          ),
                          scrollable: true,
                          content: Column(
                            children: [
                                  SizedBox(
                          width: 200,
                          height: 200,
                          child: QrImageView(
                            data: user!.cpf,
                            version: QrVersions.auto,
                            size: 200.00,
                            backgroundColor: Colors.white,
                          ),
                        ),
        
                        Text(
                          'QR Code gerado!',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.dosis(
                            textStyle: const TextStyle(
                                fontSize: 24, 
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                              Text(
                                "Apresente este QR\nCode para o fiscal na\n entrada da loja",
                                textAlign: TextAlign.center,
                                style: GoogleFonts.dosis(
                                  textStyle: const TextStyle(
                                    fontSize: 22,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              )
                            ],
                          ));
                    });
              },
              icon: const Icon(
                Icons.qr_code,
                color: Colors.white,
              ),
            ),
          ],
          automaticallyImplyLeading: false,
          backgroundColor: darkBlueColor,
          centerTitle: true,
          title: Image.asset(
            'assets/Captura de tela 2023-09-19 181800.png',
            fit: BoxFit.contain,
            height: 62,
          ),
        ),
        body: Container(
          color: Colors.white,
          child: CustomPaint(
            painter: TrianguloPainter(),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 400,
                    width: 950,
                    child: Image.asset('assets/Captura de tela 2023-09-19 195450.png'),
                  ),
                  Text(
                    'Não há escalas disponíveis',
                    style: GoogleFonts.dosis(
                      textStyle: TextStyle(
                        fontSize: 28,
                        color: darkBlueColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(
                     height: telaHeight * 0.01,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: yellowColor,
                          minimumSize: const Size(double.infinity, 50),
                        ),
                        onPressed: _isLoading
                            ? null
                            : () async {
                                setState(() {
                                  _isLoading = true;
                                });
                                _getUser();
                                setState(() {
                                  _isLoading = false;
                                });
                              },
                        child: _isLoading
                            ? const CircularProgressIndicator() // Exibe o indicador de progresso.
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.refresh,
                                  ),
                                  Text(
                                    'Atualizar',
                                    style: GoogleFonts.dosis(
                                      textStyle: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              )),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }
    String nomeCompleto = user.nome;
    List<String> partesDoNome = nomeCompleto.split(' ');
    String primeiroNome = partesDoNome.isNotEmpty ? partesDoNome[0] : '';
    double telaHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                        iconPadding: EdgeInsets.zero,
                        icon: Row(
                          children: [
                            IconButton(
                              onPressed: () => Navigator.pop(context),
                              icon: const Icon(Icons.close),
                            ),
                          ],
                        ),
                        scrollable: true,
                        content: Column(
                          children: [
                             SizedBox(
                          width: 200,
                          height: 200,
                          child: QrImageView(
                            data: user!.cpf,
                            version: QrVersions.auto,
                            size: 200.00,
                            backgroundColor: Colors.white,
                          ),
                        ),
        
                        Text(
                          'QR Code gerado!',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.dosis(
                            textStyle: const TextStyle(
                                fontSize: 24, 
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                            Text(
                              "Apresente este QR\nCode para o fiscal na\n entrada da loja",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.dosis(
                                textStyle: const TextStyle(
                                  fontSize: 22,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            )
                          ],
                        ));
                  });
            },
            icon: const Icon(
              Icons.qr_code,
              color: Colors.white,
            ),
          ),
        ],
        automaticallyImplyLeading: false,
        backgroundColor: darkBlueColor,
        centerTitle: true,
        title: Image.asset(
          'assets/Captura de tela 2023-09-19 181800.png',
          fit: BoxFit.contain,
          height: 62,
        ),
      ),
      body: CustomPaint(
        painter: TrianguloPainter(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Text(
                'Olá, $primeiroNome',
                style: GoogleFonts.dosis(
                  textStyle: TextStyle(fontSize: 26, color: darkBlueColor, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 12.0),
                  child: Text(
                    'Acompanhe o status da sua programação',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.dosis(
                      textStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 5),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: yellowColor,
                    ),
                    onPressed: () {
                      _getUser();
                    },
                    child: Icon(Icons.refresh),
                  ),
                )
              ],
            ),
            SizedBox(
              height: telaHeight * 0.04,
            ),
            if (escalas != null)
              Expanded(
                child: ListView.builder(
                  primary: true,
                  shrinkWrap: true,
                  itemCount: escalas!.length,
                  itemBuilder: (context, index) {
                    EscalaPromotor escala = escalas![index];
                    return Column(
                      children: [
                        ListTile(
                          title: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  escala.loja,
                                  style: GoogleFonts.dosis(
                                    textStyle: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 22.0),
                                child: SizedBox(
                                  width: 50,
                                  height: 50,
                                  child: Image.network(
                                    escala.fornLogoMarca.toString(),
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container();
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                          subtitle: Text(
                            'Período: ${DateFormat('dd/MM').format(DateTime.parse(escala.dtInicio))} à ${DateFormat('dd/MM').format(
                              DateTime.parse(escala.dtTermino),
                            )}',
                            style: GoogleFonts.dosis(
                              textStyle: const TextStyle(fontSize: 18),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Card(
                            elevation: 1.5,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ListView.builder(
                                shrinkWrap: true,
                                primary: false,
                                itemCount: escala.pontos.length,
                                itemBuilder: (context, indexPonto) {
                                  DateTime dtReferenciaTime = DateTime.parse(escala.pontos[indexPonto].dtReferencia);
                                  return Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              children: [
                                                Text(
                                                  DateFormat('dd/MM').format(
                                                    DateTime.parse(escala.pontos[indexPonto].dtReferencia),
                                                  ),
                                                  style: GoogleFonts.dosis(textStyle: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.only(left: 3),
                                                  child: Text(
                                                    '(${DateFormat('EEEE', 'pt-BR').format(dtReferenciaTime)})',
                                                    style: GoogleFonts.dosis(textStyle: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                const Icon(Icons.history),
                                                Padding(
                                                  padding: const EdgeInsets.only(left: 5),
                                                  child: Text(
                                                    DateFormat('HH:mm').format(DateTime.parse(
                                                        '${escala.pontos[indexPonto].dtReferencia} ${escala.pontos[indexPonto].hrCargaHoraria}')),
                                                    style: GoogleFonts.dosis(textStyle: TextStyle(fontSize: fontSize)),
                                                  ),
                                                ),
                                              ],
                                            ),
                                             Padding(
                                              padding: EdgeInsets.only(left: 0, top: 0),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.end,
                                                children: [
                                                  
                                                  Icon(
                                                    Icons.pause,
                                                    size: 20,
                                                  ),
                                                  Text(
                                              DateFormat('HH:mm')
                                                  .format(DateTime.parse('${escala.pontos[indexPonto].dtReferencia} ${escala.pontos[indexPonto].hrIntervalo}')),
                                              style: GoogleFonts.dosis(textStyle: TextStyle(fontSize: fontSize)),
                                            ),
                                                ],
                                              ),
                                            ),
                                            
                                          ],
                                        ),
                                      ),
                                      if (indexPonto < escala.pontos.length - 1)
                                        const Divider(
                                          color: Colors.black,
                                        ),
                                    ],
                                  );
                                },
                              ),
                            ),
                          ),
                        )
                      ],
                    );
                  },
                ),
              )
            else
              const Center(
                child: CircularProgressIndicator(),
              )
          ],
        ),
      ),
    );
  }
}
