import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../services/image_picker_service.dart';

class PilihFotoDialog {
  /// Cek apakah pengguna membuka lewat HP (mobile) atau Laptop / Desktop
  static bool isMobile(BuildContext context) {
    if (kIsWeb) {
      return MediaQuery.of(context).size.width < 700;
    }
    return defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.iOS;
  }

  /// Fungsi responsive:
  /// - Di HP: Muncul dialog "Pilih tindakan" (Kamera, Kamera Video, File)
  /// - Di Laptop: Langsung membuka file picker / explorer laptop
  static Future<void> pilihFotoResponsive(
    BuildContext context, {
    required Function(Uint8List bytes) onFotoTerpilih,
    VoidCallback? onKameraVideo,
  }) async {
    if (isMobile(context)) {
      show(
        context,
        onKamera: () async {
          final bytes = await AppImagePicker.pickFromCamera();
          if (bytes != null) {
            onFotoTerpilih(bytes);
          }
        },
        onKameraVideo: onKameraVideo ??
            () async {
              await AppImagePicker.pickVideo();
            },
        onFile: () async {
          final bytes = await AppImagePicker.pickFromGallery();
          if (bytes != null) {
            onFotoTerpilih(bytes);
          }
        },
      );
    } else {
      // Laptop / Desktop: langsung buka file picker sistem
      final bytes = await AppImagePicker.pickFromGallery();
      if (bytes != null) {
        onFotoTerpilih(bytes);
      }
    }
  }

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
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: 58,
                  height: 58,
                  decoration: BoxDecoration(
                    color: const Color(0xFF2C2C2C),
                    shape: BoxShape.circle,
                    border: Border.all(color: const Color(0xFF404040), width: 1.5),
                  ),
                  child: Icon(
                    icon,
                    color: iconColor,
                    size: 28,
                  ),
                ),
                if (badgeColor != null)
                  Positioned(
                    bottom: 2,
                    right: 2,
                    child: Container(
                      width: 14,
                      height: 14,
                      decoration: BoxDecoration(
                        color: badgeColor,
                        shape: BoxShape.circle,
                        border: Border.all(color: const Color(0xFF1E1E1E), width: 2),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xFFE2E8F0),
                fontSize: 12,
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
