import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../bloc/auth_bloc.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailCtrl    = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool _rememberMe    = false;

  // ── Color palette (dekoratif — tetap) ──
  static const Color _accent        = Color(0xFF7C9EFF);
  static const Color _accentLight   = Color(0xFFB8CDFF);
  static const Color _accentBlue    = Color(0xFF4B6EF5);
  static const Color _accentDeep    = Color(0xFF3B5FD9);
  static const Color _accentVibrant = Color(0xFF5B7FFF);
  static const Color _green         = Color(0xFF4ADE80);
  static const Color _navyDark      = Color(0xFF0D1B3E);
  // Field bg — navy biru, tetap hardcoded karena beda dari cardBg
  static const Color _surface       = Color(0xFF1A2540);

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    final email    = _emailCtrl.text.trim();
    final password = _passwordCtrl.text;
    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }
    context.read<AuthBloc>().add(
          LoginRequested(email: email, password: password),
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          Navigator.pushReplacementNamed(context, '/dashboard');
        } else if (state is AuthFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.red,
            ),
          );
        }
      },
      child: Scaffold(
        // BG halaman — sama dengan ProfileScreen
        backgroundColor: AppColors.darkBlueBg,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded,
                color: _accent, size: 18),
            onPressed: () => Navigator.pop(context),
          ),
          title: ShaderMask(
            shaderCallback: (bounds) => const LinearGradient(
              colors: [_accent, _accentLight],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ).createShader(bounds),
            child: const Text(
              'PROJECTPALS',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
          ),
          centerTitle: true,
        ),
        body: Center(
          child: SingleChildScrollView(
            padding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: Container(
              constraints: const BoxConstraints(maxWidth: 400),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                // BG card — sama dengan ProfileScreen
                color: AppColors.cardBg,
                borderRadius: BorderRadius.circular(24),
                // Border card — sama dengan ProfileScreen
                border: Border.all(color: AppColors.borderColor),
                boxShadow: [
                  BoxShadow(
                    color: _accentVibrant.withOpacity(0.12),
                    blurRadius: 30,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // ── Icon rocket ──
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: _accent.withOpacity(0.1),
                      shape: BoxShape.circle,
                      // Border avatar — ikut cardBg biar seamless
                      border: Border.all(
                          color: AppColors.cardBg, width: 2),
                    ),
                    child: const Icon(Icons.rocket_launch_rounded,
                        color: _accent, size: 26),
                  ),
                  const SizedBox(height: 16),

                  // ── Title ──
                  const Text(
                    'Welcome Back',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.3,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Sign in to your command center',
                    style: TextStyle(
                        color: Colors.white.withOpacity(0.4),
                        fontSize: 13),
                  ),
                  const SizedBox(height: 32),

                  // ── Email ──
                  _buildTextField(
                    'EMAIL',
                    'budi@example.com',
                    controller: _emailCtrl,
                    icon: Icons.alternate_email_rounded,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 18),

                  // ── Password ──
                  _buildTextField(
                    'PASSWORD',
                    '••••••••',
                    controller: _passwordCtrl,
                    isPassword: true,
                    icon: Icons.lock_outline_rounded,
                  ),
                  const SizedBox(height: 14),

                  // ── Remember me + Forgot ──
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          SizedBox(
                            height: 22,
                            width: 22,
                            child: Checkbox(
                              value: _rememberMe,
                              activeColor: _accent,
                              checkColor: _navyDark,
                              side: BorderSide(
                                  color: Colors.white.withOpacity(0.2)),
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(4)),
                              onChanged: (v) =>
                                  setState(() => _rememberMe = v!),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Remember me',
                            style: TextStyle(
                                color: Colors.white.withOpacity(0.4),
                                fontSize: 12),
                          ),
                        ],
                      ),
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          'Forgot Password?',
                          style: TextStyle(
                            color: _accent.withOpacity(0.8),
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 26),

                  // ── Login button ──
                  BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, state) {
                      final isLoading = state is AuthLoading;
                      return GestureDetector(
                        onTap: isLoading ? null : _submit,
                        child: Container(
                          width: double.infinity,
                          height: 52,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [_accent, _accentLight],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: [
                              BoxShadow(
                                color: _accentVibrant.withOpacity(0.35),
                                blurRadius: 14,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Center(
                            child: isLoading
                                ? const SizedBox(
                                    width: 22,
                                    height: 22,
                                    child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Color(0xFF0D1B3E)),
                                  )
                                : const Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Login',
                                        style: TextStyle(
                                          color: Color(0xFF0D1B3E),
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(width: 8),
                                      Icon(
                                          Icons.arrow_forward_rounded,
                                          color: Color(0xFF0D1B3E),
                                          size: 18),
                                    ],
                                  ),
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 24),

                  // ── Register link ──
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account?  ",
                        style: TextStyle(
                            color: Colors.white.withOpacity(0.4),
                            fontSize: 13),
                      ),
                      GestureDetector(
                        onTap: () =>
                            Navigator.pushNamed(context, '/register'),
                        child: const Text(
                          'Register Now',
                          style: TextStyle(
                            color: _green,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    String hint, {
    required TextEditingController controller,
    bool isPassword = false,
    IconData? icon,
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: _accent.withOpacity(0.7),
            fontSize: 10,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.4,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: isPassword,
          keyboardType: keyboardType,
          style: const TextStyle(color: Colors.white, fontSize: 14),
          decoration: InputDecoration(
            prefixIcon: icon != null
                ? Icon(icon,
                    color: Colors.white.withOpacity(0.25), size: 19)
                : null,
            hintText: hint,
            hintStyle: TextStyle(
                color: Colors.white.withOpacity(0.2), fontSize: 13),
            filled: true,
            fillColor: _surface,
            contentPadding: const EdgeInsets.symmetric(
                horizontal: 16, vertical: 16),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide:
                  BorderSide(color: Colors.white.withOpacity(0.08)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: _accent.withOpacity(0.5)),
            ),
          ),
        ),
      ],
    );
  }
}