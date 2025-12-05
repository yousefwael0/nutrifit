import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:nutrifit/models/models.dart';
import 'package:nutrifit/providers/providers.dart';
import 'package:nutrifit/repositories/mock_data_repository.dart';
import 'package:nutrifit/screens/meal_detail_screen.dart';
import 'package:nutrifit/screens/workout_detail_screen.dart';

/// Home tab showing recent meals/workouts and insights
class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    // ✅ Performance: Only watch user, not entire provider
    final user = context.select<UserProvider, User?>(
      (provider) => provider.user,
    );

    if (user == null) {
      return const Center(child: CircularProgressIndicator());
    }

    // ✅ Performance: Select only what we need from favorites
    final favoriteMealIds = context.select<FavoritesProvider, List<String>>(
      (provider) => provider.favoriteMeals.take(3).toList(),
    );
    final favoriteWorkoutIds = context.select<FavoritesProvider, List<String>>(
      (provider) => provider.favoriteWorkouts.take(3).toList(),
    );

    final favoriteMeals = favoriteMealIds
        .map((id) => MockDataRepository.getMealById(id))
        .whereType<Meal>()
        .toList();

    final favoriteWorkouts = favoriteWorkoutIds
        .map((id) => MockDataRepository.getWorkoutById(id))
        .whereType<Workout>()
        .toList();

    final hasNoActivity = favoriteMeals.isEmpty && favoriteWorkouts.isEmpty;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Greeting and stats
        _buildGreetingCard(user),
        const SizedBox(height: 24),

        // Daily calorie insights
        _buildInsightsSection(user),
        const SizedBox(height: 24),

        // Favorite meals
        if (favoriteMeals.isNotEmpty) ...[
          _buildSectionHeader('Favorite Meals'),
          const SizedBox(height: 12),
          ...favoriteMeals.map((meal) => _buildMealCard(context, meal)),
          const SizedBox(height: 24),
        ],

        // Favorite workouts
        if (favoriteWorkouts.isNotEmpty) ...[
          _buildSectionHeader('Favorite Workouts'),
          const SizedBox(height: 12),
          ...favoriteWorkouts
              .map((workout) => _buildWorkoutCard(context, workout)),
          const SizedBox(height: 24),
        ],

        // ✨ Enhanced empty state
        if (hasNoActivity)
          Container(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.favorite_border, size: 64, color: Colors.grey[300]),
                const SizedBox(height: 16),
                const Text(
                  'No favorites yet!',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey),
                ),
                const SizedBox(height: 8),
                Text(
                  'Start by adding meals and workouts to favorites',
                  style: TextStyle(fontSize: 14, color: Colors.grey[400]),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
      ],
    );
  }

  /// Build greeting card
  Widget _buildGreetingCard(User user) {
    return Card(
      color: const Color(0xFF4CAF50),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome, ${user.email.split('@')[0]}!',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'BMI: ${user.bmi.toStringAsFixed(1)} | Weight: ${user.weight.toStringAsFixed(1)} kg',
              style: const TextStyle(fontSize: 12, color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }

  /// Build insights section
  Widget _buildInsightsSection(User user) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Today\'s Insights'),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildInsightRow(
                  'Daily Calorie Target',
                  '${user.dailyCalories.toStringAsFixed(0)} cal',
                  Icons.local_fire_department,
                ),
                const Divider(),
                _buildInsightRow(
                  'Weight Progress',
                  '${user.weight.toStringAsFixed(1)} → ${user.targetWeight.toStringAsFixed(1)} kg',
                  Icons.trending_down,
                ),
                const Divider(),
                _buildInsightRow(
                  'Current BMI',
                  '${user.bmi.toStringAsFixed(1)} (${_getBmiCategory(user.bmi)})',
                  Icons.health_and_safety,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// Get BMI category
  String _getBmiCategory(double bmi) {
    if (bmi < 18.5) return 'Underweight';
    if (bmi < 25) return 'Normal';
    if (bmi < 30) return 'Overweight';
    return 'Obese';
  }

  /// Build insight row
  Widget _buildInsightRow(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFF4CAF50), size: 24),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ],
    );
  }

  /// Build section header
  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    );
  }

  /// Build meal card
  Widget _buildMealCard(BuildContext context, Meal meal) {
    return Card(
      key: ValueKey('home_meal_${meal.id}'),
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.grey[200],
          ),
          child: const Icon(Icons.restaurant, color: Color(0xFF4CAF50)),
        ),
        title: Text(meal.name),
        subtitle: Text('${meal.calories.toStringAsFixed(0)} cal'),
        trailing: const Icon(Icons.arrow_forward, color: Colors.grey),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => MealDetailScreen(meal: meal),
            ),
          );
        },
      ),
    );
  }

  /// Build workout card
  Widget _buildWorkoutCard(BuildContext context, Workout workout) {
    return Card(
      key: ValueKey('home_workout_${workout.id}'),
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.grey[200],
          ),
          child: const Icon(Icons.fitness_center, color: Color(0xFF4CAF50)),
        ),
        title: Text(workout.name),
        subtitle: Text('${workout.durationMinutes} min'),
        trailing: const Icon(Icons.arrow_forward, color: Colors.grey),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => WorkoutDetailScreen(workout: workout),
            ),
          );
        },
      ),
    );
  }
}
