import 'package:flutter/material.dart';
import 'package:nutrifit/models/models.dart';
import 'package:nutrifit/services/storage_service.dart';

/// Provider for managing user state
class UserProvider extends ChangeNotifier {
  User? _user;

  User? get user => _user;
  bool get isLoggedIn => _user != null;

  /// Load user from storage
  Future<void> loadUser() async {
    _user = StorageService.getUser();
    notifyListeners();
  }

  /// Login/Register user
  Future<void> loginUser(User user) async {
    _user = user;
    await StorageService.saveUser(user);
    notifyListeners();
  }

  /// Update user profile
  Future<void> updateUser(User updatedUser) async {
    _user = updatedUser;
    await StorageService.saveUser(updatedUser);
    notifyListeners();
  }

  /// Logout user
  Future<void> logout() async {
    _user = null;
    await StorageService.clearUser();
    notifyListeners();
  }
}

/// Provider for managing favorite meals and workouts
class FavoritesProvider extends ChangeNotifier {
  final List<String> _favoriteMeals = [];
  final List<String> _favoriteWorkouts = [];
  List<String> get favoriteMeals => _favoriteMeals;
  List<String> get favoriteWorkouts => _favoriteWorkouts;

  Future<void> initialize() async {
    _favoriteMeals
      ..clear()
      ..addAll(StorageService.getFavoriteMeals());
    _favoriteWorkouts
      ..clear()
      ..addAll(StorageService.getFavoriteWorkouts());
    notifyListeners();
  }

  /// Toggle meal favorite status
  Future<void> toggleMealFavorite(String mealId) async {
    if (_favoriteMeals.contains(mealId)) {
      _favoriteMeals.remove(mealId);
      await StorageService.removeFavoriteMeal(mealId);
    } else {
      _favoriteMeals.add(mealId);
      await StorageService.addFavoriteMeal(mealId);
    }
    notifyListeners();
  }

  /// Check if meal is favorite
  bool isMealFavorite(String mealId) => _favoriteMeals.contains(mealId);

  /// Toggle workout favorite status
  Future<void> toggleWorkoutFavorite(String workoutId) async {
    if (_favoriteWorkouts.contains(workoutId)) {
      _favoriteWorkouts.remove(workoutId);
      await StorageService.removeFavoriteWorkout(workoutId);
    } else {
      _favoriteWorkouts.add(workoutId);
      await StorageService.addFavoriteWorkout(workoutId);
    }
    notifyListeners();
  }

  /// Check if workout is favorite
  bool isWorkoutFavorite(String workoutId) =>
      _favoriteWorkouts.contains(workoutId);
}

/// Provider for managing recents
class RecentsProvider extends ChangeNotifier {
  List<String> _recentMeals = [];
  List<String> _recentWorkouts = [];

  List<String> get recentMeals => _recentMeals;
  List<String> get recentWorkouts => _recentWorkouts;

  /// Initialize recents from storage
  void initialize() {
    _recentMeals = StorageService.getRecentMeals();
    _recentWorkouts = StorageService.getRecentWorkouts();
    notifyListeners();
  }

  /// Add meal to recents
  Future<void> addRecentMeal(String mealId) async {
    await StorageService.addRecentMeal(mealId);
    _recentMeals = StorageService.getRecentMeals();
    notifyListeners();
  }

  /// Add workout to recents
  Future<void> addRecentWorkout(String workoutId) async {
    await StorageService.addRecentWorkout(workoutId);
    _recentWorkouts = StorageService.getRecentWorkouts();
    notifyListeners();
  }
}
