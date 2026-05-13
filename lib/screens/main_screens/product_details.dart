import 'package:flutter/material.dart';
import 'package:vibrant_commerce/components/assets/app_colors.dart';
import 'package:vibrant_commerce/components/widgets/testimonial.dart';

class ProductDetails extends StatelessWidget {
  const ProductDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.tertiaryColor,
      body: SafeArea(
        child: SingleChildScrollView(
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
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                Icon(Icons.star_rate, color: Color(0xff904D00)),
                                Icon(Icons.star_rate, color: Color(0xff904D00)),
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
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Text('Description', style: TextStyle(fontSize: 16)),
                    const SizedBox(height: 16),
                    Text(
                      '''Experience the ultimate in kinetic energy return. The Stratos Flow features our proprietary nitrogen-infused foam core and an ultra-breathable mesh upper, designed for professional marathons and high-intensity urban training.''',
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black),
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: Center(
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(100),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: Color(0xff0F172A),
                            borderRadius: BorderRadius.circular(100),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: Color(0xff1D4ED8),
                            borderRadius: BorderRadius.circular(100),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('SELECT SIZE', style: TextStyle(fontSize: 16)),
                        Text('Size Guide', style: TextStyle(fontSize: 16)),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 80,
                          height: 48,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Color(0xffC5C6D2)),
                          ),
                          child: Center(
                            child: Text('7', style: TextStyle(fontSize: 16)),
                          ),
                        ),
                        Container(
                          width: 80,
                          height: 48,
                          decoration: BoxDecoration(
                            color: Color(0xffDBE1FF),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Color(0xff00113A),
                              width: 2,
                            ),
                          ),
                          child: Center(
                            child: Text('8', style: TextStyle(fontSize: 16)),
                          ),
                        ),
                        Container(
                          width: 80,
                          height: 48,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Color(0xffC5C6D2)),
                          ),
                          child: Center(
                            child: Text('9', style: TextStyle(fontSize: 16)),
                          ),
                        ),
                        Container(
                          width: 80,
                          height: 48,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Color(0xffC5C6D2)),
                          ),
                          child: Center(
                            child: Text('10', style: TextStyle(fontSize: 16)),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Container(
                          width: 80,
                          height: 48,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Color(0xffC5C6D2)),
                          ),
                          child: Center(
                            child: Text('9', style: TextStyle(fontSize: 16)),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Container(
                          width: 80,
                          height: 48,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Color(0xffC5C6D2)),
                          ),
                          child: Center(
                            child: Text('10', style: TextStyle(fontSize: 16)),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Divider(),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Reviews',
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xff00113A),
                          ),
                        ),

                        Text(
                          'View All',
                          style: TextStyle(
                            fontSize: 16,
                            color: AppColors.primaryColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Testimonial(
                      name: 'Marcus J',
                      text:
                          '"Best running shoes I\'ve owned. The energy return is noticeable from the first mile."',
                      imagePath: 'assets/images/shoe.png',
                    ),

                    const SizedBox(height: 16),
                    Testimonial(
                      name: 'Sarah K',
                      text:
                          '"Incredible breathability for summer runs. True to size and looks fantastic in person!"',
                      imagePath: 'assets/images/watch.png',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
