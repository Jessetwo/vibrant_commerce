import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:vibrant_commerce/models/order.dart';
import 'package:vibrant_commerce/models/user.dart';
import 'package:vibrant_commerce/models/promo.dart';

class OrderProvider with ChangeNotifier {
  static const String _baseUrl = 'https://e-commerce-api-five-gilt.vercel.app/api';

  List<Order> _myOrders = [];
  Order? _selectedOrder;
  bool _isLoading = false;
  String? _error;
  String? _paymentUrl;
  String? _paymentReference;

  List<Order> get myOrders => _myOrders;
  Order? get selectedOrder => _selectedOrder;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String? get paymentUrl => _paymentUrl;
  String? get paymentReference => _paymentReference;

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

  // Clear orders state (on logout)
  void clearOrders() {
    _myOrders = [];
    _selectedOrder = null;
    _error = null;
    _paymentUrl = null;
    _paymentReference = null;
    notifyListeners();
  }

  // POST /api/orders
  Future<Order?> createOrder({
    required List<OrderItem> items,
    required Address shippingAddress,
    required double totalPrice,
    String? paymentReference,
    required String token,
  }) async {
    _setLoading(true);
    _setError(null);
    _paymentUrl = null;
    _paymentReference = null;
    try {
      final Map<String, dynamic> requestBody = {
        'items': items.map((i) => i.toJson()).toList(),
        'shippingAddress': shippingAddress.toJson(),
        'totalPrice': totalPrice,
      };
      if (paymentReference != null) {
        requestBody['paymentReference'] = paymentReference;
      }

      final response = await http.post(
        Uri.parse('$_baseUrl/orders'),
        headers: _getHeaders(token),
        body: json.encode(requestBody),
      );

      final responseData = json.decode(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        final orderData = responseData['order'] ?? responseData;
        final order = Order.fromJson(orderData);
        _paymentUrl = responseData['paymentUrl'];
        _paymentReference = responseData['reference'] ?? responseData['paymentReference'];
        _myOrders.insert(0, order); // Add to local list
        _setLoading(false);
        return order;
      } else {
        _setError(responseData['message'] ?? 'Failed to create order');
        _setLoading(false);
        return null;
      }
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      return null;
    }
  }

  // GET /api/orders/myorders
  Future<List<Order>> getMyOrders(String token) async {
    _setLoading(true);
    _setError(null);
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/orders/myorders'),
        headers: _getHeaders(token),
      );

      final responseData = json.decode(response.body);
      if (response.statusCode == 200) {
        final List rawOrders = responseData is List ? responseData : [];
        _myOrders = rawOrders.map((o) => Order.fromJson(o)).toList();
        _setLoading(false);
        return _myOrders;
      } else {
        _setError(responseData['message'] ?? 'Failed to fetch my orders');
        _setLoading(false);
        return [];
      }
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      return [];
    }
  }

  // GET /api/orders/verify/:reference
  Future<bool> verifyPayment(String reference, String token) async {
    _setLoading(true);
    _setError(null);
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/orders/verify/$reference'),
        headers: _getHeaders(token),
      );

      final responseData = json.decode(response.body);
      if (response.statusCode == 200) {
        _setLoading(false);
        return responseData['status'] == 'success' || responseData['verified'] == true;
      } else {
        _setError(responseData['message'] ?? 'Payment verification failed');
        _setLoading(false);
        return false;
      }
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      return false;
    }
  }

  // GET /api/orders/:id
  Future<Order?> getOrderById(String id, String token) async {
    _setLoading(true);
    _setError(null);
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/orders/$id'),
        headers: _getHeaders(token),
      );

      final responseData = json.decode(response.body);
      if (response.statusCode == 200) {
        _selectedOrder = Order.fromJson(responseData);
        _setLoading(false);
        return _selectedOrder;
      } else {
        _setError(responseData['message'] ?? 'Failed to fetch order details');
        _setLoading(false);
        return null;
      }
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      return null;
    }
  }

  // POST /api/checkout/validate-promo
  Future<Promo?> validatePromoCode(String code, String token) async {
    _setLoading(true);
    _setError(null);
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/checkout/validate-promo'),
        headers: _getHeaders(token),
        body: json.encode({'code': code}),
      );

      final responseData = json.decode(response.body);
      if (response.statusCode == 200) {
        // Typically returns promo specifications
        final promo = Promo.fromJson(responseData);
        _setLoading(false);
        return promo;
      } else {
        _setError(responseData['message'] ?? 'Invalid promo code');
        _setLoading(false);
        return null;
      }
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      return null;
    }
  }
}
