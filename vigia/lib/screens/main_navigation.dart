import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/app_colors.dart';
import '../core/theme_manager.dart';
import 'home_screen.dart';
import 'route_map_screen.dart';
import 'profile_screen.dart';
import 'dashboard_screen.dart';

class MainNavigation extends StatelessWidget {
  const MainNavigation({super.key});

  final List<Widget> _screens = const [
    HomeScreen(),
    RouteMapScreen(),
    ProfileScreen(),
    DashboardScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeManager>();
    bool isDark = themeProvider.themeMode == ThemeMode.dark;
    Color primary = AppColors.getPrimary(context);

    return Scaffold(
      body: _screens[themeProvider.selectedIndex], 
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: themeProvider.selectedIndex,
        onTap: (index) => themeProvider.setIndex(index),
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppColors.getBackground(context),
        selectedItemColor: primary,
        unselectedItemColor: isDark ? Colors.white38 : Colors.black26,
        showSelectedLabels: true,
        showUnselectedLabels: false,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: 'Início'),
          BottomNavigationBarItem(icon: Icon(Icons.map_outlined), label: 'Mapa'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Perfil'),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart_outlined), label: 'Status'),
        ],
      ),
    );
  }
}