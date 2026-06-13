import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vibrant_commerce/components/assets/app_colors.dart';
import 'package:vibrant_commerce/components/widgets/my_button.dart';
import 'package:vibrant_commerce/providers/auth_provider.dart';
import 'package:vibrant_commerce/screens/auth/login.dart';
import 'package:vibrant_commerce/providers/cart_provider.dart';
import 'package:vibrant_commerce/screens/main_screens/edit_profile_page.dart';
import 'package:vibrant_commerce/screens/main_screens/shipping_addresses_page.dart';
import 'package:vibrant_commerce/screens/main_screens/payment_methods_page.dart';
import 'package:vibrant_commerce/screens/main_screens/my_reviews_page.dart';
import 'package:vibrant_commerce/screens/main_screens/notifications_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      if (authProvider.currentUser == null && authProvider.isAuthenticated) {
        authProvider.getUserProfile();
      }
    });
  }

  void _showComingSoonSnackBar(String featureName) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$featureName feature coming soon!'),
        backgroundColor: AppColors.primaryColor,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final user = authProvider.currentUser;
    final isLoading = authProvider.isLoading;

    // Resolve avatar image provider
    ImageProvider avatarImage;
    if (user != null && user.avatar.isNotEmpty) {
      if (user.avatar.startsWith('http://') || user.avatar.startsWith('https://')) {
        avatarImage = NetworkImage(user.avatar);
      } else {
        avatarImage = AssetImage(user.avatar);
      }
    } else {
      avatarImage = const AssetImage('assets/images/avatar.png');
    }

    return Scaffold(
      backgroundColor: AppColors.tertiaryColor,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
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
                            image: avatarImage,
                            fit: BoxFit.cover,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        right: 0,
                        top: 70,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const EditProfilePage(),
                              ),
                            );
                          },
                          child: Image.asset('assets/images/pic.png'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  if (isLoading && user == null)
                    const Column(
                      children: [
                        SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(strokeWidth: 2.5),
                        ),
                        SizedBox(height: 16),
                      ],
                    )
                  else ...[
                    Text(
                      user?.name ?? 'Guest User',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 24),
                    ),
                    Text(
                      user?.email ?? 'guest@example.com',
                      style: const TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ],
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.all(16),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 2,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        // Edit Profile Row
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const EditProfilePage(),
                              ),
                            );
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: const Color(0xffDBE1FF),
                                      borderRadius: BorderRadius.circular(100),
                                    ),
                                    child: const Center(
                                        child: Icon(Icons.person,
                                            color: Color(0xff002366))),
                                  ),
                                  const SizedBox(width: 16),
                                  const Text('Edit Profile',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500)),
                                ],
                              ),
                              const Icon(Icons.arrow_forward_ios,
                                  size: 16, color: Colors.grey),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Divider(thickness: 0.5),
                        const SizedBox(height: 16),

                        // Shipping Addresses Row
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const ShippingAddressesPage(),
                              ),
                            );
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: const Color(0xffDBE1FF),
                                      borderRadius: BorderRadius.circular(100),
                                    ),
                                    child: const Center(
                                      child: Icon(Icons.delivery_dining,
                                          color: Color(0xff002366)),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  const Text('Shipping Addresses',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500)),
                                ],
                              ),
                              const Icon(Icons.arrow_forward_ios,
                                  size: 16, color: Colors.grey),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Divider(thickness: 0.5),
                        const SizedBox(height: 16),

                        // My Reviews Row
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const MyReviewsPage(),
                              ),
                            );
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: const Color(0xffDBE1FF),
                                      borderRadius: BorderRadius.circular(100),
                                    ),
                                    child: const Center(
                                        child: Icon(Icons.star,
                                            color: Color(0xff002366))),
                                  ),
                                  const SizedBox(width: 16),
                                  const Text('My Reviews',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500)),
                                ],
                              ),
                              const Icon(Icons.arrow_forward_ios,
                                  size: 16, color: Colors.grey),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Divider(thickness: 0.5),
                        const SizedBox(height: 16),

                        // Notifications Row
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const NotificationsPage(),
                              ),
                            );
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: const Color(0xffDBE1FF),
                                      borderRadius: BorderRadius.circular(100),
                                    ),
                                    child: const Center(
                                      child: Icon(Icons.notifications,
                                          color: Color(0xff002366)),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  const Text('Notifications',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500)),
                                ],
                              ),
                              const Icon(Icons.arrow_forward_ios,
                                  size: 16, color: Colors.grey),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Divider(thickness: 0.5),
                        const SizedBox(height: 16),

                        // Payment Methods Row
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const PaymentMethodsPage(),
                              ),
                            );
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: const Color(0xffDBE1FF),
                                      borderRadius: BorderRadius.circular(100),
                                    ),
                                    child: const Center(
                                        child: Icon(Icons.payment,
                                            color: Color(0xff002366))),
                                  ),
                                  const SizedBox(width: 16),
                                  const Text('Payment Methods',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500)),
                                ],
                              ),
                              const Icon(Icons.arrow_forward_ios,
                                  size: 16, color: Colors.grey),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Divider(thickness: 0.5),
                        const SizedBox(height: 16),

                        // Help & Support Row
                        InkWell(
                          onTap: () => _showComingSoonSnackBar('Help & Support'),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: const Color(0xffDBE1FF),
                                      borderRadius: BorderRadius.circular(100),
                                    ),
                                    child: const Center(
                                        child: Icon(Icons.support,
                                            color: Color(0xff002366))),
                                  ),
                                  const SizedBox(width: 16),
                                  const Text('Help & Support',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500)),
                                ],
                              ),
                              const Icon(Icons.arrow_forward_ios,
                                  size: 16, color: Colors.grey),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  MyButton(
                    title: 'Log Out',
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            title: const Text(
                              'Confirm Logout',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            content: const Text(
                              'Are you sure you want to log out of Vibrant Commerce?',
                              style: TextStyle(color: Colors.grey, fontSize: 16),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text(
                                  'Cancel',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.secondaryColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  authProvider.logout();
                                  Provider.of<CartProvider>(context, listen: false).clearCart();
                                  Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(
                                      builder: (context) => const Login(),
                                    ),
                                    (route) => false,
                                  );
                                },
                                child: const Text(
                                  'Log Out',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    color: AppColors.secondaryColor,
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
