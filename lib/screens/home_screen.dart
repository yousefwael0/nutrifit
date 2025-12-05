import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:nutrifit/providers/providers.dart';
import 'package:nutrifit/screens/tabs/home_tab.dart';
import 'package:nutrifit/screens/tabs/meals_tab.dart';
import 'package:nutrifit/screens/tabs/workout_tab.dart';
import 'package:nutrifit/screens/tabs/malnutrition_tab.dart';
import 'package:nutrifit/screens/settings_screen.dart';

/// Main home screen with bottom navigation
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  // Screens for each tab
  late final List<Widget> _screens = [
    const HomeTab(),
    const MealsTab(),
    const WorkoutTab(),
    const MalnutritionTab(),
  ];

  final List<String> _tabTitles = ['Home', 'Meals', 'Workouts', 'Malnutrition'];

  final List<IconData> _tabIcons = [
    Icons.home,
    Icons.restaurant,
    Icons.fitness_center,
    Icons.accessibility,
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Load user for HomeTab (fresh launch from Splash)
      context.read<UserProvider>().loadUser();
      // Initialize favorites without notifying during build
      context.read<FavoritesProvider>().initialize();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_tabTitles[_selectedIndex]),
        elevation: 0,
        actions: [
          // Profile icon button
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const SettingsScreen(),
                  ),
                );
              },
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(Icons.person, color: Color(0xFF4CAF50)),
              ),
            ),
          ),
        ],
      ),
      body: IndexedStack(index: _selectedIndex, children: _screens),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() => _selectedIndex = index);
        },
        type: BottomNavigationBarType.fixed,
        items: List.generate(
          _tabTitles.length,
          (index) => BottomNavigationBarItem(
            icon: Icon(_tabIcons[index]),
            label: _tabTitles[index],
          ),
        ),
      ),
    );
  }
}
