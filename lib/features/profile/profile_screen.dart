import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/constants/app_colors.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthUnauthenticated) {
          Navigator.pushNamedAndRemoveUntil(
              context, '/login', (_) => false);
        }
      },
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          final user =
              state is AuthAuthenticated ? state.user : null;

          return Scaffold(
            backgroundColor: AppColors.darkBlueBg,
            body: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Profile',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        )),
                    const SizedBox(height: 24),

                    // Avatar card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: AppColors.cardBg,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppColors.borderColor),
                      ),
                      child: Column(
                        children: [
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              color: AppColors.primaryCyan
                                  .withValues(alpha: 0.15),
                              shape: BoxShape.circle,
                              border: Border.all(
                                  color: AppColors.primaryCyan
                                      .withValues(alpha: 0.4),
                                  width: 2),
                            ),
                            child: const Icon(Icons.person,
                                color: AppColors.primaryCyan, size: 40),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            user?.name ?? 'User',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            user?.username ?? '',
                            style: const TextStyle(
                                color: AppColors.primaryCyan,
                                fontSize: 14),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            user?.email ?? '',
                            style: const TextStyle(
                                color: AppColors.textGrey, fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Account section
                    const Text('Account',
                        style: TextStyle(
                          color: AppColors.textGrey,
                          fontSize: 11,
                          letterSpacing: 1.5,
                          fontWeight: FontWeight.w600,
                        )),
                    const SizedBox(height: 10),
                    _SettingsItem(
                        icon: Icons.person_outline,
                        label: 'Edit Profile',
                        onTap: () {}),
                    _SettingsItem(
                        icon: Icons.lock_outline,
                        label: 'Change Password',
                        onTap: () {}),
                    const SizedBox(height: 24),

                    // Session section
                    const Text('Session',
                        style: TextStyle(
                          color: AppColors.textGrey,
                          fontSize: 11,
                          letterSpacing: 1.5,
                          fontWeight: FontWeight.w600,
                        )),
                    const SizedBox(height: 10),
                    _SettingsItem(
                      icon: Icons.logout,
                      label: 'Logout',
                      color: AppColors.red,
                      onTap: () => _confirmLogout(context),
                    ),
                  ],
                ),
              ),
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
            side: const BorderSide(color: AppColors.borderColor)),
        title: const Text('Logout?',
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold)),
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
