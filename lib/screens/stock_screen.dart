import 'package:flutter/material.dart';

class Product {
  int? id;
  String name;
  int quantity;
  double purchasePrice;
  double salePrice;
  String type;

  Product({
    this.id,
    required this.name,
    required this.quantity,
    required this.purchasePrice,
    required this.salePrice,
    required this.type,
  });
}

class InventoryScreen extends StatefulWidget {
  @override
  _InventoryScreenState createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  final List<Product> _products = [];
  final List<String> _productTypes = [
    'Alimentos',
    'Bebidas',
    'Congelados',
    'Outros'
  ];

  void _showProductForm([Product? existing]) {
    final isEditing = existing != null;
    final formKey = GlobalKey<FormState>();
    String name = existing?.name ?? '';
    int quantity = existing?.quantity ?? 0;
    double purchasePrice = existing?.purchasePrice ?? 0;
    String type = existing?.type ?? _productTypes.first;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(isEditing ? 'Editar Item' : 'Adicionar Item'),
        content: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  initialValue: name,
                  decoration: InputDecoration(labelText: 'Nome do Produto'),
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Informe o nome' : null,
                  onSaved: (value) => name = value!,
                ),
                SizedBox(height: 12),
                TextFormField(
                  initialValue: quantity == 0 ? '' : quantity.toString(),
                  decoration: InputDecoration(labelText: 'Quantidade'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty)
                      return 'Informe a quantidade';
                    if (int.tryParse(value) == null) return 'Número inválido';
                    return null;
                  },
                  onSaved: (value) => quantity = int.parse(value!),
                ),
                SizedBox(height: 12),
                TextFormField(
                  initialValue: purchasePrice == 0
                      ? ''
                      : purchasePrice.toStringAsFixed(2),
                  decoration:
                      InputDecoration(labelText: 'Preço de Compra (R\$)'),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  validator: (value) {
                    if (value == null || value.isEmpty)
                      return 'Informe o valor';
                    if (double.tryParse(value) == null)
                      return 'Número inválido';
                    return null;
                  },
                  onSaved: (value) => purchasePrice = double.parse(value!),
                ),
                SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: type,
                  decoration: InputDecoration(labelText: 'Categoria'),
                  items: _productTypes
                      .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                      .toList(),
                  onChanged: (value) => type = value!,
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancelar'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.amber,
              foregroundColor: Colors.black,
            ),
            onPressed: () {
              if (formKey.currentState!.validate()) {
                formKey.currentState!.save();
                final calculatedSalePrice = purchasePrice * 1.3;

                setState(() {
                  if (isEditing) {
                    existing!.name = name;
                    existing.quantity = quantity;
                    existing.purchasePrice = purchasePrice;
                    existing.salePrice = calculatedSalePrice;
                    existing.type = type;
                  } else {
                    _products.add(Product(
                      id: DateTime.now().millisecondsSinceEpoch,
                      name: name,
                      quantity: quantity,
                      purchasePrice: purchasePrice,
                      salePrice: calculatedSalePrice,
                      type: type,
                    ));
                  }
                });
                Navigator.of(context).pop();
              }
            },
            child: Text(isEditing ? 'Salvar' : 'Adicionar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final totalItems = _products.fold<int>(0, (sum, p) => sum + p.quantity);
    final totalValue = _products.fold<double>(
        0, (sum, p) => sum + p.quantity * p.purchasePrice);

    return Scaffold(
      appBar: AppBar(title: Text('Estoque de Alimentos')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Itens: $totalItems',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                Text('Valor Total: R\$ ${totalValue.toStringAsFixed(2)}',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          Expanded(
            child: _products.isEmpty
                ? Center(child: Text('Nenhum produto cadastrado'))
                : ListView.builder(
                    itemCount: _products.length,
                    itemBuilder: (_, i) {
                      final p = _products[i];
                      final total = p.quantity * p.purchasePrice;
                      return Card(
                        margin:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        child: ListTile(
                          title: Text(p.name),
                          subtitle: Text(
                              'Tipo: ${p.type} | Qtde: ${p.quantity} | Total: R\$ ${total.toStringAsFixed(2)}'),
                          trailing: Text(
                              'Venda: R\$ ${p.salePrice.toStringAsFixed(2)}'),
                          onTap: () => _showProductForm(p),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.amber,
        foregroundColor: Colors.black,
        onPressed: () => _showProductForm(),
        child: Icon(Icons.add),
        tooltip: 'Adicionar Item',
      ),
    );
  }
}
