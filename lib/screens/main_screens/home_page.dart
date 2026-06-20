import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vibrant_commerce/components/assets/app_colors.dart';
import 'package:vibrant_commerce/components/widgets/my_text_box.dart';
import 'package:vibrant_commerce/components/widgets/product_card.dart';
import 'package:vibrant_commerce/screens/main_screens/product_details.dart';
import 'package:vibrant_commerce/providers/product_provider.dart';
import 'package:vibrant_commerce/providers/auth_provider.dart';
import 'package:vibrant_commerce/providers/cart_provider.dart';
import 'package:vibrant_commerce/providers/notification_provider.dart';
import 'package:vibrant_commerce/screens/main_screens/notifications_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'All';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchInitialData();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchInitialData() async {
    final productProvider = Provider.of<ProductProvider>(
      context,
      listen: false,
    );
    final auth = Provider.of<AuthProvider>(context, listen: false);
    final notif = Provider.of<NotificationProvider>(context, listen: false);
    await productProvider.getCategories();
    final prods = await productProvider.getProducts();
    if (auth.isAuthenticated) {
      notif.checkAndSimulateSellerOrders(prods, auth.currentUser!.id);
    }
  }

  String _getCategoryImage(String category) {
    final cat = category.toLowerCase();
    if (cat.contains('electron')) return 'assets/images/electronics.png';
    if (cat.contains('fash') ||
        cat.contains('cloth') ||
        cat.contains('shoe') ||
        cat.contains('wear')) {
      return 'assets/images/fashion.png';
    }
    if (cat.contains('home') ||
        cat.contains('furniture') ||
        cat.contains('kitchen')) {
      return 'assets/images/home.png';
    }
    if (cat.contains('beaut') ||
        cat.contains('cosmet') ||
        cat.contains('perfume') ||
        cat.contains('care')) {
      return 'assets/images/beauty.png';
    }
    return 'assets/images/electronics.png'; // default fallback
  }

  void _handleCategoryTap(String category) {
    setState(() {
      _selectedCategory = category;
    });
    final productProvider = Provider.of<ProductProvider>(
      context,
      listen: false,
    );
    if (category == 'All') {
      productProvider.getProducts();
    } else {
      productProvider.getProducts(category: category);
    }
  }

  void _handleSearch(String query) {
    final productProvider = Provider.of<ProductProvider>(
      context,
      listen: false,
    );
    if (query.trim().isEmpty) {
      productProvider.getProducts(
        category: _selectedCategory == 'All' ? null : _selectedCategory,
      );
    } else {
      productProvider.searchProducts(query.trim());
    }
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = context.watch<ProductProvider>();
    final products = productProvider.products;
    final categories = ['All', ...productProvider.categories];
    final isLoading = productProvider.isLoading;

    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth >= 600;
    final isDesktop = screenWidth >= 900;
    final horizontalPadding = isDesktop
        ? 48.0
        : isTablet
        ? 32.0
        : 20.0;
    final gridCrossAxisCount = isDesktop
        ? 4
        : isTablet
        ? 3
        : 2;

    final heroBannerHeight = isTablet ? 240.0 : 180.0;

    return Scaffold(
      backgroundColor: AppColors.tertiaryColor,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            final provider = Provider.of<ProductProvider>(
              context,
              listen: false,
            );
            await provider.getCategories();
            if (_selectedCategory == 'All') {
              await provider.getProducts();
            } else {
              await provider.getProducts(category: _selectedCategory);
            }
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: 20.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Row with Notifications Icon and Badge
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Vibrant Commerce',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff00113A),
                        ),
                      ),
                      Stack(
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.notifications_none_outlined,
                              size: 28,
                              color: Color(0xff00113A),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const NotificationsPage(),
                                ),
                              );
                            },
                          ),
                          Consumer<NotificationProvider>(
                            builder: (context, notif, _) {
                              final count = notif.unreadCount;
                              if (count == 0) return const SizedBox.shrink();
                              return Positioned(
                                right: 6,
                                top: 6,
                                child: Container(
                                  padding: const EdgeInsets.all(2),
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  constraints: const BoxConstraints(
                                    minWidth: 16,
                                    minHeight: 16,
                                  ),
                                  child: Text(
                                    '$count',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Hero Banner
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: SizedBox(
                          width: double.infinity,
                          height: heroBannerHeight,
                          child: Image.asset(
                            'assets/images/Hero_banner.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 20,
                        left: 24,
                        right: 24,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.primaryColor,
                                borderRadius: BorderRadius.circular(100),
                              ),
                              child: const Text(
                                'LIMITED OFFER',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'Season Sale up to 50% Off',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'Discover premium electronics, cosmetics, & apparel.',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Search Bar
                  MyTextBox(
                    hintText: 'Search Products...',
                    prefixIcon: Icons.search,
                    controller: _searchController,
                    onChanged: _handleSearch,
                    onSubmitted: _handleSearch,
                  ),
                  const SizedBox(height: 24),

                  // Categories Section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Categories',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedCategory = 'All';
                          });
                          productProvider.getProducts();
                        },
                        child: Text(
                          'See All',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Horizontal Categories List
                  SizedBox(
                    height: 96,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: categories.length,
                      itemBuilder: (context, index) {
                        final cat = categories[index];
                        final isSelected = cat == _selectedCategory;
                        return GestureDetector(
                          onTap: () => _handleCategoryTap(cat),
                          child: Padding(
                            padding: const EdgeInsets.only(right: 16.0),
                            child: Column(
                              children: [
                                Container(
                                  width: 60,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? AppColors.primaryColor
                                        : Colors.white,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.05),
                                        blurRadius: 4,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                    border: Border.all(
                                      color: isSelected
                                          ? AppColors.primaryColor
                                          : Colors.transparent,
                                      width: 2,
                                    ),
                                  ),
                                  child: Center(
                                    child: cat == 'All'
                                        ? Icon(
                                            Icons.grid_view_rounded,
                                            color: isSelected
                                                ? Colors.white
                                                : Colors.grey,
                                            size: 28,
                                          )
                                        : Image.asset(
                                            _getCategoryImage(cat),
                                            width: 30,
                                            height: 30,
                                            color: isSelected
                                                ? Colors.white
                                                : null,
                                            errorBuilder:
                                                (context, error, stackTrace) {
                                                  return const Icon(
                                                    Icons.category,
                                                    color: Colors.grey,
                                                  );
                                                },
                                          ),
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  cat,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: isSelected
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                    color: isSelected
                                        ? AppColors.primaryColor
                                        : Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  // General Products Title
                  Text(
                    _selectedCategory == 'All'
                        ? 'Our Products'
                        : '$_selectedCategory Products',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Loader or Product Grid
                  if (isLoading && products.isEmpty)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(40.0),
                        child: CircularProgressIndicator(),
                      ),
                    )
                  else if (products.isEmpty)
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(40.0),
                        child: Column(
                          children: [
                            Icon(
                              Icons.shopping_bag_outlined,
                              size: 64,
                              color: Colors.grey.withOpacity(0.5),
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'No products found.',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: products.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: gridCrossAxisCount,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 0.62,
                      ),
                      itemBuilder: (context, index) {
                        final product = products[index];
                        return ProductCard(
                          title: product.name,
                          price: 'N${product.price.toStringAsFixed(2)}',
                          imagePath: product.images.isNotEmpty
                              ? product.images.first
                              : _getCategoryImage(product.category),
                          rating: product.ratings.average,
                          reviewCount: product.ratings.count,
                          ontap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) =>
                                    ProductDetails(product: product),
                              ),
                            );
                          },
                          onAddToCart: () async {
                            final auth = Provider.of<AuthProvider>(context, listen: false);
                            if (!auth.isAuthenticated || auth.currentUser == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Please login to add to cart')),
                              );
                              return;
                            }
                            
                            if (product.user == auth.currentUser!.id) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('You cannot buy your own product'),
                                  backgroundColor: Colors.orange,
                                ),
                              );
                              return;
                            }
                            
                            final cartProvider = Provider.of<CartProvider>(context, listen: false);

                            // Check if product is already in cart
                            final isInCart = cartProvider.cart?.items.any((item) => item.product.id == product.id) ?? false;
                            
                            if (isInCart) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Product already in cart'),
                                  backgroundColor: Colors.orange,
                                ),
                              );
                              return;
                            }

                            final success = await cartProvider.addToCart(
                              productId: product.id,
                              token: auth.token!,
                            );
                            
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(success ? 'Added to cart' : 'Failed to add to cart'),
                                  backgroundColor: success ? Colors.green : Colors.red,
                                ),
                              );
                            }
                          },
                        );
                      },
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
