import 'package:flutter/material.dart';
import '../widgets/notification_dialog.dart';
import 'join_screen.dart' as join; // Pastikan file join_screen.dart sudah dibuat
import 'create_screen.dart' as create;
import 'profile_screen.dart' as profile;
import 'room_screen.dart' as room;
import '../widgets/app_bottom_nav.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  // Warna Tema
  final Color primaryCyan = const Color(0xFF3CD7FF);
  final Color darkBlueBg = const Color(0xFF041329);
  final Color mintGreen = const Color(0xFF42E38D);
  final Color textGrey = const Color(0xFFC5C6CD);

  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkBlueBg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- HEADER ---
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          color: Colors.white10,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.person, color: Colors.white, size: 30),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Welcome Back,", style: TextStyle(color: textGrey, fontSize: 13)),
                          const Text("Juju", 
                            style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () => showNotificationDialog(context),
                    child: Stack(
                      children: [
                        const Icon(Icons.notifications, color: Colors.white, size: 28),
                        Positioned(
                          right: 0,
                          top: 0,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(color: Colors.orange, shape: BoxShape.circle),
                            child: const Text("1", 
                              style: TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold)),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 25),

              // --- ACTIVE PROJECTS CARD ---
              _buildActiveProjectCard(),
              const SizedBox(height: 30),

              // --- QUICK ACCESS ---
              const Text("Quick Access", 
                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 15),
              Row(
                children: [
                  _buildQuickAccessBtn(Icons.rocket_launch, "Create Room", () {
                    Navigator.push(
                      context,
                      buildSlideRoute(const create.CreateRoomScreen()),
                    );
                  }),
                  const SizedBox(width: 15),
                  _buildQuickAccessBtn(Icons.groups, "Join Room", () {
                    Navigator.push(
                      context, 
                      buildSlideRoute(const join.JoinRoomScreen()),
                    );
                  }),
                ],
              ),
              const SizedBox(height: 30),

              // --- YOUR PROJECTS TEAM ---
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Your Projects Team", 
                    style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                  Text("More Details →", style: TextStyle(color: textGrey, fontSize: 12)),
                ],
              ),
              const SizedBox(height: 15),
              _buildProjectItem("PitStop+", "Frontend", "3 months", true),
              _buildProjectItem("Mancingin", "FullStack", "1 year", true),
            ],
          ),
        ),
      ),

      // --- FLOATING ACTION BUTTON ---
      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryCyan,
        onPressed: () {},
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: Color(0xFF003642), size: 30),
      ),

      // --- BOTTOM NAVIGATION BAR ---
      bottomNavigationBar: AppBottomNavBar(
        currentIndex: _selectedIndex,
        selectedItemColor: mintGreen,
        onTap: (index) {
          if (index == _selectedIndex) {
            return;
          }

          setState(() => _selectedIndex = index);

          if (index == 1) {
            Navigator.push(context, buildSlideRoute(const join.JoinRoomScreen()));
          } else if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const room.RoomScreen(),
              ),
            );
          } else if (index == 3) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const profile.ProfileScreen(),
              ),
            );
          }
        },
      ),
    );
  }

  // --- HELPER WIDGETS ---

  Widget _buildActiveProjectCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: primaryCyan,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text("Active Projects", 
                style: TextStyle(color: Color(0xFF003642), fontSize: 18, fontWeight: FontWeight.bold)),
              Icon(Icons.arrow_forward_ios, size: 12, color: Color(0xFF003642)),
            ],
          ),
          const SizedBox(height: 15),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF002B35).withValues(alpha: 0.9),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Drinkedin", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                Text("Day 3 : On Going", 
                  style: TextStyle(color: mintGreen, fontSize: 10, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // UPDATED: Sekarang menerima fungsi VoidCallback onTap
  Widget _buildQuickAccessBtn(IconData icon, String label, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFF1B263B).withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            children: [
              Icon(icon, color: primaryCyan, size: 28),
              const SizedBox(height: 10),
              Text(label, style: TextStyle(color: primaryCyan, fontSize: 12, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProjectItem(String title, String role, String duration, bool isCompleted) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF0D1B2A),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              Text("$role  •  $duration", style: TextStyle(color: textGrey, fontSize: 12)),
            ],
          ),
          if (isCompleted)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                border: Border.all(color: mintGreen.withValues(alpha: 0.5)),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text("COMPLETED", 
                style: TextStyle(color: mintGreen, fontSize: 9, fontWeight: FontWeight.bold)),
            ),
        ],
      ),
    );
  }
}