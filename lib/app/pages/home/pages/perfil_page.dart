import 'dart:convert';
import 'package:acessonovo/app/models/user_promote.dart';
import 'package:acessonovo/app/pages/redefine_user/redefine_user.dart';
import 'package:acessonovo/app/services/status_service.dart';
import 'package:acessonovo/app/widget/app_color.dart';
import 'package:acessonovo/app/widget/tringulo_pointer.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cached_network_image/cached_network_image.dart';

class PerfilPage extends StatefulWidget {
  const PerfilPage({super.key});
  @override
  State<PerfilPage> createState() => _PerfilPageState();
}

class _PerfilPageState extends State<PerfilPage> {
  UserPromote? user;
  bool obscureFields = true;
  bool showNome = true;
  _getUser() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    final result = sharedPreferences.getString('data');
    if (result != null) {
      final Map<String, dynamic> data = jsonDecode(result);
      if (data.containsKey('data')) {
        setState(
          () {
            user = UserPromote.fromMap(data['data']);
          },
        );
      } else {
        print('Erro: "data" não encontrado no JSON');
      }
    } else {
      print('Erro: Nenhum dado encontrado no SharedPreferences');
    }
  }

  String decodeStatusToUtf8(String status) {
    try {
      String decodedStatus = utf8.decode(status.codeUnits);

      if (decodedStatus == "EM_ANALISE") {
        return "EM ANÁLISE";
      }

      return decodedStatus;
    } catch (e) {
      return "Erro na decodificação";
    }
  }

  String formatarCPF(String cpf) {
    if (cpf.length != 11) {
      return cpf;
    }

    return "${cpf.substring(0, 3)}.${cpf.substring(3, 6)}.${cpf.substring(6, 9)}-${cpf.substring(9)}";
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

  Color greenColor = Colors.green;
  Color redColor = Colors.red;
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    double telaHeight = MediaQuery.of(context).size.height;
    final isLoading = this.user == null;
    if (isLoading) {
      return const Material(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    UserPromote user = this.user!;
    String cpfCuston = user.cpf;
    String telefoneC = user.telefone;
    String dtNascimentoC = user.dtNascimento;
    String empresaC = user.empresa;
    String emailC = user.email;
    String statusC = user.status;
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
                          width: 300,
                          height: 300,
                          child: QrImageView(
                            data: user.cpf,
                            version: QrVersions.auto,
                            size: 300.00,
                            backgroundColor: Colors.white,
                          ),
                        ),
                        Text(
                          'QR Code gerado!',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.dosis(
                            textStyle: const TextStyle(
                              fontSize: 28,
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
        title: Image.asset(
          'assets/Captura de tela 2023-09-19 181800.png',
          fit: BoxFit.contain,
          height: 62,
        ),
        centerTitle: true,
      ),
      body: CustomPaint(
        painter: TrianguloPainter(),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: screenHeight * 0.02,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stack(
                    children: [
                      SizedBox(
                        width: 170,
                        height: screenHeight * 0.25,
                        child: CachedNetworkImage(
                          imageUrl: user.foto,
                          placeholder: (context, url) =>
                              const CircularProgressIndicator(),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                          imageBuilder: (context, imageProvider) => Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: imageProvider,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 10,
                        left: 130,
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.yellow[600], // Cor de fundo amarela
                          ),
                          child: IconButton(
                            onPressed: () async {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => RedefineUser(
                                    update: () {
                                      _getUser();
                                    },
                                  ),
                                ),
                              );
                            },
                            icon: const Icon(Icons.edit),
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: screenHeight * 0.015,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 13, top: 0, right: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Dados Pessoais',
                      style: GoogleFonts.dosis(
                        textStyle: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: darkBlueColor),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          showNome = !showNome;
                        });
                      },
                      icon: showNome
                          ? const Icon(Icons.visibility_off)
                          : const Icon(Icons.visibility),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(14.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Nome',
                          style: GoogleFonts.dosis(
                            textStyle: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 1,
                    ),
                    Row(
                      children: [
                        Text(
                          user.nome,
                          style: GoogleFonts.dosis(
                            textStyle: const TextStyle(
                                fontSize: 16, color: Colors.grey),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    // ... (previous code)

                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'CPF',
                                style: GoogleFonts.dosis(
                                  textStyle: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              SizedBox(
                                height: telaHeight * 0.00,
                              ),
                              Text(
                                showNome
                                    ? '*' * cpfCuston.length
                                    : formatarCPF(user.cpf),
                                style: GoogleFonts.dosis(
                                  textStyle: const TextStyle(
                                      fontSize: 16, color: Colors.grey),
                                ),
                              ),
                              SizedBox(
                                height: telaHeight * 0.01,
                              ),
                              SizedBox(
                                height: telaHeight * 0.01,
                              ),
                              Text(
                                "E-mail",
                                style: GoogleFonts.dosis(
                                  textStyle: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Text(
                                showNome ? '*' * emailC.length : user.email,
                                style: GoogleFonts.dosis(
                                  textStyle: const TextStyle(
                                      fontSize: 16, color: Colors.grey),
                                ),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Telefone',
                                style: GoogleFonts.dosis(
                                  textStyle: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Text(
                                showNome
                                    ? '*' * telefoneC.length
                                    : user.telefone,
                                style: GoogleFonts.dosis(
                                  textStyle: const TextStyle(
                                      fontSize: 16, color: Colors.grey),
                                ),
                              ),
                              SizedBox(
                                height: telaHeight * 0.01,
                              ),
                              Text(
                                "Data de Nasc.",
                                style: GoogleFonts.dosis(
                                  textStyle: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Text(
                                showNome
                                    ? '*' * dtNascimentoC.length
                                    : DateFormat.yMd('pt_BR').format(
                                        DateTime.parse(user.dtNascimento),
                                      ),
                                style: GoogleFonts.dosis(
                                  textStyle: const TextStyle(
                                      fontSize: 16, color: Colors.grey),
                                ),
                              ),
                              SizedBox(
                                height: telaHeight * 0.01,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // ... (remaining code)

                    SizedBox(
                      height: telaHeight * 0.03,
                    ),
                    Text('Empresas',
                        style: GoogleFonts.dosis(
                          textStyle: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: darkBlueColor),
                        )),
                    SizedBox(
                      height: telaHeight * 0.01,
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: user.empresas!.length,
                      itemBuilder: (context, index) {
                        String empresaName = user.empresas![index].empresaNome;
                        String statusDesc = user.empresas![index].statusDesc;
                        String dtAprov =
                            user.empresas![index].dtAprovacao ?? '';
                        String dtReprov =
                            user.empresas![index].dtReprovacao ?? '';
                        String dtCreate = user.empresas![index].dtCreate ?? '';
                        String rede =
                            user.empresas![index].grupoEmpresarialNome;
                        Color statusColor;
                        String statusDate;
                        switch (statusDesc) {
                          case 'Aprovado':
                            statusColor = Colors.green;
                            statusDate = dtAprov;
                            break;
                          case 'Reprovado':
                            statusColor = Colors.red;
                            statusDate = dtReprov;
                            break;
                          case 'Em Análise':
                            statusColor = Colors.yellow;
                            statusDate = dtCreate;
                            break;
                          default:
                            statusColor = Colors.black;
                            statusDate = '';
                            break;
                        }
                        return Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Card(
                            elevation: 3,
                            margin: EdgeInsets.symmetric(
                                vertical: 0, horizontal: 0),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('$empresaName',
                                          style: GoogleFonts.dosis(
                                            textStyle: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                color: darkBlueColor),
                                          )),
                                      Text('$rede',
                                          style: GoogleFonts.dosis(
                                            textStyle: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                color: darkBlueColor),
                                          )),
                                    ],
                                  ),
                                  SizedBox(height: 3),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text.rich(TextSpan(children: [
                                        TextSpan(text: 'Status:'),
                                        TextSpan(
                                            text: ' $statusDesc',
                                            style: GoogleFonts.dosis(
                                              textStyle: TextStyle(
                                                  fontSize: 16,
                                                  color: statusColor),
                                            ))
                                      ])),
                                      Text(
                                          DateFormat('dd/MM/yyyy - HH:mm')
                                              .format(
                                                  DateTime.parse(statusDate)),
                                          style: GoogleFonts.dosis(
                                            textStyle: TextStyle(
                                                fontSize: 16,
                                                color: Colors.black),
                                          ))
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
