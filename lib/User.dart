class User {
  String? _userName;
  String? _password;

  User(String userName, String password){
   this.userName = userName;
   this.password = password;
  }

 String? get getPassword => _password;

  set password(String password) {
    if (password.trim().isEmpty) {
      throw Exception('Password is required');
    }
    _password = password;
  }

  String? get getUserName => _userName;

  set userName(String userName) {
    if (userName.trim().isEmpty) {
      throw Exception('Username is required');
    } else {
      _userName = userName;
    }
  }


}
