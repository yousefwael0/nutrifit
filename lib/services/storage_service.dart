import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nutrifit/models/models.dart';

/// Service for handling local storage with shared_preferences
class StorageService {
  static late SharedPreferences _prefs;

  static const String _userKey = 'nutrifit_user';
  static const String _favoriteMealsKey = 'nutrifit_favorite_meals';
  static const String _favoriteWorkoutsKey = 'nutrifit_favorite_workouts';
  static const String _recentMealsKey = 'nutrifit_recent_meals';
  static const String _recentWorkoutsKey = 'nutrifit_recent_workouts';

  /// Initialize storage service
  static Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // ==================== User Storage ====================

  /// Save user to local storage
  static Future<bool> saveUser(User user) async {
    return _prefs.setString(_userKey, jsonEncode(user.toJson()));
  }

  /// Get stored user
  static User? getUser() {
    final userJson = _prefs.getString(_userKey);
    if (userJson == null) return null;
    return User.fromJson(jsonDecode(userJson) as Map<String, dynamic>);
  }

  /// Clear user (logout)
  static Future<bool> clearUser() async {
    return _prefs.remove(_userKey);
  }

  // ==================== Favorites Storage ====================

  /// Add meal to favorites
  static Future<bool> addFavoriteMeal(String mealId) async {
    final favorites = getFavoriteMeals();
    if (!favorites.contains(mealId)) {
      favorites.add(mealId);
      return _prefs.setStringList(_favoriteMealsKey, favorites);
    }
    return true;
  }

  /// Remove meal from favorites
  static Future<bool> removeFavoriteMeal(String mealId) async {
    final favorites = getFavoriteMeals();
    favorites.remove(mealId);
    return _prefs.setStringList(_favoriteMealsKey, favorites);
  }

  /// Get favorite meal IDs
  static List<String> getFavoriteMeals() {
    return _prefs.getStringList(_favoriteMealsKey) ?? [];
  }

  /// Check if meal is favorite
  static bool isMealFavorite(String mealId) {
    return getFavoriteMeals().contains(mealId);
  }

  /// Add workout to favorites
  static Future<bool> addFavoriteWorkout(String workoutId) async {
    final favorites = getFavoriteWorkouts();
    if (!favorites.contains(workoutId)) {
      favorites.add(workoutId);
      return _prefs.setStringList(_favoriteWorkoutsKey, favorites);
    }
    return true;
  }

  /// Remove workout from favorites
  static Future<bool> removeFavoriteWorkout(String workoutId) async {
    final favorites = getFavoriteWorkouts();
    favorites.remove(workoutId);
    return _prefs.setStringList(_favoriteWorkoutsKey, favorites);
  }

  /// Get favorite workout IDs
  static List<String> getFavoriteWorkouts() {
    return _prefs.getStringList(_favoriteWorkoutsKey) ?? [];
  }

  /// Check if workout is favorite
  static bool isWorkoutFavorite(String workoutId) {
    return getFavoriteWorkouts().contains(workoutId);
  }

  // ==================== Recents Storage ====================

  /// Add meal to recents
  static Future<bool> addRecentMeal(String mealId) async {
    final recents = getRecentMeals();
    recents.remove(mealId); // Remove if already exists
    recents.insert(0, mealId); // Add to front
    if (recents.length > 10) recents.removeLast(); // Keep only 10 recent items
    return _prefs.setStringList(_recentMealsKey, recents);
  }

  /// Get recent meal IDs
  static List<String> getRecentMeals() {
    return _prefs.getStringList(_recentMealsKey) ?? [];
  }

  /// Add workout to recents
  static Future<bool> addRecentWorkout(String workoutId) async {
    final recents = getRecentWorkouts();
    recents.remove(workoutId); // Remove if already exists
    recents.insert(0, workoutId); // Add to front
    if (recents.length > 10) recents.removeLast(); // Keep only 10 recent items
    return _prefs.setStringList(_recentWorkoutsKey, recents);
  }

  /// Get recent workout IDs
  static List<String> getRecentWorkouts() {
    return _prefs.getStringList(_recentWorkoutsKey) ?? [];
  }

  // ==================== Clear All ====================

  /// Clear all data (for testing or reset)
  static Future<bool> clearAll() async {
    return _prefs.clear();
  }
}
