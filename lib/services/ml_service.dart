import 'dart:math';
import 'package:nutrifit/models/models.dart';

/// Service for mock ML inference (food detection and malnutrition detection)
/// In production, this would use tflite_flutter with real models
class MLService {
  static final Random _random = Random();

  /// Mock food detection via image
  /// In production, this would use tflite_flutter with a food detection model
  static Future<List<Map<String, dynamic>>> detectFoodFromImage(
    String imagePath,
  ) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));

    // Mock food detections (in production, use actual model inference)
    final foodOptions = [
      {
        'name': 'Grilled Chicken Salad',
        'calories': 250,
        'protein': 35,
        'carbs': 10,
        'fats': 8,
      },
      {
        'name': 'Protein Smoothie',
        'calories': 300,
        'protein': 25,
        'carbs': 45,
        'fats': 5,
      },
      {
        'name': 'Quinoa Bowl',
        'calories': 450,
        'protein': 15,
        'carbs': 60,
        'fats': 12,
      },
      {
        'name': 'Salmon with Broccoli',
        'calories': 400,
        'protein': 40,
        'carbs': 15,
        'fats': 18,
      },
      {
        'name': 'Yogurt Parfait',
        'calories': 200,
        'protein': 15,
        'carbs': 35,
        'fats': 3,
      },
    ];

    // Return 2-3 random food items
    foodOptions.shuffle();
    return foodOptions.take(2 + _random.nextInt(2)).toList();
  }

  /// Mock body analysis for malnutrition detection
  /// In production, this would use tflite_flutter with a pose detection/body analysis model
  static Future<MalnutritionResult> detectMalnutrition(
    String imagePath,
    User user,
  ) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));

    // Generate mock malnutrition result
    final riskLevels = ['Low', 'Medium'];
    final labels = [
      'Low muscle mass in arms',
      'Mild muscle deficit',
      'Slight nutritional imbalance',
      'Good muscle tone',
      'Slight dehydration signs',
    ];

    final selectedLabel = labels[_random.nextInt(labels.length)];
    final riskLevel = riskLevels[_random.nextInt(riskLevels.length)];
    final confidence = 0.7 + (_random.nextDouble() * 0.25); // 0.7-0.95

    // Suggest meals and workouts based on detection
    final suggestions = [
      'Try protein-rich meals: Grilled Chicken Salad, Salmon with Broccoli',
      'Increase calorie intake: Protein Smoothie, Quinoa Bowl',
      'Focus on strength training: Bench Press, Deadlifts',
      'Add cardio sessions: Running 30min, Cycling 45min',
      'Ensure adequate hydration (3L+ daily)',
    ];

    suggestions.shuffle();

    return MalnutritionResult(
      detectionLabel: selectedLabel,
      riskLevel: riskLevel,
      suggestions: suggestions.take(3).toList(),
      confidence: confidence,
    );
  }

  /// Check if device has camera available (mock for now)
  static Future<bool> hasCameraAvailable() async {
    return true; // In production, check actual device capabilities
  }
}
