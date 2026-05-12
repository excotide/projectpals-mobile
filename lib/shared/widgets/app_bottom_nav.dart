import 'package:flutter/material.dart';

class AppBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final Color selectedItemColor;

  const AppBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.selectedItemColor,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: const Color(0xFF05101C),
      type: BottomNavigationBarType.fixed,
      currentIndex: currentIndex,
      selectedItemColor: selectedItemColor,
      unselectedItemColor: Colors.white38,
      onTap: onTap,
      items: const [
        BottomNavigationBarItem(
            icon: Icon(Icons.grid_view_rounded), label: 'HOME'),
        BottomNavigationBarItem(icon: Icon(Icons.people), label: 'JOIN'),
        BottomNavigationBarItem(
            icon: Icon(Icons.analytics_outlined), label: 'ROOMS'),
        BottomNavigationBarItem(
            icon: Icon(Icons.person_outline), label: 'PROFILE'),
      ],
    );
  }
}

Route<T> buildSlideRoute<T>(Widget page) {
  return PageRouteBuilder<T>(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final tween = Tween<Offset>(
        begin: const Offset(1, 0),
        end: Offset.zero,
      ).chain(CurveTween(curve: Curves.easeOutCubic));
      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}
