/// Hasil preview normalisasi nama role dari `POST /api/normalize-role`.
///
/// Backend yang menjalankan logika 2-layer (fuzzy DB lookup + AI fallback);
/// di sisi klien kita hanya menampilkan hasilnya.
class RoleNormalization {
  /// Input asli yang dikirim pengguna.
  final String original;

  /// Nama role kanonik hasil normalisasi.
  final String normalized;

  /// `true` jika [normalized] berbeda dari [original].
  final bool changed;

  const RoleNormalization({
    required this.original,
    required this.normalized,
    required this.changed,
  });
}
