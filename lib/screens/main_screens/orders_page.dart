import 'package:flutter/material.dart';
import 'package:vibrant_commerce/components/assets/app_colors.dart';
import 'package:vibrant_commerce/components/widgets/orders.dart';

class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.tertiaryColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsetsGeometry.all(24),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    //all orders
                    Container(
                      width: 110,
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(99),
                        color: AppColors.secondaryColor,
                      ),
                      child: Center(
                        child: Text(
                          'All Orders',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                    ),
                    //ongoing
                    Container(
                      width: 110,
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(99),
                        color: Color(0xffE4E4E8),
                      ),
                      child: Center(
                        child: Text(
                          'On Going',
                          style: TextStyle(
                            color: Color(0xff444650),
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                    //completed
                    Container(
                      width: 110,
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(99),
                        color: Color(0xffE4E4E8),
                      ),
                      child: Center(
                        child: Text(
                          'All Orders',
                          style: TextStyle(
                            color: Color(0xff444650),
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Orders(
                  imagePath: 'assets/images/watch.png',
                  statusTextColor: Colors.green,
                  statusColor: Colors.green,
                  status: 'Delivered',
                  color: Color(0xffDCFCE7),
                  price: '\$173.5',
                  items: '2 Items',
                ),
                const SizedBox(height: 16),
                Orders(
                  imagePath: 'assets/images/shoe.png',
                  statusTextColor: Color(0xffC2410C),
                  items: '4 itmes',
                  price: '\$200',
                  status: 'In transit',
                  color: Color(0xffFFEDD5),
                  statusColor: Color(0xffF97316),
                ),
                const SizedBox(height: 16),
                Orders(
                  imagePath: 'assets/images/headphone.png',
                  statusTextColor: Color(0xffC2410C),
                  items: '1 itmes',
                  price: '\$197.50',
                  status: 'In transit',
                  color: Color(0xffFFEDD5),
                  statusColor: Color(0xffF97316),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
