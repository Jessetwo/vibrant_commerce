import 'package:flutter/material.dart';

class Social extends StatelessWidget {
  final String title;
  final String assetPath;
  const Social({super.key, required this.title, required this.assetPath});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
      height: 52,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(assetPath, width: 24, height: 24),
          const SizedBox(width: 8),
          Text(
            title,
            style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
          ),
        ],
      ),
    );
  }
}
