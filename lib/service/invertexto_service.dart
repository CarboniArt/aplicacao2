import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class InvertextoService {
  final String _token = "21567|3pIjBHMOxbPqSemOC90q18RypX6llWZS";

  Future<Map<String, dynamic>> ConvertePorExtenso(
    String? valor, {
    required String moeda,
  }) async {
    try {
      if (valor == null || valor.isEmpty) {
        throw Exception('Por favor, insira um número.');
      }

      final uri = Uri.parse(
        "https://api.invertexto.com/v1/number-to-words"
        "?token=$_token"
        "&number=$valor"
        "&language=pt"
        "&currency=$moeda",
      );
      final response = await http.get(uri);
      final data = json.decode(response.body);

      if (response.statusCode == 200) {
        if (data.containsKey('error')) {
          throw Exception(data['error']);
        }
        return data;
      } else {
        final errorMessage =
            data['error'] ?? 'Erro ${response.statusCode}: Falha na conversão.';
        throw Exception(errorMessage);
      }
    } on SocketException {
      throw Exception('Erro de conexão com a internet.');
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> buscaCEP(String? valor) async {
    try {
      if (valor == null || valor.isEmpty) {
        throw Exception('Por favor, insira um CEP válido.');
      }

      final uri = Uri.parse(
        "https://api.invertexto.com/v1/cep/${valor}?token=${_token}",
      );
      final response = await http.get(uri);
      final data = json.decode(response.body);

      if (response.statusCode == 200) {
        if (data.containsKey('error')) {
          throw Exception(data['error']);
        }
        return data;
      } else {
        final errorMessage =
            data['error'] ??
            'Erro ${response.statusCode}: Falha na busca por CEP.';
        throw Exception(errorMessage);
      }
    } on SocketException {
      throw Exception('Erro de conexão com a internet.');
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> GeradorDePessoas() async {
    try {
      final uri = Uri.parse(
        "https://api.invertexto.com/v1/faker?token=${_token}&fields=name,cpf&locale=pt_BR",
      );
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data.containsKey('error')) {
          throw Exception(data['error']);
        }
        return data;
      } else {
        final data = json.decode(response.body);
        final errorMessage = data['error'] ?? 'Erro ${response.statusCode}';
        throw Exception(errorMessage);
      }
    } on SocketException {
      throw Exception('Erro de conexão com a internet.');
    } catch (e) {
      rethrow;
    }
  }
}
