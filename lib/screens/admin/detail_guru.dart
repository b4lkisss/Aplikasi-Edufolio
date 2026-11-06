import 'package:flutter/material.dart';

class DetailGuru extends StatelessWidget {
  final Map<String, dynamic> guru;

  const DetailGuru({
    super.key,
    required this.guru,
  });

  final Color primaryColor = const Color(0xFF356DA8);
  final Color cardBgColor = const Color(0xFFE2E8F0);

  @override
  Widget build(BuildContext context) {
    final nama = guru['nama'] ?? '';
    final nip = guru['nip'] ?? '1245543';
    final bidang = guru['bidang'] ?? '';
    final email = guru['email'] ?? '';
    final telepon = guru['telepon'] ?? '08819429283';
    final gender = guru['gender'] ?? 'Perempuan';
    final aktif = guru['aktif'] ?? true;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // HEADER ATAS
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 10,
              ),
              child: Row(
                children: [
                  InkWell(
                    borderRadius: BorderRadius.circular(8),
                    onTap: () => Navigator.pop(context),
                    child: const Padding(
                      padding: EdgeInsets.all(4),
                      child: Icon(
                        Icons.arrow_back,
                        size: 24,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Detail Guru',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.notifications,
                      color: primaryColor,
                    ),
                  ),
                ],
              ),
            ),

            // KONTEN SCROLLABLE
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Column(
                  children: [
                    // AVATAR GURU
                    Container(
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFFF1F5F9),
                        border: Border.all(
                          color: const Color(0xFFCBD5E1),
                          width: 2,
                        ),
                      ),
                      child: ClipOval(
                        child: Icon(
                          Icons.person,
                          size: 55,
                          color: primaryColor,
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    // NAMA GURU
                    Text(
                      nama,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                      ),
                    ),

                    const SizedBox(height: 10),

                    // BADGE STATUS AKTIF/NONAKTIF
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: aktif
                            ? const Color(0xFF4CAF50)
                            : const Color(0xFFE53935),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        aktif ? 'Aktif' : 'Nonaktif',
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // INFORMASI PRIBADI
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: cardBgColor,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Informasi Pribadi',
                            style: TextStyle(
                              fontSize: 13.5,
                              fontWeight: FontWeight.bold,
                              color: primaryColor,
                            ),
                          ),
                          const SizedBox(height: 14),
                          _buildInfoRow('Nama Lengkap', nama),
                          const SizedBox(height: 10),
                          _buildInfoRow('Nip', nip),
                          const SizedBox(height: 10),
                          _buildInfoRow('Bidang Mengajar', bidang),
                          const SizedBox(height: 10),
                          _buildInfoRow('Email', email),
                          const SizedBox(height: 10),
                          _buildInfoRow('No Telpon', telepon),
                          const SizedBox(height: 10),
                          _buildInfoRow('Jenis Kelamin', gender),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // TOMBOL RESET PASSWORD & EDIT AKUN
                    Row(
                      children: [
                        // TOMBOL RESET PASSWORD
                        Expanded(
                          child: SizedBox(
                            height: 42,
                            child: OutlinedButton.icon(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (dialogContext) {
                                    return Dialog(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      backgroundColor: Colors.white,
                                      insetPadding: const EdgeInsets.symmetric(horizontal: 32),
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(20, 22, 20, 20),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Reset Password',
                                              style: TextStyle(
                                                fontSize: 17,
                                                fontWeight: FontWeight.bold,
                                                color: primaryColor,
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            Text(
                                              'Apakah anda yakin ingin mereset password akun guru ini?',
                                              style: TextStyle(
                                                fontSize: 12.5,
                                                color: primaryColor,
                                                height: 1.35,
                                              ),
                                            ),
                                            const SizedBox(height: 16),
                                            Container(
                                              width: double.infinity,
                                              padding: const EdgeInsets.symmetric(
                                                horizontal: 14,
                                                vertical: 12,
                                              ),
                                              decoration: BoxDecoration(
                                                color: const Color(0xFFE2E8F0),
                                                borderRadius: BorderRadius.circular(12),
                                              ),
                                              child: Row(
                                                children: [
                                                  CircleAvatar(
                                                    radius: 22,
                                                    backgroundColor: Colors.white,
                                                    child: Icon(
                                                      Icons.person,
                                                      size: 26,
                                                      color: primaryColor,
                                                    ),
                                                  ),
                                                  const SizedBox(width: 12),
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text(
                                                          nama,
                                                          style: const TextStyle(
                                                            fontSize: 13,
                                                            fontWeight: FontWeight.bold,
                                                            color: Colors.black87,
                                                          ),
                                                        ),
                                                        const SizedBox(height: 2),
                                                        Text(
                                                          email,
                                                          style: const TextStyle(
                                                            fontSize: 11,
                                                            color: Colors.black54,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(height: 20),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: SizedBox(
                                                    height: 38,
                                                    child: OutlinedButton(
                                                      onPressed: () => Navigator.pop(dialogContext),
                                                      style: OutlinedButton.styleFrom(
                                                        side: BorderSide(
                                                          color: primaryColor,
                                                          width: 1.5,
                                                        ),
                                                        shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.circular(10),
                                                        ),
                                                      ),
                                                      child: Text(
                                                        'Batal',
                                                        style: TextStyle(
                                                          fontSize: 13,
                                                          fontWeight: FontWeight.w600,
                                                          color: primaryColor,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(width: 12),
                                                Expanded(
                                                  child: SizedBox(
                                                    height: 38,
                                                    child: ElevatedButton(
                                                      onPressed: () {
                                                        Navigator.pop(dialogContext);
                                                        ScaffoldMessenger.of(context).showSnackBar(
                                                          const SnackBar(
                                                            content: Text(
                                                              'Password guru berhasil direset ke: edufolio123',
                                                            ),
                                                            backgroundColor: Colors.green,
                                                          ),
                                                        );
                                                      },
                                                      style: ElevatedButton.styleFrom(
                                                        backgroundColor: primaryColor,
                                                        foregroundColor: Colors.white,
                                                        elevation: 0,
                                                        shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.circular(10),
                                                        ),
                                                      ),
                                                      child: const Text(
                                                        'Reset',
                                                        style: TextStyle(
                                                          fontSize: 13,
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
                                  },
                                );
                              },
                              icon: Icon(
                                Icons.vpn_key,
                                size: 16,
                                color: primaryColor,
                              ),
                              label: Text(
                                'Reset Password',
                                style: TextStyle(
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.w600,
                                  color: primaryColor,
                                ),
                              ),
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(
                                  color: primaryColor,
                                  width: 1.5,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(width: 10),

                        // TOMBOL EDIT AKUN
                        Expanded(
                          child: SizedBox(
                            height: 42,
                            child: OutlinedButton.icon(
                              onPressed: () {
                                Navigator.pop(context, 'edit');
                              },
                              icon: Icon(
                                Icons.edit,
                                size: 16,
                                color: primaryColor,
                              ),
                              label: Text(
                                'Edit Akun',
                                style: TextStyle(
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.w600,
                                  color: primaryColor,
                                ),
                              ),
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(
                                  color: primaryColor,
                                  width: 1.5,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // WIDGET BARIS INFORMASI PRIBADI
  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: primaryColor,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(width: 10),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: TextStyle(
              fontSize: 11,
              color: primaryColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

