//import 'package:flutflix/colors.dart';
import 'package:flutflix/home_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '&flix',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Color.fromARGB(255, 43, 40, 40),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}