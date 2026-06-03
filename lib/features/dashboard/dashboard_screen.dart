import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/constants/app_colors.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../shared/widgets/app_bottom_nav.dart';
import '../../shared/widgets/main_scaffold.dart';
import './widgets/notification_dialog.dart';
import '../room/presentation/screens/create_screen.dart';
import '../room/domain/entities/room_entity.dart';
import '../room/presentation/bloc/room_bloc.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  // ── Palette dekoratif ──
  static const Color _accent        = Color(0xFF7C9EFF);
  static const Color _accentLight   = Color(0xFFB8CDFF);
  static const Color _accentBlue    = Color(0xFF4B6EF5);
  static const Color _accentVibrant = Color(0xFF5B7FFF);
  static const Color _green         = Color(0xFF4ADE80);

  @override
  void initState() {
    super.initState();
    context.read<RoomBloc>().add(RoomMyRoomsLoadRequested());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        final displayName = state is AuthAuthenticated
            ? state.user.name.split(' ').first
            : 'there';

        return Scaffold(
          // BG halaman — sama dengan ProfileScreen
          backgroundColor: AppColors.darkBlueBg,
          body: SafeArea(
            child: SingleChildScrollView(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Header ──────────────────────────────────────────────
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          // Avatar — gradient biru palette baru
                          Container(
                            width: 46,
                            height: 46,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                colors: [_accentBlue, _accent],
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
                              Text(
                                'Welcome Back,',
                                style: TextStyle(
                                    color: Colors.white.withValues(alpha: 0.4),
                                    fontSize: 12),
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
                              width: 38,
                              height: 38,
                              decoration: BoxDecoration(
                                color: const Color(0xFF1E2640),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                    color: Colors.white.withValues(alpha: 0.08)),
                              ),
                              child: Icon(
                                Icons.notifications_outlined,
                                color: Colors.white.withValues(alpha: 0.7),
                                size: 19,
                              ),
                            ),
                            Positioned(
                              top: 8,
                              right: 8,
                              child: Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                  color: _green,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // ── Active Projects Card ─────────────────────────────────
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      // BG card — sama dengan ProfileScreen
                      color: AppColors.cardBg,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.borderColor),
                      boxShadow: [
                        BoxShadow(
                          color: _accentVibrant.withValues(alpha: 0.08),
                          blurRadius: 20,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Gradient text label
                            ShaderMask(
                              shaderCallback: (bounds) =>
                                  const LinearGradient(
                                colors: [_accent, _accentLight],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ).createShader(bounds),
                              child: const Text(
                                'Active Projects',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            GestureDetector(
                              onTap: () =>
                                  MainScaffold.of(context)?.switchTab(2),
                              child: Row(
                                children: [
                                  Text(
                                    'More Details',
                                    style: TextStyle(
                                        color: _accent.withValues(alpha: 0.8),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  const SizedBox(width: 4),
                                  Icon(Icons.arrow_forward_ios,
                                      size: 11,
                                      color: _accent.withValues(alpha: 0.8)),
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
                              color: const Color(0xFF1A2035),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.06)),
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
                                    color: _green.withValues(alpha: 0.12),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                        color: _green.withValues(alpha: 0.4),
                                        width: 1),
                                  ),
                                  child: const Text(
                                    'Day 3 · On Going',
                                    style: TextStyle(
                                        color: _green,
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

                  // ── Quick Access ─────────────────────────────────────────
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

                  // ── Your Projects Team ───────────────────────────────────
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
                        child: Row(
                          children: [
                            Text(
                              'More Details',
                              style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.4),
                                  fontSize: 12),
                            ),
                            const SizedBox(width: 4),
                            Icon(Icons.arrow_forward_ios,
                                size: 11,
                                color: Colors.white.withValues(alpha: 0.4)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // Project item cards — diambil dari my-rooms (RoomBloc)
                  const _DashboardProjectsList(),

                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
          floatingActionButton: Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [_accent, _accentLight],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: _accentVibrant.withValues(alpha: 0.35),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: IconButton(
              onPressed: () => Navigator.push(
                  context, buildSlideRoute(const CreateRoomScreen())),
              icon: const Icon(Icons.add,
                  color: Color(0xFF0D1B3E), size: 28),
            ),
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

  static const Color _accent      = Color(0xFF7C9EFF);
  static const Color _accentLight = Color(0xFFB8CDFF);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 22),
          decoration: BoxDecoration(
            // BG card — sama dengan ProfileScreen
            color: AppColors.cardBg,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.borderColor),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ShaderMask(
                shaderCallback: (bounds) => const LinearGradient(
                  colors: [_accent, _accentLight],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ).createShader(bounds),
                child: Icon(icon, color: Colors.white, size: 30),
              ),
              const SizedBox(height: 10),
              ShaderMask(
                shaderCallback: (bounds) => const LinearGradient(
                  colors: [_accent, _accentLight],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ).createShader(bounds),
                child: Text(
                  label,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Projects list (from my-rooms) ───────────────────────────────────────────────
class _DashboardProjectsList extends StatelessWidget {
  const _DashboardProjectsList();

  String _statusLabel(String status) => switch (status) {
        'open' => 'OPEN',
        'matching' => 'MATCHING',
        'ongoing' || 'in_progress' || 'matched' => 'ON GOING',
        'completed' => 'COMPLETED',
        'closed' => 'CLOSED',
        _ => status.toUpperCase(),
      };

  Color _statusColor(String status) => switch (status) {
        'open' || 'ongoing' || 'in_progress' || 'matched' => AppColors.mintGreen,
        'matching' => Colors.orange,
        _ => AppColors.textGrey,
      };

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RoomBloc, RoomState>(
      builder: (context, state) {
        if (state is RoomLoading) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Center(
              child: SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                    strokeWidth: 2, color: AppColors.primaryCyan),
              ),
            ),
          );
        }

        if (state is RoomMyRoomsLoaded && state.rooms.isNotEmpty) {
          final rooms = state.rooms.take(3).toList();
          return Column(
            children: [
              for (final RoomEntity room in rooms) ...[
                _ProjectTeamItem(
                  name: room.projectTheme,
                  subtitle: room.roles.isNotEmpty
                      ? room.roles.join(' · ')
                      : room.roomCode,
                  status: _statusLabel(room.status),
                  statusColor: _statusColor(room.status),
                ),
                const SizedBox(height: 10),
              ],
            ],
          );
        }

        // Kosong / belum login / gagal
        return const _ProjectTeamItem(
          name: 'No projects yet',
          subtitle: 'Join or create a room to start',
          status: null,
          statusColor: Colors.transparent,
        );
      },
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
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
              color: Colors.white.withValues(alpha: 0.07), width: 1),
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
                style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.4), fontSize: 12),
              ),
            ],
          ),
          if (status != null)
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: statusColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                    color: statusColor.withValues(alpha: 0.4), width: 1),
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