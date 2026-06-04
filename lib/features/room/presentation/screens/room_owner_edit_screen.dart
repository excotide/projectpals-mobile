// ── room_owner_edit_screen.dart ───────────────────────────────────────────────
// Layar edit room untuk OWNER: ubah project theme, roles, kapasitas, & status.
// Dipanggil dari tombol EDIT / opsi "Edit Room" di RoomInformationScreen.
// Hanya owner (validasi di RoomInformationScreen). Payload PATCH /rooms/{code}.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../domain/entities/room_entity.dart';
import '../bloc/room_bloc.dart';

class RoomOwnerEditScreen extends StatefulWidget {
  final RoomEntity room;
  const RoomOwnerEditScreen({super.key, required this.room});

  @override
  State<RoomOwnerEditScreen> createState() => _RoomOwnerEditScreenState();
}

class _RoomOwnerEditScreenState extends State<RoomOwnerEditScreen> {
  // ── BG sama dengan ProfileScreen ──
  static Color get _bgColor => AppColors.darkBlueBg;

  static const Color _accent = Color(0xFF7C9EFF);
  static const Color _accentLight = Color(0xFFB8CDFF);
  static const Color _green = Color(0xFF4ADE80);

  late final TextEditingController _themeCtrl;
  late final TextEditingController _roleCtrl;
  late List<String> _roles;
  late int _maxPerGroup;
  late int _numberOfGroups;

  /// Minimal anggota room = jumlah role × jumlah tim (FLOWS §1.1: tiap role
  /// tercover di tiap tim). Jadi batas bawah "Max Member Room".
  int get _minMembers => _roles.length * _numberOfGroups;

  bool get _canSave =>
      _themeCtrl.text.trim().isNotEmpty &&
      _roles.length >= 2 &&
      _maxPerGroup >= _minMembers;

  /// Pastikan max member tidak di bawah minimal (role × tim).
  void _clampMaxMembers() {
    if (_maxPerGroup < _minMembers) _maxPerGroup = _minMembers;
  }

  @override
  void initState() {
    super.initState();
    _themeCtrl = TextEditingController(text: widget.room.projectTheme);
    _roleCtrl = TextEditingController();
    _roles = List<String>.from(widget.room.roles);
    _maxPerGroup = widget.room.maxPerGroup;
    _numberOfGroups = widget.room.numberOfGroups;
    _clampMaxMembers();
  }

  @override
  void dispose() {
    _themeCtrl.dispose();
    _roleCtrl.dispose();
    super.dispose();
  }

  void _addRole() {
    final role = _roleCtrl.text.trim();
    if (role.isNotEmpty && !_roles.contains(role)) {
      setState(() {
        _roles.add(role);
        _roleCtrl.clear();
        _clampMaxMembers();
      });
    }
  }

  void _save() {
    if (!_canSave) return;
    context.read<RoomBloc>().add(
      RoomUpdateRequested(
        roomCode: widget.room.roomCode,
        data: {
          'project_theme': _themeCtrl.text.trim(),
          'roles': _roles,
          'max_per_group': _maxPerGroup,
          'number_of_groups': _numberOfGroups,
        },
      ),
    );
    // Pop ditangani oleh listener saat RoomUpdated diterima (hindari double-pop).
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RoomBloc, RoomState>(
      listener: (context, state) {
        if (state is RoomUpdated) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Room berhasil diperbarui'),
              backgroundColor: _green,
              behavior: SnackBarBehavior.floating,
            ),
          );
          Navigator.pop(context);
        } else if (state is RoomFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.red,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: _bgColor,
        body: SafeArea(
          child: Column(
            children: [
              _buildAppBar(context),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _sectionLabel('ROOM NAME'),
                      const SizedBox(height: 8),
                      _buildField(_themeCtrl, 'Required'),
                      const SizedBox(height: 24),
                      _sectionLabel('ROLES (min. 2)'),
                      const SizedBox(height: 8),
                      _buildRoleInput(),
                      const SizedBox(height: 12),
                      ..._buildRoleChips(),
                      const SizedBox(height: 24),
                      _sectionLabel('CAPACITY'),
                      const SizedBox(height: 8),
                      _buildCounter(
                        'Number of Groups',
                        'Range: 2–50',
                        _numberOfGroups,
                        2,
                        50,
                        (v) => setState(() {
                          _numberOfGroups = v;
                          _clampMaxMembers();
                        }),
                      ),
                      const SizedBox(height: 12),
                      _buildCounter(
                        'Max Member Room',
                        'Min: $_minMembers (role × tim)',
                        _maxPerGroup,
                        _minMembers,
                        100,
                        (v) => setState(() => _maxPerGroup = v),
                      ),
                      const SizedBox(height: 32),
                      _buildSaveButton(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Colors.white,
              size: 18,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          Expanded(
            child: ShaderMask(
              shaderCallback: (bounds) => const LinearGradient(
                colors: [_accent, _accentLight],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ).createShader(bounds),
              child: const Text(
                'Edit Room',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          const SizedBox(width: 44),
        ],
      ),
    );
  }

  Widget _buildRoleInput() {
    return Row(
      children: [
        Expanded(
          child: _buildField(
            _roleCtrl,
            'Add a role',
            onSubmitted: (_) => _addRole(),
          ),
        ),
        const SizedBox(width: 10),
        GestureDetector(
          onTap: _addRole,
          child: Container(
            width: 48,
            height: 54,
            decoration: BoxDecoration(
              color: _accent,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.add, color: Colors.white, size: 22),
          ),
        ),
      ],
    );
  }

  List<Widget> _buildRoleChips() {
    return _roles
        .asMap()
        .entries
        .map(
          (e) => Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                    color: _accent,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    e.value,
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ),
                GestureDetector(
                  onTap: () => setState(() {
                    _roles.removeAt(e.key);
                    _clampMaxMembers();
                  }),
                  child: Icon(
                    Icons.delete_outline,
                    color: Colors.white.withValues(alpha: 0.4),
                    size: 18,
                  ),
                ),
              ],
            ),
          ),
        )
        .toList();
  }

  Widget _buildSaveButton() {
    return BlocBuilder<RoomBloc, RoomState>(
      builder: (context, state) {
        final isLoading = state is RoomLoading;
        final enabled = _canSave && !isLoading;
        return SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton(
            onPressed: enabled ? _save : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: _accent,
              foregroundColor: Colors.white,
              disabledBackgroundColor: _accent.withValues(alpha: 0.3),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              elevation: 0,
            ),
            child: isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Text(
                    'Save Changes',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
          ),
        );
      },
    );
  }

  Widget _sectionLabel(String label) => Text(
    label,
    style: TextStyle(
      color: Colors.white.withValues(alpha: 0.4),
      fontSize: 11,
      fontWeight: FontWeight.w700,
      letterSpacing: 1.5,
    ),
  );

  Widget _buildField(
    TextEditingController ctrl,
    String hint, {
    ValueChanged<String>? onSubmitted,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderColor),
      ),
      child: TextField(
        controller: ctrl,
        style: const TextStyle(color: Colors.white, fontSize: 15),
        onSubmitted: onSubmitted,
        onChanged: (_) => setState(() {}),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.25)),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 18,
          ),
        ),
      ),
    );
  }

  Widget _buildCounter(
    String label,
    String sublabel,
    int value,
    int min,
    int max,
    ValueChanged<int> onChanged,
  ) {
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
                Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  sublabel,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.35),
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          _circleBtn(
            Icons.remove,
            value > min,
            value > min ? () => onChanged(value - 1) : null,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              '$value',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          _circleBtn(
            Icons.add,
            value < max,
            value < max ? () => onChanged(value + 1) : null,
          ),
        ],
      ),
    );
  }

  Widget _circleBtn(IconData icon, bool enabled, VoidCallback? onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: enabled
                ? _accent.withValues(alpha: 0.6)
                : Colors.white.withValues(alpha: 0.1),
          ),
        ),
        child: Icon(
          icon,
          size: 16,
          color: enabled ? _accent : Colors.white.withValues(alpha: 0.2),
        ),
      ),
    );
  }
}
