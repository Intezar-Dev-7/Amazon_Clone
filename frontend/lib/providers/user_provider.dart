import 'package:flutter/material.dart';
import 'package:frontend/models/user.dart';

class UserProvider extends ChangeNotifier {
  User _user = User(
    id: '',
    name: '',
    password: '',
    email: '',
    address: '',
    type: '',
    token: '',
    cart: [],
  );

  User get user => _user;

  void setUser(String user) {
    _user = User.fromJson(user);
    notifyListeners();
  }

  void setUserFromModel(User user) {
    _user = user;
    notifyListeners();
  }
}
