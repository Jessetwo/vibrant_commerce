import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vibrant_commerce/components/assets/app_colors.dart';
import 'package:vibrant_commerce/components/assets/category_images.dart';
import 'package:vibrant_commerce/components/widgets/product_image.dart';
import 'package:vibrant_commerce/models/product.dart';
import 'package:vibrant_commerce/models/review.dart';
import 'package:vibrant_commerce/providers/auth_provider.dart';
import 'package:vibrant_commerce/providers/cart_provider.dart';
import 'package:vibrant_commerce/providers/product_provider.dart';
import 'package:vibrant_commerce/providers/notification_provider.dart';
import 'package:vibrant_commerce/screens/main_screens/create_new.dart';

class ProductDetails extends StatefulWidget {
  final Product product;
  const ProductDetails({super.key, required this.product});

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  final PageController _pageController = PageController();
  final TextEditingController _commentController = TextEditingController();

  int _currentImageIndex = 0;
  String? _selectedSize;
  String? _selectedColor;
  int _submitRating = 5;
  bool _isSubmittingReview = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProductProvider>(context, listen: false)
          .getProductReviews(widget.product.id);
    });
    if (widget.product.sizes.isNotEmpty) _selectedSize = widget.product.sizes.first;
    if (widget.product.colors.isNotEmpty) _selectedColor = widget.product.colors.first;
  }

  @override
  void dispose() {
    _pageController.dispose();
    _commentController.dispose();
    super.dispose();
  }

  Color _parseColor(String colorName) {
    final n = colorName.toLowerCase();
    if (n.contains('red') || n.contains('crimson')) return const Color(0xffDC143C);
    if (n.contains('black') || n.contains('midnight') || n.contains('charcoal')) return const Color(0xff1C1C1E);
    if (n.contains('blue')) return Colors.blue;
    if (n.contains('green') || n.contains('emerald')) return const Color(0xff046A38);
    if (n.contains('grey') || n.contains('gray') || n.contains('slate')) return Colors.grey;
    if (n.contains('white') || n.contains('ivory')) return const Color(0xffFAFAFA);
    if (n.contains('silver')) return const Color(0xffC0C0C0);
    if (n.contains('gold')) return const Color(0xffFFD700);
    if (n.contains('orange')) return Colors.orange;
    if (n.contains('purple')) return Colors.purple;
    return Colors.amber;
  }

  Future<void> _submitReview(String token) async {
    if (_commentController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Please write a comment before submitting.'),
        backgroundColor: Colors.orange,
      ));
      return;
    }
    setState(() => _isSubmittingReview = true);
    final pp = Provider.of<ProductProvider>(context, listen: false);
    final auth = Provider.of<AuthProvider>(context, listen: false);
    final ok = await pp.createReview(
      productId: widget.product.id,
      rating: _submitRating,
      comment: _commentController.text.trim(),
      name: auth.currentUser?.name ?? 'Verified Customer',
      token: token,
    );
    if (!mounted) return;
    setState(() => _isSubmittingReview = false);
    if (ok) {
      _commentController.clear();
      setState(() => _submitRating = 5);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Review submitted successfully!'),
        backgroundColor: Colors.green,
      ));
      pp.getProductReviews(widget.product.id);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(pp.error ?? 'Failed to submit review.'),
        backgroundColor: Colors.red,
      ));
    }
  }

  Future<void> _addToCart(String token) async {
    final cart = Provider.of<CartProvider>(context, listen: false);
    final ok = await cart.addToCart(
      productId: widget.product.id,
      quantity: 1,
      size: _selectedSize,
      color: _selectedColor,
      token: token,
    );
    if (!mounted) return;
    if (ok) {
      Provider.of<NotificationProvider>(context, listen: false).addNotification(
        title: 'Item Added to Cart 🛒',
        body: '${widget.product.name} has been added to your shopping cart.',
        type: 'cart_added',
      );
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Row(children: [
          const Icon(Icons.check_circle, color: Colors.white),
          const SizedBox(width: 8),
          Text('${widget.product.name} added to cart!'),
        ]),
        backgroundColor: Colors.green,
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(cart.error ?? 'Failed to add to cart.'),
        backgroundColor: Colors.red,
      ));
    }
  }

  Future<void> _confirmDelete(BuildContext context, String token) async {
    final pp = Provider.of<ProductProvider>(context, listen: false);
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Delete Product'),
          content: const Text('Are you sure you want to delete this product? This action cannot be undone.'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Deleting product...'),
          duration: Duration(seconds: 1),
        ),
      );
      
      final success = await pp.deleteProduct(widget.product.id, token);
      
      if (!context.mounted) return;
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Product deleted successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.of(context).pop();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(pp.error ?? 'Failed to delete product.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Widget _buildReviewCard(Review rev) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xffE2E2E5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: AppColors.primaryColor.withOpacity(0.15),
                child: Text(
                  rev.name.isNotEmpty ? rev.name[0].toUpperCase() : 'U',
                  style: TextStyle(
                    color: AppColors.primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      rev.name.isNotEmpty ? rev.name : 'Verified Customer',
                      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                    ),
                    Row(
                      children: List.generate(5, (i) => Icon(
                        i < rev.rating ? Icons.star_rounded : Icons.star_border_rounded,
                        color: Colors.amber[700],
                        size: 16,
                      )),
                    ),
                  ],
                ),
              ),
              if (rev.createdAt != null)
                Text(
                  '${rev.createdAt!.day}/${rev.createdAt!.month}/${rev.createdAt!.year}',
                  style: TextStyle(color: Colors.grey[500], fontSize: 11),
                ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            rev.comment,
            style: TextStyle(fontSize: 13, color: Colors.grey[700], height: 1.5),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final pp = context.watch<ProductProvider>();
    final reviews = pp.currentProductReviews;
    final currentUser = auth.currentUser;

    final Product product = pp.products.firstWhere(
      (p) => p.id == widget.product.id,
      orElse: () => pp.trendingProducts.firstWhere(
        (p) => p.id == widget.product.id,
        orElse: () => widget.product,
      ),
    );

    final isOwner = currentUser != null && product.user == currentUser.id;

    final images = product.images.isNotEmpty
        ? product.images
        : <String>[categoryFallbackImage(product.category)];

    return Scaffold(
      backgroundColor: AppColors.tertiaryColor,
      body: SafeArea(
        child: Column(
          children: [
            // ── Top bar ──────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.07), blurRadius: 6)],
                      ),
                      child: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
                    ),
                  ),
                  const Text('Product Details',
                      style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                  Row(children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.07), blurRadius: 6)],
                      ),
                      child: const Icon(Icons.favorite_border_rounded, size: 18),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.07), blurRadius: 6)],
                      ),
                      child: const Icon(Icons.share_rounded, size: 18),
                    ),
                  ]),
                ],
              ),
            ),

            // ── Scrollable Body ───────────────────────────────
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    // ── Image Gallery (PageView) ──────────────
                    Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        SizedBox(
                          height: 320,
                          width: double.infinity,
                          child: PageView.builder(
                            controller: _pageController,
                            itemCount: images.length,
                            onPageChanged: (i) => setState(() => _currentImageIndex = i),
                            itemBuilder: (context, index) {
                              final src = images[index];
                              return ProductImage(
                                imagePath: src,
                                category: widget.product.category,
                                fit: BoxFit.cover,
                                width: double.infinity,
                              );
                            },
                          ),
                        ),
                        // Dot indicators
                        if (images.length > 1)
                          Positioned(
                            bottom: 14,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(images.length, (i) {
                                final active = i == _currentImageIndex;
                                return AnimatedContainer(
                                  duration: const Duration(milliseconds: 250),
                                  margin: const EdgeInsets.symmetric(horizontal: 4),
                                  width: active ? 22 : 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                    color: active
                                        ? AppColors.primaryColor
                                        : Colors.white.withOpacity(0.65),
                                  ),
                                );
                              }),
                            ),
                          ),
                        // Image counter badge
                        Positioned(
                          top: 12,
                          right: 12,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              '${_currentImageIndex + 1}/${images.length}',
                              style: const TextStyle(color: Colors.white, fontSize: 12),
                            ),
                          ),
                        ),
                      ],
                    ),

                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          // ── Name / Price / Trending ───────────
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(product.name,
                                        style: const TextStyle(
                                            fontSize: 20, fontWeight: FontWeight.bold)),
                                    const SizedBox(height: 6),
                                    Text(
                                      'N${product.price.toStringAsFixed(2)}',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.primaryColor),
                                    ),
                                  ],
                                ),
                              ),
                              if (product.isTrending)
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(99),
                                    color: AppColors.secondaryColor.withOpacity(0.15),
                                    border: Border.all(color: AppColors.secondaryColor),
                                  ),
                                  child: Text('🔥 Trending',
                                      style: TextStyle(
                                          color: AppColors.secondaryColor,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold)),
                                ),
                            ],
                          ),
                          const SizedBox(height: 10),

                          // ── Rating row ────────────────────────
                          Row(
                            children: [
                              ...List.generate(5, (i) => Icon(
                                i < product.ratings.average.round()
                                    ? Icons.star_rounded
                                    : Icons.star_border_rounded,
                                color: Colors.amber[700], size: 20,
                              )),
                              const SizedBox(width: 6),
                              Text('(${reviews.length} ${reviews.length == 1 ? 'review' : 'reviews'})',
                                  style: TextStyle(color: Colors.grey[600], fontSize: 13)),
                              const Spacer(),
                              if (isOwner)
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.blue.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(99),
                                    border: Border.all(color: Colors.blue.withOpacity(0.4)),
                                  ),
                                  child: const Row(children: [
                                    Icon(Icons.verified_user_rounded, color: Colors.blue, size: 13),
                                    SizedBox(width: 4),
                                    Text('Your Product',
                                        style: TextStyle(color: Colors.blue, fontSize: 11, fontWeight: FontWeight.bold)),
                                  ]),
                                ),
                            ],
                          ),
                          const SizedBox(height: 20),

                          // ── Description ───────────────────────
                          const Text('Description',
                              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
                          Text(product.description,
                              style: TextStyle(fontSize: 14, color: Colors.grey[700], height: 1.6)),
                          const SizedBox(height: 24),

                          // ── Color Selector ────────────────────
                          if (product.colors.isNotEmpty) ...[
                            const Text('Color',
                                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 12),
                            Wrap(
                              spacing: 10,
                              children: product.colors.map((c) {
                                final selected = _selectedColor == c;
                                final parsed = _parseColor(c);
                                return GestureDetector(
                                  onTap: () => setState(() => _selectedColor = c),
                                  child: Tooltip(
                                    message: c,
                                    child: AnimatedContainer(
                                      duration: const Duration(milliseconds: 200),
                                      padding: const EdgeInsets.all(3),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: selected ? AppColors.primaryColor : Colors.transparent,
                                          width: 2.5,
                                        ),
                                      ),
                                      child: Container(
                                        width: 32, height: 32,
                                        decoration: BoxDecoration(
                                          color: parsed,
                                          shape: BoxShape.circle,
                                          border: parsed == const Color(0xffFAFAFA)
                                              ? Border.all(color: Colors.grey[300]!)
                                              : null,
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(0.12),
                                              blurRadius: 3,
                                              offset: const Offset(0, 1),
                                            ),
                                          ],
                                        ),
                                        child: selected
                                            ? Icon(Icons.check,
                                                color: parsed.computeLuminance() > 0.5
                                                    ? Colors.black
                                                    : Colors.white,
                                                size: 16)
                                            : null,
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                            const SizedBox(height: 24),
                          ],

                          // ── Size Selector ─────────────────────
                          if (product.sizes.isNotEmpty) ...[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Size',
                                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                                Text('Size Guide',
                                    style: TextStyle(
                                        fontSize: 13,
                                        color: AppColors.primaryColor,
                                        fontWeight: FontWeight.w600)),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Wrap(
                              spacing: 10,
                              runSpacing: 10,
                              children: product.sizes.map((s) {
                                final selected = _selectedSize == s;
                                return GestureDetector(
                                  onTap: () => setState(() => _selectedSize = s),
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 200),
                                    width: 58, height: 48,
                                    decoration: BoxDecoration(
                                      color: selected
                                          ? AppColors.primaryColor.withOpacity(0.12)
                                          : Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color: selected ? AppColors.primaryColor : const Color(0xffC5C6D2),
                                        width: selected ? 2 : 1,
                                      ),
                                    ),
                                    child: Center(
                                      child: Text(s,
                                          style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                                              color: selected ? AppColors.primaryColor : Colors.black87)),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                            const SizedBox(height: 28),
                          ],

                          const Divider(height: 1),
                          const SizedBox(height: 20),

                          // ── Reviews Section ───────────────────
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Reviews (${reviews.length})',
                                  style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                            ],
                          ),
                          const SizedBox(height: 16),

                          if (pp.isLoading && reviews.isEmpty)
                            const Center(child: CircularProgressIndicator())
                          else if (reviews.isEmpty)
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 20),
                                child: Text(
                                  'No reviews yet. Be the first!',
                                  style: TextStyle(color: Colors.grey[500], fontSize: 14),
                                ),
                              ),
                            )
                          else
                            ...reviews.map(_buildReviewCard),

                          const SizedBox(height: 28),
                          const Divider(height: 1),
                          const SizedBox(height: 20),

                          // ── Add Review / Blocked Messages ─────
                          if (!auth.isAuthenticated)
                            _infoBox(
                              icon: Icons.lock_outline_rounded,
                              color: Colors.orange,
                              title: 'Login Required',
                              message: 'You must be logged in to write a review.',
                            )
                          else if (isOwner)
                            _infoBox(
                              icon: Icons.gavel_rounded,
                              color: Colors.red,
                              title: 'Self-Reviews Not Allowed',
                              message:
                                  'You cannot review your own product. This keeps feedback honest and impartial.',
                            )
                          else ...[
                            const Text('Write a Review',
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 14),

                            // Star Rating Picker
                            Row(children: [
                              const Text('Rating: ',
                                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                              const SizedBox(width: 8),
                              ...List.generate(5, (i) => GestureDetector(
                                onTap: () => setState(() => _submitRating = i + 1),
                                child: Icon(
                                  i < _submitRating ? Icons.star_rounded : Icons.star_border_rounded,
                                  color: Colors.amber[700], size: 30,
                                ),
                              )),
                            ]),
                            const SizedBox(height: 14),

                            // Comment Field
                            TextField(
                              controller: _commentController,
                              maxLines: 4,
                              decoration: InputDecoration(
                                hintText: 'Share your experience with this product...',
                                hintStyle: TextStyle(color: Colors.grey[400], fontSize: 13),
                                fillColor: Colors.white,
                                filled: true,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(color: Colors.grey[300]!),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(color: Colors.grey[300]!),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(color: AppColors.primaryColor, width: 1.5),
                                ),
                                contentPadding: const EdgeInsets.all(14),
                              ),
                            ),
                            const SizedBox(height: 14),

                            SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: ElevatedButton(
                                onPressed: _isSubmittingReview
                                    ? null
                                    : () => _submitReview(auth.token!),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primaryColor,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12)),
                                  elevation: 2,
                                ),
                                child: _isSubmittingReview
                                    ? const SizedBox(
                                        width: 22, height: 22,
                                        child: CircularProgressIndicator(
                                            color: Colors.white, strokeWidth: 2))
                                    : const Text('Submit Review',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold)),
                              ),
                            ),
                          ],

                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ── Bottom Bar (Add to Cart / Owner Controls) ──────
            isOwner
                ? Container(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: const Border(top: BorderSide(color: Color(0xffF1F5F9))),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(0.06),
                            blurRadius: 12,
                            offset: const Offset(0, -4))
                      ],
                    ),
                    child: Row(children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => _confirmDelete(context, auth.token!),
                          child: Container(
                            height: 54,
                            decoration: BoxDecoration(
                              color: Colors.red.shade600,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.red.withOpacity(0.35),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4))
                              ],
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('DELETE',
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 1.2)),
                                SizedBox(width: 8),
                                Icon(Icons.delete_outline, color: Colors.white, size: 20),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: GestureDetector(
                          onTap: () async {
                            final updated = await Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => CreateNew(product: product),
                              ),
                            );
                            if (updated == true) {
                              pp.getProductReviews(product.id);
                            }
                          },
                          child: Container(
                            height: 54,
                            decoration: BoxDecoration(
                              color: AppColors.primaryColor,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                    color: AppColors.primaryColor.withOpacity(0.35),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4))
                              ],
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('EDIT PRODUCT',
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 1.2)),
                                SizedBox(width: 8),
                                Icon(Icons.edit_outlined, color: Colors.white, size: 20),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ]),
                  )
                : Container(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: const Border(top: BorderSide(color: Color(0xffF1F5F9))),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(0.06),
                            blurRadius: 12,
                            offset: const Offset(0, -4))
                      ],
                    ),
                    child: Row(children: [
                      Container(
                        width: 54, height: 54,
                        decoration: BoxDecoration(
                          border: Border.all(color: const Color(0xffE2E8F0), width: 1.5),
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.white,
                        ),
                        child: const Icon(Icons.shopping_bag_outlined, color: Colors.black87),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            if (!auth.isAuthenticated) {
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                content: Text('Please log in to add items to cart.'),
                                backgroundColor: Colors.red,
                              ));
                              return;
                            }
                            if (widget.product.user == auth.currentUser!.id) {
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                content: Text('You cannot buy your own product.'),
                                backgroundColor: Colors.orange,
                              ));
                              return;
                            }
                            _addToCart(auth.token!);
                          },
                          child: Container(
                            height: 54,
                            decoration: BoxDecoration(
                              color: AppColors.primaryColor,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                    color: AppColors.primaryColor.withOpacity(0.35),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4))
                              ],
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('ADD TO CART',
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 1.2)),
                                SizedBox(width: 8),
                                Icon(Icons.shopping_cart_outlined, color: Colors.white, size: 20),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ]),
                  ),
          ],
        ),
      ),
    );
  }

  Widget _infoBox({
    required IconData icon,
    required Color color,
    required String title,
    required String message,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.06),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.4)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 13)),
                const SizedBox(height: 4),
                Text(message,
                    style: TextStyle(color: color.withOpacity(0.8), fontSize: 12, height: 1.5)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
