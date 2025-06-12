import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user.dart';
import '../models/property.dart';
import '../models/booking.dart';

class ApiService {
  static const String baseUrl = 'http://localhost:3000/api';

  // User endpoints
  static Future<List<User>> getUsers() async {
    final response = await http.get(Uri.parse('$baseUrl/users'));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => User.fromJson(json)).toList();
    }
    throw Exception('Failed to load users');
  }

  static Future<User> getUserById(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/users/$id'));
    if (response.statusCode == 200) {
      return User.fromJson(json.decode(response.body));
    }
    throw Exception('Failed to load user');
  }

  static Future<User> createUser(User user) async {
    final response = await http.post(
      Uri.parse('$baseUrl/users'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(user.toJson()),
    );
    if (response.statusCode == 201) {
      return User.fromJson(json.decode(response.body));
    }
    throw Exception('Failed to create user');
  }

  static Future<void> updateUser(int id, User user) async {
    final response = await http.put(
      Uri.parse('$baseUrl/users/$id'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(user.toJson()),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to update user');
    }
  }

  static Future<void> deleteUser(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/users/$id'));
    if (response.statusCode != 200) {
      throw Exception('Failed to delete user');
    }
  }

  // Authentication endpoints
  static Future<User> loginUser(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'email': email, 'password': password}),
    );

    print('Login Response: ${response.body}');

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return User.fromJson(data['user']);
    } else {
      final error = json.decode(response.body);
      throw Exception(error['error'] ?? 'Login failed');
    }
  }

  static Future<User> registerUser({
    required String name,
    required String email,
    required String phone,
    required String password,
    String role = 'user',
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/register'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'name': name,
        'email': email,
        'phone': phone,
        'password': password,
        'role': role,
      }),
    );

    if (response.statusCode == 201) {
      final data = json.decode(response.body);
      return User.fromJson(data['user']);
    } else {
      final error = json.decode(response.body);
      throw Exception(error['error'] ?? 'Registration failed');
    }
  }

  static Future<void> changePassword({
    required int userId,
    required String currentPassword,
    required String newPassword,
  }) async {
    final response = await http.put(
      Uri.parse('$baseUrl/auth/change-password/$userId'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'currentPassword': currentPassword,
        'newPassword': newPassword,
      }),
    );

    if (response.statusCode != 200) {
      final error = json.decode(response.body);
      throw Exception(error['error'] ?? 'Failed to change password');
    }
  }

  // Property endpoints
  static Future<List<Property>> getProperties() async {
    final response = await http.get(Uri.parse('$baseUrl/properties'));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      print('Properties: $data');
      return data.map((json) => Property.fromJson(json)).toList();
    }
    throw Exception('Failed to load properties');
  }

  static Future<Property> getPropertyById(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/properties/$id'));
    if (response.statusCode == 200) {
      return Property.fromJson(json.decode(response.body));
    }
    throw Exception('Failed to load property');
  }

  static Future<Property> createProperty(Property property) async {
    final response = await http.post(
      Uri.parse('$baseUrl/properties'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(property.toJson()),
    );
    print('Property Creation Response: ${response.body}');
    if (response.statusCode == 201) {
      return Property.fromJson(json.decode(response.body));
    }
    throw Exception('Failed to create property');
  }

  static Future<void> updateProperty(int id, Property property) async {
    final response = await http.put(
      Uri.parse('$baseUrl/properties/$id'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(property.toJson()),
    );
    print('Property Update Response: ${response.body}');
    if (response.statusCode != 200) {
      throw Exception('Failed to update property');
    }
  }

  static Future<void> deleteProperty(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/properties/$id'));
    print('Property Deletion Response: ${response.body}');
    if (response.statusCode != 200) {
      throw Exception('Failed to delete property');
    }
  }

  // Booking endpoints
  static Future<List<Booking>> getBookings() async {
    final response = await http.get(Uri.parse('$baseUrl/bookings'));
    print('Bookings Response: ${response.body}');
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => Booking.fromJson(json)).toList();
    }
    throw Exception('Failed to load bookings');
  }

  static Future<List<Booking>> getUserBookings(int userId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/bookings/user/$userId'),
    );
    print('User Bookings Response: ${response.body}');
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => Booking.fromJson(json)).toList();
    }
    throw Exception('Failed to load user bookings');
  }

  static Future<Booking> createBooking(Booking booking) async {
    final response = await http.post(
      Uri.parse('$baseUrl/bookings'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(booking.toJson()),
    );
    print('Booking Creation Response: ${response.body}');
    if (response.statusCode == 201) {
      return Booking.fromJson(json.decode(response.body));
    }
    throw Exception('Failed to create booking');
  }

  static Future<void> updateBooking(int id, Booking booking) async {
    final response = await http.put(
      Uri.parse('$baseUrl/bookings/$id'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(booking.toJson()),
    );
    print('Booking Update Response: ${response.body}');
    if (response.statusCode != 200) {
      throw Exception('Failed to update booking');
    }
  }

  static Future<void> deleteBooking(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/bookings/$id'));
    if (response.statusCode != 200) {
      throw Exception('Failed to delete booking');
    }
  }
}
