import 'package:flutter/material.dart';

class ParticipantesScreen extends StatefulWidget {
  const ParticipantesScreen({super.key});

  @override
  _ParticipantesScreenState createState() => _ParticipantesScreenState();
}

class _ParticipantesScreenState extends State<ParticipantesScreen> {
  final List<Map<String, String>> participantes = [
    {'nome': 'João Silva', 'funcao': 'Trabalhador'},
    {'nome': 'Maria Souza', 'funcao': 'Acampante'},
    {'nome': 'Carlos Almeida', 'funcao': 'Líder'},
    {'nome': 'Ana Costa', 'funcao': 'Acampante'},
  ];

  void _showAddParticipantDialog() {
    String nome = '';
    String? funcao;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: const Text('Adicionar Participante'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    onChanged: (value) {
                      nome = value;
                    },
                    decoration: const InputDecoration(
                      labelText: 'Nome',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value: funcao,
                    decoration: const InputDecoration(
                      labelText: 'Função',
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: 'Trabalhador',
                        child: Text('Trabalhador'),
                      ),
                      DropdownMenuItem(
                        value: 'Acampante',
                        child: Text('Acampante'),
                      ),
                    ],
                    onChanged: (value) {
                      setModalState(() {
                        funcao = value;
                      });
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancelar'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (nome.isNotEmpty && funcao != null) {
                      setState(() {
                        participantes.add({'nome': nome, 'funcao': funcao!});
                      });
                      Navigator.of(context).pop();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber,
                  ),
                  child: const Text('Adicionar'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showDeleteDialog(String nome) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text('Confirmar Remoção'),
          content:
              Text('Você tem certeza que deseja remover $nome desse quarto?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  participantes.removeWhere((p) => p['nome'] == nome);
                });
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              child: const Text('Remover'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildParticipantCard(Map<String, String> participante) {
    String nome = participante['nome']!;
    String funcao = participante['funcao']!;

    IconData iconeFuncao;
    Color corFuncao;

    switch (funcao) {
      case 'Trabalhador':
        iconeFuncao = Icons.work;
        corFuncao = Colors.blueAccent;
        break;
      case 'Acampante':
        iconeFuncao = Icons.park;
        corFuncao = Colors.green;
        break;
      case 'Líder':
        iconeFuncao = Icons.star;
        corFuncao = Colors.deepPurple;
        break;
      default:
        iconeFuncao = Icons.person;
        corFuncao = Colors.grey;
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          radius: 26,
          backgroundColor: corFuncao.withOpacity(0.1),
          child: Text(
            nome[0].toUpperCase(),
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: corFuncao,
            ),
          ),
        ),
        title: Text(
          nome,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 18,
            color: Color(0xFF1D3557),
          ),
        ),
        subtitle: Row(
          children: [
            Icon(iconeFuncao, size: 16, color: corFuncao),
            const SizedBox(width: 4),
            Text(
              funcao,
              style: TextStyle(color: corFuncao),
            ),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete_outline, color: Colors.red),
          onPressed: () => _showDeleteDialog(nome),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 2,
        title: const Text(
          'Participantes',
          style: TextStyle(
            color: Color(0xFF1D3557),
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.amber),
            onPressed: _showAddParticipantDialog,
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: participantes.length,
        itemBuilder: (context, index) {
          return _buildParticipantCard(participantes[index]);
        },
      ),
    );
  }
}
