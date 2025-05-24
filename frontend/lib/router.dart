import 'package:flutter/material.dart';
import 'package:frontend/common/widgets/bottom_navigation_bar.dart';
import 'package:frontend/features/address/screens/address_screen.dart';
import 'package:frontend/features/admin/screens/add_product_screen.dart';
import 'package:frontend/features/auth/screens/auth_screen.dart';
import 'package:frontend/features/home/screens/category_deals_screen.dart';
import 'package:frontend/features/home/screens/home_screen.dart';
import 'package:frontend/features/order_details/screens/order_details.dart';
import 'package:frontend/features/product_details/screens/product_details_screen.dart';
import 'package:frontend/features/search/screens/search_screen.dart';
import 'package:frontend/models/order.dart';
import 'package:frontend/models/product.dart';

Route<dynamic> generateRoute(RouteSettings routeSettings) {
  switch (routeSettings.name) {
    case AuthScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const AuthScreen(),
      );
    case HomeScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const HomeScreen(),
      );
    case BottomNavigationBarWidget.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const BottomNavigationBarWidget(),
      );
    case AddProductScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const AddProductScreen(),
      );
    case CategoryDealsScreen.routeName:
      var category = routeSettings.arguments as String;
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => CategoryDealsScreen(category: category),
      );
    case SearchScreen.routeName:
      var searchQuery = routeSettings.arguments as String;
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => SearchScreen(searchQuery: searchQuery),
      );
    case ProductDetailsScreen.routeName:
      var product = routeSettings.arguments as Product;
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => ProductDetailsScreen(product: product),
      );
    case AddressScreen.routeName:
      var totalAmount = routeSettings.arguments as String;
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => AddressScreen(totalAmount: totalAmount),
      );
    case OrderDetailScreen.routeName:
      var order = routeSettings.arguments as Order;
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => OrderDetailScreen(order: order),
      );
    default:
      return MaterialPageRoute(
        settings: routeSettings,
        builder:
            (_) => const Scaffold(
              body: Center(child: Text("Page does not exist")),
            ),
      );
  }
}
