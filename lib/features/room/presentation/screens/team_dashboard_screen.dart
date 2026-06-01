// ── team_dashboard_screen.dart ───────────────────────────────────────────────
// Letakkan di: lib/features/room/presentation/screens/team_dashboard_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/constants/app_colors.dart';
import '../../domain/entities/room_entity.dart';

// ─── Dummy models ─────────────────────────────────────────────────────────────

class TeamMember {
  final String id;
  final String name;
  final String role;
  final bool isOwner;

  const TeamMember({
    required this.id,
    required this.name,
    required this.role,
    this.isOwner = false,
  });

  String get initials {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.isNotEmpty ? name[0].toUpperCase() : '?';
  }
}

class TeamModel {
  final String id;
  final String name;
  final List<TeamMember> members;

  const TeamModel({
    required this.id,
    required this.name,
    required this.members,
  });
}

// ─── Main Screen ──────────────────────────────────────────────────────────────

class TeamDashboardScreen extends StatefulWidget {
  final RoomEntity room;

  const TeamDashboardScreen({super.key, required this.room});

  @override
  State<TeamDashboardScreen> createState() => _TeamDashboardScreenState();
}

class _TeamDashboardScreenState extends State<TeamDashboardScreen> {
  int _selectedTeamIndex = 0;

  // ── BG sama dengan ProfileScreen ──
  static Color get _bgColor => AppColors.darkBlueBg;

  // ── Palette lainnya tetap ──
  static const Color _surface     = Color(0xFF1A2035);
  static const Color _navyBg      = Color(0xFF1E2640);
  static const Color _accent      = Color(0xFF7C9EFF);
  static const Color _accentLight = Color(0xFFB8CDFF);
  static const Color _accentBlue  = Color(0xFF4B6EF5);
  static const Color _green       = Color(0xFF4ADE80);
  static const Color _yellow      = Color(0xFFFBBF24);

  // Team tab color palette
  static const List<Color> _teamTabColors = [
    Color(0xFF3B4FD9),
    Color(0xFF2D9B6F),
    Color(0xFF8B5CF6),
    Color(0xFF5B7FFF),
    Color(0xFF8AAEFF),
  ];

  late List<TeamModel> _teams;

  @override
  void initState() {
    super.initState();
    _teams = _buildDummyTeams();
  }

  List<TeamModel> _buildDummyTeams() {
    final count = widget.room.numberOfGroups.clamp(1, 10);
    return List.generate(
      count,
      (i) => TeamModel(
        id: 'team_$i',
        name: 'Team ${i + 1}',
        members: i == 0
            ? [
                const TeamMember(
                    id: '46',
                    name: 'Dev User 46',
                    role: 'AF-Designer',
                    isOwner: true),
                const TeamMember(
                    id: '47', name: 'test user', role: 'FE-Developer'),
                const TeamMember(
                    id: '45', name: 'Dev User 45', role: 'SD-Specialist'),
                const TeamMember(
                    id: '49', name: 'Dev User 49', role: 'SD-Specialist'),
              ]
            : [],
      ),
    );
  }

  TeamModel get _currentTeam => _teams[_selectedTeamIndex];

  Color _statusColor(String status) => switch (status) {
        'open' => _green,
        'ongoing' || 'in_progress' || 'matched' => _green,
        'matching' => _yellow,
        'completed' || 'closed' => Colors.white38,
        _ => Colors.white38,
      };

  String _statusLabel(String status) => switch (status) {
        'open' => 'Open',
        'ongoing' || 'in_progress' || 'matched' => 'Ongoing',
        'matching' => 'Matching',
        'completed' => 'Completed',
        'closed' => 'Closed',
        _ => status,
      };

  Color _tabColor(int index) => _teamTabColors[index % _teamTabColors.length];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ── BG sama dengan ProfileScreen ──
      backgroundColor: _bgColor,
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(),
            _buildTeamTabs(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 14),
                    _buildRoomInfoCard(),
                    const SizedBox(height: 16),
                    _buildTargetSection(),
                    const SizedBox(height: 16),
                    _buildMembersSection(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: _buildFAB(),
    );
  }

  // ── Top bar ────────────────────────────────────────────────────────────────

  Widget _buildTopBar() {
    return Container(
      // ── BG sama dengan ProfileScreen ──
      color: _bgColor,
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: _navyBg,
                borderRadius: BorderRadius.circular(9),
                border: Border.all(color: Colors.white.withOpacity(0.08)),
              ),
              child: Icon(
                Icons.arrow_back_ios_new_rounded,
                color: Colors.white.withOpacity(0.7),
                size: 15,
              ),
            ),
          ),
          const SizedBox(width: 10),
          ShaderMask(
            shaderCallback: (b) => const LinearGradient(
              colors: [_accent, _accentLight],
            ).createShader(b),
            child: const Icon(
              Icons.rocket_launch_rounded,
              color: Colors.white,
              size: 18,
            ),
          ),
          const SizedBox(width: 6),
          ShaderMask(
            shaderCallback: (b) => const LinearGradient(
              colors: [_accent, _accentLight],
            ).createShader(b),
            child: const Text(
              'ProjectPals',
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.3,
              ),
            ),
          ),
          const Spacer(),
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: _navyBg,
              borderRadius: BorderRadius.circular(9),
              border: Border.all(color: Colors.white.withOpacity(0.08)),
            ),
            child: Icon(
              Icons.search_rounded,
              color: Colors.white.withOpacity(0.6),
              size: 17,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [_accentBlue, _accent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              border: Border.all(
                color: _accent.withOpacity(0.5),
                width: 1.5,
              ),
            ),
            child: const Center(
              child: Text(
                'TE',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Team Tabs ──────────────────────────────────────────────────────────────

  Widget _buildTeamTabs() {
    return Container(
      // ── BG sama dengan ProfileScreen ──
      color: _bgColor,
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(bottom: 8),
            child: Text(
              'ACTIVE TEAMS',
              style: TextStyle(
                color: Color(0x55FFFFFF),
                fontSize: 9,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.2,
              ),
            ),
          ),
          Row(
            children: List.generate(_teams.length, (i) {
              final selected = _selectedTeamIndex == i;
              final color = _tabColor(i);
              return Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                      right: i < _teams.length - 1 ? 8 : 0),
                  child: GestureDetector(
                    onTap: () =>
                        setState(() => _selectedTeamIndex = i),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      padding: const EdgeInsets.symmetric(vertical: 9),
                      decoration: BoxDecoration(
                        // ── Selected: gradient biru, unselected: surface ──
                        gradient: selected
                            ? const LinearGradient(
                                colors: [
                                  Color(0xFFB8CDFF),
                                  Color(0xFF3B5FD9),
                                ],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              )
                            : null,
                        color: selected ? null : _surface,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: selected
                              ? Colors.transparent
                              : Colors.white.withOpacity(0.08),
                        ),
                        boxShadow: selected
                            ? [
                                BoxShadow(
                                  color: const Color(0xFF3B5FD9)
                                      .withOpacity(0.35),
                                  blurRadius: 8,
                                  offset: const Offset(0, 3),
                                ),
                              ]
                            : null,
                      ),
                      child: Center(
                        child: Text(
                          _teams[i].name,
                          style: TextStyle(
                            // teks gelap saat selected agar kontras
                            color: selected
                                ? const Color(0xFF0D1B3E)
                                : Colors.white.withOpacity(0.5),
                            fontSize: 12,
                            fontWeight: selected
                                ? FontWeight.w700
                                : FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 2),
        ],
      ),
    );
  }

  // ── Room Info Card ─────────────────────────────────────────────────────────

  Widget _buildRoomInfoCard() {
    final room = widget.room;
    final statusColor = _statusColor(room.status);
    final statusText = _statusLabel(room.status);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        // ── BG card sama dengan ProfileScreen ──
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'ROOM: ${room.projectTheme.toUpperCase()}',
            style: TextStyle(
              color: Colors.white.withOpacity(0.35),
              fontSize: 9,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.1,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  room.projectTheme,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.4,
                    height: 1.1,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: statusColor.withOpacity(0.3)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 5,
                      height: 5,
                      decoration: BoxDecoration(
                        color: statusColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      statusText,
                      style: TextStyle(
                        color: statusColor,
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.6,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ROOMCODE',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.3),
                        fontSize: 8,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.0,
                      ),
                    ),
                    const SizedBox(height: 3),
                    GestureDetector(
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
                      child: Row(
                        children: [
                          Text(
                            room.roomCode,
                            style: const TextStyle(
                              color: Color(0xFF7C9EFF),
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Icon(
                            Icons.copy_rounded,
                            color:
                                const Color(0xFF7C9EFF).withOpacity(0.6),
                            size: 11,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ENVIRONMENT',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.3),
                        fontSize: 8,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.0,
                      ),
                    ),
                    const SizedBox(height: 3),
                    const Text(
                      'Flexible',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'AVAILABILITY',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.3),
                  fontSize: 8,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.0,
                ),
              ),
              const SizedBox(height: 6),
              if (room.roles.isNotEmpty)
                Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  children: room.roles.take(5).map((role) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF7C9EFF).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                            color: const Color(0xFF7C9EFF)
                                .withOpacity(0.2)),
                      ),
                      child: Text(
                        role.length > 4
                            ? role.substring(0, 2).toUpperCase()
                            : role.toUpperCase(),
                        style: const TextStyle(
                          color: Color(0xFF7C9EFF),
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    );
                  }).toList(),
                ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Target Section ─────────────────────────────────────────────────────────

  Widget _buildTargetSection() {
    final roles = widget.room.roles;
    final maxPerGroup = widget.room.maxPerGroup;
    final memberCount = _currentTeam.members.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              'Target Tim',
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            ),
            const Spacer(),
            Text(
              '$memberCount/$maxPerGroup Selesai',
              style: TextStyle(
                color: Colors.white.withOpacity(0.35),
                fontSize: 11,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        ...roles.map((role) {
          final filledCount = _currentTeam.members
              .where((m) =>
                  m.role.toLowerCase().contains(role.toLowerCase()) ||
                  role.toLowerCase().contains(m.role.toLowerCase()))
              .length;
          return _buildRoleTargetItem(role, filledCount, 0);
        }),
        if (roles.isEmpty)
          _buildRoleTargetItem('Member', memberCount, maxPerGroup),
      ],
    );
  }

  Widget _buildRoleTargetItem(String role, int filled, int total) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        // ── BG card sama dengan ProfileScreen ──
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 3,
                height: 14,
                decoration: BoxDecoration(
                  color: const Color(0xFF7C9EFF),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                role,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              Text(
                '$filled/0',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.35),
                  fontSize: 11,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            'Belum ada target untuk role ini',
            style: TextStyle(
              color: Colors.white.withOpacity(0.25),
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  // ── Members Section ────────────────────────────────────────────────────────

  Widget _buildMembersSection() {
    final members = _currentTeam.members;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              'Anggota Team',
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            ),
            const Spacer(),
            Text(
              'Total: ${members.length}',
              style: TextStyle(
                color: Colors.white.withOpacity(0.35),
                fontSize: 11,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        if (members.isEmpty)
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              // ── BG card sama dengan ProfileScreen ──
              color: AppColors.cardBg,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.borderColor),
            ),
            child: Center(
              child: Text(
                'Belum ada anggota di tim ini',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.3),
                  fontSize: 12,
                ),
              ),
            ),
          )
        else
          ...members.map((m) => _buildMemberCard(m)),
      ],
    );
  }

  Widget _buildMemberCard(TeamMember member) {
    final colorPairs = [
      [const Color(0xFF4B6EF5), const Color(0xFF7C9EFF)],
      [const Color(0xFF7C9EFF), const Color(0xFFB8CDFF)],
      [const Color(0xFF2D9B6F), const Color(0xFF4ADE80)],
      [const Color(0xFF8B5CF6), const Color(0xFFB8CDFF)],
    ];
    final idx = member.id.hashCode.abs() % colorPairs.length;
    final gradColors = colorPairs[idx];

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        // ── BG card sama dengan ProfileScreen ──
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderColor),
      ),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: gradColors,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Center(
              child: Text(
                member.initials,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
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
                      member.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (member.isOwner) ...[
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: _green.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(
                              color: _green.withOpacity(0.3)),
                        ),
                        child: const Text(
                          'Ketua',
                          style: TextStyle(
                            color: _green,
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  member.role,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.4),
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          // More button
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: _surface,
              borderRadius: BorderRadius.circular(7),
              border: Border.all(color: Colors.white.withOpacity(0.08)),
            ),
            child: Icon(
              Icons.more_vert_rounded,
              color: Colors.white.withOpacity(0.4),
              size: 16,
            ),
          ),
        ],
      ),
    );
  }

  // ── FAB ────────────────────────────────────────────────────────────────────

  Widget _buildFAB() {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          colors: [Color(0xFF7C9EFF), Color(0xFFB8CDFF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF5B7FFF).withOpacity(0.35),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: const Icon(Icons.add, color: Colors.white, size: 22),
    );
  }
}