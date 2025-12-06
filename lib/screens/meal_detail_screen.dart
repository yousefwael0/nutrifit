import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:nutrifit/models/models.dart';
import 'package:nutrifit/providers/providers.dart';
import 'package:nutrifit/services/storage_service.dart';
import 'package:nutrifit/repositories/mock_data_repository.dart';
import 'package:nutrifit/widgets/cached_meal_image.dart';
import 'package:nutrifit/screens/create_meal_screen.dart';

/// Meal detail screen
class MealDetailScreen extends StatefulWidget {
  final Meal meal;

  const MealDetailScreen({super.key, required this.meal});

  @override
  State<MealDetailScreen> createState() => _MealDetailScreenState();
}

class _MealDetailScreenState extends State<MealDetailScreen> {
  @override
  void initState() {
    super.initState();
    StorageService.addRecentMeal(widget.meal.id);
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Breakfast':
        return Colors.orange;
      case 'Lunch':
        return Colors.blue;
      case 'Dinner':
        return Colors.purple;
      case 'Snacks':
        return Colors.teal;
      default:
        return const Color(0xFF4CAF50);
    }
  }

  /// ✅ Delete meal with confirmation (NO restrictions)
  void _deleteMeal() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Meal'),
        content: Text('Are you sure you want to delete "${widget.meal.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              // Delete from storage and repository
              if (MockDataRepository.isCustomMeal(widget.meal.id)) {
                await StorageService.deleteCustomMeal(widget.meal.id);
              }
              MockDataRepository.deleteMeal(widget.meal.id);

              if (mounted) {
                Navigator.pop(context); // Close dialog
                Navigator.pop(
                    context, true); // ✅ Return true to trigger refresh
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Meal deleted')),
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

  /// ✅ Edit meal (NO restrictions)
  void _editMeal() async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => CreateMealScreen(existingMeal: widget.meal),
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
    final isCustom = MockDataRepository.isCustomMeal(widget.meal.id);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Meal Details'),
        actions: [
          // ✅ Edit button - ALWAYS SHOW
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: _editMeal,
            tooltip: 'Edit',
          ),
          // Favorite button
          Builder(
            builder: (context) {
              final isFavorite = context
                  .watch<FavoritesProvider>()
                  .isMealFavorite(widget.meal.id);
              return IconButton(
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: isFavorite ? Colors.red : null,
                ),
                onPressed: () {
                  context
                      .read<FavoritesProvider>()
                      .toggleMealFavorite(widget.meal.id);
                },
              );
            },
          ),
          // ✅ Delete button - ALWAYS SHOW
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: _deleteMeal,
            tooltip: 'Delete',
          ),
        ],
      ),
      body: ListView(
        children: [
          // Hero cached image
          Hero(
            tag: 'meal_${widget.meal.id}',
            child: CachedMealImage(
              imageUrl: widget.meal.imageUrl,
              height: 250,
              fallbackIcon: Icons.restaurant,
              fallbackColor: _getCategoryColor(widget.meal.category),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  widget.meal.name,
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
                      label: Text(widget.meal.category),
                      backgroundColor: _getCategoryColor(widget.meal.category),
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

                // Macros grid
                GridView.count(
                  crossAxisCount: 4,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  childAspectRatio: 1.2,
                  children: [
                    _buildMacroCard(
                      widget.meal.calories.toStringAsFixed(0),
                      'Calories',
                      Icons.local_fire_department,
                    ),
                    _buildMacroCard(
                      widget.meal.protein.toStringAsFixed(0),
                      'Protein',
                      Icons.fitness_center,
                    ),
                    _buildMacroCard(
                      '${widget.meal.carbs.toStringAsFixed(0)}g',
                      'Carbs',
                      Icons.grain,
                    ),
                    _buildMacroCard(
                      '${widget.meal.fats.toStringAsFixed(0)}g',
                      'Fats',
                      Icons.opacity,
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
                  widget.meal.description,
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 24),

                // Ingredients
                const Text(
                  'Ingredients',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                ...widget.meal.ingredients.map((ingredient) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        Icon(
                          Icons.check_circle,
                          size: 16,
                          color: _getCategoryColor(widget.meal.category),
                        ),
                        const SizedBox(width: 8),
                        Text(ingredient),
                      ],
                    ),
                  );
                }),
                const SizedBox(height: 24),

                // Portion size
                Text(
                  'Portion Size: ${widget.meal.portionSize.toStringAsFixed(0)}g',
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Build macro card
  Widget _buildMacroCard(String value, String label, IconData icon) {
    return Card(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: _getCategoryColor(widget.meal.category), size: 24),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(fontSize: 10, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
