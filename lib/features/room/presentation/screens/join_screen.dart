import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../bloc/room_bloc.dart';
import 'join_screen2.dart';

class JoinRoomScreen extends StatefulWidget {
  const JoinRoomScreen({super.key});

  @override
  State<JoinRoomScreen> createState() => _JoinRoomScreenState();
}

class _JoinRoomScreenState extends State<JoinRoomScreen> {
  final _codeCtrl = TextEditingController();

  // ── Palette dekoratif ──
  static const Color _accent        = Color(0xFF7C9EFF);
  static const Color _accentLight   = Color(0xFFB8CDFF);
  static const Color _accentBlue    = Color(0xFF4B6EF5);
  static const Color _accentVibrant = Color(0xFF5B7FFF);
  static const Color _green         = Color(0xFF4ADE80);
  static const Color _navyDark      = Color(0xFF0D1B3E);

  @override
  void dispose() {
    _codeCtrl.dispose();
    super.dispose();
  }

  void _validateCode() {
    final code = _codeCtrl.text.trim().toUpperCase();
    if (code.isEmpty) return;

    // ── MOCK: bypass backend, langsung ke JoinScreen2 ──
    final mockPreview = {
      'project_theme': 'Mock Project',
      'roles': [
        'Frontend Developer',
        'Backend Developer',
        'UI/UX Designer',
        'Project Manager'
      ],
      'max_per_group': 4,
      'number_of_groups': 3,
    };

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: context.read<RoomBloc>(),
          child: JoinScreen2(
            preview: mockPreview,
            roomCode: code,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RoomBloc, RoomState>(
      listener: (context, state) {
        if (state is RoomFailure) {
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
          // AppBar — gradient biru palette baru
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF4B6EF5), Color(0xFF7C9EFF)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
            ),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.close,
                color: Color(0xFF0D1B3E), size: 22),
            onPressed: () => Navigator.of(context).maybePop(),
          ),
          title: const Text(
            'Join Room',
            style: TextStyle(
              color: Color(0xFF0D1B3E),
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          centerTitle: true,
        ),
        body: _EnterCodeStep(
          controller: _codeCtrl,
          onValidate: _validateCode,
        ),
      ),
    );
  }
}

// ── Enter Code Step ────────────────────────────────────────────────────────────
class _EnterCodeStep extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onValidate;

  static const Color _accent        = Color(0xFF7C9EFF);
  static const Color _accentLight   = Color(0xFFB8CDFF);
  static const Color _accentBlue    = Color(0xFF4B6EF5);
  static const Color _accentVibrant = Color(0xFF5B7FFF);
  static const Color _green         = Color(0xFF4ADE80);
  static const Color _navyDark      = Color(0xFF0D1B3E);

  const _EnterCodeStep(
      {required this.controller, required this.onValidate});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // ── Hero Section ─────────────────────────────────────────
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(24, 48, 24, 40),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  const Color(0xFF0A1628),
                  AppColors.darkBlueBg,
                ],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Badge label — pakai gradient biru baru
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 7),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: _accent.withOpacity(0.55),
                      width: 1,
                    ),
                  ),
                  child: const Text(
                    'FIND YOUR GROUP',
                    style: TextStyle(
                      color: _accent,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Hero title
                const Text(
                  'Find your people.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                    height: 1.15,
                  ),
                ),
                // Subtitle — gradient teks
                ShaderMask(
                  shaderCallback: (bounds) => const LinearGradient(
                    colors: [_accent, _accentLight],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ).createShader(bounds),
                  child: const Text(
                    'Build your project.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                      height: 1.15,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Connect with developers and designers\nglobally to bring your vision to life.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.4),
                    fontSize: 14,
                    height: 1.6,
                  ),
                ),
              ],
            ),
          ),

          // ── Input Section ─────────────────────────────────────────
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            child: Column(
              children: [
                // Code input field
                TextField(
                  controller: controller,
                  textCapitalization: TextCapitalization.characters,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    letterSpacing: 2,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Enter Unique Room Code',
                    hintStyle: TextStyle(
                      color: Colors.white.withOpacity(0.25),
                      fontSize: 14,
                      letterSpacing: 0,
                    ),
                    prefixIcon: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      child: Icon(
                        Icons.vpn_key_outlined,
                        color: _accent.withOpacity(0.7),
                        size: 20,
                      ),
                    ),
                    prefixIconConstraints: const BoxConstraints(
                      minWidth: 50,
                      minHeight: 50,
                    ),
                    filled: true,
                    // BG card — sama dengan ProfileScreen
                    fillColor: AppColors.cardBg,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 18),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      // Border — sama dengan ProfileScreen
                      borderSide:
                          BorderSide(color: AppColors.borderColor),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(
                          color: _accent.withOpacity(0.6), width: 1.5),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // JOIN ROOM button — gradient biru palette baru
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: GestureDetector(
                    onTap: onValidate,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [_accent, _accentLight],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        borderRadius: BorderRadius.circular(28),
                        boxShadow: [
                          BoxShadow(
                            color: _accentVibrant.withOpacity(0.35),
                            blurRadius: 14,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'JOIN ROOM',
                            style: TextStyle(
                              color: Color(0xFF0D1B3E),
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.2,
                            ),
                          ),
                          SizedBox(width: 8),
                          Icon(
                            Icons.arrow_forward_rounded,
                            color: Color(0xFF0D1B3E),
                            size: 18,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}