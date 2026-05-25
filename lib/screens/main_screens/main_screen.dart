import 'package:flutter/material.dart';
import 'package:vibrant_commerce/components/assets/app_colors.dart';
import 'package:vibrant_commerce/screens/main_screens/cart_page.dart';
import 'package:vibrant_commerce/screens/main_screens/create_new.dart';
import 'package:vibrant_commerce/screens/main_screens/home_page.dart';
import 'package:vibrant_commerce/screens/main_screens/orders_page.dart';
import 'package:vibrant_commerce/screens/main_screens/profile_page.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const HomePage(),
    const OrdersPage(),
    const CartPage(),
    const ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: _pages),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CreateNew()),
          );
        },
        backgroundColor: AppColors.primaryColor,
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: Colors.white, size: 32),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        color: Colors.white,
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MaterialButton(
                    minWidth: 40,
                    onPressed: () => _onItemTapped(0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.home_outlined,
                          color: _selectedIndex == 0
                              ? AppColors.primaryColor
                              : Colors.grey,
                        ),
                        Text(
                          'Home',
                          style: TextStyle(
                            color: _selectedIndex == 0
                                ? AppColors.primaryColor
                                : Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  MaterialButton(
                    minWidth: 40,
                    onPressed: () => _onItemTapped(1),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.shopping_bag_outlined,
                          color: _selectedIndex == 1
                              ? AppColors.primaryColor
                              : Colors.grey,
                        ),
                        Text(
                          'Orders',
                          style: TextStyle(
                            color: _selectedIndex == 1
                                ? AppColors.primaryColor
                                : Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              // Right Tab bar icons
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MaterialButton(
                    minWidth: 40,
                    onPressed: () => _onItemTapped(2),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.shopping_cart_outlined,
                          color: _selectedIndex == 2
                              ? AppColors.primaryColor
                              : Colors.grey,
                        ),
                        Text(
                          'Cart',
                          style: TextStyle(
                            color: _selectedIndex == 2
                                ? AppColors.primaryColor
                                : Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  MaterialButton(
                    minWidth: 40,
                    onPressed: () => _onItemTapped(3),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.person_outline,
                          color: _selectedIndex == 3
                              ? AppColors.primaryColor
                              : Colors.grey,
                        ),
                        Text(
                          'Profile',
                          style: TextStyle(
                            color: _selectedIndex == 3
                                ? AppColors.primaryColor
                                : Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
