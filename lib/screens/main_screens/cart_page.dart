import 'package:flutter/material.dart';
import 'package:vibrant_commerce/components/assets/app_colors.dart';
import 'package:vibrant_commerce/components/widgets/cart.dart';
import 'package:vibrant_commerce/components/widgets/my_button.dart';
import 'package:vibrant_commerce/components/widgets/my_text_box.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.tertiaryColor,

      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: SingleChildScrollView(
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
                const SizedBox(height: 24),
                Cart(
                  title: 'Velocity Nitro Pro',
                  size: 'Size: 42 | Color: Crimson',
                  imagePath: 'assets/images/shoe.png',
                  price: 'N129.00',
                ),
                const SizedBox(height: 24),
                Cart(
                  title: 'SonicHeadphones Gen 2',
                  size: 'Matte Navy | Noise Cancelling',
                  imagePath: 'assets/images/headphone.png',
                  price: 'N5000',
                ),
                const SizedBox(height: 16),
                Cart(
                  title: 'SportWatch Essential',
                  size: 'Orange Sport | 44mm',
                  imagePath: 'assets/images/watch.png',
                  price: 'N2000',
                ),
                const SizedBox(height: 16),
                MyTextBox(hintText: 'Enter Coupoun', title: 'Promo Code'),
                const SizedBox(height: 16),
                MyButton(
                  title: 'Apply',
                  onPressed: () {},
                  color: AppColors.secondaryColor,
                ),
                const SizedBox(height: 16),
                Container(
                  padding: EdgeInsets.all(16),
                  width: double.infinity,
                  height: 195,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.01),
                        blurRadius: 2,
                        offset: Offset(0, 1),
                      ),
                    ],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Subtotal',
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                          Text('N157.00', style: TextStyle(fontSize: 16)),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Shipping',
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                          Text(
                            'FREE',
                            style: TextStyle(
                              fontSize: 16,
                              color: AppColors.primaryColor,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Estimated Tax',
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                          Text('N57.00', style: TextStyle(fontSize: 16)),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Divider(thickness: 0.7),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total',
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'N314',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                MyButton(
                  title: 'Proceed to Checkout',
                  onPressed: () {},
                  color: AppColors.primaryColor,
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
