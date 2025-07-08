import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';
import 'home_screen.dart';
import 'login_screen.dart';

class SplashRouter extends StatelessWidget {
  const SplashRouter({super.key});

  Future<Widget> _determineStartScreen() async {
    final user = FirebaseAuth.instance.currentUser;
    final prefs = await SharedPreferences.getInstance();
    final role = prefs.getString('user_role');

    if (user != null && role != null) {
      return HomeScreen(title: 'Dashboard', role: role);
    } else {
      return const LoginScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Widget>(
      future: _determineStartScreen(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return snapshot.data!;
        } else {
          return const SplashScreen(); // Show rotating AUCS while checking
        }
      },
    );
  }
}
