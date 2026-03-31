import 'package:dairy_mobile/models/product_model.dart';
import 'package:dairy_mobile/services/product_service.dart';
import 'package:flutter/material.dart';

class ProductController extends ChangeNotifier {
  final ProductService productService;
  
  ProductController({required this.productService});
  
  List<Product> _products = [];
  bool _isLoading = false;
  String? _error;
  
  List<Product> get products => _products;
  bool get isLoading => _isLoading;
  String? get error => _error;
  
  List<Product> get productsInStock {
    return _products.where((p) => p.hasAmount).toList();
  }
  
  Future<void> loadProducts() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    try {
      _products = await productService.getProducts();
    } catch (e) {
      _error = e.toString();
      print('Erro ao carregar produtos: $e'); // Para debug
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  Future<bool> addProduct(Product product) async {
    _isLoading = true;
    notifyListeners();
    
    try {
      final newProduct = await productService.createProduct(product);
      _products.add(newProduct);
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      print('Erro ao adicionar produto: $e'); // Para debug
      notifyListeners();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  Future<bool> updateProduct(int id, Product product) async {
    _isLoading = true;
    notifyListeners();
    
    try {
      final updatedProduct = await productService.updateProduct(id, product);
      final index = _products.indexWhere((p) => p.id == id);
      if (index != -1) {
        _products[index] = updatedProduct;
      }
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      print('Erro ao atualizar produto: $e'); // Para debug
      notifyListeners();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  Future<bool> deleteProduct(int id) async {
    _isLoading = true;
    notifyListeners();
    
    try {
      await productService.deleteProduct(id);
      _products.removeWhere((p) => p.id == id);
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      print('Erro ao deletar produto: $e'); // Para debug
      notifyListeners();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  // Método para limpar recursos
  void dispose() {
    // Se o ProductService tiver um método dispose, chame aqui
    super.dispose();
  }
}