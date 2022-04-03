import 'dart:io';

import 'package:flutter/material.dart';
import 'package:token_transfer/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Token Transfer',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple, textSelectionTheme: TextSelectionThemeData(selectionColor: Colors.blue.shade100)
      ),
      home: const HomePage(),
    );
  }
}
