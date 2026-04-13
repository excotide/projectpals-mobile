import 'package:flutter/material.dart';

class JoinScreen extends StatelessWidget {
  const JoinScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Definisi Warna sesuai Gambar
    const Color primaryCyan = Color(0xFF3CD7FF);
    const Color darkBlueBg = Color(0xFF041329); // Background gelap mendalam
    const Color inputBg = Color(0xFF0D1B2A); // Warna kotak input

    return Scaffold(
      backgroundColor: darkBlueBg,
      body: SafeArea(
        child: Column(
          children: [
            // --- HEADER ---
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
              color: primaryCyan,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.close, color: Color(0xFF003642), size: 28),
                  ),
                  const Text(
                    "Join Room",
                    style: TextStyle(
                      color: Color(0xFF003642),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 40), // Spacer agar teks tetap di tengah
                ],
              ),
            ),

            // --- ISI KONTEN ---
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 30),
                decoration: const BoxDecoration(
                  // Efek gradasi halus dari atas ke bawah sesuai gambar
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xFF051C36), darkBlueBg],
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Label Atas
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white24),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        "FIND YOUR GROUP",
                        style: TextStyle(
                          color: primaryCyan,
                          fontSize: 12,
                          letterSpacing: 1.2,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),

                    // Headline Besar
                    const Text(
                      "Find your people.\nBuild your project.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Sub-headline
                    const Text(
                      "Connect with developers and designers\nglobally to bring your vision to life.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white54,
                        fontSize: 14,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 40),

                    // Input Field (Unique Room Code) - UPDATED WITH withValues
                    Container(
                      decoration: BoxDecoration(
                        color: inputBg.withValues(alpha: 0.5), // Sudah diperbarui
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.white10),
                      ),
                      child: const TextField(
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: "Enter Unique Room Code",
                          hintStyle: TextStyle(color: Colors.white24, fontSize: 14),
                          prefixIcon: Icon(Icons.key_outlined, color: primaryCyan),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 18),
                        ),
                      ),
                    ),
                    const SizedBox(height: 25),

                    // Tombol Join Room
                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryCyan,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        onPressed: () {},
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "JOIN ROOM",
                              style: TextStyle(
                                color: Color(0xFF003642),
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(width: 8),
                            Icon(Icons.arrow_forward, color: Color(0xFF003642), size: 20),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      // --- BOTTOM NAVIGATION BAR ---
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF05101C),
        type: BottomNavigationBarType.fixed,
        currentIndex: 1, // Aktif di menu JOIN
        selectedItemColor: const Color(0xFF42E38D),
        unselectedItemColor: Colors.white38,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.grid_view_rounded), label: "HOME"),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: "JOIN"),
          BottomNavigationBarItem(icon: Icon(Icons.analytics_outlined), label: "ROOMS"),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: "PROFILE"),
        ],
      ),
    );
  }
}