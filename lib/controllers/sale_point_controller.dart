import 'package:flutter/foundation.dart';
import 'package:dairy_mobile/models/sale_point_model.dart';
import 'package:dairy_mobile/services/sale_point_service.dart';

class SalePointController extends ChangeNotifier {
  final SalePointService service;

  SalePoint? _currentUser;
  bool _loading = false;
  String? _error;

  SalePointController(this.service);

  SalePoint? get currentUser => _currentUser;
  bool get loading => _loading;
  String? get error => _error;

  Future<bool> login(String username, String password) async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      final user = await service.login(username, password);
      if (user != null) {
        _currentUser = user;
        _loading = false;
        notifyListeners();
        return true;
      } else {
        _error = 'Usuário ou senha incorretos';
      }
    } catch (e) {
      _error = 'Erro ao logar: $e';
    }

    _loading = false;
    notifyListeners();
    return false;
  }

  Future<bool> register(SalePoint user) async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      final success = await service.register(user);
      if (!success) _error = 'Falha ao cadastrar';
      _loading = false;
      notifyListeners();
      return success;
    } catch (e) {
      _error = 'Erro ao cadastrar: $e';
    }

    _loading = false;
    notifyListeners();
    return false;
  }

  Future<void> logout() async {
    await service.logout();
    _currentUser = null;
    notifyListeners();
  }
}