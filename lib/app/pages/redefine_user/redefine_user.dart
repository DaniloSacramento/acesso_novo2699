// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:acessonovo/app/models/user_promote.dart';
import 'package:acessonovo/app/pages/sucesso_page/sucesso_page_alterar_cadastro.dart';
import 'package:acessonovo/app/services/foto_service.dart';
import 'package:acessonovo/app/services/redefine_dados_service.dart';
import 'package:acessonovo/app/widget/app_color.dart';
import 'package:acessonovo/app/widget/tringulo_pointer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RedefineUser extends StatefulWidget {
  const RedefineUser({
    Key? key,
    required this.update,
  }) : super(key: key);
  final Function update;
  @override
  State<RedefineUser> createState() => _RedefineUserState(update);
}

class _RedefineUserState extends State<RedefineUser> {
  UserPromote? user;
  final bool _isFormValid = false;
  bool isLoading = false;
  final Function update;
  Uint8List? imageBytes;
  _RedefineUserState(this.update);
  // ignore: unused_element
  _getUser() async {
    final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final result = sharedPreferences.getString('data');

    setState(() {
      user = UserPromote.fromMap(jsonDecode(result!)['data']);
      if (user != null) {
        _nomeController.text = user!.nome;
        _dtNascimentoController.text = DateFormat.yMd('pt_BR').format(DateTime.parse(user!.dtNascimento));
        _telefoneController.text = user!.telefone;
      }
    });
  }

  Future<void> _checkInternetConnection() async {
    var connectivityResult = await (Connectivity().checkConnectivity());

    if (connectivityResult == ConnectivityResult.none) {
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'Sem conexão com a internet',
              style: GoogleFonts.dosis(
                  textStyle: TextStyle(
                fontSize: 26,
                color: darkBlueColor,
                fontWeight: FontWeight.bold,
              )),
            ),
            content: Text(
              'Verifique sua conexão com a internet e tente novamente.',
              style: GoogleFonts.dosis(
                  textStyle: const TextStyle(
                fontSize: 22,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              )),
            ),
            actions: <Widget>[
              TextButton(
                child: Text(
                  'OK',
                  style: GoogleFonts.dosis(
                      textStyle: TextStyle(
                    fontSize: 17,
                    color: darkBlueColor,
                    fontWeight: FontWeight.bold,
                  )),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  final ImagePicker _imagePicker = ImagePicker();
  File? imageFile;

  pick(ImageSource source) async {
    try {
      final XFile? image = await _imagePicker.pickImage(source: source);
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
    } catch (e) {
      print('Erro ao selecionar a imagem: $e');
    }
  }

  var maskFormatter = MaskTextInputFormatter(
    mask: '(##) #####-####',
    filter: {"#": RegExp(r'[0-9]')},
    type: MaskAutoCompletionType.lazy,
  );
  var maskFormatterData = MaskTextInputFormatter(
    mask: '##/##/####',
    type: MaskAutoCompletionType.lazy,
  );
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _dtNascimentoController = TextEditingController();
  final _telefoneController = TextEditingController();
  @override
  void initState() {
    super.initState();
    _getUser();
  }

  @override
  Widget build(BuildContext context) {
    double telaHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        backgroundColor: darkBlueColor,
        title: Image.asset(
          'assets/Captura de tela 2023-09-19 181800.png',
          fit: BoxFit.contain,
          height: 62,
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () async {
            FocusScope.of(context).unfocus();
            await Future.delayed(const Duration(milliseconds: 200));
            // ignore: use_build_context_synchronously
            Navigator.pop(context);
          },
        ),
      ),
      body: CustomPaint(
        painter: TrianguloPainter(),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: telaHeight * 0.01,
                ),
                Padding(
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      "Alterar dados cadastrais",
                      style: GoogleFonts.dosis(
                        textStyle: TextStyle(fontSize: 24, color: darkBlueColor, fontWeight: FontWeight.bold),
                      ),
                    )),
                Center(
                  child: Column(
                    //crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Stack(
                          children: [
                            SizedBox(
                                width: 170,
                                height: telaHeight * 0.25,
                                child: imageBytes == null
                                    ? CachedNetworkImage(
                                        imageUrl: user!.foto,
                                        placeholder: (context, url) => const CircularProgressIndicator(),
                                        errorWidget: (context, url, error) => const Icon(Icons.error),
                                        imageBuilder: (context, imageProvider) => Container(
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            image: DecorationImage(
                                              fit: BoxFit.cover,
                                              image: imageProvider,
                                            ),
                                          ),
                                        ),
                                      )
                                    : SizedBox(
                                        width: 170,
                                        height: telaHeight * 0.25,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            image: DecorationImage(
                                              fit: BoxFit.cover,
                                              image: MemoryImage(imageBytes!),
                                            ),
                                          ),
                                        ),
                                      )),
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
                                    _showOpcoesBottomSheet();
                                  },
                                  icon: const Icon(Icons.camera_alt),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: telaHeight * 0.01,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 2.0,
                        ),
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
                        controller: _nomeController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Digite um nome válido';
                          }
                          return null;
                        },
                        cursorColor: Colors.black,
                        decoration: InputDecoration(
                          // hintText: "Digite aqui o seu nome completo",
                          // labelText: "Nome",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                              12.0,
                            ),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.grey[300],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: telaHeight * 0.015,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 2.0,
                        ),
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
                        controller: _dtNascimentoController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Digite uma data de nascimento válida';
                          }

                          return null;
                        },
                        cursorColor: Colors.black,
                        inputFormatters: [maskFormatterData],
                        keyboardType: TextInputType.datetime,
                        decoration: InputDecoration(
                          // hintText: "00/00/0000",
                          // labelText: "Data de nascimento",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                              12.0,
                            ),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.grey[300],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: telaHeight * 0.015,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 2.0,
                        ),
                        child: Text(
                          'Numero de telefone',
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
                        controller: _telefoneController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Digite um número de telefone válido';
                          }

                          return null;
                        },
                        inputFormatters: [maskFormatter],
                        cursorColor: Colors.black,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          // hintText: "(00) 0000-0000",
                          // labelText: "Telefone",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                              12.0,
                            ),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.grey[300],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: telaHeight * 0.020,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
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
                              _checkInternetConnection();
                              setState(() {
                                isLoading = true;
                              });
                              String? foto;
                              if (imageBytes != null) {
                                foto = await AlterarFoto().fotoPromotor(email: user!.email, file: imageBytes!);
                              }

                              setState(() {
                                isLoading = true;
                              });
                              await redefineUser(
                                foto: foto ?? user!.foto,
                                nome: _nomeController.text,
                                dtNascimento: DateFormat('yyyy-MM-dd').format(
                                  (DateFormat('dd/MM/yyyy').parse(
                                    (_dtNascimentoController.text),
                                  )),
                                ),
                                telefone: _telefoneController.text,
                              ).then((value) async {
                                update();
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => AlterarDadosSucesso(),
                                  ),
                                );
                              });
                            },
                      child: isLoading
                          ? const CircularProgressIndicator()
                          : Text(
                              "Salvar",
                              style: GoogleFonts.dosis(
                                textStyle: const TextStyle(
                                  fontSize: 17,
                                  color: Colors.black,
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

  void _showOpcoesBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.grey[200],
                  child: Center(
                    child: Icon(
                      PhosphorIcons.camera(),
                      color: Colors.grey[500],
                    ),
                  ),
                ),
                title: Text(
                  'Galeria',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                onTap: () {
                  Navigator.of(context).pop();

                  pick(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.grey[200],
                  child: Center(
                    child: Icon(
                      PhosphorIcons.camera(),
                      color: Colors.grey[500],
                    ),
                  ),
                ),
                title: Text(
                  'Câmera',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  pick(ImageSource.camera);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
