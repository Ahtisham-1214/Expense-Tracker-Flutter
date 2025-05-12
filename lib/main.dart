import 'package:flutter/material.dart';

import 'User.dart';

void main() {
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
      home: const LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  String? _loginMessage;
  Color _messageColor = Colors.red;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() {
    if (_formKey.currentState!.validate()) {
      // Simulate a login process.  Replace this with your actual authentication logic.
      String username = _usernameController.text;
      String password = _passwordController.text;
      try {
        User user = User(username, password);

        setState(() {
          _loginMessage = 'Login Successful!';
          _messageColor = Colors.green;
        });

        _formKey.currentState?.reset();
        _usernameController.clear();
        _passwordController.clear();
      } catch (e) {
        setState(() {
          _loginMessage = e.toString().replaceFirst('Exception:', '');
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
              // Username Input
              TextFormField(
                controller: _usernameController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  labelText: 'Username',
                  prefixIcon: const Icon(Icons.person_outline),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  floatingLabelBehavior: FloatingLabelBehavior.auto,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your username';
                  } else if (value.length < 3) {
                    return 'Username must be at least 3 characters long';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20.0),
              // Password Input
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
                  }
                  return null;
                },
              ),
              const SizedBox(height: 30.0),
              // Login Button
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
