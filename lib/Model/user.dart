// lib/user.dart
class User {
  int? id; // Nullable for when it's not yet in the DB (auto-incremented)
  late String _userName;
  late String _password;
  late String _role;

  User({this.id, required String userName, required String password, required String role})
  {
    this.userName = userName;
    this.password = password;
    this.role = role;
  }


  String get role => _role;

  set role(String value) {
    if (value.trim().isEmpty) {
      _role = "user"; // Basic validation for object creation
    }else {
      _role = value;
    }
  }

  String get password => _password;
  set password(String password) {
    if (password.trim().isEmpty) {
      throw Exception('Password cannot be empty'); // Basic validation for object creation
    }
    _password = password;
  }

  String get userName => _userName;
  set userName(String userName) {
    if (userName.trim().isEmpty) {
      throw Exception('Username cannot be empty'); // Basic validation for object creation
    }
    _userName = userName;
  }

  // Convert a User object into a Map for database insertion/update
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': _userName,
      'password': _password,
      'role': _role,
    };
  }

  // Create a User object from a Map (read from database)
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      userName: map['username'],
      password: map['password'],
      role: map['role'],
    );
  }

  // For debugging
  @override
  String toString() {
    return 'User(id: $id, username: $_userName, password: $_password, role: $role)';
  }
}