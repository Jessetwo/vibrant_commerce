import 'package:flutter/material.dart';

class CatergoryBox extends StatelessWidget {
  const CatergoryBox({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}
