import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login_screen.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key, required this.title});

  final String title;

  @override
  _UserProfileScreen createState() => _UserProfileScreen();
}

class _UserProfileScreen extends State<UserProfileScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String _userId = '';

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
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

  Future<void> _save() async {
    if (_formKey.currentState!.validate()) {
      String email = _emailController.text.trim();
      String password = _passwordController.text;

      try {
        final user = FirebaseAuth.instance.currentUser;

        if (user != null) {

          // Now update email and/or password
          await user.updateEmail(email);
          await user.updatePassword(password);


          // Update Firebase Realtime Database
          final DatabaseReference userRef = FirebaseDatabase.instance
              .ref()
              .child('users')
              .child(user.uid);

          await userRef.update({
            'email': email,
          });

          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('User info updated successfully')),
          );

          _logout();
        }
      } on FirebaseAuthException catch (e) {
        debugPrint('FirebaseAuthException: ${e.message}');
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Auth error: ${e.message}')),
        );
      } catch (e) {
        debugPrint('Error: $e');
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating user: $e')),
        );
      }
    }
  }




  Future<void> _loadUserInfo() async {
    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        // Set email from FirebaseAuth
        _emailController.text = user.email ?? '';

        final DatabaseReference userRef =
        FirebaseDatabase.instance.ref().child('users').child(user.uid);

        final DataSnapshot snapshot = await userRef.get();

        if (snapshot.exists) {
          final data = snapshot.value as Map<dynamic, dynamic>;

          String role = data['role'] ?? '';
          String userID = data['userID'] ?? user.uid;

          setState(() {
            _userId = userID;
            // You could store role here too if needed
          });
        } else {
          // Fallback: just set Firebase UID
          setState(() {
            _userId = user.uid;
          });
        }
      }
    } catch (e) {
      print('Error loading user info: $e');
      // You could show a snackbar or dialog here
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Form(
          key: _formKey,
          child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 16.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline, color: Colors.grey),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      _userId.isNotEmpty ? _userId : 'Loading...',
                      style: const TextStyle(fontSize: 16, color: Colors.black87),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20.0),
            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                labelText: 'Email',
                prefixIcon: const Icon(Icons.person_outline),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                floatingLabelBehavior: FloatingLabelBehavior.auto,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your email';
                } else if (!RegExp(
                  r"^[a-zA-Z0-9_!#$%&'*+/=?`{|}~^.-]+@[a-zA-Z0-9.-]+$",
                ).hasMatch(value)) {
                  return 'Please enter a valid email';
                }
                return null;
              },
            ),
            const SizedBox(height: 20.0),
            TextFormField(
              controller: _passwordController,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                labelText: 'Password',
                prefixIcon: const Icon(Icons.lock_outline),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                floatingLabelBehavior: FloatingLabelBehavior.auto,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return null;
                } else if (value.length < 6) {
                  return 'Password must be at least 6 characters long';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _save,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              child: const Text('Save', style: TextStyle(fontSize: 18.0)),
            ),
          ],
        ),
        ),
      ),
    );
  }
}
