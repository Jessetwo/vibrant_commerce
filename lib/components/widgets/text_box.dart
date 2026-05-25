import 'package:flutter/material.dart';

class IconlessTextBox extends StatelessWidget {
  final String? title;
  final String hintText;

  final int minLines;
  final int maxLines;
  final int? width;

  final bool obscureText;
  final TextEditingController? controller;

  const IconlessTextBox({
    super.key,
    required this.hintText,
    this.title,
    this.controller,
    this.obscureText = false,
    this.minLines = 1,
    this.maxLines = 1,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null) ...[
          Text(
            title!,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8),
        ],

        Container(
          width: width != null ? width!.toDouble() : double.infinity,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.withOpacity(0.4), width: 0.8),
            color: const Color(0xffF3F3F6),
            borderRadius: BorderRadius.circular(12),
          ),
          child: TextField(
            controller: controller,
            obscureText: obscureText,
            minLines: minLines,
            maxLines: maxLines,
            keyboardType: maxLines > 1
                ? TextInputType.multiline
                : TextInputType.text,
            decoration: InputDecoration(
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
