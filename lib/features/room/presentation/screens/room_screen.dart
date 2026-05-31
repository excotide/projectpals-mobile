import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../domain/entities/member_entity.dart';
import '../../domain/entities/room_entity.dart';
import '../bloc/room_bloc.dart';

// ── Room Screen ────────────────────────────────────────────────────────────────

class RoomScreen extends StatefulWidget {
  const RoomScreen({super.key});

  @override
  State<RoomScreen> createState() => _RoomScreenState();
}

class _RoomScreenState extends State<RoomScreen> {
  List<RoomEntity> _rooms = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadRooms();
  }

  void _loadRooms() {
    context.read<RoomBloc>().add(RoomMyRoomsLoadRequested());
  }

  void _reload() {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    _loadRooms();
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
        backgroundColor: AppColors.darkBlueBg,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'My Joined Rooms',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Manage your active collaborations',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.45),
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
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
        child: CircularProgressIndicator(color: AppColors.primaryCyan),
      );
    }
    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.wifi_off, color: AppColors.textGrey, size: 48),
            const SizedBox(height: 16),
            Text(
              _error!,
              style: const TextStyle(color: AppColors.textGrey, fontSize: 14),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _reload,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryCyan,
              ),
              child: const Text('Retry',
                  style: TextStyle(color: Color(0xFF003642))),
            ),
          ],
        ),
      );
    }
    if (_rooms.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: AppColors.cardBg,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.borderColor),
              ),
              child: const Icon(Icons.inbox_outlined,
                  color: AppColors.textGrey, size: 36),
            ),
            const SizedBox(height: 20),
            const Text(
              'No rooms yet',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Create or join a room to get started.',
              style: TextStyle(color: AppColors.textGrey, fontSize: 13),
            ),
          ],
        ),
      );
    }
    return Stack(
      children: [
        ListView.separated(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 100),
          itemCount: _rooms.length,
          separatorBuilder: (_, __) => const SizedBox(height: 14),
          itemBuilder: (context, i) {
            final room = _rooms[i];
            return GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => RoomDetailScreen(room: room),
                ),
              ),
              child: _RoomCard(room: room),
            );
          },
        ),
        // Floating action button
        Positioned(
          bottom: 24,
          right: 20,
          child: GestureDetector(
            onTap: () {
              // TODO: navigate to create/join room
            },
            child: Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: AppColors.primaryCyan,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryCyan.withOpacity(0.4),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: const Icon(Icons.add, color: Colors.black87, size: 26),
            ),
          ),
        ),
      ],
    );
  }
}

// ── Room Card ──────────────────────────────────────────────────────────────────

class _RoomCard extends StatelessWidget {
  final RoomEntity room;
  const _RoomCard({required this.room});

  Color _statusColor(String status) {
    return switch (status) {
      'open' => AppColors.primaryCyan,
      'ongoing' || 'in_progress' => AppColors.primaryCyan,
      'matching' => Colors.orange,
      'completed' => AppColors.mintGreen,
      _ => AppColors.textGrey,
    };
  }

  String _statusLabel(String status) {
    return switch (status) {
      'open' => 'OPEN',
      'ongoing' || 'in_progress' => 'IN PROGRESS',
      'matching' => 'MATCHING',
      'completed' => 'COMPLETED',
      'closed' => 'CLOSED',
      _ => status.toUpperCase(),
    };
  }

  bool get _isCompleted =>
      room.status == 'completed' || room.status == 'closed';

  @override
  Widget build(BuildContext context) {
    final statusColor = _statusColor(room.status);

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: AppColors.borderColor,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Row: title + badge ──
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      room.projectTheme.toUpperCase(),
                      style: TextStyle(
                        color: statusColor,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.6,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 3),
                    Text(
                      room.roomCode,
                      style: const TextStyle(
                        color: AppColors.textGrey,
                        fontSize: 11,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              _StatusBadge(
                status: room.status,
                label: _statusLabel(room.status),
                color: statusColor,
              ),
            ],
          ),
          const SizedBox(height: 14),

          // ── Members row ──
          Row(
            children: [
              const Icon(Icons.people_outline,
                  color: AppColors.textGrey, size: 14),
              const SizedBox(width: 6),
              Text(
                '${room.maxPerGroup} members',
                style: const TextStyle(
                  color: AppColors.textGrey,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // ── Divider ──
          Container(height: 1, color: AppColors.borderColor),
          const SizedBox(height: 14),

          // ── Bottom row ──
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    _isCompleted
                        ? Icons.check_circle_outline
                        : Icons.calendar_today_outlined,
                    color: AppColors.textGrey,
                    size: 13,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    _isCompleted ? 'Project Finished' : 'Next Milestone',
                    style: const TextStyle(
                      color: AppColors.textGrey,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
              if (_isCompleted)
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 5),
                  decoration: BoxDecoration(
                    color: AppColors.mintGreen.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                        color: AppColors.mintGreen.withOpacity(0.3)),
                  ),
                  child: const Text(
                    'Archived',
                    style: TextStyle(
                      color: AppColors.mintGreen,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                )
              else
                Text(
                  'Due in 9 days',
                  style: TextStyle(
                    color: room.status == 'matching'
                        ? Colors.redAccent
                        : Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Status Badge ───────────────────────────────────────────────────────────────

class _StatusBadge extends StatelessWidget {
  final String status;
  final String label;
  final Color color;

  const _StatusBadge({
    required this.status,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.35)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 9,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

// ── Room Detail Screen ─────────────────────────────────────────────────────────

class RoomDetailScreen extends StatefulWidget {
  final RoomEntity room;
  const RoomDetailScreen({super.key, required this.room});

  @override
  State<RoomDetailScreen> createState() => _RoomDetailScreenState();
}

class _RoomDetailScreenState extends State<RoomDetailScreen> {
  late RoomEntity _room;
  List<MemberEntity> _members = [];
  bool _loadingMembers = true;

  bool get _isOwner {
    final s = context.read<AuthBloc>().state;
    return s is AuthAuthenticated && _room.createdBy == s.user.id;
  }

  @override
  void initState() {
    super.initState();
    _room = widget.room;
    context.read<RoomBloc>().add(RoomMembersLoadRequested(_room.roomCode));
  }

  void _showDeleteDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.cardBg,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: const BorderSide(color: AppColors.borderColor)),
        title: const Text('Delete Room?',
            style:
                TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        content: const Text(
            'This will permanently delete the room and all its members.',
            style: TextStyle(color: AppColors.textGrey, fontSize: 14)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CANCEL',
                style: TextStyle(color: AppColors.textGrey)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context
                  .read<RoomBloc>()
                  .add(RoomDeleteRequested(_room.roomCode));
            },
            child: const Text('DELETE',
                style: TextStyle(
                    color: AppColors.red, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  void _showLeaveDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.cardBg,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: const BorderSide(color: AppColors.borderColor)),
        title: const Text('Leave Room?',
            style:
                TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        content: const Text('Are you sure you want to leave this room?',
            style: TextStyle(color: AppColors.textGrey, fontSize: 14)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CANCEL',
                style: TextStyle(color: AppColors.textGrey)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context
                  .read<RoomBloc>()
                  .add(RoomLeaveRequested(_room.roomCode));
            },
            child: const Text('LEAVE',
                style: TextStyle(
                    color: AppColors.red, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  void _showEditSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _EditRoomSheet(
        room: _room,
        onSave: (data) => context.read<RoomBloc>().add(
              RoomUpdateRequested(roomCode: _room.roomCode, data: data),
            ),
      ),
    );
  }

  String _statusLabel(String status) {
    return switch (status) {
      'open' => 'OPEN',
      'ongoing' || 'in_progress' => 'IN PROGRESS',
      'matching' => 'MATCHING',
      'completed' => 'COMPLETED',
      'closed' => 'CLOSED',
      _ => status.toUpperCase(),
    };
  }

  Color _statusColor(String status) {
    return switch (status) {
      'open' => AppColors.primaryCyan,
      'ongoing' || 'in_progress' => AppColors.primaryCyan,
      'matching' => Colors.orange,
      'completed' => AppColors.mintGreen,
      _ => AppColors.textGrey,
    };
  }

  // completion % mock: bisa diganti dari data nyata
  int get _completionPercent {
    return switch (_room.status) {
      'open' => 0,
      'matching' => 20,
      'ongoing' || 'in_progress' => 64,
      'completed' => 100,
      _ => 0,
    };
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RoomBloc, RoomState>(
      listener: (context, state) {
        if (state is RoomLeft || state is RoomDeleted) {
          Navigator.pop(context);
        } else if (state is RoomMembersLoaded) {
          setState(() {
            _members = state.members;
            _loadingMembers = false;
          });
        } else if (state is RoomUpdated) {
          setState(() => _room = state.room);
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Room updated successfully'),
            backgroundColor: AppColors.mintGreen,
          ));
        } else if (state is RoomFailure) {
          setState(() => _loadingMembers = false);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(state.message),
            backgroundColor: AppColors.red,
          ));
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.darkBlueBg,
        appBar: AppBar(
          backgroundColor: AppColors.darkBlueBg,
          elevation: 0,
          centerTitle: false,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded,
                color: AppColors.primaryCyan, size: 18),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            _room.projectTheme.toUpperCase(),
            style: const TextStyle(
              color: AppColors.primaryCyan,
              fontWeight: FontWeight.bold,
              fontSize: 16,
              letterSpacing: 0.8,
            ),
          ),
          actions: [
            if (_isOwner) ...[
              IconButton(
                icon: const Icon(Icons.edit_outlined,
                    color: AppColors.primaryCyan, size: 20),
                onPressed: _showEditSheet,
                tooltip: 'Edit Room',
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline,
                    color: AppColors.red, size: 20),
                onPressed: _showDeleteDialog,
                tooltip: 'Delete Room',
              ),
            ] else
              Padding(
                padding: const EdgeInsets.only(right: 12),
                child: GestureDetector(
                  onTap: _showLeaveDialog,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.red,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'LEAVE TEAM',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Project Status Card ──
              _buildStatusCard(),
              const SizedBox(height: 28),

              // ── Team Members ──
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Team Members',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      // TODO: view all members
                    },
                    child: Row(
                      children: [
                        Text(
                          'View All',
                          style: TextStyle(
                            color: AppColors.primaryCyan.withOpacity(0.8),
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Icon(
                          Icons.chevron_right,
                          color: AppColors.primaryCyan.withOpacity(0.8),
                          size: 16,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              _buildMembersList(),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusCard() {
    final statusColor = _statusColor(_room.status);
    final completion = _completionPercent;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header ──
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'PROJECT STATUS',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.4),
                  fontSize: 10,
                  letterSpacing: 1.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
              _StatusBadge(
                status: _room.status,
                label: _statusLabel(_room.status),
                color: statusColor,
              ),
            ],
          ),
          const SizedBox(height: 10),

          // ── Status title ──
          Text(
            _statusLabel(_room.status)
                .split(' ')
                .map((w) =>
                    w[0].toUpperCase() + w.substring(1).toLowerCase())
                .join(' '),
            style: TextStyle(
              color: statusColor,
              fontSize: 26,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 16),

          // ── Completion bar ──
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Completion',
                style: TextStyle(color: Colors.white, fontSize: 13),
              ),
              Text(
                '$completion%',
                style: TextStyle(
                  color: statusColor,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: completion / 100,
              minHeight: 7,
              backgroundColor: AppColors.borderColor,
              valueColor: AlwaysStoppedAnimation<Color>(statusColor),
            ),
          ),
          const SizedBox(height: 14),

          // ── Deadline / Info row ──
          Row(
            children: [
              Icon(Icons.calendar_today_outlined,
                  color: Colors.white.withOpacity(0.5), size: 13),
              const SizedBox(width: 6),
              Text(
                'Deadline: Oct 24, 2026',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.5),
                  fontSize: 12,
                ),
              ),
            ],
          ),

          // ── Roles & Code (collapsible info) ──
          if (_room.roles.isNotEmpty) ...[
            const SizedBox(height: 16),
            Container(height: 1, color: AppColors.borderColor),
            const SizedBox(height: 14),
            Row(
              children: [
                Icon(Icons.vpn_key_outlined,
                    color: Colors.white.withOpacity(0.4), size: 13),
                const SizedBox(width: 6),
                Text(
                  _room.roomCode,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.5),
                    fontSize: 12,
                    letterSpacing: 1,
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () {
                    Clipboard.setData(
                        ClipboardData(text: _room.roomCode));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Code copied!'),
                        duration: Duration(seconds: 2),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                  child: Icon(Icons.copy_rounded,
                      color: Colors.white.withOpacity(0.4), size: 14),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 6,
              children: _room.roles
                  .map((r) => Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 5),
                        decoration: BoxDecoration(
                          color: AppColors.primaryCyan.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                              color:
                                  AppColors.primaryCyan.withOpacity(0.25)),
                        ),
                        child: Text(
                          r,
                          style: const TextStyle(
                              color: AppColors.primaryCyan, fontSize: 11),
                        ),
                      ))
                  .toList(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMembersList() {
    if (_loadingMembers) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: CircularProgressIndicator(color: AppColors.primaryCyan),
        ),
      );
    }
    if (_members.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(24),
        child: Center(
          child: Text('No members yet',
              style: TextStyle(color: AppColors.textGrey)),
        ),
      );
    }
    return Column(
      children: _members.map((m) => _MemberCard(member: m)).toList(),
    );
  }
}

// ── Member Card ────────────────────────────────────────────────────────────────

class _MemberCard extends StatelessWidget {
  final MemberEntity member;
  const _MemberCard({required this.member});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Top: avatar + name + role + chat icon ──
          Row(
            children: [
              // Avatar
              Stack(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: AppColors.borderColor,
                    ),
                    child: const Icon(Icons.person,
                        color: Colors.white38, size: 26),
                  ),
                  Positioned(
                    bottom: 2,
                    right: 2,
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: AppColors.mintGreen,
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: AppColors.cardBg, width: 1.5),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      member.user != null
                          ? '@${member.user!.username}'
                          : '@user${member.userId}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    if (member.primaryRole != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        member.primaryRole!.toUpperCase(),
                        style: TextStyle(
                          color: AppColors.primaryCyan.withOpacity(0.8),
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              // Chat icon
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: AppColors.darkBlueBg,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.borderColor),
                ),
                child: const Icon(
                  Icons.chat_bubble_outline_rounded,
                  color: AppColors.textGrey,
                  size: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Container(height: 1, color: AppColors.borderColor),
          const SizedBox(height: 12),

          // ── Bottom: expertise + activity ──
          Row(
            children: [
              // Expertise
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'EXPERTISE',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.4),
                        fontSize: 9,
                        letterSpacing: 1.2,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 6,
                      runSpacing: 4,
                      children: _expertiseTags(member),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              // Activity
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'ACTIVITY',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.4),
                      fontSize: 9,
                      letterSpacing: 1.2,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'High (98%)',
                    style: TextStyle(
                      color: AppColors.mintGreen,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  List<Widget> _expertiseTags(MemberEntity m) {
    // Gunakan data expertise dari user jika ada, fallback ke role
    final tags = <String>[];
    if (m.primaryRole != null) tags.add(m.primaryRole!);
    if (tags.isEmpty) tags.add('General');

    return tags
        .map((t) => Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.darkBlueBg,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: AppColors.borderColor),
              ),
              child: Text(
                t,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 11,
                ),
              ),
            ))
        .toList();
  }
}

// ── Edit Room Sheet ────────────────────────────────────────────────────────────

class _EditRoomSheet extends StatefulWidget {
  final RoomEntity room;
  final void Function(Map<String, dynamic> data) onSave;
  const _EditRoomSheet({required this.room, required this.onSave});

  @override
  State<_EditRoomSheet> createState() => _EditRoomSheetState();
}

class _EditRoomSheetState extends State<_EditRoomSheet> {
  late final TextEditingController _themeCtrl;
  late final TextEditingController _roleCtrl;
  late List<String> _roles;
  late int _maxPerGroup;
  late int _numberOfGroups;
  late String _status;

  static const _statuses = ['open', 'matching', 'ongoing', 'closed'];

  @override
  void initState() {
    super.initState();
    _themeCtrl = TextEditingController(text: widget.room.projectTheme);
    _roleCtrl = TextEditingController();
    _roles = List<String>.from(widget.room.roles);
    _maxPerGroup = widget.room.maxPerGroup;
    _numberOfGroups = widget.room.numberOfGroups;
    _status = widget.room.status;
  }

  @override
  void dispose() {
    _themeCtrl.dispose();
    _roleCtrl.dispose();
    super.dispose();
  }

  void _addRole() {
    final role = _roleCtrl.text.trim();
    if (role.isNotEmpty && !_roles.contains(role)) {
      setState(() {
        _roles.add(role);
        _roleCtrl.clear();
      });
    }
  }

  void _save() {
    if (_themeCtrl.text.trim().isEmpty || _roles.length < 2) return;
    widget.onSave({
      'project_theme': _themeCtrl.text.trim(),
      'roles': _roles,
      'max_per_group': _maxPerGroup,
      'number_of_groups': _numberOfGroups,
      'status': _status,
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        decoration: const BoxDecoration(
          color: AppColors.darkBlueBg,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.88,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          builder: (_, scrollCtrl) => ListView(
            controller: scrollCtrl,
            padding: EdgeInsets.fromLTRB(
                24, 16, 24, MediaQuery.of(context).padding.bottom + 24),
            children: [
              Center(
                child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                        color: AppColors.borderColor,
                        borderRadius: BorderRadius.circular(2))),
              ),
              const SizedBox(height: 20),
              const Text('Edit Room',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold)),
              const SizedBox(height: 24),

              // ── Room Name ────────────────────────────────────────────────
              _sectionLabel('ROOM NAME'),
              const SizedBox(height: 8),
              _buildField(_themeCtrl, 'Required'),
              const SizedBox(height: 24),

              // ── Status ───────────────────────────────────────────────────
              _sectionLabel('STATUS'),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: _statuses.map((s) {
                  final selected = _status == s;
                  final color = switch (s) {
                    'open' => AppColors.primaryCyan,
                    'matching' => Colors.orange,
                    'ongoing' => AppColors.mintGreen,
                    _ => AppColors.textGrey,
                  };
                  return GestureDetector(
                    onTap: () => setState(() => _status = s),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: selected
                            ? color.withValues(alpha: 0.15)
                            : AppColors.cardBg,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                            color: selected ? color : AppColors.borderColor),
                      ),
                      child: Text(s.toUpperCase(),
                          style: TextStyle(
                              color:
                                  selected ? color : AppColors.textGrey,
                              fontSize: 11,
                              fontWeight: FontWeight.bold)),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),

              // ── Roles ────────────────────────────────────────────────────
              _sectionLabel('ROLES (min. 2)'),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: _buildField(_roleCtrl, 'Add a role',
                        onSubmitted: (_) => _addRole()),
                  ),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: _addRole,
                    child: Container(
                      width: 48,
                      height: 54,
                      decoration: BoxDecoration(
                          color: AppColors.primaryCyan,
                          borderRadius: BorderRadius.circular(12)),
                      child: const Icon(Icons.add,
                          color: Colors.black87, size: 22),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ..._roles.asMap().entries.map((e) => Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: AppColors.cardBg,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.borderColor),
                    ),
                    child: Row(
                      children: [
                        Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                                color: AppColors.primaryCyan,
                                shape: BoxShape.circle)),
                        const SizedBox(width: 12),
                        Expanded(
                            child: Text(e.value,
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 14))),
                        GestureDetector(
                          onTap: () =>
                              setState(() => _roles.removeAt(e.key)),
                          child: const Icon(Icons.delete_outline,
                              color: AppColors.textGrey, size: 18),
                        ),
                      ],
                    ),
                  )),
              const SizedBox(height: 24),

              // ── Capacity ─────────────────────────────────────────────────
              _sectionLabel('CAPACITY'),
              const SizedBox(height: 8),
              _buildCounter('Max People Per Group', 'Range: 2–20',
                  _maxPerGroup, 2, 20,
                  (v) => setState(() => _maxPerGroup = v)),
              const SizedBox(height: 12),
              _buildCounter('Number of Groups', 'Range: 2–50',
                  _numberOfGroups, 2, 50,
                  (v) => setState(() => _numberOfGroups = v)),
              const SizedBox(height: 32),

              // ── Save ──────────────────────────────────────────────────────
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: (_themeCtrl.text.trim().isNotEmpty &&
                          _roles.length >= 2)
                      ? _save
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryCyan,
                    foregroundColor: Colors.black87,
                    disabledBackgroundColor:
                        AppColors.primaryCyan.withValues(alpha: 0.3),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                    elevation: 0,
                  ),
                  child: const Text('Save Changes',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 15)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionLabel(String label) => Text(label,
      style: const TextStyle(
          color: AppColors.primaryCyan,
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.5));

  Widget _buildField(TextEditingController ctrl, String hint,
      {ValueChanged<String>? onSubmitted}) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.inputBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderColor),
      ),
      child: TextField(
        controller: ctrl,
        style: const TextStyle(color: Colors.white, fontSize: 15),
        onSubmitted: onSubmitted,
        onChanged: (_) => setState(() {}),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle:
              TextStyle(color: AppColors.textGrey.withValues(alpha: 0.4)),
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        ),
      ),
    );
  }

  Widget _buildCounter(String label, String sublabel, int value, int min,
      int max, ValueChanged<int> onChanged) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.borderColor),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600)),
                Text(sublabel,
                    style: const TextStyle(
                        color: AppColors.textGrey, fontSize: 11)),
              ],
            ),
          ),
          _circleBtn(Icons.remove, value > min,
              value > min ? () => onChanged(value - 1) : null),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text('$value',
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold)),
          ),
          _circleBtn(Icons.add, value < max,
              value < max ? () => onChanged(value + 1) : null),
        ],
      ),
    );
  }

  Widget _circleBtn(IconData icon, bool enabled, VoidCallback? onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: enabled
                ? AppColors.primaryCyan.withValues(alpha: 0.6)
                : AppColors.primaryCyan.withValues(alpha: 0.2),
          ),
        ),
        child: Icon(icon,
            size: 16,
            color: enabled
                ? AppColors.primaryCyan
                : AppColors.primaryCyan.withValues(alpha: 0.3)),
      ),
    );
  }
}