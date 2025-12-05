import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:nutrifit/models/models.dart';
import 'package:nutrifit/repositories/mock_data_repository.dart';
import 'package:nutrifit/services/ml_service.dart';
import 'package:nutrifit/providers/providers.dart';
import 'package:nutrifit/screens/meal_detail_screen.dart';
import 'package:flutter/services.dart'; // add this

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

  /// Open camera for food detection
  Future<void> _openCamera() async {
    try {
      final image = await _imagePicker.pickImage(
        source: ImageSource.camera,
        imageQuality: 85,
      );
      if (image == null || !mounted) return;

      // Loading dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => const Center(child: CircularProgressIndicator()),
      );

      final detections = await MLService.detectFoodFromImage(image.path);
      if (!mounted) return;
      Navigator.of(context, rootNavigator: true).pop(); // close loading
      _showFoodDetectionResults(detections);
    } on PlatformException catch (e) {
      // iOS simulator or no camera available
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text('Camera unavailable (${e.code}). Opening gallery...')),
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
                leading: const Icon(Icons.restaurant),
                title: Text(detection['name']),
                subtitle: Text('${detection['calories']} cal'),
                trailing: const Icon(Icons.add),
                onTap: () {
                  Navigator.pop(context);
                  // Optionally add to favorites or log
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

    return Scaffold(
      body: Column(
        children: [
          // Category selector
          Container(
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: categories.map((category) {
                  final isSelected = category == _selectedCategory;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Text(category),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() => _selectedCategory = category);
                      },
                      backgroundColor: Colors.grey[200],
                      selectedColor: const Color(0xFF4CAF50),
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : Colors.black,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          // Meals list
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: meals.length,
              itemBuilder: (context, index) {
                final meal = meals[index];
                return _buildMealCard(context, meal);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'meals_camera_fab',
        onPressed: _openCamera,
        tooltip: 'Scan Food',
        child: const Icon(Icons.camera_alt),
      ),
    );
  }

  /// Build meal card
  Widget _buildMealCard(BuildContext context, Meal meal) {
    final isFavorite = context.watch<FavoritesProvider>().isMealFavorite(
          meal.id,
        );

    return Card(
      key: ValueKey('meal_card_${meal.id}'),
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => MealDetailScreen(meal: meal),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Meal image placeholder
            Container(
              width: double.infinity,
              height: 150,
              decoration: BoxDecoration(color: Colors.grey[200]),
              child: const Icon(Icons.image, size: 64, color: Colors.grey),
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
                          context.read<FavoritesProvider>().toggleMealFavorite(
                                meal.id,
                              );
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

  /// Build macro tag
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
