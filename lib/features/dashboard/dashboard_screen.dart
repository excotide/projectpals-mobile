import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/constants/app_colors.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../shared/widgets/app_bottom_nav.dart';
import '../../shared/widgets/main_scaffold.dart';
import './widgets/notification_dialog.dart';
import '../room/presentation/screens/create_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        final displayName = state is AuthAuthenticated
            ? state.user.name.split(' ').first
            : 'there';

        return Scaffold(
          backgroundColor: AppColors.darkBlueBg,
          body: SafeArea(
            child: SingleChildScrollView(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: const BoxDecoration(
                              color: Colors.white10,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.person,
                                color: Colors.white, size: 30),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Welcome Back,',
                                  style: TextStyle(
                                      color: AppColors.textGrey,
                                      fontSize: 13)),
                              Text(displayName,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () => showNotificationDialog(context),
                        child: Stack(
                          children: [
                            const Icon(Icons.notifications,
                                color: Colors.white, size: 28),
                            Positioned(
                              right: 0,
                              top: 0,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: const BoxDecoration(
                                    color: Colors.orange,
                                    shape: BoxShape.circle),
                                child: const Text('1',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 8,
                                        fontWeight: FontWeight.bold)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),

                  // Active Projects Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.primaryCyan,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Active Projects',
                                style: TextStyle(
                                    color: Color(0xFF003642),
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold)),
                            Icon(Icons.arrow_forward_ios,
                                size: 12, color: Color(0xFF003642)),
                          ],
                        ),
                        const SizedBox(height: 15),
                        GestureDetector(
                          onTap: () => MainScaffold.of(context)?.switchTab(2),
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: const Color(0xFF002B35)
                                  .withValues(alpha: 0.9),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: const Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                Text('My Rooms',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600)),
                                Text('View All →',
                                    style: TextStyle(
                                        color: AppColors.mintGreen,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Quick Access
                  const Text('Quick Access',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      _QuickBtn(
                        icon: Icons.rocket_launch,
                        label: 'Create Room',
                        onTap: () => Navigator.push(context,
                            buildSlideRoute(const CreateRoomScreen())),
                      ),
                      const SizedBox(width: 15),
                      _QuickBtn(
                        icon: Icons.groups,
                        label: 'Join Room',
                        onTap: () =>
                            MainScaffold.of(context)?.switchTab(1),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),

                  // Profile quick info
                  if (state is AuthAuthenticated) ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Your Account',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold)),
                        GestureDetector(
                          onTap: () => MainScaffold.of(context)?.switchTab(3),
                          child: const Text('Profile →',
                              style: TextStyle(
                                  color: AppColors.textGrey, fontSize: 12)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0D1B2A),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: const BoxDecoration(
                              color: Colors.white10,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.person,
                                color: AppColors.primaryCyan, size: 24),
                          ),
                          const SizedBox(width: 14),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(state.user.name,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold)),
                              Text(state.user.username,
                                  style: const TextStyle(
                                      color: AppColors.textGrey,
                                      fontSize: 12)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: AppColors.primaryCyan,
            onPressed: () => Navigator.push(
                context, buildSlideRoute(const CreateRoomScreen())),
            shape: const CircleBorder(),
            child: const Icon(Icons.add, color: Color(0xFF003642), size: 30),
          ),
        );
      },
    );
  }
}

class _QuickBtn extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _QuickBtn(
      {required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFF1B263B).withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            children: [
              Icon(icon, color: AppColors.primaryCyan, size: 28),
              const SizedBox(height: 10),
              Text(label,
                  style: const TextStyle(
                      color: AppColors.primaryCyan,
                      fontSize: 12,
                      fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }
}
