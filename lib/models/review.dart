class Review {
  final String id;
  final String user; // User ID
  final String product; // Product ID
  final String name; // User's screen name
  final int rating;
  final String comment;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Review({
    required this.id,
    required this.user,
    required this.product,
    required this.name,
    required this.rating,
    required this.comment,
    this.createdAt,
    this.updatedAt,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    String userId = '';
    if (json['user'] is Map<String, dynamic>) {
      userId = json['user']['_id'] ?? json['user']['id'] ?? '';
    } else {
      userId = json['user'] ?? '';
    }

    String prodId = '';
    if (json['product'] is Map<String, dynamic>) {
      prodId = json['product']['_id'] ?? json['product']['id'] ?? '';
    } else {
      prodId = json['product'] ?? '';
    }

    return Review(
      id: json['_id'] ?? json['id'] ?? '',
      user: userId,
      product: prodId,
      name: json['name'] ?? '',
      rating: json['rating'] ?? 0,
      comment: json['comment'] ?? '',
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
      'product': product,
      'name': name,
      'rating': rating,
      'comment': comment,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}
