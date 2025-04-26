import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart'; // <- Import necessário
import 'screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // <- Necessário para inicialização antes do runApp
  await initializeDateFormatting(
      'pt_BR', null); // <- Inicializa a formatação em português
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ebenezer Camp',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        scaffoldBackgroundColor: Colors.white,
        useMaterial3: true,
      ),
      home: const LoginScreen(), // <- Tela inicial
    );
  }
}
