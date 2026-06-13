class Ratings {
  final double average;
  final int count;

  Ratings({this.average = 0.0, this.count = 0});

  factory Ratings.fromJson(Map<String, dynamic> json) {
    return Ratings(
      average: (json['average'] ?? 0.0) is int
          ? (json['average'] as int).toDouble()
          : (json['average'] ?? 0.0).toDouble(),
      count: json['count'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {'average': average, 'count': count};
  }
}

class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final String category;
  final int stock;
  final List<String> images;
  final List<String> sizes;
  final List<String> colors;
  final bool isTrending;
  final Ratings ratings;
  final String user;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.category,
    this.stock = 0,
    this.images = const [],
    this.sizes = const [],
    this.colors = const [],
    this.isTrending = false,
    required this.ratings,
    this.user = '',
    this.createdAt,
    this.updatedAt,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    var imagesList = json['images'] as List?;
    List<String> parsedImages = imagesList != null
        ? imagesList
              .where(
                (i) =>
                    i != null &&
                    i.toString().trim().isNotEmpty &&
                    i.toString() != 'null',
              )
              .map((i) => i.toString())
              .toList()
        : [];

    var sizesList = json['sizes'] as List?;
    List<String> parsedSizes = sizesList != null
        ? sizesList.map((i) => i.toString()).toList()
        : [];

    var colorsList = json['colors'] as List?;
    List<String> parsedColors = colorsList != null
        ? colorsList.map((i) => i.toString()).toList()
        : [];

    String userId = '';
    if (json['user'] is Map<String, dynamic>) {
      userId = json['user']['_id'] ?? json['user']['id'] ?? '';
    } else {
      userId = json['user']?.toString() ?? '';
    }

    return Product(
      id: json['_id'] ?? json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] ?? 0.0) is int
          ? (json['price'] as int).toDouble()
          : (json['price'] ?? 0.0).toDouble(),
      category: json['category'] ?? '',
      stock: json['stock'] ?? 0,
      images: parsedImages,
      sizes: parsedSizes,
      colors: parsedColors,
      isTrending: json['isTrending'] ?? false,
      ratings: json['ratings'] != null
          ? Ratings.fromJson(json['ratings'])
          : Ratings(),
      user: userId,
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
      'name': name,
      'description': description,
      'price': price,
      'category': category,
      'stock': stock,
      'images': images,
      'sizes': sizes,
      'colors': colors,
      'isTrending': isTrending,
      'ratings': ratings.toJson(),
      'user': user,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}
