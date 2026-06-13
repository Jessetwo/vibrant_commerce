import 'package:vibrant_commerce/models/product.dart';

class CartItem {
  final String id; // Represents Mongoose subdocument _id
  final Product product;
  final int quantity;
  final String? size;
  final String? color;

  CartItem({
    required this.id,
    required this.product,
    this.quantity = 1,
    this.size,
    this.color,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    Product parsedProduct;
    if (json['product'] is Map<String, dynamic>) {
      parsedProduct = Product.fromJson(json['product']);
    } else {
      // If product is just an ID (String)
      parsedProduct = Product(
        id: json['product'] ?? '',
        name: '',
        description: '',
        price: 0.0,
        category: '',
        ratings: Ratings(),
      );
    }

    return CartItem(
      id: json['_id'] ?? json['id'] ?? '',
      product: parsedProduct,
      quantity: json['quantity'] ?? 1,
      size: json['size'],
      color: json['color'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      '_id': id,
      'product': product.toJson(),
      'quantity': quantity,
      'size': size,
      'color': color,
    };
  }
}

class Cart {
  final String id;
  final String user;
  final List<CartItem> items;

  Cart({required this.id, required this.user, this.items = const []});

  factory Cart.fromJson(Map<String, dynamic> json) {
    var itemsList = json['items'] as List?;
    List<CartItem> parsedItems = itemsList != null
        ? itemsList.map((i) => CartItem.fromJson(i)).toList()
        : [];

    return Cart(
      id: json['_id'] ?? json['id'] ?? '',
      user: json['user'] ?? '',
      items: parsedItems,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      '_id': id,
      'user': user,
      'items': items.map((i) => i.toJson()).toList(),
    };
  }
}
