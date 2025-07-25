import 'package:expense_tracker/View/participant_screen.dart';
import 'package:expense_tracker/View/user_profile.dart';
import 'package:expense_tracker/View/volunteer_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Model/user.dart';
import 'register_screen.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.title, required this.role});

  final String title;
  final String role;

  @override
  State<HomeScreen> createState() => _HomeScreen();
}

class _HomeScreen extends State<HomeScreen> {

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_role');
    await FirebaseAuth.instance.signOut();
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
          (route) => false, // Remove all previous routes
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Theme.of(context).primaryColor,
        centerTitle: true,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: const Text(
                'Navigation Menu',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Profile'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const UserProfileScreen(title: 'User Info'))
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.person_add),
              title: const Text('Register'),
              onTap: () {
                if (widget.role == "admin") {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const RegisterPage(),
                    ),
                  );
                } else {
                  showDialog(
                    context: context,
                    builder:
                        (context) => AlertDialog(
                      title: const Text('Permission Denied'),
                      content: const Text(
                        'Only admins can access this feature',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('OK'),
                        ),
                      ],
                    ),
                  );
                }
              },
            ),

            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () {
                _logout();
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
            // Show an alert dialog when the button is pressed
            showDialog(
              context: context,
              builder: (ctx) => AlertDialog(
                title: const Text("Alert Dialog Box"),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => VolunteerScreen(title: "Volunteer"))
                      );
                    },
                    child: const Text("Volunteer"),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => ParticipantScreen(title: "Participant"))
                      );
                    },
                    child: const Text("Participant"),
                  ),
                ],
              ),
            );
        },
        tooltip: 'Add Log',
        child: const Icon(Icons.add),
      ),
    );
  }
}