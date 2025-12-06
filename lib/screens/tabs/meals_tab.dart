import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:nutrifit/models/models.dart';
import 'package:nutrifit/repositories/mock_data_repository.dart';
import 'package:nutrifit/services/ml_service.dart';
import 'package:nutrifit/providers/providers.dart';
import 'package:nutrifit/screens/meal_detail_screen.dart';
import 'package:flutter/services.dart';
import 'package:nutrifit/widgets/cached_meal_image.dart';
import 'package:nutrifit/screens/create_meal_screen.dart';

/// Meals tab showing all meals with category filtering
class MealsTab extends StatefulWidget {
  const MealsTab({super.key});

  @override
  State<MealsTab> createState() => _MealsTabState();
}

class _MealsTabState extends State<MealsTab> {
  late String _selectedCategory;
  final ImagePicker _imagePicker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _selectedCategory = MockDataRepository.getAllMealCategories().first;
  }

  /// Get custom icon for meal category
  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Breakfast':
        return Icons.free_breakfast;
      case 'Lunch':
        return Icons.lunch_dining;
      case 'Dinner':
        return Icons.dinner_dining;
      case 'Snacks':
        return Icons.restaurant;
      default:
        return Icons.fastfood;
    }
  }

  /// Get category color
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

  /// Open camera for food detection
  Future<void> _openCamera() async {
    try {
      final image = await _imagePicker.pickImage(
        source: ImageSource.camera,
        imageQuality: 85,
      );
      if (image == null || !mounted) return;

      if (!mounted) return;
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => const Center(child: CircularProgressIndicator()),
      );

      final detections = await MLService.detectFoodFromImage(image.path);
      if (!mounted) return;
      Navigator.of(context, rootNavigator: true).pop();
      _showFoodDetectionResults(detections);
    } on PlatformException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Camera unavailable (${e.code}). Opening gallery...'),
        ),
      );

      final image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );
      if (image == null || !mounted) return;

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => const Center(child: CircularProgressIndicator()),
      );

      final detections = await MLService.detectFoodFromImage(image.path);
      if (!mounted) return;
      Navigator.of(context, rootNavigator: true).pop();
      _showFoodDetectionResults(detections);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  /// Show detected food items
  void _showFoodDetectionResults(List<Map<String, dynamic>> detections) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Detected Foods'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView(
            shrinkWrap: true,
            children: detections.map((detection) {
              return ListTile(
                leading: const Icon(Icons.restaurant, color: Color(0xFF4CAF50)),
                title: Text(detection['name']),
                subtitle: Text('${detection['calories']} cal'),
                trailing: const Icon(Icons.add, color: Color(0xFF4CAF50)),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('${detection['name']} detected!')),
                  );
                },
              );
            }).toList(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final meals = MockDataRepository.getMealsByCategory(_selectedCategory);
    final categories = MockDataRepository.getAllMealCategories();

    // ✅ Wrap entire body with GestureDetector for keyboard dismissal
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(), // Dismiss keyboard on tap
      child: Scaffold(
        body: Column(
          children: [
            // Enhanced category selector with custom icons
            Container(
              padding: const EdgeInsets.all(16),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: categories.map((category) {
                    final isSelected = category == _selectedCategory;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        avatar: Icon(
                          _getCategoryIcon(category),
                          size: 18,
                          color: isSelected
                              ? Colors.white
                              : _getCategoryColor(category),
                        ),
                        label: Text(category),
                        selected: isSelected,
                        onSelected: (selected) {
                          setState(() => _selectedCategory = category);
                        },
                        backgroundColor: Colors.grey[200],
                        selectedColor: _getCategoryColor(category),
                        labelStyle: TextStyle(
                          color: isSelected ? Colors.white : Colors.black,
                          fontWeight:
                              isSelected ? FontWeight.w600 : FontWeight.normal,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),

            // Meals list
            Expanded(
              child: meals.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior
                          .onDrag, // ✅ Dismiss on scroll
                      padding: const EdgeInsets.all(12),
                      itemCount: meals.length,
                      itemBuilder: (context, index) {
                        return MealCard(
                          meal: meals[index],
                          categoryIcon: _getCategoryIcon(meals[index].category),
                          categoryColor:
                              _getCategoryColor(meals[index].category),
                          onUpdate: () => setState(() {}), // ✅ Trigger refresh
                        );
                      },
                    ),
            ),
          ],
        ),
        floatingActionButton: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ✅ Add custom meal button
            FloatingActionButton(
              heroTag: 'meals_add_fab',
              onPressed: () => _showCreateMealDialog(),
              child: const Icon(Icons.add),
            ),
            const SizedBox(height: 12),
            FloatingActionButton.extended(
              heroTag: 'meals_camera_fab',
              onPressed: _openCamera,
              icon: const Icon(Icons.camera_alt),
              label: const Text('Scan Food'),
            ),
          ],
        ),
      ),
    );
  }

  /// ✅ Show create meal dialog and refresh on create
  void _showCreateMealDialog() async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const CreateMealScreen(),
        fullscreenDialog: true,
      ),
    );

    // ✅ Refresh tab if meal was created
    if (result == true && mounted) {
      setState(() {});
    }
  }

  /// Build empty state with illustration
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.restaurant_menu,
            size: 80,
            color: Colors.grey[300],
          ),
          const SizedBox(height: 24),
          Text(
            'No meals in $_selectedCategory',
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

/// ✅ Separate widget for meal card with cached images
class MealCard extends StatelessWidget {
  final Meal meal;
  final IconData categoryIcon;
  final Color categoryColor;
  final VoidCallback? onUpdate; // ✅ Add callback

  const MealCard({
    super.key,
    required this.meal,
    required this.categoryIcon,
    required this.categoryColor,
    this.onUpdate,
  });

  @override
  Widget build(BuildContext context) {
    final isFavorite = context.select<FavoritesProvider, bool>(
      (provider) => provider.isMealFavorite(meal.id),
    );

    return Card(
      key: ValueKey('meal_card_${meal.id}'),
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () async {
          // ✅ Listen for result from detail screen
          final result = await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => MealDetailScreen(meal: meal),
            ),
          );

          // ✅ Trigger refresh if changes were made
          if (result == true && onUpdate != null) {
            onUpdate!();
          }
        },
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ✅ Cached network image with fallback
            CachedMealImage(
              imageUrl: meal.imageUrl,
              height: 150,
              fallbackIcon: categoryIcon,
              fallbackColor: categoryColor,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(16)),
            ),

            // Meal details
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          meal.name,
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
                              .toggleMealFavorite(meal.id);
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Macros
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildMacroTag(
                        '${meal.calories.toStringAsFixed(0)} cal',
                        Icons.local_fire_department,
                      ),
                      _buildMacroTag(
                        '${meal.protein.toStringAsFixed(0)}g Protein',
                        Icons.fitness_center,
                      ),
                      _buildMacroTag(
                        '${meal.carbs.toStringAsFixed(0)}g Carbs',
                        Icons.grain,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    meal.description,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMacroTag(String label, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 14, color: const Color(0xFF4CAF50)),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
      ],
    );
  }
}
