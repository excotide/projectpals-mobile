// ── my_rooms_screen.dart ──────────────────────────────────────────────────────
// Letakkan di: lib/features/room/presentation/screens/my_rooms_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../domain/entities/room_entity.dart';
import '../bloc/room_bloc.dart';
import 'team_dashboard_screen.dart';

/// Format tanggal ISO (mis. `2026-05-11T08:00:00Z`) → `May 11, 2026`.
String _formatDate(String? iso) {
  if (iso == null) return '';
  final dt = DateTime.tryParse(iso);
  if (dt == null) return '';
  const months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];
  final local = dt.toLocal();
  return '${months[local.month - 1]} ${local.day}, ${local.year}';
}

class MyRoomsScreen extends StatefulWidget {
  const MyRoomsScreen({super.key});

  @override
  State<MyRoomsScreen> createState() => _MyRoomsScreenState();
}

class _MyRoomsScreenState extends State<MyRoomsScreen> {
  List<RoomEntity> _rooms = [];
  bool _isLoading = true;
  String? _error;
  int _selectedTab = 0; // 0=All, 1=Open, 2=Ongoing

  // ── Color palette ──
  // BG halaman — sama dengan ProfileScreen
  static Color get _bgColor => AppColors.darkBlueBg;

  static const Color _accent      = Color(0xFF7C9EFF);
  static const Color _accentLight = Color(0xFFB8CDFF);
  static const Color _accentBlue  = Color(0xFF4B6EF5);
  static const Color _surface     = Color(0xFF1A2035);
  static const Color _navyBg      = Color(0xFF1E2640);

  @override
  void initState() {
    super.initState();
    context.read<RoomBloc>().add(RoomMyRoomsLoadRequested());
  }

  void _reload() {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    context.read<RoomBloc>().add(RoomMyRoomsLoadRequested());
  }

  List<RoomEntity> get _filteredRooms {
    if (_selectedTab == 1) {
      return _rooms.where((r) => r.status == 'open').toList();
    } else if (_selectedTab == 2) {
      return _rooms
          .where((r) =>
              r.status == 'ongoing' ||
              r.status == 'in_progress' ||
              r.status == 'matched')
          .toList();
    }
    return _rooms;
  }

  int get _openCount =>
      _rooms.where((r) => r.status == 'open').length;

  int get _ongoingCount => _rooms
      .where((r) =>
          r.status == 'ongoing' ||
          r.status == 'in_progress' ||
          r.status == 'matched')
      .length;

  @override
  Widget build(BuildContext context) {
    return BlocListener<RoomBloc, RoomState>(
      listener: (context, state) {
        if (state is RoomMyRoomsLoaded) {
          setState(() {
            _rooms = state.rooms;
            _isLoading = false;
            _error = null;
          });
        } else if (state is RoomFailure) {
          if (_isLoading) {
            setState(() {
              _isLoading = false;
              _error = state.message;
            });
          } else {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.red,
              behavior: SnackBarBehavior.floating,
            ));
          }
        } else if (state is RoomLeft ||
            state is RoomDeleted ||
            state is RoomUpdated ||
            state is RoomJoined ||
            state is RoomCreated) {
          _reload();
        }
      },
      child: Scaffold(
        // ── BG sama dengan ProfileScreen ──
        backgroundColor: _bgColor,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTopBar(),
              const SizedBox(height: 16),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'My Rooms',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.5,
                      ),
                    ),
                    SizedBox(height: 3),
                    Text(
                      'All the rooms you own or are a member of.',
                      style: TextStyle(
                        color: Color(0x60FFFFFF),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              _buildFilterTabs(),
              const SizedBox(height: 14),
              Expanded(child: _buildBody()),
            ],
          ),
        ),
      ),
    );
  }

  // ── Top bar ────────────────────────────────────────────────────────────────

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              ShaderMask(
                shaderCallback: (bounds) => const LinearGradient(
                  colors: [_accent, _accentLight],
                ).createShader(bounds),
                child: const Icon(
                  Icons.rocket_launch_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 8),
              ShaderMask(
                shaderCallback: (bounds) => const LinearGradient(
                  colors: [_accent, _accentLight],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ).createShader(bounds),
                child: const Text(
                  'ProjectPals',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.3,
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: _navyBg,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
                ),
                child: Icon(
                  Icons.search_rounded,
                  color: Colors.white.withValues(alpha: 0.65),
                  size: 18,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    colors: [_accentBlue, _accent],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  border: Border.all(
                    color: _accent.withValues(alpha: 0.5),
                    width: 1.5,
                  ),
                ),
                child:
                    const Icon(Icons.person, color: Colors.white, size: 19),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Filter tabs ────────────────────────────────────────────────────────────

  Widget _buildFilterTabs() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(
            child: _TabChip(
              label: 'All',
              count: _rooms.length,
              selected: _selectedTab == 0,
              onTap: () => setState(() => _selectedTab = 0),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _TabChip(
              label: 'Open',
              count: _openCount,
              selected: _selectedTab == 1,
              onTap: () => setState(() => _selectedTab = 1),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _TabChip(
              label: 'Ongoing',
              count: _ongoingCount,
              selected: _selectedTab == 2,
              onTap: () => setState(() => _selectedTab = 2),
            ),
          ),
        ],
      ),
    );
  }

  // ── Body ───────────────────────────────────────────────────────────────────

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: _accent),
      );
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.wifi_off,
                color: Colors.white.withValues(alpha: 0.3), size: 48),
            const SizedBox(height: 16),
            Text(
              _error!,
              style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.5), fontSize: 14),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _reload,
              style: ElevatedButton.styleFrom(
                backgroundColor: _accent,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
              ),
              child: const Text('Retry',
                  style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      );
    }

    final rooms = _filteredRooms;

    if (rooms.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inbox_outlined,
                color: Colors.white.withValues(alpha: 0.2), size: 52),
            const SizedBox(height: 14),
            Text(
              'No rooms found',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.45),
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      itemCount: rooms.length + 1,
      itemBuilder: (context, i) {
        if (i == rooms.length) return _buildStartFresh();
        final room = rooms[i];
        final authState = context.read<AuthBloc>().state;
        final isOwner = authState is AuthAuthenticated &&
            room.createdBy == authState.user.id;
        return Padding(
          padding: const EdgeInsets.only(bottom: 14),
          child: _MyRoomCard(
            room: room,
            isOwner: isOwner,
            onOpenRoom: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => TeamDashboardScreen(room: room)),
            ),
          ),
        );
      },
    );
  }

  Widget _buildStartFresh() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Column(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _surface,
              border: Border.all(
                  color: Colors.white.withValues(alpha: 0.12), width: 1.5),
            ),
            child: Icon(Icons.add,
                color: Colors.white.withValues(alpha: 0.4), size: 22),
          ),
          const SizedBox(height: 10),
          Text(
            'Start Fresh',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.65),
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            'Create a new collaborative room',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.25),
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Tab Chip ───────────────────────────────────────────────────────────────────

class _TabChip extends StatelessWidget {
  final String label;
  final int count;
  final bool selected;
  final VoidCallback onTap;

  const _TabChip({
    required this.label,
    required this.count,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          gradient: selected
              ? const LinearGradient(
                  colors: [Color(0xFFB8CDFF), Color(0xFF3B5FD9)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                )
              : null,
          color: selected ? null : const Color(0xFF1A2035),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: selected
                ? Colors.transparent
                : Colors.white.withValues(alpha: 0.08),
          ),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: const Color(0xFF3B5FD9).withValues(alpha: 0.35),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Text(
              label,
              style: TextStyle(
                color: selected
                    ? const Color(0xFF0D1B3E)
                    : Colors.white.withValues(alpha: 0.6),
                fontSize: 12,
                fontWeight:
                    selected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
            const SizedBox(width: 5),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
              decoration: BoxDecoration(
                color: selected
                    ? const Color(0xFF0D1B3E).withValues(alpha: 0.18)
                    : Colors.white.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '$count',
                style: TextStyle(
                  color: selected
                      ? const Color(0xFF0D1B3E)
                      : Colors.white.withValues(alpha: 0.5),
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── My Room Card ───────────────────────────────────────────────────────────────

class _MyRoomCard extends StatelessWidget {
  final RoomEntity room;
  final bool isOwner;
  final VoidCallback onOpenRoom;

  const _MyRoomCard({
    required this.room,
    required this.isOwner,
    required this.onOpenRoom,
  });

  Color get _statusColor => switch (room.status) {
        'open' => const Color(0xFF4ADE80),
        'ongoing' || 'in_progress' || 'matched' => const Color(0xFF4ADE80),
        'matching' => const Color(0xFFFBBF24),
        _ => Colors.white38,
      };

  String get _statusLabel => switch (room.status) {
        'open' => 'OPEN',
        'ongoing' || 'in_progress' || 'matched' => 'ONGOING',
        'matching' => 'MATCHING',
        'completed' => 'COMPLETED',
        'closed' => 'CLOSED',
        _ => room.status.toUpperCase(),
      };

  Color get _statusBg => switch (room.status) {
        'open' => const Color(0xFF4ADE80).withValues(alpha: 0.12),
        'ongoing' || 'in_progress' || 'matched' =>
          const Color(0xFF4ADE80).withValues(alpha: 0.12),
        'matching' => const Color(0xFFFBBF24).withValues(alpha: 0.12),
        _ => Colors.white.withValues(alpha: 0.05),
      };

  Color get _statusBorder => switch (room.status) {
        'open' => const Color(0xFF4ADE80).withValues(alpha: 0.3),
        'ongoing' || 'in_progress' || 'matched' =>
          const Color(0xFF4ADE80).withValues(alpha: 0.3),
        'matching' => const Color(0xFFFBBF24).withValues(alpha: 0.3),
        _ => Colors.white.withValues(alpha: 0.1),
      };

  List<Color> get _cardBorderColors => switch (room.status) {
        'open' => [
            const Color(0xFF4ADE80).withValues(alpha: 0.4),
            const Color(0xFF4ADE80).withValues(alpha: 0.05),
          ],
        'ongoing' || 'in_progress' || 'matched' => [
            const Color(0xFF4ADE80).withValues(alpha: 0.4),
            const Color(0xFF4ADE80).withValues(alpha: 0.05),
          ],
        _ => [
            Colors.white.withValues(alpha: 0.08),
            Colors.white.withValues(alpha: 0.02),
          ],
      };

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        // ── BG card sama dengan ProfileScreen ──
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: _cardBorderColors[0]),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Row 1: Status badge + room code ──
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _statusBg,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: _statusBorder),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 5,
                        height: 5,
                        decoration: BoxDecoration(
                          color: _statusColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _statusLabel,
                        style: TextStyle(
                          color: _statusColor,
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Text(
                  room.roomCode,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.28),
                    fontSize: 9,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // ── Project name ──
            Text(
              room.projectTheme,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.3,
                height: 1.2,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 3),

            // ── Owner / Member ──
            Text(
              isOwner ? 'Created by you' : 'Joined room',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.35),
                fontSize: 11,
              ),
            ),
            const SizedBox(height: 2),

            // ── Date ──
            Text(
              _formatDate(room.createdAt),
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.28),
                fontSize: 11,
              ),
            ),
            const SizedBox(height: 10),

            // ── Stats row ──
            Row(
              children: [
                Icon(Icons.people_outline_rounded,
                    color: Colors.white.withValues(alpha: 0.45), size: 14),
                const SizedBox(width: 4),
                Text(
                  '${room.maxPerGroup} max',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.45),
                    fontSize: 12,
                  ),
                ),
                const SizedBox(width: 16),
                Icon(Icons.grid_view_rounded,
                    color: Colors.white.withValues(alpha: 0.45), size: 14),
                const SizedBox(width: 4),
                Text(
                  '${room.numberOfGroups} teams',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.45),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // ── Roles chip row ──
            if (room.roles.isNotEmpty)
              Wrap(
                spacing: 6,
                runSpacing: 4,
                children: [
                  ...room.roles.take(3).map((role) => Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 9, vertical: 4),
                        decoration: BoxDecoration(
                          color:
                              const Color(0xFF7C9EFF).withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                              color: const Color(0xFF7C9EFF)
                                  .withValues(alpha: 0.2)),
                        ),
                        child: Text(
                          role,
                          style: const TextStyle(
                            color: Color(0xFF7C9EFF),
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      )),
                  if (room.roles.length > 3)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 9, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.04),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                            color: Colors.white.withValues(alpha: 0.08)),
                      ),
                      child: Text(
                        '+${room.roles.length - 3} more',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.35),
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                ],
              ),
            const SizedBox(height: 14),

            // ── Bottom row: Copy Code | Open Room ──
            Row(
              children: [
                // Copy Code
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Clipboard.setData(
                          ClipboardData(text: room.roomCode));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Code copied!'),
                          duration: Duration(seconds: 2),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 11),
                      decoration: BoxDecoration(
                        // ── BG card sama dengan ProfileScreen ──
                        color: AppColors.cardBg,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppColors.borderColor),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.copy_rounded,
                              color: Colors.white.withValues(alpha: 0.6),
                              size: 14),
                          const SizedBox(width: 6),
                          Text(
                            'Copy Code',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.6),
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                // Open Room
                Expanded(
                  child: GestureDetector(
                    onTap: onOpenRoom,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 11),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFB8CDFF), Color(0xFF3B5FD9)],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color:
                                const Color(0xFF3B5FD9).withValues(alpha: 0.35),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Open Room',
                            style: TextStyle(
                              color: Color(0xFF0D1B3E),
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(width: 6),
                          Icon(Icons.arrow_forward_rounded,
                              color: Color(0xFF0D1B3E), size: 14),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}