// lib/core/utils/image_utils.dart
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';

class ImageUtils {
  /// Get company logo URL based on symbol
  static String getCompanyLogoUrl(String symbol, {int size = 64}) {
    // Using a free financial logo API
    return 'https://financialmodelingprep.com/image-stock/$symbol.png';
  }

  /// Get alternative logo URL
  static String getAlternativeLogoUrl(String symbol, {int size = 64}) {
    return 'https://logo.clearbit.com/${_getCompanyDomain(symbol)}?size=$size';
  }

  /// Get company domain from symbol (simplified mapping)
  static String _getCompanyDomain(String symbol) {
    const symbolToDomain = {
      'AAPL': 'apple.com',
      'GOOGL': 'google.com',
      'MSFT': 'microsoft.com',
      'TSLA': 'tesla.com',
      'AMZN': 'amazon.com',
      'META': 'meta.com',
      'NVDA': 'nvidia.com',
      'JPM': 'jpmorganchase.com',
      'JNJ': 'jnj.com',
      'V': 'visa.com',
    };
    
    return symbolToDomain[symbol.toUpperCase()] ?? 'example.com';
  }

  /// Generate placeholder avatar with initials
  static Widget generateAvatarFromInitials(
    String initials, {
    double size = 40,
    Color backgroundColor = Colors.grey,
    Color textColor = Colors.white,
  }) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: backgroundColor,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          initials.toUpperCase(),
          style: TextStyle(
            color: textColor,
            fontSize: size * 0.4,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  /// Generate colored avatar based on string
  static Widget generateColoredAvatar(
    String text, {
    double size = 40,
    Color? backgroundColor,
  }) {
    final color = backgroundColor ?? _generateColorFromString(text);
    final initials = _getInitials(text);
    
    return generateAvatarFromInitials(
      initials,
      size: size,
      backgroundColor: color,
      textColor: Colors.white,
    );
  }

  /// Generate color from string hash
  static Color _generateColorFromString(String text) {
    final hash = text.hashCode;
    final colors = [
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.red,
      Colors.teal,
      Colors.indigo,
      Colors.pink,
      Colors.cyan,
      Colors.amber,
    ];
    
    return colors[hash.abs() % colors.length];
  }

  /// Get initials from text
  static String _getInitials(String text) {
    if (text.isEmpty) return '?';
    
    final words = text.trim().split(' ');
    if (words.length == 1) {
      return words[0].substring(0, 1);
    } else {
      return words[0].substring(0, 1) + words[1].substring(0, 1);
    }
  }

  /// Validate image file
  static bool isValidImageFile(File file) {
    final extension = file.path.toLowerCase().split('.').last;
    return ['jpg', 'jpeg', 'png', 'gif', 'webp'].contains(extension);
  }

  /// Get image size
  static Future<Size?> getImageSize(File file) async {
    try {
      final bytes = await file.readAsBytes();
      final image = await decodeImageFromList(bytes);
      return Size(image.width.toDouble(), image.height.toDouble());
    } catch (e) {
      return null;
    }
  }

  /// Compress image bytes
  static Uint8List compressImage(Uint8List bytes, {int quality = 85}) {
    // In a real implementation, you would use image compression library
    // For now, return the original bytes
    return bytes;
  }

  /// Get file size in MB
  static double getFileSizeInMB(File file) {
    final bytes = file.lengthSync();
    return bytes / (1024 * 1024);
  }
}