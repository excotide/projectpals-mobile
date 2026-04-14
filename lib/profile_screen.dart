import 'package:flutter/material.dart';
import 'join_screen.dart' as join;
import 'room_screen.dart' as room;
import 'app_bottom_nav.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Dummy data
// ─────────────────────────────────────────────────────────────────────────────
const List<String> _takenUsernames = [
  'furappluv',
  'ambasing',
  'projectpals',
  'admin',
];

const List<Map<String, dynamic>> _projectHistory = [
  {
    'name': 'ProjectPals',
    'role': 'FrontEnd',
    'duration': '3 months',
    'desc':
        'Redesigned the core visualization engine using Three.js and custom shaders, improving rendering performance by 40%.',
    'completed': false,
  },
  {
    'name': 'Mancingin',
    'role': 'FullStack',
    'duration': '1 year',
    'desc':
        'Implemented a real-time data synchronization layer for IoT devices using Rust and WebSockets.',
    'completed': true,
  },
];

// ─────────────────────────────────────────────────────────────────────────────
// Profile Screen
// ─────────────────────────────────────────────────────────────────────────────
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // ── Tema ──────────────────────────────────────────────────────────────────
  final Color primaryCyan = const Color(0xFF3CD7FF);
  final Color darkBlueBg = const Color(0xFF041329);
  final Color cardBg = const Color(0xFF0A1F35);
  final Color mintGreen = const Color(0xFF42E38D);
  final Color textGrey = const Color(0xFFC5C6CD);
  final Color inputBg = const Color(0xFF0D2137);
  final Color borderColor = const Color(0xFF1A3A55);
  int _selectedIndex = 3;

  // ── User Data ─────────────────────────────────────────────────────────────
  String _username = 'ambasing';
  String _nickname = 'Juju';
  final double _rating = 4.8;
  final Set<String> _selectedWindows = {'Morning', 'Afternoon', 'Flexible'};
  final List<String> _expertise = ['FrontEnd', 'UI/UX Designer'];

  bool _isEditing = false;

  // ── Edit State ────────────────────────────────────────────────────────────
  late TextEditingController _usernameCtrl;
  late TextEditingController _nicknameCtrl;
  late TextEditingController _expertiseCtrl;
  late Set<String> _editWindows;
  String _usernameError = '';

  void _startEdit() {
    _usernameCtrl = TextEditingController(text: _username);
    _nicknameCtrl = TextEditingController(text: _nickname);
    _expertiseCtrl = TextEditingController();
    _editWindows = Set.from(_selectedWindows);
    _usernameError = '';
    setState(() => _isEditing = true);
  }

  void _cancelEdit() {
    _usernameCtrl.dispose();
    _nicknameCtrl.dispose();
    _expertiseCtrl.dispose();
    setState(() {
      _isEditing = false;
      _usernameError = '';
    });
  }

  void _saveEdit() {
    final newUsername = _usernameCtrl.text.trim().toLowerCase();
    final newNickname = _nicknameCtrl.text.trim();

    // Validate username
    if (newUsername.isEmpty) {
      setState(() => _usernameError = 'Username cannot be empty');
      return;
    }
    if (newUsername != _username &&
        _takenUsernames.contains(newUsername)) {
      setState(() => _usernameError = 'Username already taken');
      return;
    }

    _usernameCtrl.dispose();
    _nicknameCtrl.dispose();
    _expertiseCtrl.dispose();

    setState(() {
      _username = newUsername;
      if (newNickname.isNotEmpty) _nickname = newNickname;
      _selectedWindows
        ..clear()
        ..addAll(_editWindows);
      _isEditing = false;
      _usernameError = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkBlueBg,
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: _isEditing
            ? _EditView(
                key: const ValueKey('edit'),
                username: _username,
                usernameCtrl: _usernameCtrl,
                nicknameCtrl: _nicknameCtrl,
                expertiseCtrl: _expertiseCtrl,
                expertiseList: _expertise,
                editWindows: _editWindows,
                usernameError: _usernameError,
                primaryCyan: primaryCyan,
                darkBlueBg: darkBlueBg,
                cardBg: cardBg,
                textGrey: textGrey,
                inputBg: inputBg,
                borderColor: borderColor,
                onCancel: _cancelEdit,
                onDone: _saveEdit,
                onUsernameChanged: (v) {
                  final lower = v.toLowerCase();
                  setState(() {
                    if (lower != _username &&
                        _takenUsernames.contains(lower)) {
                      _usernameError = 'Username already taken';
                    } else {
                      _usernameError = '';
                    }
                  });
                },
                onToggleWindow: (w) => setState(() {
                  if (_editWindows.contains(w)) {
                    _editWindows.remove(w);
                  } else {
                    _editWindows.add(w);
                  }
                }),
                onAddExpertise: (tag) => setState(() {
                  if (tag.isNotEmpty && !_expertise.contains(tag)) {
                    _expertise.add(tag);
                  }
                }),
                onRemoveExpertise: (tag) =>
                    setState(() => _expertise.remove(tag)),
              )
            : _ProfileView(
                key: const ValueKey('view'),
                username: _username,
                nickname: _nickname,
                rating: _rating,
                selectedWindows: _selectedWindows,
                expertise: _expertise,
                projects: _projectHistory,
                primaryCyan: primaryCyan,
                darkBlueBg: darkBlueBg,
                cardBg: cardBg,
                mintGreen: mintGreen,
                textGrey: textGrey,
                borderColor: borderColor,
                onEdit: _startEdit,
              ),
      ),
      bottomNavigationBar: AppBottomNavBar(
        currentIndex: _selectedIndex,
        selectedItemColor: mintGreen,
        onTap: (index) {
          if (index == _selectedIndex) {
            return;
          }

          setState(() => _selectedIndex = index);

          if (index == 0) {
            Navigator.pushNamedAndRemoveUntil(
              context,
              '/dashboard',
              (route) => false,
            );
          } else if (index == 1) {
            Navigator.pushReplacement(
              context,
              buildSlideRoute(const join.JoinRoomScreen()),
            );
          } else if (index == 2) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const room.RoomScreen(),
              ),
            );
          }
        },
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Profile View (read-only)
// ─────────────────────────────────────────────────────────────────────────────
class _ProfileView extends StatelessWidget {
  final String username, nickname;
  final double rating;
  final Set<String> selectedWindows;
  final List<String> expertise;
  final List<Map<String, dynamic>> projects;
  final Color primaryCyan, darkBlueBg, cardBg, mintGreen, textGrey,
      borderColor;
  final VoidCallback onEdit;

  const _ProfileView({
    super.key,
    required this.username,
    required this.nickname,
    required this.rating,
    required this.selectedWindows,
    required this.expertise,
    required this.projects,
    required this.primaryCyan,
    required this.darkBlueBg,
    required this.cardBg,
    required this.mintGreen,
    required this.textGrey,
    required this.borderColor,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // ── Cyan Header ──────────────────────────────────────────────────
        _ProfileHeader(
          username: username,
          primaryCyan: primaryCyan,
          darkBlueBg: darkBlueBg,
          isEditing: false,
          showEditIcon: true,
          onEditTap: onEdit,
        ),

        // ── Body ─────────────────────────────────────────────────────────
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Nickname + Rating
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: cardBg,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: borderColor),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('NICKNAME',
                                style: TextStyle(
                                    color: textGrey,
                                    fontSize: 10,
                                    letterSpacing: 1.5)),
                            const SizedBox(height: 4),
                            Text(nickname,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                      Container(
                          width: 1, height: 40, color: borderColor),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('RATINGS',
                                style: TextStyle(
                                    color: textGrey,
                                    fontSize: 10,
                                    letterSpacing: 1.5)),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Icon(Icons.star_rounded,
                                    color: Colors.amber, size: 18),
                                const SizedBox(width: 4),
                                Text(rating.toStringAsFixed(1),
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Productivity Preferences
                _SectionTitle(title: 'Productivity Preferences', textColor: Colors.white),
                const SizedBox(height: 12),
                Row(
                  children: ['Morning', 'Afternoon', 'Flexible']
                      .map((w) => Expanded(
                            child: Container(
                              margin: EdgeInsets.only(
                                  right: w == 'Flexible' ? 0 : 8),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 14),
                              decoration: BoxDecoration(
                                color: selectedWindows.contains(w)
                                    ? primaryCyan.withValues(alpha: 0.1)
                                    : cardBg,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: selectedWindows.contains(w)
                                      ? primaryCyan
                                      : borderColor,
                                  width:
                                      selectedWindows.contains(w) ? 1.5 : 1,
                                ),
                              ),
                              child: Column(
                                children: [
                                  Icon(
                                    _windowIcon(w),
                                    color: selectedWindows.contains(w)
                                        ? primaryCyan
                                        : textGrey,
                                    size: 20,
                                  ),
                                  const SizedBox(height: 6),
                                  Text(w,
                                      style: TextStyle(
                                        color: selectedWindows.contains(w)
                                            ? primaryCyan
                                            : textGrey,
                                        fontSize: 11,
                                        fontWeight: selectedWindows.contains(w)
                                            ? FontWeight.bold
                                            : FontWeight.normal,
                                      )),
                                ],
                              ),
                            ),
                          ))
                      .toList(),
                ),
                const SizedBox(height: 24),

                // Expertise
                _SectionTitle(title: 'Expertise', textColor: Colors.white),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: expertise
                      .map((e) => Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: cardBg,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: borderColor),
                            ),
                            child: Text(e,
                                style: TextStyle(
                                    color: textGrey, fontSize: 13)),
                          ))
                      .toList(),
                ),
                const SizedBox(height: 24),

                // Project History
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _SectionTitle(
                        title: 'Project History',
                        textColor: Colors.white),
                    Icon(Icons.arrow_forward_rounded,
                        color: mintGreen, size: 20),
                  ],
                ),
                const SizedBox(height: 12),
                ...projects.map((p) => _ProjectCard(
                      project: p,
                      cardBg: cardBg,
                      borderColor: borderColor,
                      textGrey: textGrey,
                      mintGreen: mintGreen,
                    )),
              ],
            ),
          ),
        ),

      ],
    );
  }

  IconData _windowIcon(String w) {
    switch (w) {
      case 'Morning':
        return Icons.wb_sunny_outlined;
      case 'Afternoon':
        return Icons.wb_cloudy_outlined;
      case 'Flexible':
        return Icons.nightlight_outlined;
      default:
        return Icons.access_time;
    }
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Edit View
// ─────────────────────────────────────────────────────────────────────────────
class _EditView extends StatelessWidget {
  final String username;
  final TextEditingController usernameCtrl, nicknameCtrl, expertiseCtrl;
  final List<String> expertiseList;
  final Set<String> editWindows;
  final String usernameError;
  final Color primaryCyan, darkBlueBg, cardBg, textGrey, inputBg, borderColor;
  final VoidCallback onCancel, onDone;
  final ValueChanged<String> onUsernameChanged;
  final ValueChanged<String> onToggleWindow;
  final ValueChanged<String> onAddExpertise;
  final ValueChanged<String> onRemoveExpertise;

  const _EditView({
    super.key,
    required this.username,
    required this.usernameCtrl,
    required this.nicknameCtrl,
    required this.expertiseCtrl,
    required this.expertiseList,
    required this.editWindows,
    required this.usernameError,
    required this.primaryCyan,
    required this.darkBlueBg,
    required this.cardBg,
    required this.textGrey,
    required this.inputBg,
    required this.borderColor,
    required this.onCancel,
    required this.onDone,
    required this.onUsernameChanged,
    required this.onToggleWindow,
    required this.onAddExpertise,
    required this.onRemoveExpertise,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // ── Top bar: Cancel | Done ────────────────────────────────────────
        Container(
          color: primaryCyan,
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top + 8,
            bottom: 0,
            left: 16,
            right: 16,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: onCancel,
                child: const Text('Cancel!',
                    style: TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.bold,
                        fontSize: 15)),
              ),
              TextButton(
                onPressed: onDone,
                child: const Text('Done',
                    style: TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.bold,
                        fontSize: 15)),
              ),
            ],
          ),
        ),

        // ── Edit Header ───────────────────────────────────────────────────
        _ProfileHeader(
          username: usernameCtrl.text,
          primaryCyan: primaryCyan,
          darkBlueBg: darkBlueBg,
          isEditing: true,
          showEditIcon: true,
          onEditTap: null,
          usernameCtrl: usernameCtrl,
          usernameError: usernameError,
          onUsernameChanged: onUsernameChanged,
        ),

        // ── Edit Fields ───────────────────────────────────────────────────
        Expanded(
          child: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: SingleChildScrollView(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Nickname
                  Text('NICKNAME',
                      style: TextStyle(
                          color: textGrey,
                          fontSize: 10,
                          letterSpacing: 1.5)),
                  const SizedBox(height: 8),
                  _EditField(
                    controller: nicknameCtrl,
                    hint: 'Insert Text',
                    primaryCyan: primaryCyan,
                    textGrey: textGrey,
                    inputBg: inputBg,
                    borderColor: borderColor,
                  ),
                  const SizedBox(height: 24),

                  // Productivity Preferences
                  _SectionTitle(
                      title: 'Productivity Preferences',
                      textColor: Colors.white),
                  const SizedBox(height: 12),
                  Row(
                    children: ['Morning', 'Afternoon', 'Flexible']
                        .map((w) => Expanded(
                              child: GestureDetector(
                                onTap: () => onToggleWindow(w),
                                child: Container(
                                  margin: EdgeInsets.only(
                                      right: w == 'Flexible' ? 0 : 8),
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 14),
                                  decoration: BoxDecoration(
                                    color: editWindows.contains(w)
                                        ? primaryCyan.withValues(alpha: 0.1)
                                        : cardBg,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: editWindows.contains(w)
                                          ? primaryCyan
                                          : borderColor,
                                      width: editWindows.contains(w) ? 1.5 : 1,
                                    ),
                                  ),
                                  child: Column(
                                    children: [
                                      Icon(
                                        _windowIcon(w),
                                        color: editWindows.contains(w)
                                            ? primaryCyan
                                            : textGrey,
                                        size: 20,
                                      ),
                                      const SizedBox(height: 6),
                                      Text(w,
                                          style: TextStyle(
                                            color: editWindows.contains(w)
                                                ? primaryCyan
                                                : textGrey,
                                            fontSize: 11,
                                            fontWeight: editWindows.contains(w)
                                                ? FontWeight.bold
                                                : FontWeight.normal,
                                          )),
                                    ],
                                  ),
                                ),
                              ),
                            ))
                        .toList(),
                  ),
                  const SizedBox(height: 24),

                  // Expertise
                  _SectionTitle(
                      title: 'Expertise', textColor: Colors.white),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _EditField(
                          controller: expertiseCtrl,
                          hint: 'Insert Text',
                          primaryCyan: primaryCyan,
                          textGrey: textGrey,
                          inputBg: inputBg,
                          borderColor: borderColor,
                          onSubmitted: (v) {
                            onAddExpertise(v);
                            expertiseCtrl.clear();
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: () {
                          onAddExpertise(expertiseCtrl.text.trim());
                          expertiseCtrl.clear();
                        },
                        child: Container(
                          width: 46,
                          height: 50,
                          decoration: BoxDecoration(
                            color: primaryCyan,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.add,
                              color: Colors.black87, size: 20),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: expertiseList
                        .map((e) => Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 8),
                              decoration: BoxDecoration(
                                color: primaryCyan.withValues(alpha: 0.08),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                    color:
                                        primaryCyan.withValues(alpha: 0.3)),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(e,
                                      style: TextStyle(
                                          color: primaryCyan, fontSize: 13)),
                                  const SizedBox(width: 6),
                                  GestureDetector(
                                    onTap: () => onRemoveExpertise(e),
                                    child: Icon(Icons.close,
                                        color: primaryCyan, size: 13),
                                  ),
                                ],
                              ),
                            ))
                        .toList(),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  IconData _windowIcon(String w) {
    switch (w) {
      case 'Morning':
        return Icons.wb_sunny_outlined;
      case 'Afternoon':
        return Icons.wb_cloudy_outlined;
      case 'Flexible':
        return Icons.nightlight_outlined;
      default:
        return Icons.access_time;
    }
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Profile Header (cyan wave + avatar)
// ─────────────────────────────────────────────────────────────────────────────
class _ProfileHeader extends StatelessWidget {
  final String username;
  final Color primaryCyan, darkBlueBg;
  final bool isEditing, showEditIcon;
  final VoidCallback? onEditTap;
  final TextEditingController? usernameCtrl;
  final String? usernameError;
  final ValueChanged<String>? onUsernameChanged;

  const _ProfileHeader({
    required this.username,
    required this.primaryCyan,
    required this.darkBlueBg,
    required this.isEditing,
    required this.showEditIcon,
    required this.onEditTap,
    this.usernameCtrl,
    this.usernameError,
    this.onUsernameChanged,
  });

  @override
  Widget build(BuildContext context) {
    final topPad = isEditing ? 0.0 : MediaQuery.of(context).padding.top + 8.0;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: primaryCyan,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.elliptical(200, 60),
          bottomRight: Radius.elliptical(200, 60),
        ),
      ),
      padding: EdgeInsets.only(
        top: topPad + 16,
        bottom: 28,
        left: 16,
        right: 16,
      ),
      child: Column(
        children: [
          // Avatar
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF1A3A55),
                  border: Border.all(color: Colors.white, width: 3),
                ),
                child: ClipOval(
                  child: Container(
                    color: const Color(0xFF2D5A8A),
                    child: const Icon(Icons.person,
                        size: 55, color: Colors.white54),
                  ),
                ),
              ),
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: darkBlueBg,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 1.5),
                ),
                child: Icon(Icons.edit_rounded,
                    size: 14, color: primaryCyan),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Username
          if (isEditing && usernameCtrl != null) ...[
            _UsernameEditField(
              controller: usernameCtrl!,
              error: usernameError ?? '',
              primaryCyan: primaryCyan,
              onChanged: onUsernameChanged ?? (_) {},
            ),
          ] else ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '@$username',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (showEditIcon) ...[
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: onEditTap,
                    child: Icon(Icons.edit_rounded,
                        size: 16, color: Colors.black54),
                  ),
                ],
              ],
            ),
          ],
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Username Edit Field (inline in header)
// ─────────────────────────────────────────────────────────────────────────────
class _UsernameEditField extends StatelessWidget {
  final TextEditingController controller;
  final String error;
  final Color primaryCyan;
  final ValueChanged<String> onChanged;

  const _UsernameEditField({
    required this.controller,
    required this.error,
    required this.primaryCyan,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final hasError = error.isNotEmpty;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('@',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold)),
            IntrinsicWidth(
              child: TextField(
                controller: controller,
                onChanged: onChanged,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: hasError ? Colors.redAccent : Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                decoration: InputDecoration(
                  isDense: true,
                  contentPadding: const EdgeInsets.only(bottom: 2),
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: hasError ? Colors.redAccent : Colors.white70),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: hasError ? Colors.redAccent : Colors.white,
                        width: 2),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: hasError ? Colors.redAccent : Colors.white70),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Icon(Icons.edit_rounded, size: 16, color: Colors.black54),
          ],
        ),
        if (hasError) ...[
          const SizedBox(height: 4),
          Text(error,
              style: const TextStyle(
                  color: Colors.redAccent,
                  fontSize: 11,
                  fontWeight: FontWeight.w500)),
        ],
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Project Card
// ─────────────────────────────────────────────────────────────────────────────
class _ProjectCard extends StatelessWidget {
  final Map<String, dynamic> project;
  final Color cardBg, borderColor, textGrey, mintGreen;

  const _ProjectCard({
    required this.project,
    required this.cardBg,
    required this.borderColor,
    required this.textGrey,
    required this.mintGreen,
  });

  @override
  Widget build(BuildContext context) {
    final isCompleted = project['completed'] as bool;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(project['name'] as String,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold)),
              if (isCompleted)
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: mintGreen.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                        color: mintGreen.withValues(alpha: 0.4)),
                  ),
                  child: Text('COMPLETED',
                      style: TextStyle(
                          color: mintGreen,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.8)),
                ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            '${project['role']} • ${project['duration']}',
            style: TextStyle(color: textGrey, fontSize: 12),
          ),
          const SizedBox(height: 10),
          Text(
            project['desc'] as String,
            style: TextStyle(
                color: textGrey, fontSize: 13, height: 1.5),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Shared Widgets
// ─────────────────────────────────────────────────────────────────────────────
class _SectionTitle extends StatelessWidget {
  final String title;
  final Color textColor;

  const _SectionTitle({required this.title, required this.textColor});

  @override
  Widget build(BuildContext context) {
    return Text(title,
        style: TextStyle(
            color: textColor,
            fontSize: 17,
            fontWeight: FontWeight.bold));
  }
}

class _EditField extends StatefulWidget {
  final TextEditingController controller;
  final String hint;
  final Color primaryCyan, textGrey, inputBg, borderColor;
  final ValueChanged<String>? onSubmitted;

  const _EditField({
    required this.controller,
    required this.hint,
    required this.primaryCyan,
    required this.textGrey,
    required this.inputBg,
    required this.borderColor,
    this.onSubmitted,
  });

  @override
  State<_EditField> createState() => _EditFieldState();
}

class _EditFieldState extends State<_EditField> {
  final FocusNode _focus = FocusNode();

  @override
  void initState() {
    super.initState();
    _focus.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _focus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: widget.inputBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color:
              _focus.hasFocus ? widget.primaryCyan : widget.borderColor,
          width: _focus.hasFocus ? 1.5 : 1,
        ),
      ),
      child: TextField(
        controller: widget.controller,
        focusNode: _focus,
        onSubmitted: widget.onSubmitted,
        style: const TextStyle(color: Colors.white, fontSize: 14),
        decoration: InputDecoration(
          hintText: widget.hint,
          hintStyle: TextStyle(
              color: widget.textGrey.withValues(alpha: 0.4), fontSize: 14),
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
  }
}

