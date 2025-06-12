class User {
  final int? userId;
  final String name;
  final String email;
  final String phone;
  final String role;

  User({
    this.userId,
    required this.name,
    required this.email,
    required this.phone,
    required this.role,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['user_id'],
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      role: json['role'] ?? 'user',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'role': role,
    };
  }

  bool get isAdmin => role.toLowerCase() == 'admin';
}
