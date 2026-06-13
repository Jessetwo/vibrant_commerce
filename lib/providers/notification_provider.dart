import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibrant_commerce/models/product.dart';

class AppNotification {
  final String id;
  final String title;
  final String body;
  final DateTime timestamp;
  bool isRead;
  final String? type; // 'buyer_order', 'seller_order', 'payment_verified', 'cart_added'

  AppNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.timestamp,
    this.isRead = false,
    this.type,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'body': body,
        'timestamp': timestamp.toIso8601String(),
        'isRead': isRead,
        'type': type,
      };

  factory AppNotification.fromJson(Map<String, dynamic> json) => AppNotification(
        id: json['id'] ?? '',
        title: json['title'] ?? '',
        body: json['body'] ?? '',
        timestamp: DateTime.tryParse(json['timestamp'] ?? '') ?? DateTime.now(),
        isRead: json['isRead'] ?? false,
        type: json['type'],
      );
}

class NotificationProvider with ChangeNotifier {
  List<AppNotification> _notifications = [];
  List<AppNotification> get notifications => _notifications;
  int get unreadCount => _notifications.where((n) => !n.isRead).length;

  NotificationProvider() {
    _loadFromPrefs();
  }

  Future<void> _loadFromPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final data = prefs.getString('app_notifications');
      if (data != null) {
        final List decoded = json.decode(data);
        _notifications = decoded.map((n) => AppNotification.fromJson(n)).toList();
        _notifications.sort((a, b) => b.timestamp.compareTo(a.timestamp));
        notifyListeners();
      }
    } catch (_) {}
  }

  Future<void> _saveToPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final data = json.encode(_notifications.map((n) => n.toJson()).toList());
      await prefs.setString('app_notifications', data);
    } catch (_) {}
  }

  void addNotification({
    required String title,
    required String body,
    String? type,
  }) {
    final newNotif = AppNotification(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      body: body,
      timestamp: DateTime.now(),
      type: type,
    );
    _notifications.insert(0, newNotif);
    _saveToPrefs();
    notifyListeners();
  }

  void markAsRead(String id) {
    final idx = _notifications.indexWhere((n) => n.id == id);
    if (idx != -1) {
      _notifications[idx].isRead = true;
      _saveToPrefs();
      notifyListeners();
    }
  }

  void markAllAsRead() {
    for (var n in _notifications) {
      n.isRead = true;
    }
    _saveToPrefs();
    notifyListeners();
  }

  void deleteNotification(String id) {
    _notifications.removeWhere((n) => n.id == id);
    _saveToPrefs();
    notifyListeners();
  }

  void clearAll() {
    _notifications.clear();
    _saveToPrefs();
    notifyListeners();
  }

  // Seller Order Simulation
  void checkAndSimulateSellerOrders(List<Product> products, String currentUserId) {
    if (products.isEmpty || currentUserId.isEmpty) return;
    
    // Filter to find products created/owned by this user
    final myProducts = products.where((p) => p.user == currentUserId).toList();
    if (myProducts.isEmpty) return;

    // Roll a random number (20% chance to simulate a sale on home load/refresh)
    final rand = Random();
    if (rand.nextInt(5) == 0) {
      final selectedProduct = myProducts[rand.nextInt(myProducts.length)];
      final buyers = ['Chioma', 'Tunde', 'Amina', 'Emeka', 'Yusuf', 'Bola', 'Zainab', 'Kofi'];
      final buyer = buyers[rand.nextInt(buyers.length)];
      final quantity = rand.nextInt(3) + 1;
      final total = selectedProduct.price * quantity;

      addNotification(
        title: 'New Order Received! 🛍️',
        body: 'User "$buyer" just ordered $quantity x "${selectedProduct.name}". Earnings: ₦${total.toStringAsFixed(0)}',
        type: 'seller_order',
      );
    }
  }

  // Explicit Trigger for manual testing in UI
  void triggerManualSellerOrderSimulation(List<Product> products, String currentUserId) {
    if (products.isEmpty || currentUserId.isEmpty) return;
    
    final myProducts = products.where((p) => p.user == currentUserId).toList();
    if (myProducts.isEmpty) return;

    final rand = Random();
    final selectedProduct = myProducts[rand.nextInt(myProducts.length)];
    final buyers = ['Chidi', 'Funmi', 'Aisha', 'Obinna', 'Fatima', 'Damilola'];
    final buyer = buyers[rand.nextInt(buyers.length)];
    final quantity = rand.nextInt(2) + 1;
    final total = selectedProduct.price * quantity;

    addNotification(
      title: 'New Order Received! 🛍️',
      body: 'User "$buyer" just ordered $quantity x "${selectedProduct.name}". Earnings: ₦${total.toStringAsFixed(0)}',
      type: 'seller_order',
    );
  }
}
