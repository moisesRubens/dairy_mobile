import 'package:dairy_mobile/services/api_service.dart';
import 'package:dairy_mobile/models/outbound_model.dart';

class OutboundService {
  final ApiService _apiService;

  OutboundService(this._apiService);

  Future<List<Outbound>> getOutbounds(int id, {DateTime? date}) async {
    String endpoint = 'auth/$id/outbounds';
    
    // Se tiver data, adiciona como query parameter
    if (date != null) {
      final formattedDate = date.toIso8601String().split('T').first;
      endpoint = 'auth/$id/outbounds?date=$formattedDate';
    }
    
    final response = await _apiService.get(endpoint);

    if (response is List) {
      return response.map((json) => Outbound.fromJson(json)).toList();
    }
    return [];
  }
}