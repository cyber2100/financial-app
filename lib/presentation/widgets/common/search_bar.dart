// lib/presentation/widgets/common/search_bar.dart
import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';

class CustomSearchBar extends StatefulWidget {
  final String? hintText;
  final String? value;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onClear;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool enabled;
  final bool autofocus;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;

  const CustomSearchBar({
    super.key,
    this.hintText,
    this.value,
    this.onChanged,
    this.onClear,
    this.prefixIcon,
    this.suffixIcon,
    this.enabled = true,
    this.autofocus = false,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.search,
  });

  @override
  State<CustomSearchBar> createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;
  bool _hasFocus = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value);
    _focusNode = FocusNode();
    
    _focusNode.addListener(() {
      if (mounted) {
        setState(() {
          _hasFocus = _focusNode.hasFocus;
        });
      }
    });
  }

  @override
  void didUpdateWidget(CustomSearchBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value && widget.value != _controller.text) {
      _controller.text = widget.value ?? '';
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onClear() {
    _controller.clear();
    widget.onChanged?.call('');
    widget.onClear?.call();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        border: Border.all(
          color: _hasFocus 
              ? colorScheme.primary 
              : colorScheme.outline.withOpacity(0.3),
          width: _hasFocus ? 2 : 1,
        ),
        boxShadow: _hasFocus ? [
          BoxShadow(
            color: colorScheme.primary.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ] : null,
      ),
      child: TextField(
        controller: _controller,
        focusNode: _focusNode,
        enabled: widget.enabled,
        autofocus: widget.autofocus,
        keyboardType: widget.keyboardType,
        textInputAction: widget.textInputAction,
        style: theme.textTheme.bodyLarge,
        decoration: InputDecoration(
          hintText: widget.hintText ?? 'Buscar...',
          hintStyle: theme.textTheme.bodyLarge?.copyWith(
            color: colorScheme.onSurface.withOpacity(0.5),
          ),
          prefixIcon: widget.prefixIcon ?? Icon(
            Icons.search,
            color: colorScheme.onSurface.withOpacity(0.5),
          ),
          suffixIcon: _buildSuffixIcon(),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppConstants.defaultPadding,
            vertical: 12,
          ),
          isDense: true,
        ),
        onChanged: widget.onChanged,
        onTap: () {
          // Ensure cursor is at the end when tapping
          _controller.selection = TextSelection.fromPosition(
            TextPosition(offset: _controller.text.length),
          );
        },
      ),
    );
  }

  Widget? _buildSuffixIcon() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    final hasText = _controller.text.isNotEmpty;
    
    if (widget.suffixIcon != null) {
      return widget.suffixIcon;
    }
    
    if (hasText) {
      return IconButton(
        onPressed: _onClear,
        icon: Icon(
          Icons.clear,
          color: colorScheme.onSurface.withOpacity(0.5),
          size: 20,
        ),
        tooltip: 'Limpiar búsqueda',
        splashRadius: 20,
      );
    }
    
    return null;
  }
}