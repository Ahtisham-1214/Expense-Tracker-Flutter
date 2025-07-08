import 'package:expense_tracker/View/participant_screen.dart';
import 'package:expense_tracker/View/volunteer_screen.dart';
import 'package:flutter/material.dart';

import '../Model/user.dart';
import '../main.dart';
import 'register_screen.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.title});

  final String title;
  // final User user;

  @override
  State<HomeScreen> createState() => _HomeScreen();
}

class _HomeScreen extends State<HomeScreen> {

  @override
  void initState() {
    super.initState();
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
              leading: const Icon(Icons.person_add),
              title: const Text('Register'),
              onTap: () {
                // if (widget.user.role == "admin") {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const RegisterPage(),
                    ),
                  );
                // } else {
                //   showDialog(
                //     context: context,
                //     builder:
                //         (context) => AlertDialog(
                //       title: const Text('Permission Denied'),
                //       content: const Text(
                //         'Only admins can access this feature',
                //       ),
                //       actions: [
                //         TextButton(
                //           onPressed: () => Navigator.pop(context),
                //           child: const Text('OK'),
                //         ),
                //       ],
                //     ),
                //   );
                // }
              },
            ),

            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
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