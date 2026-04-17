import 'package:flutter/material.dart';
import 'package:dairy_mobile/services/outbound_service.dart';
import 'package:dairy_mobile/models/outbound_model.dart';
import 'package:dairy_mobile/controllers/sale_point_controller.dart';

class OutboundController extends ChangeNotifier {
  final OutboundService outboundService;
  final SalePointController salePointController;

  List<Outbound> _outbounds = [];
  bool _isLoading = false;
  String? _error;
  DateTime _selectedDate = DateTime.now();

  int _totalOrders = 0;
  double _dailyRevenue = 0;

  OutboundController({
    required this.outboundService,
    required this.salePointController,
  });

  List<Outbound> get outbounds => _outbounds;
  bool get isLoading => _isLoading;
  String? get error => _error;
  DateTime get selectedDate => _selectedDate;

  int get totalOrders => _totalOrders;
  double get dailyRevenue => _dailyRevenue;

  void registerOrder(double value) {
    _totalOrders++;
    _dailyRevenue += value;
    notifyListeners();
  }

  Future<void> loadOutbounds() async {
    final userId = salePointController.currentUser?.id;

    if (userId == null) {
      _error = 'Usuário não identificado';
      notifyListeners();
      return;
    }

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _outbounds =
          await outboundService.getOutbounds(userId, date: _selectedDate);
    } catch (e) {
      _error = e.toString();
      _outbounds = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> changeDate(DateTime newDate) async {
    _selectedDate = newDate;
    await loadOutbounds();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}