import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../config.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _telefoneController = TextEditingController();
  final _cpfController = TextEditingController();
  final _senhaController = TextEditingController();
  final _confirmarSenhaController = TextEditingController();

  String? _funcaoSelecionada;
  bool _loading = false;

  InputDecoration _buildInputDecoration(String label, IconData icon) {
    return InputDecoration(
      hintText: label,
      hintStyle: const TextStyle(color: Colors.black54),
      prefixIcon: Icon(icon, color: Colors.black54),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.transparent),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: Color.fromARGB(255, 199, 151, 8),
          width: 2,
        ),
      ),
    );
  }

  Future<void> _realizarCadastro() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _loading = true);

      final url = Uri.parse('${AppConfig.baseUrl}/api/Auth/register');

      final body = {
        'nome': _nomeController.text.trim(),
        'email': _emailController.text.trim(),
        'senha': _senhaController.text.trim(),
        'confirmarSenha': _confirmarSenhaController.text.trim(),
        'funcao': _funcaoSelecionada,
        'cpf': _cpfController.text.trim(),
        'telefone': _telefoneController.text.trim(),
      };

      try {
        final response = await http.post(
          url,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(body),
        );

        if (response.statusCode == 200 || response.statusCode == 201) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Cadastro realizado com sucesso!')),
          );
          Navigator.pop(context);
        } else {
          String errorMessage = 'Erro ao cadastrar.';

          if (response.body.isNotEmpty) {
            try {
              final resp = jsonDecode(response.body);
              errorMessage = resp['message'] ?? errorMessage;
            } catch (_) {
              errorMessage = 'Erro: resposta inesperada da API.';
            }
          } else if (response.statusCode == 401) {
            errorMessage =
                'Não autorizado. Verifique se o endpoint permite acesso anônimo.';
          }

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(errorMessage)),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro de conexão: $e')),
        );
      } finally {
        setState(() => _loading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 9, 20, 49),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: IntrinsicHeight(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 32, bottom: 16),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: SizedBox(
                            height: 120,
                            child: Image.asset(
                              'assets/logoEbenezer.png',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'CADASTRAR',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 199, 151, 8),
                        ),
                      ),
                      const SizedBox(height: 32),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              controller: _nomeController,
                              style: const TextStyle(color: Colors.black),
                              decoration:
                                  _buildInputDecoration("Nome", Icons.person),
                              validator: (value) =>
                                  value!.isEmpty ? "Informe seu nome" : null,
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              style: const TextStyle(color: Colors.black),
                              decoration:
                                  _buildInputDecoration("E-mail", Icons.email),
                              validator: (value) {
                                if (value!.isEmpty) return "Informe seu e-mail";
                                if (!value.contains('@'))
                                  return 'E-mail inválido';
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _telefoneController,
                              keyboardType: TextInputType.phone,
                              style: const TextStyle(color: Colors.black),
                              decoration: _buildInputDecoration(
                                  "Telefone", Icons.phone),
                              validator: (value) => value!.isEmpty
                                  ? "Informe seu telefone"
                                  : null,
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _cpfController,
                              keyboardType: TextInputType.number,
                              style: const TextStyle(color: Colors.black),
                              decoration: _buildInputDecoration(
                                  "CPF", Icons.credit_card),
                              validator: (value) =>
                                  value!.isEmpty ? "Informe seu CPF" : null,
                            ),
                            const SizedBox(height: 16),
                            DropdownButtonFormField<String>(
                              decoration:
                                  _buildInputDecoration("Função", Icons.work),
                              dropdownColor: Colors.white,
                              value: _funcaoSelecionada,
                              items: const [
                                DropdownMenuItem(
                                  value: 'Acampante',
                                  child: Text('Acampante'),
                                ),
                                DropdownMenuItem(
                                  value: 'Trabalhador',
                                  child: Text('Trabalhador'),
                                ),
                              ],
                              onChanged: (value) {
                                setState(() {
                                  _funcaoSelecionada = value;
                                });
                              },
                              validator: (value) =>
                                  value == null ? 'Selecione a função' : null,
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _senhaController,
                              obscureText: true,
                              style: const TextStyle(color: Colors.black),
                              decoration:
                                  _buildInputDecoration("Senha", Icons.lock),
                              validator: (value) => value!.length < 6
                                  ? "Mínimo 6 caracteres"
                                  : null,
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _confirmarSenhaController,
                              obscureText: true,
                              style: const TextStyle(color: Colors.black),
                              decoration: _buildInputDecoration(
                                  "Confirmar senha", Icons.lock_outline),
                              validator: (value) {
                                if (value != _senhaController.text) {
                                  return "As senhas não coincidem";
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 24),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      const Color.fromARGB(255, 199, 151, 8),
                                  foregroundColor: const Color(0xFF0D1B2A),
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 16),
                                  textStyle: const TextStyle(fontSize: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                onPressed: _loading ? null : _realizarCadastro,
                                child: _loading
                                    ? const CircularProgressIndicator()
                                    : const Text("Cadastrar"),
                              ),
                            ),
                            const SizedBox(height: 16),
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text(
                                "Já tem conta? Voltar para login",
                                style: TextStyle(
                                  color: Color.fromARGB(255, 199, 151, 8),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
