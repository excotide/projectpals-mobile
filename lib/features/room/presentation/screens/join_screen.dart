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
  String? _pendingCode;

  @override
  void dispose() {
    _codeCtrl.dispose();
    super.dispose();
  }

  void _validateCode() {
    final code = _codeCtrl.text.trim().toUpperCase();
    if (code.isEmpty) return;

    // Ambil preview room dari API sebelum lanjut memilih peran.
    setState(() => _pendingCode = code);
    context.read<RoomBloc>().add(RoomPreviewRequested(code));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RoomBloc, RoomState>(
      listener: (context, state) {
        if (state is RoomPreviewLoaded && _pendingCode != null) {
          final code = _pendingCode!;
          _pendingCode = null;
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => BlocProvider.value(
                value: context.read<RoomBloc>(),
                child: JoinScreen2(
                  preview: state.preview,
                  roomCode: code,
                ),
              ),
            ),
          );
        } else if (state is RoomFailure) {
          _pendingCode = null;
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
  static const Color _accentVibrant = Color(0xFF5B7FFF);

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
                      color: _accent.withValues(alpha: 0.55),
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
                    color: Colors.white.withValues(alpha: 0.4),
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
                      color: Colors.white.withValues(alpha: 0.25),
                      fontSize: 14,
                      letterSpacing: 0,
                    ),
                    prefixIcon: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      child: Icon(
                        Icons.vpn_key_outlined,
                        color: _accent.withValues(alpha: 0.7),
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
                          color: _accent.withValues(alpha: 0.6), width: 1.5),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // JOIN ROOM button — gradient biru palette baru
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: BlocBuilder<RoomBloc, RoomState>(
                    builder: (context, state) {
                      final isLoading = state is RoomLoading;
                      return GestureDetector(
                        onTap: isLoading ? null : onValidate,
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
                                color: _accentVibrant.withValues(alpha: 0.35),
                                blurRadius: 14,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: isLoading
                              ? const Center(
                                  child: SizedBox(
                                    width: 22,
                                    height: 22,
                                    child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Color(0xFF0D1B3E)),
                                  ),
                                )
                              : const Row(
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
                      );
                    },
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