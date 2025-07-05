import 'package:sqflite/sqflite.dart';
import 'database_helper.dart'; // Adjust path
import 'user.dart'; // Adjust path

class UserRepository {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  // Insert a new user into the database
  Future<int> insertUser(User user) async {
    final db = await _databaseHelper.database;
    // The 'conflictAlgorithm' ensures that if the same username is inserted,
    // it will be replaced (or ignored, or abort, depending on your needs).
    // UNIQUE constraint on username in table definition helps too.
    return await db.insert(
      'users',
      user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace, // Or .ignore
    );
  }

  // Retrieve a user by username
  Future<User?> getUserByUsername(String username) async {
    final db = await _databaseHelper.database;
    List<Map<String, dynamic>> maps = await db.query(
      'users',
      where: 'username = ?',
      whereArgs: [username],
      limit: 1, // Only expect one user with a unique username
    );

    if (maps.isNotEmpty) {
      return User.fromMap(maps.first);
    }
    return null;
  }

  // Validate user credentials
  Future<User?> validateUser(String username, String password) async {
    final db = await _databaseHelper.database;
    List<Map<String, dynamic>> maps = await db.query(
      'users',
      where: 'username = ? AND password = ?',
      whereArgs: [username, password],
      limit: 1,
    );
    if (maps.isNotEmpty) {
      return User.fromMap(maps.first);
    }
    return null; // If a match is found, maps will not be empty
  }

  // Get all users (for testing/admin purposes)
  Future<List<User>> getAllUsers() async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('users');
    return List.generate(maps.length, (i) {
      return User.fromMap(maps[i]);
    });
  }

  // Delete a user
  Future<int> deleteUser(int id) async {
    final db = await _databaseHelper.database;
    return await db.delete(
      'users',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Update a user
  Future<int> updateUser(User user) async {
    final db = await _databaseHelper.database;
    return await db.update(
      'users',
      user.toMap(),
      where: 'id = ?',
      whereArgs: [user.id],
    );
  }
}