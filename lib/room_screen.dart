import 'package:flutter/material.dart';
import 'app_bottom_nav.dart';
import 'dashboard.dart' as dashboard;
import 'join_screen.dart' as join;
import 'profile_screen.dart' as profile;

// ─────────────────────────────────────────────────────────────────────────────
// Dummy Data
// ─────────────────────────────────────────────────────────────────────────────
final List<Map<String, dynamic>> _dummyRooms = [
  {
    'id': '1',
    'name': 'CLOUDFRIEND',
    'role': 'BACK-END',
    'members': 5,
    'status': 'IN PROGRESS',
    'milestone': 'Due in 9 days',
    'milestoneUrgent': false,
    'completion': 0.45,
    'deadline': 'Nov 10, 2026',
    'teamMembers': [
      {
        'username': '@Labje',
        'role': 'BACK-END',
        'expertise': ['React', 'Rust'],
        'activity': 'High (98%)',
        'activityLevel': 0.98,
      },
      {
        'username': '@Abici00',
        'role': 'FRONT-END',
        'expertise': ['React', 'Tailwind'],
        'activity': 'Peak (95%)',
        'activityLevel': 0.95,
      },
      {
        'username': '@DevMark',
        'role': 'BACK-END',
        'expertise': ['Docker', 'AWS'],
        'activity': 'Idle (22%)',
        'activityLevel': 0.22,
      },
    ],
  },
  {
    'id': '2',
    'name': 'DRINKEDIN',
    'role': 'FRONT-END',
    'members': 3,
    'status': 'IN PROGRESS',
    'milestone': 'Due in 3 days',
    'milestoneUrgent': true,
    'completion': 0.64,
    'deadline': 'Oct 24, 2026',
    'teamMembers': [
      {
        'username': '@Labje',
        'role': 'BACK-END',
        'expertise': ['React', 'Rust'],
        'activity': 'High (98%)',
        'activityLevel': 0.98,
      },
      {
        'username': '@Abici00',
        'role': 'FRONT-END',
        'expertise': ['React', 'Tailwind'],
        'activity': 'Peak (95%)',
        'activityLevel': 0.95,
      },
      {
        'username': '@JunkDev',
        'role': 'DEVOPS',
        'expertise': ['Docker', 'AWS'],
        'activity': 'Idle (22%)',
        'activityLevel': 0.22,
      },
    ],
  },
  {
    'id': '3',
    'name': 'Neural Core',
    'role': 'UI DESIGNER',
    'members': 4,
    'status': 'COMPLETED',
    'milestone': 'Project Finished',
    'milestoneUrgent': false,
    'completion': 1.0,
    'deadline': 'Sep 1, 2026',
    'teamMembers': [],
  },
  {
    'id': '4',
    'name': 'Pixel Surge',
    'role': 'FRONT-END',
    'members': 6,
    'status': 'COMPLETED',
    'milestone': 'Project Finished',
    'milestoneUrgent': false,
    'completion': 1.0,
    'deadline': 'Aug 15, 2026',
    'teamMembers': [],
  },
];

// ─────────────────────────────────────────────────────────────────────────────
// Tema warna
// ─────────────────────────────────────────────────────────────────────────────
const Color _cyan = Color(0xFF3CD7FF);
const Color _darkBg = Color(0xFF041329);
const Color _cardBg = Color(0xFF0A1F35);
const Color _mintGreen = Color(0xFF42E38D);
const Color _textGrey = Color(0xFFC5C6CD);
const Color _border = Color(0xFF1A3A55);
const Color _red = Color(0xFFFF4444);

// ─────────────────────────────────────────────────────────────────────────────
// Room List Screen
// ─────────────────────────────────────────────────────────────────────────────
class RoomScreen extends StatelessWidget {
  const RoomScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _darkBg,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header ───────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'My Joined Rooms',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Manage your active collaborations',
                    style: TextStyle(color: _textGrey, fontSize: 13),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // ── Room List ─────────────────────────────────────────────────
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 4),
                itemCount: _dummyRooms.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, i) {
                  final room = _dummyRooms[i];
                  final isCompleted = room['status'] == 'COMPLETED';
                  return GestureDetector(
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => GroupDetailScreen(room: room),
                      ),
                    ),
                    child: _RoomCard(room: room, isCompleted: isCompleted),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: AppBottomNavBar(
        currentIndex: 2,
        selectedItemColor: _mintGreen,
        onTap: (index) {
          if (index == 2) {
            return;
          }

          if (index == 0) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const dashboard.DashboardScreen(),
              ),
            );
          } else if (index == 1) {
            Navigator.pushReplacement(
              context,
              buildSlideRoute(const join.JoinRoomScreen()),
            );
          } else if (index == 3) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const profile.ProfileScreen(),
              ),
            );
          }
        },
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Room Card
// ─────────────────────────────────────────────────────────────────────────────
class _RoomCard extends StatelessWidget {
  final Map<String, dynamic> room;
  final bool isCompleted;

  const _RoomCard({required this.room, required this.isCompleted});

  @override
  Widget build(BuildContext context) {
    final urgent = room['milestoneUrgent'] as bool;

    return Container(
      decoration: BoxDecoration(
        color: _cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _border),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Name + Status badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                room['name'] as String,
                style: TextStyle(
                  color: isCompleted ? _textGrey : _cyan,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  decoration: isCompleted
                      ? TextDecoration.lineThrough
                      : TextDecoration.none,
                  decorationColor: _textGrey,
                ),
              ),
              _StatusBadge(status: room['status'] as String),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            room['role'] as String,
            style: TextStyle(
                color: _textGrey,
                fontSize: 12,
                fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 12),

          // Members
          Row(
            children: [
              Icon(Icons.group_outlined, color: _textGrey, size: 16),
              const SizedBox(width: 6),
              Text(
                '${room['members']} members',
                style: TextStyle(color: _textGrey, fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Divider(color: _border, height: 1),
          const SizedBox(height: 12),

          // Milestone
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    isCompleted
                        ? Icons.check_circle_outline
                        : Icons.event_outlined,
                    color: _textGrey,
                    size: 15,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    isCompleted ? 'Project Finished' : 'Next Milestone',
                    style: TextStyle(color: _textGrey, fontSize: 12),
                  ),
                ],
              ),
              Text(
                room['milestone'] as String,
                style: TextStyle(
                  color: isCompleted
                      ? _textGrey
                      : urgent
                          ? _red
                          : Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Group Detail Screen
// ─────────────────────────────────────────────────────────────────────────────
class GroupDetailScreen extends StatelessWidget {
  final Map<String, dynamic> room;

  const GroupDetailScreen({super.key, required this.room});

  void _showLeaveDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.75),
      builder: (_) => _LeaveDialog(
        onLeave: () {
          Navigator.of(context).pop(); // close dialog
          Navigator.of(context).pop(); // go back to room list
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final members =
        List<Map<String, dynamic>>.from(room['teamMembers'] as List);
    final completion = room['completion'] as double;
    final isCompleted = room['status'] == 'COMPLETED';

    return Scaffold(
      backgroundColor: _darkBg,
      appBar: AppBar(
        backgroundColor: _darkBg,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: _cyan, size: 18),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          room['name'] as String,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
            letterSpacing: 1,
          ),
        ),
        actions: [
          if (!isCompleted)
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: ElevatedButton(
                onPressed: () => _showLeaveDialog(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _red,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 8),
                  elevation: 0,
                ),
                child: const Text('LEAVE TEAM',
                    style: TextStyle(
                        fontSize: 12, fontWeight: FontWeight.bold)),
              ),
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Project Status Card ───────────────────────────────────────
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: _cardBg,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: _border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('PROJECT STATUS',
                          style: TextStyle(
                              color: _textGrey,
                              fontSize: 10,
                              letterSpacing: 1.5)),
                      _StatusBadge(status: room['status'] as String),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    isCompleted ? 'Completed' : 'In Progress',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Completion',
                          style:
                              TextStyle(color: _textGrey, fontSize: 13)),
                      Text(
                        '${(completion * 100).round()}%',
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 13),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: completion,
                      backgroundColor: _border,
                      valueColor: AlwaysStoppedAnimation<Color>(
                          isCompleted ? _mintGreen : _cyan),
                      minHeight: 6,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(Icons.calendar_today_outlined,
                          color: _textGrey, size: 14),
                      const SizedBox(width: 6),
                      Text(
                        'Deadline: ${room['deadline']}',
                        style:
                            TextStyle(color: _textGrey, fontSize: 12),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // ── Team Members ──────────────────────────────────────────────
            if (members.isNotEmpty) ...[
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
                  Text('View All >',
                      style: TextStyle(color: _cyan, fontSize: 12)),
                ],
              ),
              const SizedBox(height: 12),
              ...members.map((m) => _MemberCard(member: m)),
            ],

            const SizedBox(height: 16),

            // ── Action Buttons ────────────────────────────────────────────
            if (!isCompleted) ...[
              _ActionButton(
                icon: Icons.send_outlined,
                label: 'SUBMIT PROGRESS NOTE',
                color: _cyan,
                onTap: () {},
              ),
              const SizedBox(height: 12),
              _ActionButton(
                icon: Icons.star_outline_rounded,
                label: 'RATE YOUR TEAMMATE',
                color: _mintGreen,
                onTap: () {},
              ),
              const SizedBox(height: 20),
            ],
          ],
        ),
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppBottomNavBar(
            currentIndex: 2,
            selectedItemColor: _mintGreen,
            onTap: (index) {
              if (index == 2) {
                Navigator.of(context).pop();
                return;
              }

              if (index == 0) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const dashboard.DashboardScreen(),
                  ),
                );
              } else if (index == 1) {
                Navigator.pushReplacement(
                  context,
                  buildSlideRoute(const join.JoinRoomScreen()),
                );
              } else if (index == 3) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const profile.ProfileScreen(),
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Member Card
// ─────────────────────────────────────────────────────────────────────────────
class _MemberCard extends StatelessWidget {
  final Map<String, dynamic> member;

  const _MemberCard({required this.member});

  Color _activityColor(double level) {
    if (level >= 0.8) return _cyan;
    if (level >= 0.5) return _mintGreen;
    return _textGrey;
  }

  @override
  Widget build(BuildContext context) {
    final level = member['activityLevel'] as double;
    final expertise = List<String>.from(member['expertise'] as List);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _border),
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Avatar
              Stack(
                children: [
                  Container(
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFF1A3A55),
                      border: Border.all(color: _border, width: 2),
                    ),
                    child: const Icon(Icons.person,
                        color: Colors.white38, size: 26),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: _mintGreen,
                        shape: BoxShape.circle,
                        border: Border.all(color: _cardBg, width: 1.5),
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
                      member['username'] as String,
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14),
                    ),
                    Text(
                      member['role'] as String,
                      style: TextStyle(
                          color: _textGrey, fontSize: 11),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chat_bubble_outline_rounded,
                  color: _textGrey, size: 18),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('EXPERTISE',
                        style: TextStyle(
                            color: _textGrey,
                            fontSize: 9,
                            letterSpacing: 1.2)),
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 6,
                      children: expertise
                          .map((e) => Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color:
                                      _cyan.withValues(alpha: 0.08),
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(
                                      color:
                                          _cyan.withValues(alpha: 0.2)),
                                ),
                                child: Text(e,
                                    style: TextStyle(
                                        color: _cyan, fontSize: 10)),
                              ))
                          .toList(),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('ACTIVITY',
                      style: TextStyle(
                          color: _textGrey,
                          fontSize: 9,
                          letterSpacing: 1.2)),
                  const SizedBox(height: 6),
                  Text(
                    member['activity'] as String,
                    style: TextStyle(
                      color: _activityColor(level),
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
}

// ─────────────────────────────────────────────────────────────────────────────
// Action Button
// ─────────────────────────────────────────────────────────────────────────────
class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 18),
            const SizedBox(width: 10),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 13,
                letterSpacing: 0.8,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Leave Team Dialog
// ─────────────────────────────────────────────────────────────────────────────
class _LeaveDialog extends StatefulWidget {
  final VoidCallback onLeave;

  const _LeaveDialog({required this.onLeave});

  @override
  State<_LeaveDialog> createState() => _LeaveDialogState();
}

class _LeaveDialogState extends State<_LeaveDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        duration: const Duration(milliseconds: 350), vsync: this);
    _scale =
        CurvedAnimation(parent: _ctrl, curve: Curves.easeOutBack);
    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: ScaleTransition(
        scale: _scale,
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFF0A1F35),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFF1A3A55)),
          ),
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Warning icon
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: const Color(0xFF1A2E45),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(Icons.warning_amber_rounded,
                    color: _cyan, size: 32),
              ),
              const SizedBox(height: 20),

              const Text(
                'Leave The Team?',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Are you sure you want to exit? Your progress on this task will be lost forever.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: _textGrey,
                  fontSize: 13,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 24),

              // Stay button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _cyan,
                    foregroundColor: Colors.black87,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    elevation: 0,
                  ),
                  child: const Text(
                    'STAY',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        letterSpacing: 1),
                  ),
                ),
              ),
              const SizedBox(height: 10),

              // Leave button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: TextButton(
                  onPressed: widget.onLeave,
                  style: TextButton.styleFrom(
                    foregroundColor: _textGrey,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(
                          color: const Color(0xFF1A3A55)),
                    ),
                  ),
                  child: const Text(
                    'LEAVE',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        letterSpacing: 1),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Status Badge
// ─────────────────────────────────────────────────────────────────────────────
class _StatusBadge extends StatelessWidget {
  final String status;

  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final isCompleted = status == 'COMPLETED';
    final color = isCompleted ? _mintGreen : _cyan;

    return Container(
      padding:
          const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
