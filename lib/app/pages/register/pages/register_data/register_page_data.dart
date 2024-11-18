// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:acessonovo/app/pages/register/pages/register_senha/register_senha.dart';
import 'package:acessonovo/app/widget/app_color.dart';
import 'package:acessonovo/app/widget/tringulo_pointer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:validadores/Validador.dart';

class RegisterData extends StatefulWidget {
  final Map<String, dynamic> qrCodeConsulta;
  final String userEmail;
  const RegisterData({
    Key? key,
    required this.qrCodeConsulta,
    required this.userEmail,
  }) : super(key: key);

  @override
  State<RegisterData> createState() => _RegisterDataState();
}

class _RegisterDataState extends State<RegisterData> {
  var maskFormatter = MaskTextInputFormatter(
    mask: '(##) #####-####',
    filter: {"#": RegExp(r'[0-9]')},
    type: MaskAutoCompletionType.lazy,
  );
  var maskFormatterData = MaskTextInputFormatter(
    mask: '##/##/####',
    type: MaskAutoCompletionType.lazy,
  );

  var maskformaterCpf = MaskTextInputFormatter(
    mask: '###.###.###-##',
    type: MaskAutoCompletionType.lazy,
  );
  final TextEditingController nameInputController = TextEditingController();
  final TextEditingController cpfInputController = TextEditingController();
  final TextEditingController dtNascimentoInputController = TextEditingController();
  final TextEditingController telefoneInputController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  
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
              padding: const EdgeInsets.only(top: 30, left: 14, right: 14),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Informe seus dados',
                        style: GoogleFonts.dosis(
                          textStyle: TextStyle(color: darkBlueColor, fontSize: 26, fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(
                        height: telaHeight * 0.04,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 2.0),
                        child: Text(
                          'Nome',
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
                        controller: nameInputController,
                        cursorColor: Colors.black,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Digite um nome válido';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          hintText: "Digite aqui o seu nome completo",
                          filled: true,
                          fillColor: Colors.grey[300],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                              12.0,
                            ),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: telaHeight * 0.02,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 2.0),
                              child: Text(
                                'CPF',
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
                              controller: cpfInputController,
                              inputFormatters: [maskformaterCpf],
                              keyboardType: TextInputType.number,
                              cursorColor: Colors.black,
                            validator: (value) {
                      return Validador()
                          .add(Validar.CPF, msg: 'CPF Inválido')
                          .add(Validar.OBRIGATORIO, msg: 'Campo obrigatório')
                          .minLength(11)
                          
                          
                          .maxLength(11)
                          .valido(value, clearNoNumber: true);
                    },
                              decoration: InputDecoration(
                                hintText: "000.000.000-00",
                                filled: true,
                                fillColor: Colors.grey[300],
                  
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                    12.0,
                                  ),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: telaHeight * 0.02,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 2.0),
                              child: Text(
                                'Data de nascimento',
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
                              controller: dtNascimentoInputController,
                              keyboardType: TextInputType.number,
                              cursorColor: Colors.black,
                              inputFormatters: [maskFormatterData],
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Digite uma data de nascimento válida';
                                }

                                return null;
                              },
                              decoration: InputDecoration(
                                hintText: "00/00/0000",
                                filled: true,
                                fillColor: Colors.grey[300],
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                    12.0,
                                  ),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: telaHeight * 0.02,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 2.0),
                              child: Text(
                                'Telefone',
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
                              controller: telefoneInputController,
                              keyboardType: TextInputType.phone,
                              inputFormatters: [maskFormatter],
                              cursorColor: Colors.black,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Digite um número de telefone válido';
                                }

                                return null;
                              },
                              decoration: InputDecoration(
                                hintText: "(00) 00000-0000",
                                //        labelText: "Telefone",
                                filled: true,
                                fillColor: Colors.grey[300],
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                    12.0,
                                  ),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: telaHeight * 0.05,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 0, left: 0, right: 0),
                        child: SizedBox(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: yellowColor,
                              minimumSize: const Size(
                                double.infinity,
                                50,
                              ),
                            ),
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                FocusScope.of(context).unfocus();
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => RegisterSenha(
                                              userNome: nameInputController.text,
                                              userTelefone: telefoneInputController.text,
                                              userDtNascimento: DateFormat('yyyy-MM-dd').format(
                                                (DateFormat('dd/MM/yyyy').parse(
                                                  (dtNascimentoInputController.text),
                                                )),
                                              ),

                                              //dtNascimentoInputController.text,
                                              userCpf: cpfInputController.text,
                                              userEmail: widget.userEmail,
                                              qrCodeConsulta: widget.qrCodeConsulta,
                                            )));
                              }
                            },
                            child: Text(
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
              ),
            ),
          ),
        ),
      ),
    );
  }
}
