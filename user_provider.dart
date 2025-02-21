// user_provider.dart
import 'package:flutter/material.dart';
import 'user_model.dart'; // Make sure this is the correct path

class UserModel with ChangeNotifier {
  User? _user;

  User? get user => _user;

  void login(User user) {
    _user = user;
    notifyListeners();
  }

  void logout() {
    _user = null;
    notifyListeners();
  }
}
