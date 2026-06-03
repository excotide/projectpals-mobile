import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/errors/exceptions.dart';
import '../../domain/entities/role_normalization.dart';
import '../../domain/usecases/normalize_role_usecase.dart';

/// State untuk preview normalisasi role di form create room.
sealed class RoleNormalizerState {
  const RoleNormalizerState();
}

/// Belum ada input / sudah di-reset.
class RoleNormalizerIdle extends RoleNormalizerState {
  const RoleNormalizerIdle();
}

/// Sedang menanyakan normalisasi ke backend.
class RoleNormalizerLoading extends RoleNormalizerState {
  final String input;
  const RoleNormalizerLoading(this.input);
}

/// Hasil normalisasi siap ditampilkan.
class RoleNormalizerSuccess extends RoleNormalizerState {
  final RoleNormalization result;
  const RoleNormalizerSuccess(this.result);
}

/// Gagal (mis. jaringan) — UI tetap boleh menambah role mentah.
class RoleNormalizerError extends RoleNormalizerState {
  final String message;
  const RoleNormalizerError(this.message);
}

/// Memetakan input role bebas → role kanonik lewat backend.
///
/// Logika 2-layer (fuzzy DB + AI fallback) berjalan di server; cubit ini
/// hanya men-debounce input untuk preview dan menyediakan [resolve] yang
/// awaitable saat role benar-benar ditambahkan.
class RoleNormalizerCubit extends Cubit<RoleNormalizerState> {
  final NormalizeRoleUseCase normalizeRoleUseCase;

  Timer? _debounce;
  int _requestId = 0;

  RoleNormalizerCubit(this.normalizeRoleUseCase)
      : super(const RoleNormalizerIdle());

  /// Preview ter-debounce saat pengguna mengetik.
  void previewDebounced(
    String role, {
    Duration delay = const Duration(milliseconds: 450),
  }) {
    _debounce?.cancel();
    final trimmed = role.trim();
    if (trimmed.isEmpty) {
      _requestId++; // batalkan request lama
      emit(const RoleNormalizerIdle());
      return;
    }
    _debounce = Timer(delay, () => _preview(trimmed));
  }

  Future<void> _preview(String role) async {
    final id = ++_requestId;
    emit(RoleNormalizerLoading(role));
    try {
      final result = await normalizeRoleUseCase(role);
      if (id != _requestId) return; // hasil sudah usang
      emit(RoleNormalizerSuccess(result));
    } on ServerException catch (e) {
      if (id != _requestId) return;
      emit(RoleNormalizerError(e.message));
    } catch (_) {
      if (id != _requestId) return;
      emit(const RoleNormalizerError('Network error'));
    }
  }

  /// Resolusi final saat role ditambahkan. Mengembalikan nama kanonik;
  /// jika API gagal, fallback ke input yang sudah di-trim.
  Future<String> resolve(String role) async {
    _debounce?.cancel();
    _requestId++; // batalkan preview yang tertunda
    final trimmed = role.trim();
    if (trimmed.isEmpty) return trimmed;
    try {
      final result = await normalizeRoleUseCase(trimmed);
      return result.normalized.trim().isNotEmpty
          ? result.normalized.trim()
          : trimmed;
    } catch (_) {
      return trimmed;
    }
  }

  void reset() {
    _debounce?.cancel();
    _requestId++;
    emit(const RoleNormalizerIdle());
  }

  @override
  Future<void> close() {
    _debounce?.cancel();
    return super.close();
  }
}
