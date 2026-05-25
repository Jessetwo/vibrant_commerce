import 'package:flutter/material.dart';

class CreateNew extends StatelessWidget {
  const CreateNew({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(Icons.arrow_back_ios),
                  ),
                  const SizedBox(width: 50),
                  Text(
                    'Create New Product',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Product Images (Up to 4)',
                    style: TextStyle(fontSize: 16),
                  ),
                  Text('JPEG or PNG'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
