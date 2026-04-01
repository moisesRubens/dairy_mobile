import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dairy_mobile/controllers/sale_point_controller.dart';
import 'package:dairy_mobile/models/sale_point_model.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Consumer<SalePointController>(
      builder: (context, controller, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Login'),
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            elevation: 1,
          ),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                  controller: _usernameController,
                  decoration: const InputDecoration(labelText: 'Usuário'),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(labelText: 'Senha'),
                ),
                const SizedBox(height: 24),
                if (controller.loading) const CircularProgressIndicator(),
                if (controller.error != null)
                  Text(
                    controller.error!,
                    style: const TextStyle(color: Colors.red),
                  ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: controller.loading
                      ? null
                      : () async {
                          bool success = await controller.login(
                            _usernameController.text,
                            _passwordController.text,
                          );
                          if (success) {
                            // Se login bem-sucedido, retorna para Home
                            Navigator.pop(context);
                          }
                        },
                  child: const Text('Entrar'),
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/register');
                  },
                  child: const Text('Não tem conta? Cadastre-se'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Consumer<SalePointController>(
      builder: (context, controller, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Cadastro'),
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            elevation: 1,
          ),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                  controller: _usernameController,
                  decoration: const InputDecoration(labelText: 'Usuário'),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(labelText: 'Senha'),
                ),
                const SizedBox(height: 24),
                if (controller.loading) const CircularProgressIndicator(),
                if (controller.error != null)
                  Text(
                    controller.error!,
                    style: const TextStyle(color: Colors.red),
                  ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: controller.loading
                      ? null
                      : () async {
                          final user = SalePoint(
                            id: 0,
                            name: _usernameController.text,
                            email: _emailController.text,
                            password: _passwordController.text,
                          );
                          bool success = await controller.register(user);
                          if (success) {
                            Navigator.pop(context); // volta para login
                          }
                        },
                  child: const Text('Cadastrar'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}