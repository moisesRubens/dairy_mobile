import 'package:dairy_mobile/controllers/product_controller.dart';
import 'package:dairy_mobile/controllers/sale_point_controller.dart';
import 'package:dairy_mobile/controllers/outbound_controller.dart';
import 'package:dairy_mobile/views/outbound_page.dart';
import 'package:dairy_mobile/views/product_page.dart';
import 'package:dairy_mobile/views/auth_page.dart';
import 'package:dairy_mobile/services/api_service.dart';
import 'package:dairy_mobile/services/product_service.dart';
import 'package:dairy_mobile/services/sale_point_service.dart';
import 'package:dairy_mobile/services/outbound_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

// No main.dart, adicione o OutboundController nos providers

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  final prefs = await SharedPreferences.getInstance();
  final savedToken = prefs.getString('token') ?? '';
  
  final apiService = ApiService();
  if (savedToken.isNotEmpty) {
    apiService.setToken(savedToken);
  }
  
  runApp(
    MultiProvider(
      providers: [
        Provider<ApiService>.value(value: apiService),
        ChangeNotifierProvider(
          create: (_) => SalePointController(
            SalePointService(apiService),
          ),
        ),
        // Adiciona o OutboundController
        ChangeNotifierProxyProvider<SalePointController, OutboundController>(
          create: (context) => OutboundController(
            outboundService: OutboundService(apiService),
            salePointController: context.read<SalePointController>(),
          ),
          update: (context, salePointController, previous) => previous ?? OutboundController(
            outboundService: OutboundService(apiService),
            salePointController: salePointController,
          ),
        ),
      ],
      child: const DairyApp(),
    ),
  );
}

class DairyApp extends StatelessWidget {
  const DairyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final salePointController = Provider.of<SalePointController>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
      },
      // Se não estiver logado, abre login; caso contrário, abre home
      home: const AuthWrapper(),
    );
  }
}

class Dairy extends StatefulWidget {
  const Dairy({super.key});

  @override
  State<Dairy> createState() => _DairyState();
}

class _DairyState extends State<Dairy> {
  int currentPageIndex = 0;

  Widget _setPage() {
    switch (currentPageIndex) {
      case 0:
        return const Home();
      case 1:
        return const Center(child: Text("Pedidos"));
      case 2:
        return const ProductsPageWrapper();
      case 3:
        return const Center(child: Text("Pontos de Venda"));
      default:
        return const Center(child: Text("Funcionou"));
    }
  }

  @override
  Widget build(BuildContext context) {
    final salePointController =
        Provider.of<SalePointController>(context, listen: false);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        actions: [],
        backgroundColor: Colors.white,
        shape: const Border(
          bottom: BorderSide(
            color: Colors.grey,
            width: 2,
          ),
        ),
        title: const Align(
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
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Sair'),
              onTap: () async {
                await salePointController.logout();
                Navigator.pushReplacementNamed(context, '/login');
              },
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
      body: _setPage(),
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
        const Padding(
          padding: EdgeInsets.all(8),
          child: DairyStatus(),
        ),
        Expanded(
          child: OutboundPage(),
        ),
      ],
    );
  }
}

class DairyStatus extends StatefulWidget {
  const DairyStatus({super.key});

  @override
  State<DairyStatus> createState() => _StateDairyStatus();
}

class _StateDairyStatus extends State<DairyStatus> {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Faturamento do dia"),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text("Soma: "),
                Text("Total de Pedidos: ")
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ProductsPageWrapper extends StatelessWidget {
  const ProductsPageWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final apiService = Provider.of<ApiService>(context);  // ✅ Pega o mesmo ApiService
    return ChangeNotifierProvider(
      create: (context) => ProductController(
        productService: ProductService(apiService),  // ✅ Usa o mesmo com token
      )..loadProducts(),
      child: const ProductPage(),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SalePointController>(
      builder: (context, controller, _) {
        if (controller.currentUser == null) {
          return const LoginPage();
        } else {
          return const Dairy();
        }
      },
    );
  }
}

