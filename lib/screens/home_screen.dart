import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'profile_screen.dart';
import 'bedroom_screen.dart';
import 'credits_screen.dart';
import 'events_screen.dart'; // Importe a tela de eventos

class HomeScreen extends StatefulWidget {
  final bool isAdmin;

  const HomeScreen({super.key, required this.isAdmin});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    const backgroundColor = Color(0xFFF5F7FA);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: PopupMenuButton<String>(
          icon: const Icon(Icons.menu, color: Colors.blueAccent),
          onSelected: (value) {
            if (value == 'transacoes') {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const TransactionsScreen(),
                ),
              );
            }
          },
          itemBuilder: (BuildContext context) {
            List<PopupMenuEntry<String>> items = [];

            if (widget.isAdmin) {
              items.add(
                const PopupMenuItem<String>(
                  value: 'transacoes',
                  child: Text('Transações'),
                ),
              );
            }

            return items;
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline, color: Colors.blueAccent),
            tooltip: 'Informações do sistema',
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  contentPadding: const EdgeInsets.all(24),
                  content: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Text(
                          "🎯 Objetivo",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1D3557),
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          "Este aplicativo tem como objetivo auxiliar na gestão de pessoas durante o acampamento da igreja. "
                          "Os participantes são organizados por quartos divididos por sexo, cada um com um líder responsável. "
                          "Além disso, o app também gerencia o saldo individual de cada pessoa, registrando gastos feitos na cantina.",
                          style: TextStyle(fontSize: 16),
                          textAlign: TextAlign.justify,
                        ),
                        SizedBox(height: 24),
                        Text(
                          "👥 Integrantes do Projeto",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1D3557),
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          "Gabriel Bueno Alves\nOtavio Lucas de Oliveira",
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                  actions: [
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('Fechar'),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.red),
            tooltip: 'Sair',
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    title: Row(
                      children: const [
                        Icon(Icons.warning_amber_rounded, color: Colors.orange),
                        SizedBox(width: 10),
                        Text(
                          'Confirmação',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    content: const Text(
                      'Deseja realmente sair do aplicativo?',
                      style: TextStyle(fontSize: 16),
                    ),
                    actionsPadding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    actions: [
                      TextButton(
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.grey[700],
                          textStyle: const TextStyle(fontSize: 15),
                        ),
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('Cancelar'),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginScreen(),
                            ),
                          );
                        },
                        child: const Text('Sair'),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: 100,
                child: Image.asset(
                  'assets/logoEbenezer.png',
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                "Bem vindo!",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1D3557),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              const SizedBox(height: 16),
              // Adicione aqui os eventos se houver algum ou algum conteúdo alternativo
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Início'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
          BottomNavigationBarItem(
              icon: Icon(Icons.bed_outlined), label: 'Quarto'),
          BottomNavigationBarItem(
              icon: Icon(Icons.event), label: 'Eventos'), // Novo item
        ],
        onTap: (index) {
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProfileScreen(
                  nome: 'Bielzera bot',
                  email: 'bielzeradev@gmail.com',
                  telefone: '(19) 99999-9999',
                  funcao: 'Trabalhador',
                ),
              ),
            );
          } else if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const QuartoScreen(),
              ),
            );
          } else if (index == 3) {
            // Redireciona para a tela de eventos
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CreateEventScreen(
                  isAdmin: widget.isAdmin,
                ), // Usando widget.isAdmin
              ),
            );
          }
        },
      ),
    );
  }
}
