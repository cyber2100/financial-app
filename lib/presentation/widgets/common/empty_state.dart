import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';


// lib/presentation/widgets/common/empty_state.dart
class CustomEmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final String? actionText;
  final VoidCallback? onAction;
  final Widget? illustration;

  const CustomEmptyState({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.actionText,
    this.onAction,
    this.illustration,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.largePadding),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Illustration or icon
            if (illustration != null)
              illustration!
            else
              Icon(
                icon,
                size: 80,
                color: colorScheme.onSurface.withOpacity(0.3),
              ),
            
            const SizedBox(height: AppConstants.defaultPadding),
            
            // Title
            Text(
              title,
              style: theme.textTheme.headlineSmall?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            
            // Subtitle
            if (subtitle != null) ...[
              const SizedBox(height: AppConstants.smallPadding),
              Text(
                subtitle!,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurface.withOpacity(0.7),
                ),
                textAlign: TextAlign.center,
              ),
            ],
            
            // Action button
            if (actionText != null && onAction != null) ...[
              const SizedBox(height: AppConstants.largePadding),
              ElevatedButton.icon(
                onPressed: onAction,
                icon: const Icon(Icons.refresh),
                label: Text(actionText!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}