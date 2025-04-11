import 'package:flutter/material.dart';

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
  final _senhaController = TextEditingController();
  final _confirmarSenhaController = TextEditingController();

  bool _loading = false;

  void _realizarCadastro() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _loading = true;
      });

      // TODO: Enviar os dados para API

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cadastro realizado!')),
      );

      setState(() {
        _loading = false;
      });

      // TODO: Navegar para login
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Cadastro")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Nome
              TextFormField(
                controller: _nomeController,
                decoration: const InputDecoration(labelText: "Nome"),
                validator: (value) =>
                    value!.isEmpty ? "Informe seu nome" : null,
              ),
              const SizedBox(height: 16),

              // E-mail
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(labelText: "E-mail"),
                validator: (value) {
                  if (value!.isEmpty) return "Informe seu e-mail";
                  if (!value.contains("@")) return "E-mail inválido";
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Telefone
              TextFormField(
                controller: _telefoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(labelText: "Telefone"),
                validator: (value) =>
                    value!.isEmpty ? "Informe seu telefone" : null,
              ),
              const SizedBox(height: 16),

              // Senha
              TextFormField(
                controller: _senhaController,
                obscureText: true,
                decoration: const InputDecoration(labelText: "Senha"),
                validator: (value) =>
                    value!.length < 6 ? "Mínimo 6 caracteres" : null,
              ),
              const SizedBox(height: 16),

              // Confirmar Senha
              TextFormField(
                controller: _confirmarSenhaController,
                obscureText: true,
                decoration: const InputDecoration(labelText: "Confirmar senha"),
                validator: (value) {
                  if (value != _senhaController.text) {
                    return "As senhas não coincidem";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // Botão de cadastrar
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _loading ? null : _realizarCadastro,
                  child: _loading
                      ? const CircularProgressIndicator()
                      : const Text("Cadastrar"),
                ),
              ),

              const SizedBox(height: 16),

              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Já tem conta? Voltar para login"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
