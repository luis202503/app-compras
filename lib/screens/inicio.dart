import 'package:flutter/material.dart';
import 'package:compras/screens/nueva_compra.dart';
import 'package:compras/screens/lista_compras.dart';
import 'package:compras/screens/reporte.dart';

class Inicio extends StatelessWidget {
  const Inicio({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Registro de Compras",
          style: TextStyle(
            color: Colors.black,
            fontSize: 30,
            fontWeight: FontWeight.w900,
            letterSpacing: 2.0,
          ),
        ),
        centerTitle: true,
      ),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            // Imagen del icono
            Image.asset('assets/icon/icono_compra.png', width: 80),
            const SizedBox(height: 70),
            // Botón Nueva Compra
            SizedBox(
              width: 230,
              height: 55,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.add),
                label: const Text(
                  "Nueva Compra",
                  style: TextStyle(fontSize: 18),
                ),

                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const NuevaCompra(),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 20),

            // Botón Ver Compras
            SizedBox(
              width: 230,
              height: 55,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.list),
                label: const Text(
                  "Ver Compras",
                  style: TextStyle(fontSize: 18),
                ),

                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ListaCompras(),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 20),

            // Botón Reportes
            SizedBox(
              width: 230,
              height: 55,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.bar_chart),
                label: const Text("Reportes", style: TextStyle(fontSize: 18)),

                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Reporte()),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
