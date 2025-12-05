import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:nutrifit/models/models.dart';
import 'package:nutrifit/providers/providers.dart';
import 'package:nutrifit/services/storage_service.dart';

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
    // Add to recents
    StorageService.addRecentWorkout(widget.workout.id);
  }

  @override
  Widget build(BuildContext context) {
    //final isFavorite = context.watch<FavoritesProvider>().isWorkoutFavorite(
    //    widget.workout.id,
    //);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Workout Details'),
        actions: [
          Builder(
            builder: (context) {
              final isFavorite =
                  context.watch<FavoritesProvider>().isWorkoutFavorite(
                        widget.workout.id,
                      );
              return IconButton(
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: isFavorite ? Colors.red : null,
                ),
                onPressed: () {
                  context.read<FavoritesProvider>().toggleWorkoutFavorite(
                        widget.workout.id,
                      );
                },
              );
            },
          ),
        ],
      ),
      body: ListView(
        children: [
          // Workout image placeholder
          Container(
            width: double.infinity,
            height: 250,
            color: Colors.grey[200],
            child: const Icon(
              Icons.fitness_center,
              size: 80,
              color: Colors.grey,
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
                // Category
                Chip(
                  label: Text(widget.workout.category),
                  backgroundColor: const Color(0xFF4CAF50),
                  labelStyle: const TextStyle(color: Colors.white),
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
                            color: const Color(0xFF4CAF50),
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
          Icon(icon, color: const Color(0xFF4CAF50), size: 24),
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
