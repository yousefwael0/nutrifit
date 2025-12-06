import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:nutrifit/models/models.dart';
import 'package:nutrifit/repositories/mock_data_repository.dart';
import 'package:nutrifit/providers/providers.dart';
import 'package:nutrifit/screens/workout_timer_screen.dart';
import 'package:nutrifit/screens/workout_detail_screen.dart';
import 'package:nutrifit/widgets/cached_meal_image.dart';
import 'package:nutrifit/screens/create_workout_screen.dart';

/// Workout tab showing weight lifting and cardio workouts
class WorkoutTab extends StatefulWidget {
  const WorkoutTab({super.key});

  @override
  State<WorkoutTab> createState() => _WorkoutTabState();
}

class _WorkoutTabState extends State<WorkoutTab> {
  late String _selectedCategory;

  @override
  void initState() {
    super.initState();
    _selectedCategory = MockDataRepository.getAllWorkoutCategories().first;
  }

  /// Get category icon
  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Weight Lifting':
        return Icons.fitness_center;
      case 'Cardio':
        return Icons.directions_run;
      default:
        return Icons.sports_gymnastics;
    }
  }

  /// Get category color
  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Weight Lifting':
        return Colors.deepOrange;
      case 'Cardio':
        return Colors.blue;
      default:
        return const Color(0xFF4CAF50);
    }
  }

  @override
  Widget build(BuildContext context) {
    final workouts =
        MockDataRepository.getWorkoutsByCategory(_selectedCategory);
    final categories = MockDataRepository.getAllWorkoutCategories();

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: Column(
          children: [
            // Category selector
            Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: categories.map((category) {
                  final isSelected = category == _selectedCategory;
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: ChoiceChip(
                        avatar: Icon(
                          _getCategoryIcon(category),
                          size: 18,
                          color: isSelected
                              ? Colors.white
                              : _getCategoryColor(category),
                        ),
                        label: Text(
                          category,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        selected: isSelected,
                        onSelected: (selected) {
                          setState(() => _selectedCategory = category);
                        },
                        backgroundColor: Colors.grey[200],
                        selectedColor: _getCategoryColor(category),
                        labelStyle: TextStyle(
                          color: isSelected ? Colors.white : Colors.black,
                          fontSize: 12,
                          fontWeight:
                              isSelected ? FontWeight.w600 : FontWeight.normal,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

            // Workouts list
            Expanded(
              child: workouts.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior
                          .onDrag, // ✅ Dismiss on scroll
                      padding: const EdgeInsets.all(12),
                      itemCount: workouts.length,
                      itemBuilder: (context, index) {
                        return WorkoutCard(
                          workout: workouts[index],
                          categoryIcon:
                              _getCategoryIcon(workouts[index].category),
                          categoryColor:
                              _getCategoryColor(workouts[index].category),
                        );
                      },
                    ),
            ),
          ],
        ),
        // ✅ Add create workout FAB
        floatingActionButton: FloatingActionButton(
          heroTag: 'workout_add_fab',
          onPressed: () async {
            final result = await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const CreateWorkoutScreen(),
                fullscreenDialog: true,
              ),
            );

            // ✅ Refresh tab if workout was created
            if (result == true && mounted) {
              setState(() {});
            }
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  /// Build empty state
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            _getCategoryIcon(_selectedCategory),
            size: 80,
            color: Colors.grey[300],
          ),
          const SizedBox(height: 24),
          Text(
            'No workouts in $_selectedCategory',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try selecting a different category',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[400],
            ),
          ),
        ],
      ),
    );
  }
}

/// ✅ Separate widget for workout card with cached images
class WorkoutCard extends StatelessWidget {
  final Workout workout;
  final IconData categoryIcon;
  final Color categoryColor;

  const WorkoutCard({
    super.key,
    required this.workout,
    required this.categoryIcon,
    required this.categoryColor,
  });

  @override
  Widget build(BuildContext context) {
    final isFavorite = context.select<FavoritesProvider, bool>(
      (provider) => provider.isWorkoutFavorite(workout.id),
    );

    return Card(
      key: ValueKey('workout_card_${workout.id}'),
      margin: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ✅ Cached network image with fallback
          CachedMealImage(
            imageUrl: workout.imageUrl,
            height: 120,
            fallbackIcon: categoryIcon,
            fallbackColor: categoryColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          ),

          // Workout details
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title and favorite button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        workout.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: isFavorite ? Colors.red : Colors.grey,
                      ),
                      onPressed: () {
                        context
                            .read<FavoritesProvider>()
                            .toggleWorkoutFavorite(workout.id);
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Details row
                Row(
                  children: [
                    const Icon(Icons.timer, size: 14, color: Color(0xFF4CAF50)),
                    const SizedBox(width: 4),
                    Text(
                      '${workout.durationMinutes} min',
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    const SizedBox(width: 16),
                    const Icon(
                      Icons.local_fire_department,
                      size: 14,
                      color: Color(0xFF4CAF50),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${workout.caloriesBurned.toStringAsFixed(0)} cal',
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Target muscles
                if (workout.targetMuscles.isNotEmpty)
                  Wrap(
                    spacing: 6,
                    runSpacing: 4,
                    children: workout.targetMuscles
                        .map(
                          (muscle) => Chip(
                            label: Text(
                              muscle,
                              style: const TextStyle(fontSize: 11),
                            ),
                            backgroundColor: Colors.grey[200],
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                          ),
                        )
                        .toList(),
                  ),
                const SizedBox(height: 12),

                // Action buttons
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.play_arrow, size: 18),
                        label: const Text('Start'),
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) =>
                                  WorkoutTimerScreen(workout: workout),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton.icon(
                        icon: const Icon(Icons.info, size: 18),
                        label: const Text('Details'),
                        onPressed: () async {
                          // ✅ Listen for result from detail screen
                          final result = await Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) =>
                                  WorkoutDetailScreen(workout: workout),
                            ),
                          );

                          // ✅ Trigger refresh if changes were made
                          if (result == true) {
                            // Find the parent _WorkoutTabState and trigger refresh
                            (context.findAncestorStateOfType<
                                    _WorkoutTabState>())
                                ?.setState(() {});
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
