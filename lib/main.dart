import 'package:dairy_mobile/models/product_model.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const Dairy());
}

class Dairy extends StatelessWidget {
  const Dairy({super.key});

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          shape: Border(
            bottom: BorderSide(
              color: Colors.grey,
               width: 2,
            ),
          ),
          backgroundColor: Colors.white,
          title: Align(
            alignment: Alignment.centerLeft,
            child: Text('Fazenda Boa Esperança'),
          ),
        ),
        body: Column(
          children: [
            DairyStatus(),
            Expanded(
              child: ProductList(),
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

class DairyStatus extends StatefulWidget {
  final String name = 'Faturamento do Dia: ';

  @override
  State<DairyStatus> createState() => _StateDairyStatus();
}

class _StateDairyStatus extends State<DairyStatus> {

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.name),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Soma: "),
              Text("Total de Pedidos: ")
            ],
          ),
        ],
      ),
    ); 
  }
}
