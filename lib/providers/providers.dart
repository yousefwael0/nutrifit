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

/// Provider for managing progress tracking with demo data
class ProgressProvider extends ChangeNotifier {
  final List<WeightEntry> _weightHistory = [];
  final List<ActivityEntry> _activityHistory = [];
  final List<DailyNutrition> _nutritionHistory = [];

  List<WeightEntry> get weightHistory => _weightHistory;
  List<ActivityEntry> get activityHistory => _activityHistory;
  List<DailyNutrition> get nutritionHistory => _nutritionHistory;

  /// Initialize with demo data for presentation
  void initializeDemoData() {
    _generateDemoWeightData();
    _generateDemoActivityData();
    _generateDemoNutritionData();
    notifyListeners();
  }

  /// Generate 30 days of realistic weight tracking
  void _generateDemoWeightData() {
    _weightHistory.clear();
    final startDate = DateTime.now().subtract(const Duration(days: 30));
    double currentWeight = 82.5; // Starting weight

    for (int i = 0; i <= 30; i++) {
      final date = startDate.add(Duration(days: i));

      // Realistic weight loss: -0.5 to -0.8 kg per week with fluctuations
      if (i % 7 == 0 && i > 0) {
        currentWeight -= 0.6; // Weekly average loss
      }

      // Daily fluctuations (-0.3 to +0.2 kg)
      final dailyVariation = (i % 3 == 0) ? -0.2 : ((i % 2 == 0) ? 0.1 : -0.1);
      final weight = currentWeight + dailyVariation;

      _weightHistory.add(WeightEntry(
        date: date,
        weight: double.parse(weight.toStringAsFixed(1)),
        note: i == 0
            ? 'Starting weight'
            : (i % 7 == 0 ? 'Weekly check-in' : null),
      ));
    }
  }

  /// Generate 30 days of activity data
  void _generateDemoActivityData() {
    _activityHistory.clear();
    final startDate = DateTime.now().subtract(const Duration(days: 30));

    for (int i = 0; i <= 30; i++) {
      final date = startDate.add(Duration(days: i));

      // Most active on weekdays, less on weekends
      final isWeekend =
          date.weekday == DateTime.saturday || date.weekday == DateTime.sunday;

      final workouts = isWeekend ? (i % 3 == 0 ? 1 : 0) : (i % 2 == 0 ? 2 : 1);
      final meals = isWeekend ? 2 : 3;
      final calories = workouts * 250.0 + (i % 4 == 0 ? 100 : 0);

      _activityHistory.add(ActivityEntry(
        date: date,
        workoutsCompleted: workouts,
        mealsLogged: meals,
        caloriesBurned: calories,
      ));
    }
  }

  /// Generate 7 days of nutrition data
  void _generateDemoNutritionData() {
    _nutritionHistory.clear();
    final startDate = DateTime.now().subtract(const Duration(days: 7));

    for (int i = 0; i <= 7; i++) {
      final date = startDate.add(Duration(days: i));

      // Realistic daily macros
      final calories = 1800 + (i % 3) * 100 - (i % 2) * 50;
      final protein = 120 + (i % 4) * 10;
      final carbs = 180 + (i % 3) * 20;
      final fats = 60 + (i % 2) * 5;

      _nutritionHistory.add(DailyNutrition(
        date: date,
        calories: calories.toDouble(),
        protein: protein.toDouble(),
        carbs: carbs.toDouble(),
        fats: fats.toDouble(),
      ));
    }
  }

  /// Get current weight
  double? get currentWeight =>
      _weightHistory.isNotEmpty ? _weightHistory.last.weight : null;

  /// Get starting weight
  double? get startingWeight =>
      _weightHistory.isNotEmpty ? _weightHistory.first.weight : null;

  /// Get total weight lost
  double get weightLost {
    if (_weightHistory.length < 2) return 0;
    return startingWeight! - currentWeight!;
  }

  /// Get this week's activity count
  int get thisWeekWorkouts {
    final weekAgo = DateTime.now().subtract(const Duration(days: 7));
    return _activityHistory
        .where((entry) => entry.date.isAfter(weekAgo))
        .fold(0, (sum, entry) => sum + entry.workoutsCompleted);
  }

  /// Get this week's calories burned
  double get thisWeekCalories {
    final weekAgo = DateTime.now().subtract(const Duration(days: 7));
    return _activityHistory
        .where((entry) => entry.date.isAfter(weekAgo))
        .fold(0.0, (sum, entry) => sum + entry.caloriesBurned);
  }

  /// Get current streak (consecutive days with activity)
  int get currentStreak {
    if (_activityHistory.isEmpty) return 0;

    int streak = 0;
    final now = DateTime.now();

    for (int i = 0; i < 30; i++) {
      final checkDate = now.subtract(Duration(days: i));
      final activity = _activityHistory.firstWhere(
        (entry) =>
            entry.date.day == checkDate.day &&
            entry.date.month == checkDate.month,
        orElse: () => ActivityEntry(
            date: checkDate,
            workoutsCompleted: 0,
            mealsLogged: 0,
            caloriesBurned: 0),
      );

      if (activity.activityScore > 0) {
        streak++;
      } else {
        break;
      }
    }

    return streak;
  }
}

/// Provider for managing theme (dark mode)
class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;

  ThemeMode get themeMode => _themeMode;
  bool get isDarkMode => _themeMode == ThemeMode.dark;

  /// Initialize theme from storage
  Future<void> initialize() async {
    final isDark = StorageService.getDarkMode();
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  /// Toggle dark mode
  Future<void> toggleTheme() async {
    _themeMode =
        _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    await StorageService.setDarkMode(_themeMode == ThemeMode.dark);
    notifyListeners();
  }
}
