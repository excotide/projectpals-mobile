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
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool _rememberMe = false;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    final email = _emailCtrl.text.trim();
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
        backgroundColor: AppColors.darkBlueBg,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.primaryCyan),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text(
            'PROJECTPALS',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
              letterSpacing: 4,
            ),
          ),
          centerTitle: true,
        ),
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              constraints: const BoxConstraints(maxWidth: 400),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFF0D1B2A).withValues(alpha: 0.8),
                borderRadius: BorderRadius.circular(25),
                border: Border.all(color: Colors.white10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  )
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Welcome Back',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Sign in to your command center',
                    style: TextStyle(
                        color: AppColors.textGrey, fontSize: 14),
                  ),
                  const SizedBox(height: 40),
                  _buildTextField('EMAIL', 'budi@example.com',
                      controller: _emailCtrl,
                      icon: Icons.alternate_email,
                      keyboardType: TextInputType.emailAddress),
                  const SizedBox(height: 20),
                  _buildTextField('PASSWORD', '••••••••',
                      controller: _passwordCtrl,
                      isPassword: true,
                      icon: Icons.lock_outline),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          SizedBox(
                            height: 24,
                            width: 24,
                            child: Checkbox(
                              value: _rememberMe,
                              activeColor: AppColors.primaryCyan,
                              checkColor: AppColors.darkBlueBg,
                              side: const BorderSide(color: Colors.white24),
                              onChanged: (v) =>
                                  setState(() => _rememberMe = v!),
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Text('Remember me',
                              style: TextStyle(
                                  color: AppColors.textGrey, fontSize: 12)),
                        ],
                      ),
                      TextButton(
                        onPressed: () {},
                        child: const Text('Forgot Password?',
                            style: TextStyle(
                              color: AppColors.primaryCyan,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            )),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, state) {
                      final isLoading = state is AuthLoading;
                      return SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primaryCyan
                                    .withValues(alpha: 0.3),
                                blurRadius: 15,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryCyan,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              elevation: 0,
                            ),
                            onPressed: isLoading ? null : _submit,
                            child: isLoading
                                ? const SizedBox(
                                    width: 22,
                                    height: 22,
                                    child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Color(0xFF003642)),
                                  )
                                : const Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.center,
                                    children: [
                                      Text('Login',
                                          style: TextStyle(
                                            color: Color(0xFF003642),
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          )),
                                      SizedBox(width: 10),
                                      Icon(Icons.arrow_forward,
                                          color: Color(0xFF003642),
                                          size: 20),
                                    ],
                                  ),
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 25),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't have an account? ",
                          style: TextStyle(
                              color: AppColors.textGrey, fontSize: 13)),
                      GestureDetector(
                        onTap: () =>
                            Navigator.pushNamed(context, '/register'),
                        child: const Text('Register Now',
                            style: TextStyle(
                              color: AppColors.mintGreen,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            )),
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
        Text(label,
            style: const TextStyle(
              color: AppColors.mintGreen,
              fontSize: 11,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            )),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: isPassword,
          keyboardType: keyboardType,
          style: const TextStyle(color: Colors.white, fontSize: 14),
          decoration: InputDecoration(
            prefixIcon: icon != null
                ? Icon(icon, color: Colors.white24, size: 20)
                : null,
            hintText: hint,
            hintStyle: const TextStyle(color: Colors.white24),
            filled: true,
            fillColor: const Color(0xFF05101C),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.white10),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                  color: AppColors.primaryCyan.withValues(alpha: 0.6)),
            ),
          ),
        ),
      ],
    );
  }
}
