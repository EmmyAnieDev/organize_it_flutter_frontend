class User {
  final int? id;
  final String name;
  final String email;
  final String? password;
  final DateTime? createdAt;

  User({
    this.id,
    required this.name,
    required this.email,
    this.password,
    this.createdAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int?,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson({bool includePassword = false}) {
    final data = {
      'id': id,
      'name': name,
      'email': email,
      'created_at': createdAt?.toIso8601String(),
    };

    if (includePassword && password != null) {
      data['password'] = password!;
    }

    return data;
  }
}
