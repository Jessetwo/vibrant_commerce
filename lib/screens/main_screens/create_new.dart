import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:vibrant_commerce/components/assets/app_colors.dart';
import 'package:vibrant_commerce/components/widgets/my_button.dart';
import 'package:vibrant_commerce/components/widgets/text_box.dart';

class CreateNew extends StatelessWidget {
  const CreateNew({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.tertiaryColor,
      body: SafeArea(
        child: SingleChildScrollView(
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
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
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
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    DottedBorder(
                      options: RoundedRectDottedBorderOptions(
                        color: Colors.grey,
                        dashPattern: [8, 4],
                        strokeWidth: 2,
                        radius: Radius.circular(12),
                      ),
                      child: Container(
                        padding: EdgeInsets.all(16),
                        width: 78,
                        height: 78,
                        child: Center(
                          child: Column(
                            children: [
                              Image.asset('assets/images/Margin.png'),
                              Text('Add'),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(16),
                      width: 78,
                      height: 78,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        image: DecorationImage(
                          image: AssetImage('assets/images/small_watch.png'),
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(16),
                      width: 78,
                      height: 78,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          width: 0.8,
                          color: Colors.grey.withOpacity(.5),
                        ),
                        borderRadius: BorderRadius.circular(12),
                        image: DecorationImage(
                          image: AssetImage('assets/images/placeholder.png'),
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(16),
                      width: 78,
                      height: 78,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          width: 0.8,
                          color: Colors.grey.withOpacity(.5),
                        ),
                        borderRadius: BorderRadius.circular(12),
                        image: DecorationImage(
                          image: AssetImage('assets/images/placeholder.png'),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Container(
                  padding: EdgeInsets.all(24),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      IconlessTextBox(
                        hintText: 'Enter Descriptive name...',
                        title: 'Product Name',
                      ),
                      const SizedBox(height: 16),
                      IconlessTextBox(hintText: 'Category', title: 'Category'),
                      const SizedBox(height: 16),
                      IconlessTextBox(
                        hintText: 'Tell buyers about your product',
                        title: 'Product Description',
                        maxLines: 6,
                        minLines: 6,
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconlessTextBox(
                            hintText: '0.00',
                            title: 'Price',
                            width: 149,
                          ),
                          IconlessTextBox(
                            hintText: '1',
                            title: 'Stock Quantity',
                            width: 149,
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Product Condition',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            height: 48,
                            width: 149,
                            decoration: BoxDecoration(
                              color: AppColors.primaryColor,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset('assets/images/check.png'),
                                const SizedBox(width: 8),
                                Text(
                                  'New',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          Container(
                            height: 48,
                            width: 149,
                            decoration: BoxDecoration(
                              color: Colors.grey[400],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const SizedBox(width: 8),
                                Text('Used', style: TextStyle(fontSize: 16)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                MyButton(
                  title: 'Publish Product',
                  onPressed: () {},
                  color: AppColors.primaryColor,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
