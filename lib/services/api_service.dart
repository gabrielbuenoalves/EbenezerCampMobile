import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'https://localhost:7125';

  static Future<String?> login(String email, String senha) async {
    final url = Uri.parse('$baseUrl/api/auth/login');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': email,
          'senha': senha,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['token'];
      } else {
        print('Erro no login: ${response.statusCode}');
        print('Mensagem: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Erro de conexão: $e');
      return null;
    }
  }

  // Você pode adicionar mais métodos aqui:
  // static Future<bool> register(...) async { ... }
  // static Future<void> recuperarSenha(...) async { ... }
}
