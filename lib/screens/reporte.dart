import 'package:flutter/material.dart';

class Reporte extends StatelessWidget {
  const Reporte({super.key});

  //AQUI ES DONDE SE DIBUJA LOS ELEMENTOS DE LA PANTALLA
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("REPORTES")),

      body: const Center(
        child: Text(
          "Aquí estarán los reportes",
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
