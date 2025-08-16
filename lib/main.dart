// main.dart
import 'package:flutter/material.dart';

import 'package:taftaf/screens/auth/ForgotPassword.dart';
import 'package:taftaf/screens/auth/auth_screen.dart';
import 'package:taftaf/screens/tabs/exchanges_tab.dart';

import 'screens/splash_screen.dart';

import 'screens/home_screen.dart';
import 'screens/profile_screen.dart';

import 'core/theme/app_theme.dart';
// import 'utils/theme.dart';

void main() {
  runApp(TafTafApp());
}

class TafTafApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Taf-Taf Freemium',
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => WelcomeScreen(),
        '/auth': (context) => AuthScreen(),
        '/home': (context) => HomeScreen(),
        '/profile': (context) => ProfileScreen(),
        // '/chat': (context) => ChatScreen(),
        '/exchange': (context) => ExchangesTab(),
        '/forgot-password': (context) => ForgotPasswordScreen(),
      },
    );
  }
}
