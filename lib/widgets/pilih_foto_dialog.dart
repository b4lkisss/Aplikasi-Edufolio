import 'package:flutter/material.dart';

class PilihFotoDialog {
  static void show(
    BuildContext context, {
    required VoidCallback onKamera,
    VoidCallback? onKameraVideo,
    required VoidCallback onFile,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
          decoration: const BoxDecoration(
            color: Color(0xFF1E1E1E), // Background gelap persis screenshot contoh user
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // JUDUL "Pilih tindakan"
              const Text(
                'Pilih tindakan',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),

              // BARIS OPSI: Kamera, Kamera Video, File
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // OPSI KAMERA
                  _buildOption(
                    context: ctx,
                    icon: Icons.camera_alt_rounded,
                    iconColor: const Color(0xFFE2E8F0),
                    badgeColor: Colors.redAccent,
                    label: 'Kamera',
                    onTap: () {
                      Navigator.pop(ctx);
                      onKamera();
                    },
                  ),

                  // OPSI KAMERA VIDEO
                  _buildOption(
                    context: ctx,
                    icon: Icons.videocam_rounded,
                    iconColor: const Color(0xFFE2E8F0),
                    badgeColor: Colors.redAccent,
                    label: 'Kamera\nVideo',
                    onTap: () {
                      Navigator.pop(ctx);
                      if (onKameraVideo != null) {
                        onKameraVideo();
                      } else {
                        onKamera();
                      }
                    },
                  ),

                  // OPSI FILE
                  _buildOption(
                    context: ctx,
                    icon: Icons.folder_rounded,
                    iconColor: const Color(0xFF3B82F6),
                    badgeColor: null,
                    label: 'File',
                    onTap: () {
                      Navigator.pop(ctx);
                      onFile();
                    },
                  ),
                ],
              ),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  static Widget _buildOption({
    required BuildContext context,
    required IconData icon,
    required Color iconColor,
    required Color? badgeColor,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // KOTAK ICON
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: 58,
                  height: 58,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F5F9), // Abu-abu terang persis gambar
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x1A000000),
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Icon(
                      icon,
                      size: 30,
                      color: iconColor,
                    ),
                  ),
                ),
                if (badgeColor != null)
                  Positioned(
                    top: 14,
                    left: 14,
                    child: Container(
                      width: 5,
                      height: 5,
                      decoration: BoxDecoration(
                        color: badgeColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12.5,
                fontWeight: FontWeight.w500,
                height: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
