import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vibrant_commerce/components/assets/app_colors.dart';
import 'package:vibrant_commerce/components/assets/category_images.dart';
import 'package:vibrant_commerce/components/widgets/my_button.dart';
import 'package:vibrant_commerce/components/widgets/product_image.dart';
import 'package:vibrant_commerce/models/cart.dart';
import 'package:vibrant_commerce/providers/auth_provider.dart';
import 'package:vibrant_commerce/providers/cart_provider.dart';
import 'package:vibrant_commerce/screens/main_screens/checkout_page.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final auth = context.read<AuthProvider>();
      if (auth.isAuthenticated) {
        context.read<CartProvider>().getCart(auth.token!);
      }
    });
  }

  Future<void> _removeItem(String productId, String token) async {
    final cart = context.read<CartProvider>();
    final ok = await cart.removeFromCart(productId, token);
    if (mounted && !ok) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(cart.error ?? 'Could not remove item.'),
        backgroundColor: Colors.red,
      ));
    }
  }

  Future<void> _updateQuantity(String itemId, int newQty, String token) async {
    if (newQty < 1) return;
    final cart = context.read<CartProvider>();
    await cart.updateCartItem(itemId: itemId, quantity: newQty, token: token);
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final cartProvider = context.watch<CartProvider>();
    final cart = cartProvider.cart;
    final items = cart?.items ?? [];

    // Compute total
    double total = 0;
    for (final item in items) {
      total += item.product.price * item.quantity;
    }

    return Scaffold(
      backgroundColor: AppColors.tertiaryColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Header ───────────────────────────────────
              const Text(
                'Your Shopping Cart',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                items.isEmpty
                    ? 'Your cart is empty'
                    : 'You have ${items.length} item${items.length == 1 ? '' : 's'} in your cart',
                style: const TextStyle(fontSize: 15, color: Color(0xff757682)),
              ),
              const SizedBox(height: 20),

              // ── Items List ───────────────────────────────
              Expanded(
                child: !auth.isAuthenticated
                    ? _buildNotLoggedIn()
                    : cartProvider.isLoading && items.isEmpty
                        ? const Center(child: CircularProgressIndicator())
                        : items.isEmpty
                            ? _buildEmptyCart()
                            : ListView.separated(
                                itemCount: items.length,
                                separatorBuilder: (_, __) =>
                                    const SizedBox(height: 14),
                                itemBuilder: (context, index) {
                                  final item = items[index];
                                  return _CartItemCard(
                                    item: item,
                                    token: auth.token!,
                                    onRemove: () => _removeItem(
                                        item.product.id, auth.token!),
                                    onQuantityChanged: (newQty) =>
                                        _updateQuantity(
                                            item.id, newQty, auth.token!),
                                  );
                                },
                              ),
              ),

              // ── Summary & Checkout ───────────────────────
              if (auth.isAuthenticated && items.isNotEmpty) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      _summaryRow('Subtotal',
                          'N${total.toStringAsFixed(2)}'),
                      const SizedBox(height: 10),
                      _summaryRow('Shipping', 'FREE',
                          valueColor: AppColors.primaryColor),
                      const SizedBox(height: 10),
                      const Divider(height: 1),
                      const SizedBox(height: 10),
                      _summaryRow('Total',
                          'N${total.toStringAsFixed(2)}',
                          isBold: true),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                MyButton(
                  title: 'Proceed to Checkout',
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => CheckOutPage()));
                  },
                  color: AppColors.primaryColor,
                ),
                const SizedBox(height: 8),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _summaryRow(String label, String value,
      {Color? valueColor, bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: TextStyle(
                fontSize: isBold ? 17 : 14,
                color: isBold ? Colors.black : Colors.grey[600],
                fontWeight:
                    isBold ? FontWeight.bold : FontWeight.normal)),
        Text(value,
            style: TextStyle(
                fontSize: isBold ? 17 : 14,
                color: valueColor ?? Colors.black,
                fontWeight:
                    isBold ? FontWeight.bold : FontWeight.normal)),
      ],
    );
  }

  Widget _buildEmptyCart() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shopping_cart_outlined,
              size: 80, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text('Your cart is empty',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[500])),
          const SizedBox(height: 8),
          Text('Browse products and add something you love!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey[400])),
        ],
      ),
    );
  }

  Widget _buildNotLoggedIn() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.lock_outline_rounded, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text('Login to view your cart',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[600])),
        ],
      ),
    );
  }
}

// ─── Cart Item Card ─────────────────────────────────────────────────────────
class _CartItemCard extends StatelessWidget {
  final CartItem item;
  final String token;
  final VoidCallback onRemove;
  final ValueChanged<int> onQuantityChanged;

  const _CartItemCard({
    required this.item,
    required this.token,
    required this.onRemove,
    required this.onQuantityChanged,
  });

  @override
  Widget build(BuildContext context) {
    final product = item.product;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: SizedBox(
              width: 88,
              height: 88,
              child: ProductImage(
                imagePath: product.images.isNotEmpty ? product.images.first : '',
                category: product.category,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 14),

          // Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        product.name.isNotEmpty ? product.name : 'Product',
                        style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w700),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    GestureDetector(
                      onTap: onRemove,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        child: const Icon(Icons.delete_outline_rounded,
                            color: Colors.red, size: 20),
                      ),
                    ),
                  ],
                ),
                if (item.size != null || item.color != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Text(
                      [
                        if (item.size != null) 'Size: ${item.size}',
                        if (item.color != null) 'Color: ${item.color}',
                      ].join(' | '),
                      style: const TextStyle(
                          fontSize: 12, color: Color(0xff757682)),
                    ),
                  ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'N${(product.price * item.quantity).toStringAsFixed(2)}',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryColor),
                    ),
                    // Quantity stepper
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 3),
                      decoration: BoxDecoration(
                        color: const Color(0xffF3F3F6),
                        borderRadius: BorderRadius.circular(99),
                      ),
                      child: Row(
                        children: [
                          _stepBtn(
                            icon: Icons.remove,
                            onTap: () =>
                                onQuantityChanged(item.quantity - 1),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10),
                            child: Text('${item.quantity}',
                                style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold)),
                          ),
                          _stepBtn(
                            icon: Icons.add,
                            onTap: () =>
                                onQuantityChanged(item.quantity + 1),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _stepBtn(
      {required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 26,
        height: 26,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 3,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Icon(icon, size: 15),
      ),
    );
  }
}
