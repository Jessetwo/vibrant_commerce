import 'package:flutter/material.dart';

class CatergoryBox extends StatelessWidget {
  final String imagePath;
  const CatergoryBox({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 2,
            offset: Offset(0, 1),
          ),
        ],
        color: Colors.white,
        borderRadius: BorderRadius.circular(100),
      ),
      child: Center(child: Image.asset(imagePath, width: 32, height: 32)),
    );
  }
}
