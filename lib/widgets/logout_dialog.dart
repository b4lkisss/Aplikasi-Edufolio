import 'package:flutter/material.dart';

class LogoutDialog extends StatelessWidget {
  final String role; // 'admin', 'guru', 'siswa'
  final VoidCallback? onLogout;

  const LogoutDialog({
    super.key,
    this.role = 'guru',
    this.onLogout,
  });

  static Future<void> show(
    BuildContext context, {
    String role = 'guru',
    VoidCallback? onLogout,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => LogoutDialog(
        role: role,
        onLogout: onLogout,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryBlue = Color(0xFF254BD1);

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(22),
      ),
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.symmetric(horizontal: 32),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 26),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // IKON LOGOUT BULAT
            Container(
              width: 72,
              height: 72,
              decoration: const BoxDecoration(
                color: Color(0xFFE2E8F0),
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Icon(
                  Icons.logout_rounded,
                  color: primaryBlue,
                  size: 34,
                ),
              ),
            ),

            const SizedBox(height: 18),

            // JUDUL POPUP
            const Text(
              'Keluar dari akun?',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E293B),
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 8),

            // SUBTITLE KONFIRMASI
            const Text(
              'Apa kamu yakin ingin keluar dari\nakun ini?',
              style: TextStyle(
                fontSize: 13,
                color: Color(0xFF64748B),
                height: 1.35,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 24),

            // TOMBOL BATAL & KELUAR
            Row(
              children: [
                // TOMBOL BATAL (OUTLINE)
                Expanded(
                  child: SizedBox(
                    height: 44,
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(
                          color: primaryBlue,
                          width: 1.5,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Batal',
                        style: TextStyle(
                          color: primaryBlue,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                // TOMBOL KELUAR (FILLED BLUE)
                Expanded(
                  child: SizedBox(
                    height: 44,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        if (onLogout != null) {
                          onLogout!();
                        } else {
                          String route = '/login';
                          if (role == 'guru') {
                            route = '/login-guru';
                          } else if (role == 'siswa') {
                            route = '/login-siswa';
                          }
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            route,
                            (r) => false,
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryBlue,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Keluar',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

