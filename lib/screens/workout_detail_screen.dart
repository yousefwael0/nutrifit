import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:nutrifit/models/models.dart';
import 'package:nutrifit/providers/providers.dart';
import 'package:nutrifit/services/storage_service.dart';
import 'package:nutrifit/repositories/mock_data_repository.dart';
import 'package:nutrifit/widgets/cached_meal_image.dart';
import 'package:nutrifit/screens/create_workout_screen.dart';

/// Workout detail screen
class WorkoutDetailScreen extends StatefulWidget {
  final Workout workout;

  const WorkoutDetailScreen({super.key, required this.workout});

  @override
  State<WorkoutDetailScreen> createState() => _WorkoutDetailScreenState();
}

class _WorkoutDetailScreenState extends State<WorkoutDetailScreen> {
  @override
  void initState() {
    super.initState();
    StorageService.addRecentWorkout(widget.workout.id);
  }

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

  /// ✅ Delete workout with confirmation (NO restrictions)
  void _deleteWorkout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Workout'),
        content:
            Text('Are you sure you want to delete "${widget.workout.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              // Delete from storage and repository
              if (MockDataRepository.isCustomWorkout(widget.workout.id)) {
                await StorageService.deleteCustomWorkout(widget.workout.id);
              }
              MockDataRepository.deleteWorkout(widget.workout.id);

              if (mounted) {
                Navigator.pop(context); // Close dialog
                Navigator.pop(
                    context, true); // ✅ Return true to trigger refresh
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Workout deleted')),
                );
              }
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  /// ✅ Edit workout (NO restrictions)
  void _editWorkout() async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) =>
            CreateWorkoutScreen(existingWorkout: widget.workout),
        fullscreenDialog: true,
      ),
    );

    // ✅ Refresh if edited
    if (result == true && mounted) {
      Navigator.pop(context, true); // Return true to trigger parent refresh
    }
  }

  @override
  Widget build(BuildContext context) {
    final isCustom = MockDataRepository.isCustomWorkout(widget.workout.id);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Workout Details'),
        actions: [
          // ✅ Edit button - ALWAYS SHOW
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: _editWorkout,
            tooltip: 'Edit',
          ),
          // Favorite button
          Builder(
            builder: (context) {
              final isFavorite = context
                  .watch<FavoritesProvider>()
                  .isWorkoutFavorite(widget.workout.id);
              return IconButton(
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: isFavorite ? Colors.red : null,
                ),
                onPressed: () {
                  context
                      .read<FavoritesProvider>()
                      .toggleWorkoutFavorite(widget.workout.id);
                },
              );
            },
          ),
          // ✅ Delete button - ALWAYS SHOW
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: _deleteWorkout,
            tooltip: 'Delete',
          ),
        ],
      ),
      body: ListView(
        children: [
          // Hero cached image
          Hero(
            tag: 'workout_${widget.workout.id}',
            child: CachedMealImage(
              imageUrl: widget.workout.imageUrl,
              height: 250,
              fallbackIcon: _getCategoryIcon(widget.workout.category),
              fallbackColor: _getCategoryColor(widget.workout.category),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  widget.workout.name,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),

                // Category chip
                Row(
                  children: [
                    Chip(
                      label: Text(widget.workout.category),
                      backgroundColor:
                          _getCategoryColor(widget.workout.category),
                      labelStyle: const TextStyle(color: Colors.white),
                    ),
                    // Custom badge (optional indicator)
                    if (isCustom) ...[
                      const SizedBox(width: 8),
                      const Chip(
                        label: Text('Custom'),
                        backgroundColor: Colors.purple,
                        labelStyle:
                            TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 16),

                // Stats grid
                GridView.count(
                  crossAxisCount: 3,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  childAspectRatio: 1.5,
                  children: [
                    _buildStatCard(
                      widget.workout.durationMinutes.toStringAsFixed(0),
                      'Minutes',
                      Icons.timer,
                    ),
                    _buildStatCard(
                      widget.workout.caloriesBurned.toStringAsFixed(0),
                      'Calories',
                      Icons.local_fire_department,
                    ),
                    _buildStatCard(
                      '${widget.workout.steps.length}',
                      'Steps',
                      Icons.list,
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Description
                const Text(
                  'Description',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  widget.workout.description,
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 24),

                // Steps
                const Text(
                  'Workout Steps',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                ...widget.workout.steps.asMap().entries.map((entry) {
                  final index = entry.key;
                  final step = entry.value;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            color: _getCategoryColor(widget.workout.category),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              '${index + 1}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(
                              step,
                              style: const TextStyle(fontSize: 14),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
                const SizedBox(height: 24),

                // Target muscles
                if (widget.workout.targetMuscles.isNotEmpty) ...[
                  const Text(
                    'Target Muscles',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: widget.workout.targetMuscles
                        .map(
                          (muscle) => Chip(
                            label: Text(muscle),
                            backgroundColor: Colors.grey[200],
                          ),
                        )
                        .toList(),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Build stat card
  Widget _buildStatCard(String value, String label, IconData icon) {
    return Card(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon,
              color: _getCategoryColor(widget.workout.category), size: 24),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(fontSize: 11, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
