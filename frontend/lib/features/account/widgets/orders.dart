import 'package:flutter/material.dart';
import 'package:frontend/common/widgets/loader.dart';
import 'package:frontend/features/account/services/account_services.dart';
import 'package:frontend/features/account/widgets/single_product.dart';
import 'package:frontend/features/order_details/screens/order_details.dart';
import 'package:frontend/models/order.dart';
import 'package:frontend/utils/constants/colors.dart';

class Orders extends StatefulWidget {
  const Orders({super.key});

  @override
  State<Orders> createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  List<Order>? orders;

  final AccountServices accountServices = AccountServices();

  @override
  void initState() {
    super.initState();
    fetchOrders();
  }

  void fetchOrders() async {
    orders = await accountServices.fetchMyOrders(context: context);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return orders == null
        ? Loader()
        : Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.only(left: 15),
                  child: const Text(
                    'Your orders ',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(left: 15),
                  child: Text(
                    'See All',
                    style: TextStyle(color: selectedNavBarColor),
                  ),
                ),
              ],
            ),
            // Display orders
            Container(
              height: 170,
              padding: const EdgeInsets.only(left: 10, top: 20, right: 0),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: orders!.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        OrderDetailScreen.routeName,

                        arguments: orders![index],
                      );
                    },
                    child: SingleProduct(
                      image: orders![index].products[0].images[0],
                    ),
                  );
                },
              ),
            ),
          ],
        );
  }
}
