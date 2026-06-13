import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:vibrant_commerce/models/product.dart';
import 'package:vibrant_commerce/models/review.dart';

class ProductProvider with ChangeNotifier {
  static const String _baseUrl = 'https://e-commerce-api-five-gilt.vercel.app/api';

  List<Product> _products = [];
  List<Product> _trendingProducts = [];
  List<String> _categories = [];
  List<Review> _currentProductReviews = [];
  Product? _selectedProduct;
  bool _isLoading = false;
  String? _error;

  List<Product> get products => _products;
  List<Product> get trendingProducts => _trendingProducts;
  List<String> get categories => _categories;
  List<Review> get currentProductReviews => _currentProductReviews;
  Product? get selectedProduct => _selectedProduct;
  bool get isLoading => _isLoading;
  String? get error => _error;

  void _setLoading(bool val) {
    _isLoading = val;
    notifyListeners();
  }

  void _setError(String? err) {
    _error = err;
    notifyListeners();
  }

  Map<String, String> _getHeaders([String? token]) {
    final headers = {
      'Content-Type': 'application/json',
    };
    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }
    return headers;
  }

  // GET /api/products
  Future<List<Product>> getProducts({
    String? category,
    int? page,
    int? limit,
  }) async {
    _setLoading(true);
    _setError(null);
    try {
      final queryParams = <String, String>{};
      if (category != null) queryParams['category'] = category;
      if (page != null) queryParams['page'] = page.toString();
      if (limit != null) queryParams['limit'] = limit.toString();

      final uri = Uri.parse('$_baseUrl/products').replace(queryParameters: queryParams);
      final response = await http.get(uri, headers: _getHeaders());

      final responseData = json.decode(response.body);
      if (response.statusCode == 200) {
        // The API might return an array directly, or an object with { products: [...] }
        final List rawProducts = responseData is List 
            ? responseData 
            : (responseData['products'] ?? []);
        
        _products = rawProducts.map((p) => Product.fromJson(p)).toList();
        _setLoading(false);
        return _products;
      } else {
        _setError(responseData['message'] ?? 'Failed to fetch products');
        _setLoading(false);
        return [];
      }
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      return [];
    }
  }

  // GET /api/products/trending
  Future<List<Product>> getTrendingProducts() async {
    _setLoading(true);
    _setError(null);
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/products/trending'),
        headers: _getHeaders(),
      );

      final responseData = json.decode(response.body);
      if (response.statusCode == 200) {
        final List rawProducts = responseData is List 
            ? responseData 
            : (responseData['products'] ?? []);

        _trendingProducts = rawProducts.map((p) => Product.fromJson(p)).toList();
        _setLoading(false);
        return _trendingProducts;
      } else {
        _setError(responseData['message'] ?? 'Failed to fetch trending products');
        _setLoading(false);
        return [];
      }
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      return [];
    }
  }

  // GET /api/products/search
  Future<List<Product>> searchProducts(String keyword) async {
    _setLoading(true);
    _setError(null);
    try {
      final uri = Uri.parse('$_baseUrl/products/search').replace(
        queryParameters: {'keyword': keyword},
      );
      final response = await http.get(uri, headers: _getHeaders());

      final responseData = json.decode(response.body);
      if (response.statusCode == 200) {
        final List rawProducts = responseData is List 
            ? responseData 
            : (responseData['products'] ?? []);

        _products = rawProducts.map((p) => Product.fromJson(p)).toList();
        _setLoading(false);
        return _products;
      } else {
        _setError(responseData['message'] ?? 'Search failed');
        _setLoading(false);
        return [];
      }
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      return [];
    }
  }

  // GET /api/products/categories
  Future<List<String>> getCategories() async {
    _setLoading(true);
    _setError(null);
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/products/categories'),
        headers: _getHeaders(),
      );

      final responseData = json.decode(response.body);
      if (response.statusCode == 200) {
        _categories = (responseData as List).map((c) => c.toString()).toList();
        _setLoading(false);
        return _categories;
      } else {
        _setError(responseData['message'] ?? 'Failed to fetch categories');
        _setLoading(false);
        return [];
      }
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      return [];
    }
  }

  // GET /api/products/:id
  Future<Product?> getProductById(String id) async {
    _setLoading(true);
    _setError(null);
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/products/$id'),
        headers: _getHeaders(),
      );

      final responseData = json.decode(response.body);
      if (response.statusCode == 200) {
        _selectedProduct = Product.fromJson(responseData);
        _setLoading(false);
        return _selectedProduct;
      } else {
        _setError(responseData['message'] ?? 'Failed to fetch product details');
        _setLoading(false);
        return null;
      }
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      return null;
    }
  }

  // GET /api/products/:id/reviews
  Future<List<Review>> getProductReviews(String productId) async {
    _setLoading(true);
    _setError(null);
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/products/$productId/reviews'),
        headers: _getHeaders(),
      );

      final responseData = json.decode(response.body);
      if (response.statusCode == 200) {
        final List rawReviews = responseData is List ? responseData : [];
        _currentProductReviews = rawReviews.map((r) => Review.fromJson(r)).toList();
        _setLoading(false);
        return _currentProductReviews;
      } else {
        _setError(responseData['message'] ?? 'Failed to fetch reviews');
        _setLoading(false);
        return [];
      }
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      return [];
    }
  }

  // POST /api/products (Admin Only)
  Future<bool> createProduct({
    required String name,
    required String description,
    required double price,
    required String category,
    int stock = 0,
    List<String> images = const [],
    List<String> sizes = const [],
    List<String> colors = const [],
    bool isTrending = false,
    required String adminToken,
  }) async {
    _setLoading(true);
    _setError(null);
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/products'),
        headers: _getHeaders(adminToken),
        body: json.encode({
          'name': name,
          'description': description,
          'price': price,
          'category': category,
          'stock': stock,
          'images': images,
          'sizes': sizes,
          'colors': colors,
          'isTrending': isTrending,
        }),
      );

      final responseData = json.decode(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        final newProduct = Product.fromJson(responseData);
        _products.add(newProduct);
        _setLoading(false);
        return true;
      } else {
        _setError(responseData['message'] ?? 'Failed to create product');
        _setLoading(false);
        return false;
      }
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      return false;
    }
  }

  // PUT /api/products/:id (Admin Only)
  Future<bool> updateProduct({
    required String id,
    String? name,
    String? description,
    double? price,
    String? category,
    int? stock,
    List<String>? images,
    List<String>? sizes,
    List<String>? colors,
    bool? isTrending,
    required String adminToken,
  }) async {
    _setLoading(true);
    _setError(null);
    try {
      final bodyMap = <String, dynamic>{};
      if (name != null) bodyMap['name'] = name;
      if (description != null) bodyMap['description'] = description;
      if (price != null) bodyMap['price'] = price;
      if (category != null) bodyMap['category'] = category;
      if (stock != null) bodyMap['stock'] = stock;
      if (images != null) bodyMap['images'] = images;
      if (sizes != null) bodyMap['sizes'] = sizes;
      if (colors != null) bodyMap['colors'] = colors;
      if (isTrending != null) bodyMap['isTrending'] = isTrending;

      final response = await http.put(
        Uri.parse('$_baseUrl/products/$id'),
        headers: _getHeaders(adminToken),
        body: json.encode(bodyMap),
      );

      final responseData = json.decode(response.body);
      if (response.statusCode == 200) {
        final updatedProduct = Product.fromJson(responseData);
        
        final idx = _products.indexWhere((p) => p.id == id);
        if (idx != -1) {
          _products[idx] = updatedProduct;
        }
        
        if (_selectedProduct?.id == id) {
          _selectedProduct = updatedProduct;
        }

        _setLoading(false);
        return true;
      } else {
        _setError(responseData['message'] ?? 'Failed to update product');
        _setLoading(false);
        return false;
      }
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      return false;
    }
  }

  // DELETE /api/products/:id (Admin Only)
  Future<bool> deleteProduct(String id, String adminToken) async {
    _setLoading(true);
    _setError(null);
    try {
      final response = await http.delete(
        Uri.parse('$_baseUrl/products/$id'),
        headers: _getHeaders(adminToken),
      );

      final responseData = json.decode(response.body);
      if (response.statusCode == 200) {
        _products.removeWhere((p) => p.id == id);
        _setLoading(false);
        return true;
      } else {
        _setError(responseData['message'] ?? 'Failed to delete product');
        _setLoading(false);
        return false;
      }
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      return false;
    }
  }

  // POST /api/products/:id/reviews
  Future<bool> createReview({
    required String productId,
    required int rating,
    required String comment,
    required String token,
  }) async {
    _setLoading(true);
    _setError(null);
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/products/$productId/reviews'),
        headers: _getHeaders(token),
        body: json.encode({
          'rating': rating,
          'comment': comment,
        }),
      );

      final responseData = json.decode(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        await getProductReviews(productId);
        _setLoading(false);
        return true;
      } else {
        _setError(responseData['message'] ?? 'Failed to add review');
        _setLoading(false);
        return false;
      }
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      return false;
    }
  }
}
