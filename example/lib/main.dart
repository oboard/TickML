import 'package:flutter/material.dart';

import 'package:tickml/tickml.dart';

void main() {
  runApp(const TickMLApp());
}

class TickMLApp extends StatelessWidget {
  const TickMLApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'TickML Test',
      home: Scaffold(
        body: Center(
          child: TickML("<text>Hello, World!</text>"),
        ),
      ),
    );
  }
}
