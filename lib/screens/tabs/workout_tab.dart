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

        // Workouts list with empty state
        Expanded(
          child: workouts.isEmpty
              ? _buildEmptyState()
              : ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: workouts.length,
                  itemBuilder: (context, index) {
                    // ✅ FIXED: Extract to separate widget
                    return WorkoutCard(
                      workout: workouts[index],
                      categoryIcon: _getCategoryIcon(workouts[index].category),
                      categoryColor:
                          _getCategoryColor(workouts[index].category),
                    );
                  },
                ),
        ),
      ],
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

/// ✅ Separate widget for workout card (allows context.select to work properly)
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
    // ✅ Now context.select works perfectly!
    final isFavorite = context.select<FavoritesProvider, bool>(
      (provider) => provider.isWorkoutFavorite(workout.id),
    );

    return Card(
      key: ValueKey('workout_card_${workout.id}'),
      margin: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Workout image placeholder with gradient
          Container(
            width: double.infinity,
            height: 120,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  categoryColor.withValues(alpha: 0.2),
                  categoryColor.withValues(alpha: 0.05),
                ],
              ),
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Icon(
              categoryIcon,
              size: 48,
              color: categoryColor.withValues(alpha: 0.5),
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
