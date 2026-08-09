import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../utils/generar_pdf.dart';

String obtenerDia(String fecha) {
  DateTime fechaConvertida = DateTime.parse(fecha);

  switch (fechaConvertida.weekday) {
    case 1:
      return "Lunes";
    case 2:
      return "Martes";
    case 3:
      return "Miércoles";
    case 4:
      return "Jueves";
    case 5:
      return "Viernes";
    case 6:
      return "Sábado";
    case 7:
      return "Domingo";
    default:
      return "";
  }
}

class ListaCompras extends StatefulWidget {
  const ListaCompras({super.key});

  @override
  State<ListaCompras> createState() => _ListaComprasState();
}

class _ListaComprasState extends State<ListaCompras> {
  List<Map<String, dynamic>> compras = [];

  String filtroEstado = "TODOS";
  String vendedorSeleccionado = "TODOS";
  @override
  void initState() {
    super.initState();
    cargarCompras();
  }

  Future cargarCompras() async {
    List<Map<String, dynamic>> resultado =
        await DatabaseHelper.instance.obtenerCompras();
    if (filtroEstado == "PENDIENTES") {
      resultado =
          resultado.where((c) => c['estado_pago'] == "PENDIENTE").toList();
    }
    if (filtroEstado == "PAGADOS") {
      resultado = resultado.where((c) => c['estado_pago'] == "PAGADO").toList();
    }
    if (vendedorSeleccionado != "TODOS") {
      resultado =
          resultado
              .where((c) => c['vendedor'] == vendedorSeleccionado)
              .toList();
    }

    setState(() {
      compras = resultado;
    });
  }

  // Cambiar PENDIENTE / PAGADO
  Future cambiarEstadoPago(Map<String, dynamic> compra) async {
    if (compra['estado_pago'] == "PAGADO") {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Esta compra ya está pagada")),
      );
      return;
    }

    bool? confirmar = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Confirmar pago"),
          content: Text(
            "¿Desea cambiar la compra ${compra['id_compra']} a PAGADO?",
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text("Cancelar"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text("Pagar"),
            ),
          ],
        );
      },
    );

    if (confirmar == true) {
      await DatabaseHelper.instance.actualizarEstadoPago(
        compra['id_compra'],
        "PAGADO",
      );
      await cargarCompras();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Compra actualizada a PAGADO")),
      );
    }
  }

  //AQUI ES DONDE SE DIBUJA LOS ELEMENTOS DE LA PANTALLA
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "COMPRAS REGISTRADAS",

          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.5,
          ),
        ),

        centerTitle: true,
      ),

      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),

            child: DropdownButtonFormField<String>(
              value: vendedorSeleccionado,

              decoration: const InputDecoration(
                labelText: "Seleccionar vendedor",

                border: OutlineInputBorder(),
              ),

              items: const [
                DropdownMenuItem(value: "TODOS", child: Text("TODOS")),

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

                cargarCompras();
              },
            ),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,

            children: [
              ElevatedButton(
                onPressed: () {
                  filtroEstado = "TODOS";

                  cargarCompras();
                },

                child: const Text("Todos"),
              ),

              ElevatedButton(
                onPressed: () {
                  filtroEstado = "PENDIENTES";

                  cargarCompras();
                },

                child: const Text("Pendientes"),
              ),

              ElevatedButton(
                onPressed: () {
                  filtroEstado = "PAGADOS";

                  cargarCompras();
                },

                child: const Text("Pagados"),
              ),
            ],
          ),

          const SizedBox(height: 10),

          ElevatedButton(
            onPressed: () {
              generarPDF(compras);
            },

            child: const Text("Generar PDF"),
          ),

          Expanded(
            child: ListView.builder(
              itemCount: compras.length,

              itemBuilder: (context, index) {
                final compra = compras[index];

                return Card(
                  margin: const EdgeInsets.all(8),

                  child: ListTile(
                    // tocar compra cambia estado
                    onTap: () {
                      cambiarEstadoPago(compra);
                    },

                    title: Text(
                      "ID COMPRA: ${compra['id_compra']}",

                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),

                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        Text(
                          "Descripción compra: ${compra['descripcion_compra']}",
                        ),

                        Text("Vendedor: ${compra['vendedor']}"),

                        Text("Costo: \$${compra['costo']}"),

                        /*

                        Text("Estado: ${compra['estado_pago']}"),
*/
                        Text(
                          "Estado: ${compra['estado_pago']}",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color:
                                compra['estado_pago'] == "PAGADO"
                                    ? Colors.green
                                    : Colors.red,
                          ),
                        ),

                        Text("Día: ${obtenerDia(compra['fecha'])}"),

                        Text("Fecha: ${compra['fecha']}"),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
