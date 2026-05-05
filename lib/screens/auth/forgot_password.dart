import 'package:flutter/material.dart';
import 'package:vibrant_commerce/components/assets/app_colors.dart';
import 'package:vibrant_commerce/components/widgets/my_button.dart';
import 'package:vibrant_commerce/components/widgets/my_text_box.dart';
import 'package:vibrant_commerce/components/widgets/social.dart';
import 'package:vibrant_commerce/screens/auth/login.dart';
import 'package:vibrant_commerce/screens/auth/register.dart';

class ForgotPassword extends StatelessWidget {
  const ForgotPassword({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.tertiaryColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Center(
            child: Container(
              padding: const EdgeInsets.all(32.0),
              width: double.infinity,
              height: 400,

              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Color(0xff002366).withOpacity(0.08),
                    spreadRadius: 12,
                    blurRadius: 24,
                    offset: const Offset(0, 4), // changes position of shadow
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Forgot Password',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    textAlign: TextAlign.center,
                    'Enter your email to reset your password',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 24),
                  MyTextBox(
                    hintText: ' Enter your Email',
                    prefixIcon: Icons.email_outlined,
                    title: 'Email Address',
                  ),
                  const SizedBox(height: 16),

                  MyButton(
                    title: 'Reset Password',
                    onPressed: () {},
                    color: AppColors.primaryColor,
                  ),

                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Remember your password?',
                        style: TextStyle(fontSize: 16),
                      ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const Login(),
                            ),
                          );
                          // Handle sign up action
                        },
                        child: Text(
                          'Sign In',
                          style: TextStyle(
                            color: AppColors.primaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
