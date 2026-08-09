import 'package:flutter/material.dart';
import '../database/database_helper.dart';

class NuevaCompra extends StatefulWidget {
  const NuevaCompra({super.key});

  @override
  State<NuevaCompra> createState() => _NuevaCompraState();
}

class _NuevaCompraState extends State<NuevaCompra> {
  final descripcionCompra = TextEditingController();
  final costo = TextEditingController();

  String vendedorSeleccionado = "CAMIONETA ROJA";
  String estadoPago = "PENDIENTE";

  Future guardarCompra() async {
    await DatabaseHelper.instance.insertarCompra({
      'descripcion_compra': descripcionCompra.text,
      'vendedor': vendedorSeleccionado,
      'costo': double.parse(costo.text),
      'estado_pago': estadoPago,
    });

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("COMPRA GUARDADA")));

    descripcionCompra.clear();
    costo.clear();

    setState(() {
      vendedorSeleccionado = "CAMIONETA ROJA";
      estadoPago = "PENDIENTE";
    });
  }

  //AQUI ES DONDE SE DIBUJA LOS ELEMENTOS DE LA PANTALLA
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("NUEVA COMPRA")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: descripcionCompra,
                decoration: const InputDecoration(
                  labelText: "Descripción de la compra",
                ),
              ),
              const SizedBox(height: 15),
              // Selector de vendedor
              DropdownButtonFormField<String>(
                value: vendedorSeleccionado,
                decoration: const InputDecoration(labelText: "Vendedor"),
                items: const [
                  DropdownMenuItem(
                    value: "CAMIONETA ROJA",
                    child: Text("CAMIONETA ROJA"),
                  ),

                  DropdownMenuItem(
                    value: "AUTO PLOMO",
                    child: Text("AUTO PLOMO"),
                  ),
                ],

                onChanged: (valor) {
                  setState(() {
                    vendedorSeleccionado = valor!;
                  });
                },
              ),

              const SizedBox(height: 15),
              TextField(
                controller: costo,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: "Costo"),
              ),

              const SizedBox(height: 15),
              // Estado del pago
              DropdownButtonFormField<String>(
                value: estadoPago,
                decoration: const InputDecoration(labelText: "Estado de pago"),
                items: const [
                  DropdownMenuItem(
                    value: "PENDIENTE",
                    child: Text("PENDIENTE"),
                  ),
                  DropdownMenuItem(value: "PAGADO", child: Text("PAGADO")),
                ],

                onChanged: (valor) {
                  setState(() {
                    estadoPago = valor!;
                  });
                },
              ),

              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: guardarCompra,
                  child: const Text(
                    "Guardar Compra",
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
