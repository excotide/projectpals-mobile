import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../auth/presentation/bloc/auth_bloc.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _rocketFlyUp;
  late Animation<double> _rocketOpacity;
  late Animation<double> _textOpacity;
  late Animation<double> _subTextOpacity;

  // ── Color palette (sesuai design terbaru) ──
  static const Color _bg1        = Color(0xFF0D1117);
  static const Color _bg2        = Color(0xFF0D1B3E);
  static const Color _accent     = Color(0xFF7C9EFF);
  static const Color _accentLight= Color(0xFFB8CDFF);
  static const Color _accentBlue = Color(0xFF4B6EF5);
  static const Color _accentDark = Color(0xFF3B5FD9);
  static const Color _green      = Color(0xFF4ADE80);

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );

    _rocketOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
          parent: _controller,
          curve: const Interval(0.0, 0.2, curve: Curves.easeIn)),
    );
    _rocketFlyUp = Tween<double>(begin: 50.0, end: -300.0).animate(
      CurvedAnimation(
          parent: _controller,
          curve: const Interval(0.2, 0.7, curve: Curves.fastOutSlowIn)),
    );
    _textOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
          parent: _controller,
          curve: const Interval(0.5, 0.8, curve: Curves.easeIn)),
    );
    _subTextOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
          parent: _controller,
          curve: const Interval(0.8, 1.0, curve: Curves.easeIn)),
    );

    _controller.forward();

    Future.delayed(const Duration(milliseconds: 4200), () {
      if (!mounted) return;
      context.read<AuthBloc>().add(AuthCheckRequested());
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          Navigator.pushReplacementNamed(context, '/dashboard');
        } else if (state is AuthUnauthenticated) {
          Navigator.pushReplacementNamed(context, '/onboarding');
        }
      },
      child: Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            // ── Background gradient gelap navy → hitam, sesuai tema app ──
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF0D1117), // hitam gelap
                Color(0xFF0D1B3E), // navy gelap
                Color(0xFF0D1117), // hitam gelap
              ],
            ),
          ),
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, _) {
              return Stack(
                alignment: Alignment.center,
                children: [
                  // ── Glow lingkaran biru di tengah ──
                  Container(
                    width: 280,
                    height: 280,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF4B6EF5).withOpacity(0.15),
                          blurRadius: 120,
                          spreadRadius: 60,
                        ),
                      ],
                    ),
                  ),

                  // ── Glow kedua, lebih kecil, lebih terang ──
                  Container(
                    width: 140,
                    height: 140,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF7C9EFF).withOpacity(0.12),
                          blurRadius: 80,
                          spreadRadius: 30,
                        ),
                      ],
                    ),
                  ),

                  // ── Roket terbang ke atas ──
                  Transform.translate(
                    offset: Offset(0, _rocketFlyUp.value),
                    child: Opacity(
                      opacity: _rocketOpacity.value,
                      child: ShaderMask(
                        shaderCallback: (bounds) => const LinearGradient(
                          colors: [_accent, _accentLight],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ).createShader(bounds),
                        child: const Icon(
                          Icons.rocket_launch_rounded,
                          color: Colors.white, // warna di-override ShaderMask
                          size: 64,
                        ),
                      ),
                    ),
                  ),

                  // ── Teks PROJECT PALS + subtitle ──
                  Opacity(
                    opacity: _textOpacity.value,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // "PROJECT" — putih
                        ShaderMask(
                          shaderCallback: (bounds) => const LinearGradient(
                            colors: [Colors.white, Color(0xFFE0E8FF)],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ).createShader(bounds),
                          child: const Text(
                            'PROJECT',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 30,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 6,
                            ),
                          ),
                        ),

                        // "PALS" — gradient biru
                        ShaderMask(
                          shaderCallback: (bounds) => const LinearGradient(
                            colors: [_accent, _accentLight],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ).createShader(bounds),
                          child: const Text(
                            'PALS',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 26,
                              fontWeight: FontWeight.w300,
                              letterSpacing: 10,
                            ),
                          ),
                        ),

                        const SizedBox(height: 44),

                        // Subtitle
                        Opacity(
                          opacity: _subTextOpacity.value,
                          child: Column(
                            children: [
                              const Text(
                                'VIRTUAL COLLABORATION ENGINE',
                                style: TextStyle(
                                  color: Color(0x80FFFFFF),
                                  fontSize: 10,
                                  letterSpacing: 2.5,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 20),

                              // ── Loading dots ──
                              _LoadingDots(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

// ── Loading Dots ───────────────────────────────────────────────────────────────
// Tiga titik kecil animasi sebagai indikator loading

class _LoadingDots extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _dot(const Color(0xFF7C9EFF)),
        const SizedBox(width: 6),
        _dot(const Color(0xFFB8CDFF)),
        const SizedBox(width: 6),
        _dot(const Color(0xFF4B6EF5)),
      ],
    );
  }

  Widget _dot(Color color) {
    return Container(
      width: 5,
      height: 5,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.5),
            blurRadius: 6,
            spreadRadius: 1,
          ),
        ],
      ),
    );
  }
}