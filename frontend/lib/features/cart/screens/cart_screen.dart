import 'package:flutter/material.dart';
import 'package:frontend/common/widgets/custom_button.dart';
import 'package:frontend/features/address/screens/address_screen.dart';
import 'package:frontend/features/cart/widgets/cart_product.dart';
import 'package:frontend/features/cart/widgets/cart_subtotal.dart';
import 'package:frontend/features/home/widgets/address_box.dart';
import 'package:frontend/features/search/screens/search_screen.dart';
import 'package:frontend/providers/user_provider.dart';
import 'package:frontend/utils/constants/colors.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  void navigateToSearchScreen(String query) {
    Navigator.pushNamed(context, SearchScreen.routeName, arguments: query);
  }

  void navigateToAddress(int sum) {
    Navigator.pushNamed(
      context,
      AddressScreen.routeName,
      arguments: sum.toString(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>().user;
    int sum = 0;
    user.cart.map((e) => sum += e['quantity']['price'] as int).toList();
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(gradient: appBarGradient),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Container(
                  height: 42,
                  margin: EdgeInsets.only(left: 15),
                  child: Material(
                    borderRadius: BorderRadius.circular(7),
                    elevation: 1,
                    child: TextFormField(
                      onFieldSubmitted: navigateToSearchScreen,
                      decoration: InputDecoration(
                        hintText: 'Search Products',
                        hintStyle: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 17,
                        ),
                        prefixIcon: InkWell(
                          child: const Padding(
                            padding: EdgeInsets.only(left: 6),
                            child: Icon(
                              Icons.search,
                              color: Colors.black,
                              size: 23,
                            ),
                          ),
                        ),
                        fillColor: Colors.white,
                        filled: true,
                        contentPadding: const EdgeInsets.only(top: 10),
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(7)),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(7)),
                          borderSide: BorderSide(
                            color: Colors.black38,
                            width: 1,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              // Microphone Icon
              Container(
                color: Colors.transparent,
                height: 42,
                margin: const EdgeInsets.symmetric(horizontal: 10),
                child: const Icon(Icons.mic, color: Colors.black, size: 25),
              ),
            ],
          ),
        ),
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [
            const AddressBox(),
            const CartSubtotal(),
            Padding(
              padding: const EdgeInsets.all(8),
              child: CustomElevatedButton(
                text: 'Proceed to buy',
                onPressed: () => navigateToAddress(sum),
                color: Colors.yellow[600],
              ),
            ),
            const SizedBox(height: 15),
            Container(color: Colors.black12.withOpacity(0.08), height: 1),
            const SizedBox(height: 5),
            ListView.builder(
              itemCount: user.cart.length,
              shrinkWrap: true,

              itemBuilder: (context, index) {
                return CartProduct(index: index);
              },
            ),
          ],
        ),
      ),
    );
  }
}
