import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:dairy_mobile/models/sale_point_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'api_service.dart';

class SalePointService {
  final ApiService api;

  SalePointService(this.api);

  /// Faz login usando form-urlencoded, compatível com FastAPI OAuth2PasswordRequestForm
  Future<SalePoint?> login(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiService.baseUrl}/auth/login'),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          'Accept': 'application/json',
        },
        body: {
          'username': username,
          'password': password,
        },
      );

      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw Exception('Erro na requisição: ${response.statusCode} - ${response.body}');
      }

      final data = jsonDecode(response.body);
      final token = data['access_token'];
      if (token == null) return null;

      // Salva token no ApiService
      api.setToken(token);

      // Salva token no SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token);

      // Decodifica token para pegar userId
      final payload = Jwt.parseJwt(token);
      final userId = int.parse(payload['sub']);

      // Busca dados do usuário na API
      final userResponse = await api.get('auth/$userId');

      return SalePoint(
        id: userId,
        name: username, // ou userResponse['name'] se disponível
        email: userResponse['email'],
        password: null, // nunca armazene senha em produção
      );
    } catch (e) {
      print('Erro no login: $e');
      return null;
    }
  }

  Future<bool> register(SalePoint user) async {
    try {
      await api.post('auth', user.toJson());
      return true;
    } catch (e) {
      print('Erro no cadastro: $e');
      return false;
    }
  }

  /// Logout: remove token e limpa ApiService
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token != null) {
      try {
        await api.post('auth/logout', {});
      } catch (e) {
        print('Erro ao fazer logout na API: $e');
      }
    }

    api.setToken(''); // limpa token do ApiService
    await prefs.remove('token');
  }
}