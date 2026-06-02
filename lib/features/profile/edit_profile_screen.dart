import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/constants/app_colors.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _nicknameController = TextEditingController();
  final _expertiseController = TextEditingController();
  int _selectedPreference = 0;

  final _preferenceOptions = const [
    {'label': 'Morning', 'icon': Icons.wb_sunny_outlined},
    {'label': 'Afternoon', 'icon': Icons.wb_twilight_outlined},
    {'label': 'Flexible', 'icon': Icons.nightlight_round_outlined},
  ];

  @override
  void dispose() {
    _nicknameController.dispose();
    _expertiseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        final user = state is AuthAuthenticated ? state.user : null;

        return Scaffold(
          backgroundColor: AppColors.darkBlueBg,
          body: Column(
            children: [
              _EditProfileHero(
                user: user,
                onCancel: () => Navigator.pop(context),
                onDone: () {
                  // TODO: dispatch update event ke bloc
                  Navigator.pop(context);
                },
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const _FormLabel(label: 'NICKNAME'),
                      const SizedBox(height: 8),
                      _InputField(
                        controller: _nicknameController,
                        hint: 'Insert Text',
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'Productivity Preferences',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 12),
                      _EditPreferenceChips(
                        options: _preferenceOptions,
                        selected: _selectedPreference,
                        onSelect: (i) =>
                            setState(() => _selectedPreference = i),
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'Expertise',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 12),
                      _InputField(
                        controller: _expertiseController,
                        hint: 'Insert Text',
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Edit hero header
// ─────────────────────────────────────────────────────────────
class _EditProfileHero extends StatelessWidget {
  final dynamic user;
  final VoidCallback onCancel;
  final VoidCallback onDone;

  const _EditProfileHero({
    required this.user,
    required this.onCancel,
    required this.onDone,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.primaryCyan,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      padding: const EdgeInsets.only(
          top: 52, bottom: 28, left: 20, right: 20),
      child: Column(
        children: [
          // ── Row: Cancel (kiri) | Done (kanan) — sejajar di atas ──
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _HeroButton(label: 'Cancel!', onTap: onCancel),
              _HeroButton(label: 'Done', onTap: onDone),
            ],
          ),
          const SizedBox(height: 20),

          // ── Avatar di tengah bawah button ──
          Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF002B35),
                  border: Border.all(
                      color: Colors.white.withValues(alpha: 0.5), width: 2.5),
                ),
                child: const Icon(Icons.person,
                    color: AppColors.primaryCyan, size: 48),
              ),
              Positioned(
                bottom: -2,
                right: -2,
                child: Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFF002B35),
                    border: Border.all(
                        color: Colors.white.withValues(alpha: 0.7), width: 1.5),
                  ),
                  child: const Icon(Icons.edit,
                      color: Colors.white, size: 14),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // @username + edit icon
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                user != null ? '@${user.username}' : '@username',
                style: const TextStyle(
                  color: Color(0xFF003642),
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.4,
                ),
              ),
              const SizedBox(width: 6),
              const Icon(Icons.edit, color: Color(0xFF003642), size: 14),
            ],
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Hero button
// ─────────────────────────────────────────────────────────────
class _HeroButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _HeroButton({
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 110,
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: const Color(0xFF002B35),
          borderRadius: BorderRadius.circular(24),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Form label
// ─────────────────────────────────────────────────────────────
class _FormLabel extends StatelessWidget {
  final String label;
  const _FormLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(
        color: AppColors.textGrey,
        fontSize: 11,
        letterSpacing: 1.4,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Input field
// ─────────────────────────────────────────────────────────────
class _InputField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;

  const _InputField({required this.controller, required this.hint});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      style: const TextStyle(color: Colors.white, fontSize: 14),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: AppColors.textGrey),
        filled: true,
        fillColor: AppColors.cardBg,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:
              const BorderSide(color: AppColors.primaryCyan, width: 1.5),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Preference chips for edit screen
// ─────────────────────────────────────────────────────────────
class _EditPreferenceChips extends StatelessWidget {
  final List<Map<String, Object>> options;
  final int selected;
  final ValueChanged<int> onSelect;

  const _EditPreferenceChips({
    required this.options,
    required this.selected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(options.length, (i) {
        final active = i == selected;
        return Expanded(
          child: GestureDetector(
            onTap: () => onSelect(i),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: EdgeInsets.only(
                  right: i < options.length - 1 ? 10 : 0),
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                color: active
                    ? AppColors.primaryCyan.withValues(alpha: 0.18)
                    : AppColors.cardBg,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: active
                      ? AppColors.primaryCyan
                      : AppColors.borderColor,
                  width: active ? 1.5 : 1,
                ),
              ),
              child: Column(
                children: [
                  Icon(options[i]['icon'] as IconData,
                      color: active
                          ? AppColors.primaryCyan
                          : AppColors.textGrey,
                      size: 22),
                  const SizedBox(height: 6),
                  Text(
                    options[i]['label'] as String,
                    style: TextStyle(
                      color: active
                          ? AppColors.primaryCyan
                          : AppColors.textGrey,
                      fontSize: 12,
                      fontWeight: active
                          ? FontWeight.w600
                          : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}