import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/theme.dart';

/// Main Shell container with bottom navigation for the 5 primary tabs:
/// Home, Meals, Progress, Coach (Coming soon), Profile.
class MainShellScreen extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const MainShellScreen({
    super.key,
    required this.navigationShell,
  });

  void _onTap(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
          border: Border(
            top: BorderSide(
              color: isDark ? AppColors.borderDark : AppColors.borderLight,
              width: 1,
            ),
          ),
        ),
        child: SafeArea(
          top: false,
          child: NavigationBar(
            selectedIndex: navigationShell.currentIndex,
            onDestinationSelected: _onTap,
            backgroundColor: Colors.transparent,
            indicatorColor: AppColors.primaryContainer,
            elevation: 0,
            destinations: [
              const NavigationDestination(
                icon: Icon(Icons.home_outlined),
                selectedIcon: Icon(Icons.home_rounded, color: AppColors.primaryDark),
                label: 'Home',
              ),
              const NavigationDestination(
                icon: Icon(Icons.restaurant_menu_outlined),
                selectedIcon: Icon(Icons.restaurant_menu_rounded, color: AppColors.primaryDark),
                label: 'Meals',
              ),
              const NavigationDestination(
                icon: Icon(Icons.bar_chart_outlined),
                selectedIcon: Icon(Icons.bar_chart_rounded, color: AppColors.primaryDark),
                label: 'Progress',
              ),
              NavigationDestination(
                icon: Badge(
                  label: const Text(
                    'Soon',
                    style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold),
                  ),
                  backgroundColor: AppColors.coral,
                  child: const Icon(Icons.auto_awesome_outlined),
                ),
                selectedIcon: Badge(
                  label: const Text(
                    'Soon',
                    style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold),
                  ),
                  backgroundColor: AppColors.coral,
                  child: const Icon(Icons.auto_awesome_rounded, color: AppColors.primaryDark),
                ),
                label: 'Coach',
              ),
              const NavigationDestination(
                icon: Icon(Icons.person_outline_rounded),
                selectedIcon: Icon(Icons.person_rounded, color: AppColors.primaryDark),
                label: 'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
