import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vibrant_commerce/components/assets/app_colors.dart';
import 'package:vibrant_commerce/components/widgets/my_button.dart';
import 'package:vibrant_commerce/components/widgets/my_text_box.dart';
import 'package:vibrant_commerce/components/widgets/social.dart';
import 'package:vibrant_commerce/providers/auth_provider.dart';
import 'package:vibrant_commerce/screens/main_screens/main_screen.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields.')),
      );
      return;
    }

    if (password.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password must be at least 6 characters.')),
      );
      return;
    }

    final authProvider = context.read<AuthProvider>();
    final success = await authProvider.registerUser(
      name: name,
      email: email,
      password: password,
    );

    if (!mounted) return;

    if (success) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(authProvider.error ?? 'Sign up failed. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = context.watch<AuthProvider>().isLoading;

    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth >= 600;
    final horizontalPadding = isTablet ? screenWidth * 0.1 : 24.0;

    return Scaffold(
      backgroundColor: AppColors.tertiaryColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding,
            vertical: 24.0,
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Container(
                padding: EdgeInsets.all(isTablet ? 40.0 : 28.0),
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xff002366).withValues(alpha: 0.08),
                      spreadRadius: 12,
                      blurRadius: 24,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Create an Account',
                      style: TextStyle(
                        fontSize: isTablet ? 28 : 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Sign up to get started',
                      style: TextStyle(
                        fontSize: isTablet ? 18 : 16,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 24),
                    MyTextBox(
                      hintText: ' Enter your Name',
                      prefixIcon: Icons.person_outline,
                      title: 'Full Name',
                      controller: _nameController,
                    ),
                    const SizedBox(height: 16),
                    MyTextBox(
                      hintText: ' Enter your Email',
                      prefixIcon: Icons.email_outlined,
                      title: 'Email Address',
                      controller: _emailController,
                    ),
                    const SizedBox(height: 16),
                    MyTextBox(
                      hintText: ' Enter your Password',
                      prefixIcon: Icons.lock_outline,
                      title: 'Password',
                      obscureText: true,
                      suffixIcon: Icons.visibility_off_outlined,
                      controller: _passwordController,
                    ),
                    const SizedBox(height: 24),
                    isLoading
                        ? const CircularProgressIndicator()
                        : MyButton(
                            title: 'Sign Up',
                            onPressed: _handleRegister,
                            color: AppColors.primaryColor,
                          ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(child: Divider(color: Colors.grey, thickness: 1)),
                        const SizedBox(width: 10),
                        const Text('Or continue with'),
                        const SizedBox(width: 10),
                        Expanded(child: Divider(color: Colors.grey, thickness: 1)),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Social(
                            title: 'Google',
                            assetPath: 'assets/images/google.png',
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Social(
                            title: 'Apple',
                            assetPath: 'assets/images/ios.png',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Wrap(
                      alignment: WrapAlignment.center,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 8,
                      children: [
                        Text(
                          'Already have an account?',
                          style: TextStyle(fontSize: 16),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
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
      ),
    );
  }
}
