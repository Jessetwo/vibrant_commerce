class Promo {
  final String id;
  final String code;
  final double discount;
  final String type; // 'percentage' or 'flat'
  final DateTime expiryDate;
  final bool isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Promo({
    required this.id,
    required this.code,
    required this.discount,
    this.type = 'percentage',
    required this.expiryDate,
    this.isActive = true,
    this.createdAt,
    this.updatedAt,
  });

  factory Promo.fromJson(Map<String, dynamic> json) {
    return Promo(
      id: json['_id'] ?? json['id'] ?? '',
      code: json['code'] ?? '',
      discount: (json['discount'] ?? 0.0) is int
          ? (json['discount'] as int).toDouble()
          : (json['discount'] ?? 0.0).toDouble(),
      type: json['type'] ?? 'percentage',
      expiryDate: json['expiryDate'] != null
          ? DateTime.tryParse(json['expiryDate']) ?? DateTime.now()
          : DateTime.now(),
      isActive: json['isActive'] ?? true,
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
      'code': code,
      'discount': discount,
      'type': type,
      'expiryDate': expiryDate.toIso8601String(),
      'isActive': isActive,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}
