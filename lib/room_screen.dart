import 'package:flutter/material.dart';
import 'app_bottom_nav.dart';
import 'dashboard.dart' as dashboard;
import 'join_screen.dart' as join;
import 'profile_screen.dart' as profile;
import 'feedback_screen.dart'; 

// ─────────────────────────────────────────────────────────────────────────────
// Tema Warna & Konstanta
// ─────────────────────────────────────────────────────────────────────────────
const Color _cyan = Color(0xFF3CD7FF);
const Color _darkBg = Color(0xFF041329);
const Color _cardBg = Color(0xFF0A1F35);
const Color _mintGreen = Color(0xFF42E38D);
const Color _textGrey = Color(0xFFC5C6CD);
const Color _border = Color(0xFF1A3A55);
const Color _red = Color(0xFFFF4444);

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
      },
      {
        'username': '@Abici00',
        'role': 'FRONT-END',
        'expertise': ['React', 'Tailwind'],
        'activity': 'Peak (95%)',
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
];

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
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                itemCount: _dummyRooms.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, i) {
                  final room = _dummyRooms[i];
                  return GestureDetector(
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => GroupDetailScreen(room: room),
                      ),
                    ),
                    child: _RoomCard(
                      room: room,
                      isCompleted: room['status'] == 'COMPLETED',
                    ),
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
          if (index == 2) return;
          if (index == 0) {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const dashboard.DashboardScreen()));
          } else if (index == 1) {
            Navigator.pushReplacement(context, buildSlideRoute(const join.JoinRoomScreen()));
          } else if (index == 3) {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const profile.ProfileScreen()));
          }
        },
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
      barrierColor: Colors.black.withAlpha(190),
      builder: (_) => _LeaveDialog(
        onLeave: () {
          Navigator.of(context).pop(); // Tutup Dialog
          Navigator.of(context).pop(); // Kembali ke Room List
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> members = List<Map<String, dynamic>>.from(room['teamMembers'] ?? []);
    final isCompleted = room['status'] == 'COMPLETED';
    final completion = (room['completion'] as num).toDouble();

    return Scaffold(
      backgroundColor: _darkBg,
      appBar: AppBar(
        backgroundColor: _darkBg,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: _cyan, size: 18),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          room['name'] as String,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16, letterSpacing: 1),
        ),
        actions: [
          if (!isCompleted)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: TextButton(
                onPressed: () => _showLeaveDialog(context),
                child: const Text('LEAVE', style: TextStyle(color: _red, fontWeight: FontWeight.bold, fontSize: 12)),
              ),
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Project Status Card
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
                      const Text('PROJECT STATUS', style: TextStyle(color: _textGrey, fontSize: 10, letterSpacing: 1.5)),
                      _StatusBadge(status: room['status'] as String),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    isCompleted ? 'Completed' : 'In Progress',
                    style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Completion', style: TextStyle(color: _textGrey, fontSize: 13)),
                      Text('${(completion * 100).round()}%', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: completion,
                      backgroundColor: _border,
                      valueColor: AlwaysStoppedAnimation<Color>(isCompleted ? _mintGreen : _cyan),
                      minHeight: 6,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(Icons.calendar_today_outlined, color: _textGrey, size: 14),
                      const SizedBox(width: 6),
                      Text('Deadline: ${room['deadline']}', style: const TextStyle(color: _textGrey, fontSize: 12)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Team Members Section
            if (members.isNotEmpty) ...[
              const Row(
                children: [
                  Text('Team Members', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 12),
              ...members.map((m) => _MemberCard(member: m)),
            ],

            const SizedBox(height: 16),

            // Action Buttons
            if (!isCompleted) ...[
              _ActionButton(
                icon: Icons.send_outlined,
                label: 'SUBMIT PROGRESS NOTE',
                color: _cyan,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FeedbackScreen(
                        room: room,
                        member: members.isNotEmpty ? members[0] : {'username': '@Unknown', 'role': 'Team Member'},
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
              _ActionButton(
                icon: Icons.star_outline_rounded,
                label: 'RATE YOUR TEAMMATE',
                color: _mintGreen,
                onTap: () {},
              ),
            ],
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Reusable Components
// ─────────────────────────────────────────────────────────────────────────────

class _RoomCard extends StatelessWidget {
  final Map<String, dynamic> room;
  final bool isCompleted;
  const _RoomCard({required this.room, required this.isCompleted});

  @override
  Widget build(BuildContext context) {
    final bool urgent = room['milestoneUrgent'] ?? false;
    return Container(
      padding: const EdgeInsets.all(16),
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
              Text(
                room['name'] as String,
                style: TextStyle(
                  color: isCompleted ? _textGrey : _cyan,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  decoration: isCompleted ? TextDecoration.lineThrough : TextDecoration.none,
                ),
              ),
              _StatusBadge(status: room['status'] as String),
            ],
          ),
          const SizedBox(height: 4),
          Text(room['role'] as String, style: const TextStyle(color: _textGrey, fontSize: 12)),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(isCompleted ? Icons.check_circle_outline : Icons.event_outlined, color: _textGrey, size: 15),
                  const SizedBox(width: 6),
                  Text(isCompleted ? 'Finished' : room['milestone'], 
                    style: TextStyle(color: !isCompleted && urgent ? _red : _textGrey, fontSize: 12, fontWeight: urgent ? FontWeight.bold : FontWeight.normal)),
                ],
              ),
              Text('${room['members']} Members', style: const TextStyle(color: _textGrey, fontSize: 11)),
            ],
          ),
        ],
      ),
    );
  }
}

class _MemberCard extends StatelessWidget {
  final Map<String, dynamic> member;
  const _MemberCard({required this.member});

  @override
  Widget build(BuildContext context) {
    final expertise = List<String>.from(member['expertise'] ?? []);
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: _cardBg, borderRadius: BorderRadius.circular(14), border: Border.all(color: _border)),
      child: Column(
        children: [
          Row(
            children: [
              const CircleAvatar(backgroundColor: _border, child: Icon(Icons.person, color: Colors.white38, size: 20)),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(member['username'], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    Text(member['role'], style: const TextStyle(color: _textGrey, fontSize: 11)),
                  ],
                ),
              ),
              const Icon(Icons.chat_bubble_outline_rounded, color: _cyan, size: 18),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Wrap(
                spacing: 6,
                children: expertise.map((e) => Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: _cyan.withOpacity(0.1), borderRadius: BorderRadius.circular(6)),
                  child: Text(e, style: const TextStyle(color: _cyan, fontSize: 10)),
                )).toList(),
              ),
              Text(member['activity'] ?? '', style: const TextStyle(color: _mintGreen, fontSize: 11, fontWeight: FontWeight.bold)),
            ],
          )
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  const _ActionButton({required this.icon, required this.label, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.05),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 18),
            const SizedBox(width: 10),
            Text(label, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 13, letterSpacing: 0.5)),
          ],
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;
  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final isCompleted = status == 'COMPLETED';
    final color = isCompleted ? _mintGreen : _cyan;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.4)),
      ),
      child: Text(status, style: TextStyle(color: color, fontSize: 9, fontWeight: FontWeight.bold)),
    );
  }
}

class _LeaveDialog extends StatelessWidget {
  final VoidCallback onLeave;
  const _LeaveDialog({required this.onLeave});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: _cardBg,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20), side: const BorderSide(color: _border)),
      title: const Text('Leave Team?', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
      content: const Text('Are you sure you want to leave this project? Your contribution data will be archived.', style: TextStyle(color: _textGrey, fontSize: 14)),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('CANCEL', style: TextStyle(color: _textGrey))),
        TextButton(onPressed: onLeave, child: const Text('LEAVE TEAM', style: TextStyle(color: _red, fontWeight: FontWeight.bold))),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Route Animation
// ─────────────────────────────────────────────────────────────────────────────
Route buildSlideRoute(Widget page) {
  return PageRouteBuilder(
    pageBuilder: (context, anim, secAnim) => page,
    transitionsBuilder: (context, anim, secAnim, child) {
      return SlideTransition(
        position: anim.drive(Tween(begin: const Offset(1, 0), end: Offset.zero).chain(CurveTween(curve: Curves.ease))),
        child: child,
      );
    },
  );
}