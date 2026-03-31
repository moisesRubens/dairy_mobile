// product_page.dart - Mantenha apenas se precisar da tela completa
import 'package:dairy_mobile/controllers/product_controller.dart';
import 'package:dairy_mobile/main.dart';
import 'package:dairy_mobile/models/product_model.dart';
import 'package:dairy_mobile/services/api_service.dart';
import 'package:dairy_mobile/services/product_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Esta tela é usada na página de produtos do bottom navigation
class ProductList extends StatefulWidget {
  @override
  State<ProductList> createState() => _ProductsListState();
}

class _ProductsListState extends State<ProductList> {
  // Inicializar com produtos diretamente
  List<Product> products = [];

  void addProduct(String name, int id, int amount, double price) {
    setState(() {
      products.add(Product(name: name, id: id, amount: amount, price: price));
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
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red
              ),
              onPressed: () {
                removeAllOutbounds();
              },
              child: Text("Retornar ao estoque", style: TextStyle(color: Colors.white)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red
              ),
              onPressed: () {addProduct("Produto ${products.length+1}", 9, 1,1);},
              child: Text("Adicionar Produto", style: TextStyle(color: Colors.white))),
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
                    /*return ListTile(
                      title: Text(products[index].name),
                      trailing: IconButton(
                        icon: Icon(Icons.add),
                        onPressed: () => null,
                      ),
                    );*/
                    return Padding(
                      padding: EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Text(
                                products[index].name,
                                style: const TextStyle(fontSize: 16),
                              ),
                          ),
                          SizedBox(
                              width: 65,
                              child: TextField(
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Qtd',
                                  isDense: true,
                                ),
                                keyboardType: TextInputType.number,
                                controller: TextEditingController(
                                  text: null,
                                ),
                                onChanged: null,
                              ),
                            ),
                        ],
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}