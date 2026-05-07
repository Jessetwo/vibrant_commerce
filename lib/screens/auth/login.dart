import 'package:flutter/material.dart';
import 'package:vibrant_commerce/components/assets/app_colors.dart';
import 'package:vibrant_commerce/components/widgets/my_button.dart';
import 'package:vibrant_commerce/components/widgets/my_text_box.dart';
import 'package:vibrant_commerce/components/widgets/social.dart';
import 'package:vibrant_commerce/screens/auth/forgot_password.dart';
import 'package:vibrant_commerce/screens/auth/register.dart';
import 'package:vibrant_commerce/screens/main_screens/main_screen.dart';

class Login extends StatelessWidget {
  const Login({super.key});

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
              height: 615,
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
                    'Welcome Back!',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Sign in to continue your Journey',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 24),
                  MyTextBox(
                    hintText: ' Enter your Email',
                    prefixIcon: Icons.email_outlined,
                    title: 'Email Address',
                  ),
                  const SizedBox(height: 16),
                  MyTextBox(
                    hintText: ' Enter your Password',
                    prefixIcon: Icons.lock_outline,
                    title: 'Password',
                    obscureText: true,
                    suffixIcon: Icons.visibility_off_outlined,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {
                          // Handle forgot password action
                        },
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ForgotPassword(),
                              ),
                            );
                          },
                          child: Text(
                            'Forgot Password?',
                            style: TextStyle(
                              color: AppColors.primaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  MyButton(
                    title: 'Sign In',
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MainScreen(),
                        ),
                      );
                    },
                    color: AppColors.primaryColor,
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 70,
                        child: Divider(color: Colors.grey, thickness: 1),
                      ),
                      const SizedBox(width: 10),
                      Text('Or continue with'),
                      const SizedBox(width: 10),
                      Container(
                        width: 70,
                        child: Divider(color: Colors.grey, thickness: 1),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Social(
                        title: 'Google',
                        assetPath: 'assets/images/google.png',
                      ),
                      Social(
                        title: 'Apple',
                        assetPath: 'assets/images/ios.png',
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Don\'t have an account?',
                        style: TextStyle(fontSize: 16),
                      ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const Register(),
                            ),
                          );
                          // Handle sign up action
                        },
                        child: Text(
                          'Sign Up',
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
