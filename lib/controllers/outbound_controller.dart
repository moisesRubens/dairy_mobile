import 'package:flutter/material.dart';
import 'package:dairy_mobile/services/outbound_service.dart';
import 'package:dairy_mobile/models/outbound_model.dart';

class OutboundController extends ChangeNotifier {
  final OutboundService outboundService;
  List<Outbound> _outbounds = [];
  bool _isLoading = false;
  String? _error;

  OutboundController({required this.outboundService});

  List<Outbound> get outbounds {
    return _outbounds;
  }

  bool get isLoading {
    return _isLoading;
  }

  String? get error {
    return _error;
  }

  Future<void> loadOutbounds(int id) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    try {
      _outbounds = await outboundService.getOutbounds(id);
    } catch(e) {
      _error =  e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}