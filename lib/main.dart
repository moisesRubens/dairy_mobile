import 'package:dairy_mobile/models/product_model.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const Dairy());
}

class Dairy extends StatelessWidget {
  const Dairy({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: Home());
  }
}


class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}


class _HomeState extends State<Home> {
  int currentPageIndex = 0;
  String selectedPage = '';
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        actions: [
          
        ],
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
              onTap: () {
                setState(() {
                  selectedPage = 'Profile';
                });
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Sair'),
              onTap: () {
                setState(() {
                  selectedPage = 'Login';
                });
              },
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8),
            child: DairyStatus(),
          ),
          Expanded(
            child: ProductList(),
          ),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        indicatorColor: Colors.amber,
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
