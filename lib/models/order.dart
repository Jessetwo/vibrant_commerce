import 'package:vibrant_commerce/models/user.dart';

class OrderItem {
  final String product; // Product ID
  final String name;
  final double price;
  final int quantity;
  final String? image;

  OrderItem({
    required this.product,
    required this.name,
    required this.price,
    required this.quantity,
    this.image,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    String prodId = '';
    String? img;
    if (json['product'] is Map<String, dynamic>) {
      prodId = json['product']['_id'] ?? json['product']['id'] ?? '';
      var imgsList = json['product']['images'] as List?;
      if (imgsList != null && imgsList.isNotEmpty) {
        img = imgsList.first?.toString();
      }
    } else {
      prodId = json['product'] ?? '';
    }

    img ??= json['image'] ?? json['imagePath'];

    return OrderItem(
      product: prodId,
      name: json['name'] ?? '',
      price: double.tryParse(json['price']?.toString() ?? '0') ?? 0.0,
      quantity: json['quantity'] is String 
          ? (int.tryParse(json['quantity']) ?? 0) 
          : (json['quantity'] ?? 0),
      image: img,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product': product,
      'name': name,
      'price': price,
      'quantity': quantity,
      'qty': quantity,
      if (image != null) 'image': image,
    };
  }
}

class Order {
  final String id;
  final String user;
  final List<OrderItem> items;
  final Address shippingAddress;
  final double totalPrice;
  final String paymentStatus;
  final String? paymentReference;
  final String orderStatus;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Order({
    required this.id,
    required this.user,
    this.items = const [],
    required this.shippingAddress,
    required this.totalPrice,
    this.paymentStatus = 'pending',
    this.paymentReference,
    this.orderStatus = 'processing',
    this.createdAt,
    this.updatedAt,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    var itemsList = json['items'] as List?;
    List<OrderItem> parsedItems = itemsList != null
        ? itemsList.map((i) => OrderItem.fromJson(i)).toList()
        : [];

    String userId = '';
    if (json['user'] is Map<String, dynamic>) {
      userId = json['user']['_id'] ?? json['user']['id'] ?? '';
    } else {
      userId = json['user']?.toString() ?? '';
    }

    return Order(
      id: json['_id'] ?? json['id'] ?? '',
      user: userId,
      items: parsedItems,
      shippingAddress: json['shippingAddress'] != null
          ? Address.fromJson(json['shippingAddress'])
          : Address(
              street: '',
              city: '',
              state: '',
              zipCode: '',
              country: '',
            ),
      totalPrice: double.tryParse(json['totalPrice']?.toString() ?? '0') ?? 0.0,
      paymentStatus: json['paymentStatus'] ?? 'pending',
      paymentReference: json['paymentReference'],
      orderStatus: json['orderStatus'] ?? 'processing',
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      '_id': id,
      'user': user,
      'items': items.map((i) => i.toJson()).toList(),
      'shippingAddress': shippingAddress.toJson(),
      'totalPrice': totalPrice,
      'paymentStatus': paymentStatus,
      'paymentReference': paymentReference,
      'orderStatus': orderStatus,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}
