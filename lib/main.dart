import 'package:acessonovo/app/pages/home/home_page.dart';
import 'package:acessonovo/app/pages/input/input_screen.dart';
import 'package:acessonovo/app/shared/theme/colors_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:shared_preferences/shared_preferences.dart';

main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  final bool hasUser = await verificarUser();
  runApp(
    MyApp(hasUser: hasUser),
  );
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
}

class MyApp extends StatefulWidget {
  const MyApp({super.key, required this.hasUser});
  final bool hasUser;
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    tempoSplash();
  }

  void tempoSplash() async {
    await Future.delayed(const Duration(seconds: 1));
    FlutterNativeSplash.remove();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      title: 'Acesso Novo',
      debugShowCheckedModeBanner: false,
      theme: myTheme,
      localizationsDelegates: const [
        GlobalCupertinoLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('pt', 'BR'),
      ],
      home: widget.hasUser ? const HomePage() : const InputScreen(),
    );
  }
}

Future<bool> verificarUser() async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  return sharedPreferences.getString('data') != null;
}
