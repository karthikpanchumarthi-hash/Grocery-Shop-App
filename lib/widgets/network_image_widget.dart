import 'package:flutter/material.dart';

/// A small reusable widget that displays a network image with
/// loading and error placeholders. If [imageUrl] is null or empty,
/// it shows an [placeholder] or an icon.
class NetworkImageWidget extends StatelessWidget {
  final String? imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Widget? placeholder;
  final Widget? errorWidget;
  final BorderRadius? borderRadius;

  const NetworkImageWidget({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.placeholder,
    this.errorWidget,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final Widget defaultPlaceholder = Container(
      width: width,
      height: height,
      color: Colors.grey[200],
      child: const Center(
        child: Icon(Icons.image_outlined, color: Colors.grey, size: 36),
      ),
    );

    final Widget defaultError = Container(
      width: width,
      height: height,
      color: Colors.grey[100],
      child: const Center(
        child: Icon(Icons.broken_image_outlined, color: Colors.grey, size: 36),
      ),
    );

    if (imageUrl == null || imageUrl!.trim().isEmpty) {
      return borderRadius != null
          ? ClipRRect(
              borderRadius: borderRadius!,
              child: placeholder ?? defaultPlaceholder)
          : (placeholder ?? defaultPlaceholder);
    }

    final image = Image.network(
      imageUrl!,
      width: width,
      height: height,
      fit: fit,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return placeholder ?? defaultPlaceholder;
      },
      errorBuilder: (context, error, stackTrace) {
        return errorWidget ?? defaultError;
      },
    );

    return borderRadius != null
        ? ClipRRect(borderRadius: borderRadius!, child: image)
        : image;
  }
}
