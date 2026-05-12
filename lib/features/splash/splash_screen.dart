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
          curve:
              const Interval(0.2, 0.7, curve: Curves.fastOutSlowIn)),
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
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF020A1A),
                Color(0xFF081B4B),
                Color(0xFF020A1A),
              ],
            ),
          ),
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, _) {
              return Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 250,
                    height: 250,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue.withValues(alpha: 0.1),
                          blurRadius: 100,
                          spreadRadius: 50,
                        ),
                      ],
                    ),
                  ),
                  Transform.translate(
                    offset: Offset(0, _rocketFlyUp.value),
                    child: Opacity(
                      opacity: _rocketOpacity.value,
                      child: const Icon(Icons.rocket_launch,
                          color: Colors.blueAccent, size: 60),
                    ),
                  ),
                  Opacity(
                    opacity: _textOpacity.value,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'PROJECT',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 4,
                          ),
                        ),
                        Text(
                          'PALS',
                          style: TextStyle(
                            color: Colors.blue.shade300,
                            fontSize: 24,
                            fontWeight: FontWeight.w300,
                            letterSpacing: 8,
                          ),
                        ),
                        const SizedBox(height: 40),
                        Opacity(
                          opacity: _subTextOpacity.value,
                          child: const Text(
                            'VIRTUAL COLLABORATION ENGINE',
                            style: TextStyle(
                                color: Colors.white54,
                                fontSize: 10,
                                letterSpacing: 2),
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
