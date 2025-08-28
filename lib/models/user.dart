class User {
  final int? id;
  final String username;
  final String passwordHash;

  User({this.id, required this.username, required this.passwordHash});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'password': passwordHash,
    };
  }

  User.fromMap(Map<String, dynamic> map)
      : id = map['id'] as int?,
        username = map['username'] as String,
        passwordHash = map['password'] as String;
}
