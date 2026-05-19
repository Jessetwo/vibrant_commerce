import 'package:flutter/material.dart';
import 'package:vibrant_commerce/components/assets/app_colors.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.tertiaryColor,
      body: SafeArea(
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
