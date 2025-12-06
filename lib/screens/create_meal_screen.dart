import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:nutrifit/models/models.dart';
import 'package:nutrifit/services/storage_service.dart';
import 'package:nutrifit/repositories/mock_data_repository.dart';

/// Screen for creating/editing custom meals
class CreateMealScreen extends StatefulWidget {
  final Meal? existingMeal; // ✅ For edit mode

  const CreateMealScreen({super.key, this.existingMeal});

  @override
  State<CreateMealScreen> createState() => _CreateMealScreenState();
}

class _CreateMealScreenState extends State<CreateMealScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _caloriesController = TextEditingController();
  final _proteinController = TextEditingController();
  final _carbsController = TextEditingController();
  final _fatsController = TextEditingController();
  final _portionController = TextEditingController();
  final _imageUrlController = TextEditingController(); // ✅ New

  String _selectedCategory = 'Breakfast';
  final List<String> _ingredients = [];
  final _ingredientController = TextEditingController();

  bool get _isEditMode => widget.existingMeal != null; // ✅ Check mode

  @override
  void initState() {
    super.initState();

    // ✅ Pre-fill form if editing
    if (_isEditMode) {
      final meal = widget.existingMeal!;
      _nameController.text = meal.name;
      _descriptionController.text = meal.description;
      _caloriesController.text = meal.calories.toString();
      _proteinController.text = meal.protein.toString();
      _carbsController.text = meal.carbs.toString();
      _fatsController.text = meal.fats.toString();
      _portionController.text = meal.portionSize.toString();
      _imageUrlController.text = meal.imageUrl;
      _selectedCategory = meal.category;
      _ingredients.addAll(meal.ingredients);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _caloriesController.dispose();
    _proteinController.dispose();
    _carbsController.dispose();
    _fatsController.dispose();
    _portionController.dispose();
    _imageUrlController.dispose();
    _ingredientController.dispose();
    super.dispose();
  }

  void _saveMeal() async {
    if (!_formKey.currentState!.validate()) return;

    if (_ingredients.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please add at least one ingredient')),
      );
      return;
    }

    final meal = Meal(
      id: _isEditMode
          ? widget.existingMeal!.id
          : 'custom_meal_${const Uuid().v4()}',
      name: _nameController.text.trim(),
      category: _selectedCategory,
      ingredients: _ingredients,
      calories: double.parse(_caloriesController.text),
      protein: double.parse(_proteinController.text),
      carbs: double.parse(_carbsController.text),
      fats: double.parse(_fatsController.text),
      portionSize: double.parse(_portionController.text),
      imageUrl: _imageUrlController.text.trim(), // ✅ Use provided URL
      description: _descriptionController.text.trim(),
    );

    if (_isEditMode) {
      // ✅ Update existing meal
      await StorageService.updateCustomMeal(meal);
      MockDataRepository.updateMeal(meal);
    } else {
      // ✅ Create new meal
      await StorageService.saveCustomMeal(meal);
      MockDataRepository.addCustomMeal(meal);
    }

    if (mounted) {
      Navigator.pop(context, true); // ✅ Return true to trigger refresh
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(_isEditMode ? 'Meal updated!' : 'Meal created!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(_isEditMode ? 'Edit Meal' : 'Create Custom Meal'),
          actions: [
            TextButton(
              onPressed: _saveMeal,
              child: const Text(
                'SAVE',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        body: Form(
          key: _formKey,
          child: ListView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            padding: const EdgeInsets.all(16),
            children: [
              // Name
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Meal Name *',
                  hintText: 'e.g., Chicken Salad',
                ),
                textInputAction: TextInputAction.next,
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Required' : null,
              ),
              const SizedBox(height: 16),

              // Category
              DropdownButtonFormField<String>(
                initialValue: _selectedCategory,
                decoration: const InputDecoration(labelText: 'Category'),
                items: ['Breakfast', 'Lunch', 'Dinner', 'Snacks']
                    .map(
                        (cat) => DropdownMenuItem(value: cat, child: Text(cat)))
                    .toList(),
                onChanged: (value) =>
                    setState(() => _selectedCategory = value!),
              ),
              const SizedBox(height: 16),

              // Description
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description *',
                  hintText: 'Brief description',
                ),
                maxLines: 2,
                textInputAction: TextInputAction.next,
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Required' : null,
              ),
              const SizedBox(height: 16),

              // ✅ Image URL (optional)
              TextFormField(
                controller: _imageUrlController,
                decoration: const InputDecoration(
                  labelText: 'Image URL (optional)',
                  hintText: 'https://example.com/image.jpg',
                  prefixIcon: Icon(Icons.image),
                ),
                keyboardType: TextInputType.url,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 24),

              // Macros header
              const Text('Macros',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),

              // Macros grid
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _caloriesController,
                      decoration:
                          const InputDecoration(labelText: 'Calories *'),
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      textInputAction: TextInputAction.next,
                      validator: (value) =>
                          value?.isEmpty ?? true ? 'Required' : null,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _proteinController,
                      decoration:
                          const InputDecoration(labelText: 'Protein (g) *'),
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      textInputAction: TextInputAction.next,
                      validator: (value) =>
                          value?.isEmpty ?? true ? 'Required' : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _carbsController,
                      decoration:
                          const InputDecoration(labelText: 'Carbs (g) *'),
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      textInputAction: TextInputAction.next,
                      validator: (value) =>
                          value?.isEmpty ?? true ? 'Required' : null,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _fatsController,
                      decoration:
                          const InputDecoration(labelText: 'Fats (g) *'),
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      textInputAction: TextInputAction.next,
                      validator: (value) =>
                          value?.isEmpty ?? true ? 'Required' : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Portion size
              TextFormField(
                controller: _portionController,
                decoration:
                    const InputDecoration(labelText: 'Portion Size (g) *'),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                textInputAction: TextInputAction.done,
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Required' : null,
              ),
              const SizedBox(height: 24),

              // Ingredients
              Row(
                children: [
                  const Text('Ingredients',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const Spacer(),
                  Text('${_ingredients.length} added',
                      style: const TextStyle(color: Colors.grey)),
                ],
              ),
              const SizedBox(height: 12),

              // Add ingredient row
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _ingredientController,
                      decoration: const InputDecoration(
                        hintText: 'e.g., Chicken breast 150g',
                        border: OutlineInputBorder(),
                      ),
                      textInputAction: TextInputAction.done,
                      onSubmitted: (_) => _addIngredient(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton.filled(
                    icon: const Icon(Icons.add),
                    onPressed: _addIngredient,
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Ingredients list
              ..._ingredients.asMap().entries.map((entry) {
                return Card(
                  child: ListTile(
                    leading: const Icon(Icons.check_circle,
                        color: Color(0xFF4CAF50)),
                    title: Text(entry.value),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () =>
                          setState(() => _ingredients.removeAt(entry.key)),
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  void _addIngredient() {
    final ingredient = _ingredientController.text.trim();
    if (ingredient.isNotEmpty) {
      setState(() {
        _ingredients.add(ingredient);
        _ingredientController.clear();
      });
    }
  }
}
