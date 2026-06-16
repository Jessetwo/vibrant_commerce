import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:vibrant_commerce/models/user.dart';

class AuthProvider with ChangeNotifier {
  static const String _baseUrl = 'https://e-commerce-api-five-gilt.vercel.app/api';

  User? _currentUser;
  String? _token;
  bool _isLoading = false;
  String? _error;

  User? get currentUser => _currentUser;
  String? get token => _token;
  bool get isAuthenticated => _token != null;
  bool get isLoading => _isLoading;
  String? get error => _error;

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
  );

  Future<bool> loginWithGoogle() async {
    _setLoading(true);
    _setError(null);
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        // User cancelled sign-in
        _setLoading(false);
        return false;
      }

      final String name = googleUser.displayName ?? '';
      final String email = googleUser.email;
      final String avatar = googleUser.photoUrl ?? '';
      final String providerId = googleUser.id;

      // Delegate to the existing socialLogin method
      final success = await socialLogin(
        name: name,
        email: email,
        avatar: avatar,
        provider: 'google',
        providerId: providerId,
      );
      
      return success;
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      return false;
    }
  }

  Map<String, String> get _headers {
    final headers = {
      'Content-Type': 'application/json',
    };
    if (_token != null) {
      headers['Authorization'] = 'Bearer $_token';
    }
    return headers;
  }

  void _setLoading(bool val) {
    _isLoading = val;
    notifyListeners();
  }

  void _setError(String? err) {
    _error = err;
    notifyListeners();
  }

  // Clear errors and current authentication states
  void logout() {
    _currentUser = null;
    _token = null;
    _error = null;
    notifyListeners();
  }

  // POST /api/auth/signup
  Future<bool> registerUser({
    required String name,
    required String email,
    required String password,
  }) async {
    _setLoading(true);
    _setError(null);
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/auth/signup'),
        headers: _headers,
        body: json.encode({
          'name': name,
          'email': email,
          'password': password,
        }),
      );

      final responseData = json.decode(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        _token = responseData['token'];
        if (responseData['user'] != null) {
          _currentUser = User.fromJson(responseData['user']);
        }
        _setLoading(false);
        return true;
      } else {
        _setError(responseData['message'] ?? 'Failed to sign up');
        _setLoading(false);
        return false;
      }
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      return false;
    }
  }

  // POST /api/auth/login
  Future<bool> loginUser({
    required String email,
    required String password,
  }) async {
    _setLoading(true);
    _setError(null);
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/auth/login'),
        headers: _headers,
        body: json.encode({
          'email': email,
          'password': password,
        }),
      );

      final responseData = json.decode(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        _token = responseData['token'];
        if (responseData['user'] != null) {
          _currentUser = User.fromJson(responseData['user']);
        }
        _setLoading(false);
        return true;
      } else {
        _setError(responseData['message'] ?? 'Failed to log in');
        _setLoading(false);
        return false;
      }
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      return false;
    }
  }

  // POST /api/auth/social-login
  Future<bool> socialLogin({
    required String name,
    required String email,
    String avatar = '',
    required String provider,
    required String providerId,
  }) async {
    _setLoading(true);
    _setError(null);
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/auth/social-login'),
        headers: _headers,
        body: json.encode({
          'name': name,
          'email': email,
          'avatar': avatar,
          'provider': provider,
          'providerId': providerId,
        }),
      );

      final responseData = json.decode(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        _token = responseData['token'];
        if (responseData['user'] != null) {
          _currentUser = User.fromJson(responseData['user']);
        }
        _setLoading(false);
        return true;
      } else {
        _setError(responseData['message'] ?? 'Social login failed');
        _setLoading(false);
        return false;
      }
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      return false;
    }
  }

  // GET /api/user/profile
  Future<bool> getUserProfile() async {
    _setLoading(true);
    _setError(null);
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/user/profile'),
        headers: _headers,
      );

      final responseData = json.decode(response.body);
      if (response.statusCode == 200) {
        _currentUser = User.fromJson(responseData);
        _setLoading(false);
        return true;
      } else {
        _setError(responseData['message'] ?? 'Failed to fetch profile');
        _setLoading(false);
        return false;
      }
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      return false;
    }
  }

  // PATCH /api/user/profile
  Future<bool> updateUserProfile({
    String? name,
    String? email,
    String? password,
    String? avatar,
  }) async {
    _setLoading(true);
    _setError(null);
    try {
      final bodyMap = <String, dynamic>{};
      if (name != null) bodyMap['name'] = name;
      if (email != null) bodyMap['email'] = email;
      if (password != null) bodyMap['password'] = password;
      if (avatar != null) bodyMap['avatar'] = avatar;

      final response = await http.patch(
        Uri.parse('$_baseUrl/user/profile'),
        headers: _headers,
        body: json.encode(bodyMap),
      );

      final responseData = json.decode(response.body);
      if (response.statusCode == 200) {
        _currentUser = User.fromJson(responseData);
        _setLoading(false);
        return true;
      } else {
        _setError(responseData['message'] ?? 'Failed to update profile');
        _setLoading(false);
        return false;
      }
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      return false;
    }
  }

  // GET /api/user/addresses
  Future<List<Address>> getAddresses() async {
    _setLoading(true);
    _setError(null);
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/user/addresses'),
        headers: _headers,
      );

      final responseData = json.decode(response.body);
      if (response.statusCode == 200) {
        final List<Address> addresses = (responseData as List)
            .map((addr) => Address.fromJson(addr))
            .toList();
        
        // Update local user addresses if user exists
        if (_currentUser != null) {
          _currentUser = User(
            id: _currentUser!.id,
            name: _currentUser!.name,
            email: _currentUser!.email,
            avatar: _currentUser!.avatar,
            role: _currentUser!.role,
            addresses: addresses,
            paymentMethods: _currentUser!.paymentMethods,
          );
        }
        _setLoading(false);
        return addresses;
      } else {
        _setError(responseData['message'] ?? 'Failed to fetch addresses');
        _setLoading(false);
        return [];
      }
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      return [];
    }
  }

  // POST /api/user/addresses
  Future<bool> addAddress({
    required String street,
    required String city,
    required String state,
    required String zipCode,
    required String country,
    bool isDefault = false,
  }) async {
    _setLoading(true);
    _setError(null);
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/user/addresses'),
        headers: _headers,
        body: json.encode({
          'street': street,
          'city': city,
          'state': state,
          'zipCode': zipCode,
          'country': country,
          'isDefault': isDefault,
        }),
      );

      final responseData = json.decode(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        // Appends or refreshes from response, usually returns updated user or address list
        await getAddresses();
        _setLoading(false);
        return true;
      } else {
        _setError(responseData['message'] ?? 'Failed to add address');
        _setLoading(false);
        return false;
      }
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      return false;
    }
  }

  // GET /api/user/payments
  Future<List<PaymentMethod>> getPayments() async {
    _setLoading(true);
    _setError(null);
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/user/payments'),
        headers: _headers,
      );

      final responseData = json.decode(response.body);
      if (response.statusCode == 200) {
        final List<PaymentMethod> payments = (responseData as List)
            .map((p) => PaymentMethod.fromJson(p))
            .toList();

        // Update local user payment methods if user exists
        if (_currentUser != null) {
          _currentUser = User(
            id: _currentUser!.id,
            name: _currentUser!.name,
            email: _currentUser!.email,
            avatar: _currentUser!.avatar,
            role: _currentUser!.role,
            addresses: _currentUser!.addresses,
            paymentMethods: payments,
          );
        }
        _setLoading(false);
        return payments;
      } else {
        _setError(responseData['message'] ?? 'Failed to fetch payments');
        _setLoading(false);
        return [];
      }
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      return [];
    }
  }
}
