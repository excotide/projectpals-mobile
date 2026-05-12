import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../bloc/room_bloc.dart';

class JoinRoomScreen extends StatefulWidget {
  const JoinRoomScreen({super.key});

  @override
  State<JoinRoomScreen> createState() => _JoinRoomScreenState();
}

class _JoinRoomScreenState extends State<JoinRoomScreen> {
  // 0=enter code, 1=time windows, 2=role selection, 3=success
  int _step = 0;

  final _codeCtrl = TextEditingController();
  Map<String, dynamic>? _preview;

  final List<String> _timeOptions = [
    'morning', 'afternoon', 'evening', 'flexible'
  ];
  final List<String> _selectedWindows = [];

  String? _primaryRole;
  String? _backupRole;

  List<String> get _availableRoles =>
      List<String>.from(_preview?['roles'] ?? []);

  @override
  void dispose() {
    _codeCtrl.dispose();
    super.dispose();
  }

  void _validateCode() {
    final code = _codeCtrl.text.trim().toUpperCase();
    if (code.isEmpty) return;
    context.read<RoomBloc>().add(RoomPreviewRequested(code));
  }

  void _submitJoin() {
    final code = _codeCtrl.text.trim().toUpperCase();
    context.read<RoomBloc>().add(RoomJoinRequested(
          roomCode: code,
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
        if (state is RoomPreviewLoaded) {
          setState(() {
            _preview = state.preview;
            _step = 1;
          });
        } else if (state is RoomJoined) {
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
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: _step < 3
              ? IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new_rounded,
                      color: AppColors.primaryCyan, size: 18),
                  onPressed: () {
                    if (_step > 0) {
                      setState(() => _step--);
                    } else {
                      Navigator.of(context).maybePop();
                    }
                  },
                )
              : null,
          title: Text(
            _step == 0
                ? 'Join Room'
                : _step == 1
                    ? 'Productivity Windows'
                    : _step == 2
                        ? 'Select Role'
                        : 'Joined!',
            style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18),
          ),
          centerTitle: true,
        ),
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

  Widget _buildStep() {
    switch (_step) {
      case 0:
        return _EnterCodeStep(
          controller: _codeCtrl,
          onValidate: _validateCode,
        );
      case 1:
        return _TimeWindowStep(
          options: _timeOptions,
          selected: _selectedWindows,
          roomName: _preview?['project_theme'] ?? '',
          onToggle: (val) {
            setState(() {
              if (_selectedWindows.contains(val)) {
                _selectedWindows.remove(val);
              } else if (_selectedWindows.length < 2) {
                _selectedWindows.add(val);
              }
            });
          },
          onNext: () => setState(() => _step = 2),
        );
      case 2:
        return _RoleStep(
          roles: _availableRoles,
          primaryRole: _primaryRole,
          backupRole: _backupRole,
          onPrimaryChanged: (v) => setState(() => _primaryRole = v),
          onBackupChanged: (v) => setState(() => _backupRole = v),
          onSubmit: _submitJoin,
        );
      case 3:
        return _SuccessStep(
          roomName: _preview?['project_theme'] ?? '',
          onDone: () => Navigator.of(context).pop(),
        );
      default:
        return const SizedBox.shrink();
    }
  }
}

// ── Enter Code ─────────────────────────────────────────────────────────────────
class _EnterCodeStep extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onValidate;
  const _EnterCodeStep({required this.controller, required this.onValidate});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Enter Room Code',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          const Text('Ask the room owner for their 6-character code.',
              style: TextStyle(
                  color: AppColors.textGrey, fontSize: 14, height: 1.5)),
          const SizedBox(height: 40),
          TextField(
            controller: controller,
            textCapitalization: TextCapitalization.characters,
            style: const TextStyle(
                color: Colors.white, fontSize: 24, letterSpacing: 4),
            decoration: InputDecoration(
              hintText: 'ABC123',
              hintStyle: const TextStyle(color: Colors.white24, fontSize: 24),
              filled: true,
              fillColor: AppColors.inputBg,
              contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20, vertical: 20),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: AppColors.borderColor),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide:
                    const BorderSide(color: AppColors.primaryCyan),
              ),
            ),
          ),
          const SizedBox(height: 32),
          BlocBuilder<RoomBloc, RoomState>(
            builder: (context, state) {
              final isLoading = state is RoomLoading;
              return SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: isLoading ? null : onValidate,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryCyan,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    elevation: 0,
                  ),
                  child: isLoading
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: Color(0xFF003642)))
                      : const Text('Continue',
                          style: TextStyle(
                              color: Color(0xFF003642),
                              fontSize: 16,
                              fontWeight: FontWeight.bold)),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

// ── Time Windows ───────────────────────────────────────────────────────────────
class _TimeWindowStep extends StatelessWidget {
  final List<String> options, selected;
  final String roomName;
  final ValueChanged<String> onToggle;
  final VoidCallback onNext;
  const _TimeWindowStep(
      {required this.options,
      required this.selected,
      required this.roomName,
      required this.onToggle,
      required this.onNext});

  static const Map<String, String> _labels = {
    'morning': 'Morning',
    'afternoon': 'Afternoon',
    'evening': 'Evening',
    'flexible': 'Flexible',
  };
  static const Map<String, IconData> _icons = {
    'morning': Icons.wb_sunny_outlined,
    'afternoon': Icons.wb_cloudy_outlined,
    'evening': Icons.nights_stay_outlined,
    'flexible': Icons.schedule_outlined,
  };

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Joining: $roomName',
              style: const TextStyle(
                  color: AppColors.primaryCyan,
                  fontSize: 13,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const Text('Peak Kinetic Window',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const Text(
              'Select up to 2 time windows when you are most productive.',
              style: TextStyle(
                  color: AppColors.textGrey, fontSize: 14, height: 1.5)),
          const SizedBox(height: 32),
          ...options.map((opt) {
            final isSelected = selected.contains(opt);
            return GestureDetector(
              onTap: () => onToggle(opt),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primaryCyan.withValues(alpha: 0.1)
                      : AppColors.cardBg,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: isSelected
                        ? AppColors.primaryCyan
                        : AppColors.borderColor,
                    width: isSelected ? 1.5 : 1,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(_icons[opt],
                        color: isSelected
                            ? AppColors.primaryCyan
                            : AppColors.textGrey,
                        size: 22),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Text(_labels[opt] ?? opt,
                          style: TextStyle(
                              color: isSelected
                                  ? AppColors.primaryCyan
                                  : Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600)),
                    ),
                    if (isSelected)
                      const Icon(Icons.check_circle,
                          color: AppColors.primaryCyan, size: 20),
                  ],
                ),
              ),
            );
          }),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: onNext,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryCyan,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                elevation: 0,
              ),
              child: const Text('Next',
                  style: TextStyle(
                      color: Color(0xFF003642),
                      fontSize: 16,
                      fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Role Selection ─────────────────────────────────────────────────────────────
class _RoleStep extends StatelessWidget {
  final List<String> roles;
  final String? primaryRole, backupRole;
  final ValueChanged<String?> onPrimaryChanged, onBackupChanged;
  final VoidCallback onSubmit;
  const _RoleStep(
      {required this.roles,
      required this.primaryRole,
      required this.backupRole,
      required this.onPrimaryChanged,
      required this.onBackupChanged,
      required this.onSubmit});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Select Your Role',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const Text(
              'Choose a primary role and optionally a backup role.',
              style: TextStyle(
                  color: AppColors.textGrey, fontSize: 14, height: 1.5)),
          const SizedBox(height: 28),
          const Text('PRIMARY ROLE',
              style: TextStyle(
                  color: AppColors.primaryCyan,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5)),
          const SizedBox(height: 10),
          ...roles.map((role) {
            final isSelected = primaryRole == role;
            return GestureDetector(
              onTap: () => onPrimaryChanged(isSelected ? null : role),
              child: _roleItem(role, isSelected, AppColors.primaryCyan),
            );
          }),
          if (primaryRole != null) ...[
            const SizedBox(height: 24),
            const Text('BACKUP ROLE (OPTIONAL)',
                style: TextStyle(
                    color: AppColors.mintGreen,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5)),
            const SizedBox(height: 10),
            ...roles.where((r) => r != primaryRole).map((role) {
              final isSelected = backupRole == role;
              return GestureDetector(
                onTap: () => onBackupChanged(isSelected ? null : role),
                child: _roleItem(role, isSelected, AppColors.mintGreen),
              );
            }),
          ],
          const SizedBox(height: 32),
          BlocBuilder<RoomBloc, RoomState>(
            builder: (context, state) {
              final isLoading = state is RoomLoading;
              return SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: isLoading ? null : onSubmit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryCyan,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    elevation: 0,
                  ),
                  child: isLoading
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: Color(0xFF003642)))
                      : const Text('Join Room',
                          style: TextStyle(
                              color: Color(0xFF003642),
                              fontSize: 16,
                              fontWeight: FontWeight.bold)),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _roleItem(String role, bool isSelected, Color color) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: isSelected ? color.withValues(alpha: 0.1) : AppColors.cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected ? color : AppColors.borderColor,
          width: isSelected ? 1.5 : 1,
        ),
      ),
      child: Row(
        children: [
          Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                  color: isSelected ? color : AppColors.textGrey,
                  shape: BoxShape.circle)),
          const SizedBox(width: 12),
          Expanded(
              child: Text(role,
                  style: TextStyle(
                      color: isSelected ? color : Colors.white,
                      fontSize: 15))),
          if (isSelected) Icon(Icons.check_circle, color: color, size: 18),
        ],
      ),
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
                    color: Colors.black,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.mintGreen.withValues(alpha: 0.5),
                        blurRadius: 40,
                        spreadRadius: 10,
                      ),
                    ],
                  ),
                  child: const Icon(Icons.check_rounded,
                      color: AppColors.mintGreen, size: 50),
                ),
              ),
            ),
            const SizedBox(height: 32),
            const Text('Welcome Aboard!',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Text(
              'You have successfully joined ${widget.roomName}.',
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: AppColors.textGrey, fontSize: 15, height: 1.5),
            ),
            const SizedBox(height: 48),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: widget.onDone,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.mintGreen,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  elevation: 0,
                ),
                child: const Text('Go to My Rooms',
                    style: TextStyle(
                        color: Color(0xFF003642),
                        fontSize: 16,
                        fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
