import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';


// lib/presentation/widgets/common/filter_tabs.dart
class FilterTabs extends StatelessWidget {
  final String selectedFilter;
  final ValueChanged<String> onFilterChanged;
  final List<String> filters;
  final bool scrollable;
  final EdgeInsetsGeometry? padding;

  const FilterTabs({
    super.key,
    required this.selectedFilter,
    required this.onFilterChanged,
    required this.filters,
    this.scrollable = true,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      height: 40,
      padding: padding,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: filters.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final filter = filters[index];
          final isSelected = filter == selectedFilter;

          return FilterChip(
            label: Text(
              filter,
              style: theme.textTheme.labelMedium?.copyWith(
                color: isSelected 
                    ? colorScheme.onPrimary 
                    : colorScheme.onSurface.withOpacity(0.7),
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
            selected: isSelected,
            onSelected: (selected) {
              if (selected) {
                onFilterChanged(filter);
              }
            },
            backgroundColor: colorScheme.surface,
            selectedColor: colorScheme.primary,
            checkmarkColor: colorScheme.onPrimary,
            side: BorderSide(
              color: isSelected 
                  ? colorScheme.primary 
                  : colorScheme.outline.withOpacity(0.3),
            ),
            elevation: isSelected ? 2 : 0,
            pressElevation: 4,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            visualDensity: VisualDensity.compact,
          );
        },
      ),
    );
  }
}