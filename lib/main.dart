import 'dart:math';

import 'package:flutter/material.dart';
import 'Model/database_helper.dart';
import 'View/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseHelper().database;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'Inter',
      ),
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _rotationAnimation;
  final double _radius = 120;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    );

    _rotationAnimation = Tween<double>(begin: 0, end: 2 * pi).animate(
      CurvedAnimation(parent: _controller, curve: Curves.linear),
    );

    _controller.repeat();

    Future.delayed(const Duration(seconds: 10), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildCurvedText(String text, double angle) {
    // Split text into characters to position them individually
    final characters = text.split('');
    final characterCount = characters.length;
    final double charAngle = pi / (characterCount / 2);

    return Transform.rotate(
      angle: angle,
      child: SizedBox(
        width: _radius * 2,
        height: _radius * 2,
        child: Stack(
          alignment: Alignment.center,
          children: List.generate(characterCount, (index) {
            final charAngle = -pi/2 + (pi / characterCount) * index;
            return Positioned(
              left: _radius + _radius * cos(charAngle) - 6,
              top: _radius + _radius * sin(charAngle) - 8,
              child: Transform.rotate(
                angle: charAngle + pi/2,
                child: Text(
                  characters[index],
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.blue,
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: AnimatedBuilder(
          animation: _rotationAnimation,
          builder: (context, child) {
            return Stack(
              alignment: Alignment.center,
              children: [
                // Central AUCS text
                const Text(
                  'AUCS',
                  style: TextStyle(
                    fontSize: 60,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),

                // Curved text
                Transform.translate(
                  offset: Offset.zero,
                  child: Transform.rotate(
                    angle: _rotationAnimation.value,
                    child: _buildCurvedText(
                      'Aror University Computer Society ',
                      0,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}