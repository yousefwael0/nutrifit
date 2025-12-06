import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:my_nutrition/services/storage_service.dart';
import 'package:my_nutrition/models/models.dart';

void main() {
  group('Storage Service Tests', () {
    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      await StorageService.initialize();
    });

    test('Save and retrieve user', () async {
      final user = User(
        id: 'test_001',
        email: 'test@example.com',
        age: 25,
        weight: 70,
        height: 175,
        sex: 'M',
        targetWeight: 65,
      );

      await StorageService.saveUser(user);
      final retrieved = StorageService.getUser();

      expect(retrieved, isNotNull);
      expect(retrieved!.email, equals(user.email));
      expect(retrieved.age, equals(user.age));
    });

    test('Add and retrieve favorite meals', () async {
      await StorageService.addFavoriteMeal('meal_001');
      await StorageService.addFavoriteMeal('meal_002');

      final favorites = StorageService.getFavoriteMeals();

      expect(favorites.length, equals(2));
      expect(favorites, contains('meal_001'));
      expect(favorites, contains('meal_002'));
    });

    test('Remove favorite meal', () async {
      await StorageService.addFavoriteMeal('meal_001');
      await StorageService.removeFavoriteMeal('meal_001');

      final favorites = StorageService.getFavoriteMeals();
      expect(favorites, isEmpty);
    });
  });
}
