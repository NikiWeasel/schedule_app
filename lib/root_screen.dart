import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RootScreen extends StatelessWidget {
  const RootScreen(
      {super.key,
      required this.navigationShell,
      required this.hideNavigationBar});

  /// Контейнер для навигационного бара.
  final StatefulNavigationShell navigationShell;
  final bool hideNavigationBar;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: hideNavigationBar
          ? null
          : NavigationBar(
              indicatorColor: Theme.of(context).colorScheme.secondaryContainer,

              /// Лист элементов для нижнего навигационного бара.
              destinations: _buildBottomNavBarItems,

              /// Текущий индекс нижнего навигационного бара.
              selectedIndex: navigationShell.currentIndex,

              /// Обработчик нажатия на элемент нижнего навигационного бара.
              onDestinationSelected: (index) => navigationShell.goBranch(
                index,
                initialLocation: index == navigationShell.currentIndex,
              ),
            ),
    );
  }

  // Возвращает лист элементов для нижнего навигационного бара.
  List<NavigationDestination> get _buildBottomNavBarItems => const [
        NavigationDestination(
          selectedIcon: Icon(Icons.home),
          icon: Icon(Icons.home_outlined),
          label: 'Главная',
        ),
        NavigationDestination(
          selectedIcon: Icon(Icons.business),
          icon: Badge(child: Icon(Icons.business_outlined)),
          label: 'Регламент',
        ),
        NavigationDestination(
          selectedIcon: Icon(Icons.insert_drive_file),
          icon: Badge(child: Icon(Icons.insert_drive_file_outlined)),
          label: 'Портфолио',
        ),
        NavigationDestination(
          selectedIcon: Icon(Icons.person_2),
          icon: Icon(Icons.person_2_outlined),
          label: 'Профиль',
        ),
      ];
}
