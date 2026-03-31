import 'package:flutter/material.dart';

class Product {
  /*id: int
    name: str
    price: float
    amount: float | None = None
    kg: float | None = None
    liters: float | None = None*/
  int id;
  String name;
  double price;
  int? amount;
  double? kg;
  double? liters;  
  
  Product({required this.name, required this.id, required this.price, this.amount, this.kg, this.liters});

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as int,
      name: json['name'] as String,
      price: (json['price'] as num).toDouble(), 
      amount: json['amount'] as int?,          
      kg: json['kg'] != null 
          ? (json['kg'] as num).toDouble() 
          : null,
      liters: json['liters'] != null 
          ? (json['liters'] as num).toDouble() 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'amount': amount,
      'kg': kg,
      'liters': liters,
    };
  }
  
  bool get hasAmount => amount != null && amount! > 0;
  
  String get quantityDisplay {
    if (kg != null && kg! > 0) return '${kg}kg';
    if (liters != null && liters! > 0) return '${liters}L';
    if (amount != null && amount! > 0) return '${amount} unidade(s)';
    return 'Sem estoque';
  }
}
