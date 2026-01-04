import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mobiebox/screens/Authpage.dart';
import 'dart:convert';
import 'dart:ui';

import 'screens/home_page.dart';
// import 'screens/login_page.dart'; // Create this file and move the LoginPage there later

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      scrollBehavior: MyCustomScrollBehavior(),
      title: 'MovieFlix',
      // Ensure your AppTheme is correctly defined in theme/app_theme.dart
      // theme: AppTheme.darkTheme,

      // We use 'initialRoute' instead of 'home' when using named routes
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(),
        '/login': (context) => const AuthPage(),
      },
    );
  }
}

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      };
}