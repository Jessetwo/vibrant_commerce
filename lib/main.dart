import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vibrant_commerce/providers/auth_provider.dart';
import 'package:vibrant_commerce/providers/product_provider.dart';
import 'package:vibrant_commerce/providers/cart_provider.dart';
import 'package:vibrant_commerce/providers/order_provider.dart';
import 'package:vibrant_commerce/providers/notification_provider.dart';
import 'package:vibrant_commerce/screens/auth/splash_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => OrderProvider()),
        ChangeNotifierProvider(create: (_) => NotificationProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
