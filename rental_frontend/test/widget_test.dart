// This is a basic Flutter widget test for the Rental Management app.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:rental_frontend/main.dart';

void main() {
  testWidgets('App loads and shows login screen', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const RentalApp());

    // Wait for the auth check to complete
    await tester.pumpAndSettle();

    // Verify that the login screen is shown
    expect(find.text('Welcome Back'), findsOneWidget);
    expect(find.text('Sign in to your account'), findsOneWidget);
    expect(
      find.byType(TextFormField),
      findsAtLeastNWidgets(2),
    ); // Email and password fields
  });
}
