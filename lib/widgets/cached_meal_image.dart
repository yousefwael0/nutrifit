import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

/// Reusable cached image widget with fallback
class CachedMealImage extends StatelessWidget {
  final String? imageUrl;
  final double height;
  final IconData fallbackIcon;
  final Color? fallbackColor;
  final BorderRadius? borderRadius;

  const CachedMealImage({
    super.key,
    required this.imageUrl,
    required this.height,
    this.fallbackIcon = Icons.restaurant,
    this.fallbackColor,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final color = fallbackColor ?? Colors.orange;

    // Fallback if no URL provided
    if (imageUrl == null || imageUrl!.isEmpty) {
      return _buildFallback(color);
    }

    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.zero,
      child: CachedNetworkImage(
        imageUrl: imageUrl!,
        height: height,
        width: double.infinity,
        fit: BoxFit.cover,

        // ✅ Smooth fade-in animation
        fadeInDuration: const Duration(milliseconds: 300),
        fadeOutDuration: const Duration(milliseconds: 100),

        // ✅ Gradient placeholder while loading
        placeholder: (context, url) => _buildPlaceholder(color),

        // ✅ Graceful fallback if image fails
        errorWidget: (context, url, error) => _buildFallback(color),

        // ✅ Automatic disk cache (works offline after first load!)
        memCacheHeight: 400,
        memCacheWidth: 600,
      ),
    );
  }

  /// Build gradient placeholder
  Widget _buildPlaceholder(Color color) {
    return Container(
      height: height,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            color.withValues(alpha: 0.3),
            color.withValues(alpha: 0.1),
          ],
        ),
      ),
      child: Center(
        child: CircularProgressIndicator(
          color: color.withValues(alpha: 0.5),
          strokeWidth: 2,
        ),
      ),
    );
  }

  /// Build fallback icon view
  Widget _buildFallback(Color color) {
    return Container(
      height: height,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            color.withValues(alpha: 0.2),
            color.withValues(alpha: 0.05),
          ],
        ),
      ),
      child: Icon(
        fallbackIcon,
        size: height * 0.4,
        color: color.withValues(alpha: 0.5),
      ),
    );
  }
}
