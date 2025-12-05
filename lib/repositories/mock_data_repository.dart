import 'package:nutrifit/models/models.dart';

/// Mock data repository with pre-defined meals and workouts
class MockDataRepository {
  /// All available meals
  static final List<Meal> allMeals = [
    // Breakfast
    Meal(
      id: 'meal_001',
      name: 'Oatmeal with Berries',
      category: 'Breakfast',
      ingredients: ['Oats 50g', 'Milk 200ml', 'Blueberries 100g', 'Honey 1tsp'],
      calories: 280,
      protein: 8,
      carbs: 48,
      fats: 5,
      portionSize: 350,
      imageUrl:
          'https://images.unsplash.com/photo-1590411657471-cd5d03b409db?w=500&h=400&fit=crop',
      description:
          'Healthy oatmeal bowl with fresh berries and a drizzle of honey.',
    ),
    Meal(
      id: 'meal_002',
      name: 'Scrambled Eggs with Toast',
      category: 'Breakfast',
      ingredients: [
        'Eggs 2',
        'Whole wheat bread 2 slices',
        'Butter 1tsp',
        'Salt & Pepper',
      ],
      calories: 320,
      protein: 15,
      carbs: 35,
      fats: 12,
      portionSize: 250,
      imageUrl:
          'https://images.unsplash.com/photo-1541519227354-08fa5d50c44d?w=500&h=400&fit=crop',
      description: 'Classic scrambled eggs with whole wheat toast.',
    ),
    Meal(
      id: 'meal_003',
      name: 'Protein Smoothie',
      category: 'Breakfast',
      ingredients: [
        'Protein powder 30g',
        'Banana 1',
        'Almond milk 250ml',
        'Peanut butter 1tbsp',
      ],
      calories: 300,
      protein: 25,
      carbs: 35,
      fats: 8,
      portionSize: 300,
      imageUrl:
          'https://images.unsplash.com/photo-1590410967868-d7cb0d11b416?w=500&h=400&fit=crop',
      description:
          'Delicious protein-packed smoothie perfect for post-workout.',
    ),

    // Lunch
    Meal(
      id: 'meal_004',
      name: 'Grilled Chicken Salad',
      category: 'Lunch',
      ingredients: [
        'Chicken breast 150g',
        'Mixed greens 200g',
        'Tomato 1',
        'Olive oil 1tbsp',
        'Lemon juice',
      ],
      calories: 280,
      protein: 35,
      carbs: 10,
      fats: 12,
      portionSize: 400,
      imageUrl:
          'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=500&h=400&fit=crop',
      description:
          'Lean grilled chicken over fresh mixed greens with light vinaigrette.',
    ),
    Meal(
      id: 'meal_005',
      name: 'Salmon with Broccoli',
      category: 'Lunch',
      ingredients: [
        'Salmon fillet 150g',
        'Broccoli 200g',
        'Olive oil 1tbsp',
        'Garlic 2 cloves',
        'Salt & Pepper',
      ],
      calories: 380,
      protein: 38,
      carbs: 15,
      fats: 18,
      portionSize: 400,
      imageUrl:
          'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=500&h=400&fit=crop',
      description: 'Rich omega-3 salmon with steamed broccoli.',
    ),
    Meal(
      id: 'meal_006',
      name: 'Quinoa Bowl',
      category: 'Lunch',
      ingredients: [
        'Cooked quinoa 150g',
        'Chickpeas 100g',
        'Cucumber 100g',
        'Cherry tomatoes 100g',
        'Tahini dressing',
      ],
      calories: 420,
      protein: 15,
      carbs: 60,
      fats: 14,
      portionSize: 450,
      imageUrl:
          'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=500&h=400&fit=crop',
      description: 'Complete protein quinoa bowl with vegetables.',
    ),

    // Dinner
    Meal(
      id: 'meal_007',
      name: 'Turkey Meatballs with Pasta',
      category: 'Dinner',
      ingredients: [
        'Ground turkey 150g',
        'Pasta 200g',
        'Tomato sauce 1 cup',
        'Garlic',
        'Herbs',
      ],
      calories: 480,
      protein: 32,
      carbs: 55,
      fats: 10,
      portionSize: 500,
      imageUrl:
          'https://images.unsplash.com/photo-1621996346565-e3dbc646d9a9?w=500&h=400&fit=crop',
      description: 'Lean turkey meatballs in homemade tomato sauce.',
    ),
    Meal(
      id: 'meal_008',
      name: 'Beef Stir-Fry',
      category: 'Dinner',
      ingredients: [
        'Lean beef 150g',
        'Mixed vegetables 300g',
        'Brown rice 150g',
        'Soy sauce',
        'Ginger',
      ],
      calories: 450,
      protein: 30,
      carbs: 50,
      fats: 12,
      portionSize: 500,
      imageUrl:
          'https://images.unsplash.com/photo-1609501676725-7186f017a4b0?w=500&h=400&fit=crop',
      description: 'Flavorful stir-fry with lean beef and colorful vegetables.',
    ),
    Meal(
      id: 'meal_009',
      name: 'Baked Cod with Sweet Potato',
      category: 'Dinner',
      ingredients: [
        'Cod fillet 150g',
        'Sweet potato 150g',
        'Asparagus 100g',
        'Olive oil',
        'Lemon',
      ],
      calories: 380,
      protein: 32,
      carbs: 45,
      fats: 8,
      portionSize: 450,
      imageUrl:
          'https://images.unsplash.com/photo-1580822261290-991b38693d1d?w=500&h=400&fit=crop',
      description: 'Baked white fish with roasted sweet potato and asparagus.',
    ),

    // Snacks
    Meal(
      id: 'meal_010',
      name: 'Greek Yogurt with Granola',
      category: 'Snacks',
      ingredients: [
        'Greek yogurt 150g',
        'Granola 50g',
        'Honey 1tbsp',
        'Berries 50g',
      ],
      calories: 250,
      protein: 15,
      carbs: 35,
      fats: 5,
      portionSize: 200,
      imageUrl:
          'https://images.unsplash.com/photo-1488477181946-6428a0291840?w=500&h=400&fit=crop',
      description:
          'Creamy Greek yogurt with crunchy granola and fresh berries.',
    ),
    Meal(
      id: 'meal_011',
      name: 'Almonds & Apple',
      category: 'Snacks',
      ingredients: ['Almonds 30g', 'Apple 1 medium'],
      calories: 200,
      protein: 7,
      carbs: 25,
      fats: 9,
      portionSize: 150,
      imageUrl:
          'https://images.unsplash.com/photo-1599599810694-b5ac4dd1529f?w=500&h=400&fit=crop',
      description: 'Simple, nutritious snack with healthy fats and fiber.',
    ),
    Meal(
      id: 'meal_012',
      name: 'Protein Energy Balls',
      category: 'Snacks',
      ingredients: [
        'Dates 100g',
        'Almonds 50g',
        'Protein powder 20g',
        'Cocoa powder 1tbsp',
      ],
      calories: 220,
      protein: 12,
      carbs: 30,
      fats: 7,
      portionSize: 100,
      imageUrl:
          'https://images.unsplash.com/photo-1599599810694-b5ac4dd1529f?w=500&h=400&fit=crop',
      description: 'Homemade energy balls packed with protein.',
    ),
  ];

  /// Get meals by category
  static List<Meal> getMealsByCategory(String category) {
    return allMeals.where((meal) => meal.category == category).toList();
  }

  // Get all meals
  static List<Meal> getAllMeals() {
    return allMeals;
  }

  /// Get meal by ID
  static Meal? getMealById(String id) {
    try {
      return allMeals.firstWhere((meal) => meal.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Get all meal categories
  static List<String> getAllMealCategories() {
    final categories = <String>{};
    for (var meal in allMeals) {
      categories.add(meal.category);
    }
    return categories.toList();
  }

  // ==================== Workouts ====================

  /// All available workouts
  static final List<Workout> allWorkouts = [
    // Weight Lifting
    Workout(
      id: 'workout_001',
      name: 'Bench Press',
      category: 'Weight Lifting',
      steps: [
        'Lie flat on bench',
        'Grip barbell shoulder-width apart',
        'Lower bar to chest',
        'Push bar up explosively',
        'Repeat for 10-12 reps, 3 sets',
      ],
      targetMuscles: ['Chest', 'Triceps', 'Shoulders'],
      caloriesBurned: 120,
      imageUrl:
          'https://images.unsplash.com/photo-1534438327276-14e5300c3a48?w=500&h=400&fit=crop',
      description: 'Classic upper body compound movement.',
      durationMinutes: 15,
    ),
    Workout(
      id: 'workout_002',
      name: 'Deadlifts',
      category: 'Weight Lifting',
      steps: [
        'Stand with feet hip-width apart',
        'Grip barbell with hands shoulder-width',
        'Keep back straight, engage core',
        'Lift barbell from ground to hip level',
        'Lower with control',
        'Repeat for 6-8 reps, 3 sets',
      ],
      targetMuscles: ['Back', 'Glutes', 'Hamstrings', 'Core'],
      caloriesBurned: 150,
      imageUrl:
          'https://images.unsplash.com/photo-1534438327276-14e5300c3a48?w=500&h=400&fit=crop',
      description: 'Full body compound exercise.',
      durationMinutes: 20,
    ),
    Workout(
      id: 'workout_003',
      name: 'Squats',
      category: 'Weight Lifting',
      steps: [
        'Stand with feet shoulder-width apart',
        'Place barbell on upper back',
        'Lower body by bending knees',
        'Go as low as comfortable',
        'Push through heels to stand up',
        'Repeat for 10-12 reps, 4 sets',
      ],
      targetMuscles: ['Quadriceps', 'Glutes', 'Hamstrings'],
      caloriesBurned: 140,
      imageUrl:
          'https://images.unsplash.com/photo-1534438327276-14e5300c3a48?w=500&h=400&fit=crop',
      description: 'Lower body power movement.',
      durationMinutes: 18,
    ),

    // Cardio
    Workout(
      id: 'workout_004',
      name: 'Running',
      category: 'Cardio',
      steps: [
        'Warm up with 5 min light jog',
        'Run at moderate pace (70% max HR)',
        'Maintain steady breathing',
        'Cool down with 5 min walk',
      ],
      targetMuscles: ['Cardiovascular System', 'Legs'],
      caloriesBurned: 300,
      imageUrl:
          'https://images.unsplash.com/photo-1552602898-5dfa35a236c7?w=500&h=400&fit=crop',
      description: '30-minute steady-state running session.',
      durationMinutes: 30,
    ),
    Workout(
      id: 'workout_005',
      name: 'Cycling',
      category: 'Cardio',
      steps: [
        'Adjust seat height and position',
        'Warm up with 5 min easy pedaling',
        'Cycle at moderate intensity',
        'Vary resistance every 5 minutes',
        'Cool down with 5 min easy pace',
      ],
      targetMuscles: ['Cardiovascular System', 'Legs', 'Core'],
      caloriesBurned: 250,
      imageUrl:
          'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=500&h=400&fit=crop',
      description: '45-minute moderate intensity cycling.',
      durationMinutes: 45,
    ),
    Workout(
      id: 'workout_006',
      name: 'HIIT Training',
      category: 'Cardio',
      steps: [
        'Warm up 2 minutes light cardio',
        '30 seconds high intensity',
        '30 seconds rest',
        'Repeat 8-10 times',
        'Cool down 3 minutes',
      ],
      targetMuscles: ['Cardiovascular System', 'Full Body'],
      caloriesBurned: 280,
      imageUrl:
          'https://images.unsplash.com/photo-1552602898-5dfa35a236c7?w=500&h=400&fit=crop',
      description: 'High-intensity interval training for maximum calorie burn.',
      durationMinutes: 20,
    ),
  ];

  /// Get workouts by category
  static List<Workout> getWorkoutsByCategory(String category) {
    return allWorkouts
        .where((workout) => workout.category == category)
        .toList();
  }

  /// Get workout by ID
  static Workout? getWorkoutById(String id) {
    try {
      return allWorkouts.firstWhere((workout) => workout.id == id);
    } catch (e) {
      return null;
    }
  }

  // Get all workouts
  static List<Workout> getAllWorkouts() {
    return allWorkouts;
  }

  /// Get all workout categories
  static List<String> getAllWorkoutCategories() {
    final categories = <String>{};
    for (var workout in allWorkouts) {
      categories.add(workout.category);
    }
    return categories.toList();
  }
}
