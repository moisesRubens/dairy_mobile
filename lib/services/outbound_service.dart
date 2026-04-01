import 'package:dairy_mobile/services/api_service.dart';
import 'package:dairy_mobile/models/outbound_model.dart';

class OutboundService {
  final ApiService _apiService;

  OutboundService(this._apiService);

  Future<List<Outbound>> getOutbounds(int id) async {
    final response = await _apiService.get('auth/$id/outbounds');

    if(response is List) {
      return response.map((json) => Outbound.fromJson(json)).toList();
    }
    return [];
  }


}