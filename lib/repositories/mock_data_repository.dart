import 'package:my_nutrition/models/models.dart';
import 'package:my_nutrition/services/storage_service.dart';

/// Mock data repository with pre-defined meals and workouts
class MockDataRepository {
  /// All available meals
  static final List<Meal> allMeals = [
    // ==================== BREAKFAST (5 items) ====================
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
          'https://images.unsplash.com/photo-1517673132405-a56a62b18caf?w=800&q=85', // Vibrant oatmeal bowl
      description:
          'Creamy oatmeal topped with fresh blueberries, strawberries, and a drizzle of golden honey.',
    ),
    Meal(
      id: 'meal_002',
      name: 'Scrambled Eggs & Avocado',
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
          'https://images.unsplash.com/photo-1525351484163-7529414344d8?w=800&q=85', // Professional avocado toast
      description:
          'Fluffy scrambled eggs served on toasted sourdough with creamy avocado and fresh tomatoes.',
    ),
    Meal(
      id: 'meal_003',
      name: 'Protein Pancakes',
      category: 'Breakfast',
      ingredients: [
        'Banana 1',
        'Eggs 2',
        'Protein powder 30g',
        'Blueberries 80g',
        'Greek yogurt 50g',
        'Maple syrup 1tbsp',
      ],
      calories: 380,
      protein: 32,
      carbs: 42,
      fats: 8,
      portionSize: 320,
      imageUrl:
          'https://images.unsplash.com/photo-1506084868230-bb9d95c24759?w=800&q=85', // Stunning pancake stack
      description:
          'Fluffy protein-packed pancakes topped with fresh blueberries and Greek yogurt.',
    ),
    Meal(
      id: 'meal_004',
      name: 'Veggie Omelet',
      category: 'Breakfast',
      ingredients: [
        'Eggs 3',
        'Spinach 50g',
        'Mushrooms 50g',
        'Bell peppers 40g',
        'Feta cheese 30g',
        'Olive oil 1tsp',
      ],
      calories: 320,
      protein: 24,
      carbs: 12,
      fats: 20,
      portionSize: 280,
      imageUrl:
          'https://images.unsplash.com/photo-1510693206972-df098062cb71?w=800&q=85', // Close-up omelet
      description:
          'Colorful vegetable omelet packed with spinach, mushrooms, peppers, and tangy feta cheese.',
    ),
    Meal(
      id: 'meal_005',
      name: 'Acai Bowl',
      category: 'Breakfast',
      ingredients: [
        'Acai puree 100g',
        'Banana 1',
        'Granola 50g',
        'Fresh strawberries 80g',
        'Coconut flakes 10g',
        'Honey drizzle',
      ],
      calories: 360,
      protein: 8,
      carbs: 62,
      fats: 10,
      portionSize: 400,
      imageUrl:
          'https://images.unsplash.com/photo-1490474418585-ba9bad8fd0ea?w=800&q=85', // Beautiful fruit bowl
      description:
          'Instagram-worthy acai bowl topped with granola, fresh fruit, and coconut flakes.',
    ),

    // ==================== LUNCH (5 items) ====================
    Meal(
      id: 'meal_006',
      name: 'Grilled Chicken Caesar',
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
          'https://images.unsplash.com/photo-1550304943-4f24f54ddde9?w=800&q=85', // Crisp salad
      description:
          'Classic Caesar with juicy grilled chicken, crisp romaine, parmesan shavings, and homemade croutons.',
    ),
    Meal(
      id: 'meal_007',
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
          'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=800&q=85', // Perfect salmon bowl
      description:
          'Japanese-inspired bowl with glazed salmon, fluffy brown rice, edamame, and pickled vegetables.',
    ),
    Meal(
      id: 'meal_008',
      name: 'Mediterranean Quinoa',
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
          'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=800&q=85', // Healthy veggie bowl
      description:
          'Vibrant Mediterranean bowl with protein-rich quinoa, crispy chickpeas, fresh veggies, and creamy tahini.',
    ),
    Meal(
      id: 'meal_009',
      name: 'Turkey & Avocado Wrap',
      category: 'Lunch',
      ingredients: [
        'Whole wheat tortilla',
        'Sliced turkey 120g',
        'Avocado 1/2',
        'Mixed greens 50g',
        'Tomato slices',
        'Mustard mayo',
      ],
      calories: 420,
      protein: 32,
      carbs: 38,
      fats: 14,
      portionSize: 320,
      imageUrl:
          'https://images.unsplash.com/photo-1626700051175-6818013e1d4f?w=800&q=85', // Fresh wrap
      description:
          'Hearty wrap filled with lean turkey, creamy avocado, fresh greens, and tangy sauce.',
    ),
    Meal(
      id: 'meal_010',
      name: 'Thai Noodle Bowl',
      category: 'Lunch',
      ingredients: [
        'Rice noodles 150g',
        'Grilled chicken 130g',
        'Peanut sauce 3tbsp',
        'Shredded carrots',
        'Bean sprouts',
        'Fresh cilantro',
        'Crushed peanuts',
      ],
      calories: 540,
      protein: 36,
      carbs: 58,
      fats: 16,
      portionSize: 480,
      imageUrl:
          'https://images.unsplash.com/photo-1569718212165-3a8278d5f624?w=800&q=85', // Appetizing noodles
      description:
          'Thai-inspired noodle bowl with savory peanut sauce, tender chicken, and fresh herbs.',
    ),

    // ==================== DINNER (5 items) ====================
    Meal(
      id: 'meal_011',
      name: 'Grilled Ribeye Steak',
      category: 'Dinner',
      ingredients: [
        'Ribeye steak 200g',
        'Roasted potatoes 150g',
        'Grilled asparagus 100g',
        'Garlic herb butter 1tbsp',
        'Fresh rosemary',
      ],
      calories: 640,
      protein: 48,
      carbs: 32,
      fats: 36,
      portionSize: 500,
      imageUrl:
          'https://images.unsplash.com/photo-1600891964092-4316c288032e?w=800&q=85', // Juicy steak
      description:
          'Perfectly grilled ribeye with herb butter, crispy roasted potatoes, and charred asparagus.',
    ),
    Meal(
      id: 'meal_012',
      name: 'Spaghetti & Meatballs',
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
          'https://images.unsplash.com/photo-1515516947383-d15674029dc1?w=800&q=85', // Rich pasta dish
      description:
          'Classic Italian comfort food with lean turkey meatballs in rich tomato sauce over al dente pasta.',
    ),
    Meal(
      id: 'meal_013',
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
          'https://images.unsplash.com/photo-1512058564366-18510be2db19?w=800&q=85', // Colorful stir fry
      description:
          'Colorful wok-tossed beef with crisp vegetables in savory ginger-soy glaze over steamed rice.',
    ),
    Meal(
      id: 'meal_014',
      name: 'Herb-Crusted Cod',
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
          'https://images.unsplash.com/photo-1519708227418-8fb0291d1c57?w=800&q=85', // Elegant fish dish
      description:
          'Flaky herb-crusted cod with caramelized sweet potato, tender asparagus, and roasted tomatoes.',
    ),
    Meal(
      id: 'meal_015',
      name: 'BBQ Chicken Pizza',
      category: 'Dinner',
      ingredients: [
        'Thin crust pizza base',
        'BBQ sauce 50g',
        'Grilled chicken 120g',
        'Red onion slices',
        'Mozzarella cheese 80g',
        'Fresh cilantro',
      ],
      calories: 620,
      protein: 42,
      carbs: 68,
      fats: 18,
      portionSize: 350,
      imageUrl:
          'https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?w=800&q=85', // Delicious pizza
      description:
          'Gourmet BBQ chicken pizza with tangy sauce, melted mozzarella, red onions, and fresh cilantro.',
    ),

    // ==================== SNACKS (5 items) ====================
    Meal(
      id: 'meal_016',
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
          'https://images.unsplash.com/photo-1488477181946-6428a0291840?w=800&q=85', // Parfait cup
      description:
          'Layered parfait with thick Greek yogurt, crunchy granola, fresh berries, and honey.',
    ),
    Meal(
      id: 'meal_017',
      name: 'Protein Smoothie',
      category: 'Snacks',
      ingredients: [
        'Banana 1',
        'Protein powder 30g',
        'Almond milk 250ml',
        'Peanut butter 1tbsp',
        'Ice cubes',
      ],
      calories: 320,
      protein: 28,
      carbs: 32,
      fats: 10,
      portionSize: 400,
      imageUrl:
          'https://images.unsplash.com/photo-1553530979-7ee52a2670c4?w=800&q=85', // Smoothie glass
      description:
          'Creamy protein shake with banana, peanut butter, and vanilla protein - perfect post-workout fuel.',
    ),
    Meal(
      id: 'meal_018',
      name: 'Hummus & Veggies',
      category: 'Snacks',
      ingredients: [
        'Hummus 100g',
        'Carrot sticks 80g',
        'Cucumber slices 80g',
        'Bell pepper strips 60g',
        'Cherry tomatoes 40g',
      ],
      calories: 180,
      protein: 7,
      carbs: 22,
      fats: 8,
      portionSize: 360,
      imageUrl:
          'https://images.unsplash.com/photo-1637949385162-e416fb15b2ce?w=800&q=85', // Hummus platter
      description:
          'Fresh crunchy vegetables served with creamy, protein-rich hummus dip.',
    ),
    Meal(
      id: 'meal_019',
      name: 'Trail Mix',
      category: 'Snacks',
      ingredients: [
        'Mixed nuts 40g',
        'Dark chocolate chips 20g',
        'Dried cranberries 30g',
        'Pumpkin seeds 15g',
      ],
      calories: 320,
      protein: 10,
      carbs: 28,
      fats: 20,
      portionSize: 105,
      imageUrl:
          'https://images.unsplash.com/photo-1536658113075-bd0a7d05a527?w=800&q=85', // Trail mix
      description:
          'Energy-packed trail mix with nuts, dark chocolate, dried fruit, and seeds.',
    ),
    Meal(
      id: 'meal_020',
      name: 'Rice Cakes & Butter',
      category: 'Snacks',
      ingredients: [
        'Brown rice cakes 2',
        'Almond butter 2tbsp',
        'Banana slices',
        'Cinnamon sprinkle',
      ],
      calories: 260,
      protein: 9,
      carbs: 32,
      fats: 12,
      portionSize: 150,
      imageUrl:
          'https://images.unsplash.com/photo-1541592106381-b31e9677c0e5?w=800&q=85', // Rice cake snack
      description:
          'Crunchy rice cakes topped with creamy almond butter, fresh banana, and cinnamon.',
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
    // ==================== WEIGHT LIFTING (6 items) ====================
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
          'https://images.unsplash.com/photo-1571019614242-c5c5dee9f50b?w=800&q=85', // Intense gym press
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
          'https://images.unsplash.com/photo-1517836357463-d25dfeac3438?w=800&q=85', // Weights focus
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
          'https://images.unsplash.com/photo-1534438327276-14e5300c3a48?w=800&q=85', // Squat rack
      description:
          'The king of leg exercises - builds massive lower body strength and muscle mass.',
      durationMinutes: 22,
    ),
    Workout(
      id: 'workout_004',
      name: 'Dumbbell Shoulder Press',
      category: 'Weight Lifting',
      steps: [
        'Sit on bench with back support, feet flat on floor',
        'Hold dumbbells at shoulder height with palms facing forward',
        'Press dumbbells overhead until arms are fully extended',
        'Lower with control back to starting position',
        'Keep core engaged and avoid arching lower back',
        'Perform 4 sets of 10-12 reps',
      ],
      targetMuscles: ['Shoulders', 'Triceps', 'Upper Chest'],
      caloriesBurned: 140,
      imageUrl:
          'https://images.unsplash.com/photo-1581009146145-b5ef050c2e1e?w=800&q=85', // Dumbbell press
      description:
          'Build boulder shoulders with this classic pressing movement for maximum shoulder development.',
      durationMinutes: 18,
    ),
    Workout(
      id: 'workout_005',
      name: 'Barbell Rows',
      category: 'Weight Lifting',
      steps: [
        'Bend forward at hips with slight knee bend, back straight',
        'Grip barbell slightly wider than shoulder-width',
        'Pull bar to lower chest/upper abdomen',
        'Squeeze shoulder blades together at the top',
        'Lower bar with control to full arm extension',
        'Complete 4 sets of 8-10 reps',
      ],
      targetMuscles: ['Upper Back', 'Lats', 'Biceps', 'Rear Delts'],
      caloriesBurned: 145,
      imageUrl:
          'https://images.unsplash.com/photo-1598971639058-211a74a96c10?w=800&q=85', // Barbell row
      description:
          'Build a thick, powerful back with this compound pulling exercise.',
      durationMinutes: 20,
    ),
    Workout(
      id: 'workout_006',
      name: 'Leg Press',
      category: 'Weight Lifting',
      steps: [
        'Sit in leg press machine with back and head against pad',
        'Place feet shoulder-width apart on platform',
        'Release safety bars and slowly lower weight',
        'Lower until knees are at 90-degree angle',
        'Press through heels to extend legs fully',
        'Perform 4 sets of 12-15 reps',
      ],
      targetMuscles: ['Quadriceps', 'Glutes', 'Hamstrings'],
      caloriesBurned: 155,
      imageUrl:
          'https://images.unsplash.com/photo-1574680096145-d05b474e2155?w=800&q=85', // Gym machine leg press
      description:
          'Heavy leg development exercise that safely loads massive weight for quad growth.',
      durationMinutes: 20,
    ),

    // ==================== CARDIO (6 items) ====================
    Workout(
      id: 'workout_007',
      name: 'Trail Running',
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
          'https://images.unsplash.com/photo-1476480862126-209bfaa8edc8?w=800&q=85', // Scenic trail run
      description:
          'Classic steady-state cardio - improves cardiovascular endurance and burns serious calories.',
      durationMinutes: 35,
    ),
    Workout(
      id: 'workout_008',
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
          'https://images.unsplash.com/photo-1534891858418-c743a3551900?w=800&q=85', // Spin class
      description:
          'Low-impact cardio powerhouse - torch calories while protecting your joints.',
      durationMinutes: 45,
    ),
    Workout(
      id: 'workout_009',
      name: 'HIIT Circuit',
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
          'https://images.unsplash.com/photo-1601422407692-ec4eeec1d9b3?w=800&q=85', // Intense action
      description:
          'Maximum calorie burn in minimum time - boosts metabolism for hours after workout.',
      durationMinutes: 25,
    ),
    Workout(
      id: 'workout_010',
      name: 'Swimming Laps',
      category: 'Cardio',
      steps: [
        'Warm up with 5 minutes easy freestyle swimming',
        'Swim 10 laps (250m) at moderate pace',
        'Rest 30 seconds between every 2 laps',
        'Focus on smooth breathing and efficient strokes',
        'Cool down with 5 minutes of easy backstroke',
        'Stretch shoulders and legs poolside',
      ],
      targetMuscles: ['Full Body', 'Shoulders', 'Core', 'Legs'],
      caloriesBurned: 380,
      imageUrl:
          'https://images.unsplash.com/photo-1530549387789-4c1017266635?w=800&q=85', // Swimming pool
      description:
          'Full-body, low-impact cardio that builds endurance while being gentle on joints.',
      durationMinutes: 40,
    ),
    Workout(
      id: 'workout_011',
      name: 'Jump Rope Intervals',
      category: 'Cardio',
      steps: [
        'Warm up with light skipping for 3 minutes',
        'Jump rope at high intensity for 1 minute',
        'Rest for 30 seconds (walk in place)',
        'Repeat intervals for 15 minutes total',
        'Mix in double-unders if advanced',
        'Cool down with slow skipping for 2 minutes',
      ],
      targetMuscles: ['Calves', 'Quads', 'Shoulders', 'Core'],
      caloriesBurned: 310,
      imageUrl:
          'https://images.unsplash.com/photo-1599058945522-28d584b6f0ff?w=800&q=85', // Jump rope
      description:
          'High-intensity rope jumping that improves coordination, burns fat, and builds calf strength.',
      durationMinutes: 20,
    ),
    Workout(
      id: 'workout_012',
      name: 'Stair Climbing',
      category: 'Cardio',
      steps: [
        'Find a staircase (at least 3-4 floors)',
        'Warm up by walking up and down slowly twice',
        'Climb stairs at brisk pace for 2 minutes',
        'Walk down slowly for active recovery (1 minute)',
        'Repeat climb-and-descend for 25 minutes',
        'Finish with 5 minutes of walking and leg stretches',
      ],
      targetMuscles: ['Glutes', 'Quads', 'Hamstrings', 'Calves', 'Core'],
      caloriesBurned: 360,
      imageUrl:
          'https://images.unsplash.com/photo-1502224562085-639556652f33?w=800&q=85', // Stairs runner
      description:
          'Intense lower-body cardio that sculpts legs and glutes while burning maximum calories.',
      durationMinutes: 30,
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

  // ==================== CUSTOM ITEMS ====================

  /// Add custom meal to repository
  static void addCustomMeal(Meal meal) {
    allMeals.add(meal);
  }

  /// Add custom workout to repository
  static void addCustomWorkout(Workout workout) {
    allWorkouts.add(workout);
  }

  /// ✅ Update meal in repository
  static void updateMeal(Meal updatedMeal) {
    final index = allMeals.indexWhere((m) => m.id == updatedMeal.id);
    if (index != -1) {
      allMeals[index] = updatedMeal;
    }
  }

  /// ✅ Delete meal from repository
  static void deleteMeal(String mealId) {
    allMeals.removeWhere((m) => m.id == mealId);
  }

  /// ✅ Update workout in repository
  static void updateWorkout(Workout updatedWorkout) {
    final index = allWorkouts.indexWhere((w) => w.id == updatedWorkout.id);
    if (index != -1) {
      allWorkouts[index] = updatedWorkout;
    }
  }

  /// ✅ Delete workout from repository
  static void deleteWorkout(String workoutId) {
    allWorkouts.removeWhere((w) => w.id == workoutId);
  }

  /// ✅ Check if meal is custom (can be edited/deleted)
  static bool isCustomMeal(String mealId) {
    return mealId.startsWith('custom_meal_');
  }

  /// ✅ Check if workout is custom (can be edited/deleted)
  static bool isCustomWorkout(String workoutId) {
    return workoutId.startsWith('custom_workout_');
  }

  /// Load custom items from storage
  static void loadCustomItems() {
    final customMeals = StorageService.getCustomMeals();
    final customWorkouts = StorageService.getCustomWorkouts();
    allMeals.addAll(customMeals);
    allWorkouts.addAll(customWorkouts);
  }
}
