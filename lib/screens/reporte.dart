import 'package:flutter/material.dart';

class Reporte extends StatelessWidget {
  const Reporte({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Reportes")),

      body: const Center(
        child: Text(
          "Aquí estarán los reportes",
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
