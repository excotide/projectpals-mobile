import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../features/dashboard/dashboard_screen.dart';
import '../../features/profile/profile_screen.dart';
import '../../features/room/presentation/screens/join_screen.dart';
import '../../features/room/presentation/screens/room_screen.dart';
import 'app_bottom_nav.dart';

class MainScaffold extends StatefulWidget {
  final int initialIndex;
  const MainScaffold({super.key, this.initialIndex = 0});

  static MainScaffoldState? of(BuildContext context) =>
      context.findAncestorStateOfType<MainScaffoldState>();

  @override
  State<MainScaffold> createState() => MainScaffoldState();
}

class MainScaffoldState extends State<MainScaffold> {
  late int _currentIndex;

  static const _screens = <Widget>[
    DashboardScreen(),
    JoinRoomScreen(),
    RoomScreen(),
    ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  void switchTab(int index) {
    if (index == _currentIndex) return;
    setState(() => _currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBlueBg,
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: AppBottomNavBar(
        currentIndex: _currentIndex,
        selectedItemColor: AppColors.mintGreen,
        onTap: switchTab,
      ),
    );
  }
}
