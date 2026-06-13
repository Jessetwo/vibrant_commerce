class Address {
  final String street;
  final String city;
  final String state;
  final String zipCode;
  final String country;
  final bool isDefault;

  Address({
    required this.street,
    required this.city,
    required this.state,
    required this.zipCode,
    required this.country,
    this.isDefault = false,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      street: json['street'] ?? '',
      city: json['city'] ?? '',
      state: json['state'] ?? '',
      zipCode: json['zipCode'] ?? '',
      country: json['country'] ?? '',
      isDefault: json['isDefault'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'street': street,
      'city': city,
      'state': state,
      'zipCode': zipCode,
      'country': country,
      'isDefault': isDefault,
    };
  }
}

class PaymentMethod {
  final String type;
  final String last4;
  final String brand;
  final int expiryMonth;
  final int expiryYear;

  PaymentMethod({
    required this.type,
    required this.last4,
    required this.brand,
    required this.expiryMonth,
    required this.expiryYear,
  });

  factory PaymentMethod.fromJson(Map<String, dynamic> json) {
    return PaymentMethod(
      type: json['type'] ?? '',
      last4: json['last4'] ?? '',
      brand: json['brand'] ?? '',
      expiryMonth: json['expiryMonth'] is int
          ? json['expiryMonth']
          : int.tryParse(json['expiryMonth']?.toString() ?? '') ?? 0,
      expiryYear: json['expiryYear'] is int
          ? json['expiryYear']
          : int.tryParse(json['expiryYear']?.toString() ?? '') ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'last4': last4,
      'brand': brand,
      'expiryMonth': expiryMonth,
      'expiryYear': expiryYear,
    };
  }
}

class User {
  final String id;
  final String name;
  final String email;
  final String avatar;
  final String role;
  final List<Address> addresses;
  final List<PaymentMethod> paymentMethods;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.avatar = '',
    this.role = 'user',
    this.addresses = const [],
    this.paymentMethods = const [],
  });

  factory User.fromJson(Map<String, dynamic> json) {
    var addrList = json['addresses'] as List?;
    List<Address> parsedAddresses = addrList != null
        ? addrList.map((i) => Address.fromJson(i)).toList()
        : [];

    var payList = json['paymentMethods'] as List?;
    List<PaymentMethod> parsedPaymentMethods = payList != null
        ? payList.map((i) => PaymentMethod.fromJson(i)).toList()
        : [];

    return User(
      id: json['_id'] ?? json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      avatar: json['avatar'] ?? '',
      role: json['role'] ?? 'user',
      addresses: parsedAddresses,
      paymentMethods: parsedPaymentMethods,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      '_id': id,
      'name': name,
      'email': email,
      'avatar': avatar,
      'role': role,
      'addresses': addresses.map((a) => a.toJson()).toList(),
      'paymentMethods': paymentMethods.map((p) => p.toJson()).toList(),
    };
  }
}
