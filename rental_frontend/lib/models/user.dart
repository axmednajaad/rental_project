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
    print('Parsing User from JSON: $json'); // Debug log
    final userId = json['user_id'] ?? json['id'];
    print('Extracted userId: $userId'); // Debug log
    return User(
      userId: userId,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      role: json['role'] ?? 'user',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'name': name,
      'email': email,
      'phone': phone,
      'role': role,
    };
  }

  bool get isAdmin => role.toLowerCase() == 'admin';
}
