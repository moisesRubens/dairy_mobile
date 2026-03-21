
import 'dart:collection';

import 'package:flutter/material.dart';

class Product {
  final String name;

  Product({required this.name});
}

class ProductList extends StatefulWidget {
  @override
  State<ProductList> createState() => _ProductsListState();
}

class _ProductsListState extends State<ProductList> {
  List<Product> products = [];

  void addProduct(String name) {
    setState(() {
      products.add(Product(name: name));
    });
  }

  void removeProduct(int index) {
    setState(() {
      products.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () {
            addProduct("Produto ${products.length + 1}");
          },
          child: Text("Adicionar Produto"),
        ),

        Expanded(
          child: ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(products[index].name),
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () => removeProduct(index),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

