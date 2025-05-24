import 'package:flutter/material.dart';
import 'package:frontend/common/widgets/bottom_navigation_bar.dart';
import 'package:frontend/features/admin/screens/admin_screen.dart';
import 'package:frontend/features/auth/screens/auth_screen.dart';
import 'package:frontend/features/auth/services/auth_services.dart';
import 'package:frontend/providers/user_provider.dart';

import 'package:frontend/router.dart';
import 'package:frontend/utils/constants/colors.dart';
import 'package:provider/provider.dart';

final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

void main() {
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (context) => UserProvider())],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AuthService authService = AuthService();

  @override
  void initState() {
    super.initState();
    authService.getUserData(context);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scaffoldMessengerKey: scaffoldMessengerKey,
      debugShowCheckedModeBanner: false,
      title: 'Amazon Clone',
      theme: ThemeData(
        scaffoldBackgroundColor: backgroundColor,
        colorScheme: ColorScheme.light(onPrimary: secondaryColor),
        appBarTheme: AppBarTheme(
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.black),
        ),
        useMaterial3: true,
      ),

      onGenerateRoute: (settings) => generateRoute(settings),
      home:
          Provider.of<UserProvider>(context).user.token.isNotEmpty
              ? Provider.of<UserProvider>(context).user.type == 'user'
                  ? const BottomNavigationBarWidget()
                  : const AdminScreen()
              : const AuthScreen(),
    );
  }
}
