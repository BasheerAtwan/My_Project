import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:qr_code_generator/AdmiPage.dart';
import 'FormPage.dart';
import 'firebase_options.dart';
void main() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  initializeDateFormatting('ar', null).then((_) {
    runApp(const MainApp());
  });
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      theme: ThemeData(appBarTheme: const AppBarTheme(color: Color.fromARGB(255, 13, 19, 140)),
        fontFamily: 'ArabicModern', // Add the Arabic font here

      ),

      home:    AdminPage(),
    );
  }
}
