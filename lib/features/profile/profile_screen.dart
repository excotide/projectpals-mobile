import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/constants/app_colors.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';

// ── Accent palette ────────────────────────────────────────────
const Color _accentBlue     = Color(0xFF5B7FFF);
const Color _accentBlueDark = Color(0xFF4B6EF5);
const Color _accentBlueLight = Color(0xFF7C9EFF);
const Color _accentGreen    = Color(0xFF4ADE80);
const Color _accentYellow   = Color(0xFFFBBF24);

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthUnauthenticated) {
          Navigator.pushNamedAndRemoveUntil(context, '/login', (_) => false);
        }
      },
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          final user = state is AuthAuthenticated ? state.user : null;

          return Scaffold(
            backgroundColor: AppColors.darkBlueBg,
            body: Column(
              children: [
                // Hero: hanya avatar + username
                _ProfileHero(user: user),

                // Info card: NICKNAME + RATINGS (di luar hero, kotak sendiri)
                _ProfileInfoCard(user: user),

                // Scrollable body
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Productivity Preferences
                        const _SectionHeader(
                            title: 'Productivity Preferences'),
                        const SizedBox(height: 12),
                        _PreferenceChips(),
                        const SizedBox(height: 24),

                        // Expertise
                        const _SectionHeader(title: 'Expertise'),
                        const SizedBox(height: 12),
                        _ExpertiseChips(
                          skills: const ['Frontend', 'UI/UX Designer'],
                        ),
                        const SizedBox(height: 24),

                        // Project History
                        _SectionHeader(
                          title: 'Project History',
                          onAction: () {},
                          actionLabel: '→',
                        ),
                        const SizedBox(height: 12),
                        const _ProjectHistoryList(),
                        const SizedBox(height: 24),

                        // Account section
                        const _SectionHeader(title: 'Account'),
                        const SizedBox(height: 10),
                        _SettingsItem(
                          icon: Icons.person_outline,
                          label: 'Edit Profile',
                          onTap: () =>
                              Navigator.pushNamed(context, '/edit-profile'),
                        ),
                        _SettingsItem(
                          icon: Icons.lock_outline,
                          label: 'Change Password',
                          onTap: () {},
                        ),
                        const SizedBox(height: 24),

                        // Session section
                        const _SectionHeader(title: 'Session'),
                        const SizedBox(height: 10),
                        _SettingsItem(
                          icon: Icons.logout,
                          label: 'Logout',
                          color: AppColors.red,
                          onTap: () => _confirmLogout(context),
                        ),
                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.cardBg,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: AppColors.borderColor),
        ),
        title: const Text('Logout?',
            style:
                TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        content: const Text('Are you sure you want to log out?',
            style: TextStyle(color: AppColors.textGrey)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel',
                style: TextStyle(color: AppColors.textGrey)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<AuthBloc>().add(LogoutRequested());
            },
            child: const Text('Logout',
                style: TextStyle(
                    color: AppColors.red, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Hero: bg gradient biru + avatar + @username
// ─────────────────────────────────────────────────────────────
class _ProfileHero extends StatelessWidget {
  final dynamic user;
  const _ProfileHero({required this.user});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF4B6EF5), Color(0xFF7C9EFF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      padding: const EdgeInsets.only(top: 56, bottom: 28),
      child: Column(
        children: [
          // Avatar with edit badge
          Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  // BG card — sama dengan ProfileScreen
                  color: AppColors.cardBg,
                  // Border avatar stack — ikut cardBg biar seamless
                  border: Border.all(color: AppColors.cardBg, width: 2),
                ),
                child: const Icon(Icons.person,
                    color: _accentBlue, size: 48),
              ),
              Positioned(
                bottom: -2,
                right: -2,
                child: GestureDetector(
                  onTap: () =>
                      Navigator.pushNamed(context, '/edit-profile'),
                  child: Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _accentBlueDark,
                      border: Border.all(
                          color: Colors.white.withValues(alpha: 0.4), width: 1.5),
                    ),
                    child: const Icon(Icons.edit,
                        color: Colors.white, size: 14),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // @username saja di dalam hero
          Text(
            user != null ? '${user.username}' : '@username',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.4,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Info card: NICKNAME + RATINGS — di luar hero, kotak gelap sendiri
// ─────────────────────────────────────────────────────────────
class _ProfileInfoCard extends StatelessWidget {
  final dynamic user;
  const _ProfileInfoCard({required this.user});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.borderColor),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // NICKNAME
          Column(
            children: [
              const Text(
                'NICKNAME',
                style: TextStyle(
                  color: AppColors.textGrey,
                  fontSize: 10,
                  letterSpacing: 1.2,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                user != null ? '${user.name}' : 'Nickname',
                style: const TextStyle(
                  color: _accentBlue,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          // Divider vertikal
          Container(
            width: 1,
            height: 36,
            color: AppColors.borderColor,
          ),

          // RATINGS
          Column(
            children: [
              const Text(
                'RATINGS',
                style: TextStyle(
                  color: AppColors.textGrey,
                  fontSize: 10,
                  letterSpacing: 1.2,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: const [
                  Icon(Icons.star, color: _accentGreen, size: 16),
                  SizedBox(width: 4),
                  Text(
                    '4.8',
                    style: TextStyle(
                      color: _accentGreen,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Section header
// ─────────────────────────────────────────────────────────────
class _SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onAction;
  final String? actionLabel;

  const _SectionHeader(
      {required this.title, this.onAction, this.actionLabel});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold)),
        if (onAction != null)
          GestureDetector(
            onTap: onAction,
            child: Row(
              children: [
                Text(actionLabel ?? 'See all',
                    style: const TextStyle(
                        color: _accentBlueLight, fontSize: 13)),
                const Icon(Icons.arrow_forward_ios,
                    color: _accentBlueLight, size: 12),
              ],
            ),
          ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Productivity preference chips
// ─────────────────────────────────────────────────────────────
class _PreferenceChips extends StatefulWidget {
  @override
  State<_PreferenceChips> createState() => _PreferenceChipsState();
}

class _PreferenceChipsState extends State<_PreferenceChips> {
  int _selected = 0;

  final _options = const [
    {'label': 'Morning', 'icon': Icons.wb_sunny_outlined},
    {'label': 'Afternoon', 'icon': Icons.wb_twilight_outlined},
    {'label': 'Flexible', 'icon': Icons.nightlight_round_outlined},
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(_options.length, (i) {
        final active = i == _selected;
        return Expanded(
          child: GestureDetector(
            onTap: () => setState(() => _selected = i),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: EdgeInsets.only(
                  right: i < _options.length - 1 ? 10 : 0),
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                color: active
                    ? _accentBlue.withValues(alpha: 0.35)
                    : AppColors.cardBg,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: active ? _accentBlue : AppColors.borderColor,
                  width: active ? 1.5 : 1,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(_options[i]['icon'] as IconData,
                      color: active ? _accentBlueLight : AppColors.textGrey,
                      size: 22),
                  const SizedBox(height: 6),
                  Text(_options[i]['label'] as String,
                      style: TextStyle(
                        color: active
                            ? _accentBlueLight
                            : AppColors.textGrey,
                        fontSize: 12,
                        fontWeight: active
                            ? FontWeight.w600
                            : FontWeight.normal,
                      )),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Expertise chips
// ─────────────────────────────────────────────────────────────
class _ExpertiseChips extends StatelessWidget {
  final List<String> skills;
  const _ExpertiseChips({required this.skills});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: skills
          .map((s) => Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.cardBg,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.borderColor),
                ),
                child: Text(s,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w500)),
              ))
          .toList(),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Project History list
// ─────────────────────────────────────────────────────────────
class _ProjectHistoryList extends StatelessWidget {
  const _ProjectHistoryList();

  static const _projects = [
    {
      'title': 'PitStop+',
      'role': 'Frontend • 3 months',
      'desc':
          'Redesigned the core visualization engine using Three.js and custom shaders, improving rendering performance by 40%.',
      'status': 'COMPLETED',
    },
    {
      'title': 'Mancingin',
      'role': 'FullStack • 1 year',
      'desc':
          'Implemented a real-time data synchronization layer for IoT devices using Rust and WebSockets.',
      'status': 'COMPLETED',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: _projects
          .map((p) => _ProjectCard(
                title: p['title']!,
                role: p['role']!,
                desc: p['desc']!,
                status: p['status']!,
              ))
          .toList(),
    );
  }
}

class _ProjectCard extends StatelessWidget {
  final String title;
  final String role;
  final String desc;
  final String status;

  const _ProjectCard({
    required this.title,
    required this.role,
    required this.desc,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    final statusLower = status.toLowerCase();
    final statusColor = switch (statusLower) {
      'ongoing' || 'in_progress' || 'matched' => _accentGreen,
      'matching'                               => _accentYellow,
      'completed' || 'closed'                  => Colors.white38,
      _                                        => Colors.white38,
    };

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(title,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.bold)),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: statusColor, width: 1),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(role,
              style: const TextStyle(
                  color: AppColors.textGrey, fontSize: 12)),
          const SizedBox(height: 8),
          Text(desc,
              style: const TextStyle(
                  color: AppColors.textGrey,
                  fontSize: 13,
                  height: 1.5)),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Settings list item
// ─────────────────────────────────────────────────────────────
class _SettingsItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _SettingsItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.color = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.borderColor),
      ),
      child: ListTile(
        leading: Icon(icon, color: color, size: 22),
        title: Text(label,
            style: TextStyle(
                color: color,
                fontSize: 15,
                fontWeight: FontWeight.w500)),
        trailing: const Icon(Icons.chevron_right,
            color: AppColors.textGrey, size: 20),
        onTap: onTap,
      ),
    );
  }
}