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
        backgroundColor: AppColors.darkBlueBg,
        appBar: AppBar(
          backgroundColor: AppColors.primaryCyan,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.close, color: Colors.black, size: 22),
            onPressed: () => Navigator.of(context).maybePop(),
          ),
          title: const Text(
            'Join Room',
            style: TextStyle(
              color: Colors.black,
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

// ── Enter Code ─────────────────────────────────────────────────────────────────
class _EnterCodeStep extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onValidate;
  const _EnterCodeStep({required this.controller, required this.onValidate});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // ── Hero Section ──
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(24, 48, 24, 40),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF0A1628),
                  AppColors.darkBlueBg,
                ],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Badge label
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 7),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: AppColors.primaryCyan.withValues(alpha: 0.6),
                      width: 1,
                    ),
                  ),
                  child: const Text(
                    'FIND YOUR GROUP',
                    style: TextStyle(
                      color: AppColors.primaryCyan,
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
                const Text(
                  'Build your project.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.primaryCyan,
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                    height: 1.15,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Connect with developers and designers\nglobally to bring your vision to life.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.textGrey,
                    fontSize: 14,
                    height: 1.6,
                  ),
                ),
              ],
            ),
          ),

          // ── Input Section ──
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
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
                    hintStyle: const TextStyle(
                      color: Colors.white38,
                      fontSize: 14,
                      letterSpacing: 0,
                    ),
                    prefixIcon: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 14),
                      child: Icon(
                        Icons.vpn_key_outlined,
                        color: AppColors.primaryCyan,
                        size: 20,
                      ),
                    ),
                    prefixIconConstraints: const BoxConstraints(
                      minWidth: 50,
                      minHeight: 50,
                    ),
                    filled: true,
                    fillColor: AppColors.inputBg,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 18),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide:
                          const BorderSide(color: AppColors.borderColor),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide:
                          const BorderSide(color: AppColors.primaryCyan),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // JOIN ROOM button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: BlocBuilder<RoomBloc, RoomState>(
                    builder: (context, state) {
                      final isLoading = state is RoomLoading;
                      return ElevatedButton(
                        onPressed: isLoading ? null : onValidate,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryCyan,
                          disabledBackgroundColor:
                              AppColors.primaryCyan.withValues(alpha: 0.4),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(28)),
                          elevation: 0,
                        ),
                        child: isLoading
                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                    strokeWidth: 2, color: Color(0xFF003642)),
                              )
                            : const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'JOIN ROOM',
                                    style: TextStyle(
                                      color: Color(0xFF003642),
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1.2,
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Icon(
                                    Icons.arrow_forward_rounded,
                                    color: Color(0xFF003642),
                                    size: 18,
                                  ),
                                ],
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