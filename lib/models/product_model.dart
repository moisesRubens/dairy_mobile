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
  // Inicializar com produtos diretamente
  List<Product> products = [
    Product(name: "Doce de Leite"),
  ];

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

  void removeAllOutbounds() {
    setState(() {
      products.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ElevatedButton(
              onPressed: () {
                removeAllOutbounds();
              },
              child: Text("Retornar ao estoque"),
            ),
            ElevatedButton(
              onPressed: () {addProduct("Produto ${products.length+1}");},
              child: Text("Adicionar Produto")),
          ],
        ),
        Expanded(
          child: products.isEmpty
              ? Center(
                  child: Text("Nenhum produto disponível para a venda"),
                )
              : ListView.builder(
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    return Container(
                      padding: EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Expanded(
                              flex: 2,
                              child: Text(
                                products[index].name,
                                style: TextStyle(fontSize: 16),
                              ),
                          ),
                          SizedBox(
                              width: 80,
                              child: TextField(
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Qtd',
                                  isDense: true,
                                ),
                                keyboardType: TextInputType.number,
                                controller: TextEditingController(
                                  text: null,
                                ),
                                onChanged: null
                              ),
                          ),
                        ],
                        )
                    );
                  },
                ),
        ),
      ],
    );
  }
}




