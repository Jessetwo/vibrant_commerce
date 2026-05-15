import 'package:flutter/material.dart';
import 'package:vibrant_commerce/components/assets/app_colors.dart';

class CheckOutPage extends StatelessWidget {
  const CheckOutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.tertiaryColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            children: [
              //app bar
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(Icons.arrow_back_ios),
                  ),
                  const SizedBox(width: 100),
                  Text(
                    'Checkout',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              //containers
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: EdgeInsets.all(16),
                    height: 85,
                    width: 114,

                    decoration: BoxDecoration(
                      color: Color(0xff002366).withOpacity(0.20),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Color(0xff002366).withOpacity(0.30),
                      ),
                    ),
                    child: Center(
                      child: Column(
                        children: [
                          Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              color: AppColors.secondaryColor,
                            ),
                            child: Center(
                              child: Icon(
                                Icons.check,
                                size: 16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text('SHIPPING'),
                        ],
                      ),
                    ),
                  ),
                  //payment
                  Container(
                    padding: EdgeInsets.all(16),
                    height: 85,
                    width: 114,

                    decoration: BoxDecoration(
                      color: AppColors.primaryColor,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Color(0xff002366).withOpacity(0.30),
                      ),
                    ),
                    child: Center(
                      child: Column(
                        children: [
                          Icon(Icons.money, color: Colors.white),
                          const SizedBox(height: 4),
                          Text(
                            'PAYMENT',
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                  //review
                  Container(
                    padding: EdgeInsets.all(16),
                    height: 85,
                    width: 114,

                    decoration: BoxDecoration(
                      color: Color(0xffffffff),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Color(0xff002366).withOpacity(0.30),
                      ),
                    ),
                    child: Center(
                      child: Column(
                        children: [
                          Icon(Icons.rate_review, color: Color(0xffCBD5E1)),
                          const SizedBox(height: 4),
                          Text(
                            'REVIEW',
                            style: TextStyle(color: Color(0xff94A3B8)),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Container(
                padding: EdgeInsets.all(16),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
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
                          'Shipping Address',
                          style: TextStyle(
                            fontSize: 20,
                            color: Color(0xff00113A),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Row(
                          children: [
                            Icon(Icons.add, size: 14, color: Color(0xff904D00)),
                            Text(
                              'ADD NEW',
                              style: TextStyle(
                                color: Color(0xff904D00),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: EdgeInsets.all(16),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: AppColors.secondaryColor.withOpacity(0.5),
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(12),
                        color: AppColors.secondaryColor.withOpacity(0.05),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Home Office',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.secondaryColor,
                                ),
                              ),
                              Container(
                                width: 20,
                                height: 20,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black),
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                child: Center(
                                  child: Container(
                                    width: 15,
                                    height: 15,
                                    decoration: BoxDecoration(
                                      color: AppColors.secondaryColor,
                                      borderRadius: BorderRadius.circular(100),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '123 Tech Avenue, Suite 400 '
                            'San Francisco, CA 94105\n'
                            'United States',
                            style: TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
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
