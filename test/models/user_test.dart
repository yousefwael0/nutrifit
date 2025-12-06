import 'package:flutter_test/flutter_test.dart';
import 'package:my_nutrition/models/models.dart';

void main() {
  group('User Model Tests', () {
    test('User BMI calculation is correct', () {
      final user = User(
        id: 'test_001',
        email: 'test@example.com',
        age: 25,
        weight: 70, // kg
        height: 175, // cm
        sex: 'M',
        targetWeight: 65,
      );

      // BMI = weight / (height/100)^2
      // 70 / (1.75)^2 = 22.86
      expect(user.bmi, closeTo(22.86, 0.01));
    });

    test('User daily calories calculation (Male)', () {
      final user = User(
        id: 'test_002',
        email: 'test@example.com',
        age: 30,
        weight: 75,
        height: 180,
        sex: 'M',
        targetWeight: 70,
      );

      // Mifflin-St Jeor: (10 * weight) + (6.25 * height) - (5 * age) + 5
      // (10*75) + (6.25*180) - (5*30) + 5 = 1780
      expect(user.dailyCalories, equals(1780));
    });

    test('User daily calories calculation (Female)', () {
      final user = User(
        id: 'test_003',
        email: 'test@example.com',
        age: 25,
        weight: 60,
        height: 165,
        sex: 'F',
        targetWeight: 55,
      );

      // Mifflin-St Jeor: (10 * weight) + (6.25 * height) - (5 * age) - 161
      // (10*60) + (6.25*165) - (5*25) - 161 = 1376.25
      expect(user.dailyCalories, equals(1376.25));
    });
  });
}
