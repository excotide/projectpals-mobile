import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../bloc/room_bloc.dart';

class JoinScreen2 extends StatefulWidget {
  final Map<String, dynamic> preview;
  final String roomCode;

  const JoinScreen2({
    super.key,
    required this.preview,
    required this.roomCode,
  });

  @override
  State<JoinScreen2> createState() => _JoinScreen2State();
}

class _JoinScreen2State extends State<JoinScreen2> {
  int _step = 0; // 0 = time window, 1 = role, 2 = success

  final List<String> _timeOptions = [
    'morning',
    'afternoon',
    'evening',
    'flexible',
  ];
  final List<String> _selectedWindows = [];

  String? _primaryRole;
  String? _backupRole;

  List<String> get _availableRoles =>
      List<String>.from(widget.preview['roles'] ?? []);

  void _submitJoin() {
    context.read<RoomBloc>().add(RoomJoinRequested(
          roomCode: widget.roomCode,
          primaryRole: _primaryRole,
          backupRole: _backupRole,
          productivityWindows:
              _selectedWindows.isEmpty ? null : _selectedWindows,
        ));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RoomBloc, RoomState>(
      listener: (context, state) {
        if (state is RoomJoined) {
          setState(() => _step = 2);
        } else if (state is RoomFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.red,
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.darkBlueBg,
        appBar: _buildAppBar(),
        body: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: KeyedSubtree(
            key: ValueKey(_step),
            child: _buildStep(),
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    if (_step == 0) {
      return AppBar(
        backgroundColor: AppColors.darkBlueBg,
        elevation: 0,
        automaticallyImplyLeading: false,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFB8CDFF), Color(0xFF3B5FD9)],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
        ),
        title: const Text(
          'Match Group',
          style: TextStyle(
            color: Color(0xFF0D1B3E),
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      );
    } else if (_step == 1) {
      return AppBar(
        backgroundColor: AppColors.darkBlueBg,
        elevation: 0,
        automaticallyImplyLeading: false,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFB8CDFF), Color(0xFF3B5FD9)],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
        ),
        title: const Text(
          'Match Group',
          style: TextStyle(
            color: Color(0xFF0D1B3E),
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      );
    } else {
      return AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text(
          'Joined!',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      );
    }
  }

  Widget _buildStep() {
    switch (_step) {
      case 0:
        return _TimeWindowStep(
          options: _timeOptions,
          selected: _selectedWindows,
          roomName: widget.preview['project_theme'] ?? '',
          onToggle: (val) {
            setState(() {
              if (_selectedWindows.contains(val)) {
                _selectedWindows.remove(val);
              } else if (_selectedWindows.length < 2) {
                _selectedWindows.add(val);
              }
            });
          },
          onNext: () => setState(() => _step = 1),
          onBack: () => Navigator.of(context).maybePop(),
        );
      case 1:
        return _RoleStep(
          roles: _availableRoles,
          primaryRole: _primaryRole,
          backupRole: _backupRole,
          onPrimaryChanged: (v) => setState(() => _primaryRole = v),
          onBackupChanged: (v) => setState(() => _backupRole = v),
          onSubmit: _submitJoin,
          onNext: () => setState(() => _step = 2),
        );
      case 2:
        return _SuccessStep(
          roomName: widget.preview['project_theme'] ?? '',
          onDone: () => Navigator.of(context).pop(),
        );
      default:
        return const SizedBox.shrink();
    }
  }
}

// ── Time Windows ───────────────────────────────────────────────────────────────
class _TimeWindowStep extends StatelessWidget {
  final List<String> options, selected;
  final String roomName;
  final ValueChanged<String> onToggle;
  final VoidCallback onNext;
  final VoidCallback onBack;

  const _TimeWindowStep({
    required this.options,
    required this.selected,
    required this.roomName,
    required this.onToggle,
    required this.onNext,
    required this.onBack,
  });

  static const Map<String, String> _labels = {
    'morning': 'Morning',
    'afternoon': 'Afternoon',
    'evening': 'Evening',
    'flexible': 'Flexible',
  };

  static const Map<String, String> _subtitles = {
    'morning': '6AM - 12PM',
    'afternoon': '12PM - 6PM',
    'evening': '6PM - 12AM',
    'flexible': 'Variable',
  };

  static const Map<String, IconData> _icons = {
    'morning': Icons.wb_sunny_outlined,
    'afternoon': Icons.wb_cloudy_outlined,
    'evening': Icons.nights_stay_outlined,
    'flexible': Icons.all_inclusive_outlined,
  };

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 28, 20, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Peak Kinetic Window',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Select up to 2 options to sync your deep work sessions.',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.4),
                    fontSize: 14,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 28),
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.05,
                  children: options.map((opt) {
                    final isSelected = selected.contains(opt);
                    return GestureDetector(
                      onTap: () => onToggle(opt),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        decoration: BoxDecoration(
                          gradient: isSelected
                              ? const LinearGradient(
                                  colors: [Color(0xFFB8CDFF), Color(0xFF3B5FD9)],
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                )
                              : null,
                          color: isSelected ? null : AppColors.cardBg,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isSelected
                                ? Colors.transparent
                                : AppColors.borderColor,
                            width: isSelected ? 0 : 1,
                          ),
                          boxShadow: isSelected
                              ? [
                                  BoxShadow(
                                    color: const Color(0xFF3B5FD9)
                                        .withOpacity(0.35),
                                    blurRadius: 12,
                                    offset: const Offset(0, 4),
                                  ),
                                ]
                              : null,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              _icons[opt],
                              color: isSelected
                                  ? const Color(0xFF0D1B3E)
                                  : Colors.white.withOpacity(0.4),
                              size: 32,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              _labels[opt] ?? opt,
                              style: TextStyle(
                                color: isSelected
                                    ? const Color(0xFF0D1B3E)
                                    : Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _subtitles[opt] ?? '',
                              style: TextStyle(
                                color: isSelected
                                    ? const Color(0xFF0D1B3E).withOpacity(0.65)
                                    : Colors.white.withOpacity(0.3),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.cardBg,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.borderColor),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.info_outline,
                          color: Color(0xFF7C9EFF), size: 18),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Matching logic will prioritize users with overlapping windows for better real-time collaboration.',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.4),
                            fontSize: 12,
                            height: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
        // ── Bottom Bar ──
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          decoration: BoxDecoration(
            color: AppColors.darkBlueBg,
            border: Border(
              top: BorderSide(color: AppColors.borderColor, width: 1),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton.icon(
                onPressed: onBack,
                icon: Icon(Icons.arrow_back_ios_new_rounded,
                    size: 14, color: Colors.white.withOpacity(0.4)),
                label: Text(
                  'Back',
                  style: TextStyle(
                      color: Colors.white.withOpacity(0.4), fontSize: 14),
                ),
              ),
              SizedBox(
                height: 48,
                child: ElevatedButton(
                  onPressed: onNext,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24)),
                    elevation: 0,
                    padding: EdgeInsets.zero,
                  ),
                  child: Ink(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFB8CDFF), Color(0xFF3B5FD9)],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 28, vertical: 13),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Next',
                            style: TextStyle(
                              color: Color(0xFF0D1B3E),
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 6),
                          Icon(Icons.arrow_forward_ios_rounded,
                              size: 14, color: Color(0xFF0D1B3E)),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ── Role Selection ─────────────────────────────────────────────────────────────
class _RoleStep extends StatelessWidget {
  final List<String> roles;
  final String? primaryRole, backupRole;
  final ValueChanged<String?> onPrimaryChanged, onBackupChanged;
  final VoidCallback onSubmit;
  final VoidCallback onNext;

  static const Map<String, IconData> _roleIcons = {
    'Frontend Developer': Icons.desktop_mac_outlined,
    'Backend Developer': Icons.storage_outlined,
    'UI/UX Designer': Icons.palette_outlined,
    'Project Manager': Icons.manage_accounts_outlined,
    'Mobile Developer': Icons.phone_android_outlined,
    'DevOps': Icons.cloud_outlined,
    'Data Scientist': Icons.bar_chart_outlined,
    'QA Engineer': Icons.bug_report_outlined,
  };

  static const Map<String, String> _roleSubtitles = {
    'Frontend Developer': 'UI Implementation & UX Logic',
    'Backend Developer': 'Architecture & Data Systems',
    'UI/UX Designer': 'Visual Design & Prototypes',
    'Project Manager': 'Planning & Team Coordination',
    'Mobile Developer': 'iOS & Android Development',
    'DevOps': 'Infrastructure & Deployment',
    'Data Scientist': 'Analytics & ML Models',
    'QA Engineer': 'Testing & Quality Assurance',
  };

  const _RoleStep({
    required this.roles,
    required this.primaryRole,
    required this.backupRole,
    required this.onPrimaryChanged,
    required this.onBackupChanged,
    required this.onSubmit,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'You must choose one main role and a backup role.',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.4),
                    fontSize: 14,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 20),
                // ── Role cards ──
                ...roles.map((role) {
                  final isPrimary = primaryRole == role;
                  final isBackup = backupRole == role;
                  final icon = _roleIcons[role] ?? Icons.person_outline;
                  final subtitle = _roleSubtitles[role] ?? '';

                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: AppColors.cardBg,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: isPrimary
                            ? const Color(0xFF7C9EFF)
                            : isBackup
                                ? const Color(0xFF4ADE80)
                                : AppColors.borderColor,
                        width: (isPrimary || isBackup) ? 1.5 : 1,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // ── Baris atas: icon + judul + subtitle ──
                          Row(
                            children: [
                              Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  color: isPrimary
                                      ? const Color(0xFF7C9EFF).withOpacity(0.15)
                                      : isBackup
                                          ? const Color(0xFF4ADE80).withOpacity(0.15)
                                          : AppColors.borderColor.withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Icon(
                                  icon,
                                  color: isPrimary
                                      ? const Color(0xFF7C9EFF)
                                      : isBackup
                                          ? const Color(0xFF4ADE80)
                                          : Colors.white.withOpacity(0.4),
                                  size: 22,
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      role,
                                      style: TextStyle(
                                        color: isPrimary
                                            ? const Color(0xFF7C9EFF)
                                            : isBackup
                                                ? const Color(0xFF4ADE80)
                                                : Colors.white,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    if (subtitle.isNotEmpty) ...[
                                      const SizedBox(height: 3),
                                      Text(
                                        subtitle,
                                        style: TextStyle(
                                          color: Colors.white.withOpacity(0.4),
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          // ── Baris bawah: tombol Primary | Backup ──
                          Row(
                            children: [
                              // Primary button
                              Expanded(
                                child: GestureDetector(
                                  onTap: () => onPrimaryChanged(
                                      isPrimary ? null : role),
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 180),
                                    height: 38,
                                    decoration: BoxDecoration(
                                      gradient: isPrimary
                                          ? const LinearGradient(
                                              colors: [
                                                Color(0xFFB8CDFF),
                                                Color(0xFF3B5FD9),
                                              ],
                                              begin: Alignment.centerLeft,
                                              end: Alignment.centerRight,
                                            )
                                          : null,
                                      color: isPrimary ? null : AppColors.darkBlueBg,
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(8),
                                        bottomLeft: Radius.circular(8),
                                      ),
                                      border: Border.all(
                                        color: isPrimary
                                            ? Colors.transparent
                                            : AppColors.borderColor,
                                        width: 1,
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        if (isPrimary)
                                          const Padding(
                                            padding: EdgeInsets.only(right: 5),
                                            child: Icon(
                                              Icons.check_circle,
                                              color: Color(0xFF0D1B3E),
                                              size: 14,
                                            ),
                                          ),
                                        Text(
                                          'Primary',
                                          style: TextStyle(
                                            color: isPrimary
                                                ? const Color(0xFF0D1B3E)
                                                : Colors.white.withOpacity(0.4),
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              // Backup button
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    if (role == primaryRole) return;
                                    onBackupChanged(isBackup ? null : role);
                                  },
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 180),
                                    height: 38,
                                    decoration: BoxDecoration(
                                      color: isBackup
                                          ? const Color(0xFF4ADE80)
                                          : AppColors.darkBlueBg,
                                      borderRadius: const BorderRadius.only(
                                        topRight: Radius.circular(8),
                                        bottomRight: Radius.circular(8),
                                      ),
                                      border: Border.all(
                                        color: isBackup
                                            ? const Color(0xFF4ADE80)
                                            : AppColors.borderColor,
                                        width: 1,
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        if (isBackup)
                                          const Padding(
                                            padding: EdgeInsets.only(right: 5),
                                            child: Icon(
                                              Icons.check_circle,
                                              color: Color(0xFF0D1B3E),
                                              size: 14,
                                            ),
                                          ),
                                        Text(
                                          'Backup',
                                          style: TextStyle(
                                            color: isBackup
                                                ? const Color(0xFF0D1B3E)
                                                : Colors.white.withOpacity(0.4),
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                }),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
        // ── Bottom Bar ──
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          decoration: BoxDecoration(
            color: AppColors.darkBlueBg,
            border: Border(
              top: BorderSide(color: AppColors.borderColor, width: 1),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton.icon(
                onPressed: () {},
                icon: Icon(Icons.arrow_back_ios_new_rounded,
                    size: 14, color: Colors.white.withOpacity(0.4)),
                label: Text(
                  'Back',
                  style: TextStyle(
                      color: Colors.white.withOpacity(0.4), fontSize: 14),
                ),
              ),
              SizedBox(
                height: 48,
                child: BlocBuilder<RoomBloc, RoomState>(
                  builder: (context, state) {
                    final isLoading = state is RoomLoading;
                    return ElevatedButton(
                      onPressed: isLoading ? null : onNext,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24)),
                        elevation: 0,
                        padding: EdgeInsets.zero,
                      ),
                      child: Ink(
                        decoration: BoxDecoration(
                          gradient: isLoading
                              ? null
                              : const LinearGradient(
                                  colors: [Color(0xFFB8CDFF), Color(0xFF3B5FD9)],
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                ),
                          color: isLoading
                              ? const Color(0xFF3B5FD9).withOpacity(0.3)
                              : null,
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 28, vertical: 13),
                          child: isLoading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Color(0xFF0D1B3E)),
                                )
                              : const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      'Next',
                                      style: TextStyle(
                                        color: Color(0xFF0D1B3E),
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(width: 6),
                                    Icon(Icons.arrow_forward_ios_rounded,
                                        size: 14, color: Color(0xFF0D1B3E)),
                                  ],
                                ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ── Success ────────────────────────────────────────────────────────────────────
class _SuccessStep extends StatefulWidget {
  final String roomName;
  final VoidCallback onDone;

  const _SuccessStep({required this.roomName, required this.onDone});

  @override
  State<_SuccessStep> createState() => _SuccessStepState();
}

class _SuccessStepState extends State<_SuccessStep>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        duration: const Duration(milliseconds: 700), vsync: this);
    _scale = CurvedAnimation(parent: _ctrl, curve: Curves.elasticOut);
    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedBuilder(
              animation: _ctrl,
              builder: (context, _) => Transform.scale(
                scale: _scale.value,
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.cardBg,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF4ADE80).withOpacity(0.5),
                        blurRadius: 40,
                        spreadRadius: 10,
                      ),
                    ],
                  ),
                  child: const Icon(Icons.check_rounded,
                      color: Color(0xFF4ADE80), size: 50),
                ),
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              'Welcome Aboard!',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text(
              'You have successfully joined ${widget.roomName}.',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white.withOpacity(0.4),
                  fontSize: 15,
                  height: 1.5),
            ),
            const SizedBox(height: 48),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: widget.onDone,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  elevation: 0,
                  padding: EdgeInsets.zero,
                ),
                child: Ink(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFB8CDFF), Color(0xFF3B5FD9)],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Container(
                    alignment: Alignment.center,
                    child: const Text(
                      'Go to My Rooms',
                      style: TextStyle(
                        color: Color(0xFF0D1B3E),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}