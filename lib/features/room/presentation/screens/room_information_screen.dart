// ── room_information_screen.dart ──────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../domain/entities/member_entity.dart';
import '../../domain/entities/room_entity.dart';
import '../bloc/room_bloc.dart';
import 'room_edit_screen.dart';

class RoomInformationScreen extends StatefulWidget {
  final RoomEntity room;
  const RoomInformationScreen({super.key, required this.room});

  @override
  State<RoomInformationScreen> createState() => _RoomInformationScreenState();
}

class _RoomInformationScreenState extends State<RoomInformationScreen> {
  late RoomEntity _room;
  List<MemberEntity> _members = [];
  bool _loadingMembers = true;
  String _memberSearch = '';
  final _searchController = TextEditingController();
  bool _showSearch = false;

  // ── BG sama dengan ProfileScreen ──
  static Color get _bgColor => AppColors.darkBlueBg;
  static const Color _accent      = Color(0xFF7C9EFF);
  static const Color _accentLight = Color(0xFFB8CDFF);
  static const Color _green       = Color(0xFF4ADE80);

  bool get _isOwner {
    final s = context.read<AuthBloc>().state;
    return s is AuthAuthenticated && _room.createdBy == s.user.id;
  }

  String? get _currentUserId {
    final s = context.read<AuthBloc>().state;
    return s is AuthAuthenticated ? s.user.id.toString() : null;
  }

  @override
  void initState() {
    super.initState();
    _room = widget.room;
    context.read<RoomBloc>().add(RoomMembersLoadRequested(_room.roomCode));
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<MemberEntity> get _filteredMembers {
    if (_memberSearch.isEmpty) return _members;
    return _members
        .where((m) =>
            (m.user?.name ?? '').toLowerCase().contains(_memberSearch.toLowerCase()) ||
            (m.primaryRole ?? '').toLowerCase().contains(_memberSearch.toLowerCase()))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RoomBloc, RoomState>(
      listener: (context, state) {
        if (state is RoomMembersLoaded) {
          setState(() {
            _members = state.members;
            _loadingMembers = false;
          });
        } else if (state is RoomUpdated) {
          setState(() => _room = state.room);
        } else if (state is RoomFailure) {
          setState(() => _loadingMembers = false);
        }
      },
      child: Scaffold(
        // ── BG sama dengan ProfileScreen ──
        backgroundColor: _bgColor,
        body: SafeArea(
          child: Column(
            children: [
              _buildAppBar(context),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _RoomInfoCard(
                        room: _room,
                        isOwner: _isOwner,
                        onEditTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => RoomEditScreen(room: _room),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 16),
                      _SmartMatchingCard(room: _room),
                      const SizedBox(height: 24),
                      _buildMembersHeader(),
                      const SizedBox(height: 12),
                      if (_showSearch) _buildSearchBar(),
                      if (_showSearch) const SizedBox(height: 10),
                      _buildMembersList(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded,
                color: Colors.white, size: 18),
            onPressed: () => Navigator.pop(context),
          ),
          Expanded(
            child: ShaderMask(
              shaderCallback: (bounds) => const LinearGradient(
                colors: [Color(0xFF7C9EFF), Color(0xFFB8CDFF)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ).createShader(bounds),
              child: const Text(
                'Room Details',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.more_vert, color: Colors.white.withOpacity(0.7)),
            onPressed: () => _showOptionsSheet(context),
          ),
        ],
      ),
    );
  }

  Widget _buildMembersHeader() {
    return Row(
      children: [
        const Text(
          'Anggota di Ruang Ini',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Spacer(),
        GestureDetector(
          onTap: () => setState(() {
            _showSearch = !_showSearch;
            if (!_showSearch) {
              _memberSearch = '';
              _searchController.clear();
            }
          }),
          child: Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              // ── card bg sama dengan ProfileScreen ──
              color: AppColors.cardBg,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.borderColor),
            ),
            child: Icon(
              _showSearch ? Icons.close : Icons.search,
              color: Colors.white.withOpacity(0.5),
              size: 16,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: AppColors.cardBg,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.borderColor),
          ),
          child: Icon(Icons.tune_rounded,
              color: Colors.white.withOpacity(0.5), size: 16),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderColor),
      ),
      child: TextField(
        controller: _searchController,
        style: const TextStyle(color: Colors.white, fontSize: 13),
        onChanged: (v) => setState(() => _memberSearch = v),
        decoration: InputDecoration(
          hintText: 'Cari anggota...',
          hintStyle:
              TextStyle(color: Colors.white.withOpacity(0.25), fontSize: 13),
          prefixIcon: Icon(Icons.search,
              color: Colors.white.withOpacity(0.25), size: 18),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
        ),
      ),
    );
  }

  Widget _buildMembersList() {
    if (_loadingMembers) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: CircularProgressIndicator(color: _accent),
        ),
      );
    }
    final members = _filteredMembers;
    if (members.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(32),
        child: Center(
          child: Text(
            _memberSearch.isNotEmpty ? 'Tidak ditemukan' : 'Belum ada anggota',
            style: TextStyle(color: Colors.white.withOpacity(0.3)),
          ),
        ),
      );
    }
    return Column(
      children: members
          .map((m) => _MemberCard(
                member: m,
                isOwner: _isOwner,
                onDelete: _isOwner ? () => _showKickDialog(m) : null,
              ))
          .toList(),
    );
  }

  void _showKickDialog(MemberEntity member) {
    final name = member.user?.name ?? 'User ${member.userId}';
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF161C2C),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: Colors.white.withOpacity(0.1)),
        ),
        title: const Text('Keluarkan Anggota?',
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold)),
        content: Text('Keluarkan $name dari room ini?',
            style: const TextStyle(color: Colors.white60, fontSize: 14)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('BATAL',
                style: TextStyle(color: Colors.white60)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('KELUARKAN',
                style: TextStyle(
                    color: AppColors.red, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  void _showOptionsSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF161C2C),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 8),
          Center(
            child: Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 12),
          if (_isOwner) ...[
            ListTile(
              leading: const Icon(Icons.edit_outlined,
                  color: Color(0xFF7C9EFF)),
              title: const Text('Edit Room',
                  style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => RoomEditScreen(room: _room),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete_outline, color: AppColors.red),
              title: const Text('Hapus Room',
                  style: TextStyle(color: AppColors.red)),
              onTap: () => Navigator.pop(context),
            ),
          ] else ...[
            ListTile(
              leading: const Icon(Icons.exit_to_app, color: AppColors.red),
              title: const Text('Keluar Room',
                  style: TextStyle(color: AppColors.red)),
              onTap: () => Navigator.pop(context),
            ),
          ],
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

// ── Room Info Card ─────────────────────────────────────────────────────────────

class _RoomInfoCard extends StatelessWidget {
  final RoomEntity room;
  final bool isOwner;
  final VoidCallback onEditTap;

  const _RoomInfoCard({
    required this.room,
    required this.isOwner,
    required this.onEditTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        // ── card bg sama dengan ProfileScreen ──
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.borderColor),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: Row(
              children: [
                // ── Icon info — bg biru muda ──
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: const Color(0xFF7C9EFF).withOpacity(0.22),
                    shape: BoxShape.circle,
                    border: Border.all(
                        color: const Color(0xFF7C9EFF).withOpacity(0.5)),
                  ),
                  child: const Icon(Icons.info_outline_rounded,
                      color: Color(0xFF7C9EFF), size: 14),
                ),
                const SizedBox(width: 10),
                ShaderMask(
                  shaderCallback: (bounds) => const LinearGradient(
                    colors: [Color(0xFF7C9EFF), Color(0xFFB8CDFF)],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ).createShader(bounds),
                  child: const Text(
                    'Room Information',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: onEditTap,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFB8CDFF), Color(0xFF3B5FD9)],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF3B5FD9).withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Text(
                      'EDIT',
                      style: TextStyle(
                        color: Color(0xFF0D1B3E),
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
            child: Divider(color: Colors.white.withOpacity(0.06), height: 1),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _InfoCell(
                        label: 'ROLES',
                        value: room.roles.isNotEmpty
                            ? room.roles.join(',\n')
                            : 'No roles',
                      ),
                    ),
                    Expanded(
                      child: _InfoCell(
                        label: 'MAX MEMBERS',
                        value: '${room.maxPerGroup} Anggota',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: _InfoCell(
                        label: 'PRODUCTIVITY',
                        value: 'Flexible',
                      ),
                    ),
                    Expanded(
                      child: _InfoCell(
                        label: 'ENVIRONMENT',
                        value: '● Flexible',
                        valueColor: const Color(0xFF4ADE80),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoCell extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _InfoCell({
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.35),
            fontSize: 10,
            letterSpacing: 1.2,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            color: valueColor ?? Colors.white.withOpacity(0.75),
            fontSize: 13,
            fontWeight: FontWeight.w500,
            height: 1.4,
          ),
        ),
      ],
    );
  }
}

// ── Smart Matching Card ────────────────────────────────────────────────────────

class _SmartMatchingCard extends StatelessWidget {
  final RoomEntity room;
  const _SmartMatchingCard({required this.room});

  static const Color _navyDark = Color(0xFF0D1B3E);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFB8CDFF), Color(0xFF3B5FD9)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFF7C9EFF).withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF5B7FFF).withOpacity(0.2),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.location_on_outlined,
                  color: _navyDark.withOpacity(0.7), size: 13),
              const SizedBox(width: 4),
              Text(
                'FIND GROUP',
                style: TextStyle(
                  color: _navyDark.withOpacity(0.7),
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            'Smart matching',
            style: TextStyle(
              color: _navyDark,
              fontSize: 22,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Find the perfect collaborators with our AI-driven matchmaking algorithm. Maximize your group productivity.",
            style: TextStyle(
              color: _navyDark.withOpacity(0.65),
              fontSize: 13,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 20),
          GestureDetector(
            onTap: () {},
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Start Matching',
                    style: TextStyle(
                      color: _navyDark,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(Icons.arrow_forward_rounded,
                      color: _navyDark, size: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Member Card ────────────────────────────────────────────────────────────────

class _MemberCard extends StatelessWidget {
  final MemberEntity member;
  final bool isOwner;
  final VoidCallback? onDelete;

  const _MemberCard({
    required this.member,
    required this.isOwner,
    this.onDelete,
  });

  String _initials(MemberEntity m) {
    if (m.user != null) {
      final parts = m.user!.name.trim().split(' ');
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

  @override
  Widget build(BuildContext context) {
    final name = member.user?.name ?? 'User ${member.userId}';
    final role = member.primaryRole ?? 'Member';

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        // ── card bg sama dengan ProfileScreen ──
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.borderColor),
      ),
      child: Row(
        children: [
          Stack(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
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
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  width: 11,
                  height: 11,
                  decoration: BoxDecoration(
                    color: const Color(0xFF4ADE80),
                    shape: BoxShape.circle,
                    // ── border ikut cardBg biar seamless ──
                    border: Border.all(color: AppColors.cardBg, width: 2),
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
                  name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    _RoleBadge(label: role),
                    const SizedBox(width: 6),
                    _RoleBadge(label: 'Flexible', isSecondary: true),
                  ],
                ),
              ],
            ),
          ),
          if (isOwner && onDelete != null)
            GestureDetector(
              onTap: onDelete,
              child: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red.withOpacity(0.15)),
                ),
                child: Icon(Icons.delete_outline,
                    color: Colors.red.withOpacity(0.5), size: 16),
              ),
            ),
        ],
      ),
    );
  }
}

class _RoleBadge extends StatelessWidget {
  final String label;
  final bool isSecondary;

  const _RoleBadge({required this.label, this.isSecondary = false});

  @override
  Widget build(BuildContext context) {
    final color =
        isSecondary ? const Color(0xFF7C9EFF) : const Color(0xFF4ADE80);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: color.withOpacity(0.25)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}