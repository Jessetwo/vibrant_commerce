import 'package:flutter/material.dart';
import 'package:vibrant_commerce/components/assets/app_colors.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.tertiaryColor,
      appBar: AppBar(
        title: const Text('My Cart'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: AppColors.neutralColor,
      ),
      body: const Center(
        child: Text('Cart Page Placeholder'),
      ),
    );
  }
}
