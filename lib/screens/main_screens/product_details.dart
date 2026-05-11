import 'package:flutter/material.dart';
import 'package:vibrant_commerce/components/assets/app_colors.dart';

class ProductDetails extends StatelessWidget {
  const ProductDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.tertiaryColor,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(Icons.arrow_back_ios_outlined),
                  ),
                  Text('Product Details', style: TextStyle(fontSize: 18)),
                  Row(
                    children: [
                      Icon(Icons.favorite_border),
                      const SizedBox(width: 8),
                      Icon(Icons.share),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              height: 390,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/product_image.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.all(24),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Aero-Max Runners',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text('N129', style: TextStyle(fontSize: 16)),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(Icons.star_rate, color: Color(0xff904D00)),
                              const SizedBox(width: 5),
                              Text(
                                '(124 Reviews)',
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Container(
                        width: 110,
                        height: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(99),
                          color: AppColors.primaryColor,
                        ),
                        child: Center(
                          child: Text(
                            '25% Off',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
