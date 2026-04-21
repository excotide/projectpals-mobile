import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/constants/app_strings.dart';
import 'dashboard.dart' as dashboard;
import 'profile_screen.dart' as profile;
import 'room_screen.dart' as room;
import '../widgets/app_bottom_nav.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Dummy valid room codes
// ─────────────────────────────────────────────────────────────────────────────
const Map<String, Map<String, dynamic>> _validRooms = {
  '555678': {
    'roomName': 'Project Pals',
    'memberPerGroup': 5,
    'groups': 12,
    'roles': ['Front-end', 'Back-end', 'UI/UX'],
  },
  'ABC123': {
    'roomName': 'Design Sprint',
    'memberPerGroup': 3,
    'groups': 6,
    'roles': ['UI/UX', 'Front-end'],
  },
  'XYZ999': {
    'roomName': 'Hackathon 2026',
    'memberPerGroup': 4,
    'groups': 8,
    'roles': ['Front-end', 'Back-end', 'UI/UX', 'DevOps'],
  },
};

// ─────────────────────────────────────────────────────────────────────────────
// Join Room Entry Screen
// ─────────────────────────────────────────────────────────────────────────────
class JoinRoomScreen extends StatefulWidget {
  const JoinRoomScreen({super.key});

  @override
  State<JoinRoomScreen> createState() => _JoinRoomScreenState();
}

class _JoinRoomScreenState extends State<JoinRoomScreen> {
  // ── Tema ──────────────────────────────────────────────────────────────────
  final Color primaryCyan = const Color(0xFF3CD7FF);
  final Color darkBlueBg = const Color(0xFF041329);
  final Color inputBg = const Color(0xFF0D2137);
  final Color borderColor = const Color(0xFF1A3A55);
  final Color textGrey = const Color(0xFFC5C6CD);

  final TextEditingController _codeCtrl = TextEditingController();
  bool _isLoading = false;

  Future<void> _joinRoom() async {
    final code = _codeCtrl.text.trim().toUpperCase();
    if (code.isEmpty) return;

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 1200));
    setState(() => _isLoading = false);

    if (!mounted) return;

    if (_validRooms.containsKey(code)) {
      // valid → go to Match Group flow
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) =>
          MatchGroupScreen(
            roomData: _validRooms[code]!,
            roomCode: code,
          ),
        ),
      );
    } else {
      // invalid → show full-screen invalid page
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => InvalidCodeScreen(
            primaryCyan: primaryCyan,
            darkBlueBg: darkBlueBg,
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    _codeCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkBlueBg,
      appBar: AppBar(
        backgroundColor: primaryCyan,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black87),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: const Text(
          'Join Room',
          style: TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.bold,
              fontSize: 18),
        ),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Spacer(flex: 2),

              // ── Badge ──────────────────────────────────────────────────
              Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 18, vertical: 7),
                  decoration: BoxDecoration(
                    border: Border.all(color: borderColor),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'FIND YOUR GROUP',
                    style: TextStyle(
                      color: textGrey,
                      fontSize: 11,
                      letterSpacing: 1.5,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // ── Headline ───────────────────────────────────────────────
              const Center(
                child: Text(
                  'Find your people.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    height: 1.2,
                  ),
                ),
              ),
              Center(
                child: Text(
                  'Build your project.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: primaryCyan,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    height: 1.2,
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Center(
                child: Text(
                  'Connect with developers and designers globally\nto bring your vision to life.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: textGrey,
                    fontSize: 13,
                    height: 1.5,
                  ),
                ),
              ),

              const Spacer(flex: 2),

              // ── Input ──────────────────────────────────────────────────
              _CodeInputField(
                controller: _codeCtrl,
                primaryCyan: primaryCyan,
                textGrey: textGrey,
                inputBg: inputBg,
                borderColor: borderColor,
              ),
              const SizedBox(height: 14),

              // ── Join Button ────────────────────────────────────────────
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _joinRoom,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryCyan,
                    foregroundColor: Colors.black87,
                    disabledBackgroundColor:
                        primaryCyan.withValues(alpha: 0.4),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 0,
                  ),
                  child: _isLoading
                      ? SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                                darkBlueBg),
                          ),
                        )
                      : const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'JOIN ROOM',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                letterSpacing: 1,
                              ),
                            ),
                            SizedBox(width: 8),
                            Icon(Icons.arrow_forward_rounded, size: 18),
                          ],
                        ),
                ),
              ),

              const Spacer(flex: 3),
            ],
          ),
        ),
      ),
      bottomNavigationBar: AppBottomNavBar(
        currentIndex: 1,
        selectedItemColor: const Color(0xFF42E38D),
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const dashboard.DashboardScreen(),
              ),
            );
          } else if (index == 2) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const room.RoomScreen(),
              ),
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
// Code Input Field
// ─────────────────────────────────────────────────────────────────────────────
class _CodeInputField extends StatefulWidget {
  final TextEditingController controller;
  final Color primaryCyan, textGrey, inputBg, borderColor;

  const _CodeInputField({
    required this.controller,
    required this.primaryCyan,
    required this.textGrey,
    required this.inputBg,
    required this.borderColor,
  });

  @override
  State<_CodeInputField> createState() => _CodeInputFieldState();
}

class _CodeInputFieldState extends State<_CodeInputField> {
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
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color:
              _focus.hasFocus ? widget.primaryCyan : widget.borderColor,
          width: _focus.hasFocus ? 1.5 : 1,
        ),
      ),
      child: TextField(
        controller: widget.controller,
        focusNode: _focus,
        textCapitalization: TextCapitalization.characters,
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9]')),
          LengthLimitingTextInputFormatter(10),
        ],
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
          letterSpacing: 2,
          fontWeight: FontWeight.w600,
        ),
        decoration: InputDecoration(
          prefixIcon: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Icon(
              Icons.vpn_key_outlined,
              color: _focus.hasFocus
                  ? widget.primaryCyan
                  : widget.textGrey.withValues(alpha: 0.5),
              size: 20,
            ),
          ),
          prefixIconConstraints:
              const BoxConstraints(minWidth: 52, minHeight: 52),
          hintText: 'Enter Unique Room Code',
          hintStyle: TextStyle(
            color: widget.textGrey.withValues(alpha: 0.4),
            fontSize: 14,
            letterSpacing: 0.5,
            fontWeight: FontWeight.normal,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 18),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Invalid Code Screen
// ─────────────────────────────────────────────────────────────────────────────
class InvalidCodeScreen extends StatefulWidget {
  final Color primaryCyan, darkBlueBg;

  const InvalidCodeScreen({
    super.key,
    required this.primaryCyan,
    required this.darkBlueBg,
  });

  @override
  State<InvalidCodeScreen> createState() => _InvalidCodeScreenState();
}

class _InvalidCodeScreenState extends State<InvalidCodeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scale, _fade;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);
    _scale = CurvedAnimation(parent: _ctrl, curve: Curves.easeOutBack);
    _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeIn);
    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const errorRed = Color(0xFFFF4D4D);
    const errorRedDim = Color(0xFF3D1010);

    return Scaffold(
      backgroundColor: widget.darkBlueBg,
      body: FadeTransition(
        opacity: _fade,
        child: Padding(
          padding: EdgeInsets.only(
            left: 32,
            right: 32,
            bottom: MediaQuery.of(context).padding.bottom + 24,
            top: MediaQuery.of(context).padding.top,
          ),
          child: Column(
            children: [
              const Spacer(flex: 3),

              // ── Error Icon ─────────────────────────────────────────────
              ScaleTransition(
                scale: _scale,
                child: Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    color: errorRedDim,
                    borderRadius: BorderRadius.circular(22),
                    boxShadow: [
                      BoxShadow(
                        color: errorRed.withValues(alpha: 0.25),
                        blurRadius: 30,
                        spreadRadius: 4,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.link_off_rounded,
                    color: errorRed,
                    size: 40,
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // ── Text ───────────────────────────────────────────────────
              const Text(
                'Invalid Code',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'The room code you entered could not be found in the ProjectPals registry. Please verify the code and try again.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: const Color(0xFFC5C6CD),
                  fontSize: 14,
                  height: 1.6,
                ),
              ),

              const Spacer(flex: 3),

              // ── Try Again Button ───────────────────────────────────────
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton.icon(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.refresh_rounded, size: 18),
                  label: const Text(
                    'Try Again',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: widget.primaryCyan,
                    foregroundColor: Colors.black87,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 0,
                  ),
                ),
              ),
              const SizedBox(height: 14),

              // ── Need Help ──────────────────────────────────────────────
              GestureDetector(
                onTap: () {},
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.help_outline_rounded,
                        color: const Color(0xFFC5C6CD), size: 15),
                    const SizedBox(width: 6),
                    Text(
                      'Need Help?',
                      style: TextStyle(
                        color: const Color(0xFFC5C6CD),
                        fontSize: 13,
                        decoration: TextDecoration.underline,
                        decorationColor: const Color(0xFFC5C6CD),
                      ),
                    ),
                  ],
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
// Match Group Screen (multi-step)
// ─────────────────────────────────────────────────────────────────────────────
class MatchGroupScreen extends StatefulWidget {
  final Map<String, dynamic> roomData;
  final String roomCode;

  const MatchGroupScreen({
    super.key,
    required this.roomData,
    required this.roomCode,
  });

  @override
  State<MatchGroupScreen> createState() => _MatchGroupScreenState();
}

class _MatchGroupScreenState extends State<MatchGroupScreen> {
  final Color primaryCyan = const Color(0xFF3CD7FF);
  final Color mintGreen = const Color(0xFF42E38D);
  final Color darkBlueBg = const Color(0xFF041329);
  final Color cardBg = const Color(0xFF0A1F35);
  final Color borderColor = const Color(0xFF1A3A55);
  final Color textGrey = const Color(0xFFC5C6CD);

  int _step = 0; // 0 = time window, 1 = role selection

  // Step 0 — Time Window
  final Set<String> _selectedWindows = {'Morning'};

  // Step 1 — Role selection
  String? _primaryRole;
  String? _backupRole;

  bool _isLoading = false;

  List<String> get _roles =>
      List<String>.from(widget.roomData['roles'] as List);

  bool get _canNext {
    if (_step == 0) return _selectedWindows.isNotEmpty;
    if (_step == 1) return _primaryRole != null && _backupRole != null;
    return true;
  }

  void _next() {
    if (_step == 0) {
      setState(() => _step = 1);
    } else {
      _submit();
    }
  }

  Future<void> _submit() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 1200));
    setState(() => _isLoading = false);
    if (!mounted) return;
    _showSuccess();
  }

  void _showSuccess() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) =>
            _SuccessScreen(darkBlueBg: darkBlueBg, mintGreen: mintGreen),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkBlueBg,
      appBar: AppBar(
        backgroundColor: primaryCyan,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text(
          'Match Group',
          style: TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.bold,
              fontSize: 18),
        ),
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 250),
        transitionBuilder: (child, anim) => FadeTransition(
          opacity: anim,
          child: SlideTransition(
            position: Tween<Offset>(
                    begin: const Offset(0.04, 0), end: Offset.zero)
                .animate(anim),
            child: child,
          ),
        ),
        child: KeyedSubtree(
          key: ValueKey(_step),
          child: _step == 0
              ? _TimeWindowStep(
                  selected: _selectedWindows,
                  primaryCyan: primaryCyan,
                  darkBlueBg: darkBlueBg,
                  cardBg: cardBg,
                  borderColor: borderColor,
                  textGrey: textGrey,
                  onToggle: (w) => setState(() {
                    if (_selectedWindows.contains(w)) {
                      if (_selectedWindows.length > 1) {
                        _selectedWindows.remove(w);
                      }
                    } else {
                      if (_selectedWindows.length < 2) {
                        _selectedWindows.add(w);
                      }
                    }
                  }),
                )
              : _RoleStep(
                  roles: _roles,
                  primaryRole: _primaryRole,
                  backupRole: _backupRole,
                  primaryCyan: primaryCyan,
                  mintGreen: mintGreen,
                  cardBg: cardBg,
                  borderColor: borderColor,
                  textGrey: textGrey,
                  onPrimary: (r) => setState(() {
                    _primaryRole = r;
                    if (_backupRole == r) _backupRole = null;
                  }),
                  onBackup: (r) => setState(() {
                    _backupRole = r;
                    if (_primaryRole == r) _primaryRole = null;
                  }),
                ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.only(
          left: 24,
          right: 24,
          bottom: MediaQuery.of(context).padding.bottom + 16,
          top: 16,
        ),
        decoration: BoxDecoration(
          color: darkBlueBg,
          border: Border(top: BorderSide(color: borderColor)),
        ),
        child: Row(
          children: [
            GestureDetector(
              onTap: () {
                if (_step > 0) {
                  setState(() => _step--);
                } else {
                  Navigator.of(context).pop();
                }
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.chevron_left, color: textGrey, size: 20),
                  Text('Back',
                      style: TextStyle(color: textGrey, fontSize: 12)),
                ],
              ),
            ),
            const Spacer(),
            SizedBox(
              height: 52,
              child: ElevatedButton(
                onPressed: (_canNext && !_isLoading) ? _next : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryCyan,
                  foregroundColor: Colors.black87,
                  disabledBackgroundColor:
                      primaryCyan.withValues(alpha: 0.3),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                  padding: const EdgeInsets.symmetric(horizontal: 28),
                  elevation: 0,
                ),
                child: _isLoading
                    ? SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(darkBlueBg),
                        ),
                      )
                    : Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            _step == 1 ? 'Submit' : 'Next',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                          const SizedBox(width: 6),
                          const Icon(Icons.arrow_forward_rounded, size: 18),
                        ],
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Step 0 — Peak Kinetic Window
// ─────────────────────────────────────────────────────────────────────────────
class _TimeWindowStep extends StatelessWidget {
  final Set<String> selected;
  final Color primaryCyan, darkBlueBg, cardBg, borderColor, textGrey;
  final ValueChanged<String> onToggle;

  const _TimeWindowStep({
    required this.selected,
    required this.primaryCyan,
    required this.darkBlueBg,
    required this.cardBg,
    required this.borderColor,
    required this.textGrey,
    required this.onToggle,
  });

  static const _windows = [
    {'label': 'Morning', 'sub': '6AM - 12PM', 'icon': Icons.wb_sunny_outlined},
    {'label': 'Afternoon', 'sub': '12PM - 6PM', 'icon': Icons.wb_cloudy_outlined},
    {'label': 'Evening', 'sub': '6PM - 12AM', 'icon': Icons.nightlight_outlined},
    {'label': 'Flexible', 'sub': 'Variable', 'icon': Icons.all_inclusive_rounded},
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Peak Kinetic Window',
            style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Select up to 2 options to sync your deep work sessions.',
            style: TextStyle(color: textGrey, fontSize: 13, height: 1.5),
          ),
          const SizedBox(height: 28),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.1,
            children: _windows.map((w) {
              final label = w['label'] as String;
              final sub = w['sub'] as String;
              final icon = w['icon'] as IconData;
              final isSelected = selected.contains(label);
              return GestureDetector(
                onTap: () => onToggle(label),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? primaryCyan.withValues(alpha: 0.1)
                        : cardBg,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isSelected ? primaryCyan : borderColor,
                      width: isSelected ? 1.5 : 1,
                    ),
                  ),
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(icon,
                          color: isSelected ? primaryCyan : textGrey,
                          size: 26),
                      const Spacer(),
                      Text(
                        label,
                        style: TextStyle(
                          color:
                              isSelected ? primaryCyan : Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(sub,
                          style:
                              TextStyle(color: textGrey, fontSize: 11)),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: primaryCyan.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: primaryCyan.withValues(alpha: 0.15)),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: primaryCyan, size: 16),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Matching logic will prioritize users with overlapping windows for better real-time collaboration.',
                    style:
                        TextStyle(color: textGrey, fontSize: 12, height: 1.5),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Step 1 — Role Selection
// ─────────────────────────────────────────────────────────────────────────────
class _RoleStep extends StatelessWidget {
  final List<String> roles;
  final String? primaryRole, backupRole;
  final Color primaryCyan, mintGreen, cardBg, borderColor, textGrey;
  final ValueChanged<String> onPrimary, onBackup;

  const _RoleStep({
    required this.roles,
    required this.primaryRole,
    required this.backupRole,
    required this.primaryCyan,
    required this.mintGreen,
    required this.cardBg,
    required this.borderColor,
    required this.textGrey,
    required this.onPrimary,
    required this.onBackup,
  });

  static const _roleMeta = {
    'Front-end': {'sub': 'UI Implementation & UX Logic', 'icon': Icons.code_rounded},
    'Back-end': {'sub': 'Architecture & Data Systems', 'icon': Icons.storage_rounded},
    'UI/UX': {'sub': 'Visual Design & Prototypes', 'icon': Icons.palette_outlined},
    'DevOps': {'sub': 'CI/CD & Infrastructure', 'icon': Icons.settings_outlined},
    'Mobile': {'sub': 'iOS & Android Development', 'icon': Icons.phone_android_rounded},
  };

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'You must choose one main role and a backup role.',
            style: TextStyle(color: textGrey, fontSize: 14, height: 1.5),
          ),
          const SizedBox(height: 24),
          ...roles.map((role) {
            final meta = _roleMeta[role];
            final sub = meta?['sub'] as String? ?? '';
            final icon = meta?['icon'] as IconData? ?? Icons.work_outline;
            final isPrimary = primaryRole == role;
            final isBackup = backupRole == role;

            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: cardBg,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isPrimary || isBackup ? primaryCyan.withValues(alpha: 0.4) : borderColor,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: primaryCyan.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(icon, color: primaryCyan, size: 20),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(role,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15)),
                            Text(sub,
                                style: TextStyle(
                                    color: textGrey, fontSize: 11)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: _RoleToggleBtn(
                          label: 'Primary',
                          icon: Icons.star_rounded,
                          isSelected: isPrimary,
                          color: primaryCyan,
                          onTap: () => onPrimary(role),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _RoleToggleBtn(
                          label: 'Backup',
                          icon: Icons.backup_rounded,
                          isSelected: isBackup,
                          color: mintGreen,
                          onTap: () => onBackup(role),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _RoleToggleBtn extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final Color color;
  final VoidCallback onTap;

  const _RoleToggleBtn({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        height: 40,
        decoration: BoxDecoration(
          color: isSelected ? color.withValues(alpha: 0.15) : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? color : const Color(0xFF1A3A55),
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 14, color: isSelected ? color : const Color(0xFFC5C6CD)),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? color : const Color(0xFFC5C6CD),
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Success Screen (full page, bukan dialog)
// ─────────────────────────────────────────────────────────────────────────────
class _SuccessScreen extends StatefulWidget {
  final Color darkBlueBg, mintGreen;

  const _SuccessScreen({
    required this.darkBlueBg,
    required this.mintGreen,
  });

  @override
  State<_SuccessScreen> createState() => _SuccessScreenState();
}

class _SuccessScreenState extends State<_SuccessScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scale, _glow, _fade;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        duration: const Duration(milliseconds: 700), vsync: this);
    _scale = CurvedAnimation(parent: _ctrl, curve: Curves.elasticOut);
    _glow = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeIn);
    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.darkBlueBg,
      body: FadeTransition(
        opacity: _fade,
        child: Padding(
          padding: EdgeInsets.only(
            left: 32,
            right: 32,
            bottom: MediaQuery.of(context).padding.bottom + 32,
            top: MediaQuery.of(context).padding.top,
          ),
          child: Column(
            children: [
              const Spacer(flex: 3),
              AnimatedBuilder(
                animation: _ctrl,
                builder: (context, child) => Transform.scale(
                  scale: _scale.value,
                  child: Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.black,
                      boxShadow: [
                        BoxShadow(
                          color: widget.mintGreen
                              .withValues(alpha: 0.5 * _glow.value),
                          blurRadius: 40,
                          spreadRadius: 10,
                        ),
                      ],
                    ),
                    child: Icon(Icons.check_rounded,
                        color: widget.mintGreen, size: 44),
                  ),
                ),
              ),
              const SizedBox(height: 28),
              const Text(
                'Success',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.bold),
              ),
              const Spacer(flex: 3),
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      AppStrings.routeDashboard,
                      (route) => false,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        widget.mintGreen.withValues(alpha: 0.15),
                    foregroundColor: widget.mintGreen,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                      side: BorderSide(
                          color: widget.mintGreen.withValues(alpha: 0.3)),
                    ),
                    elevation: 0,
                  ),
                  child: const Text('OK',
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
}
