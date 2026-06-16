import 'package:flutter/material.dart';

class MyTextBox extends StatefulWidget {
  final String? title;
  final String hintText;
  final IconData? prefixIcon;
  final bool? obscureText;
  final IconData? suffixIcon;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  const MyTextBox({
    super.key,
    required this.hintText,
    this.prefixIcon,
    this.obscureText,
    this.suffixIcon,
    this.controller,
    this.title,
    this.onChanged,
    this.onSubmitted,
  });

  @override
  State<MyTextBox> createState() => _MyTextBoxState();
}

class _MyTextBoxState extends State<MyTextBox> {
  late bool _isObscured;

  @override
  void initState() {
    super.initState();
    _isObscured = widget.obscureText ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.title ?? '',
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
            controller: widget.controller,
            obscureText: _isObscured,
            onChanged: widget.onChanged,
            onSubmitted: widget.onSubmitted,
            decoration: InputDecoration(
              suffixIcon: widget.suffixIcon != null || widget.obscureText == true
                  ? GestureDetector(
                      onTap: () {
                        if (widget.obscureText == true) {
                          setState(() {
                            _isObscured = !_isObscured;
                          });
                        }
                      },
                      child: Icon(
                        widget.obscureText == true 
                            ? (_isObscured ? Icons.visibility_off_outlined : Icons.visibility_outlined)
                            : widget.suffixIcon,
                        color: Colors.grey.withOpacity(0.6),
                      ),
                    )
                  : null,
              prefixIcon: widget.prefixIcon != null 
                  ? Icon(widget.prefixIcon, color: Colors.grey.withOpacity(0.6)) 
                  : null,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
              border: InputBorder.none,
              hintText: widget.hintText,
              hintStyle: TextStyle(color: Colors.grey.withOpacity(0.6)),
            ),
          ),
        ),
      ],
    );
  }
}
