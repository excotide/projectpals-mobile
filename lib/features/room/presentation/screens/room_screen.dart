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
    context.read<RoomBloc>().add(RoomMyRoomsLoadRequested());
  }

  void _reload() {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    context.read<RoomBloc>().add(RoomMyRoomsLoadRequested());
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
        } else if (state is RoomFailure && _isLoading) {
          setState(() {
            _isLoading = false;
            _error = state.message;
          });
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
              const Padding(
                padding: EdgeInsets.fromLTRB(20, 20, 20, 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('My Rooms',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 26,
                            fontWeight: FontWeight.bold)),
                    SizedBox(height: 4),
                    Text('Rooms you created & joined',
                        style:
                            TextStyle(color: AppColors.textGrey, fontSize: 13)),
                  ],
                ),
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
          child: CircularProgressIndicator(color: AppColors.primaryCyan));
    }
    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.wifi_off, color: AppColors.textGrey, size: 48),
            const SizedBox(height: 16),
            Text(_error!,
                style:
                    const TextStyle(color: AppColors.textGrey, fontSize: 14)),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _reload,
              style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryCyan),
              child: const Text('Retry',
                  style: TextStyle(color: Color(0xFF003642))),
            ),
          ],
        ),
      );
    }
    if (_rooms.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inbox_outlined, color: AppColors.textGrey, size: 56),
            SizedBox(height: 16),
            Text('No rooms yet',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text('Create or join a room to get started.',
                style: TextStyle(color: AppColors.textGrey, fontSize: 13)),
          ],
        ),
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      itemCount: _rooms.length,
      separatorBuilder: (context, i) => const SizedBox(height: 12),
      itemBuilder: (context, i) {
        final room = _rooms[i];
        return GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => RoomDetailScreen(room: room)),
          ),
          child: _RoomCard(room: room),
        );
      },
    );
  }
}

// ── Room Card ──────────────────────────────────────────────────────────────────

class _RoomCard extends StatelessWidget {
  final RoomEntity room;
  const _RoomCard({required this.room});

  @override
  Widget build(BuildContext context) {
    final color =
        room.status == 'open' ? AppColors.primaryCyan : AppColors.mintGreen;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(room.projectTheme,
                    style: TextStyle(
                        color: color,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
              ),
              _StatusBadge(status: room.status),
            ],
          ),
          const SizedBox(height: 4),
          Text(room.roomCode,
              style: const TextStyle(
                  color: AppColors.textGrey, fontSize: 12, letterSpacing: 1)),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.people_outline,
                  color: AppColors.textGrey, size: 14),
              const SizedBox(width: 4),
              Text(
                  '${room.maxPerGroup} per group  •  ${room.numberOfGroups} groups',
                  style: const TextStyle(
                      color: AppColors.textGrey, fontSize: 11)),
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
  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final color = switch (status) {
      'open' => AppColors.primaryCyan,
      'ongoing' => AppColors.mintGreen,
      'matching' => Colors.orange,
      _ => AppColors.textGrey,
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Text(status.toUpperCase(),
          style: TextStyle(
              color: color, fontSize: 9, fontWeight: FontWeight.bold)),
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
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded,
                color: AppColors.primaryCyan, size: 18),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(_room.projectTheme,
              style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16)),
          actions: [
            if (_isOwner) ...[
              IconButton(
                icon: const Icon(Icons.edit_outlined,
                    color: AppColors.primaryCyan, size: 20),
                onPressed: _showEditSheet,
                tooltip: 'Edit Room',
              ),
              IconButton(
                icon:
                    const Icon(Icons.delete_outline, color: AppColors.red, size: 20),
                onPressed: _showDeleteDialog,
                tooltip: 'Delete Room',
              ),
            ] else
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: TextButton(
                  onPressed: _showLeaveDialog,
                  child: const Text('LEAVE',
                      style: TextStyle(
                          color: AppColors.red,
                          fontWeight: FontWeight.bold,
                          fontSize: 12)),
                ),
              ),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInfoCard(),
              const SizedBox(height: 24),
              const Text('Members',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              _buildMembersList(),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('ROOM INFO',
                  style: TextStyle(
                      color: AppColors.textGrey,
                      fontSize: 10,
                      letterSpacing: 1.5)),
              _StatusBadge(status: _room.status),
            ],
          ),
          const SizedBox(height: 12),
          _infoRow(Icons.vpn_key_outlined, 'Code', _room.roomCode,
              copyable: true),
          const SizedBox(height: 8),
          _infoRow(Icons.people_outline, 'Capacity',
              '${_room.maxPerGroup} per group · ${_room.numberOfGroups} groups'),
          if (_room.roles.isNotEmpty) ...[
            const SizedBox(height: 12),
            const Text('ROLES',
                style: TextStyle(
                    color: AppColors.textGrey,
                    fontSize: 10,
                    letterSpacing: 1.5)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 6,
              children: _room.roles
                  .map((r) => Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.primaryCyan.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                              color:
                                  AppColors.primaryCyan.withValues(alpha: 0.3)),
                        ),
                        child: Text(r,
                            style: const TextStyle(
                                color: AppColors.primaryCyan, fontSize: 12)),
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
                style: TextStyle(color: AppColors.textGrey))),
      );
    }
    return Column(
      children: _members
          .map((m) => Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.cardBg,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.borderColor),
                ),
                child: Row(
                  children: [
                    const CircleAvatar(
                      backgroundColor: AppColors.borderColor,
                      child: Icon(Icons.person,
                          color: Colors.white38, size: 20),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              m.user != null
                                  ? '@${m.user!.username}'
                                  : '@user${m.userId}',
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                          if (m.primaryRole != null)
                            Text(m.primaryRole!,
                                style: const TextStyle(
                                    color: AppColors.textGrey, fontSize: 11)),
                        ],
                      ),
                    ),
                  ],
                ),
              ))
          .toList(),
    );
  }

  Widget _infoRow(IconData icon, String label, String value,
      {bool copyable = false}) {
    return Row(
      children: [
        Icon(icon, color: AppColors.textGrey, size: 16),
        const SizedBox(width: 8),
        Text('$label: ',
            style:
                const TextStyle(color: AppColors.textGrey, fontSize: 13)),
        Expanded(
          child: Text(value,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w500),
              overflow: TextOverflow.ellipsis),
        ),
        if (copyable)
          GestureDetector(
            onTap: () {
              Clipboard.setData(ClipboardData(text: value));
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text('Code copied!'),
                duration: Duration(seconds: 2),
                behavior: SnackBarBehavior.floating,
              ));
            },
            child: const Icon(Icons.copy_rounded,
                color: AppColors.textGrey, size: 14),
          ),
      ],
    );
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
                            color: selected
                                ? color
                                : AppColors.borderColor),
                      ),
                      child: Text(s.toUpperCase(),
                          style: TextStyle(
                              color: selected ? color : AppColors.textGrey,
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
                  onPressed:
                      (_themeCtrl.text.trim().isNotEmpty && _roles.length >= 2)
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
