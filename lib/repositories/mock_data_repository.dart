import 'package:nutrifit/models/models.dart';

/// Mock data repository with pre-defined meals and workouts
class MockDataRepository {
  /// All available meals
  static final List<Meal> allMeals = [
    // ==================== BREAKFAST ====================
    Meal(
      id: 'meal_001',
      name: 'Oatmeal with Berries',
      category: 'Breakfast',
      ingredients: [
        'Rolled oats 50g',
        'Almond milk 200ml',
        'Mixed berries 100g',
        'Honey 1tsp',
        'Chia seeds 1tbsp'
      ],
      calories: 280,
      protein: 8,
      carbs: 48,
      fats: 5,
      portionSize: 350,
      imageUrl:
          'https://images.unsplash.com/photo-1590301157890-4810ed352733?w=800&q=85',
      description:
          'Creamy oatmeal topped with fresh blueberries, strawberries, and a drizzle of golden honey.',
    ),
    Meal(
      id: 'meal_002',
      name: 'Scrambled Eggs with Avocado Toast',
      category: 'Breakfast',
      ingredients: [
        'Eggs 3',
        'Sourdough bread 2 slices',
        'Avocado 1/2',
        'Cherry tomatoes 5',
        'Butter 1tsp',
      ],
      calories: 420,
      protein: 22,
      carbs: 32,
      fats: 20,
      portionSize: 300,
      imageUrl:
          'https://images.unsplash.com/photo-1525351484163-7529414344d8?w=800&q=85',
      description:
          'Fluffy scrambled eggs served on toasted sourdough with creamy avocado and fresh tomatoes.',
    ),
    Meal(
      id: 'meal_003',
      name: 'Protein Smoothie Bowl',
      category: 'Breakfast',
      ingredients: [
        'Banana 1',
        'Frozen berries 100g',
        'Protein powder 30g',
        'Almond milk 150ml',
        'Granola 30g',
        'Coconut flakes',
      ],
      calories: 340,
      protein: 28,
      carbs: 42,
      fats: 8,
      portionSize: 350,
      imageUrl:
          'https://images.unsplash.com/photo-1590301157890-4810ed352733?w=800&q=85',
      description:
          'Thick acai-style smoothie bowl topped with granola, fresh fruit, and coconut.',
    ),

    // ==================== LUNCH ====================
    Meal(
      id: 'meal_004',
      name: 'Grilled Chicken Caesar Salad',
      category: 'Lunch',
      ingredients: [
        'Grilled chicken breast 150g',
        'Romaine lettuce 150g',
        'Parmesan cheese 20g',
        'Caesar dressing 2tbsp',
        'Croutons 30g',
      ],
      calories: 380,
      protein: 38,
      carbs: 18,
      fats: 16,
      portionSize: 400,
      imageUrl:
          'https://images.unsplash.com/photo-1546793665-c74683f339c1?w=800&q=85',
      description:
          'Classic Caesar with juicy grilled chicken, crisp romaine, parmesan shavings, and homemade croutons.',
    ),
    Meal(
      id: 'meal_005',
      name: 'Teriyaki Salmon Bowl',
      category: 'Lunch',
      ingredients: [
        'Teriyaki glazed salmon 150g',
        'Brown rice 150g',
        'Edamame 50g',
        'Pickled ginger',
        'Sesame seeds',
        'Seaweed',
      ],
      calories: 520,
      protein: 42,
      carbs: 48,
      fats: 18,
      portionSize: 450,
      imageUrl:
          'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=800&q=85',
      description:
          'Japanese-inspired bowl with glazed salmon, fluffy brown rice, edamame, and pickled vegetables.',
    ),
    Meal(
      id: 'meal_006',
      name: 'Mediterranean Quinoa Bowl',
      category: 'Lunch',
      ingredients: [
        'Quinoa 150g',
        'Chickpeas 100g',
        'Cucumber 80g',
        'Cherry tomatoes 80g',
        'Feta cheese 30g',
        'Olives 10',
        'Tahini dressing',
      ],
      calories: 480,
      protein: 18,
      carbs: 58,
      fats: 18,
      portionSize: 500,
      imageUrl:
          'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=800&q=85',
      description:
          'Vibrant Mediterranean bowl with protein-rich quinoa, crispy chickpeas, fresh veggies, and creamy tahini.',
    ),

    // ==================== DINNER ====================
    Meal(
      id: 'meal_007',
      name: 'Spaghetti with Turkey Meatballs',
      category: 'Dinner',
      ingredients: [
        'Whole wheat spaghetti 200g',
        'Turkey meatballs 4pcs (120g)',
        'Marinara sauce 200ml',
        'Fresh basil',
        'Parmesan cheese 15g',
      ],
      calories: 580,
      protein: 38,
      carbs: 68,
      fats: 14,
      portionSize: 550,
      imageUrl:
          'https://images.unsplash.com/photo-1621996346565-e3dbc646d9a9?w=800&q=85',
      description:
          'Classic Italian comfort food with lean turkey meatballs in rich tomato sauce over al dente pasta.',
    ),
    Meal(
      id: 'meal_008',
      name: 'Asian Beef Stir-Fry',
      category: 'Dinner',
      ingredients: [
        'Lean beef strips 150g',
        'Bell peppers 100g',
        'Broccoli 100g',
        'Snap peas 80g',
        'Jasmine rice 150g',
        'Ginger-soy sauce',
      ],
      calories: 520,
      protein: 35,
      carbs: 55,
      fats: 14,
      portionSize: 500,
      imageUrl:
          'https://images.unsplash.com/photo-1603133872878-684f208fb84b?w=800&q=85',
      description:
          'Colorful wok-tossed beef with crisp vegetables in savory ginger-soy glaze over steamed rice.',
    ),
    Meal(
      id: 'meal_009',
      name: 'Herb-Crusted Cod with Roasted Vegetables',
      category: 'Dinner',
      ingredients: [
        'Cod fillet 180g',
        'Sweet potato 150g',
        'Asparagus 100g',
        'Cherry tomatoes 80g',
        'Olive oil 1tbsp',
        'Fresh herbs',
      ],
      calories: 420,
      protein: 38,
      carbs: 42,
      fats: 10,
      portionSize: 480,
      imageUrl:
          'https://images.unsplash.com/photo-1580476262798-bddd9f4b7369?w=800&q=85',
      description:
          'Flaky herb-crusted cod with caramelized sweet potato, tender asparagus, and roasted tomatoes.',
    ),

    // ==================== SNACKS ====================
    Meal(
      id: 'meal_010',
      name: 'Greek Yogurt Parfait',
      category: 'Snacks',
      ingredients: [
        'Greek yogurt 200g',
        'Homemade granola 50g',
        'Fresh berries 80g',
        'Honey drizzle 1tsp',
        'Sliced almonds 10g',
      ],
      calories: 320,
      protein: 20,
      carbs: 38,
      fats: 9,
      portionSize: 300,
      imageUrl:
          'https://images.unsplash.com/photo-1488477181946-6428a0291840?w=800&q=85',
      description:
          'Layered parfait with thick Greek yogurt, crunchy granola, fresh berries, and honey.',
    ),
    Meal(
      id: 'meal_011',
      name: 'Apple Slices with Almond Butter',
      category: 'Snacks',
      ingredients: [
        'Honeycrisp apple 1 medium',
        'Almond butter 2tbsp',
        'Cinnamon sprinkle',
      ],
      calories: 240,
      protein: 8,
      carbs: 28,
      fats: 12,
      portionSize: 180,
      imageUrl:
          'https://images.unsplash.com/photo-1568702846914-96b305d2aaeb?w=800&q=85',
      description:
          'Crisp apple slices paired with creamy almond butter and a hint of cinnamon.',
    ),
    Meal(
      id: 'meal_012',
      name: 'Dark Chocolate Protein Balls',
      category: 'Snacks',
      ingredients: [
        'Medjool dates 100g',
        'Raw almonds 50g',
        'Dark cocoa powder 2tbsp',
        'Protein powder 20g',
        'Coconut oil 1tsp',
      ],
      calories: 280,
      protein: 14,
      carbs: 32,
      fats: 10,
      portionSize: 120,
      imageUrl:
          'https://images.unsplash.com/photo-1599599810694-b5ac4dd1529f?w=800&q=85',
      description:
          'Rich chocolate energy balls made with dates, almonds, and protein powder - perfect pre-workout fuel.',
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

  // ==================== WORKOUTS ====================

  /// All available workouts
  static final List<Workout> allWorkouts = [
    // ==================== WEIGHT LIFTING ====================
    Workout(
      id: 'workout_001',
      name: 'Barbell Bench Press',
      category: 'Weight Lifting',
      steps: [
        'Lie flat on bench with feet planted firmly on floor',
        'Grip barbell slightly wider than shoulder-width',
        'Unrack the bar and position it above your chest',
        'Lower the bar slowly to mid-chest with elbows at 45°',
        'Press the bar up explosively until arms are fully extended',
        'Complete 4 sets of 8-12 reps with 2 min rest',
      ],
      targetMuscles: ['Chest', 'Triceps', 'Front Shoulders'],
      caloriesBurned: 150,
      imageUrl:
          'https://images.unsplash.com/photo-1571019614242-c5c5dee9f50b?w=800&q=85',
      description:
          'The king of upper body exercises - builds powerful chest, shoulders, and triceps.',
      durationMinutes: 20,
    ),
    Workout(
      id: 'workout_002',
      name: 'Conventional Deadlift',
      category: 'Weight Lifting',
      steps: [
        'Stand with feet hip-width apart, bar over mid-foot',
        'Bend down and grip bar just outside your legs',
        'Keep back neutral, chest up, shoulders back',
        'Drive through heels and extend hips to lift the bar',
        'Keep bar close to body throughout the movement',
        'Lower bar with control and repeat for 5 sets of 5 reps',
      ],
      targetMuscles: ['Lower Back', 'Glutes', 'Hamstrings', 'Traps', 'Core'],
      caloriesBurned: 180,
      imageUrl:
          'https://images.unsplash.com/photo-1534438327276-14e5300c3a48?w=800&q=85',
      description:
          'The ultimate full-body strength builder - works nearly every major muscle group.',
      durationMinutes: 25,
    ),
    Workout(
      id: 'workout_003',
      name: 'Barbell Back Squat',
      category: 'Weight Lifting',
      steps: [
        'Position barbell on upper back/traps (high bar) or rear delts (low bar)',
        'Stand with feet shoulder-width, toes slightly out',
        'Brace core and begin descent by breaking at hips and knees',
        'Squat down until thighs are parallel or below',
        'Drive through heels and midfoot to return to standing',
        'Complete 4 sets of 10-15 reps with proper form',
      ],
      targetMuscles: ['Quadriceps', 'Glutes', 'Hamstrings', 'Core'],
      caloriesBurned: 160,
      imageUrl:
          'https://images.unsplash.com/photo-1574680096145-d05b474e2155?w=800&q=85',
      description:
          'The king of leg exercises - builds massive lower body strength and muscle mass.',
      durationMinutes: 22,
    ),

    // ==================== CARDIO ====================
    Workout(
      id: 'workout_004',
      name: 'Outdoor Running',
      category: 'Cardio',
      steps: [
        'Start with 5-minute brisk walk to warm up muscles',
        'Begin running at comfortable conversational pace',
        'Maintain consistent speed for 20-25 minutes',
        'Focus on landing mid-foot, keep shoulders relaxed',
        'Gradually slow to jog, then walk for 5-minute cooldown',
        'Finish with light stretching of calves and quads',
      ],
      targetMuscles: ['Heart & Lungs', 'Calves', 'Quads', 'Hamstrings'],
      caloriesBurned: 350,
      imageUrl:
          'https://images.unsplash.com/photo-1552674605-db6ffd4facb5?w=800&q=85',
      description:
          'Classic steady-state cardio - improves cardiovascular endurance and burns serious calories.',
      durationMinutes: 35,
    ),
    Workout(
      id: 'workout_005',
      name: 'Indoor Cycling',
      category: 'Cardio',
      steps: [
        'Adjust seat height so knee has slight bend at bottom',
        'Warm up with 5 minutes of easy spinning (low resistance)',
        'Increase resistance and maintain 80-100 RPM cadence',
        'Alternate between seated and standing positions',
        'Every 5 minutes, increase resistance for hill simulation',
        'Cool down with 5 minutes of light spinning',
      ],
      targetMuscles: ['Quads', 'Hamstrings', 'Calves', 'Glutes', 'Core'],
      caloriesBurned: 400,
      imageUrl:
          'https://images.unsplash.com/photo-1517649763962-0c623066013b?w=800&q=85',
      description:
          'Low-impact cardio powerhouse - torch calories while protecting your joints.',
      durationMinutes: 45,
    ),
    Workout(
      id: 'workout_006',
      name: 'HIIT Circuit Training',
      category: 'Cardio',
      steps: [
        'Warm up: 2 minutes jumping jacks and dynamic stretching',
        'Round 1: 40 seconds max effort, 20 seconds rest (burpees)',
        'Round 2: 40 seconds max effort, 20 seconds rest (mountain climbers)',
        'Round 3: 40 seconds max effort, 20 seconds rest (jump squats)',
        'Round 4: 40 seconds max effort, 20 seconds rest (high knees)',
        'Repeat circuit 4 times, cool down with 3-minute walk',
      ],
      targetMuscles: ['Full Body', 'Core', 'Cardiovascular System'],
      caloriesBurned: 320,
      imageUrl:
          'https://images.unsplash.com/photo-1518611012118-696072aa579a?w=800&q=85',
      description:
          'Maximum calorie burn in minimum time - boosts metabolism for hours after workout.',
      durationMinutes: 25,
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
