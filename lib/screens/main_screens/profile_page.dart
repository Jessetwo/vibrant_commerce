import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vibrant_commerce/components/assets/app_colors.dart';
import 'package:vibrant_commerce/components/widgets/my_button.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.tertiaryColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Center(
              child: Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          image: DecorationImage(
                            image: AssetImage('assets/images/avatar.png'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned(
                        right: 0,
                        top: 70,
                        child: Image.asset('assets/images/pic.png'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Alex Johnson',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                  ),

                  Text(
                    'alex.johnson@example.com',
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 24),
                  Container(
                    padding: EdgeInsets.all(16),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 2,
                          offset: Offset(0, 1),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: Color(0xffDBE1FF),
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                  child: Center(child: Icon(Icons.person)),
                                ),
                                const SizedBox(width: 16),
                                Text('Edit Profile'),
                              ],
                            ),
                            Icon(Icons.arrow_forward_ios),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Divider(thickness: 0.5),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: Color(0xffDBE1FF),
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                  child: Center(
                                    child: Icon(Icons.delivery_dining),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Text('Shipping Addresses'),
                              ],
                            ),
                            Icon(Icons.arrow_forward_ios),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Divider(thickness: 0.5),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: Color(0xffDBE1FF),
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                  child: Center(child: Icon(Icons.star)),
                                ),
                                const SizedBox(width: 16),
                                Text('My Reviews'),
                              ],
                            ),
                            Icon(Icons.arrow_forward_ios),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Divider(thickness: 0.5),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: Color(0xffDBE1FF),
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                  child: Center(
                                    child: Icon(Icons.notifications),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Text('Notifications'),
                              ],
                            ),
                            Icon(Icons.arrow_forward_ios),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Divider(thickness: 0.5),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: Color(0xffDBE1FF),
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                  child: Center(child: Icon(Icons.payment)),
                                ),
                                const SizedBox(width: 16),
                                Text('Payment Methods'),
                              ],
                            ),
                            Icon(Icons.arrow_forward_ios),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Divider(thickness: 0.5),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: Color(0xffDBE1FF),
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                  child: Center(child: Icon(Icons.support)),
                                ),
                                const SizedBox(width: 16),
                                Text('Help & Support'),
                              ],
                            ),
                            Icon(Icons.arrow_forward_ios),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  MyButton(
                    title: 'Log Out',
                    onPressed: () {},
                    color: AppColors.secondaryColor,
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
