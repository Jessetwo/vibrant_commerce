import 'package:flutter/material.dart';
import 'package:vibrant_commerce/components/widgets/my_text_box.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              MyTextBox(
                hintText: 'Search Products...',
                prefixIcon: Icons.search,
              ),
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
