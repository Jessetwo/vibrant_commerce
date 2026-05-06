import 'package:flutter/material.dart';
import 'package:vibrant_commerce/components/assets/app_colors.dart';
import 'package:vibrant_commerce/components/widgets/catergory_box.dart';
import 'package:vibrant_commerce/components/widgets/my_text_box.dart';
import 'package:vibrant_commerce/components/widgets/product_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.tertiaryColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                Stack(
                  children: [
                    Image.asset(
                      'assets/images/Hero_banner.png',
                      fit: BoxFit.cover,
                    ),
                    Positioned(
                      top: 20,
                      left: 32,
                      right: 32,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            width: 100,
                            height: 22,
                            decoration: BoxDecoration(
                              color: AppColors.primaryColor,
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: Text(
                              'LIMITED OFFER',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Season Sale up to 50% Off',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Discover the latest trends in tech and fashion.',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            width: 120,
                            height: 40,
                            decoration: BoxDecoration(
                              color: AppColors.primaryColor,
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: Text(
                              'Shop Now',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                MyTextBox(
                  hintText: 'Search Products...',
                  prefixIcon: Icons.search,
                ),

                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Categories',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'See All',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        const CatergoryBox(
                          imagePath: 'assets/images/electronics.png',
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Electronics',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),

                    Column(
                      children: [
                        const CatergoryBox(
                          imagePath: 'assets/images/fashion.png',
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Fashion',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),

                    Column(
                      children: [
                        const CatergoryBox(imagePath: 'assets/images/home.png'),
                        const SizedBox(height: 8),
                        Text(
                          'Home',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),

                    Column(
                      children: [
                        const CatergoryBox(
                          imagePath: 'assets/images/beauty.png',
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Beauty',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Trending Products',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'See All',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ProductCard(
                      title: 'Pro Sound',
                      Price: '\$299.00',
                      imagePath: 'assets/images/headphone.png',
                    ),
                    ProductCard(
                      title: 'Smart Watch',
                      Price: '\$199.00',
                      imagePath: 'assets/images/watch.png',
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ProductCard(
                      title: 'Aero-Max Runners',
                      Price: '\$120.00',
                      imagePath: 'assets/images/shoe.png',
                    ),
                    ProductCard(
                      title: 'Velvet Amber…',
                      Price: '\$75.00',
                      imagePath: 'assets/images/perfume.png',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
