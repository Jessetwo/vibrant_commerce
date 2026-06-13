import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vibrant_commerce/components/assets/app_colors.dart';
import 'package:vibrant_commerce/components/assets/category_images.dart';
import 'package:vibrant_commerce/components/widgets/product_image.dart';
import 'package:vibrant_commerce/models/product.dart';
import 'package:vibrant_commerce/models/review.dart';
import 'package:vibrant_commerce/providers/auth_provider.dart';
import 'package:vibrant_commerce/providers/product_provider.dart';

class MyReviewsPage extends StatefulWidget {
  const MyReviewsPage({super.key});

  @override
  State<MyReviewsPage> createState() => _MyReviewsPageState();
}

class _MyReviewsPageState extends State<MyReviewsPage> {
  bool _isLoading = true;
  String? _errorMessage;
  final Map<String, List<Review>> _groupedReviews = {};
  List<Product> _myProducts = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchSellerReviews();
    });
  }

  Future<void> _fetchSellerReviews() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final auth = Provider.of<AuthProvider>(context, listen: false);
      final currentUser = auth.currentUser;
      if (currentUser == null) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'User profile not found. Please log in again.';
        });
        return;
      }

      final productProvider = Provider.of<ProductProvider>(context, listen: false);
      
      // Ensure products are loaded
      if (productProvider.products.isEmpty) {
        await productProvider.getProducts();
      }

      _myProducts = productProvider.products
          .where((p) => p.user == currentUser.id)
          .toList();

      _groupedReviews.clear();
      
      // Fetch reviews for each of the seller's products
      for (final prod in _myProducts) {
        final reviews = await productProvider.getProductReviews(prod.id);
        if (reviews.isNotEmpty) {
          _groupedReviews[prod.id] = reviews;
        }
      }
    } catch (e) {
      _errorMessage = 'Failed to fetch reviews: $e';
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Widget _buildReviewCard(Review rev) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xffF8F9FC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xffE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: AppColors.primaryColor.withValues(alpha: 0.15),
                child: Text(
                  rev.name.isNotEmpty ? rev.name[0].toUpperCase() : 'U',
                  style: TextStyle(
                    color: AppColors.primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      rev.name.isNotEmpty ? rev.name : 'Verified Customer',
                      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                    ),
                    Row(
                      children: List.generate(5, (i) => Icon(
                        i < rev.rating ? Icons.star_rounded : Icons.star_border_rounded,
                        color: Colors.amber[700],
                        size: 14,
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
          const SizedBox(height: 8),
          Text(
            rev.comment,
            style: TextStyle(fontSize: 12.5, color: Colors.grey[700], height: 1.45),
          ),
        ],
      ),
    );
  }

  Widget _buildProductGroup(Product product, List<Review> reviews) {
    final double averageRating = product.ratings.average;
    final int count = reviews.length;
    final fallbackImage = categoryFallbackImage(product.category);

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: const Color(0xffF1F5F9)),
      ),
      child: ExpansionTile(
        initiallyExpanded: true,
        shape: const Border(),
        title: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: SizedBox(
                width: 48,
                height: 48,
                child: ProductImage(
                  imagePath: product.images.isNotEmpty ? product.images.first : fallbackImage,
                  category: product.category,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: Color(0xff0f172a),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      ...List.generate(5, (i) => Icon(
                        i < averageRating.round() ? Icons.star_rounded : Icons.star_border_rounded,
                        color: Colors.amber[700],
                        size: 14,
                      )),
                      const SizedBox(width: 6),
                      Text(
                        '($count review${count > 1 ? 's' : ''})',
                        style: TextStyle(color: Colors.grey[500], fontSize: 12),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Column(
              children: [
                const Divider(height: 20),
                ...reviews.map(_buildReviewCard),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final productsWithReviews = _myProducts.where((p) => _groupedReviews.containsKey(p.id)).toList();

    return Scaffold(
      backgroundColor: AppColors.tertiaryColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Product Reviews',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded, color: Colors.black),
            onPressed: _fetchSellerReviews,
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Builder(
            builder: (context) {
              if (_isLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (_errorMessage != null) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline_rounded, color: Colors.red, size: 48),
                      const SizedBox(height: 12),
                      Text(
                        _errorMessage!,
                        style: const TextStyle(color: Colors.red, fontSize: 14),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _fetchSellerReviews,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text('Retry', style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  ),
                );
              }

              if (productsWithReviews.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.rate_review_outlined,
                        size: 64,
                        color: Colors.grey.withValues(alpha: 0.5),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'No reviews on your products yet.',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Keep selling to collect customer feedback!',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                itemCount: productsWithReviews.length,
                itemBuilder: (context, index) {
                  final prod = productsWithReviews[index];
                  final reviews = _groupedReviews[prod.id]!;
                  return _buildProductGroup(prod, reviews);
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
