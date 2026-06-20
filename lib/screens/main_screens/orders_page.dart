import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vibrant_commerce/components/assets/app_colors.dart';
import 'package:vibrant_commerce/components/widgets/orders.dart';
import 'package:vibrant_commerce/models/order.dart';
import 'package:vibrant_commerce/providers/auth_provider.dart';
import 'package:vibrant_commerce/providers/order_provider.dart';
import 'package:vibrant_commerce/providers/product_provider.dart';
import 'package:vibrant_commerce/screens/main_screens/order_details_page.dart';
import 'package:vibrant_commerce/models/product.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  // Tab: 0 = My Orders, 1 = Customer Orders
  int _selectedTab = 0;
  bool _didFetch = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_didFetch) {
        _didFetch = true;
        _fetchOrders();
      }
    });
  }

  Future<void> _fetchOrders() async {
    final auth = context.read<AuthProvider>();
    if (auth.isAuthenticated && auth.token != null) {
      await context.read<OrderProvider>().getMyOrders(auth.token!);
    }
  }

  _StatusStyle _statusStyle(String status) {
    switch (status.toLowerCase()) {
      case 'delivered':
      case 'completed':
        return _StatusStyle(
          bgColor: const Color(0xffDCFCE7),
          dotColor: Colors.green,
          textColor: Colors.green,
          label: 'Delivered',
        );
      case 'shipped':
      case 'in_transit':
        return _StatusStyle(
          bgColor: const Color(0xffFFEDD5),
          dotColor: const Color(0xffF97316),
          textColor: const Color(0xffC2410C),
          label: 'In Transit',
        );
      case 'cancelled':
        return _StatusStyle(
          bgColor: const Color(0xffFEE2E2),
          dotColor: Colors.red,
          textColor: Colors.red,
          label: 'Cancelled',
        );
      default:
        return _StatusStyle(
          bgColor: const Color(0xffE0F2FE),
          dotColor: const Color(0xff0284C7),
          textColor: const Color(0xff0369A1),
          label: _capitalise(status),
        );
    }
  }

  String _capitalise(String s) =>
      s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);

  String _formatDate(DateTime? dt) {
    if (dt == null) return '—';
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[dt.month - 1]} ${dt.day}, ${dt.year}';
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final orderProvider = context.watch<OrderProvider>();
    final productProvider = context.watch<ProductProvider>();
    final isLoading = orderProvider.isLoading;
    final allOrders = orderProvider.myOrders;
    final currentUser = auth.currentUser;

    Product? findFullProduct(String id) {
      try {
        return productProvider.products.firstWhere((p) => p.id == id);
      } catch (_) {
        try {
          return productProvider.trendingProducts.firstWhere((p) => p.id == id);
        } catch (_) {
          return null;
        }
      }
    }

    // Flatten orders into individual paid products
    final List<Map<String, dynamic>> paidProducts = [];
    for (final order in allOrders) {
      for (final item in order.items) {
        final isMyOrder = currentUser != null && order.user == currentUser.id;
        
        final fullProduct = findFullProduct(item.product);
        final isMyProduct = fullProduct != null && currentUser != null && fullProduct.user == currentUser.id;
        
        if (_selectedTab == 0 && isMyOrder) {
          paidProducts.add({
            'order': order,
            'item': item,
          });
        } else if (_selectedTab == 1 && isMyProduct) {
          paidProducts.add({
            'order': order,
            'item': item,
          });
        }
      }
    }

    return Scaffold(
      backgroundColor: AppColors.tertiaryColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header ─────────────────────────────────────────
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'My Orders',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff00113A),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${paidProducts.length} product${paidProducts.length == 1 ? '' : 's'} total',
                    style:
                        TextStyle(fontSize: 14, color: Colors.grey[500]),
                  ),
                ],
              ),
            ),

            // ── Filter Tabs ────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: [
                  _tabChip('My Orders', 0),
                  const SizedBox(width: 10),
                  _tabChip('Customer Orders', 1),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // ── Body ───────────────────────────────────────────
            Expanded(
              child: RefreshIndicator(
                onRefresh: _fetchOrders,
                color: AppColors.primaryColor,
                child: !auth.isAuthenticated
                    ? _notLoggedIn()
                    : isLoading && allOrders.isEmpty
                        ? const Center(child: CircularProgressIndicator())
                        : orderProvider.error != null && allOrders.isEmpty
                            ? _errorState(orderProvider.error!)
                            : allOrders.isEmpty
                                ? _emptyState()
                                : Builder(
                                    builder: (context) {
                                      if (paidProducts.isEmpty) return _emptyState();

                                      return ListView.separated(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 24, vertical: 8),
                                        itemCount: paidProducts.length,
                                        separatorBuilder: (_, __) =>
                                            const SizedBox(height: 16),
                                        itemBuilder: (_, i) {
                                          final productData = paidProducts[i];
                                          final order = productData['order'] as Order;
                                          final item = productData['item'] as OrderItem;
                                          
                                          final style = _statusStyle(order.orderStatus);
                                          final fullProduct = findFullProduct(item.product);
                                          
                                          final img = (fullProduct != null && fullProduct.images.isNotEmpty) 
                                              ? fullProduct.images.first 
                                              : item.image;
                                              
                                          final displayImg = (img != null && img.isNotEmpty && img != 'null') 
                                              ? img 
                                              : 'assets/images/placeholder.png';

                                          return GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => OrderDetailsPage(order: order),
                                                ),
                                              );
                                            },
                                            child: Orders(
                                              orderId: order.id,
                                              date: _formatDate(order.createdAt),
                                              status: style.label,
                                              items: '${item.name} (x${item.quantity})',
                                              price: '₦${(item.price * item.quantity).toStringAsFixed(0)}',
                                              color: style.bgColor,
                                              statusColor: style.dotColor,
                                              statusTextColor: style.textColor,
                                              imagePath: displayImg,
                                            ),
                                          );
                                        },
                                      );
                                    },
                                  ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _tabChip(String label, int index) {
    final active = _selectedTab == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedTab = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(99),
          color: active ? AppColors.secondaryColor : const Color(0xffE4E4E8),
          boxShadow: active
              ? [
                  BoxShadow(
                    color: AppColors.secondaryColor.withValues(alpha: 0.35),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  )
                ]
              : [],
        ),
        child: Text(
          label,
          style: TextStyle(
            color: active ? Colors.white : const Color(0xff444650),
            fontSize: 14,
            fontWeight: active ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _emptyState() {
    return ListView(
      padding: const EdgeInsets.all(40),
      children: [
        const SizedBox(height: 60),
        Center(
          child: Column(
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: AppColors.primaryColor.withValues(alpha: 0.08),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.receipt_long_outlined,
                  size: 50,
                  color: AppColors.primaryColor.withValues(alpha: 0.5),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'No orders yet',
                style:
                    TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'Your orders will appear here\nonce you make a purchase.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.grey[500]),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _notLoggedIn() {
    return ListView(
      padding: const EdgeInsets.all(40),
      children: [
        const SizedBox(height: 60),
        Center(
          child: Column(
            children: [
              Icon(Icons.lock_outline_rounded,
                  size: 64, color: Colors.grey[400]),
              const SizedBox(height: 20),
              const Text(
                'Please log in',
                style:
                    TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'Log in to view your order history.',
                style: TextStyle(fontSize: 14, color: Colors.grey[500]),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _errorState(String msg) {
    return ListView(
      padding: const EdgeInsets.all(40),
      children: [
        const SizedBox(height: 60),
        Center(
          child: Column(
            children: [
              Icon(Icons.wifi_off_rounded, size: 64, color: Colors.grey[400]),
              const SizedBox(height: 20),
              const Text(
                'Could not load orders',
                style:
                    TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                msg,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13, color: Colors.grey[500]),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _fetchOrders,
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('Retry'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _StatusStyle {
  final Color bgColor;
  final Color dotColor;
  final Color textColor;
  final String label;
  const _StatusStyle({
    required this.bgColor,
    required this.dotColor,
    required this.textColor,
    required this.label,
  });
}
