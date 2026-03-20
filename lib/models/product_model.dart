
import 'dart:collection';

import 'package:flutter/material.dart';

enum UnitType {
  amount, 
  liters,
  kg
}

class Product {
  final String name;
  final double price;
  final double quantity;
  final UnitType unitType;

  const Product({required this.name,
    required this.price,
    required this.quantity, 
    required this.unitType});

}

class Outbound {
  late List<String> products;

  Outbound({required this.products});

  UnmodifiableListView<String> get getProducts => UnmodifiableListView(products);
}