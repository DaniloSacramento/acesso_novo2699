import 'dart:convert';
import 'package:acessonovo/app/models/escala_promotor.dart';
import 'package:acessonovo/app/models/user_promote.dart';
import 'package:acessonovo/app/pages/alterar_senha/alterar_senha.dart';
import 'package:acessonovo/app/pages/diretrizes/diretrizes_page.dart';
import 'package:acessonovo/app/pages/input/input_screen.dart';
import 'package:acessonovo/app/services/escala_service.dart';
import 'package:acessonovo/app/services/inativar_conta_service.dart';
import 'package:acessonovo/app/widget/app_color.dart';
import 'package:acessonovo/app/widget/tringulo_pointer.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
class ConfigPage extends StatefulWidget {
  const ConfigPage({Key? key}) : super(key: key);
  @override
  State<ConfigPage> createState() => _ConfigPageState();
}
class _ConfigPageState extends State<ConfigPage> {
  UserPromote? user;
  List<EscalaPromotor>? escalas;
  bool isSwitched = false;

  @override
  void initState() {
    super.initState();
    _getUser();
  }

  Future<void> _getUser() async {
    final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final result = sharedPreferences.getString('data');
    user = UserPromote.fromMap(jsonDecode(result!)['data']);
    escalas = await fetchEscalas(user!.email);
    setState(() {});
  }

  Future<void> _showDeleteAccountConfirmationDialog(BuildContext context) async {
    bool confirmDelete = false;
    bool isDeleteAccountChecked = false;
    String errorMessage = '';

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: Text(
                'Excluir Minha Conta',
                style: GoogleFonts.dosis(
                  textStyle: TextStyle(
                    fontSize: 26,
                    color: darkBlueColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    'Todos os seus dados serão apagados, deseja continuar?',
                    style: GoogleFonts.dosis(
                      textStyle: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Checkbox(
                        value: isDeleteAccountChecked,
                        onChanged: (value) {
                          setState(() {
                            isDeleteAccountChecked = value ?? false;
                            confirmDelete = isDeleteAccountChecked;
                          });
                        },
                      ),
                      Text(
                        'Estou ciente dessa ação',
                        style: GoogleFonts.dosis(
                          textStyle: TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (errorMessage.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Text(
                        errorMessage,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.red,
                        ),
                      ),
                    ),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  child: Text(
                    'Cancelar',
                    style: GoogleFonts.dosis(
                      textStyle: TextStyle(
                        fontSize: 17,
                        color: darkBlueColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                if (confirmDelete)
                  TextButton(
                    child: Text(
                      'Confirmar',
                      style: GoogleFonts.dosis(
                        textStyle: TextStyle(
                          fontSize: 17,
                          color: darkBlueColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    onPressed: () async {
                      bool deleted = await DeixarUserInativo().deixarUserInativo(email: user!.email);
                      if (deleted) {
                        SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
                        await sharedPreferences.clear();

                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const InputScreen(),
                          ),
                        );
                      } else {
                        setState(() {
                          errorMessage = 'Erro ao excluir conta. Tente novamente!';
                        });
                      }
                    },
                  ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _showExitConfirmationDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Sair do aplicativo?',
            style: GoogleFonts.dosis(
              textStyle: TextStyle(
                fontSize: 26,
                color: darkBlueColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  'Tem certeza de que deseja sair do aplicativo?',
                  style: GoogleFonts.dosis(
                    textStyle: const TextStyle(
                      fontSize: 24,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'Cancelar',
                style: GoogleFonts.dosis(
                  textStyle: TextStyle(
                    fontSize: 17,
                    color: darkBlueColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop(); // Fecha o diálogo
              },
            ),
            TextButton(
              child: Text(
                'Sair',
                style: GoogleFonts.dosis(
                  textStyle: TextStyle(
                    fontSize: 17,
                    color: darkBlueColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              onPressed: () async {
                bool saiu = await sair();
                if (saiu) {
                  Navigator.of(context).pop(); // Fecha o diálogo
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const InputScreen(),
                    ),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
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
                    ),
                  );
                },
              );
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
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: telaHeight * 0.03,
              ),
              SizedBox(
                height: telaHeight * 0.05,
              ),
              Text(
                "Notificações",
                style: GoogleFonts.dosis(
                  textStyle: TextStyle(
                    color: darkBlueColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 26,
                  ),
                ),
              ),
              SizedBox(
                height: telaHeight * 0.001,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Permitir notificações na tela bloqueada',
                    style: GoogleFonts.dosis(
                      textStyle: const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  Checkbox(
                    value: isSwitched,
                    onChanged: (value) {
                      setState(() {
                        isSwitched = value!;
                      });
                    },
                  ),
                ],
              ),
              SizedBox(
                height: telaHeight * 0.03,
              ),
              Text(
                'Acesso',
                style: GoogleFonts.dosis(
                  textStyle: TextStyle(
                    color: darkBlueColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 26,
                  ),
                ),
              ),
              SizedBox(
                height: telaHeight * 0.02,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: yellowColor,
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const AlterarSenha()));
                    },
                    child: Text(
                      'Alterar senha',
                      style: GoogleFonts.dosis(
                        textStyle: const TextStyle(color: Colors.black, fontSize: 17),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: telaHeight * 0.02,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: yellowColor,
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const Diretrizes()));
                    },
                    child: Text(
                      'Diretrizes',
                      style: GoogleFonts.dosis(
                        textStyle: const TextStyle(color: Colors.black, fontSize: 17),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: telaHeight * 0.02,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: yellowColor,
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    onPressed: () async {
                      _showDeleteAccountConfirmationDialog(context);
                    },
                    child: Text(
                      'Excluir conta',
                      style: GoogleFonts.dosis(
                        textStyle: const TextStyle(color: Colors.black, fontSize: 17),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: yellowColor,
        onPressed: () async {
          _showExitConfirmationDialog(context);
        },
        child: const Icon(
          Icons.logout,
          color: Colors.white,
        ),
      ),
    );
  }
}

Future<bool> sair() async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  await sharedPreferences.clear();
  return true;
}
