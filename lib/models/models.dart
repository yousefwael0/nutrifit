/// User model for storing user profile information
class User {
  final String id;
  final String email;
  final int age;
  final double weight; // in kg
  final double height; // in cm
  final String sex; // 'M' or 'F'
  final double targetWeight; // in kg
  final String? profilePicPath;
  final DateTime createdAt;

  User({
    required this.id,
    required this.email,
    required this.age,
    required this.weight,
    required this.height,
    required this.sex,
    required this.targetWeight,
    this.profilePicPath,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  /// Calculate BMI (Body Mass Index)
  double get bmi => weight / ((height / 100) * (height / 100));

  /// Calculate daily calorie requirement (Mifflin-St Jeor formula)
  double get dailyCalories {
    if (sex == 'M') {
      return (10 * weight) + (6.25 * height) - (5 * age) + 5;
    } else {
      return (10 * weight) + (6.25 * height) - (5 * age) - 161;
    }
  }

  /// Convert to JSON for storage
  Map<String, dynamic> toJson() => {
        'id': id,
        'email': email,
        'age': age,
        'weight': weight,
        'height': height,
        'sex': sex,
        'targetWeight': targetWeight,
        'profilePicPath': profilePicPath,
        'createdAt': createdAt.toIso8601String(),
      };

  /// Create from JSON
  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json['id'] as String,
        email: json['email'] as String,
        age: json['age'] as int,
        weight: (json['weight'] as num).toDouble(),
        height: (json['height'] as num).toDouble(),
        sex: json['sex'] as String,
        targetWeight: (json['targetWeight'] as num).toDouble(),
        profilePicPath: json['profilePicPath'] as String?,
        createdAt: DateTime.parse(json['createdAt'] as String),
      );

  /// Copy with for creating modified instances
  User copyWith({
    String? id,
    String? email,
    int? age,
    double? weight,
    double? height,
    String? sex,
    double? targetWeight,
    String? profilePicPath,
  }) =>
      User(
        id: id ?? this.id,
        email: email ?? this.email,
        age: age ?? this.age,
        weight: weight ?? this.weight,
        height: height ?? this.height,
        sex: sex ?? this.sex,
        targetWeight: targetWeight ?? this.targetWeight,
        profilePicPath: profilePicPath ?? this.profilePicPath,
        createdAt: createdAt,
      );
}

/// Meal model
class Meal {
  final String id;
  final String name;
  final String category; // 'Breakfast', 'Lunch', 'Dinner', 'Snacks'
  final List<String> ingredients;
  final double calories;
  final double protein; // grams
  final double carbs; // grams
  final double fats; // grams
  final double portionSize; // grams
  final String imageUrl;
  final String description;

  Meal({
    required this.id,
    required this.name,
    required this.category,
    required this.ingredients,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fats,
    required this.portionSize,
    required this.imageUrl,
    required this.description,
  });

  /// Convert to JSON
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'category': category,
        'ingredients': ingredients,
        'calories': calories,
        'protein': protein,
        'carbs': carbs,
        'fats': fats,
        'portionSize': portionSize,
        'imageUrl': imageUrl,
        'description': description,
      };

  /// Create from JSON
  factory Meal.fromJson(Map<String, dynamic> json) => Meal(
        id: json['id'] as String,
        name: json['name'] as String,
        category: json['category'] as String,
        ingredients: List<String>.from(json['ingredients'] as List),
        calories: (json['calories'] as num).toDouble(),
        protein: (json['protein'] as num).toDouble(),
        carbs: (json['carbs'] as num).toDouble(),
        fats: (json['fats'] as num).toDouble(),
        portionSize: (json['portionSize'] as num).toDouble(),
        imageUrl: json['imageUrl'] as String,
        description: json['description'] as String,
      );
}

/// Workout model
class Workout {
  final String id;
  final String name;
  final String category; // 'Weight Lifting', 'Cardio'
  final List<String> steps;
  final List<String> targetMuscles;
  final double
      caloriesBurned; // based on 30 min for cardio or per set for lifting
  final String imageUrl;
  final String description;
  final int durationMinutes;

  Workout({
    required this.id,
    required this.name,
    required this.category,
    required this.steps,
    required this.targetMuscles,
    required this.caloriesBurned,
    required this.imageUrl,
    required this.description,
    required this.durationMinutes,
  });

  /// Convert to JSON
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'category': category,
        'steps': steps,
        'targetMuscles': targetMuscles,
        'caloriesBurned': caloriesBurned,
        'imageUrl': imageUrl,
        'description': description,
        'durationMinutes': durationMinutes,
      };

  /// Create from JSON
  factory Workout.fromJson(Map<String, dynamic> json) => Workout(
        id: json['id'] as String,
        name: json['name'] as String,
        category: json['category'] as String,
        steps: List<String>.from(json['steps'] as List),
        targetMuscles: List<String>.from(json['targetMuscles'] as List),
        caloriesBurned: (json['caloriesBurned'] as num).toDouble(),
        imageUrl: json['imageUrl'] as String,
        description: json['description'] as String,
        durationMinutes: json['durationMinutes'] as int,
      );
}

/// Malnutrition detection result
class MalnutritionResult {
  final String detectionLabel;
  final String riskLevel; // 'Low', 'Medium', 'High'
  final List<String> suggestions;
  final double confidence;

  MalnutritionResult({
    required this.detectionLabel,
    required this.riskLevel,
    required this.suggestions,
    required this.confidence,
  });

  Map<String, dynamic> toJson() => {
        'detectionLabel': detectionLabel,
        'riskLevel': riskLevel,
        'suggestions': suggestions,
        'confidence': confidence,
      };

  factory MalnutritionResult.fromJson(Map<String, dynamic> json) =>
      MalnutritionResult(
        detectionLabel: json['detectionLabel'] as String,
        riskLevel: json['riskLevel'] as String,
        suggestions: List<String>.from(json['suggestions'] as List),
        confidence: (json['confidence'] as num).toDouble(),
      );
}

/// Weight entry for tracking progress
class WeightEntry {
  final DateTime date;
  final double weight; // kg
  final String? note;

  WeightEntry({
    required this.date,
    required this.weight,
    this.note,
  });

  Map<String, dynamic> toJson() => {
        'date': date.toIso8601String(),
        'weight': weight,
        'note': note,
      };

  factory WeightEntry.fromJson(Map<String, dynamic> json) => WeightEntry(
        date: DateTime.parse(json['date'] as String),
        weight: (json['weight'] as num).toDouble(),
        note: json['note'] as String?,
      );
}

/// Activity entry for calendar heatmap
class ActivityEntry {
  final DateTime date;
  final int workoutsCompleted;
  final int mealsLogged;
  final double caloriesBurned;

  ActivityEntry({
    required this.date,
    required this.workoutsCompleted,
    required this.mealsLogged,
    required this.caloriesBurned,
  });

  int get activityScore => workoutsCompleted + mealsLogged;

  Map<String, dynamic> toJson() => {
        'date': date.toIso8601String(),
        'workoutsCompleted': workoutsCompleted,
        'mealsLogged': mealsLogged,
        'caloriesBurned': caloriesBurned,
      };

  factory ActivityEntry.fromJson(Map<String, dynamic> json) => ActivityEntry(
        date: DateTime.parse(json['date'] as String),
        workoutsCompleted: json['workoutsCompleted'] as int,
        mealsLogged: json['mealsLogged'] as int,
        caloriesBurned: (json['caloriesBurned'] as num).toDouble(),
      );
}

/// Daily nutrition summary
class DailyNutrition {
  final DateTime date;
  final double calories;
  final double protein;
  final double carbs;
  final double fats;

  DailyNutrition({
    required this.date,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fats,
  });

  Map<String, dynamic> toJson() => {
        'date': date.toIso8601String(),
        'calories': calories,
        'protein': protein,
        'carbs': carbs,
        'fats': fats,
      };

  factory DailyNutrition.fromJson(Map<String, dynamic> json) => DailyNutrition(
        date: DateTime.parse(json['date'] as String),
        calories: (json['calories'] as num).toDouble(),
        protein: (json['protein'] as num).toDouble(),
        carbs: (json['carbs'] as num).toDouble(),
        fats: (json['fats'] as num).toDouble(),
      );
}
