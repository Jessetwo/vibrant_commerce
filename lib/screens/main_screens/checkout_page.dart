import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vibrant_commerce/components/assets/app_colors.dart';
import 'package:vibrant_commerce/components/widgets/my_button.dart';
import 'package:vibrant_commerce/models/cart.dart';
import 'package:vibrant_commerce/models/order.dart';
import 'package:vibrant_commerce/models/user.dart';
import 'package:vibrant_commerce/providers/auth_provider.dart';
import 'package:vibrant_commerce/providers/cart_provider.dart';
import 'package:vibrant_commerce/providers/order_provider.dart';
import 'package:vibrant_commerce/providers/notification_provider.dart';
import 'package:vibrant_commerce/screens/main_screens/main_screen.dart';



class CheckOutPage extends StatefulWidget {
  const CheckOutPage({super.key});

  @override
  State<CheckOutPage> createState() => _CheckOutPageState();
}

class _CheckOutPageState extends State<CheckOutPage> {
  final _streetCtrl = TextEditingController();
  final _cityCtrl = TextEditingController();
  final _stateCtrl = TextEditingController();
  final _zipCtrl = TextEditingController();
  final _countryCtrl = TextEditingController(text: 'Nigeria');

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadCart());
  }

  Future<void> _loadCart() async {
    final auth = context.read<AuthProvider>();
    if (auth.isAuthenticated) {
      await context.read<CartProvider>().getCart(auth.token!);
    }
  }

  @override
  void dispose() {
    _streetCtrl.dispose();
    _cityCtrl.dispose();
    _stateCtrl.dispose();
    _zipCtrl.dispose();
    _countryCtrl.dispose();
    super.dispose();
  }

  double _calcTotal(List items) {
    double subtotal = 0;
    for (final item in items) {
      subtotal += item.product.price * item.quantity;
    }
    return subtotal;
  }

  Future<void> _handlePlaceOrder() async {
    // Capture all context-dependent refs BEFORE any await
    final auth = context.read<AuthProvider>();
    final cartProvider = context.read<CartProvider>();
    final orderProvider = context.read<OrderProvider>();

    if (!auth.isAuthenticated) {
      _snack('Please log in to place an order.', Colors.red);
      return;
    }

    final street = _streetCtrl.text.trim();
    final city = _cityCtrl.text.trim();
    final state = _stateCtrl.text.trim();
    final zip = _zipCtrl.text.trim();
    final country = _countryCtrl.text.trim();

    if (street.isEmpty || city.isEmpty || state.isEmpty || zip.isEmpty || country.isEmpty) {
      _snack('Please fill in your complete shipping address.', Colors.orange);
      return;
    }

    final cart = cartProvider.cart;
    if (cart == null || cart.items.isEmpty) {
      _snack('Your cart is empty.', Colors.orange);
      return;
    }

    final token = auth.token!;

    // Step 1 — Build order items from cart
    final orderItems = cart.items.map((ci) {
      return OrderItem(
        product: ci.product.id,
        name: ci.product.name,
        price: ci.product.price,
        quantity: ci.quantity,
      );
    }).toList();

    final shippingAddress = Address(
      street: street,
      city: city,
      state: state,
      zipCode: zip,
      country: country,
    );

    final total = _calcTotal(cart.items);

    // Step 2 — Create order in backend (which initializes payment)
    final order = await orderProvider.createOrder(
      items: orderItems,
      shippingAddress: shippingAddress,
      totalPrice: total,
      token: token,
    );

    if (!mounted) return;

    if (order == null) {
      _snack(orderProvider.error ?? 'Order creation failed.', Colors.red);
      return;
    }

    // Step 3 — Launch native in-app browser and start auto-verification polling
    final paymentUrl = orderProvider.paymentUrl;
    final reference = orderProvider.paymentReference;

    if (paymentUrl != null && reference != null) {
      final uri = Uri.parse(paymentUrl);
      bool browserOpen = false;
      try {
        browserOpen = await launchUrl(uri, mode: LaunchMode.inAppBrowserView);
      } catch (_) {
        try {
          browserOpen = await launchUrl(uri, mode: LaunchMode.inAppWebView);
        } catch (_) {}
      }

      if (!browserOpen) {
        _snack('Could not open payment window automatically.', Colors.red);
        return;
      }

      if (!mounted) return;

      final notif = Provider.of<NotificationProvider>(context, listen: false);
      final buyerName = auth.currentUser?.name ?? 'A customer';

      final paymentSuccess = await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => _PaymentPollingDialog(
          reference: reference,
          token: token,
          totalPrice: total,
          cartItems: List.from(cart.items),
          buyerName: buyerName,
          orderProvider: orderProvider,
          cartProvider: cartProvider,
          notificationProvider: notif,
        ),
      );

      if (!mounted) return;

      if (paymentSuccess == true) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const MainScreen(initialIndex: 1),
          ),
          (route) => false,
        );
      } else {
        _snack('Payment verification cancelled or incomplete.', Colors.orange);
      }
    } else {
      _snack('No payment details returned from backend. Order created.', Colors.orange);
      cartProvider.clearCart();
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => const MainScreen(initialIndex: 1),
        ),
        (route) => false,
      );
    }
  }

  void _snack(String msg, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: color),
    );
  }

  Widget _buildAddressField(String label, TextEditingController ctrl,
      {String hint = ''}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: const TextStyle(
                  fontSize: 14, fontWeight: FontWeight.w500)),
          const SizedBox(height: 4),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.withOpacity(0.4)),
              borderRadius: BorderRadius.circular(10),
              color: const Color(0xffF3F3F6),
            ),
            child: TextField(
              controller: ctrl,
              decoration: InputDecoration(
                hintText: hint.isEmpty ? label : hint,
                hintStyle: TextStyle(color: Colors.grey.withOpacity(0.6)),
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 12),
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>().cart;
    final cartLoading = context.watch<CartProvider>().isLoading;
    final orderLoading = context.watch<OrderProvider>().isLoading;
    final items = cart?.items ?? [];
    final subtotal = _calcTotal(items);
    final total = subtotal; // shipping free

    return Scaffold(
      backgroundColor: AppColors.tertiaryColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // App bar
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(Icons.arrow_back_ios),
                    ),
                    const SizedBox(width: 100),
                    const Text(
                      'Checkout',
                      style: TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 32),

                // Step indicators
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _stepBox('SHIPPING', Icons.local_shipping, true),
                    _stepBox('PAYMENT', Icons.money, true, isActive: true),
                    _stepBox('REVIEW', Icons.rate_review, false),
                  ],
                ),
                const SizedBox(height: 24),

                // Shipping Address
                Container(
                  padding: const EdgeInsets.all(16),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 2,
                          offset: const Offset(0, 1)),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Shipping Address',
                        style: TextStyle(
                            fontSize: 20,
                            color: Color(0xff00113A),
                            fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 16),
                      _buildAddressField('Street', _streetCtrl,
                          hint: '123 Example Street'),
                      _buildAddressField('City', _cityCtrl,
                          hint: 'Lagos'),
                      Row(
                        children: [
                          Expanded(
                              child: _buildAddressField('State', _stateCtrl,
                                  hint: 'Lagos')),
                          const SizedBox(width: 12),
                          Expanded(
                              child: _buildAddressField('Zip Code', _zipCtrl,
                                  hint: '100001')),
                        ],
                      ),
                      _buildAddressField('Country', _countryCtrl),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Payment Method Banner
                Container(
                  padding: const EdgeInsets.all(16),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 2,
                          offset: const Offset(0, 1)),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(Icons.payment,
                            color: AppColors.primaryColor, size: 28),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Paystack',
                                style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16,
                                    color: Color(0xff00113A))),
                            Text('Secure payment via Paystack',
                                style: TextStyle(
                                    color: Colors.grey[600], fontSize: 13)),
                          ],
                        ),
                      ),
                      Icon(Icons.verified_user,
                          color: Colors.green[600]),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Order Summary
                Container(
                  padding: const EdgeInsets.all(16),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 2,
                          offset: const Offset(0, 1)),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Order Summary',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 16),
                      if (cartLoading)
                        const Center(child: CircularProgressIndicator())
                      else if (items.isEmpty)
                        const Text('Your cart is empty.',
                            style: TextStyle(color: Colors.grey))
                      else
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: items.length,
                          separatorBuilder: (_, __) =>
                              const Divider(height: 16),
                          itemBuilder: (_, i) {
                            final item = items[i];
                            return Row(
                              children: [
                                Container(
                                  width: 56,
                                  height: 56,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: item.product.images.isNotEmpty
                                      ? ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          child: Image.network(
                                            item.product.images.first,
                                            fit: BoxFit.cover,
                                          ),
                                        )
                                      : const Icon(Icons.image,
                                          color: Colors.grey),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(item.product.name,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14)),
                                      Text(
                                          'Qty: ${item.quantity}'
                                          '${item.size != null ? ' | Size: ${item.size}' : ''}'
                                          '${item.color != null ? ' | ${item.color}' : ''}',
                                          style: const TextStyle(
                                              fontSize: 12,
                                              color: Color(0xff64748B))),
                                    ],
                                  ),
                                ),
                                Text(
                                  '₦${(item.product.price * item.quantity).toStringAsFixed(0)}',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            );
                          },
                        ),
                      const SizedBox(height: 16),
                      const Divider(),
                      const SizedBox(height: 12),
                      _summaryRow('Subtotal',
                          '₦${subtotal.toStringAsFixed(0)}'),
                      const SizedBox(height: 8),
                      _summaryRow('Shipping', 'FREE',
                          valueColor: AppColors.primaryColor),
                      const SizedBox(height: 12),
                      const Divider(),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Total',
                              style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold)),
                          Text('₦${total.toStringAsFixed(0)}',
                              style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                      const SizedBox(height: 20),
                      orderLoading
                          ? const Center(child: CircularProgressIndicator())
                          : MyButton(
                              title: 'Place Order',
                              onPressed: _handlePlaceOrder,
                              color: AppColors.primaryColor,
                            ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset('assets/images/lock.png'),
                          const SizedBox(width: 5),
                          const Text(
                            'SECURE ENCRYPTED CHECKOUT',
                            style: TextStyle(
                                fontSize: 10,
                                color: Color(0xff94A3B8)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _stepBox(String label, IconData icon, bool done,
      {bool isActive = false}) {
    return Container(
      padding: const EdgeInsets.all(16),
      height: 85,
      width: 100,
      decoration: BoxDecoration(
        color: isActive
            ? AppColors.primaryColor
            : done
                ? Color(0xff002366).withOpacity(0.20)
                : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
            color: Color(0xff002366).withOpacity(0.30)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          done && !isActive
              ? Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.secondaryColor),
                  child: const Icon(Icons.check,
                      size: 14, color: Colors.white),
                )
              : Icon(icon,
                  color: isActive ? Colors.white : const Color(0xffCBD5E1)),
          const SizedBox(height: 4),
          Text(label,
              style: TextStyle(
                  fontSize: 11,
                  color: isActive
                      ? Colors.white
                      : done
                          ? Colors.black87
                          : const Color(0xff94A3B8))),
        ],
      ),
    );
  }

  Widget _summaryRow(String label, String value, {Color? valueColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 15)),
        Text(value,
            style: TextStyle(
                fontSize: 15,
                color: valueColor ?? Colors.black87)),
      ],
    );
  }
}

class _PaymentPollingDialog extends StatefulWidget {
  final String reference;
  final String token;
  final double totalPrice;
  final List<CartItem> cartItems;
  final String buyerName;
  final OrderProvider orderProvider;
  final CartProvider cartProvider;
  final NotificationProvider notificationProvider;

  const _PaymentPollingDialog({
    required this.reference,
    required this.token,
    required this.totalPrice,
    required this.cartItems,
    required this.buyerName,
    required this.orderProvider,
    required this.cartProvider,
    required this.notificationProvider,
  });

  @override
  State<_PaymentPollingDialog> createState() => _PaymentPollingDialogState();
}

class _PaymentPollingDialogState extends State<_PaymentPollingDialog> {
  Timer? _timer;
  bool _isVerifying = false;

  @override
  void initState() {
    super.initState();
    _startPolling();
  }

  void _startPolling() {
    _timer = Timer.periodic(const Duration(milliseconds: 2500), (timer) async {
      _checkStatus();
    });
  }

  Future<void> _checkStatus() async {
    if (_isVerifying) return;
    if (!mounted) return;
    setState(() {
      _isVerifying = true;
    });
    try {
      final success = await widget.orderProvider.verifyPayment(widget.reference, widget.token);
      if (success && mounted) {
        _timer?.cancel();
        await closeInAppWebView();
        
        // Buyer Notification
        widget.notificationProvider.addNotification(
          title: 'Order Placed successfully! 🎉',
          body: 'Your order #${widget.reference} for ₦${widget.totalPrice.toStringAsFixed(0)} was successfully paid and placed.',
          type: 'buyer_order',
        );

        // Seller/Product Notifications
        for (final ci in widget.cartItems) {
          widget.notificationProvider.addNotification(
            title: 'New Order Received! 🛍️',
            body: 'User "${widget.buyerName}" ordered ${ci.quantity} x "${ci.product.name}". Total: ₦${(ci.product.price * ci.quantity).toStringAsFixed(0)}. Ref: ${widget.reference}.',
            type: 'seller_order',
          );
        }

        widget.cartProvider.clearCart();
        if (mounted) {
          Navigator.pop(context, true); // Dismiss dialog with success result
        }
      }
    } catch (_) {
      // Ignored
    } finally {
      if (mounted) {
        setState(() {
          _isVerifying = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const Row(
        children: [
          Icon(Icons.security, color: AppColors.primaryColor),
          SizedBox(width: 8),
          Text('Verify Payment'),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Please complete your payment in the browser window.',
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 20),
          const SizedBox(
            width: 36,
            height: 36,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryColor),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Auto-verifying Ref: ${widget.reference}',
            style: const TextStyle(fontSize: 12, color: Colors.grey, fontFamily: 'monospace'),
          ),
          if (widget.orderProvider.error != null) ...[
            const SizedBox(height: 8),
            Text(
              widget.orderProvider.error!,
              style: const TextStyle(fontSize: 12, color: Colors.red),
              textAlign: TextAlign.center,
            ),
          ]
        ],
      ),
      actions: [
        TextButton(
          onPressed: () async {
            _timer?.cancel();
            await closeInAppWebView();
            if (mounted) {
              Navigator.pop(context, false); // Dismiss with cancel result
            }
          },
          child: const Text('Cancel', style: TextStyle(color: Colors.red)),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryColor,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          onPressed: _isVerifying ? null : _checkStatus,
          child: const Text('Verify Now', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}
