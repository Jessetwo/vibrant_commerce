import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:vibrant_commerce/components/assets/category_images.dart';

class ProductImage extends StatelessWidget {
  final String imagePath;
  final String category;
  final BoxFit fit;
  final double? width;
  final double? height;

  const ProductImage({
    super.key,
    required this.imagePath,
    this.category = '',
    this.fit = BoxFit.cover,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final fallbackImage = categoryFallbackImage(category);

    final placeholderWidget = Image.asset(
      fallbackImage,
      fit: fit,
      width: width,
      height: height,
    );

    if (imagePath.isEmpty) {
      return placeholderWidget;
    }

    // 1. Support Base64 Data URIs (e.g. data:image/jpeg;base64,...)
    if (imagePath.startsWith('data:image/') && imagePath.contains(';base64,')) {
      try {
        final base64String = imagePath.split(';base64,').last;
        final Uint8List bytes = base64Decode(base64String);
        return Image.memory(
          bytes,
          fit: fit,
          width: width,
          height: height,
          errorBuilder: (_, __, ___) => placeholderWidget,
        );
      } catch (e) {
        return placeholderWidget;
      }
    }

    // 2. Support network URLs
    if (imagePath.startsWith('http://') || imagePath.startsWith('https://')) {
      return Image.network(
        imagePath,
        fit: fit,
        width: width,
        height: height,
        errorBuilder: (_, __, ___) => placeholderWidget,
      );
    }

    // 3. Support local assets
    if (imagePath.startsWith('assets/')) {
      return Image.asset(
        imagePath,
        fit: fit,
        width: width,
        height: height,
        errorBuilder: (_, __, ___) => placeholderWidget,
      );
    }

    return placeholderWidget;
  }
}
