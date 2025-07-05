// lib/presentation/widgets/dialogs/add_to_portfolio_dialog.dart
class AddToPortfolioDialog extends StatefulWidget {
  final InstrumentModel instrument;
  final Function(Map<String, dynamic>)? onAdd;

  const AddToPortfolioDialog({
    super.key,
    required this.instrument,
    this.onAdd,
  });

  @override
  State<AddToPortfolioDialog> createState() => _AddToPortfolioDialogState();
}

class _AddToPortfolioDialogState extends State<AddToPortfolioDialog> {
  final _formKey = GlobalKey<FormState>();
  final _quantityController = TextEditingController();
  final _priceController = TextEditingController();
  final _notesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Pre-fill with current price
    _priceController.text = widget.instrument.price.toStringAsFixed(2);
  }

  @override
  void dispose() {
    _quantityController.dispose();
    _priceController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _handleAdd() {
    if (_formKey.currentState?.validate() ?? false) {
      final quantity = double.parse(_quantityController.text);
      final price = double.parse(_priceController.text);
      
      final portfolioItem = {
        'instrumentId': widget.instrument.id,
        'symbol': widget.instrument.symbol,
        'name': widget.instrument.name,
        'quantity': quantity,
        'averageCost': price,
        'totalCost': quantity * price,
        'notes': _notesController.text.trim(),
        'purchaseDate': DateTime.now().toIso8601String(),
      };

      widget.onAdd?.call(portfolioItem);
      Navigator.of(context).pop(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AlertDialog(
      title: Text('Agregar a Portafolio'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Instrument info
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceVariant.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: colorScheme.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Center(
                        child: Text(
                          widget.instrument.symbol.substring(0, 1),
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.instrument.symbol,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            widget.instrument.name,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurface.withOpacity(0.7),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 20),
              
              // Quantity input
              TextFormField(
                controller: _quantityController,
                decoration: const InputDecoration(
                  labelText: 'Cantidad',
                  hintText: 'Ej: 10',
                  suffixText: 'acciones',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ingrese la cantidad';
                  }
                  final quantity = double.tryParse(value);
                  if (quantity == null || quantity <= 0) {
                    return 'Ingrese una cantidad válida';
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 16),
              
              // Price input
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(
                  labelText: 'Precio de Compra',
                  hintText: 'Ej: 150.00',
                  prefixText: '\$',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ingrese el precio';
                  }
                  final price = double.tryParse(value);
                  if (price == null || price <= 0) {
                    return 'Ingrese un precio válido';
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 16),
              
              // Notes input
              TextFormField(
                controller: _notesController,
                decoration: const InputDecoration(
                  labelText: 'Notas (opcional)',
                  hintText: 'Estrategia, motivo de compra, etc.',
                ),
                maxLines: 2,
                maxLength: 200,
              ),
              
              const SizedBox(height: 16),
              
              // Total calculation
              ValueListenableBuilder(
                valueListenable: _quantityController,
                builder: (context, quantityValue, child) {
                  return ValueListenableBuilder(
                    valueListenable: _priceController,
                    builder: (context, priceValue, child) {
                      final quantity = double.tryParse(quantityValue.text) ?? 0;
                      final price = double.tryParse(priceValue.text) ?? 0;
                      final total = quantity * price;
                      
                      return Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: colorScheme.primaryContainer.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Total a Invertir:',
                              style: theme.textTheme.titleMedium,
                            ),
                            Text(
                              CurrencyFormatter.format(total),
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: _handleAdd,
          child: const Text('Agregar'),
        ),
      ],
    );
  }
}