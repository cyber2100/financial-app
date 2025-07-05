// lib/presentation/pages/settings/settings_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_constants.dart';
import '../../providers/theme_provider.dart';
import '../../providers/user_provider.dart';
import '../../widgets/common/loading_indicator.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.background,
      appBar: AppBar(
        title: const Text('Configuración'),
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User profile section
            _buildUserProfileSection(theme, colorScheme),
            
            const SizedBox(height: AppConstants.largePadding),
            
            // Appearance section
            _buildAppearanceSection(theme, colorScheme),
            
            const SizedBox(height: AppConstants.largePadding),
            
            // Notifications section
            _buildNotificationsSection(theme, colorScheme),
            
            const SizedBox(height: AppConstants.largePadding),
            
            // Data & Privacy section
            _buildDataPrivacySection(theme, colorScheme),
            
            const SizedBox(height: AppConstants.largePadding),
            
            // About section
            _buildAboutSection(theme, colorScheme),
            
            const SizedBox(height: AppConstants.largePadding),
          ],
        ),
      ),
    );
  }

  Widget _buildUserProfileSection(ThemeData theme, ColorScheme colorScheme) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(AppConstants.defaultPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Perfil de Usuario',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: colorScheme.primary,
                      child: Icon(
                        Icons.person,
                        size: 30,
                        color: colorScheme.onPrimary,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Usuario Demo',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            'demo@financialapp.com',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: colorScheme.onSurface.withOpacity(0.7),
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => _editProfile(context),
                      icon: const Icon(Icons.edit_outlined),
                      tooltip: 'Editar perfil',
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAppearanceSection(ThemeData theme, ColorScheme colorScheme) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Apariencia',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Consumer<ThemeProvider>(
              builder: (context, themeProvider, child) {
                return Column(
                  children: [
                    _buildThemeOption(
                      'Sistema',
                      'Seguir configuración del sistema',
                      Icons.settings_brightness,
                      ThemeMode.system,
                      themeProvider,
                      theme,
                      colorScheme,
                    ),
                    _buildThemeOption(
                      'Claro',
                      'Tema claro',
                      Icons.light_mode,
                      ThemeMode.light,
                      themeProvider,
                      theme,
                      colorScheme,
                    ),
                    _buildThemeOption(
                      'Oscuro',
                      'Tema oscuro',
                      Icons.dark_mode,
                      ThemeMode.dark,
                      themeProvider,
                      theme,
                      colorScheme,
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThemeOption(
    String title,
    String subtitle,
    IconData icon,
    ThemeMode mode,
    ThemeProvider themeProvider,
    ThemeData theme,
    ColorScheme colorScheme,
  ) {
    final isSelected = themeProvider.themeMode == mode;
    
    return RadioListTile<ThemeMode>(
      value: mode,
      groupValue: themeProvider.themeMode,
      onChanged: (ThemeMode? value) {
        if (value != null) {
          themeProvider.updateThemeMode(value);
        }
      },
      title: Row(
        children: [
          Icon(
            icon,
            color: isSelected ? colorScheme.primary : colorScheme.onSurface.withOpacity(0.6),
          ),
          const SizedBox(width: 12),
          Text(title),
        ],
      ),
      subtitle: Text(subtitle),
      contentPadding: EdgeInsets.zero,
    );
  }

  Widget _buildNotificationsSection(ThemeData theme, ColorScheme colorScheme) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Notificaciones',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildSwitchTile(
              'Alertas de Precios',
              'Recibir notificaciones cuando los precios cambien',
              Icons.notifications_outlined,
              true,
              (value) {
                // Handle price alerts toggle
              },
              theme,
              colorScheme,
            ),
            _buildSwitchTile(
              'Actualizaciones de Portafolio',
              'Resumen diario de tu portafolio',
              Icons.pie_chart_outline,
              true,
              (value) {
                // Handle portfolio updates toggle
              },
              theme,
              colorScheme,
            ),
            _buildSwitchTile(
              'Noticias del Mercado',
              'Noticias y análisis financieros',
              Icons.article_outlined,
              false,
              (value) {
                // Handle market news toggle
              },
              theme,
              colorScheme,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchTile(
    String title,
    String subtitle,
    IconData icon,
    bool value,
    ValueChanged<bool> onChanged,
    ThemeData theme,
    ColorScheme colorScheme,
  ) {
    return SwitchListTile(
      value: value,
      onChanged: onChanged,
      title: Row(
        children: [
          Icon(
            icon,
            color: colorScheme.onSurface.withOpacity(0.6),
          ),
          const SizedBox(width: 12),
          Text(title),
        ],
      ),
      subtitle: Text(subtitle),
      contentPadding: EdgeInsets.zero,
    );
  }

  Widget _buildDataPrivacySection(ThemeData theme, ColorScheme colorScheme) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Datos y Privacidad',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildActionTile(
              'Exportar Datos',
              'Descargar tus datos del portafolio',
              Icons.download_outlined,
              () => _exportData(colorScheme),
              theme,
              colorScheme,
            ),
            _buildActionTile(
              'Limpiar Caché',
              'Borrar datos almacenados localmente',
              Icons.cleaning_services_outlined,
              () => _clearCache(colorScheme),
              theme,
              colorScheme,
            ),
            _buildActionTile(
              'Política de Privacidad',
              'Ver nuestra política de privacidad',
              Icons.privacy_tip_outlined,
              () => _showPrivacyPolicy(colorScheme),
              theme,
              colorScheme,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAboutSection(ThemeData theme, ColorScheme colorScheme) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Acerca de',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildActionTile(
              'Versión',
              AppConstants.appVersion,
              Icons.info_outline,
              null,
              theme,
              colorScheme,
            ),
            _buildActionTile(
              'Ayuda y Soporte',
              'Obtener ayuda o reportar problemas',
              Icons.help_outline,
              () => _showHelp(colorScheme),
              theme,
              colorScheme,
            ),
            _buildActionTile(
              'Calificar App',
              'Califica nuestra app en la tienda',
              Icons.star_outline,
              () => _rateApp(colorScheme),
              theme,
              colorScheme,
            ),
            _buildActionTile(
              'Términos de Servicio',
              'Leer términos y condiciones',
              Icons.description_outlined,
              () => _showTerms(colorScheme),
              theme,
              colorScheme,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionTile(
    String title,
    String subtitle,
    IconData icon,
    VoidCallback? onTap,
    ThemeData theme,
    ColorScheme colorScheme,
  ) {
    return ListTile(
      leading: Icon(
        icon,
        color: colorScheme.onSurface.withOpacity(0.6),
      ),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: onTap != null ? const Icon(Icons.chevron_right) : null,
      onTap: onTap,
      contentPadding: EdgeInsets.zero,
    );
  }

  // Action methods
  void _editProfile(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Editar Perfil'),
        content: const Text('Funcionalidad de edición de perfil en desarrollo'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  void _exportData(ColorScheme colorScheme) {
    // Implementation for data export
    debugPrint('Export data functionality');
  }

  void _clearCache(ColorScheme colorScheme) {
    // Implementation for clearing cache
    debugPrint('Clear cache functionality');
  }

  void _showPrivacyPolicy(ColorScheme colorScheme) {
    // Implementation for showing privacy policy
    debugPrint('Show privacy policy');
  }

  void _showHelp(ColorScheme colorScheme) {
    // Implementation for showing help
    debugPrint('Show help');
  }

  void _rateApp(ColorScheme colorScheme) {
    // Implementation for rating app
    debugPrint('Rate app');
  }

  void _showTerms(ColorScheme colorScheme) {
    // Implementation for showing terms
    debugPrint('Show terms');
  }
}