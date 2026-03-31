import 'package:dairy_mobile/models/product_model.dart';
import 'package:dairy_mobile/services/api_service.dart';

class ProductService {
  final ApiService _apiService;
  
  ProductService(this._apiService);
  
  Future<List<Product>> getProducts() async {
    final response = await _apiService.get('products');
    
    if (response is List) {
      return response.map((json) => Product.fromJson(json)).toList();
    }
    return [];
  }
  
  Future<Product> getProductById(int id) async {
    final response = await _apiService.get('products/$id');
    return Product.fromJson(response);
  }
  
  Future<Product> createProduct(Product product) async {
    final response = await _apiService.post('products', product.toJson());
    return Product.fromJson(response);
  }
  
  Future<Product> updateProduct(int id, Product product) async {
    final response = await _apiService.put('products/$id', product.toJson());
    return Product.fromJson(response);
  }
  
  Future<void> deleteProduct(int id) async {
    await _apiService.delete('products/$id');
  }
}