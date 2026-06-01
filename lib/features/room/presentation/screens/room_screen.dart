// ── room_screen.dart ──────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../domain/entities/room_entity.dart';
import '../bloc/room_bloc.dart';
import 'room_detail_screen.dart';
import 'my_rooms_screen.dart'; // ← TAMBAHAN: import MyRoomsScreen

class RoomScreen extends StatefulWidget {
  const RoomScreen({super.key});

  @override
  State<RoomScreen> createState() => _RoomScreenState();
}

class _RoomScreenState extends State<RoomScreen> {
  List<RoomEntity> _rooms = [];
  bool _isLoading = true;
  String? _error;
  int _selectedTab = 0;
  final _searchController = TextEditingController();
  String _searchQuery = '';

  // ── hanya 2 warna ini yang diubah, pakai AppColors dari ProfileScreen ──
  static Color get _bgColor   => AppColors.darkBlueBg; // sama persis dengan ProfileScreen
  static Color get _cardColor => AppColors.cardBg;     // sama persis dengan ProfileScreen

  static const Color _accentBlue    = Color(0xFF7C9EFF);
  static const Color _accentBlueDark = Color(0xFF4B6EF5);

  @override
  void initState() {
    super.initState();
    context.read<RoomBloc>().add(RoomMyRoomsLoadRequested());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _reload() {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    context.read<RoomBloc>().add(RoomMyRoomsLoadRequested());
  }

  List<RoomEntity> get _filteredRooms {
    var rooms = _rooms;
    if (_selectedTab == 1) {
      final authState = context.read<AuthBloc>().state;
      if (authState is AuthAuthenticated) {
        rooms = rooms.where((r) => r.createdBy == authState.user.id).toList();
      }
    } else if (_selectedTab == 2) {
      final authState = context.read<AuthBloc>().state;
      if (authState is AuthAuthenticated) {
        rooms = rooms.where((r) => r.createdBy != authState.user.id).toList();
      }
    }
    if (_searchQuery.isNotEmpty) {
      rooms = rooms
          .where((r) =>
              r.projectTheme.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              r.roomCode.toLowerCase().contains(_searchQuery.toLowerCase()))
          .toList();
    }
    return rooms;
  }

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
        backgroundColor: _bgColor,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Top bar ──────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        ShaderMask(
                          shaderCallback: (bounds) => const LinearGradient(
                            colors: [Color(0xFF7C9EFF), Color(0xFFB8CDFF)],
                          ).createShader(bounds),
                          child: const Icon(
                            Icons.rocket_launch_rounded,
                            color: Colors.white,
                            size: 22,
                          ),
                        ),
                        const SizedBox(width: 10),
                        ShaderMask(
                          shaderCallback: (bounds) => const LinearGradient(
                            colors: [Color(0xFF7C9EFF), Color(0xFFB8CDFF)],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ).createShader(bounds),
                          child: const Text(
                            'ProjectPals',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        // ── TAMBAHAN: Tombol My Rooms ──────────────
                        GestureDetector(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const MyRoomsScreen(),
                            ),
                          ),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFFB8CDFF), Color(0xFF3B5FD9)],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF3B5FD9).withOpacity(0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.meeting_room_outlined,
                                    color: Color(0xFF0D1B3E), size: 14),
                                SizedBox(width: 5),
                                Text(
                                  'My Rooms',
                                  style: TextStyle(
                                    color: Color(0xFF0D1B3E),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        // ── END TAMBAHAN ───────────────────────────
                        const SizedBox(width: 10),
                        Stack(
                          children: [
                            Container(
                              width: 38,
                              height: 38,
                              decoration: BoxDecoration(
                                color: const Color(0xFF1E2640),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                    color: Colors.white.withOpacity(0.08)),
                              ),
                              child: Icon(
                                Icons.notifications_outlined,
                                color: Colors.white.withOpacity(0.7),
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
                                  color: Color(0xFF4ADE80),
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 10),
                        Container(
                          width: 38,
                          height: 38,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: const LinearGradient(
                              colors: [Color(0xFF4B6EF5), Color(0xFF7C9EFF)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            border: Border.all(
                                color: const Color(0xFF7C9EFF).withOpacity(0.5),
                                width: 1.5),
                          ),
                          child: const Icon(Icons.person,
                              color: Colors.white, size: 20),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // ── Search bar ───────────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  height: 52,
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A2035),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                        color: Colors.white.withOpacity(0.06)),
                  ),
                  child: TextField(
                    controller: _searchController,
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                    onChanged: (v) => setState(() => _searchQuery = v),
                    decoration: InputDecoration(
                      hintText: 'Search projects...',
                      hintStyle: TextStyle(
                          color: Colors.white.withOpacity(0.25), fontSize: 14),
                      prefixIcon: Icon(Icons.search,
                          color: Colors.white.withOpacity(0.25), size: 20),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // ── Filter tabs ──────────────────────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _FilterTab(
                    label: 'All',
                    selected: _selectedTab == 0,
                    onTap: () => setState(() => _selectedTab = 0),
                  ),
                  const SizedBox(width: 10),
                  _FilterTab(
                    label: 'Created by me',
                    selected: _selectedTab == 1,
                    onTap: () => setState(() => _selectedTab = 1),
                  ),
                  const SizedBox(width: 10),
                  _FilterTab(
                    label: 'Joined',
                    selected: _selectedTab == 2,
                    onTap: () => setState(() => _selectedTab = 2),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              Expanded(child: _buildBody()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: _accentBlue),
      );
    }
    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.wifi_off, color: Colors.white.withOpacity(0.3), size: 48),
            const SizedBox(height: 16),
            Text(_error!,
                style: TextStyle(
                    color: Colors.white.withOpacity(0.5), fontSize: 14),
                textAlign: TextAlign.center),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _reload,
              style: ElevatedButton.styleFrom(
                backgroundColor: _accentBlue,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
              ),
              child: const Text('Retry', style: TextStyle(color: Colors.white)),
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
                color: Colors.white.withOpacity(0.2), size: 56),
            const SizedBox(height: 16),
            Text('No rooms found',
                style: TextStyle(
                    color: Colors.white.withOpacity(0.5),
                    fontSize: 16,
                    fontWeight: FontWeight.bold)),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 0),
      itemCount: rooms.length + 1,
      itemBuilder: (context, i) {
        if (i == rooms.length) {
          return _buildStartFresh();
        }
        final room = rooms[i];
        final authState = context.read<AuthBloc>().state;
        final isOwner = authState is AuthAuthenticated &&
            room.createdBy == authState.user.id;
        return Padding(
          padding: const EdgeInsets.only(bottom: 14),
          child: _RoomCard(
            room: room,
            isOwner: isOwner,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => RoomDetailScreen(room: room)),
            ),
          ),
        );
      },
    );
  }

  Widget _buildStartFresh() {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 32),
      child: Column(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                  color: Colors.white.withOpacity(0.12), width: 1.5),
              color: const Color(0xFF1A2035),
            ),
            child: Icon(Icons.add,
                color: Colors.white.withOpacity(0.4), size: 22),
          ),
          const SizedBox(height: 10),
          Text(
            'Start Fresh',
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            'Create a new collaborative room',
            style: TextStyle(
              color: Colors.white.withOpacity(0.25),
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Filter Tab ─────────────────────────────────────────────────────────────────

class _FilterTab extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _FilterTab({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
                : Colors.white.withOpacity(0.08),
          ),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: const Color(0xFF3B5FD9).withOpacity(0.35),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected
                ? const Color(0xFF0D1B3E)
                : Colors.white.withOpacity(0.4),
            fontSize: 13,
            fontWeight: selected ? FontWeight.w700 : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}

// ── Room Card ──────────────────────────────────────────────────────────────────

class _RoomCard extends StatelessWidget {
  final RoomEntity room;
  final bool isOwner;
  final VoidCallback onTap;

  const _RoomCard({
    required this.room,
    required this.isOwner,
    required this.onTap,
  });

  Color get _statusColor {
    return switch (room.status) {
      'open' => const Color(0xFF4ADE80),
      'ongoing' || 'in_progress' || 'matched' => const Color(0xFF4ADE80),
      'matching' => const Color(0xFFFBBF24),
      'completed' || 'closed' => Colors.white38,
      _ => Colors.white38,
    };
  }

  String get _statusLabel {
    return switch (room.status) {
      'open' => 'On going',
      'ongoing' || 'in_progress' || 'matched' => 'On going',
      'matching' => 'Matching',
      'completed' => 'Done',
      'closed' => 'Closed',
      _ => room.status,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBg,           // ← pakai AppColors.cardBg dari ProfileScreen
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.borderColor), // ← pakai AppColors.borderColor
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 18, 18, 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── OWNER / MEMBER badge ──
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: isOwner
                            ? const Color(0xFF4ADE80).withOpacity(0.15)
                            : Colors.white.withOpacity(0.06),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: isOwner
                              ? const Color(0xFF4ADE80).withOpacity(0.5)
                              : Colors.white.withOpacity(0.1),
                        ),
                      ),
                      child: Text(
                        isOwner ? 'OWNER' : 'MEMBER',
                        style: TextStyle(
                          color: isOwner
                              ? const Color(0xFF4ADE80)
                              : Colors.white60,
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // ── Judul ──
                Text(
                  room.projectTheme,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.3,
                    height: 1.2,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),

                // ── Roles ──
                Text(
                  room.roles.isNotEmpty
                      ? room.roles.join(' · ')
                      : room.roomCode,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.4),
                    fontSize: 13,
                    height: 1.5,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 16),

                // ── Avatar stack + status ──
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _AvatarStack(count: room.maxPerGroup.clamp(0, 3)),
                    Row(
                      children: [
                        Container(
                          width: 7,
                          height: 7,
                          decoration: BoxDecoration(
                            color: _statusColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          _statusLabel,
                          style: TextStyle(
                            color: _statusColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),

          // ── Open Room button ──
          GestureDetector(
            onTap: onTap,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 15),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFFB8CDFF),
                    Color(0xFF3B5FD9),
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Open Room',
                    style: TextStyle(
                      color: Color(0xFF0D1B3E),
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.2,
                    ),
                  ),
                  SizedBox(width: 8),
                  Icon(Icons.arrow_forward_rounded,
                      color: Color(0xFF0D1B3E), size: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Avatar Stack ───────────────────────────────────────────────────────────────

class _AvatarStack extends StatelessWidget {
  final int count;
  const _AvatarStack({required this.count});

  @override
  Widget build(BuildContext context) {
    final show = count.clamp(0, 3);
    if (show == 0) return const SizedBox.shrink();
    return SizedBox(
      width: show * 20.0 + 12,
      height: 28,
      child: Stack(
        children: List.generate(show, (i) {
          return Positioned(
            left: i * 18.0,
            child: Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: [
                  const Color(0xFF3B4FD9),
                  const Color(0xFF2D9B6F),
                  const Color(0xFF8B5CF6),
                ][i % 3],
                border: Border.all(
                    color: AppColors.cardBg, width: 2), // ← border avatar pakai cardBg
              ),
              child: const Icon(Icons.person,
                  color: Colors.white, size: 14),
            ),
          );
        }),
      ),
    );
  }
}