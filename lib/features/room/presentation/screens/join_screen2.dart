import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../domain/entities/room_entity.dart';
import '../bloc/room_bloc.dart';
import 'room_information_screen.dart';

class JoinScreen2 extends StatefulWidget {
  final Map<String, dynamic> preview;
  final String roomCode;

  /// Jika diisi (alur "create lalu owner ikut join"), setelah join sukses
  /// pengguna diarahkan langsung ke halaman detail room ini.
  final RoomEntity? createdRoom;

  const JoinScreen2({
    super.key,
    required this.preview,
    required this.roomCode,
    this.createdRoom,
  });

  @override
  State<JoinScreen2> createState() => _JoinScreen2State();
}

class _JoinScreen2State extends State<JoinScreen2> {
  // 0 = time window, 1 = work environment, 2 = role, 3 = success
  int _step = 0;

  final List<String> _timeOptions = [
    'morning',
    'afternoon',
    'evening',
    'flexible',
  ];
  final List<String> _selectedWindows = [];

  final List<String> _envOptions = [
    'private',
    'public',
    'online',
    'flexible',
  ];
  final List<String> _selectedEnvs = [];

  // Opsi konkret (selain 'flexible') untuk tiap preferensi.
  static const List<String> _timeConcrete = ['morning', 'afternoon', 'evening'];
  static const List<String> _envConcrete = ['private', 'public', 'online'];

  String? _primaryRole;
  final List<String> _backupRoles = [];

  List<String> get _availableRoles =>
      List<String>.from(widget.preview['roles'] ?? []);

  /// Toggle satu preferensi dengan aturan:
  /// - 'flexible' bersifat eksklusif (mengosongkan pilihan lain).
  /// - memilih ketiga opsi konkret sekaligus otomatis menjadi 'flexible'.
  void _togglePreference(
      List<String> selected, String opt, List<String> concrete) {
    setState(() {
      if (opt == 'flexible') {
        if (selected.contains('flexible')) {
          selected.clear();
        } else {
          selected
            ..clear()
            ..add('flexible');
        }
        return;
      }
      selected.remove('flexible');
      if (selected.contains(opt)) {
        selected.remove(opt);
      } else {
        selected.add(opt);
      }
      // Ketiga opsi konkret terpilih → kolaps menjadi 'flexible'.
      if (concrete.every(selected.contains)) {
        selected
          ..clear()
          ..add('flexible');
      }
    });
  }

  /// Setelah alur selesai: ke detail room (alur create) atau pop (join biasa).
  void _onFlowDone() {
    final room = widget.createdRoom;
    if (room != null) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => RoomInformationScreen(room: room)),
      );
    } else {
      Navigator.of(context).pop();
    }
  }

  void _submitJoin() {
    context.read<RoomBloc>().add(RoomJoinRequested(
          roomCode: widget.roomCode,
          primaryRole: _primaryRole,
          backupRoles: _backupRoles.isEmpty ? null : _backupRoles,
          productivityWindows:
              _selectedWindows.isEmpty ? null : _selectedWindows,
          environments: _selectedEnvs.isEmpty ? null : _selectedEnvs,
        ));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RoomBloc, RoomState>(
      listener: (context, state) {
        if (state is RoomJoined) {
          setState(() => _step = 3);
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
    } else if (_step == 1 || _step == 2) {
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
        return _PreferenceGridStep(
          title: 'Peak Kinetic Window',
          options: _timeOptions,
          labels: _PreferenceGridStep.timeLabels,
          subtitles: _PreferenceGridStep.timeSubtitles,
          icons: _PreferenceGridStep.timeIcons,
          infoText:
              'Matching logic will prioritize users with overlapping windows for better real-time collaboration.',
          selected: _selectedWindows,
          onToggle: (val) =>
              _togglePreference(_selectedWindows, val, _timeConcrete),
          onNext: () => setState(() => _step = 1),
          onBack: () => Navigator.of(context).maybePop(),
        );
      case 1:
        return _PreferenceGridStep(
          title: 'Work Environment',
          options: _envOptions,
          labels: _PreferenceGridStep.envLabels,
          subtitles: _PreferenceGridStep.envSubtitles,
          icons: _PreferenceGridStep.envIcons,
          infoText:
              'We match you with people who prefer a similar working environment.',
          selected: _selectedEnvs,
          onToggle: (val) =>
              _togglePreference(_selectedEnvs, val, _envConcrete),
          onNext: () => setState(() => _step = 2),
          onBack: () => setState(() => _step = 0),
        );
      case 2:
        return _RoleStep(
          roles: _availableRoles,
          primaryRole: _primaryRole,
          backupRoles: _backupRoles,
          onPrimaryChanged: (v) => setState(() {
            _primaryRole = v;
            if (v != null) _backupRoles.remove(v);
          }),
          onBackupToggle: (role) => setState(() {
            if (_backupRoles.contains(role)) {
              _backupRoles.remove(role);
            } else {
              _backupRoles.add(role);
            }
          }),
          onSubmit: _submitJoin,
          onBack: () => setState(() => _step = 1),
        );
      case 3:
        return _SuccessStep(
          roomName: widget.preview['project_theme'] ?? '',
          onDone: _onFlowDone,
        );
      default:
        return const SizedBox.shrink();
    }
  }
}

// ── Preference Grid (Time Windows / Work Environment) ───────────────────────────
class _PreferenceGridStep extends StatelessWidget {
  final String title;
  final List<String> options, selected;
  final Map<String, String> labels, subtitles;
  final Map<String, IconData> icons;
  final String infoText;
  final ValueChanged<String> onToggle;
  final VoidCallback onNext;
  final VoidCallback onBack;

  const _PreferenceGridStep({
    required this.title,
    required this.options,
    required this.selected,
    required this.labels,
    required this.subtitles,
    required this.icons,
    required this.infoText,
    required this.onToggle,
    required this.onNext,
    required this.onBack,
  });

  // ── Time window config ──
  static const Map<String, String> timeLabels = {
    'morning': 'Morning',
    'afternoon': 'Afternoon',
    'evening': 'Evening',
    'flexible': 'Flexible',
  };
  static const Map<String, String> timeSubtitles = {
    'morning': '6AM - 12PM',
    'afternoon': '12PM - 6PM',
    'evening': '6PM - 12AM',
    'flexible': 'Variable',
  };
  static const Map<String, IconData> timeIcons = {
    'morning': Icons.wb_sunny_outlined,
    'afternoon': Icons.wb_cloudy_outlined,
    'evening': Icons.nights_stay_outlined,
    'flexible': Icons.all_inclusive_outlined,
  };

  // ── Work environment config ──
  static const Map<String, String> envLabels = {
    'private': 'Private',
    'public': 'Public',
    'online': 'Online',
    'flexible': 'Flexible',
  };
  static const Map<String, String> envSubtitles = {
    'private': 'Tatap muka privat',
    'public': 'Ruang publik',
    'online': 'Remote / daring',
    'flexible': 'Apa saja',
  };
  static const Map<String, IconData> envIcons = {
    'private': Icons.lock_outline,
    'public': Icons.groups_outlined,
    'online': Icons.cloud_outlined,
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
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                RichText(
                  text: TextSpan(
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.4),
                      fontSize: 14,
                      height: 1.5,
                    ),
                    children: const [
                      TextSpan(
                          text:
                              'Pilih hingga 2 preferensi. Pilih ketiganya untuk otomatis jadi '),
                      TextSpan(
                        text: 'Flexible',
                        style: TextStyle(
                            color: Color(0xFF7C9EFF),
                            fontWeight: FontWeight.w700),
                      ),
                      TextSpan(text: '.'),
                    ],
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
                                        .withValues(alpha: 0.35),
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
                              icons[opt],
                              color: isSelected
                                  ? const Color(0xFF0D1B3E)
                                  : Colors.white.withValues(alpha: 0.4),
                              size: 32,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              labels[opt] ?? opt,
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
                              subtitles[opt] ?? '',
                              style: TextStyle(
                                color: isSelected
                                    ? const Color(0xFF0D1B3E).withValues(alpha: 0.65)
                                    : Colors.white.withValues(alpha: 0.3),
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
                          infoText,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.4),
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
                    size: 14, color: Colors.white.withValues(alpha: 0.4)),
                label: Text(
                  'Back',
                  style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.4), fontSize: 14),
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
  final String? primaryRole;
  final List<String> backupRoles;
  final ValueChanged<String?> onPrimaryChanged;
  final ValueChanged<String> onBackupToggle;
  final VoidCallback onSubmit;
  final VoidCallback onBack;

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
    required this.backupRoles,
    required this.onPrimaryChanged,
    required this.onBackupToggle,
    required this.onSubmit,
    required this.onBack,
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
                  'Pilih satu primary role dan boleh lebih dari satu backup role.',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.4),
                    fontSize: 14,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 20),
                // ── Role cards ──
                ...roles.map((role) {
                  final isPrimary = primaryRole == role;
                  final isBackup = backupRoles.contains(role);
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
                                      ? const Color(0xFF7C9EFF).withValues(alpha: 0.15)
                                      : isBackup
                                          ? const Color(0xFF4ADE80).withValues(alpha: 0.15)
                                          : AppColors.borderColor.withValues(alpha: 0.3),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Icon(
                                  icon,
                                  color: isPrimary
                                      ? const Color(0xFF7C9EFF)
                                      : isBackup
                                          ? const Color(0xFF4ADE80)
                                          : Colors.white.withValues(alpha: 0.4),
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
                                          color: Colors.white.withValues(alpha: 0.4),
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
                                                : Colors.white.withValues(alpha: 0.4),
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
                                    onBackupToggle(role);
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
                                                : Colors.white.withValues(alpha: 0.4),
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
                onPressed: onBack,
                icon: Icon(Icons.arrow_back_ios_new_rounded,
                    size: 14, color: Colors.white.withValues(alpha: 0.4)),
                label: Text(
                  'Back',
                  style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.4), fontSize: 14),
                ),
              ),
              SizedBox(
                height: 48,
                child: BlocBuilder<RoomBloc, RoomState>(
                  builder: (context, state) {
                    final isLoading = state is RoomLoading;
                    final canSubmit = primaryRole != null && !isLoading;
                    return ElevatedButton(
                      onPressed: canSubmit ? onSubmit : null,
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
                              ? const Color(0xFF3B5FD9).withValues(alpha: 0.3)
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
                        color: const Color(0xFF4ADE80).withValues(alpha: 0.5),
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
                  color: Colors.white.withValues(alpha: 0.4),
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