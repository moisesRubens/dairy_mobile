import 'package:dairy_mobile/models/product_model.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:dairy_mobile/controllers/product_controller.dart';

class ProductPage extends StatelessWidget {
  const ProductPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductController>(
      builder: (context, controller, child) {
        if (controller.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        
        if (controller.error != null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Erro: ${controller.error}'),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => controller.loadProducts(),
                  child: const Text('Tentar novamente'),
                ),
              ],
            ),
          );
        }
        
        if (controller.products.isEmpty) {
          return const Center(
            child: Text('Nenhum produto no estoque'),
          );
        }
        
        return Stack(
          children: [
            Column(
              children: [
                // Barra de pesquisa
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Pesquisar produtos...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey[100],
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                    onChanged: (value) {
                      print('Pesquisando: $value');
                    },
                  ),
                ),
                // Grid de produtos
                Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.all(8),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 6,
                      mainAxisSpacing: 8,
                      childAspectRatio: 1.3, // Ajustado para caber o TextField
                    ),
                    itemCount: controller.products.length,
                    itemBuilder: (context, index) {
                      final product = controller.products[index];
                      return ProductCard(product: product);
                    },
                  ),
                ),
              ],
            ),
            // Botão flutuante no canto inferior direito
            Positioned(
              bottom: 16,
              right: 16,
              child: FloatingActionButton(
                onPressed: () {
                  // Aqui você vai implementar a ação de finalizar/retirar
                  print('Finalizar retirada');
                },
                child: const Icon(Icons.pan_tool),
                backgroundColor: Colors.green,
              ),
            ),
          ],
        );
      },
    );
  }
}

// ProductCard com TextField para quantidade
class ProductCard extends StatefulWidget {
  final Product product;
  
  const ProductCard({super.key, required this.product});
  
  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  final TextEditingController _quantityController = TextEditingController();
  
  @override
  void dispose() {
    _quantityController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 2.3,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Nome do produto
            Center(
              child: Text(
                widget.product.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Text(
              'R\$ ${widget.product.price.toStringAsFixed(2)}',
              style: const TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            Text(
              widget.product.quantityDisplay,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            TextField(
              controller: _quantityController,
              decoration: const InputDecoration(
                labelText: 'Quantidade',
                labelStyle: TextStyle(fontSize: 12),
                isDense: true,
                contentPadding: EdgeInsets.symmetric(horizontal: 1, vertical: 1),
              ),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                // Opcional: validar quantidade
                if (value.isNotEmpty) {
                  int qty = int.tryParse(value) ?? 0;
                  if (qty > (widget.product.amount ?? 0)) {
                    _quantityController.text = (widget.product.amount ?? 0).toString();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Quantidade maior que o estoque!'),
                        backgroundColor: Colors.red,
                        duration: Duration(seconds: 1),
                      ),
                    );
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}