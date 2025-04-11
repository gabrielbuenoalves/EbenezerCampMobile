import 'package:flutter/material.dart';
import 'forgot_password_confirmation_screen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _loading = false;
  String? _mensagem;

  Future<void> _enviarEmailRecuperacao() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _loading = true;
        _mensagem = null;
      });

      await Future.delayed(const Duration(seconds: 2));

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const ForgotPasswordConfirmationScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: SizedBox(
            height: deviceHeight,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Stack(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Logo
                      Padding(
                        padding: const EdgeInsets.only(top: 32, bottom: 16),
                        child: SizedBox(
                          height: 120,
                          child: Image.asset(
                            'assets/logoEbenezer.png',
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),

                      const SizedBox(height: 8),

                      const Text(
                        'Informe seu e-mail cadastrado para um link para a recuperação da senha.',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16),
                      ),

                      const SizedBox(height: 24),

                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: const InputDecoration(
                                labelText: 'E-mail',
                                border: OutlineInputBorder(),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Informe seu e-mail';
                                }
                                if (!value.contains('@')) {
                                  return 'E-mail inválido';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 24),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed:
                                    _loading ? null : _enviarEmailRecuperacao,
                                child: _loading
                                    ? const CircularProgressIndicator()
                                    : const Text('Enviar'),
                              ),
                            ),
                            if (_mensagem != null)
                              Padding(
                                padding: const EdgeInsets.only(top: 16),
                                child: Text(
                                  _mensagem!,
                                  style: const TextStyle(color: Colors.green),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  // Botão de voltar
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 50,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back),
                      color: Colors.indigo,
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
