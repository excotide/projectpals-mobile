import 'package:flutter/material.dart';

void showNotificationDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierColor: Colors.black54,
    builder: (_) => const _NotificationDialog(),
  );
}

class _NotificationDialog extends StatelessWidget {
  const _NotificationDialog();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topRight,
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Notifications',
                      style: TextStyle(
                        color: Color(0xFF041329),
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: const Text(
                        'Mark all as read',
                        style: TextStyle(
                          color: Color(0xFF3CD7FF),
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
                const Divider(color: Colors.black12),
                const SizedBox(height: 8),
                const Text(
                  'UNREAD',
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 8),
                _NotificationItem(
                  avatar: 'G',
                  name: 'gorila',
                  message: 'invited you to join CLOUDFRIEND',
                  time: '2m ago',
                ),
                _NotificationItem(
                  avatar: 'G',
                  name: 'gorila',
                  message: 'submitted a progress note',
                  time: '1h ago',
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
          Positioned(
            top: -14,
            right: -14,
            child: GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Container(
                width: 30,
                height: 30,
                decoration: const BoxDecoration(
                  color: Color(0xFF041329),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.close, color: Colors.white, size: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NotificationItem extends StatelessWidget {
  final String avatar, name, message, time;
  const _NotificationItem({
    required this.avatar,
    required this.name,
    required this.message,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: const Color(0xFF3CD7FF),
            child: Text(avatar,
                style: const TextStyle(
                    color: Color(0xFF003642), fontWeight: FontWeight.bold)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    style: const TextStyle(color: Colors.black87, fontSize: 13),
                    children: [
                      TextSpan(
                        text: '$name ',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(text: message),
                    ],
                  ),
                ),
                const SizedBox(height: 2),
                Text(time,
                    style: const TextStyle(color: Colors.black38, fontSize: 11)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
