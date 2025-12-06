import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_nutrition/main.dart';

void main() {
  testWidgets('App launches and shows splash screen',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MyNutritionApp());

    // Verify splash screen elements
    expect(find.text('My Nutrition'), findsOneWidget);
    expect(find.byIcon(Icons.eco), findsOneWidget);
  });
}
