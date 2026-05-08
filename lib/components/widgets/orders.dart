import 'package:flutter/material.dart';
import 'package:vibrant_commerce/components/assets/app_colors.dart';

class Orders extends StatelessWidget {
  final String status;
  final String items;
  final String price;
  final Color color;
  final Color statusColor;
  final Color statusTextColor;
  final String imagePath;
  const Orders({
    super.key,
    required this.items,
    required this.price,
    required this.status,
    required this.color,
    required this.statusColor,
    required this.statusTextColor,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      width: double.infinity,
      height: 195,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 2,
            offset: Offset(0, 1),
          ),
        ],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Order ID',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),

              Text(
                'Order ID',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ],
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('#ORD-12345', style: TextStyle(fontSize: 16)),

              Text('Oct 24, 2023', style: TextStyle(fontSize: 16)),
            ],
          ),
          Divider(thickness: 0.5),
          const SizedBox(height: 16),
          //info row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                children: [
                  Container(
                    width: 78,
                    height: 78,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      image: DecorationImage(
                        image: AssetImage(imagePath),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 110,
                        height: 20,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(99),
                          color: color,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                color: statusColor,
                              ),
                            ),
                            const SizedBox(width: 5),
                            Text(
                              status,
                              style: TextStyle(
                                color: statusTextColor,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(items, style: TextStyle(fontSize: 16)),
                      Text(price, style: TextStyle(fontSize: 16)),
                    ],
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    'Details',
                    style: TextStyle(
                      color: AppColors.primaryColor,
                      fontSize: 16,
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 14,
                    color: AppColors.primaryColor,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
