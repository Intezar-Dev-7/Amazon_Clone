import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend/common/widgets/custom_snackbar.dart';
import 'package:frontend/features/auth/screens/auth_screen.dart';
import 'package:frontend/models/order.dart';
import 'package:frontend/providers/user_provider.dart';
import 'package:frontend/utils/constants/api.dart';
import 'package:frontend/utils/constants/error_handling.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccountServices {
  Future<List<Order>> fetchMyOrders({required BuildContext context}) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    List<Order> orderList = [];

    try {
      http.Response res = await http.get(
        Uri.parse('$uri/api/orders/me'),
        headers: {
          "Content-Type": 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
      );

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          for (int i = 0; i < jsonDecode(res.body).length; i++) {
            orderList.add(Order.fromJson(jsonEncode(jsonDecode(res.body)[i])));
          }
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }

    return orderList;
  }

  void logOut(BuildContext context) async {
    try {
      SharedPreferences sharedPrefernces =
          await SharedPreferences.getInstance();
      await sharedPrefernces.setString('x-auth-token', '');
      Navigator.pushNamedAndRemoveUntil(
        context,
        AuthScreen.routeName,
        (route) => false,
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }
}
