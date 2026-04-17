import 'package:dairy_mobile/controllers/outbound_controller.dart';
import 'package:dairy_mobile/controllers/product_controller.dart';
import 'package:dairy_mobile/models/outbound_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OutboundPage extends StatefulWidget {
  const OutboundPage({super.key});

  @override
  State<OutboundPage> createState() => _OutboundPageState();
}

class _OutboundPageState extends State<OutboundPage> {
  final Map<int, TextEditingController> _quantityControllers = {};
  final Map<int, String> _selectedQuantities = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<OutboundController>().loadOutbounds();
    });
  }

  @override
  void dispose() {
    for (var c in _quantityControllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  TextEditingController _getController(int id) {
    if (!_quantityControllers.containsKey(id)) {
      _quantityControllers[id] = TextEditingController();
      _quantityControllers[id]!.addListener(() {
        setState(() {
          if (_quantityControllers[id]!.text.isNotEmpty) {
            _selectedQuantities[id] = _quantityControllers[id]!.text;
          } else {
            _selectedQuantities.remove(id);
          }
        });
      });
    }
    return _quantityControllers[id]!;
  }

  String _formatCurrency(double value) {
    return 'R\$ ${value.toStringAsFixed(2)}';
  }

  double _calculateTotal(Map<int, dynamic> productMap) {
    double total = 0;

    final outbounds = context.read<OutboundController>().outbounds;

    _selectedQuantities.forEach((outboundId, quantityStr) {
      final outbound = outbounds.firstWhere(
        (o) => o.id == outboundId,
        orElse: () => Outbound(id: 0, product_id: 0),
      );

      final product = productMap[outbound.product_id];
      final price = product?.price ?? 0;

      final quantity = double.tryParse(quantityStr) ?? 0;
      total += quantity * price;
    });

    return total;
  }

  int _getTotalItems() {
    int total = 0;

    _selectedQuantities.forEach((_, quantityStr) {
      final quantity = double.tryParse(quantityStr) ?? 0;
      total += quantity.toInt();
    });

    return total;
  }

  void _submitOrder(Map<int, dynamic> productMap) {
    if (_selectedQuantities.isEmpty) return;

    final total = _calculateTotal(productMap);

    context.read<OutboundController>().registerOrder(total);

    for (var c in _quantityControllers.values) {
      c.clear();
    }

    _selectedQuantities.clear();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final outboundController = context.watch<OutboundController>();
    final productController = context.watch<ProductController>();

    final productMap = {
      for (var p in productController.products) p.id: p
    };

    if (productController.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (outboundController.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      children: [
        if (_selectedQuantities.isNotEmpty)
          Card(
            margin: const EdgeInsets.all(16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Text('Itens: ${_getTotalItems()}'),
                  Text(
                    _formatCurrency(_calculateTotal(productMap)),
                  ),
                  ElevatedButton(
                    onPressed: () => _submitOrder(productMap),
                    child: const Text('Confirmar'),
                  ),
                ],
              ),
            ),
          ),

        Expanded(
          child: ListView(
            children: outboundController.outbounds.map((outbound) {
              final product = productMap[outbound.product_id];
              final price = product?.price ?? 0;

              return ListTile(
                title: Text(outbound.name ?? ''),
                subtitle: Text(_formatCurrency(price)),
                trailing: SizedBox(
                  width: 80,
                  child: TextField(
                    controller: _getController(outbound.id),
                    keyboardType: TextInputType.number,
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}