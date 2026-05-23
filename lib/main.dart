import 'package:flutter/material.dart';

void main() {
  runApp(const ShatrApp());
}

class ShatrApp extends StatelessWidget {
  const ShatrApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'شطر',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: const Scaffold(
        body: Center(
          child: Text(
            'شَطْر',
            style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
