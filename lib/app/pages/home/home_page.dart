// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:acessonovo/app/pages/home/pages/config_page.dart';
import 'package:acessonovo/app/pages/home/pages/escala_page.dart';
import 'package:acessonovo/app/pages/home/pages/historico_page.dart';
import 'package:acessonovo/app/pages/home/pages/perfil_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

enum InitialHomePage { config, perfil, historico, escala }

extension InitialHomePageExt on InitialHomePage {
  bool get isConfig => this == InitialHomePage.config;
  bool get isPerfil => this == InitialHomePage.perfil;
  bool get isHistorico => this == InitialHomePage.historico;
  bool get isEscala => this == InitialHomePage.escala;
}

class HomePage extends StatefulWidget {
  final InitialHomePage? initialHomePage;
  const HomePage({
    Key? key,
    this.initialHomePage,
  }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int intemSelecionado = 0;
  Color darkBlueColor = const Color(0xFF0C2356);
  static TextStyle labelStyle = GoogleFonts.dosis(
    textStyle: TextStyle(
      fontSize: 14,
      color: Colors.white,
      fontWeight: FontWeight.bold,
    ),
  );
  @override
  void initState() {
    if (widget.initialHomePage != null) {
      switch (widget.initialHomePage!) {
        case InitialHomePage.config:
          intemSelecionado = 3;
          break;
        case InitialHomePage.escala:
          intemSelecionado = 0;
          break;
        case InitialHomePage.perfil:
          intemSelecionado = 1;
          break;
        case InitialHomePage.historico:
          intemSelecionado = 2;
          break;
        default:
      }
      setState(() {});
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: intemSelecionado,
        children: const [
          // EscalaPage(),
          MyApp(),
          PerfilPage(),
          HistoricoPage(),
          ConfigPage(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: intemSelecionado,
        backgroundColor: darkBlueColor,
        unselectedItemColor: Colors.grey,
        fixedColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Escala",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Perfil"),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: "Historico"),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Configurações"),
        ],
        selectedLabelStyle: labelStyle,
        unselectedLabelStyle: labelStyle,
        onTap: (valor) {
          setState(
            () {
              intemSelecionado = valor;
            },
          );
        },
      ),
    );
  }
}
