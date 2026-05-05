import 'package:flutter/material.dart';

class MyTextBox extends StatelessWidget {
  final String? title;
  final String hintText;
  final IconData prefixIcon;
  final bool? obscureText;
  final IconData? suffixIcon;
  final TextEditingController? controller;
  const MyTextBox({
    super.key,
    required this.hintText,
    required this.prefixIcon,
    this.obscureText,
    this.suffixIcon,
    this.controller,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title ?? '',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          height: 52,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.withOpacity(0.4), width: 0.8),
            color: Color(0xffF3F3F6),
            borderRadius: BorderRadius.circular(12),
          ),
          child: TextField(
            controller: controller,
            obscureText: obscureText ?? false,

            decoration: InputDecoration(
              suffixIcon: Icon(suffixIcon, color: Colors.grey.withOpacity(0.6)),
              prefixIcon: Icon(prefixIcon, color: Colors.grey.withOpacity(0.6)),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
              border: InputBorder.none,
              hintText: hintText,
              hintStyle: TextStyle(color: Colors.grey.withOpacity(0.6)),
            ),
          ),
        ),
      ],
    );
  }
}
