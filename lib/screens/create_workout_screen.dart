import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:nutrifit/models/models.dart';
import 'package:nutrifit/services/storage_service.dart';
import 'package:nutrifit/repositories/mock_data_repository.dart';

/// Screen for creating/editing custom workouts
class CreateWorkoutScreen extends StatefulWidget {
  final Workout? existingWorkout; // ✅ For edit mode

  const CreateWorkoutScreen({super.key, this.existingWorkout});

  @override
  State<CreateWorkoutScreen> createState() => _CreateWorkoutScreenState();
}

class _CreateWorkoutScreenState extends State<CreateWorkoutScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _durationController = TextEditingController();
  final _caloriesController = TextEditingController();
  final _imageUrlController = TextEditingController(); // ✅ New

  String _selectedCategory = 'Weight Lifting';
  final List<String> _steps = [];
  final _stepController = TextEditingController();
  final List<String> _targetMuscles = [];
  final _muscleController = TextEditingController();

  bool get _isEditMode => widget.existingWorkout != null; // ✅ Check mode

  @override
  void initState() {
    super.initState();

    // ✅ Pre-fill form if editing
    if (_isEditMode) {
      final workout = widget.existingWorkout!;
      _nameController.text = workout.name;
      _descriptionController.text = workout.description;
      _durationController.text = workout.durationMinutes.toString();
      _caloriesController.text = workout.caloriesBurned.toString();
      _imageUrlController.text = workout.imageUrl;
      _selectedCategory = workout.category;
      _steps.addAll(workout.steps);
      _targetMuscles.addAll(workout.targetMuscles);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _durationController.dispose();
    _caloriesController.dispose();
    _imageUrlController.dispose();
    _stepController.dispose();
    _muscleController.dispose();
    super.dispose();
  }

  void _saveWorkout() async {
    if (!_formKey.currentState!.validate()) return;

    if (_steps.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please add at least one step')),
      );
      return;
    }

    final workout = Workout(
      id: _isEditMode
          ? widget.existingWorkout!.id
          : 'custom_workout_${const Uuid().v4()}',
      name: _nameController.text.trim(),
      category: _selectedCategory,
      steps: _steps,
      targetMuscles: _targetMuscles,
      caloriesBurned: double.parse(_caloriesController.text),
      imageUrl: _imageUrlController.text.trim(), // ✅ Use provided URL
      description: _descriptionController.text.trim(),
      durationMinutes: int.parse(_durationController.text),
    );

    if (_isEditMode) {
      // ✅ Update existing workout
      await StorageService.updateCustomWorkout(workout);
      MockDataRepository.updateWorkout(workout);
    } else {
      // ✅ Create new workout
      await StorageService.saveCustomWorkout(workout);
      MockDataRepository.addCustomWorkout(workout);
    }

    if (mounted) {
      Navigator.pop(context, true); // ✅ Return true to trigger refresh
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text(_isEditMode ? 'Workout updated!' : 'Workout created!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(_isEditMode ? 'Edit Workout' : 'Create Custom Workout'),
          actions: [
            TextButton(
              onPressed: _saveWorkout,
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
                  labelText: 'Workout Name *',
                  hintText: 'e.g., Morning Stretch',
                ),
                textInputAction: TextInputAction.next,
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Required' : null,
              ),
              const SizedBox(height: 16),

              // Category
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: const InputDecoration(labelText: 'Category'),
                items: ['Weight Lifting', 'Cardio']
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
              const SizedBox(height: 16),

              // Duration and Calories
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _durationController,
                      decoration:
                          const InputDecoration(labelText: 'Duration (min) *'),
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      validator: (value) =>
                          value?.isEmpty ?? true ? 'Required' : null,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _caloriesController,
                      decoration:
                          const InputDecoration(labelText: 'Calories *'),
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      textInputAction: TextInputAction.done,
                      validator: (value) =>
                          value?.isEmpty ?? true ? 'Required' : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Steps
              Row(
                children: [
                  const Text('Steps',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const Spacer(),
                  Text('${_steps.length} added',
                      style: const TextStyle(color: Colors.grey)),
                ],
              ),
              const SizedBox(height: 12),

              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _stepController,
                      decoration: const InputDecoration(
                        hintText: 'e.g., Warm up for 5 minutes',
                        border: OutlineInputBorder(),
                      ),
                      textInputAction: TextInputAction.done,
                      onSubmitted: (_) => _addStep(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton.filled(
                    icon: const Icon(Icons.add),
                    onPressed: _addStep,
                  ),
                ],
              ),
              const SizedBox(height: 12),

              ..._steps.asMap().entries.map((entry) {
                return Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: const Color(0xFF4CAF50),
                      child: Text('${entry.key + 1}',
                          style: const TextStyle(color: Colors.white)),
                    ),
                    title: Text(entry.value),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () =>
                          setState(() => _steps.removeAt(entry.key)),
                    ),
                  ),
                );
              }),

              const SizedBox(height: 24),

              // Target Muscles
              Row(
                children: [
                  const Text('Target Muscles',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const Spacer(),
                  Text('${_targetMuscles.length} added',
                      style: const TextStyle(color: Colors.grey)),
                ],
              ),
              const SizedBox(height: 12),

              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _muscleController,
                      decoration: const InputDecoration(
                        hintText: 'e.g., Chest',
                        border: OutlineInputBorder(),
                      ),
                      textInputAction: TextInputAction.done,
                      onSubmitted: (_) => _addMuscle(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton.filled(
                    icon: const Icon(Icons.add),
                    onPressed: _addMuscle,
                  ),
                ],
              ),
              const SizedBox(height: 12),

              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _targetMuscles.map((muscle) {
                  return Chip(
                    label: Text(muscle),
                    onDeleted: () =>
                        setState(() => _targetMuscles.remove(muscle)),
                    backgroundColor:
                        const Color(0xFF4CAF50).withValues(alpha: 0.2),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _addStep() {
    final step = _stepController.text.trim();
    if (step.isNotEmpty) {
      setState(() {
        _steps.add(step);
        _stepController.clear();
      });
    }
  }

  void _addMuscle() {
    final muscle = _muscleController.text.trim();
    if (muscle.isNotEmpty && !_targetMuscles.contains(muscle)) {
      setState(() {
        _targetMuscles.add(muscle);
        _muscleController.clear();
      });
    }
  }
}
