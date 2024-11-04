class User {
  final int id;
  final String name;
  final String email;
  final String? password;
  final DateTime createdAt;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.password,
    required this.createdAt,
  });

  static User fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson({bool includePassword = false}) {
    final data = {
      'id': id,
      'name': name,
      'email': email,
      'created_at': createdAt.toIso8601String(),
    };

    if (includePassword && password != null) {
      data['password'] = password!;
    }

    return data;
  }
}
