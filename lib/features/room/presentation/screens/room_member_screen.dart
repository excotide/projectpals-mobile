// ── room_member_screen.dart ───────────────────────────────────────────────────
// Layar detail room untuk member NON-OWNER (FLOWS §2 DetailMemberRoom).
// Ditampilkan saat non-owner membuka detail room (validasi di RoomInformationScreen),
// bukan dari tombol EDIT owner.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../domain/entities/room_entity.dart';
import '../bloc/room_bloc.dart';

class RoomMemberScreen extends StatefulWidget {
  final RoomEntity room;
  const RoomMemberScreen({super.key, required this.room});

  @override
  State<RoomMemberScreen> createState() => _RoomMemberScreenState();
}

class _RoomMemberScreenState extends State<RoomMemberScreen> {
  // ── BG sama dengan ProfileScreen ──
  static Color get _bgColor => AppColors.darkBlueBg;

  static const Color _accent = Color(0xFF7C9EFF);
  static const Color _accentLight = Color(0xFFB8CDFF);
  static const Color _accentDark = Color(0xFF4B6EF5);
  static const Color _green = Color(0xFF4ADE80);

  late RoomEntity _room;
  String? _selectedRole;
  String? _selectedEnvironment;

  @override
  void initState() {
    super.initState();
    _room = widget.room;
    _selectedRole = _room.roles.isNotEmpty ? _room.roles.first : null;
    _selectedEnvironment = 'Remote';
  }

  void _saveChanges() {
    final Map<String, dynamic> data = {};
    if (_selectedRole != null) data['primary_role'] = _selectedRole;
    if (_selectedEnvironment != null) {
      data['environment'] = _selectedEnvironment;
    }

    context.read<RoomBloc>().add(
      RoomUpdateRequested(roomCode: _room.roomCode, data: data),
    );
    // Snackbar sukses/gagal ditangani oleh listener saat RoomUpdated/RoomFailure.
  }

  /// Popup edit peran & lingkungan kerja (menggantikan expand ke bawah).
  void _showEditSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _EditRoleEnvSheet(
        roles: _room.roles.isNotEmpty ? _room.roles : ['Member'],
        initialRole: _selectedRole,
        initialEnvironment: _selectedEnvironment ?? 'Remote',
        onSave: (role, env) {
          setState(() {
            _selectedRole = role;
            _selectedEnvironment = env;
          });
          _saveChanges();
        },
      ),
    );
  }

  void _showLeaveConfirm() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF161C2C),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
        ),
        title: const Text(
          'Keluar dari Room?',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        content: const Text(
          'Kamu akan keluar dari room ini. Tindakan ini tidak dapat dibatalkan.',
          style: TextStyle(color: Colors.white60, fontSize: 14, height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('BATAL', style: TextStyle(color: Colors.white60)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<RoomBloc>().add(RoomLeaveRequested(_room.roomCode));
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
            child: const Text(
              'KELUAR',
              style: TextStyle(
                color: AppColors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RoomBloc, RoomState>(
      listener: (context, state) {
        if (state is RoomUpdated) {
          // Update sukses → refresh data room (popup sudah tertutup saat simpan).
          setState(() {
            _room = state.room;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Peran & lingkungan berhasil diperbarui'),
              backgroundColor: Color(0xFF4ADE80),
              behavior: SnackBarBehavior.floating,
            ),
          );
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
        // ── BG sama dengan ProfileScreen ──
        backgroundColor: _bgColor,
        body: SafeArea(
          child: Column(
            children: [
              _buildAppBar(context),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildRoomSummaryCard(),
                      const SizedBox(height: 16),
                      // ── Profile card dengan button di dalam ──
                      _buildProfileCard(),
                      const SizedBox(height: 32),
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
                'Room Details',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.cardBg,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.borderColor),
            ),
            child: Icon(
              Icons.more_vert,
              color: Colors.white.withValues(alpha: 0.5),
              size: 18,
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
    );
  }

  Widget _buildRoomSummaryCard() {
    return Container(
      decoration: BoxDecoration(
        // ── card bg sama dengan ProfileScreen ──
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.borderColor),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: Row(
              children: [
                // ── Icon info — bg biru muda ──
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: _accent.withValues(alpha: 0.22),
                    shape: BoxShape.circle,
                    border: Border.all(color: _accent.withValues(alpha: 0.5)),
                  ),
                  child: const Icon(
                    Icons.info_outline_rounded,
                    color: _accent,
                    size: 14,
                  ),
                ),
                const SizedBox(width: 10),
                ShaderMask(
                  shaderCallback: (bounds) => const LinearGradient(
                    colors: [_accent, _accentLight],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ).createShader(bounds),
                  child: const Text(
                    'Room Information',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: Divider(
              color: Colors.white.withValues(alpha: 0.06),
              height: 1,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _InfoCell(
                        label: 'ROLES',
                        value: _room.roles.isNotEmpty
                            ? _room.roles.join(',\n')
                            : 'No roles',
                      ),
                    ),
                    Expanded(
                      child: _InfoCell(
                        label: 'MAX CAPACITY',
                        value: '${_room.maxPerGroup} Anggota',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: _InfoCell(
                        label: 'PRODUCTIVITY',
                        value: 'Morning, Evening',
                      ),
                    ),
                    Expanded(
                      child: _InfoCell(
                        label: 'ENVIRONMENT',
                        value: 'Remote, Hybrid',
                        valueColor: _green,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Profile Card — button Edit & Leave di DALAM card ──────────────────────

  Widget _buildProfileCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        // ── card bg sama dengan ProfileScreen ──
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.borderColor),
        boxShadow: [
          BoxShadow(
            color: _accent.withValues(alpha: 0.06),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header ──
          Row(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: _accent.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                  border: Border.all(color: _accent.withValues(alpha: 0.4)),
                ),
                child: const Icon(
                  Icons.person_outline_rounded,
                  color: _accent,
                  size: 15,
                ),
              ),
              const SizedBox(width: 10),
              const Text(
                'Your Profile in Room',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Divider(color: Colors.white.withValues(alpha: 0.06), height: 1),
          const SizedBox(height: 14),

          // ── Current role + environment ──
          Row(
            children: [
              Expanded(
                child: _InfoCell(
                  label: 'CURRENT ROLE',
                  value:
                      '● ${_selectedRole ?? (_room.roles.isNotEmpty ? _room.roles.first : 'Belum dipilih')}',
                  valueColor: _green,
                ),
              ),
              Expanded(
                child: _InfoCell(
                  label: 'ENVIRONMENT',
                  value: '● ${_selectedEnvironment ?? 'Remote'}',
                  valueColor: _green,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),

          // ── Edit Role & Environment button — buka popup ──
          GestureDetector(
            onTap: _showEditSheet,
            child: Container(
              width: double.infinity,
              height: 48,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [_accent, _accentDark],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: _accentDark.withValues(alpha: 0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: const Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.edit_outlined, color: Colors.white, size: 16),
                    SizedBox(width: 8),
                    Text(
                      'Edit Role & Environment',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),

          // ── Leave Room button — di DALAM card ──
          GestureDetector(
            onTap: _showLeaveConfirm,
            child: Container(
              width: double.infinity,
              height: 44,
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.red.withValues(alpha: 0.45),
                  width: 1.2,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.exit_to_app_rounded,
                    color: AppColors.red.withValues(alpha: 0.8),
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Leave Room',
                    style: TextStyle(
                      color: AppColors.red.withValues(alpha: 0.8),
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Reusable Info Cell ─────────────────────────────────────────────────────────

class _InfoCell extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _InfoCell({required this.label, required this.value, this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.35),
            fontSize: 10,
            letterSpacing: 1.2,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            color: valueColor ?? Colors.white.withValues(alpha: 0.75),
            fontSize: 13,
            fontWeight: FontWeight.w500,
            height: 1.4,
          ),
        ),
      ],
    );
  }
}

// ── Popup Edit Peran & Lingkungan ──────────────────────────────────────────────

class _EditRoleEnvSheet extends StatefulWidget {
  final List<String> roles;
  final String? initialRole;
  final String initialEnvironment;
  final void Function(String? role, String environment) onSave;

  const _EditRoleEnvSheet({
    required this.roles,
    required this.initialRole,
    required this.initialEnvironment,
    required this.onSave,
  });

  @override
  State<_EditRoleEnvSheet> createState() => _EditRoleEnvSheetState();
}

class _EditRoleEnvSheetState extends State<_EditRoleEnvSheet> {
  static const Color _accent = Color(0xFF7C9EFF);
  static const Color _accentLight = Color(0xFFB8CDFF);
  static const Color _accentDark = Color(0xFF4B6EF5);

  static const List<String> _environments = [
    'Remote',
    'Hybrid',
    'On-site',
    'Flexible',
  ];

  static const Map<String, IconData> _envIcons = {
    'Remote': Icons.laptop_mac_outlined,
    'Hybrid': Icons.compare_arrows_rounded,
    'On-site': Icons.location_city_outlined,
    'Flexible': Icons.tune_rounded,
  };

  String? _selectedRole;
  late String _selectedEnvironment;

  @override
  void initState() {
    super.initState();
    _selectedRole = widget.initialRole;
    _selectedEnvironment = widget.initialEnvironment;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.darkBlueBg,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(
            20,
            12,
            20,
            MediaQuery.of(context).viewInsets.bottom + 20,
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
                    color: Colors.white.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              const Text(
                'Edit Peran & Lingkungan',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              _label('PILIH PERAN KAMU'),
              const SizedBox(height: 10),
              _buildRoleSelector(),
              const SizedBox(height: 22),
              _label('LINGKUNGAN KERJA'),
              const SizedBox(height: 10),
              _buildEnvironmentSelector(),
              const SizedBox(height: 24),
              _buildSaveButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _label(String text) => Text(
    text,
    style: TextStyle(
      color: Colors.white.withValues(alpha: 0.35),
      fontSize: 11,
      letterSpacing: 1.4,
      fontWeight: FontWeight.w700,
    ),
  );

  Widget _buildRoleSelector() {
    return Column(
      children: widget.roles.map((role) {
        final isSelected = _selectedRole == role;
        return GestureDetector(
          onTap: () => setState(() => _selectedRole = role),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: isSelected
                  ? _accent.withValues(alpha: 0.08)
                  : AppColors.cardBg,
              borderRadius: BorderRadius.circular(13),
              border: Border.all(
                color: isSelected ? _accent : AppColors.borderColor,
                width: isSelected ? 1.5 : 1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? _accent.withValues(alpha: 0.15)
                        : Colors.white.withValues(alpha: 0.04),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: isSelected
                          ? _accent.withValues(alpha: 0.5)
                          : Colors.white.withValues(alpha: 0.08),
                    ),
                  ),
                  child: Icon(
                    Icons.code_rounded,
                    color: isSelected
                        ? _accent
                        : Colors.white.withValues(alpha: 0.3),
                    size: 17,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    role,
                    style: TextStyle(
                      color: isSelected ? _accent : Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ),
                if (isSelected)
                  Container(
                    width: 22,
                    height: 22,
                    decoration: BoxDecoration(
                      color: _accent.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check_rounded,
                      color: _accent,
                      size: 14,
                    ),
                  ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildEnvironmentSelector() {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      childAspectRatio: 2.4,
      children: _environments.map((env) {
        final isSelected = _selectedEnvironment == env;
        return GestureDetector(
          onTap: () => setState(() => _selectedEnvironment = env),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            decoration: BoxDecoration(
              color: isSelected
                  ? _accent.withValues(alpha: 0.08)
                  : AppColors.cardBg,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected ? _accent : AppColors.borderColor,
                width: isSelected ? 1.5 : 1,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  _envIcons[env] ?? Icons.tune_rounded,
                  color: isSelected
                      ? _accent
                      : Colors.white.withValues(alpha: 0.3),
                  size: 16,
                ),
                const SizedBox(width: 8),
                Text(
                  env,
                  style: TextStyle(
                    color: isSelected ? _accent : Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSaveButton() {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pop();
        widget.onSave(_selectedRole, _selectedEnvironment);
      },
      child: Container(
        width: double.infinity,
        height: 50,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [_accentLight, _accentDark],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(13),
          boxShadow: [
            BoxShadow(
              color: _accentDark.withValues(alpha: 0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: const Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.check_rounded, color: Colors.white, size: 18),
              SizedBox(width: 8),
              Text(
                'Simpan Perubahan',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
