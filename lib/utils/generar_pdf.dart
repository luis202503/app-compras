import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

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

Future<void> generarPDF(List<Map<String, dynamic>> trabajos) async {
  final pdf = pw.Document();

  double totalCobrado = 0;
  double totalPendiente = 0;

  for (var trabajo in trabajos) {
    double costo = trabajo['costo'];

    if (trabajo['estado_pago'] == "PAGADO") {
      totalCobrado += costo;
    } else {
      totalPendiente += costo;
    }
  }

  pdf.addPage(
    pw.MultiPage(
      pageFormat: PdfPageFormat.a4,

      build: (context) {
        return [
          pw.Center(
            child: pw.Text(
              "REGISTRO DE COMPRAS",

              style: pw.TextStyle(fontSize: 22, fontWeight: pw.FontWeight.bold),
            ),
          ),

          pw.SizedBox(height: 10),

          pw.Text("Reporte de compras"),

          pw.SizedBox(height: 20),

          pw.Table.fromTextArray(
            headers: [
              "ID COMPRA",
              "DESCRIPCION COMPRA",
              "VENDEDOR",
              "COSTO",
              "ESTADO",
              "DIA",
              "FECHA",
            ],

            data:
                trabajos.map((trabajo) {
                  return [
                    trabajo['id_compra'],

                    trabajo['descripcion_compra'],

                    trabajo['vendedor'],

                    "\$${trabajo['costo']}",

                    trabajo['estado_pago'],

                    obtenerDia(trabajo['fecha']),

                    trabajo['fecha'],
                  ];
                }).toList(),
          ),

          pw.SizedBox(height: 20),

          pw.Text(
            "TOTAL COBRADO: \$${totalCobrado.toStringAsFixed(2)}",

            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
          ),

          pw.Text(
            "TOTAL PENDIENTE: \$${totalPendiente.toStringAsFixed(2)}",

            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
          ),

          pw.SizedBox(height: 10),

          pw.Text("Cantidad de trabajos: ${trabajos.length}"),
        ];
      },
    ),
  );

  await Printing.layoutPdf(
    onLayout: (formato) async {
      return pdf.save();
    },
  );
}
