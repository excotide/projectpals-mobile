import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../domain/entities/member_entity.dart';
import '../../domain/entities/room_entity.dart';
import '../bloc/room_bloc.dart';
import 'room_information_screen.dart'; // ← import screen baru

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
        backgroundColor: const Color(0xFF161C2C),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(color: Colors.white.withOpacity(0.1))),
        title: const Text('Delete Room?',
            style:
                TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        content: const Text('This will permanently delete the room.',
            style: TextStyle(color: Colors.white60, fontSize: 14)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CANCEL',
                style: TextStyle(color: Colors.white60)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<RoomBloc>().add(RoomDeleteRequested(_room.roomCode));
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
        backgroundColor: const Color(0xFF161C2C),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(color: Colors.white.withOpacity(0.1))),
        title: const Text('Leave Room?',
            style:
                TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        content: const Text('Are you sure you want to leave this room?',
            style: TextStyle(color: Colors.white60, fontSize: 14)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CANCEL',
                style: TextStyle(color: Colors.white60)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<RoomBloc>().add(RoomLeaveRequested(_room.roomCode));
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
        backgroundColor: const Color(0xFF0D1117),
        appBar: AppBar(
          backgroundColor: const Color(0xFF0D1117),
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded,
                color: Colors.white, size: 18),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text(
            'Room Details',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          actions: [
            if (_isOwner)
              IconButton(
                icon: Icon(Icons.more_vert,
                    color: Colors.white.withOpacity(0.7)),
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    backgroundColor: const Color(0xFF161C2C),
                    shape: const RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(20)),
                    ),
                    builder: (_) => Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListTile(
                          leading: const Icon(Icons.edit_outlined,
                              color: Color(0xFF5B7FFF)),
                          title: const Text('Edit Room',
                              style: TextStyle(color: Colors.white)),
                          onTap: () {
                            Navigator.pop(context);
                            _showEditSheet();
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.delete_outline,
                              color: AppColors.red),
                          title: const Text('Delete Room',
                              style: TextStyle(color: AppColors.red)),
                          onTap: () {
                            Navigator.pop(context);
                            _showDeleteDialog();
                          },
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  );
                },
              )
            else
              Padding(
                padding: const EdgeInsets.only(right: 12),
                child: TextButton(
                  onPressed: _showLeaveDialog,
                  child: const Text('LEAVE',
                      style: TextStyle(
                          color: AppColors.red,
                          fontWeight: FontWeight.bold)),
                ),
              ),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _TeamInfoCard(room: _room),
              const SizedBox(height: 20),
              _TargetCard(room: _room),
              const SizedBox(height: 20),

              // ── Tombol menuju Room Information Screen ──────────────
              // Klik ini untuk masuk ke halaman Room Information
              _RoomInformationButton(room: _room),
              const SizedBox(height: 20),
              // ──────────────────────────────────────────────────────

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Anggota Team',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'TOTAL: ${_members.length}',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.4),
                      fontSize: 11,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _buildMembersList(),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMembersList() {
    if (_loadingMembers) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: CircularProgressIndicator(color: Color(0xFF5B7FFF)),
        ),
      );
    }
    if (_members.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: Text('No members yet',
              style: TextStyle(color: Colors.white.withOpacity(0.3))),
        ),
      );
    }
    return Column(
      children: _members.map((m) => _DetailMemberCard(member: m)).toList(),
    );
  }
}

// ── Room Information Button ────────────────────────────────────────────────────
// Tombol ini mengarah ke RoomInformationScreen

class _RoomInformationButton extends StatelessWidget {
  final RoomEntity room;
  const _RoomInformationButton({required this.room});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => RoomInformationScreen(room: room),
        ),
      ),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        decoration: BoxDecoration(
          color: const Color(0xFF141D2E),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFF2D4799).withOpacity(0.5)),
          gradient: const LinearGradient(
            colors: [Color(0xFF141D2E), Color(0xFF131E35)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: const Color(0xFF5B7FFF).withOpacity(0.15),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                    color: const Color(0xFF5B7FFF).withOpacity(0.3)),
              ),
              child: const Icon(Icons.info_outline_rounded,
                  color: Color(0xFF5B7FFF), size: 18),
            ),
            const SizedBox(width: 14),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Room Information',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'Detail anggota, smart matching & info ruang',
                    style: TextStyle(
                      color: Color(0xFF7C9EFF),
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios_rounded,
                color: Colors.white.withOpacity(0.3), size: 14),
          ],
        ),
      ),
    );
  }
}

// ── Team Info Card ─────────────────────────────────────────────────────────────

class _TeamInfoCard extends StatelessWidget {
  final RoomEntity room;
  const _TeamInfoCard({required this.room});

  String get _statusLabel {
    return switch (room.status) {
      'open' => 'Matched',
      'matched' => 'Matched',
      'ongoing' || 'in_progress' => 'In Progress',
      'matching' => 'Matching',
      'completed' || 'closed' => 'Completed',
      _ => room.status,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF141D2E),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withOpacity(0.07)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'TEAM INFORMATION',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.35),
                  fontSize: 10,
                  letterSpacing: 1.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.mintGreen.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(6),
                  border:
                      Border.all(color: AppColors.mintGreen.withOpacity(0.3)),
                ),
                child: Text(
                  _statusLabel,
                  style: const TextStyle(
                    color: AppColors.mintGreen,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            room.projectTheme,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _InfoItem(
                  label: 'ROOM CODE',
                  value: room.roomCode,
                  copyable: true,
                  roomCode: room.roomCode,
                ),
              ),
              const SizedBox(width: 16),
              const Expanded(
                child: _InfoItem(
                  label: 'DEADLINE',
                  value: '31 Mei 2026',
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            'ROLES ACTIVE',
            style: TextStyle(
              color: Colors.white.withOpacity(0.35),
              fontSize: 10,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            room.roles.isNotEmpty ? room.roles.join(', ') : 'No roles defined',
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoItem extends StatelessWidget {
  final String label;
  final String value;
  final bool copyable;
  final String? roomCode;

  const _InfoItem({
    required this.label,
    required this.value,
    this.copyable = false,
    this.roomCode,
  });

  @override
  Widget build(BuildContext ctx) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.35),
            fontSize: 10,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (copyable && roomCode != null) ...[
              const SizedBox(width: 6),
              GestureDetector(
                onTap: () {
                  Clipboard.setData(ClipboardData(text: roomCode!));
                  ScaffoldMessenger.of(ctx).showSnackBar(
                    const SnackBar(
                      content: Text('Code copied!'),
                      duration: Duration(seconds: 2),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
                child: Icon(Icons.copy_rounded,
                    color: Colors.white.withOpacity(0.3), size: 13),
              ),
            ],
          ],
        ),
      ],
    );
  }
}

// ── Target Card ────────────────────────────────────────────────────────────────

class _TargetCard extends StatelessWidget {
  final RoomEntity room;
  const _TargetCard({required this.room});

  @override
  Widget build(BuildContext context) {
    final filled = (room.maxPerGroup * 0.75).round();
    final total = room.maxPerGroup;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF141D2E),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withOpacity(0.07)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Target Tim',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '$filled/$total Selesai',
                style: const TextStyle(
                  color: AppColors.mintGreen,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: filled / total,
              minHeight: 5,
              backgroundColor: Colors.white.withOpacity(0.07),
              valueColor:
                  const AlwaysStoppedAnimation<Color>(AppColors.mintGreen),
            ),
          ),
          const SizedBox(height: 16),
          ...room.roles.asMap().entries.map((e) {
            final roleCount =
                (room.maxPerGroup ~/ room.roles.length.clamp(1, 100))
                    .clamp(1, 99);
            final roleFilled =
                (roleCount * 0.7).round().clamp(0, roleCount);
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      e.value.toUpperCase(),
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.5),
                        fontSize: 10,
                        letterSpacing: 1,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      '$roleFilled/$roleCount',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.5),
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ...List.generate(
                  roleCount,
                  (i) => Container(
                    margin: const EdgeInsets.only(bottom: 6),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: i < roleFilled
                          ? AppColors.mintGreen.withOpacity(0.08)
                          : Colors.white.withOpacity(0.03),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: i < roleFilled
                            ? AppColors.mintGreen.withOpacity(0.2)
                            : Colors.white.withOpacity(0.06),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          i < roleFilled
                              ? Icons.check_box_rounded
                              : Icons.check_box_outline_blank_rounded,
                          color: i < roleFilled
                              ? AppColors.mintGreen
                              : Colors.white.withOpacity(0.2),
                          size: 16,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          '${e.value} ${i + 1}',
                          style: TextStyle(
                            color: i < roleFilled
                                ? Colors.white.withOpacity(0.8)
                                : Colors.white.withOpacity(0.3),
                            fontSize: 13,
                          ),
                        ),
                        const Spacer(),
                        if (i >= roleFilled)
                          Icon(Icons.edit_outlined,
                              color: Colors.white.withOpacity(0.2),
                              size: 14),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 8),
              ],
            );
          }),
        ],
      ),
    );
  }
}

// ── Detail Member Card ─────────────────────────────────────────────────────────

class _DetailMemberCard extends StatelessWidget {
  final MemberEntity member;
  const _DetailMemberCard({required this.member});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF141D2E),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withOpacity(0.07)),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: _avatarColor(member.userId),
            ),
            child: Center(
              child: Text(
                _initials(member),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      member.user != null
                          ? member.user!.name
                          : 'User ${member.userId}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(width: 6),
                    if (member.id == 1)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.mintGreen.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(
                              color: AppColors.mintGreen.withOpacity(0.3)),
                        ),
                        child: const Text(
                          'BETA',
                          style: TextStyle(
                            color: AppColors.mintGreen,
                            fontSize: 8,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  member.primaryRole != null
                      ? '${member.primaryRole} Developer'
                      : 'Developer',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.4),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: AppColors.mintGreen,
              shape: BoxShape.circle,
              border:
                  Border.all(color: const Color(0xFF141D2E), width: 1.5),
            ),
          ),
        ],
      ),
    );
  }

  String _initials(MemberEntity m) {
    if (m.user != null) {
      final parts = m.user!.name.split(' ');
      if (parts.length >= 2) {
        return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
      }
      return m.user!.name.substring(0, 2).toUpperCase();
    }
    return 'U${m.userId}';
  }

  Color _avatarColor(int id) {
    final colors = [
      const Color(0xFF3B4FD9),
      const Color(0xFF2D9B6F),
      const Color(0xFF8B5CF6),
      const Color(0xFFD97706),
      const Color(0xFFDC2626),
    ];
    return colors[id % colors.length];
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
          color: Color(0xFF0D1117),
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
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(2))),
              ),
              const SizedBox(height: 20),
              const Text('Edit Room',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold)),
              const SizedBox(height: 24),
              _sectionLabel('ROOM NAME'),
              const SizedBox(height: 8),
              _buildField(_themeCtrl, 'Required'),
              const SizedBox(height: 24),
              _sectionLabel('STATUS'),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: _statuses.map((s) {
                  final selected = _status == s;
                  final color = switch (s) {
                    'open' => const Color(0xFF5B7FFF),
                    'matching' => Colors.orange,
                    'ongoing' => AppColors.mintGreen,
                    _ => Colors.white38,
                  };
                  return GestureDetector(
                    onTap: () => setState(() => _status = s),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: selected
                            ? color.withOpacity(0.15)
                            : const Color(0xFF141D2E),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                            color: selected
                                ? color
                                : Colors.white.withOpacity(0.1)),
                      ),
                      child: Text(s.toUpperCase(),
                          style: TextStyle(
                              color: selected ? color : Colors.white38,
                              fontSize: 11,
                              fontWeight: FontWeight.bold)),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),
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
                          color: const Color(0xFF5B7FFF),
                          borderRadius: BorderRadius.circular(12)),
                      child: const Icon(Icons.add,
                          color: Colors.white, size: 22),
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
                      color: const Color(0xFF141D2E),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          color: Colors.white.withOpacity(0.07)),
                    ),
                    child: Row(
                      children: [
                        Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                                color: Color(0xFF5B7FFF),
                                shape: BoxShape.circle)),
                        const SizedBox(width: 12),
                        Expanded(
                            child: Text(e.value,
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 14))),
                        GestureDetector(
                          onTap: () =>
                              setState(() => _roles.removeAt(e.key)),
                          child: Icon(Icons.delete_outline,
                              color: Colors.white.withOpacity(0.3),
                              size: 18),
                        ),
                      ],
                    ),
                  )),
              const SizedBox(height: 24),
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
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed:
                      (_themeCtrl.text.trim().isNotEmpty && _roles.length >= 2)
                          ? _save
                          : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF5B7FFF),
                    foregroundColor: Colors.white,
                    disabledBackgroundColor:
                        const Color(0xFF5B7FFF).withOpacity(0.3),
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
      style: TextStyle(
          color: Colors.white.withOpacity(0.4),
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.5));

  Widget _buildField(TextEditingController ctrl, String hint,
      {ValueChanged<String>? onSubmitted}) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF141D2E),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),
      child: TextField(
        controller: ctrl,
        style: const TextStyle(color: Colors.white, fontSize: 15),
        onSubmitted: onSubmitted,
        onChanged: (_) => setState(() {}),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.white.withOpacity(0.25)),
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
        color: const Color(0xFF141D2E),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withOpacity(0.07)),
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
                    style: TextStyle(
                        color: Colors.white.withOpacity(0.35),
                        fontSize: 11)),
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
                ? const Color(0xFF5B7FFF).withOpacity(0.6)
                : Colors.white.withOpacity(0.1),
          ),
        ),
        child: Icon(icon,
            size: 16,
            color: enabled
                ? const Color(0xFF5B7FFF)
                : Colors.white.withOpacity(0.2)),
      ),
    );
  }
}