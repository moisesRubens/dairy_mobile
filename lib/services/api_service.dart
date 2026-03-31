import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

class ApiService {
  static String get baseUrl {
    if (kIsWeb) {
      return 'http://localhost:8000';
    }
    // Para Android Emulator
    if (defaultTargetPlatform == TargetPlatform.android) {
      return 'http://10.0.2.2:8000';
    }
    // Para iOS Simulator ou macOS
    return 'http://localhost:8000';
  }

  final http.Client client;
  
  ApiService({http.Client? client}) : client = client ?? http.Client();
  
  Future<dynamic> get(String endpoint) async {
    final response = await client.get(
      Uri.parse('$baseUrl/$endpoint'),
      headers: _headers(),
    );
    return _handleResponse(response);
  }
  
  Future<dynamic> post(String endpoint, Map<String, dynamic> data) async {
    final response = await client.post(
      Uri.parse('$baseUrl/$endpoint'),
      headers: _headers(),
      body: jsonEncode(data),
    );
    return _handleResponse(response);
  }
  
  Future<dynamic> put(String endpoint, Map<String, dynamic> data) async {
    final response = await client.put(
      Uri.parse('$baseUrl/$endpoint'),
      headers: _headers(),
      body: jsonEncode(data),
    );
    return _handleResponse(response);
  }
  
  Future<dynamic> delete(String endpoint) async {
    final response = await client.delete(
      Uri.parse('$baseUrl/$endpoint'),
      headers: _headers(),
    );
    return _handleResponse(response);
  }
  
  // Método para fechar o client quando não for mais necessário
  void dispose() {
    client.close();
  }
  
  Map<String, String> _headers() {
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
  }
  
  dynamic _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) {
        return null;
      }
      return jsonDecode(response.body);
    } else {
      throw Exception('Erro na requisição: ${response.statusCode} - ${response.body}');
    }
  }
}