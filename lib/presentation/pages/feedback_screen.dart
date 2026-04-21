import 'package:flutter/material.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Tema Warna Spesifik (Sesuai Gambar Target)
// ─────────────────────────────────────────────────────────────────────────────
const Color _cyanNeon = Color(0xFF3CD7FF); // Cyan terang untuk neon & tombol
const Color _darkBg = Color(0xFF020B1A); // Background super gelap kebiruan
const Color _inputBg = Color(0xFF081529); // Background input field sedikit lebih terang
const Color _textGrey = Color(0xFF8B9BB4); // Warna teks label & hint
const Color _borderGrey = Color(0xFF1E2D40); // Warna border input
const Color _mintCheck = Color(0xFF34E39B); // Warna hijau mint untuk checkmark

class FeedbackScreen extends StatefulWidget {
  final Map<String, dynamic> room;
  final Map<String, dynamic> member;

  const FeedbackScreen({
    super.key,
    required this.room,
    required this.member,
  });

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final TextEditingController _commentController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // Memastikan nama room dan member ada, jika dummy kosong
    final String roomName = widget.room['name']?.toString().toUpperCase() ?? 'DRINKEDIN';
    final String username = widget.member['username'] ?? '@Labje';
    final String role = widget.member['role']?.toString().toUpperCase() ?? 'BACK-END';

    return Scaffold(
      backgroundColor: _darkBg,
      // ── AppBar Costum (Sangat Minimalis) ──────────────────────────────────
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: _cyanNeon, size: 22),
          onPressed: () => Navigator.of(context).pop(),
        ),
        titleSpacing: 0,
        title: Text(
          roomName,
          style: const TextStyle(
            color: _cyanNeon,
            fontWeight: FontWeight.w900, // Sangat tebal sesuai gambar
            fontSize: 19,
            letterSpacing: 1.5,
          ),
        ),
        centerTitle: false,
      ),
      // ── Body ──────────────────────────────────────────────────────────────
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 30),

            // ── Bagian Profil Avatar (Desain Neon) ──────────────────────────
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                Container(
                  width: 130,
                  height: 130,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    // Border neon tipis kebiruan
                    border: Border.all(color: _cyanNeon.withValues(alpha: 0.3), width: 1.5),
                    // Efek Glow Neon Halus di belakang avatar
                    boxShadow: [
                      BoxShadow(
                        color: _cyanNeon.withValues(alpha: 0.15),
                        blurRadius: 30,
                        spreadRadius: 2,
                      )
                    ],
                  ),
                  child: ClipOval(
                    child: Image.network(
                      // Placeholder gambar pria sesuai target
                      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTV3b8Xm365XN7m7yM4wU1W5z5z_q1R4O5_vQ&s', 
                      fit: BoxFit.cover,
                      // Fallback jika gambar gagal dimuat
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: _inputBg,
                        child: const Icon(Icons.person, color: Colors.white24, size: 60),
                      ),
                    ),
                  ),
                ),
                // Badge Checkmark Hijau Mint
                Container(
                  transform: Matrix4.translationValues(-5, -5, 0), // Sedikit digeser masuk
                  padding: const EdgeInsets.all(5),
                  decoration: const BoxDecoration(
                    color: _mintCheck,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.check, color: Colors.black, size: 18),
                ),
              ],
            ),
            const SizedBox(height: 20),
            
            // Username
            Text(
              username,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
            // Role (Kecil, Abu-abu, Letter Spacing Lebar)
            Text(
              role,
              style: const TextStyle(
                color: _textGrey,
                fontSize: 12,
                fontWeight: FontWeight.w500,
                letterSpacing: 3,
              ),
            ),
            const SizedBox(height: 40),

            // ── Input: Choose Date ──────────────────────────────────────────
            _buildLabel("CHOOSE DATE"),
            _buildTextField(
              controller: _dateController,
              hint: "", // Kosong sesuai gambar
              maxLines: 1,
              height: 60, // Sedikit lebih tinggi
            ),

            const SizedBox(height: 30),

            // ── Input: Comments ─────────────────────────────────────────────
            _buildLabel("COMMENTS"),
            _buildTextField(
              controller: _commentController,
              hint: "Provide technical insights or peer observations...",
              maxLines: 8, // Lebih tinggi untuk komentar
            ),

            const SizedBox(height: 50),

            // ── Tombol SEND (Cyan Menyala) ─────────────────────────────────
            Container(
              width: double.infinity,
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                // Efek Glow Neon di bawah tombol
                boxShadow: [
                  BoxShadow(
                    color: _cyanNeon.withValues(alpha: 0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 5),
                  )
                ],
              ),
              child: ElevatedButton(
                onPressed: () {
                  // Tambahkan logika submit di sini
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: _cyanNeon,
                  foregroundColor: Colors.black,
                  elevation: 0, // Matikan elevasi default agar shadow custom terlihat
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text(
                  'SEND',
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 17,
                    letterSpacing: 2,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30), // Padding bawah
          ],
        ),
      ),
    );
  }

  // Helper untuk membuat Label Input (Abu-abu, Tebal, Huruf Besar)
  Widget _buildLabel(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 10.0, left: 2),
        child: Text(
          text.toUpperCase(),
          style: const TextStyle(
            color: _textGrey,
            fontSize: 13,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.2,
          ),
        ),
      ),
    );
  }

  // Helper untuk membuat Text Field custom (Gelap, Border Halus)
  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required int maxLines,
    double? height,
  }) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: _inputBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _borderGrey, width: 1.5),
      ),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        style: const TextStyle(color: Colors.white, fontSize: 15, height: 1.4),
        decoration: InputDecoration(
          hintText: hint,
          // Hint text sangat transparan sesuai target
          hintStyle: TextStyle(color: _textGrey.withValues(alpha: 0.25), fontSize: 15),
          contentPadding: const EdgeInsets.all(20),
          border: InputBorder.none, // Matikan border default TextField
        ),
      ),
    );
  }
}