import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend/common/widgets/custom_snackbar.dart';
import 'package:frontend/models/product.dart';
import 'package:frontend/models/user.dart';
import 'package:frontend/providers/user_provider.dart';
import 'package:frontend/utils/constants/api.dart';
import 'package:frontend/utils/constants/error_handling.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class ProductDetailsServices {
  void addToCart({
    required BuildContext context,
    required Product product,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    try {
      http.Response res = await http.post(
        Uri.parse('$uri/api/add-product-to-cart'),
        headers: {
          'Content-Type': 'application/json; chartset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
        body: {
          jsonEncode({'id': product.id!}),
        },
      );
      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          User user = userProvider.user.copyWith(
            cart: jsonDecode(res.body)['cart'],
          );
          userProvider.setUserFromModel(user);
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  void rateProduct({
    required BuildContext context,
    required Product product,
    required double rating,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    try {
      http.Response res = await http.post(
        Uri.parse('$uri/api/rate-proudct'),
        headers: {
          'Content-Type': 'application/json; chartset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
        body: {
          jsonEncode({'id': product.id!, 'rating': rating}),
        },
      );
      httpErrorHandle(response: res, context: context, onSuccess: () {});
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }
}
