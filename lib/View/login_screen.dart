import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../Model/user.dart';
import '../Model/user_repository.dart';
import 'home_screen.dart';
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  String? _loginMessage;
  Color _messageColor = Colors.red;
  // final UserRepository _userRepository = UserRepository();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final userDatabase = FirebaseDatabase.instance.ref('users');

  @override
  void initState() {
    super.initState();
  }


  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      String email = _emailController.text;
      String password = _passwordController.text;

      try {
        // Using async/await for cleaner error handling
        UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );

        DatabaseEvent snapshot = await userDatabase.child(userCredential.user!.uid).once();

        // Login Successful
        if (!mounted) return; // Check mounted before using context or setState

        if(snapshot.snapshot.exists && snapshot.snapshot.value != null){
          Map<dynamic, dynamic> userData = snapshot.snapshot.value as Map<dynamic, dynamic>;
          String role = userData['role'];
          setState(() {
            _loginMessage = 'Login Successful!';
            _messageColor = Colors.green;
          });

          _formKey.currentState?.reset();
          _emailController.clear();
          _passwordController.clear();

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomeScreen(title: 'Dashboard', role: role)),
          );
        }


      } on FirebaseAuthException catch (e) {
        if (!mounted) return; // Check mounted before using context or setState

        String errorMessage;
        switch (e.code) {
          case 'user-not-found':
            errorMessage = 'No user found for that email.';
            break;
          case 'invalid-email':
            errorMessage = 'The email address is not valid';
            break;
          case 'user-disabled':
            errorMessage = 'This user account has been disabled';
            break;
          case 'invalid-credential': // This is a common one for wrong email/password
            errorMessage = 'Invalid credentials';
            break;
        // Add more cases as needed based on Firebase Auth error codes
        // See: https://firebase.google.com/docs/auth/admin/errors
          default:
            errorMessage = 'An unexpected error occurred. Please try again.';
        // You might want to log the original error for debugging:
        // print('Firebase Auth Error: ${e.code} - ${e.message}');
        }
        setState(() {
          _loginMessage = errorMessage;
          _messageColor = Colors.red;
        });
      } catch (e) {
        // Catch any other non-FirebaseAuth errors
        if (!mounted) return;

        setState(() {
          _loginMessage = 'An error occurred: ${e.toString()}';
          _messageColor = Colors.red;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              if (_loginMessage != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: Text(
                    _loginMessage!,
                    style: TextStyle(color: _messageColor, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                ),
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
                  }else if (!RegExp(r"^[a-zA-Z0-9_!#$%&'*+/=?`{|}~^.-]+@[a-zA-Z0-9.-]+$").hasMatch(value)) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20.0),
              TextFormField(
                controller: _passwordController,
                obscureText: !_isPasswordVisible,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  labelText: 'Password',
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  floatingLabelBehavior: FloatingLabelBehavior.auto,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }else if (value.length < 6) {
                    return 'Password must be at least 6 characters long';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 30.0),
              ElevatedButton(
                onPressed: _login,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                child: const Text('Login', style: TextStyle(fontSize: 18.0)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
