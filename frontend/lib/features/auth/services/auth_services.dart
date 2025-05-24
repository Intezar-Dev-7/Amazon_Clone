import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:frontend/common/widgets/bottom_navigation_bar.dart';
import 'package:frontend/common/widgets/custom_snackbar.dart';
import 'package:frontend/models/user.dart';
import 'package:frontend/providers/user_provider.dart';
import 'package:frontend/utils/constants/api.dart';
import 'package:frontend/utils/constants/error_handling.dart';

import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  // sign Up user
  void signUpUser({
    required BuildContext context,
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      User user = User(
        id: '',
        name: name,
        password: password,
        email: email,
        address: '',
        type: '',
        token: '',
        cart: [],
      );

      http.Response res = await http.post(
        Uri.parse('$uri/api/signup'),
        body: user.toJson(),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      print(res.body);

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          showSnackBar(
            context,
            "Account created , Login with the same credentials",
          );
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  // sign In user
  void signInUser({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    try {
      http.Response res = await http.post(
        Uri.parse('$uri/api/signin'),
        body: jsonEncode({"email": email, "password": password}),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      print(res.body);

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () async {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          Provider.of<UserProvider>(context, listen: false).setUser(res.body);
          await prefs.setString('x-auth-token', jsonDecode(res.body)['token']);

          if (!context.mounted) return; // Check if the widget is still active
          Navigator.pushNamedAndRemoveUntil(
            context,
            BottomNavigationBarWidget.routeName,
            (route) => false,
          );
          // showSnackBar(context, "Login Successfull :)");
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  // get User Data
  void getUserData(BuildContext context) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('x-auth-token');

      if (token == null) {
        prefs.setString('x-auth-token', '');
      }
      var tokenRes = await http.post(
        Uri.parse('$uri/tokenIsValid'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': token!,
        },
      );

      var response = jsonDecode(tokenRes.body);
      if (response == true) {
        // get the user data
        http.Response userRes = await http.get(
          Uri.parse('$uri/'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'x-auth-token': token,
          },
        );

        var userProvider = Provider.of<UserProvider>(context, listen: false);
        userProvider.setUser(userRes.body);
      }
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }
}
