import 'package:flutter/material.dart';
import 'package:smart_greenhouse/main_screen.dart';

void main() {
  runApp(const GreenhouseApp());
}

class GreenhouseApp extends StatefulWidget {
  const GreenhouseApp({super.key});

  @override
  State<GreenhouseApp> createState() => _GreenhouseAppState();
}

class _GreenhouseAppState extends State<GreenhouseApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.green),
      home: const MainScreen(),
    );
  }
}
