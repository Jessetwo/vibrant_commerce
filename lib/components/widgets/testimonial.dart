import 'package:flutter/material.dart';

class Testimonial extends StatelessWidget {
  final String name;
  final String text;
  final String imagePath;
  const Testimonial({
    super.key,
    required this.name,
    required this.text,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Color(0xffFFFFFF),
        border: Border.all(color: Color(0xffE2E2E5), width: 1),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 2,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  image: DecorationImage(image: AssetImage(imagePath)),
                ),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: TextStyle(fontSize: 16)),
                  Row(
                    children: [
                      Icon(Icons.star_rate, color: Color(0xff904D00), size: 16),
                      Icon(Icons.star_rate, color: Color(0xff904D00), size: 16),
                      Icon(Icons.star_rate, color: Color(0xff904D00), size: 16),
                      Icon(Icons.star_rate, color: Color(0xff904D00), size: 16),
                    ],
                  ),
                ],
              ),
            ],
          ),
          Text(text, style: TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}
