// import 'dart:async';
// import 'package:appteste/app/pages/home/home_page.dart';
// import 'package:appteste/app/pages/input/input_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/src/widgets/framework.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class SplashScreen extends StatefulWidget {
//   const SplashScreen({super.key});

//   @override
//   State<SplashScreen> createState() => _SplashScreenState();
// }

// class _SplashScreenState extends State<SplashScreen> {
//   @override
//   void initState() {
//     super.initState();
//     verificarUser().then((value) {
//       if (value) {
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (context) => const HomePage()),
//         );
//       } else {
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (context) => const InputScreen()),
//         );
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container();
//   }

//   Future<bool> verificarUser() async {
//     SharedPreferences sheredPreference = await SharedPreferences.getInstance();
//     if (sheredPreference.getString('data') != null) {
//       return true;
//     } else {
//       return false;
//     }
//   }
// }
