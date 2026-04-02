import 'package:dairy_mobile/controllers/outbound_controller.dart';
import 'package:dairy_mobile/controllers/sale_point_controller.dart';
import 'package:dairy_mobile/services/outbound_service.dart';
import 'package:dairy_mobile/services/api_service.dart';
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
      final controller = Provider.of<OutboundController>(context, listen: false);
      controller.loadOutbounds();
    });
  }

  @override
  void dispose() {
    for (var controller in _quantityControllers.values) {
      controller.dispose();
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

  String _formatQuantity(Outbound outbound) {
    final quantity = outbound.remaining_quantity?.toStringAsFixed(2) ?? '0';
    final unitType = outbound.unit_type ?? '';
    
    switch (unitType.toLowerCase()) {
      case 'kg':
        return '$quantity kg';
      case 'liters':
        return '$quantity L';
      case 'amount':
        return '$quantity un';
      default:
        return quantity;
    }
  }

  String _getUnitSymbol(Outbound outbound) {
    final unitType = outbound.unit_type ?? '';
    switch (unitType.toLowerCase()) {
      case 'kg':
        return 'kg';
      case 'liters':
        return 'L';
      case 'amount':
        return 'un';
      default:
        return '';
    }
  }

  double _calculateTotal() {
    double total = 0;
    _selectedQuantities.forEach((id, quantityStr) {
      final product = context.read<OutboundController>().outbounds.firstWhere(
        (p) => p.id == id,
        orElse: () => Outbound(id: 0),
      );
      final quantity = double.tryParse(quantityStr) ?? 0;
      total += quantity * (product.total_value_item ?? 0);
    });
    return total;
  }

  int _getTotalItems() {
    int total = 0;
    _selectedQuantities.forEach((id, quantityStr) {
      final quantity = double.tryParse(quantityStr) ?? 0;
      total += quantity.toInt();
    });
    return total;
  }

  void _submitOrder() {
    if (_selectedQuantities.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Nenhum produto selecionado'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    // TODO: Implementar envio do pedido para a API
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar Pedido'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Total de itens: ${_getTotalItems()}'),
            const SizedBox(height: 8),
            Text('Valor total: ${_formatCurrency(_calculateTotal())}'),
            const SizedBox(height: 16),
            const Text('Deseja confirmar este pedido?'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              // Limpar seleções
              for (var controller in _quantityControllers.values) {
                controller.clear();
              }
              _selectedQuantities.clear();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Pedido enviado com sucesso!'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text('Confirmar'),
          ),
        ],
      ),
    );
  }

  void _clearOrder() {
    for (var controller in _quantityControllers.values) {
      controller.clear();
    }
    _selectedQuantities.clear();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<OutboundController>(
      builder: (context, controller, child) {
        if (controller.isLoading) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Carregando produtos...'),
              ],
            ),
          );
        }

        if (controller.error != null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
                const SizedBox(height: 16),
                Text('Erro: ${controller.error}'),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => controller.loadOutbounds(),
                  child: const Text('Tentar novamente'),
                ),
              ],
            ),
          );
        }

        if (controller.outbounds.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.inventory, size: 64, color: Colors.grey[400]),
                const SizedBox(height: 16),
                Text(
                  'Nenhum produto disponível',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
            ),
          );
        }

        return Column(
          children: [
            // Card de resumo do pedido (aparece apenas se houver itens selecionados)
            if (_selectedQuantities.isNotEmpty)
              Card(
                margin: const EdgeInsets.all(16),
                color: Colors.blue[50],
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.shopping_cart, color: Colors.blue),
                          SizedBox(width: 8),
                          Text(
                            'Resumo do Pedido',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                      const Divider(),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Total de Itens:'),
                          Text(
                            '${_getTotalItems()}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Valor Total:',
                            style: TextStyle(fontSize: 16),
                          ),
                          Text(
                            _formatCurrency(_calculateTotal()),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          const SizedBox(width: 16),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: _submitOrder,
                              icon: const Icon(Icons.send),
                              label: const Text('Submeter Pedido'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

            // Tabela de produtos
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Table(
                    border: TableBorder.all(
                      color: Colors.grey[300]!,
                      width: 1,
                    ),
                    columnWidths: {
                      0: const FlexColumnWidth(3),
                      1: const FlexColumnWidth(1.5),
                      2: const FlexColumnWidth(1.5),
                      3: const FlexColumnWidth(2),
                    },
                    children: [
                      TableRow(
                        decoration: BoxDecoration(
                          color: Colors.blue[100],
                        ),
                        children: [
                          _buildHeaderCell('Produto'),
                          _buildHeaderCell('Valor', align: TextAlign.right),
                          _buildHeaderCell('Quantidade', align: TextAlign.right),
                          _buildHeaderCell('Vender', align: TextAlign.center),
                        ],
                      ),
                      ...controller.outbounds.map((outbound) {
                        final quantityController = _getController(outbound.id);
                        final maxQuantity = outbound.remaining_quantity ?? 0;
                        
                        return TableRow(
                          children: [
                            _buildDataCell(
                              Text(
                                outbound.name ?? 'Produto',
                                style: const TextStyle(fontSize: 14),
                              ),
                            ),
                            _buildDataCell(
                              Text(
                                _formatCurrency(outbound.total_value_item ?? 0),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                ),
                                textAlign: TextAlign.right,
                              ),
                              align: TextAlign.right,
                            ),
                            _buildDataCell(
                              Text(
                                _formatQuantity(outbound),
                                style: const TextStyle(fontSize: 14),
                                textAlign: TextAlign.right,
                              ),
                              align: TextAlign.right,
                            ),
                            _buildDataCell(
                              Row(
                                children: [
                                  Expanded(
                                    child: TextField(
                                      controller: quantityController,
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                        hintText: 'Qtd',
                                        isDense: true,
                                        contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        suffixText: _getUnitSymbol(outbound),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              align: TextAlign.center,
                            ),
                          ],
                        );
                      }).toList(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildHeaderCell(String text, {TextAlign align = TextAlign.left}) {
    return Container(
      padding: const EdgeInsets.all(12),
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
        textAlign: align,
      ),
    );
  }

  Widget _buildDataCell(Widget child, {TextAlign align = TextAlign.left}) {
    return Container(
      padding: const EdgeInsets.all(12),
      child: child,
    );
  }
}