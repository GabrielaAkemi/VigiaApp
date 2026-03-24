import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import 'home_screen.dart'; // Tela com as rotas e botões
import 'route_map_screen.dart';
import 'profile_screen.dart';
import 'dashboard_screen.dart';

class MainNavigation extends StatefulWidget {
  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;

  // Lista das telas na ordem da NavBar
  final List<Widget> _screens = [
    HomeScreen(),      // Tela Principal (Vigia + Rotas)
    RouteMapScreen(),   // Mapa
    ProfileScreen(),    // Perfil (Onde troca o tema)
    DashboardScreen(),  // Dashboard
  ];

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    Color primary = AppColors.getPrimary(context);

    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
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