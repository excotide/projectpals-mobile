import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../bloc/room_bloc.dart';

class CreateRoomScreen extends StatefulWidget {
  const CreateRoomScreen({super.key});

  @override
  State<CreateRoomScreen> createState() => _CreateRoomScreenState();
}

class _CreateRoomScreenState extends State<CreateRoomScreen> {
  int _currentStep = 0;
  final int _totalSteps = 3;

  final _roomNameCtrl = TextEditingController();
  final _roleCtrl = TextEditingController();
  final List<String> _roles = [];
  int _maxPeoplePerGroup = 2;
  int _numberOfGroups = 2;

  double get _progress => (_currentStep + 1) / _totalSteps;
  String get _progressLabel =>
      '${((_progress) * 100).round()}% Complete';
  String get _stepLabel =>
      'STEP ${(_currentStep + 1).toString().padLeft(2, '0')} / ${_totalSteps.toString().padLeft(2, '0')}';

  bool get _canNext {
    switch (_currentStep) {
      case 0:
        return _roomNameCtrl.text.trim().isNotEmpty;
      case 1:
        return _roles.length >= 2;
      default:
        return true;
    }
  }

  void _next() {
    if (_currentStep < _totalSteps - 1) {
      setState(() => _currentStep++);
    } else {
      context.read<RoomBloc>().add(RoomCreateRequested(
            projectTheme: _roomNameCtrl.text.trim(),
            roles: _roles,
            maxPerGroup: _maxPeoplePerGroup,
            numberOfGroups: _numberOfGroups,
            environments: ['flexible'],
          ));
    }
  }

  void _back() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
    } else {
      Navigator.of(context).maybePop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RoomBloc, RoomState>(
      listener: (context, state) {
        if (state is RoomCreated) {
          _showSuccessDialog(state.room.roomCode);
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
          backgroundColor: AppColors.primaryCyan,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.close, color: Colors.black87),
            onPressed: () => Navigator.of(context).maybePop(),
          ),
          title: const Text('Create Room',
              style: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                  fontSize: 18)),
        ),
        body: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 24, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(_stepLabel,
                            style: const TextStyle(
                                color: AppColors.primaryCyan,
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1.5)),
                        Text(_progressLabel,
                            style: const TextStyle(
                                color: AppColors.textGrey, fontSize: 12)),
                      ],
                    ),
                    const SizedBox(height: 10),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: _progress,
                        backgroundColor: AppColors.borderColor,
                        valueColor: const AlwaysStoppedAnimation<Color>(
                            AppColors.primaryCyan),
                        minHeight: 4,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  transitionBuilder: (child, anim) => FadeTransition(
                    opacity: anim,
                    child: SlideTransition(
                      position: Tween<Offset>(
                              begin: const Offset(0.05, 0),
                              end: Offset.zero)
                          .animate(anim),
                      child: child,
                    ),
                  ),
                  child: KeyedSubtree(
                    key: ValueKey(_currentStep),
                    child: _buildStepContent(),
                  ),
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: Container(
          padding: EdgeInsets.only(
            left: 24,
            right: 24,
            bottom: MediaQuery.of(context).padding.bottom + 16,
            top: 16,
          ),
          decoration: const BoxDecoration(
            color: AppColors.darkBlueBg,
            border: Border(top: BorderSide(color: AppColors.borderColor)),
          ),
          child: Row(
            children: [
              GestureDetector(
                onTap: _back,
                child: const Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.chevron_left,
                        color: AppColors.textGrey, size: 20),
                    Text('Back',
                        style: TextStyle(
                            color: AppColors.textGrey, fontSize: 12)),
                  ],
                ),
              ),
              const Spacer(),
              BlocBuilder<RoomBloc, RoomState>(
                builder: (context, state) {
                  final isLoading = state is RoomLoading &&
                      _currentStep == _totalSteps - 1;
                  return SizedBox(
                    height: 52,
                    child: ElevatedButton(
                      onPressed:
                          (_canNext && state is! RoomLoading) ? _next : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryCyan,
                        foregroundColor: Colors.black87,
                        disabledBackgroundColor:
                            AppColors.primaryCyan.withValues(alpha: 0.3),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                        padding: const EdgeInsets.symmetric(horizontal: 28),
                        elevation: 0,
                      ),
                      child: isLoading
                          ? SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    AppColors.darkBlueBg),
                              ),
                            )
                          : Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  _currentStep == _totalSteps - 1
                                      ? 'Create Room'
                                      : 'Next',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),
                                ),
                                const SizedBox(width: 6),
                                Icon(
                                  _currentStep == _totalSteps - 1
                                      ? Icons.rocket_launch_rounded
                                      : Icons.arrow_forward_rounded,
                                  size: 18,
                                ),
                              ],
                            ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showSuccessDialog(String roomCode) {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black87,
      builder: (_) => _SuccessDialog(
        onOk: () {
          Navigator.of(context).pop();
          _showRoomInfoSheet(roomCode);
        },
      ),
    );
  }

  void _showRoomInfoSheet(String roomCode) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _RoomInfoSheet(
        roomName: _roomNameCtrl.text.trim(),
        memberPerGroup: _maxPeoplePerGroup,
        groups: _numberOfGroups,
        roomCode: roomCode,
      ),
    );
  }

  Widget _buildStepContent() {
    switch (_currentStep) {
      case 0:
        return _StepDefineCorePulse(
            controller: _roomNameCtrl,
            onChanged: (_) => setState(() {}));
      case 1:
        return _StepRoleDefinition(
            roleController: _roleCtrl,
            roles: _roles,
            onRolesChanged: () => setState(() {}));
      case 2:
        return _StepFinalize(
          maxPeoplePerGroup: _maxPeoplePerGroup,
          numberOfGroups: _numberOfGroups,
          onPeopleChanged: (v) => setState(() => _maxPeoplePerGroup = v),
          onGroupsChanged: (v) => setState(() => _numberOfGroups = v),
        );
      default:
        return const SizedBox.shrink();
    }
  }

  @override
  void dispose() {
    _roomNameCtrl.dispose();
    _roleCtrl.dispose();
    super.dispose();
  }
}

// ── Step widgets (same UI as before) ──────────────────────────────────────────

class _StepDefineCorePulse extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  const _StepDefineCorePulse(
      {required this.controller, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Define the Core Pulse',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          const Text(
              'Establish the fundamental frequency of your project.',
              style: TextStyle(
                  color: AppColors.textGrey, fontSize: 14, height: 1.5)),
          const SizedBox(height: 32),
          const Text('ROOM NAME',
              style: TextStyle(
                  color: AppColors.primaryCyan,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.5)),
          const SizedBox(height: 10),
          _InputField(
              controller: controller, hint: 'Required', onChanged: onChanged),
        ],
      ),
    );
  }
}

class _StepRoleDefinition extends StatelessWidget {
  final TextEditingController roleController;
  final List<String> roles;
  final VoidCallback onRolesChanged;
  const _StepRoleDefinition(
      {required this.roleController,
      required this.roles,
      required this.onRolesChanged});

  void _addRole() {
    final role = roleController.text.trim();
    if (role.isNotEmpty && !roles.contains(role)) {
      roles.add(role);
      roleController.clear();
      onRolesChanged();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Role Definition',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          const Text('Define core technical roles for your project.',
              style: TextStyle(
                  color: AppColors.textGrey, fontSize: 14, height: 1.5)),
          const SizedBox(height: 32),
          const Text('NEW ROLE TITLE',
              style: TextStyle(
                  color: AppColors.primaryCyan,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.5)),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _InputField(
                    controller: roleController,
                    hint: 'Required (Min. 2)',
                    onChanged: (_) {},
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
                  child: const Icon(Icons.add, color: Colors.black87, size: 22),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ...List.generate(roles.length, (i) {
            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: AppColors.inputBg,
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
                      child: Text(roles[i],
                          style: const TextStyle(
                              color: Colors.white, fontSize: 14))),
                  GestureDetector(
                    onTap: () {
                      roles.removeAt(i);
                      onRolesChanged();
                    },
                    child: const Icon(Icons.delete_outline,
                        color: AppColors.textGrey, size: 18),
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

class _StepFinalize extends StatelessWidget {
  final int maxPeoplePerGroup, numberOfGroups;
  final ValueChanged<int> onPeopleChanged, onGroupsChanged;
  const _StepFinalize(
      {required this.maxPeoplePerGroup,
      required this.numberOfGroups,
      required this.onPeopleChanged,
      required this.onGroupsChanged});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Finalize',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          const Text('Set group limits before launching the room.',
              style: TextStyle(
                  color: AppColors.textGrey, fontSize: 14, height: 1.5)),
          const SizedBox(height: 32),
          const Text('CAPACITY PARAMETERS',
              style: TextStyle(
                  color: AppColors.primaryCyan,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.5)),
          const SizedBox(height: 14),
          _CounterCard(
              label: 'Max People Per Group',
              sublabel: 'Range: 2–20',
              value: maxPeoplePerGroup,
              min: 2,
              max: 20,
              onChanged: onPeopleChanged),
          const SizedBox(height: 12),
          _CounterCard(
              label: 'Number of Groups',
              sublabel: 'Range: 2–50',
              value: numberOfGroups,
              min: 2,
              max: 50,
              onChanged: onGroupsChanged),
        ],
      ),
    );
  }
}

// ── Shared widgets ─────────────────────────────────────────────────────────────

class _CounterCard extends StatelessWidget {
  final String label, sublabel;
  final int value, min, max;
  final ValueChanged<int> onChanged;
  const _CounterCard(
      {required this.label,
      required this.sublabel,
      required this.value,
      required this.min,
      required this.max,
      required this.onChanged});

  @override
  Widget build(BuildContext context) {
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
                ]),
          ),
          Row(
            children: [
              _CircleBtn(
                  icon: Icons.remove,
                  enabled: value > min,
                  onTap: value > min ? () => onChanged(value - 1) : null),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text('$value',
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold)),
              ),
              _CircleBtn(
                  icon: Icons.add,
                  enabled: value < max,
                  onTap: value < max ? () => onChanged(value + 1) : null),
            ],
          ),
        ],
      ),
    );
  }
}

class _CircleBtn extends StatelessWidget {
  final IconData icon;
  final bool enabled;
  final VoidCallback? onTap;
  const _CircleBtn(
      {required this.icon, required this.enabled, required this.onTap});

  @override
  Widget build(BuildContext context) {
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

class _InputField extends StatefulWidget {
  final TextEditingController controller;
  final String hint;
  final ValueChanged<String> onChanged;
  final ValueChanged<String>? onSubmitted;
  const _InputField(
      {required this.controller,
      required this.hint,
      required this.onChanged,
      this.onSubmitted});

  @override
  State<_InputField> createState() => _InputFieldState();
}

class _InputFieldState extends State<_InputField> {
  final _focus = FocusNode();

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
        color: AppColors.inputBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color:
              _focus.hasFocus ? AppColors.primaryCyan : AppColors.borderColor,
          width: _focus.hasFocus ? 1.5 : 1,
        ),
      ),
      child: TextField(
        controller: widget.controller,
        focusNode: _focus,
        style: const TextStyle(color: Colors.white, fontSize: 15),
        onChanged: widget.onChanged,
        onSubmitted: widget.onSubmitted,
        decoration: InputDecoration(
          hintText: widget.hint,
          hintStyle:
              TextStyle(color: AppColors.textGrey.withValues(alpha: 0.4)),
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        ),
      ),
    );
  }
}

// ── Success Dialog ─────────────────────────────────────────────────────────────
class _SuccessDialog extends StatefulWidget {
  final VoidCallback onOk;
  const _SuccessDialog({required this.onOk});

  @override
  State<_SuccessDialog> createState() => _SuccessDialogState();
}

class _SuccessDialogState extends State<_SuccessDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scale, _glow;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        duration: const Duration(milliseconds: 600), vsync: this);
    _scale = CurvedAnimation(parent: _ctrl, curve: Curves.elasticOut);
    _glow = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
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
      child: Container(
        decoration: BoxDecoration(
            color: AppColors.darkBlueBg,
            borderRadius: BorderRadius.circular(24)),
        padding:
            const EdgeInsets.symmetric(vertical: 48, horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedBuilder(
              animation: _ctrl,
              builder: (context, _) => Transform.scale(
                scale: _scale.value,
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.black,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.mintGreen
                            .withValues(alpha: 0.5 * _glow.value),
                        blurRadius: 30,
                        spreadRadius: 8,
                      ),
                    ],
                  ),
                  child: const Icon(Icons.check_rounded,
                      color: AppColors.mintGreen, size: 40),
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text('Room Created!',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: widget.onOk,
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      AppColors.mintGreen.withValues(alpha: 0.15),
                  foregroundColor: AppColors.mintGreen,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(
                        color: AppColors.mintGreen.withValues(alpha: 0.3)),
                  ),
                  elevation: 0,
                ),
                child: const Text('View Room Info',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 15)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Room Info Sheet ────────────────────────────────────────────────────────────
class _RoomInfoSheet extends StatelessWidget {
  final String roomName, roomCode;
  final int memberPerGroup, groups;
  const _RoomInfoSheet(
      {required this.roomName,
      required this.roomCode,
      required this.memberPerGroup,
      required this.groups});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.darkBlueBg,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 24,
        bottom: MediaQuery.of(context).padding.bottom + 32,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
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
          Row(
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Room Created',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold)),
                    SizedBox(height: 4),
                    Text('Share the code with your friends',
                        style: TextStyle(
                            color: AppColors.textGrey, fontSize: 13)),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: const Icon(Icons.close, color: AppColors.textGrey),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.cardBg,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.borderColor),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('ROOM NAME',
                    style: TextStyle(
                        color: AppColors.textGrey,
                        fontSize: 10,
                        letterSpacing: 1.5,
                        fontWeight: FontWeight.w600)),
                const SizedBox(height: 6),
                Text(roomName,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                        child:
                            _StatBox(value: '$memberPerGroup', label: 'Member/\nGroup')),
                    const SizedBox(width: 12),
                    Expanded(
                        child: _StatBox(value: '$groups', label: 'Groups')),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.cardBg,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.borderColor),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Room Code',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold)),
                const SizedBox(height: 14),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: AppColors.darkBlueBg,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.borderColor),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(roomCode,
                          style: const TextStyle(
                            color: AppColors.primaryCyan,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 3,
                          )),
                      GestureDetector(
                        onTap: () {
                          Clipboard.setData(ClipboardData(text: roomCode));
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text('Code copied!'),
                              backgroundColor: AppColors.primaryCyan
                                  .withValues(alpha: 0.9),
                              behavior: SnackBarBehavior.floating,
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.primaryCyan
                                .withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                                color: AppColors.primaryCyan
                                    .withValues(alpha: 0.2)),
                          ),
                          child: const Icon(Icons.copy_rounded,
                              color: AppColors.primaryCyan, size: 18),
                        ),
                      ),
                    ],
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

class _StatBox extends StatelessWidget {
  final String value, label;
  const _StatBox({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
      decoration: BoxDecoration(
        color: AppColors.darkBlueBg,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(value,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold)),
          Text(label,
              style: const TextStyle(
                  color: AppColors.textGrey, fontSize: 11, height: 1.4)),
        ],
      ),
    );
  }
}
