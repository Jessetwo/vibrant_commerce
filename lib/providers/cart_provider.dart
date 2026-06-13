import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:vibrant_commerce/models/cart.dart';

class CartProvider with ChangeNotifier {
  static const String _baseUrl = 'https://e-commerce-api-five-gilt.vercel.app/api';

  Cart? _cart;
  bool _isLoading = false;
  String? _error;

  Cart? get cart => _cart;
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

  Map<String, String> _getHeaders(String token) {
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  // Clear current cart state (on logout)
  void clearCart() {
    _cart = null;
    _error = null;
    notifyListeners();
  }

  // GET /api/cart
  Future<Cart?> getCart(String token) async {
    _setLoading(true);
    _setError(null);
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/cart'),
        headers: _getHeaders(token),
      );

      final responseData = json.decode(response.body);
      if (response.statusCode == 200) {
        _cart = Cart.fromJson(responseData);
        _setLoading(false);
        return _cart;
      } else {
        _setError(responseData['message'] ?? 'Failed to fetch cart');
        _setLoading(false);
        return null;
      }
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      return null;
    }
  }

  // POST /api/cart
  Future<bool> addToCart({
    required String productId,
    int quantity = 1,
    String? size,
    String? color,
    required String token,
  }) async {
    _setLoading(true);
    _setError(null);
    try {
      final Map<String, dynamic> requestBody = {
        'productId': productId,
        'quantity': quantity,
      };
      if (size != null) requestBody['size'] = size;
      if (color != null) requestBody['color'] = color;

      final response = await http.post(
        Uri.parse('$_baseUrl/cart'),
        headers: _getHeaders(token),
        body: json.encode(requestBody),
      );

      final responseData = json.decode(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        // Typically returns the updated cart
        _cart = Cart.fromJson(responseData);
        _setLoading(false);
        return true;
      } else {
        _setError(responseData['message'] ?? 'Failed to add to cart');
        _setLoading(false);
        return false;
      }
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      return false;
    }
  }

  // PATCH /api/cart/item/:itemId
  Future<bool> updateCartItem({
    required String itemId,
    int? quantity,
    String? size,
    String? color,
    required String token,
  }) async {
    _setLoading(true);
    _setError(null);
    try {
      final bodyMap = <String, dynamic>{};
      if (quantity != null) bodyMap['quantity'] = quantity;
      if (size != null) bodyMap['size'] = size;
      if (color != null) bodyMap['color'] = color;

      final response = await http.patch(
        Uri.parse('$_baseUrl/cart/item/$itemId'),
        headers: _getHeaders(token),
        body: json.encode(bodyMap),
      );

      final responseData = json.decode(response.body);
      if (response.statusCode == 200) {
        _cart = Cart.fromJson(responseData);
        _setLoading(false);
        return true;
      } else {
        _setError(responseData['message'] ?? 'Failed to update cart item');
        _setLoading(false);
        return false;
      }
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      return false;
    }
  }

  // DELETE /api/cart/:productId
  Future<bool> removeFromCart(String productId, String token) async {
    _setLoading(true);
    _setError(null);
    try {
      final response = await http.delete(
        Uri.parse('$_baseUrl/cart/$productId'),
        headers: _getHeaders(token),
      );

      final responseData = json.decode(response.body);
      if (response.statusCode == 200) {
        _cart = Cart.fromJson(responseData);
        _setLoading(false);
        return true;
      } else {
        _setError(responseData['message'] ?? 'Failed to remove from cart');
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
