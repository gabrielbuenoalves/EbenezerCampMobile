import 'package:flutter/material.dart';

class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({super.key});

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  List<Map<String, dynamic>> transactions = [];
  String? selectedUser;
  final TextEditingController valueController = TextEditingController();

  final List<String> fakeUsers = [
    'Bielzera botelho',
    'tavera lurkz',
    'felipe gnomo',
    'monkey d. luffy'
  ];

  void _openAddCreditModal() {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Container(
            padding: const EdgeInsets.all(24),
            width: MediaQuery.of(context).size.width * 0.9,
            constraints: const BoxConstraints(minHeight: 300),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Adicionar Créditos',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 24),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'Selecione o usuário',
                    border: OutlineInputBorder(),
                  ),
                  items: fakeUsers.map((user) {
                    return DropdownMenuItem(
                      value: user,
                      child: Text(user),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedUser = value;
                    });
                  },
                  value: selectedUser,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: valueController,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(
                    labelText: 'Valor do crédito',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        valueController.clear();
                        selectedUser = null;
                      },
                      child: const Text('Fechar'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (selectedUser == null ||
                            valueController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Preencha todos os campos!')),
                          );
                          return;
                        }

                        _addCredit();
                        Navigator.of(context).pop(); // fecha a modal
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber,
                      ),
                      child: const Text('Adicionar'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _confirmAddCredit() {
    if (selectedUser == null || valueController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preencha todos os campos!')),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmação'),
        content: Text(
            'Deseja adicionar ${valueController.text} créditos para $selectedUser?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              _addCredit();
              Navigator.of(context).pop(); // fecha o dialog
              Navigator.of(context).pop(); // fecha a modal
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
            ),
            child: const Text('Confirmar'),
          ),
        ],
      ),
    );
  }

  void _addCredit() {
    setState(() {
      transactions.add({
        'user': selectedUser!,
        'value': double.parse(valueController.text),
        'timestamp': DateTime.now(),
      });
      selectedUser = null;
      valueController.clear();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Crédito adicionado com sucesso!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transações de Crédito'),
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.add),
                label: const Text('Adicionar Créditos'),
                onPressed: _openAddCreditModal,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: transactions.isEmpty
                  ? const Center(
                      child: Text('Nenhuma transação registrada.'),
                    )
                  : ListView.builder(
                      itemCount: transactions.length,
                      itemBuilder: (context, index) {
                        final transaction = transactions[index];
                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 4,
                          margin: const EdgeInsets.only(bottom: 12),
                          child: ListTile(
                            leading: const Icon(Icons.attach_money,
                                color: Colors.green),
                            title: Text(transaction['user']),
                            subtitle: Text(
                              'Valor: R\$ ${transaction['value'].toStringAsFixed(2)}',
                            ),
                            trailing: Text(
                              '${transaction['timestamp'].hour}:${transaction['timestamp'].minute.toString().padLeft(2, '0')}',
                              style: const TextStyle(fontSize: 12),
                            ),
                          ),
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
