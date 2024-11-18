import 'dart:convert';

import 'package:acessonovo/app/models/escala_promotor_ponto.dart';
import 'package:acessonovo/app/models/user_promote.dart';
import 'package:acessonovo/app/services/ponto_service.dart';
import 'package:acessonovo/app/widget/app_color.dart';
import 'package:acessonovo/app/widget/tringulo_pointer.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HistoricoPage extends StatefulWidget {
  const HistoricoPage({super.key});

  @override
  State<HistoricoPage> createState() => _HistoricoPageState();
}

class _HistoricoPageState extends State<HistoricoPage> {
   late DateTime currentDate;
  late DateTime date30DaysBefore;
  DateTime? selectedStartDate;
DateTime? selectedEndDate;
bool isDateRangeSelected = false;
  bool isFirstTimeOpened = true;
  List<PromotorEscalaPonto>? pontos;
  bool isDateInFuture(DateTime date) {
    return date.isAfter(DateTime.now());
  }

  final _formKey = GlobalKey<FormState>();
  UserPromote? user;
  Future<void> _handleRefresh() async {
  await _getUser(); 
  setState(() {}); 
}
DateTime initialStartDate = DateTime.now().subtract(Duration(days: 30));
final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  TextEditingController lojaController = TextEditingController();
  TextEditingController dtInicialController = TextEditingController();
  TextEditingController dtFinalController = TextEditingController();
  var maskFormatterData = MaskTextInputFormatter(
    mask: '##/##/####',
    type: MaskAutoCompletionType.lazy,
  );

  _getUser() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    final result = sharedPreferences.getString('data');
    user = UserPromote.fromMap(jsonDecode(result!)['data']);
    DateTime dataInicial = DateTime.now().subtract(Duration(days: 30));
    pontos = await pontoPromotor(
      email: user!.email,
      data1Filter: DateFormat('yyyy-MM-dd').format(dataInicial),
      data2Filter: DateFormat('yyyy-MM-dd').format(DateTime.now()),
      lojaFilter: "",
      faltasFilter: "false",
    );
    pontos = pontos?.reversed.toList() ?? [];
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      currentDate = DateTime.now();
      date30DaysBefore = currentDate.subtract(Duration(days: 30));

      _getUser();
      dtFinalController.text = DateFormat('dd/MM/yyyy').format(DateTime.now());
      DateTime dataInicial = DateTime.now().subtract(Duration(days: 30));
      dtInicialController.text = DateFormat('dd/MM/yyyy').format(dataInicial);

      if (isDateRangeSelected) {
        currentDate = selectedEndDate!;
        date30DaysBefore = selectedStartDate!;
      }
    });
  }

  
 Future<void> _showDateRangePicker(BuildContext context) async {
    DateTime currentDateMinus30Days = DateTime.now().subtract(Duration(days: 30));
    DateTime currentDateMinus90Days = DateTime.now().subtract(Duration(days: 90));

    final selectedDateRange = await showDateRangePicker(
      context: context,
      firstDate: currentDateMinus90Days,
      lastDate: DateTime.now(),
      initialDateRange: isDateRangeSelected
          ? DateTimeRange(start: selectedStartDate!, end: selectedEndDate!)
          : DateTimeRange(
              start: currentDateMinus30Days,
              end: DateTime.now(),
            ),
    );

    if (selectedDateRange != null) {
      setState(() {
        isFirstTimeOpened = false;
        isDateRangeSelected = true;
        selectedStartDate = selectedDateRange.start;
        selectedEndDate = selectedDateRange.end;
        currentDate = selectedEndDate!;
        date30DaysBefore = selectedStartDate!;
        dtInicialController.text = DateFormat('dd/MM/yyyy').format(date30DaysBefore);
        dtFinalController.text = DateFormat('dd/MM/yyyy').format(currentDate);
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    final fontSize = screenWidth * 0.045;
    final faltasQuantidades = pontos?.where(
      (element) {
        return element.dtCheckIn == null &&
            !isDateInFuture(DateTime.parse(element.dtReferencia)) &&
            DateTime.parse(element.dtReferencia).day != DateTime.now().day;
      },
    ).toList();
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
        title: Image.asset(
          'assets/Captura de tela 2023-09-19 181800.png',
          fit: BoxFit.contain,
          height: 62,
        ),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh:_handleRefresh ,
        key: _refreshIndicatorKey,
        child: CustomPaint(
          painter: TrianguloPainter(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  'Histórico de Acesso',
                  style: GoogleFonts.dosis(textStyle: TextStyle(color: darkBlueColor, fontSize: 26, fontWeight: FontWeight.bold)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(13.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        '${faltasQuantidades?.length} VISITAS NÃO REALIZADAS',
                        style: GoogleFonts.dosis(textStyle: const TextStyle(color: Colors.red, fontSize: 24, fontWeight: FontWeight.bold)),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 30),
                      child: IconButton(
                       onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return StatefulBuilder(
                                builder: (context, setState) {
                                  return AlertDialog(
                                    iconPadding: EdgeInsets.zero,
                                    icon: Row(
                                      children: [
                                        IconButton(
                                          onPressed: () => Navigator.pop(context),
                                          icon: const Icon(
                                            Icons.close,
                                          ),
                                        ),
                                      ],
                                    ),
                                    scrollable: true,
                                    content: Padding(
                                      padding: const EdgeInsets.all(0),
                                      child: Form(
                                        key: _formKey,
                                        child: Padding(
                                          padding: const EdgeInsets.all(0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Filtro de historico',
                                                style: GoogleFonts.dosis(
                                                  textStyle: TextStyle(
                                                      color: darkBlueColor,
                                                      fontSize: 20,
                                                      fontWeight: FontWeight.bold),
                                                ),
                                              ),
                                              Container(
                                                height: 55,
                                                child: Padding(
                                                  padding: const EdgeInsets.fromLTRB(
                                                      0, 5, 0, 0),
                                                  child: TextFormField(
                                                    controller: lojaController,
                                                    decoration: InputDecoration(
                                                      border: OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                          12.0,
                                                        ),
                                                        borderSide: BorderSide.none,
                                                      ),
                                                      hintText: 'Loja',
                                                      hintStyle: GoogleFonts.dosis(),
                                                      filled: true,
                                                      fillColor: Colors.grey[300],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Row(
                                                children: [
                                                  Expanded(
                                                    child: ElevatedButton(
                                                      style: ElevatedButton.styleFrom(
                                                          backgroundColor:
                                                              Colors.grey[300]),
                                                      onPressed: () {
                                                          _showDateRangePicker(
                                                              context).then((value) {
                                                                setState(() {
                                                                  
                                                                });
                                                              }); 
                                                              },
                                                      child: Text(
                                                        '${DateFormat('dd/MM/yyyy').format(date30DaysBefore)}',
                                                        style: GoogleFonts.dosis(
                                                          textStyle: const TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 16,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  Expanded(
                                                    child: ElevatedButton(
                                                      style: ElevatedButton.styleFrom(
                                                          backgroundColor:
                                                              Colors.grey[300]),
                                                      onPressed: () {
                                                          _showDateRangePicker(
                                                              context).then((value) {
                                                                setState(() {
                                                                  
                                                                });
                                                              }); 
                                                              },
                                                      child: Text(
                                                          '${DateFormat('dd/MM/yyyy').format(currentDate)}',
                                                          style: GoogleFonts.dosis(
                                                              textStyle:
                                                                  const TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 16,
                                                          ))),
                                                    
                                                    ),
                                                  ),
                                                
                                                ],
                                                
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.spaceEvenly,
                                                children: [
                                                  ElevatedButton(
                                                    style: ElevatedButton.styleFrom(
                                                        backgroundColor:
                                                            Colors.white),
                                                    onPressed: () {
                                                      lojaController.clear();
                                                      dtInicialController.clear();
                                                      dtFinalController.clear();
                                                    },
                                                    child: Text(
                                                      'Limpar',
                                                      style: GoogleFonts.dosis(
                                                        textStyle: const TextStyle(
                                                          fontSize: 17,
                                                          fontWeight: FontWeight.bold,
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  ElevatedButton(
                                                    style: ElevatedButton.styleFrom(
                                                        backgroundColor:
                                                            Colors.yellow[600]),
                                                    onPressed: () async {
                                                      //   _checkInternetConnection();
                                                      if (_formKey.currentState!
                                                          .validate()) {
                                                        DateTime dtInicial = DateFormat(
                                                                'dd/MM/yyyy')
                                                            .parse(dtInicialController
                                                                .text); //DateTime.tryParse(dtInicialController.text) ?? DateTime.now();
                                                        DateTime dtFinal =
                                                            DateFormat('dd/MM/yyyy')
                                                                .parse(
                                                                    dtFinalController
                                                                        .text);
                                                        pontos = await pontoPromotor(
                                                          email: user!.email,
                                                          data1Filter:
                                                              DateFormat('yyyy-MM-dd')
                                                                  .format(dtInicial),
                                                          data2Filter:
                                                              DateFormat('yyyy-MM-dd')
                                                                  .format(dtFinal),
                                                          faltasFilter: "false",
                                                        );
                                                        setState(() {});
                                                        Navigator.of(context).pop();
                                                      }
                                                    },
                                                    child: Text(
                                                      'Filtrar',
                                                      style: GoogleFonts.dosis(
                                                        textStyle: const TextStyle(
                                                          fontSize: 17,
                                                          fontWeight: FontWeight.bold,
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }
                              );
                            },
                          );
                        },
                      icon: const Icon(
                        Icons.filter_alt_outlined,
                      ),
                    ),
                  )
                ],
              ),
            ),
              Expanded(
                child: ListView(
                  primary: true,
                  shrinkWrap: true,
                  children: [
                    ListView.builder(
                        primary: false,
                        shrinkWrap: true,
                        itemCount: pontos?.length ?? 0,
                        itemBuilder: (context, index) {
                          final bool isChekin = pontos![index].dtCheckIn != null;
                          DateTime dtReferenciaTime =
                              DateTime.parse(pontos![index].dtReferencia);
                          bool isCurrentOrFuture =
                              dtReferenciaTime.isAfter(DateTime.now()) ||
                                  dtReferenciaTime.year == DateTime.now().year &&
                                      dtReferenciaTime.month ==
                                          DateTime.now().month &&
                                      dtReferenciaTime.day == DateTime.now().day;
                          bool showVisitNotPerformed =
                              !isChekin && !isCurrentOrFuture;
                          return Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Card(
                              elevation: 5,
                              color: isChekin
                                  ? Colors.green
                                  : (isCurrentOrFuture
                                      ? Colors.white
                                      : Colors.red[700]),
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            isCurrentOrFuture
                                                ? Text(
                                                    DateFormat('dd/MM')
                                                        .format(dtReferenciaTime),
                                                    style: GoogleFonts.dosis(
                                                        textStyle:
                                                            const TextStyle(
                                                                color:
                                                                    Colors.black,
                                                                fontSize: 18,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                  )
                                                : Text(
                                                    DateFormat('dd/MM')
                                                        .format(dtReferenciaTime),
                                                    style: GoogleFonts.dosis(
                                                        textStyle:
                                                            const TextStyle(
                                                                color:
                                                                    Colors.white,
                                                                fontSize: 18,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                  ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            isCurrentOrFuture
                                                ? Text(
                                                    '(${DateFormat('EEEE', 'pt-BR').format(dtReferenciaTime)})',
                                                    style: GoogleFonts.dosis(
                                                        textStyle:
                                                            const TextStyle(
                                                                color:
                                                                    Colors.black,
                                                                fontSize: 18,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                  )
                                                : Text(
                                                    '(${DateFormat('EEEE', 'pt-BR').format(dtReferenciaTime)})',
                                                    style: GoogleFonts.dosis(
                                                        textStyle:
                                                            const TextStyle(
                                                                color:
                                                                    Colors.white,
                                                                fontSize: 18,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                  )
                                          ],
                                        ),
                                        isCurrentOrFuture
                                            ? isChekin
                                                ? const Icon(Icons.check,
                                                    color: Colors.black)
                                                : const Icon(
                                                    Icons.close,
                                                    color: Colors.black,
                                                  )
                                            : isChekin
                                                ? const Icon(Icons.check,
                                                    color: Colors.white)
                                                : const Icon(
                                                    Icons.close,
                                                    color: Colors.white,
                                                  )
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        isCurrentOrFuture
                                            ? Text(
                                                'Loja: ${pontos![index].loja}',
                                                style: GoogleFonts.dosis(
                                                    textStyle: const TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                              )
                                            : Text(
                                                'Loja: ${pontos![index].loja}',
                                                style: GoogleFonts.dosis(
                                                    textStyle: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                              ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            isCurrentOrFuture
                                                ? Text(
                                                    'C.H.',
                                                    style: GoogleFonts.dosis(
                                                        textStyle: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: fontSize,
                                                            fontWeight:
                                                                FontWeight.bold)),
                                                  )
                                                : Text(
                                                    'C.H.',
                                                    style: GoogleFonts.dosis(
                                                        textStyle: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: fontSize,
                                                            fontWeight:
                                                                FontWeight.bold)),
                                                  ),
                                            isCurrentOrFuture
                                                ? Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 5),
                                                    child: Text(
                                                      DateFormat('HH:mm').format(
                                                        DateTime.parse(
                                                            '${pontos![index].dtReferencia} ${pontos![index].hrCargaHoraria}'),
                                                      ),
                                                      style: GoogleFonts.dosis(
                                                          textStyle: TextStyle(
                                                              color: Colors.black,
                                                              fontSize: fontSize,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold)),
                                                    ),
                                                  )
                                                : Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 5),
                                                    child: Text(
                                                      DateFormat('HH:mm').format(
                                                        DateTime.parse(
                                                            '${pontos![index].dtReferencia} ${pontos![index].hrCargaHoraria}'),
                                                      ),
                                                      style: GoogleFonts.dosis(
                                                          textStyle: TextStyle(
                                                              color: Colors.white,
                                                              fontSize: fontSize,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold)),
                                                    ),
                                                  )
                                          ],
                                        ),
                                        isCurrentOrFuture
                                            ? Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 192, top: 3),
                                                child: Icon(
                                                  Icons.pause,
                                                  size: fontSize,
                                                  color: Colors.black,
                                                ),
                                              )
                                            : Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 192, top: 3),
                                                child: Icon(
                                                  Icons.pause,
                                                  size: fontSize,
                                                  color: Colors.white,
                                                ),
                                              ),
                                        isCurrentOrFuture
                                            ? Text(
                                                DateFormat('HH:mm').format(
                                                    DateTime.parse(
                                                        '${pontos![index].dtReferencia} ${pontos![index].hrIntervalo}')),
                                                style: GoogleFonts.dosis(
                                                    textStyle: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: fontSize,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                              )
                                            : Text(
                                                DateFormat('HH:mm').format(
                                                    DateTime.parse(
                                                        '${pontos![index].dtReferencia} ${pontos![index].hrIntervalo}')),
                                                style: GoogleFonts.dosis(
                                                    textStyle: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: fontSize,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                              )
                                      ],
                                    ),
                                    const Divider(
                                      color: Colors.black,
                                    ),
                                    Row(
                                      children: [
                                        if (showVisitNotPerformed) // Mostra a mensagem apenas se for necessário
                                          Icon(
                                            Icons.close,
                                            color: Colors.white,
                                          ),
                                        if (showVisitNotPerformed)
                                          Text(
                                            "Visita não realizada",
                                            style: GoogleFonts.dosis(
                                                textStyle: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 18)),
                                          ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        isChekin
                                            ? const Icon(
                                                Icons.login,
                                                color: Colors.white,
                                              )
                                            : Container(),
                                        isChekin
                                            ? Text(
                                                DateFormat('HH:mm').format(
                                                    DateTime.parse(pontos![index]
                                                        .dtCheckIn
                                                        .toString())),
                                                style: GoogleFonts.dosis(
                                                    textStyle: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 18)),
                                              )
                                            : Container(),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 213.0),
                                          child: isChekin
                                              ? const Icon(
                                                  Icons.logout,
                                                  color: Colors.white,
                                                )
                                              : Container(),
                                        ),
                                        isChekin
                                            ? Text(
                                                pontos![index].dtCheckOut != null
                                                    ? DateFormat('HH:mm').format(
                                                        DateTime.parse(
                                                            pontos![index]
                                                                .dtCheckOut
                                                                .toString()))
                                                    : '',
                                                style: GoogleFonts.dosis(
                                                    textStyle: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 18)),
                                              )
                                            : Container(),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        })
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
