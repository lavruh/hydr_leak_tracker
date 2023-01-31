import 'package:flutter/material.dart';
import 'package:hydr_leak_tracker/ui/log_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hydraulic leak tracker',
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
      home: const LogScreen(),
    );
  }
}
