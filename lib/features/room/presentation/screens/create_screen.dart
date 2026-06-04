import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../domain/entities/role_normalization.dart';
import '../../domain/entities/room_entity.dart';
import '../bloc/role_normalizer_cubit.dart';
import '../bloc/room_bloc.dart';
import 'join_screen2.dart';
import 'room_information_screen.dart';

class CreateRoomScreen extends StatefulWidget {
  const CreateRoomScreen({super.key});

  @override
  State<CreateRoomScreen> createState() => _CreateRoomScreenState();
}

class _CreateRoomScreenState extends State<CreateRoomScreen> {
  int _currentStep = 0;
  final int _totalSteps = 3;
  int _slideDir = 1; // 1 = forward (slide in from right), -1 = back (from left)

  final _roomNameCtrl = TextEditingController();
  final _roleCtrl = TextEditingController();
  final List<String> _roles = [];
  int _maxPeoplePerGroup = 2;
  int _numberOfGroups = 2;
  bool _createRoomOnly = false;

  @override
  void initState() {
    super.initState();
    // Bersihkan state preview dari sesi sebelumnya (cubit disediakan global).
    context.read<RoleNormalizerCubit>().reset();
  }

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
      setState(() {
        _slideDir = 1;
        _currentStep++;
        // Saat masuk step Finalize, pastikan max member memenuhi minimum.
        final minMembers = _roles.length * _numberOfGroups;
        if (_maxPeoplePerGroup < minMembers) _maxPeoplePerGroup = minMembers;
      });
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
      setState(() {
        _slideDir = -1;
        _currentStep--;
      });
    } else {
      Navigator.of(context).maybePop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RoomBloc, RoomState>(
      listener: (context, state) {
        if (state is RoomCreated) {
          if (_createRoomOnly) {
            // Owner hanya membuat & memantau — langsung ke detail room.
            _goToRoomDetail(state.room);
          } else {
            // Owner langsung ikut join: pilih window/environment + role,
            // lalu diarahkan ke detail room setelah sukses.
            _goToSelfJoin(state.room);
          }
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
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFB8CDFF), Color(0xFF3B5FD9)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
            ),
          ),
          leading: IconButton(
            icon: const Icon(Icons.close, color: Color(0xFF0D1B3E)),
            onPressed: () => Navigator.of(context).maybePop(),
          ),
          title: const Text(
            'Create Room',
            style: TextStyle(
              color: Color(0xFF0D1B3E),
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ),
        body: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Column(
            children: [
              // ── Progress bar ──
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 24, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _stepLabel,
                          style: const TextStyle(
                            color: Color(0xFF7C9EFF),
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.5,
                          ),
                        ),
                        Text(
                          _progressLabel,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.4),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: _progress,
                        backgroundColor: AppColors.borderColor,
                        valueColor: const AlwaysStoppedAnimation<Color>(
                            Color(0xFF7C9EFF)),
                        minHeight: 4,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  switchInCurve: Curves.easeOutCubic,
                  switchOutCurve: Curves.easeInCubic,
                  transitionBuilder: (child, anim) => ClipRect(
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: Offset(_slideDir.toDouble(), 0),
                        end: Offset.zero,
                      ).animate(anim),
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
          decoration: BoxDecoration(
            color: AppColors.darkBlueBg,
            border: Border(top: BorderSide(color: AppColors.borderColor)),
          ),
          child: Row(
            children: [
              GestureDetector(
                onTap: _back,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.chevron_left,
                        color: Colors.white.withValues(alpha: 0.4), size: 20),
                    Text(
                      'Back',
                      style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.4), fontSize: 12),
                    ),
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
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        disabledBackgroundColor:
                            const Color(0xFF3B5FD9).withValues(alpha: 0.3),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                        padding: EdgeInsets.zero,
                        elevation: 0,
                      ),
                      child: Ink(
                        decoration: BoxDecoration(
                          gradient: (_canNext && state is! RoomLoading)
                              ? const LinearGradient(
                                  colors: [Color(0xFFB8CDFF), Color(0xFF3B5FD9)],
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                )
                              : null,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 28),
                          alignment: Alignment.center,
                          child: isLoading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Color(0xFF0D1B3E)),
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
                                        color: Color(0xFF0D1B3E),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    Icon(
                                      _currentStep == _totalSteps - 1
                                          ? Icons.rocket_launch_rounded
                                          : Icons.arrow_forward_rounded,
                                      size: 18,
                                      color: const Color(0xFF0D1B3E),
                                    ),
                                  ],
                                ),
                        ),
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

  /// Arahkan langsung ke halaman detail room yang baru dibuat.
  void _goToRoomDetail(RoomEntity room) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => RoomInformationScreen(room: room)),
    );
  }

  /// Arahkan owner ke flow join yang ada (pilih window/environment + role)
  /// memakai data room baru sebagai preview; setelah join → detail room.
  void _goToSelfJoin(RoomEntity room) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => JoinScreen2(
          roomCode: room.roomCode,
          createdRoom: room,
          preview: {
            'roles': room.roles,
            'project_theme': room.projectTheme,
          },
        ),
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
          rolesCount: _roles.length,
          maxPeoplePerGroup: _maxPeoplePerGroup,
          numberOfGroups: _numberOfGroups,
          createRoomOnly: _createRoomOnly,
          onCreateRoomOnlyChanged: (v) => setState(() => _createRoomOnly = v),
          onPeopleChanged: (v) => setState(() {
            final minMembers = _roles.length * _numberOfGroups;
            _maxPeoplePerGroup = v < minMembers ? minMembers : v;
          }),
          onGroupsChanged: (v) => setState(() {
            _numberOfGroups = v < 2 ? 2 : v;
            final minMembers = _roles.length * _numberOfGroups;
            if (_maxPeoplePerGroup < minMembers) _maxPeoplePerGroup = minMembers;
          }),
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

// ── Step widgets ───────────────────────────────────────────────────────────────

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
          const Text(
            'Define the Core Pulse',
            style: TextStyle(
                color: Colors.white,
                fontSize: 26,
                fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Text(
            'Establish the fundamental frequency of your project.',
            style: TextStyle(
                color: Colors.white.withValues(alpha: 0.4),
                fontSize: 14,
                height: 1.5),
          ),
          const SizedBox(height: 32),
          // ROOM NAME label dengan warna accent
          ShaderMask(
            shaderCallback: (bounds) => const LinearGradient(
              colors: [Color(0xFF7C9EFF), Color(0xFFB8CDFF)],
            ).createShader(bounds),
            child: const Text(
              'ROOM NAME',
              style: TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.5,
              ),
            ),
          ),
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

  Future<void> _addRole(BuildContext context) async {
    final raw = roleController.text.trim();
    if (raw.isEmpty) return;

    // Normalisasi ke nama role kanonik via backend (fallback ke input mentah).
    final cubit = context.read<RoleNormalizerCubit>();
    final canonical = await cubit.resolve(raw);
    if (!context.mounted) return;

    if (!roles.any((r) => r.toLowerCase() == canonical.toLowerCase())) {
      roles.add(canonical);
    }
    roleController.clear();
    cubit.reset();
    onRolesChanged();
  }

  /// Menambah role kanonik yang dipilih dari dropdown saran (nilai sudah ternormalisasi).
  void _pickRole(BuildContext context, String canonical) {
    final value = canonical.trim();
    if (value.isEmpty) return;
    if (!roles.any((r) => r.toLowerCase() == value.toLowerCase())) {
      roles.add(value);
    }
    roleController.clear();
    context.read<RoleNormalizerCubit>().reset();
    onRolesChanged();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Role Definition',
            style: TextStyle(
                color: Colors.white,
                fontSize: 26,
                fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Text(
            'Define core technical roles for your project.',
            style: TextStyle(
                color: Colors.white.withValues(alpha: 0.4),
                fontSize: 14,
                height: 1.5),
          ),
          const SizedBox(height: 32),
          ShaderMask(
            shaderCallback: (bounds) => const LinearGradient(
              colors: [Color(0xFF7C9EFF), Color(0xFFB8CDFF)],
            ).createShader(bounds),
            child: const Text(
              'NEW ROLE TITLE',
              style: TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.5,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _InputField(
                    controller: roleController,
                    hint: 'Required (Min. 2)',
                    onChanged: (v) =>
                        context.read<RoleNormalizerCubit>().previewDebounced(v),
                    onSubmitted: (_) => _addRole(context)),
              ),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: () => _addRole(context),
                child: Container(
                  width: 48,
                  height: 54,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFB8CDFF), Color(0xFF3B5FD9)],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.add,
                      color: Color(0xFF0D1B3E), size: 22),
                ),
              ),
            ],
          ),
          _RoleSuggestionDropdown(
              onPick: (canonical) => _pickRole(context, canonical)),
          const SizedBox(height: 20),
          ...List.generate(roles.length, (i) {
            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: AppColors.cardBg,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.borderColor),
              ),
              child: Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF7C9EFF), Color(0xFF4B6EF5)],
                      ),
                      shape: BoxShape.circle,
                    ),
                  ),
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
                    child: Icon(Icons.delete_outline,
                        color: Colors.white.withValues(alpha: 0.3), size: 18),
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

/// Dropdown saran role di bawah input: menampilkan hasil normalisasi dari
/// [RoleNormalizerCubit] sebagai item yang bisa diklik untuk langsung ditambah.
class _RoleSuggestionDropdown extends StatelessWidget {
  final void Function(String canonical) onPick;
  const _RoleSuggestionDropdown({required this.onPick});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RoleNormalizerCubit, RoleNormalizerState>(
      builder: (context, state) {
        final Widget child = switch (state) {
          RoleNormalizerLoading() => _panel(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 14),
                child: Row(
                  children: [
                    const SizedBox(
                      width: 14,
                      height: 14,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Color(0xFF7C9EFF)),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Mencari saran role…',
                      style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.5),
                          fontSize: 13),
                    ),
                  ],
                ),
              ),
            ),
          RoleNormalizerSuccess(:final result) =>
            _panel(child: _suggestionTile(result)),
          _ => const SizedBox.shrink(),
        };

        final hasPanel =
            state is RoleNormalizerLoading || state is RoleNormalizerSuccess;
        return AnimatedSize(
          duration: const Duration(milliseconds: 180),
          alignment: Alignment.topLeft,
          child: Padding(
            padding: EdgeInsets.only(top: hasPanel ? 8 : 0),
            child: child,
          ),
        );
      },
    );
  }

  Widget _panel({required Widget child}) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
            color: const Color(0xFF7C9EFF).withValues(alpha: 0.45)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _suggestionTile(RoleNormalization result) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => onPick(result.normalized),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          child: Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFB8CDFF), Color(0xFF3B5FD9)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.auto_awesome_rounded,
                    size: 16, color: Color(0xFF0D1B3E)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      result.normalized,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      result.changed
                          ? 'Saran dari "${result.original}" · ketuk untuk tambah'
                          : 'Ketuk untuk tambah',
                      style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.4),
                          fontSize: 11),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.add_circle_outline_rounded,
                  color: Color(0xFF7C9EFF), size: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class _StepFinalize extends StatelessWidget {
  final int rolesCount, maxPeoplePerGroup, numberOfGroups;
  final bool createRoomOnly;
  final ValueChanged<bool> onCreateRoomOnlyChanged;
  final ValueChanged<int> onPeopleChanged, onGroupsChanged;
  const _StepFinalize(
      {required this.rolesCount,
      required this.maxPeoplePerGroup,
      required this.numberOfGroups,
      required this.createRoomOnly,
      required this.onCreateRoomOnlyChanged,
      required this.onPeopleChanged,
      required this.onGroupsChanged});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Finalize',
            style: TextStyle(
                color: Colors.white,
                fontSize: 26,
                fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Text(
            'Set a limit on the number of group members before starting a room. All roles in the room will be filled by each team, so the minimum number of members will increase based on the number of roles and teams you add.',
            style: TextStyle(
                color: Colors.white.withValues(alpha: 0.4),
                fontSize: 14,
                height: 1.5),
          ),
          const SizedBox(height: 32),
          ShaderMask(
            shaderCallback: (bounds) => const LinearGradient(
              colors: [Color(0xFF7C9EFF), Color(0xFFB8CDFF)],
            ).createShader(bounds),
            child: const Text(
              'CAPACITY PARAMETERS',
              style: TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.5,
              ),
            ),
          ),
          const SizedBox(height: 14),
          _EditableCounterCard(
              label: 'Max member room',
              sublabel: 'Min: ${rolesCount * numberOfGroups}',
              value: maxPeoplePerGroup,
              min: rolesCount * numberOfGroups,
              onChanged: onPeopleChanged),
          const SizedBox(height: 12),
          _EditableCounterCard(
              label: 'Number of teams',
              sublabel: 'Min: 2',
              value: numberOfGroups,
              min: 2,
              onChanged: onGroupsChanged),
          const SizedBox(height: 24),
          ShaderMask(
            shaderCallback: (bounds) => const LinearGradient(
              colors: [Color(0xFF7C9EFF), Color(0xFFB8CDFF)],
            ).createShader(bounds),
            child: const Text(
              'OWNER PARTICIPATION',
              style: TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.5,
              ),
            ),
          ),
          const SizedBox(height: 14),
          _CreateRoomOnlyTile(
              value: createRoomOnly, onChanged: onCreateRoomOnlyChanged),
        ],
      ),
    );
  }
}

/// Checkbox "Create Room Only": jika dicentang, owner hanya membuat &
/// memantau room tanpa ikut bergabung/dimatch ke team.
class _CreateRoomOnlyTile extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  const _CreateRoomOnlyTile({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: AppColors.cardBg,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: value
                ? const Color(0xFF7C9EFF)
                : AppColors.borderColor,
            width: value ? 1.5 : 1,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                gradient: value
                    ? const LinearGradient(
                        colors: [Color(0xFFB8CDFF), Color(0xFF3B5FD9)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )
                    : null,
                color: value ? null : Colors.transparent,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: value
                      ? Colors.transparent
                      : const Color(0xFF7C9EFF).withValues(alpha: 0.5),
                  width: 1.5,
                ),
              ),
              child: value
                  ? const Icon(Icons.check_rounded,
                      size: 16, color: Color(0xFF0D1B3E))
                  : null,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Create Room Only',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Buat room tanpa ikut jadi anggota — kamu hanya '
                    'memantau, tidak ikut dimatch ke team.',
                    style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.4),
                        fontSize: 12,
                        height: 1.4),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Shared widgets ─────────────────────────────────────────────────────────────

class _EditableCounterCard extends StatefulWidget {
  final String label, sublabel;
  final int value, min;
  final ValueChanged<int> onChanged;
  const _EditableCounterCard(
      {required this.label,
      required this.sublabel,
      required this.value,
      required this.min,
      required this.onChanged});

  @override
  State<_EditableCounterCard> createState() => _EditableCounterCardState();
}

class _EditableCounterCardState extends State<_EditableCounterCard> {
  late final TextEditingController _ctrl;
  final _focus = FocusNode();

  @override
  void initState() {
    super.initState();
    _ctrl = TextEditingController(text: '${widget.value}');
    _focus.addListener(() {
      if (!_focus.hasFocus) _commit();
    });
  }

  @override
  void didUpdateWidget(covariant _EditableCounterCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Sinkronkan field saat value diubah dari luar (mis. min dinaikkan).
    if (widget.value != oldWidget.value && !_focus.hasFocus) {
      _ctrl.text = '${widget.value}';
    }
  }

  /// Bersihkan & clamp isi field ke minimum, lalu propagasi ke parent.
  void _commit() {
    final parsed = int.tryParse(_ctrl.text.trim()) ?? widget.min;
    final clamped = parsed < widget.min ? widget.min : parsed;
    if (_ctrl.text != '$clamped') _ctrl.text = '$clamped';
    if (clamped != widget.value) widget.onChanged(clamped);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    _focus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final canDecrement = widget.value > widget.min;
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
                  Text(widget.label,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600)),
                  Text(widget.sublabel,
                      style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.4),
                          fontSize: 11)),
                ]),
          ),
          Row(
            children: [
              _CircleBtn(
                  icon: Icons.remove,
                  enabled: canDecrement,
                  onTap: canDecrement
                      ? () => widget.onChanged(widget.value - 1)
                      : null),
              SizedBox(
                width: 48,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: TextField(
                    controller: _ctrl,
                    focusNode: _focus,
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    onSubmitted: (_) => _commit(),
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                    decoration: const InputDecoration(
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(vertical: 4),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              _CircleBtn(
                  icon: Icons.add,
                  enabled: true,
                  onTap: () => widget.onChanged(widget.value + 1)),
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
                ? const Color(0xFF7C9EFF).withValues(alpha: 0.6)
                : const Color(0xFF7C9EFF).withValues(alpha: 0.2),
          ),
        ),
        child: Icon(icon,
            size: 16,
            color: enabled
                ? const Color(0xFF7C9EFF)
                : const Color(0xFF7C9EFF).withValues(alpha: 0.3)),
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
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _focus.hasFocus
              ? const Color(0xFF7C9EFF)
              : AppColors.borderColor,
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
          hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.25)),
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        ),
      ),
    );
  }
}
