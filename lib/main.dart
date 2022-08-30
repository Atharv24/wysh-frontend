import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wysh/screens/home.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wysh',
      theme: ThemeData(textTheme: GoogleFonts.cabinTextTheme()),
      home: const HomePage(),
    );
  }
}
