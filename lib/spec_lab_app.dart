import 'package:flutter/material.dart';
import 'start_page.dart';
import 'welcome_page.dart';
import 'signin_page.dart';
import 'signup_page.dart';
import 'email_add_page.dart';
import 'dashboard.dart';
import 'building_page.dart' as building; // Add prefix for building_page.dart
import 'profile_page.dart';
import 'builds_page.dart' as builds; // Add prefix for builds_page.dart

class SpecLabApp extends StatelessWidget {
  const SpecLabApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Spec Lab',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Roboto', // Ensure Roboto is added in pubspec.yaml
      ),
      initialRoute: '/', // Ensure StartPage is implemented correctly
      routes: {
        '/': (context) => const StartPage(), // Ensure this class exists
        '/welcome': (context) => const WelcomePage(),
        '/signin': (context) => const SignInPage(),
        '/signup': (context) => const SignUpPage(),
        '/emailAdd': (context) => const EmailAddPage(),
        '/dashboard': (context) => const DashboardPage(),
        '/building': (context) => building.BuildingPage(savedBuilds: []), // Use prefix for BuildingPage
        '/profile': (context) => const ProfilePage(),
        '/builds': (context) => const builds.BuildsPage(), // Use prefix for BuildsPage
      },
    );
  }
}