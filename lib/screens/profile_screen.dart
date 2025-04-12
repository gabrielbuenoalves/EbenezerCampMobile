import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  final String nome;
  final String email;
  final String telefone;
  final String funcao;

  const ProfileScreen({
    super.key,
    required this.nome,
    required this.email,
    required this.telefone,
    required this.funcao,
  });

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late TextEditingController _emailController;
  late TextEditingController _telefoneController;
  late TextEditingController _senhaController;
  late String _selectedFuncao;
  final double saldo = 120.50; // saldo fictício

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(text: widget.email);
    _telefoneController = TextEditingController(text: widget.telefone);
    _senhaController = TextEditingController();
    _selectedFuncao = widget.funcao; // Inicializando com a função passada
  }

  Widget _buildInfoTile(String label, String value, IconData icon) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, color: const Color.fromARGB(255, 199, 151, 8)),
        title: Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        subtitle: Text(
          value,
          style: const TextStyle(fontSize: 16, color: Colors.black87),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: const Text(
          "Perfil",
          style: TextStyle(
            color: Color.fromARGB(255, 9, 20, 49),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(
          color: Color.fromARGB(255, 9, 20, 49),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const CircleAvatar(
              radius: 40,
              backgroundColor: Color.fromARGB(255, 199, 151, 8),
              child: Icon(Icons.person, size: 40, color: Colors.white),
            ),
            const SizedBox(height: 16),
            Text(
              widget.nome,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 9, 20, 49),
              ),
            ),
            const SizedBox(height: 24),
            _buildInfoTile("E-mail", widget.email, Icons.email),
            _buildInfoTile("Telefone", widget.telefone, Icons.phone),
            _buildInfoTile("Função", widget.funcao, Icons.assignment_ind),
            _buildInfoTile("Saldo", "R\$ $saldo", Icons.account_balance_wallet),
            const Spacer(),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 199, 151, 8),
                foregroundColor: const Color(0xFF0D1B2A),
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: const Icon(Icons.edit),
              label: const Text("Editar Perfil"),
              onPressed: () {
                _showEditProfileForm(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  // Função para exibir o formulário de edição
  void _showEditProfileForm(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            "Editar Perfil",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: "E-mail",
                    prefixIcon: Icon(Icons.email),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _telefoneController,
                  decoration: const InputDecoration(
                    labelText: "Telefone",
                    prefixIcon: Icon(Icons.phone),
                  ),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _selectedFuncao,
                  decoration: const InputDecoration(
                    labelText: "Função",
                    prefixIcon: Icon(Icons.assignment_ind),
                  ),
                  onChanged: (newValue) {
                    setState(() {
                      _selectedFuncao = newValue!;
                    });
                  },
                  items: const [
                    DropdownMenuItem(
                        value: 'Trabalhador', child: Text('Trabalhador')),
                    DropdownMenuItem(
                        value: 'Acampante', child: Text('Acampante')),
                  ],
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _senhaController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: "Nova Senha",
                    prefixIcon: Icon(Icons.lock),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue, // Cor azul para salvar
              ),
              onPressed: () {
                _showSaveConfirmationDialog(context);
              },
              child: const Text('Salvar'),
            ),
          ],
        );
      },
    );
  }

  // Função para exibir o diálogo de confirmação de salvar
  void _showSaveConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            "Confirmar alterações",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content:
              const Text("Você tem certeza que deseja salvar as alterações?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Fecha o diálogo de confirmação
                Navigator.of(context).pop(); // Fecha o diálogo de edição
                _showSnackbar(context); // Exibe o Snackbar
              },
              child: const Text('Confirmar'),
            ),
          ],
        );
      },
    );
  }

  // Função para exibir a Snackbar de confirmação
  void _showSnackbar(BuildContext context) {
    final snackBar = SnackBar(
      content: const Text('Perfil atualizado com sucesso!'),
      duration: const Duration(seconds: 2),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
