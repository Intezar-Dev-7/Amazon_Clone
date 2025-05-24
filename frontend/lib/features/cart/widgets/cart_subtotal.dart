import 'package:flutter/material.dart';
import 'package:frontend/providers/user_provider.dart';
import 'package:provider/provider.dart';

class CartSubtotal extends StatelessWidget {
  const CartSubtotal({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>().user;
    int sum = 0;
    user.cart.map((e) => sum += e['quantity'] * e['product']['price'] as int);

    return Container(
      margin: const EdgeInsets.all(10),
      child: Row(
        children: [
          const Text('subtotal', style: TextStyle(fontSize: 20)),
          Text(
            '\$$sum',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
