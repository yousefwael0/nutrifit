import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:nutrifit/providers/providers.dart';
import 'package:nutrifit/screens/tabs/home_tab.dart';
import 'package:nutrifit/screens/tabs/meals_tab.dart';
import 'package:nutrifit/screens/tabs/workout_tab.dart';
import 'package:nutrifit/screens/tabs/progress_tab.dart'; // ✅ New import
import 'package:nutrifit/screens/tabs/malnutrition_tab.dart';
import 'package:nutrifit/screens/settings_screen.dart';

/// Main home screen with bottom navigation
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  late AnimationController _animationController;
  late Animation<double> _animation;

  // ✅ Updated screens - added ProgressTab
  late final List<Widget> _screens = const [
    HomeTab(),
    MealsTab(),
    WorkoutTab(),
    ProgressTab(), // ✅ New tab
    MalnutritionTab(),
  ];

  // ✅ Updated titles and icons
  final List<String> _tabTitles = [
    'Home',
    'Meals',
    'Workouts',
    'Progress', // ✅ New
    'Body Analysis'
  ];

  final List<IconData> _tabIcons = [
    Icons.home,
    Icons.restaurant,
    Icons.fitness_center,
    Icons.show_chart, // ✅ New icon
    Icons.accessibility,
  ];

  @override
  void initState() {
    super.initState();

    // Smooth fade animation for tab switches
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _animationController.forward();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UserProvider>().loadUser();
      context.read<FavoritesProvider>().initialize();
      context
          .read<ProgressProvider>()
          .initializeDemoData(); // ✅ Initialize progress data
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onTabChanged(int index) {
    if (_selectedIndex == index) return;

    setState(() {
      _selectedIndex = index;
      _animationController.reset();
      _animationController.forward();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_tabTitles[_selectedIndex]),
        elevation: 0,
        actions: [
          // Profile icon button with smooth navigation
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  _createRoute(const SettingsScreen()),
                );
              },
              child: Hero(
                tag: 'profile_icon',
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Icon(Icons.person, color: Color(0xFF4CAF50)),
                ),
              ),
            ),
          ),
        ],
      ),
      body: FadeTransition(
        opacity: _animation,
        child: IndexedStack(
          index: _selectedIndex,
          children: _screens,
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onTabChanged,
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

  /// Custom slide-up route transition
  Route _createRoute(Widget destination) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => destination,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.easeInOutCubic;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);

        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }
}
