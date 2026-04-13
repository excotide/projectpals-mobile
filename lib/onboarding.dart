import 'package:flutter/material.dart';
import 'register_screen.dart'; // Memastikan navigasi ke RegisterScreen bisa jalan

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // HEX COLOR AKURAT
  final Color primaryCyan = const Color(0xFF4FC3F7); 
  final Color mintGreen = const Color(0xFF42E38D);
  final Color darkCard = const Color(0xFF0D1B2A);

  void _nextPage() {
    if (_currentPage < 2) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  void _skipToLast() {
    _pageController.animateToPage(2,
        duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Kita pakai Stack agar gradasi benar-benar mengisi seluruh layar
      body: Stack(
        children: [
          // 1. BACKGROUND GRADASI (Plek Ketiplek)
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0.0, 0.5, 1.0],
                colors: [
                  Color(0xFF020A1A), // Hitam atas
                  Color(0xFF081B4B), // Biru gelap tengah
                  Color(0xFF020A1A), // Hitam bawah
                ],
              ),
            ),
          ),
          
          // 2. CONTENT
          SafeArea(
            child: Column(
              children: [
                _buildAppBar(),
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    onPageChanged: (index) => setState(() => _currentPage = index),
                    children: [
                      _buildOnboarding1(),
                      _buildOnboarding2(),
                      _buildOnboarding3(),
                    ],
                  ),
                ),
                _buildBottomSection(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back, color: primaryCyan),
            onPressed: () {
              if (_currentPage > 0) {
                _pageController.previousPage(
                    duration: const Duration(milliseconds: 300), curve: Curves.ease);
              }
            },
          ),
          const Text(
            "PROJECTPALS",
            style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
                letterSpacing: 4),
          ),
          _currentPage < 2 
            ? TextButton(
                onPressed: _skipToLast,
                child: Text("SKIP", style: TextStyle(color: primaryCyan, fontWeight: FontWeight.bold)),
              )
            : const SizedBox(width: 48),
        ],
      ),
    );
  }

  // --- HALAMAN 1 (Find Your Perfect Match) ---
  Widget _buildOnboarding1() {
    return _pageContent(
      title: "Find Your Perfect Match",
      desc: "Our neural engine analyzes skills and personality traits to find your perfect co-builders.",
      illustration: Container(
        width: 240, height: 240,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.03),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: Colors.white10),
          boxShadow: [BoxShadow(color: primaryCyan.withOpacity(0.1), blurRadius: 40)],
        ),
        child: Icon(Icons.hub_rounded, size: 120, color: primaryCyan),
      ),
    );
  }

  // --- HALAMAN 2 (Build Your Reputation) ---
  Widget _buildOnboarding2() {
    return _pageContent(
      title: "Build Your Reputation",
      desc: "Reputation-based ecosystem ensuring commitment and high-quality collaborative outputs.",
      illustration: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          Container(
            width: 200, height: 220,
            decoration: BoxDecoration(
              color: darkCard,
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: Colors.white10),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.verified_user, size: 80, color: primaryCyan),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (i) => Icon(Icons.star, color: mintGreen, size: 18)),
                ),
                const Text("TRUST INDEX: 98%", style: TextStyle(color: Colors.white38, fontSize: 10)),
              ],
            ),
          ),
          Positioned(top: -10, right: -30, child: _tag("Commitment", mintGreen)),
          Positioned(bottom: 30, left: -40, child: _tag("High Quality", primaryCyan)),
        ],
      ),
    );
  }

  // --- HALAMAN 3 (Stay on Target) ---
  Widget _buildOnboarding3() {
    return _pageContent(
      title: "Stay on Target",
      desc: "Real-time milestone visualization with Mint-status indicators for peak performance.",
      highlight: "Mint-status indicators",
      illustration: Container(
        padding: const EdgeInsets.all(20),
        width: 300, height: 180,
        decoration: BoxDecoration(color: darkCard, borderRadius: BorderRadius.circular(20)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("PITSTOP PROJECT", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                Text("84%", style: TextStyle(color: primaryCyan, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 15),
            LinearProgressIndicator(value: 0.84, backgroundColor: Colors.white10, color: primaryCyan),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _step("INIT", true), _step("DESIGN", true), _step("BUILD", false, current: true), _step("LAUNCH", false),
              ],
            )
          ],
        ),
      ),
    );
  }

  // --- REUSABLE COMPONENTS ---

  Widget _pageContent({required String title, required String desc, required Widget illustration, String? highlight}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          illustration,
          const SizedBox(height: 40),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, height: 1.2),
              children: [
                TextSpan(text: title.substring(0, title.lastIndexOf(" ") + 1)),
                TextSpan(text: title.split(" ").last, style: TextStyle(color: primaryCyan)),
              ],
            ),
          ),
          const SizedBox(height: 20),
          _buildDescText(desc, highlight),
        ],
      ),
    );
  }

  Widget _buildDescText(String text, String? highlight) {
    if (highlight == null) {
      return Text(text, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white60, fontSize: 14));
    }
    var parts = text.split(highlight);
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: const TextStyle(color: Colors.white60, fontSize: 14, height: 1.5),
        children: [
          TextSpan(text: parts[0]),
          TextSpan(text: highlight, style: TextStyle(color: mintGreen, fontWeight: FontWeight.bold)),
          TextSpan(text: parts[1]),
        ],
      ),
    );
  }

  Widget _tag(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF020A1A),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Text(text, style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold)),
    );
  }

  Widget _step(String label, bool done, {bool current = false}) {
    return Column(
      children: [
        Icon(done ? Icons.check_circle : (current ? Icons.radio_button_checked : Icons.circle),
            color: done ? mintGreen : (current ? primaryCyan : Colors.white10), size: 20),
        Text(label, style: const TextStyle(color: Colors.white38, fontSize: 8)),
      ],
    );
  }

  Widget _buildBottomSection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(30, 0, 30, 50),
      child: Column(
        children: [
          Row(
            children: List.generate(3, (i) => Container(
              margin: const EdgeInsets.only(right: 8),
              width: 8, height: 8,
              decoration: BoxDecoration(shape: BoxShape.circle, color: _currentPage == i ? primaryCyan : Colors.white10),
            )),
          ),
          const SizedBox(height: 30),
          SizedBox(
            width: double.infinity, height: 55,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: _currentPage == 2 ? mintGreen : primaryCyan,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              ),
              onPressed: () {
                if (_currentPage < 2) {
                  _nextPage();
                } else {
                  // Navigasi ke Register Screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const RegisterScreen()),
                  );
                }
              },
              child: Text(_currentPage == 2 ? "Start >" : "Next >", 
                  style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18)),
            ),
          ),
        ],
      ),
    );
  }
}