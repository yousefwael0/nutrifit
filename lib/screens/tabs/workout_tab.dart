import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:nutrifit/models/models.dart';
import 'package:nutrifit/repositories/mock_data_repository.dart';
import 'package:nutrifit/providers/providers.dart';
import 'package:nutrifit/screens/workout_timer_screen.dart';
import 'package:nutrifit/screens/workout_detail_screen.dart';

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

  @override
  Widget build(BuildContext context) {
    final workouts = MockDataRepository.getWorkoutsByCategory(
      _selectedCategory,
    );
    final categories = MockDataRepository.getAllWorkoutCategories();

    return Column(
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
                  child: FilterChip(
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
                    selectedColor: const Color(0xFF4CAF50),
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : Colors.black,
                      fontSize: 12,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        // Workouts list
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: workouts.length,
            itemBuilder: (context, index) {
              final workout = workouts[index];
              return _buildWorkoutCard(context, workout);
            },
          ),
        ),
      ],
    );
  }

  /// Build workout card
  Widget _buildWorkoutCard(BuildContext context, Workout workout) {
    final isFavorite = context.watch<FavoritesProvider>().isWorkoutFavorite(
          workout.id,
        );

    return Card(
      key: ValueKey('workout_card_${workout.id}'),
      margin: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Workout image placeholder
          Container(
            width: double.infinity,
            height: 120,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: const Icon(
              Icons.fitness_center,
              size: 48,
              color: Colors.grey,
            ),
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
                        context.read<FavoritesProvider>().toggleWorkoutFavorite(
                              workout.id,
                            );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // Details row
                Row(
                  children: [
                    Icon(Icons.timer, size: 14, color: const Color(0xFF4CAF50)),
                    const SizedBox(width: 4),
                    Text(
                      '${workout.durationMinutes} min',
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    const SizedBox(width: 16),
                    Icon(
                      Icons.local_fire_department,
                      size: 14,
                      color: const Color(0xFF4CAF50),
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
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) =>
                                  WorkoutDetailScreen(workout: workout),
                            ),
                          );
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
