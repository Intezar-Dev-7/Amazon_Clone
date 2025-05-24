import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:frontend/features/account/screens/account_screen.dart';
import 'package:frontend/features/cart/screens/cart_screen.dart';
import 'package:frontend/features/home/screens/home_screen.dart';
import 'package:frontend/providers/user_provider.dart';
import 'package:frontend/utils/constants/colors.dart';
import 'package:badges/badges.dart' as badges;
import 'package:provider/provider.dart';

class BottomNavigationBarWidget extends StatefulWidget {
  static const String routeName = '/bottom-navBar';
  const BottomNavigationBarWidget({super.key});

  @override
  State<BottomNavigationBarWidget> createState() =>
      _BottomNavigationBarWidgetState();
}

class _BottomNavigationBarWidgetState extends State<BottomNavigationBarWidget> {
  int _page = 0;
  double bottomNavigationBarWidth = 42;
  double bottomBarBorderWidth = 5;
  List<Widget> pages = [
    const HomeScreen(),
    const AccountScreen(),
    const CartScreen(),
  ];
  void updatePage(int page) {
    setState(() {
      _page = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    final userCartLen = context.watch<UserProvider>().user.cart.length;
    return Scaffold(
      body: pages[_page],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _page,
        selectedItemColor: selectedNavBarColor,
        unselectedItemColor: unselectedNavBarColor,
        backgroundColor: backgroundColor,
        iconSize: 28,
        onTap: updatePage,
        items: [
          // Homepage
          BottomNavigationBarItem(
            icon: Container(
              width: bottomNavigationBarWidth,
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: _page == 0 ? selectedNavBarColor : backgroundColor,
                    width: bottomBarBorderWidth,
                  ),
                ),
              ),
              child: const Icon(Icons.home_outlined),
            ),
            label: '',
          ),
          // Account
          BottomNavigationBarItem(
            icon: Container(
              width: bottomNavigationBarWidth,
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: _page == 1 ? selectedNavBarColor : backgroundColor,
                    width: bottomBarBorderWidth,
                  ),
                ),
              ),
              child: const Icon(Icons.person_outline_outlined),
            ),
            label: '',
          ),
          // cart
          BottomNavigationBarItem(
            icon: Container(
              width: bottomNavigationBarWidth,
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: _page == 2 ? selectedNavBarColor : backgroundColor,
                    width: bottomBarBorderWidth,
                  ),
                ),
              ),
              child: badges.Badge(
                badgeContent: Text(userCartLen.toString()),
                badgeStyle: BadgeStyle(badgeColor: Colors.white, elevation: 0),
                child: const Icon(Icons.shopping_cart_outlined),
              ),
            ),
            label: '',
          ),
        ],
      ),
    );
  }
}
