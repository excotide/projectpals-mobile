import 'package:flutter/material.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Onboarding Screen
// ─────────────────────────────────────────────────────────────────────────────
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageCtrl = PageController();
  int _currentPage = 0;

  // ── Tema ──────────────────────────────────────────────────────────────────
  static const Color _cyan = Color(0xFF3CD7FF);
  static const Color _darkBg = Color(0xFF041329);
  static const Color _cardBg = Color(0xFF0A1F35);
  static const Color _mintGreen = Color(0xFF42E38D);
  static const Color _textGrey = Color(0xFFC5C6CD);
  static const Color _border = Color(0xFF1A3A55);

  void _next() {
    if (_currentPage < 2) {
      _pageCtrl.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      // Start goes to login after onboarding
      Navigator.of(context).pushReplacementNamed('/login');
    }
  }

  void _skip() {
    Navigator.of(context).pushReplacementNamed('/login');
  }

  @override
  void dispose() {
    _pageCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _darkBg,
      body: SafeArea(
        child: Column(
          children: [
            // ── AppBar ────────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Back button
                  _currentPage > 0
                      ? GestureDetector(
                          onTap: () => _pageCtrl.previousPage(
                            duration: const Duration(milliseconds: 400),
                            curve: Curves.easeInOut,
                          ),
                          child: const Icon(Icons.arrow_back_ios_new_rounded,
                              color: _cyan, size: 20),
                        )
                      : const SizedBox(width: 20),

                  // Title
                  const Text(
                    'PROJECTPALS',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      letterSpacing: 1.5,
                    ),
                  ),

                  // Skip
                  GestureDetector(
                    onTap: _skip,
                    child: const Text(
                      'SKIP',
                      style: TextStyle(
                        color: _cyan,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ── Page View ─────────────────────────────────────────────────
            Expanded(
              child: PageView(
                controller: _pageCtrl,
                onPageChanged: (i) => setState(() => _currentPage = i),
                children: const [
                  _Page1(),
                  _Page2(),
                  _Page3(),
                ],
              ),
            ),

            // ── Bottom: Dots + Button ─────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
              child: Column(
                children: [
                  // Next / Start button
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton(
                      onPressed: _next,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _currentPage == 2 ? _mintGreen : _cyan,
                        foregroundColor: Colors.black87,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        elevation: 0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _currentPage == 2 ? 'Start' : 'Next',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(width: 6),
                          const Icon(Icons.chevron_right_rounded, size: 20),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Dot indicators
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(3, (i) {
                      final isActive = i == _currentPage;
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: isActive ? 24 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: isActive ? _cyan : _border,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Page 1 — Find Your Perfect Match
// ─────────────────────────────────────────────────────────────────────────────
class _Page1 extends StatelessWidget {
  const _Page1();

  static const Color _cyan = Color(0xFF3CD7FF);
  static const Color _cardBg = Color(0xFF0A1F35);
  static const Color _border = Color(0xFF1A3A55);
  static const Color _textGrey = Color(0xFFC5C6CD);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          const SizedBox(height: 16),

          // Illustration card
          Container(
            width: double.infinity,
            height: 260,
            decoration: BoxDecoration(
              color: _cardBg,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: _border),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Glow background
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _cyan.withValues(alpha: 0.06),
                    boxShadow: [
                      BoxShadow(
                        color: _cyan.withValues(alpha: 0.15),
                        blurRadius: 60,
                        spreadRadius: 20,
                      ),
                    ],
                  ),
                ),

                // Center icon
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: _cyan.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: _cyan.withValues(alpha: 0.4)),
                  ),
                  child: const Icon(Icons.hub_rounded, color: _cyan, size: 32),
                ),

                // Surrounding icons
                ..._buildSurroundingIcons(),
              ],
            ),
          ),
          const SizedBox(height: 36),

          // Text
          RichText(
            textAlign: TextAlign.center,
            text: const TextSpan(
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                height: 1.2,
              ),
              children: [
                TextSpan(
                    text: 'Find Your ',
                    style: TextStyle(color: Colors.white)),
                TextSpan(
                    text: 'Perfect\nMatch',
                    style: TextStyle(color: _cyan)),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Our neural engine analyzes skills and personality traits to find your perfect co-builders.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: _textGrey,
              fontSize: 14,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildSurroundingIcons() {
    const icons = [
      {'icon': Icons.psychology_outlined, 'x': -90.0, 'y': -60.0},
      {'icon': Icons.terminal_rounded, 'x': 0.0, 'y': -90.0},
      {'icon': Icons.hub_outlined, 'x': 90.0, 'y': -60.0},
      {'icon': Icons.palette_outlined, 'x': -90.0, 'y': 60.0},
      {'icon': Icons.rocket_launch_outlined, 'x': 0.0, 'y': 90.0},
      {'icon': Icons.biotech_outlined, 'x': 90.0, 'y': 60.0},
      {'icon': Icons.bar_chart_rounded, 'x': -50.0, 'y': 0.0},
      {'icon': Icons.group_outlined, 'x': 50.0, 'y': 0.0},
    ];

    return icons.map((item) {
      return Transform.translate(
        offset: Offset(item['x'] as double, item['y'] as double),
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: const Color(0xFF0D2137),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: _border),
          ),
          child: Icon(item['icon'] as IconData,
              color: _textGrey, size: 18),
        ),
      );
    }).toList();
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Page 2 — Build Your Reputation
// ─────────────────────────────────────────────────────────────────────────────
class _Page2 extends StatelessWidget {
  const _Page2();

  static const Color _cyan = Color(0xFF3CD7FF);
  static const Color _cardBg = Color(0xFF0A1F35);
  static const Color _border = Color(0xFF1A3A55);
  static const Color _textGrey = Color(0xFFC5C6CD);
  static const Color _mintGreen = Color(0xFF42E38D);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          const SizedBox(height: 16),

          // Illustration card
          Container(
            width: double.infinity,
            height: 260,
            decoration: BoxDecoration(
              color: _cardBg,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: _border),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Glow
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: _cyan.withValues(alpha: 0.2),
                        blurRadius: 70,
                        spreadRadius: 30,
                      ),
                    ],
                  ),
                ),

                // Trust card
                Container(
                  width: 160,
                  padding: const EdgeInsets.symmetric(
                      vertical: 20, horizontal: 24),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0D2137),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: _border),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          color: _cyan.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                              color: _cyan.withValues(alpha: 0.3)),
                        ),
                        child: const Icon(Icons.verified_user_outlined,
                            color: _cyan, size: 28),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          5,
                          (_) => const Icon(Icons.star_rounded,
                              color: Colors.amber, size: 16),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'TRUST INDEX: 98%',
                        style: TextStyle(
                          color: _cyan,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),

                // Floating badges
                Positioned(
                  top: 30,
                  right: 20,
                  child: _FloatingBadge(
                      icon: Icons.handshake_outlined,
                      label: 'Commitment',
                      color: _mintGreen),
                ),
                Positioned(
                  bottom: 40,
                  left: 20,
                  child: _FloatingBadge(
                      icon: Icons.workspace_premium_outlined,
                      label: 'High Quality',
                      color: _mintGreen),
                ),
              ],
            ),
          ),
          const SizedBox(height: 36),

          // Text
          const Text(
            'Build Your\nReputation',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: _cyan,
              fontSize: 28,
              fontWeight: FontWeight.bold,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Reputation-based ecosystem ensuring commitment and high-quality collaborative outputs.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: _textGrey,
              fontSize: 14,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Page 3 — Stay on Target
// ─────────────────────────────────────────────────────────────────────────────
class _Page3 extends StatelessWidget {
  const _Page3();

  static const Color _cyan = Color(0xFF3CD7FF);
  static const Color _cardBg = Color(0xFF0A1F35);
  static const Color _border = Color(0xFF1A3A55);
  static const Color _textGrey = Color(0xFFC5C6CD);
  static const Color _mintGreen = Color(0xFF42E38D);

  @override
  Widget build(BuildContext context) {
    const milestones = ['INIT', 'DESIGN', 'BUILD', 'LAUNCH'];
    const activeIndex = 2; // BUILD is active

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          const SizedBox(height: 16),

          // Illustration card
          Container(
            width: double.infinity,
            height: 260,
            decoration: BoxDecoration(
              color: _cardBg,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: _border),
            ),
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Project name + percentage
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'PITSTOP PROJECT',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        letterSpacing: 0.5,
                      ),
                    ),
                    Text(
                      '84%',
                      style: TextStyle(
                        color: _cyan,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                // Progress bar
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: 0.84,
                    backgroundColor: _border,
                    valueColor: AlwaysStoppedAnimation<Color>(_cyan),
                    minHeight: 8,
                  ),
                ),
                const SizedBox(height: 20),

                // Milestone steps
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(milestones.length, (i) {
                    final isDone = i < activeIndex;
                    final isActive = i == activeIndex;
                    final color = isDone || isActive ? _mintGreen : _border;

                    return Column(
                      children: [
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isDone || isActive
                                ? _mintGreen.withValues(alpha: 0.15)
                                : const Color(0xFF0D2137),
                            border: Border.all(
                              color: color,
                              width: isActive ? 2 : 1,
                            ),
                          ),
                          child: Icon(
                            isDone
                                ? Icons.check_rounded
                                : isActive
                                    ? Icons.radio_button_checked_rounded
                                    : Icons.circle_outlined,
                            color: color,
                            size: isActive ? 18 : 16,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          milestones[i],
                          style: TextStyle(
                            color: isDone || isActive ? _mintGreen : _textGrey,
                            fontSize: 9,
                            fontWeight: isActive
                                ? FontWeight.bold
                                : FontWeight.normal,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    );
                  }),
                ),
              ],
            ),
          ),
          const SizedBox(height: 36),

          // Text
          const Text(
            'Stay on Target',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: _cyan,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: TextStyle(
                color: _textGrey,
                fontSize: 14,
                height: 1.6,
              ),
              children: const [
                TextSpan(text: 'Real-time milestone visualization with\n'),
                TextSpan(
                  text: 'Mint-status indicators',
                  style: TextStyle(
                    color: _mintGreen,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(text: ' for peak performance.'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Floating Badge Widget
// ─────────────────────────────────────────────────────────────────────────────
class _FloatingBadge extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _FloatingBadge({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF0D2137),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 12),
          const SizedBox(width: 5),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

