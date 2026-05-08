import 'package:flutter/material.dart';
import 'package:vibrant_commerce/components/assets/app_colors.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.tertiaryColor,

      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Your Shopping Cart',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              Text(
                'You have 3 items in your cart',
                style: TextStyle(fontSize: 16, color: Color(0xff757682)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
