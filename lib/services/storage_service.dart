import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:my_nutrition/models/models.dart';

/// Service for handling local storage with per-user data isolation
class StorageService {
  static late SharedPreferences _prefs;
  static const String _userKey = 'nutrifit_user';
  static const String _allUsersKey = 'nutrifit_all_users'; // ✅ Track all users

  /// Current user's email for namespacing
  static String? _currentUserEmail;

  /// Initialize storage service
  static Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // ==================== User Management ====================

  /// Save user and set as current
  static Future<void> saveUser(User user) async {
    _currentUserEmail = user.email;
    await _prefs.setString(_userKey, jsonEncode(user.toJson()));

    // ✅ Track this user email
    final allUsers = _prefs.getStringList(_allUsersKey) ?? [];
    if (!allUsers.contains(user.email)) {
      allUsers.add(user.email);
      await _prefs.setStringList(_allUsersKey, allUsers);
    }
  }

  /// Get stored user
  static User? getUser() {
    final userJson = _prefs.getString(_userKey);
    if (userJson == null) return null;
    final user = User.fromJson(jsonDecode(userJson) as Map<String, dynamic>);
    _currentUserEmail = user.email;
    return user;
  }

  /// Check if email already has an account
  static bool hasUserWithEmail(String email) {
    final allUsers = _prefs.getStringList(_allUsersKey) ?? [];
    return allUsers.contains(email);
  }

  /// Get user data by email
  static User? getUserByEmail(String email) {
    final userJson = _prefs.getString('${_userKey}_$email');
    if (userJson == null) return null;
    return User.fromJson(jsonDecode(userJson) as Map<String, dynamic>);
  }

  /// Save user data with email namespace
  static Future<void> saveUserData(User user) async {
    await _prefs.setString(
        '${_userKey}_${user.email}', jsonEncode(user.toJson()));
  }

  /// Clear user (logout)
  static Future<void> clearUser() async {
    await _prefs.remove(_userKey);
    _currentUserEmail = null;
  }

  // ==================== Per-User Data Keys ====================

  /// Get user-specific key
  static String _getUserKey(String baseKey) {
    if (_currentUserEmail == null) return baseKey;
    return '${baseKey}_$_currentUserEmail';
  }

  // ==================== Favorites Storage (Per-User) ====================

  static Future<void> addFavoriteMeal(String mealId) async {
    final key = _getUserKey('nutrifit_favorite_meals');
    final favorites = _prefs.getStringList(key) ?? [];
    if (!favorites.contains(mealId)) {
      favorites.add(mealId);
      await _prefs.setStringList(key, favorites);
    }
  }

  static Future<void> removeFavoriteMeal(String mealId) async {
    final key = _getUserKey('nutrifit_favorite_meals');
    final favorites = _prefs.getStringList(key) ?? [];
    favorites.remove(mealId);
    await _prefs.setStringList(key, favorites);
  }

  static List<String> getFavoriteMeals() {
    final key = _getUserKey('nutrifit_favorite_meals');
    return _prefs.getStringList(key) ?? [];
  }

  static Future<void> addFavoriteWorkout(String workoutId) async {
    final key = _getUserKey('nutrifit_favorite_workouts');
    final favorites = _prefs.getStringList(key) ?? [];
    if (!favorites.contains(workoutId)) {
      favorites.add(workoutId);
      await _prefs.setStringList(key, favorites);
    }
  }

  static Future<void> removeFavoriteWorkout(String workoutId) async {
    final key = _getUserKey('nutrifit_favorite_workouts');
    final favorites = _prefs.getStringList(key) ?? [];
    favorites.remove(workoutId);
    await _prefs.setStringList(key, favorites);
  }

  static List<String> getFavoriteWorkouts() {
    final key = _getUserKey('nutrifit_favorite_workouts');
    return _prefs.getStringList(key) ?? [];
  }

  // ==================== Recents Storage (Per-User) ====================

  static Future<void> addRecentMeal(String mealId) async {
    final key = _getUserKey('nutrifit_recent_meals');
    final recents = _prefs.getStringList(key) ?? [];
    recents.remove(mealId);
    recents.insert(0, mealId);
    if (recents.length > 10) recents.removeLast();
    await _prefs.setStringList(key, recents);
  }

  static List<String> getRecentMeals() {
    final key = _getUserKey('nutrifit_recent_meals');
    return _prefs.getStringList(key) ?? [];
  }

  static Future<void> addRecentWorkout(String workoutId) async {
    final key = _getUserKey('nutrifit_recent_workouts');
    final recents = _prefs.getStringList(key) ?? [];
    recents.remove(workoutId);
    recents.insert(0, workoutId);
    if (recents.length > 10) recents.removeLast();
    await _prefs.setStringList(key, recents);
  }

  static List<String> getRecentWorkouts() {
    final key = _getUserKey('nutrifit_recent_workouts');
    return _prefs.getStringList(key) ?? [];
  }

  // ==================== Custom Meals/Workouts (Per-User) ====================

  /// Save custom meal
  static Future<void> saveCustomMeal(Meal meal) async {
    final key = _getUserKey('nutrifit_custom_meals');
    final meals = getCustomMeals();
    meals.add(meal);
    final jsonList = meals.map((m) => jsonEncode(m.toJson())).toList();
    await _prefs.setStringList(key, jsonList);
  }

  /// Get custom meals
  static List<Meal> getCustomMeals() {
    final key = _getUserKey('nutrifit_custom_meals');
    final jsonList = _prefs.getStringList(key) ?? [];
    return jsonList
        .map((json) => Meal.fromJson(jsonDecode(json) as Map<String, dynamic>))
        .toList();
  }

  /// ✅ Update custom meal
  static Future<void> updateCustomMeal(Meal updatedMeal) async {
    final key = _getUserKey('nutrifit_custom_meals');
    final meals = getCustomMeals();
    final index = meals.indexWhere((m) => m.id == updatedMeal.id);
    if (index != -1) {
      meals[index] = updatedMeal;
      final jsonList = meals.map((m) => jsonEncode(m.toJson())).toList();
      await _prefs.setStringList(key, jsonList);
    }
  }

  /// ✅ Delete custom meal
  static Future<void> deleteCustomMeal(String mealId) async {
    final key = _getUserKey('nutrifit_custom_meals');
    final meals = getCustomMeals();
    meals.removeWhere((m) => m.id == mealId);
    final jsonList = meals.map((m) => jsonEncode(m.toJson())).toList();
    await _prefs.setStringList(key, jsonList);
  }

  /// Save custom workout
  static Future<void> saveCustomWorkout(Workout workout) async {
    final key = _getUserKey('nutrifit_custom_workouts');
    final workouts = getCustomWorkouts();
    workouts.add(workout);
    final jsonList = workouts.map((w) => jsonEncode(w.toJson())).toList();
    await _prefs.setStringList(key, jsonList);
  }

  /// Get custom workouts
  static List<Workout> getCustomWorkouts() {
    final key = _getUserKey('nutrifit_custom_workouts');
    final jsonList = _prefs.getStringList(key) ?? [];
    return jsonList
        .map((json) =>
            Workout.fromJson(jsonDecode(json) as Map<String, dynamic>))
        .toList();
  }

  /// ✅ Update custom workout
  static Future<void> updateCustomWorkout(Workout updatedWorkout) async {
    final key = _getUserKey('nutrifit_custom_workouts');
    final workouts = getCustomWorkouts();
    final index = workouts.indexWhere((w) => w.id == updatedWorkout.id);
    if (index != -1) {
      workouts[index] = updatedWorkout;
      final jsonList = workouts.map((w) => jsonEncode(w.toJson())).toList();
      await _prefs.setStringList(key, jsonList);
    }
  }

  /// ✅ Delete custom workout
  static Future<void> deleteCustomWorkout(String workoutId) async {
    final key = _getUserKey('nutrifit_custom_workouts');
    final workouts = getCustomWorkouts();
    workouts.removeWhere((w) => w.id == workoutId);
    final jsonList = workouts.map((w) => jsonEncode(w.toJson())).toList();
    await _prefs.setStringList(key, jsonList);
  }

  // ==================== Clear All ====================

  static Future<void> clearAll() async {
    await _prefs.clear();
  }

  /// Dark mode preference
  static const String _darkModeKey = 'dark_mode';

  static bool getDarkMode() {
    return _prefs.getBool(_darkModeKey) ?? false;
  }

  static Future<void> setDarkMode(bool isDark) async {
    await _prefs.setBool(_darkModeKey, isDark);
  }
}
