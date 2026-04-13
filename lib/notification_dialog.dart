import 'package:flutter/material.dart';

void showNotificationDialog(BuildContext context) {
  // Warna yang sama dengan tema dashboard
  const Color primaryCyan = Color(0xFF3CD7FF);

  showDialog(
    context: context,
    barrierColor: Colors.black.withOpacity(0.8),
    builder: (BuildContext context) {
      return Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 20),
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            // BOX PUTIH UTAMA
            Container(
              margin: const EdgeInsets.only(top: 30),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Header Biru Muda
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(18),
                    decoration: const BoxDecoration(
                      color: primaryCyan,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15),
                      ),
                    ),
                    child: const Text(
                      "Notifications",
                      style: TextStyle(
                        color: Color(0xFF003642),
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  // List Notifikasi
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("Unread", 
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black)),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(color: const Color(0xFFF5F1E6), borderRadius: BorderRadius.circular(4)),
                              child: const Text("Mark all as read", 
                                style: TextStyle(color: Colors.brown, fontSize: 11, fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),
                        _buildItem("gorila Reminded you to fill in your Progress Feedback for Drinkedin", "4 minutes ago"),
                        const Divider(),
                        _buildItem("gorila Reminded you to fill in your Progress Feedback for Drinkedin", "an hour ago"),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // TOMBOL X MELAYANG
            Positioned(
              right: 0,
              top: 0,
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: primaryCyan,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 3),
                  ),
                  child: const Icon(Icons.close, color: Color(0xFF003642), size: 28),
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}

Widget _buildItem(String message, String time) {
  return Container(
    padding: const EdgeInsets.symmetric(vertical: 12),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 5),
          child: Icon(Icons.circle, color: Colors.red, size: 8),
        ),
        const SizedBox(width: 10),
        const CircleAvatar(
          backgroundColor: Color(0xFFF0F4FF), 
          child: Icon(Icons.person_outline, color: Colors.orange)
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(message, style: const TextStyle(color: Colors.black, fontSize: 13, height: 1.4)),
              const SizedBox(height: 5),
              Text(time, style: TextStyle(color: Colors.grey.shade500, fontSize: 11)),
            ],
          ),
        ),
      ],
    ),
  );
}