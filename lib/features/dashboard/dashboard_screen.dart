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
                  // ── Header ──
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          // Avatar circle dengan warna seperti design
                          Container(
                            width: 46,
                            height: 46,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: const LinearGradient(
                                colors: [Color(0xFFFF6B6B), Color(0xFFFF8E53)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                            ),
                            child: const Icon(Icons.person,
                                color: Colors.white, size: 26),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Welcome Back,',
                                style: TextStyle(
                                    color: AppColors.textGrey, fontSize: 12),
                              ),
                              Text(
                                displayName,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ],
                      ),
                      // Notification bell
                      GestureDetector(
                        onTap: () => showNotificationDialog(context),
                        child: Stack(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white10,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.notifications_outlined,
                                  color: Colors.white, size: 22),
                            ),
                            Positioned(
                              right: 4,
                              top: 4,
                              child: Container(
                                width: 10,
                                height: 10,
                                decoration: const BoxDecoration(
                                    color: Colors.orange,
                                    shape: BoxShape.circle),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // ── Active Projects Card ──
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: AppColors.primaryCyan,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Active Projects',
                              style: TextStyle(
                                  color: Color(0xFF003642),
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold),
                            ),
                            GestureDetector(
                              onTap: () =>
                                  MainScaffold.of(context)?.switchTab(2),
                              child: const Row(
                                children: [
                                  Text(
                                    'More Details',
                                    style: TextStyle(
                                        color: Color(0xFF003642),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  SizedBox(width: 4),
                                  Icon(Icons.arrow_forward_ios,
                                      size: 11, color: Color(0xFF003642)),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        GestureDetector(
                          onTap: () =>
                              MainScaffold.of(context)?.switchTab(2),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 12),
                            decoration: BoxDecoration(
                              color: const Color(0xFF002B35)
                                  .withValues(alpha: 0.85),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'My Rooms',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: AppColors.mintGreen
                                        .withValues(alpha: 0.2),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                        color: AppColors.mintGreen,
                                        width: 1),
                                  ),
                                  child: const Text(
                                    'Day 3 · On Going',
                                    style: TextStyle(
                                        color: AppColors.mintGreen,
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),

                  // ── Quick Access ──
                  const Text(
                    'Quick Access',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      _QuickBtn(
                        icon: Icons.rocket_launch,
                        label: 'Create Room',
                        onTap: () => Navigator.push(context,
                            buildSlideRoute(const CreateRoomScreen())),
                      ),
                      const SizedBox(width: 14),
                      _QuickBtn(
                        icon: Icons.groups,
                        label: 'Join Room',
                        onTap: () =>
                            MainScaffold.of(context)?.switchTab(1),
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),

                  // ── Your Projects Team ──
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Your Projects Team',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                      GestureDetector(
                        onTap: () =>
                            MainScaffold.of(context)?.switchTab(2),
                        child: const Row(
                          children: [
                            Text(
                              'More Details',
                              style: TextStyle(
                                  color: AppColors.textGrey, fontSize: 12),
                            ),
                            SizedBox(width: 4),
                            Icon(Icons.arrow_forward_ios,
                                size: 11, color: AppColors.textGrey),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // Project item cards (dari state jika ada, atau placeholder)
                  if (state is AuthAuthenticated) ...[
                    _ProjectTeamItem(
                      name: state.user.name,
                      subtitle: 'Frontend · 3 months',
                      status: 'COMPLETED',
                      statusColor: AppColors.mintGreen,
                    ),
                    const SizedBox(height: 10),
                    _ProjectTeamItem(
                      name: state.user.username,
                      subtitle: 'FullStack · 1 year',
                      status: 'COMPLETED',
                      statusColor: AppColors.mintGreen,
                    ),
                  ] else ...[
                    _ProjectTeamItem(
                      name: 'No projects yet',
                      subtitle: 'Join or create a room to start',
                      status: null,
                      statusColor: Colors.transparent,
                    ),
                  ],

                  const SizedBox(height: 100),
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

// ── Quick Access Button ────────────────────────────────────────────────────────
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
          padding: const EdgeInsets.symmetric(vertical: 22),
          decoration: BoxDecoration(
            color: const Color(0xFF1B263B).withValues(alpha: 0.6),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.borderColor, width: 1),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: AppColors.primaryCyan, size: 30),
              const SizedBox(height: 10),
              Text(
                label,
                style: const TextStyle(
                    color: AppColors.primaryCyan,
                    fontSize: 12,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Project Team Item ──────────────────────────────────────────────────────────
class _ProjectTeamItem extends StatelessWidget {
  final String name;
  final String subtitle;
  final String? status;
  final Color statusColor;

  const _ProjectTeamItem({
    required this.name,
    required this.subtitle,
    required this.status,
    required this.statusColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 2),
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 14),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColors.borderColor, width: 1),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(
                    color: AppColors.textGrey, fontSize: 12),
              ),
            ],
          ),
          if (status != null)
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: statusColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: statusColor, width: 1),
              ),
              child: Text(
                status!,
                style: TextStyle(
                    color: statusColor,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5),
              ),
            ),
        ],
      ),
    );
  }
}