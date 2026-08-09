import 'package:flutter/material.dart';
import 'database/database_helper.dart';
import 'screens/inicio.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await DatabaseHelper.instance.database;

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      title: "Registro de Compras",

      //home: const Inicio(),
      home: const Inicio(),
    );
  }
}
