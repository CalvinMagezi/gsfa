import 'package:flutter/material.dart';

class User {
  final String? id;
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? createdAt;
  final String? updatedAt;
  final String? meter_number;
  final String? meter_id;
  final String? userId;

  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.createdAt,
    required this.updatedAt,
    required this.meter_number,
    required this.meter_id,
    required this.userId,
  });
}

class UserProvider with ChangeNotifier {
  User? _user;

  User? get user => _user;

  void setUser(User user) {
    _user = user;
    notifyListeners();
  }

  void resetUser() {
    _user = null;
    notifyListeners();
  }
}
