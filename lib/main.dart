import 'package:dairy_mobile/models/product_model.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Align(
            alignment: Alignment.centerLeft,
            child: Text('Fazenda Boa Esperança'),
          ),
        ),
        body: Center(
          child: ProductsList(),
        ),
      ),
    );
  }
}

class ProductsList extends StatelessWidget {
  const ProductsList({super.key});

  final List<Product> products = const [
    Product(
      name: 'Leite Pasteurizado',
      price: 4.99,
      quantity: 1.0,
      unitType: UnitType.liters,
    ),
    Product(
      name: 'Queijo Minas',
      price: 29.90,
      quantity: 1.0,
      unitType: UnitType.kg,
    ),
    Product(
      name: 'Iogurte Natural',
      price: 3.49,
      quantity: 1.0,
      unitType: UnitType.amount,
    ),
    Product(
      name: 'Manteiga',
      price: 12.90,
      quantity: 500,
      unitType: UnitType.amount,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          for(var product in products)
            Row(
              children: [
                Text(product.name),
                Text('${product.unitType}'),
                Text('${product.quantity}'),
                Text('${product.price}'),
              ],
            ),
        ],
      ),
    );
  }
}
