import 'package:flutter/material.dart';
import 'peoples_bedroom_screen.dart'; // Importando a tela de participantes

class QuartoScreen extends StatelessWidget {
  const QuartoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Map<String, List<Map<String, String>>> quartos = {
      'Masculino': [
        {
          'nome': 'Quarto 1',
          'lider': 'Lucas Oliveira',
          'ocupacao': '6',
          'capacidade': '8',
        },
        {
          'nome': 'Quarto 2',
          'lider': 'Gabriel Alves',
          'ocupacao': '4',
          'capacidade': '8',
        },
      ],
      'Feminino': [
        {
          'nome': 'Quarto 1',
          'lider': 'Maria Silva',
          'ocupacao': '5',
          'capacidade': '8',
        },
        {
          'nome': 'Quarto 2',
          'lider': 'Ana Souza',
          'ocupacao': '6',
          'capacidade': '8',
        },
      ],
    };

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 2,
        title: const Text(
          'Gestão de Quartos',
          style: TextStyle(
            color: Color(0xFF1D3557),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: quartos.entries.map((entry) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                entry.key,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1D3557),
                ),
              ),
              const SizedBox(height: 8),
              ...entry.value.map((quarto) {
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 3,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(12),
                    title: Text(
                      quarto['nome']!,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Color(0xFF1D3557),
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Líder: ${quarto['lider']}'),
                        Text('Ocupação: ${quarto['ocupacao']}'),
                        Text('Capacidade: ${quarto['capacidade']}'),
                      ],
                    ),
                    trailing: IconButton(
                      icon: const Icon(
                        Icons.group,
                        color: Colors.amber, // Cor amarelo para o ícone
                      ),
                      onPressed: () {
                        // Navegar para a tela de Participantes
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ParticipantesScreen(),
                          ),
                        );
                      },
                    ),
                  ),
                );
              }).toList(),
            ],
          );
        }).toList(),
      ),
    );
  }
}
