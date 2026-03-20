import 'package:dairy_mobile/models/product_model.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    final outbound = Outbound(products: ["Doce de Leite 500g", 'Coalhada 400ml']);

    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.purpleAccent,
          title: Align(
            alignment: Alignment.centerLeft,
            child: Text('Fazenda Boa Esperança'),
          ),
        ),
        body: Column(
          children: [
            Container(
              height: 50.0,
              child: Text("FATURAMENTO DO DIA"),
            ),
            Text("PRODUTOS DE HOJE:"),
            Expanded(
              child: Container(
                color: Colors.blueGrey,
                child: ListView(
                  children: outbound.getProducts.map(
                    (product) => ListTile(
                    title: Text(product)
                    )
                  ).toList(),
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: Container(
          height: 100.0,
          child: Row(
            children: [
              Container(
                child: IconButton(onPressed: null, icon: Icon(Icons.abc_rounded, size: 70.0)),
              ),
              Container(
                child: IconButton(onPressed: null, icon: Icon(Icons.ac_unit_rounded, size: 70.0,)),
              ),
            ],
          ),
        )
      ),
    );
  }
}
