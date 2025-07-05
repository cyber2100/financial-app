// lib/presentation/widgets/dialogs/add_to_portfolio_dialog.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../data/models/instrument_model.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/utils/validators.dart';
import '../../providers/portfolio_provider.dart';

class AddToPortfolioDialog extends StatefulWidget {
  final InstrumentModel instrument;

  const AddToPortfolioDialog({
    super.key,
    required this.instrument,
  });

  @override
  State<AddToPortfolioDialog> createState() => _AddToPortfolioDialogState();
}

class _AddToPortfolioDialogState extends State<AddToPortfolioDialog>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _quantityController = TextEditingController();
  final _priceController = TextEditingController();
  final _notesController = TextEditingController();
  
  late final AnimationController _animationController;
  late final Animation<double> _scaleAnimation;
  
  bool _isLoading = false;
  bool _useCurrentPrice = true;

  @override
  void initState() {
    super.initState();
    
    // Initialize with current price
    _priceController.text = widget.instrument.price.toStringAsFixed(2);
    
    // Setup animations
    _animationController = AnimationController(
      duration: AppConstants.mediumAnimationDuration,
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutBack,
    ));
    
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _quantityController.dispose();
    _priceController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _handleAdd() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final quantity = double.parse(_quantityController.text);
      final price = double.parse(_priceController.text);
      final notes = _notesController.text.trim();

      final portfolioProvider = context.read<PortfolioProvider>();
      
      final success = await portfolioProvider.addPosition(
        instrumentId: widget.instrument.id,
        symbol: widget.instrument.symbol,
        name: widget.instrument.name,
        quantity: quantity,
        averageCost: price,
        notes: notes.isNotEmpty ? notes : null,
      );

      if (success && mounted) {
        // Show success animation
        await _animationController.reverse();
        Navigator.of(context).pop(true);
      } else if (mounted) {
        _showErrorSnackBar('Error al agregar al portafolio');
      }
    } catch (e) {
      if (mounted) {
        _showErrorSnackBar('Error: ${e.toString()}');
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).colorScheme.error,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _updatePriceFromCurrent() {
    setState(() {
      _useCurrentPrice = true;
      _priceController.text = widget.instrument.price.toStringAsFixed(2);
    });
  }

  double get _totalInvestment {
    final quantity = double.tryParse(_quantityController.text) ?? 0;
    final price = double.tryParse(_priceController.text) ?? 0;
    return quantity * price;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppConstants.borderRadius),
            ),
            child: Container(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Header
                  _buildHeader(theme, colorScheme),
                  
                  // Content
                  Flexible(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(AppConstants.defaultPadding),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            // Instrument info
                            _buildInstrumentInfo(theme, colorScheme),
                            
                            const SizedBox(height: 20),
                            
                            // Quantity input
                            _buildQuantityInput(theme, colorScheme),
                            
                            const SizedBox(height: 16),
                            
                            // Price input
                            _buildPriceInput(theme, colorScheme),
                            
                            const SizedBox(height: 16),
                            
                            // Notes input
                            _buildNotesInput(theme, colorScheme),
                            
                            const SizedBox(height: 20),
                            
                            // Total investment display
                            _buildTotalInvestment(theme, colorScheme),
                          ],
                        ),
                      ),
                    ),
                  ),
                  
                  // Actions
                  _buildActions(theme, colorScheme),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(ThemeData theme, ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      decoration: BoxDecoration(
        color: colorScheme.primary.withOpacity(0.1),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(AppConstants.borderRadius),
          topRight: Radius.circular(AppConstants.borderRadius),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.add_circle_outline,
            color: colorScheme.primary,
            size: 28,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Agregar al Portafolio',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.primary,
              ),
            ),
          ),
          IconButton(
            onPressed: () => Navigator.of(context).pop(false),
            icon: const Icon(Icons.close),
            tooltip: 'Cerrar',
          ),
        ],
      ),
    );
  }

  Widget _buildInstrumentInfo(ThemeData theme, ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colorScheme.surfaceVariant.withOpacity(0.3),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: colorScheme.outline.withOpacity(0.2),
        ),
      ),
      child: Row(
        children: [
          // Icon
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                widget.instrument.symbol.substring(0, 1),
                style: theme.textTheme.titleLarge?.copyWith(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          
          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      widget.instrument.symbol,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: _getTypeColor().withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        widget.instrument.typeDisplayName,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: _getTypeColor(),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                Text(
                  widget.instrument.name,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurface.withOpacity(0.7),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          
          // Current price
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                CurrencyFormatter.format(widget.instrument.price),
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                widget.instrument.formattedChangePercent,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: widget.instrument.isGaining ? Colors.green : Colors.red,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuantityInput(ThemeData theme, ColorScheme colorScheme) {
    return TextFormField(
      controller: _quantityController,
      decoration: InputDecoration(
        labelText: 'Cantidad',
        hintText: 'Ej: 10',
        suffixText: widget.instrument.isStock ? 'acciones' : 'unidades',
        prefixIcon: const Icon(Icons.trending_up),
      ),
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
      ],
      validator: Validators.validateQuantity,
      onChanged: (value) => setState(() {}),
    );
  }

  Widget _buildPriceInput(ThemeData theme, ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _priceController,
                decoration: InputDecoration(
                  labelText: 'Precio de Compra',
                  hintText: 'Ej: 150.00',
                  prefixText: '\$',
                  prefixIcon: const Icon(Icons.attach_money),
                ),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                ],
                validator: Validators.validatePrice,
                onChanged: (value) {
                  setState(() {
                    _useCurrentPrice = false;
                  });
                },
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              onPressed: _updatePriceFromCurrent,
              icon: Icon(
                Icons.refresh,
                color: _useCurrentPrice ? colorScheme.primary : colorScheme.onSurface.withOpacity(0.5),
              ),
              tooltip: 'Usar precio actual',
            ),
          ],
        ),
        if (!_useCurrentPrice) ...[
          const SizedBox(height: 4),
          Text(
            'Precio actual: ${CurrencyFormatter.format(widget.instrument.price)}',
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildNotesInput(ThemeData theme, ColorScheme colorScheme) {
    return TextFormField(
      controller: _notesController,
      decoration: const InputDecoration(
        labelText: 'Notas (opcional)',
        hintText: 'Estrategia, motivo de compra, etc.',
        prefixIcon: Icon(Icons.notes),
      ),
      maxLines: 2,
      maxLength: 200,
      textCapitalization: TextCapitalization.sentences,
    );
  }

  Widget _buildTotalInvestment(ThemeData theme, ColorScheme colorScheme) {
    return AnimatedContainer(
      duration: AppConstants.shortAnimationDuration,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            colorScheme.primary.withOpacity(0.1),
            colorScheme.primary.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: colorScheme.primary.withOpacity(0.3),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Inversión Total',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (_totalInvestment > 0) ...[
                const SizedBox(height: 2),
                Text(
                  '${_quantityController.text} × \$${_priceController.text}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
              ],
            ],
          ),
          Text(
            CurrencyFormatter.format(_totalInvestment),
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActions(ThemeData theme, ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(AppConstants.borderRadius),
          bottomRight: Radius.circular(AppConstants.borderRadius),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: _isLoading ? null : () => Navigator.of(context).pop(false),
              child: const Text('Cancelar'),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton(
              onPressed: _isLoading ? null : _handleAdd,
              child: _isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Agregar'),
            ),
          ),
        ],
      ),
    );
  }

  Color _getTypeColor() {
    switch (widget.instrument.type.toLowerCase()) {
      case 'stock':
        return Colors.blue;
      case 'etf':
        return Colors.green;
      case 'bond':
        return Colors.purple;
      case 'mutual_fund':
        return Colors.orange;
      case 'crypto':
        return Colors.amber;
      default:
        return Colors.grey;
    }
  }
}

/// Helper class for showing the add to portfolio dialog
class AddToPortfolioHelper {
  static Future<bool?> showAddDialog(
    BuildContext context,
    InstrumentModel instrument,
  ) async {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AddToPortfolioDialog(instrument: instrument),
    );
  }
}