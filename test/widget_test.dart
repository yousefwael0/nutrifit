import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nutrifit/main.dart';

void main() {
  testWidgets('App launches and shows splash screen',
      (WidgetTester tester) async {
    await tester.pumpWidget(const NutriFitApp());

    // Verify splash screen elements
    expect(find.text('NutriFit'), findsOneWidget);
    expect(find.byIcon(Icons.eco), findsOneWidget);
  });
}
