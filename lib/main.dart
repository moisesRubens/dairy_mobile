import 'package:dairy_mobile/controllers/product_controller.dart';
import 'package:dairy_mobile/views/outbound_page.dart';
import 'package:dairy_mobile/views/product_page.dart';
import 'package:dairy_mobile/services/api_service.dart';
import 'package:dairy_mobile/services/product_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(Dairy());
}

class Dairy extends StatefulWidget {
  Dairy({super.key});

  @override
  State<Dairy> createState() => _DairyState();
}

class _DairyState extends State<Dairy> {
  int currentPageIndex = 0;  

  Widget _setPage() {
    switch(currentPageIndex) {
      case 0:
        return const Home();
      case 1:
        return Text("Pedidos");
      case 2:
        return const ProductsPageWrapper();
      case 3:
        return Text("Pontos de Venda");
      default:
        return Text("Funcionou");
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          actions: [],
          backgroundColor: Colors.white,
          shape: Border(
            bottom: BorderSide(
              color: Colors.grey,
              width: 2,
            ),
          ),
          title: Align(
            alignment: Alignment.centerLeft,
            child: Text('Fazenda Boa Esperança'),
          ),
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              const DrawerHeader(
                decoration: BoxDecoration(color: Colors.blue),
                child: Text(
                  'Decoracao qualquer',
                  style: TextStyle(color: Colors.white, fontSize: 24),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.account_circle),
                title: const Text('Perfil'),
                onTap: null
              ),
              ListTile(
                leading: const Icon(Icons.settings),
                title: const Text('Sair'),
                onTap: null
              ),
            ],
          ),
        ),
        bottomNavigationBar: NavigationBar(
          backgroundColor: Colors.white,
          onDestinationSelected: (int index) {  
            setState(() {                        
              currentPageIndex = index;
            });
          },
          indicatorColor: Colors.grey,
          selectedIndex: currentPageIndex,
          destinations: const <Widget>[
            NavigationDestination(
              selectedIcon: Icon(Icons.home),
              icon: Icon(Icons.home_outlined),
              label: 'Home',
            ),
            NavigationDestination(
              icon: Badge(child: Icon(Icons.notifications_sharp)),
              label: 'Pedidos',
            ),
            NavigationDestination(
              icon: Badge(child: Icon(Icons.messenger_sharp)),
              label: 'Produtos',
            ),
            NavigationDestination(
              icon: Badge(child: Icon(Icons.abc_sharp)),
              label: 'Pontos de Venda',
            )
          ],
        ),
        body: _setPage()
      )
    );
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  @override
  Widget build(BuildContext context) {
    return Column(
          children: [
            Padding(
              padding: EdgeInsets.all(8),
              child: DairyStatus(),
            ),
            Expanded(
              child: Outbound(),
            ),
     ],
    );
  }
}


class DairyStatus extends StatefulWidget {
  @override
  State<DairyStatus> createState() => _StateDairyStatus();
}

class _StateDairyStatus extends State<DairyStatus> {

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      child: Padding(
          padding: EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Faturamento do dia"),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Soma: "),
                  Text("Total de Pedidos: ")
                ],
              ),
            ],
          ),
        )
    );
    
  }
}

class ProductsPageWrapper extends StatelessWidget {
  const ProductsPageWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ProductController(
        productService: ProductService(ApiService()),
      )..loadProducts(),
      child: const ProductPage(), // Seu ProductPage com Consumer
    );
  }
}