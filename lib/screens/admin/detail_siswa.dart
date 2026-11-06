import 'package:flutter/material.dart';

class DetailSiswa extends StatelessWidget {
  final Map<String, dynamic> siswa;

  const DetailSiswa({
    super.key,
    required this.siswa,
  });

  final Color primaryColor = const Color(0xFF356DA8);
  final Color cardBgColor = const Color(0xFFE2E8F0); // Warna background abu-abu sesuai gambar

  @override
  Widget build(BuildContext context) {
    final nama = siswa['nama'] ?? 'Balqis Demes Piscesa';
    final nisn = siswa['nisn'] ?? '0091750552';
    final kelas = siswa['kelas'] ?? 'XII RPL B';
    final jurusan = siswa['jurusan'] ?? 'Rekayasa Perangkat Lunak';
    final angkatan = siswa['angkatan'] ?? '2024';

    // Daftar contoh portofolio sesuai gambar referensi
    final List<Map<String, String>> portofolioList = [
      {
        'judul': 'Juara 1 Mobile Flutter',
        'kategori': 'Prestasi & Lomba • 2024',
        'status': 'Disetujui',
      },
      {
        'judul': 'Juara 1 Mobile Flutter',
        'kategori': 'Prestasi & Lomba • 2024',
        'status': 'Disetujui',
      },
      {
        'judul': 'Juara 1 Mobile Flutter',
        'kategori': 'Prestasi & Lomba • 2024',
        'status': 'Disetujui',
      },
      {
        'judul': 'Juara 1 Mobile Flutter',
        'kategori': 'Prestasi & Lomba • 2024',
        'status': 'Disetujui',
      },
      {
        'judul': 'Juara 1 Mobile Flutter',
        'kategori': 'Prestasi & Lomba • 2024',
        'status': 'Disetujui',
      },
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // HEADER ATAS
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
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
                    'Detail Siswa',
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
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // PROFIL ATAS (AVATAR & INFO SINGKAT)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // AVATAR SISWA
                        Container(
                          width: 80,
                          height: 80,
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
                              siswa['avatar'] == 0 ? Icons.person : Icons.face,
                              size: 52,
                              color: primaryColor,
                            ),
                          ),
                        ),

                        const SizedBox(width: 14),

                        // NAMA, NISN & BADGE KELAS/JURUSAN
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                nama,
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: primaryColor,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 3),
                              Text(
                                'Nisn: $nisn',
                                style: TextStyle(
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xE6356DA8),
                                ),
                              ),
                              const SizedBox(height: 7),
                              Wrap(
                                spacing: 6,
                                runSpacing: 4,
                                children: [
                                  // CHIP KELAS
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 3,
                                    ),
                                    decoration: BoxDecoration(
                                      color: cardBgColor,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      kelas,
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w600,
                                        color: primaryColor,
                                      ),
                                    ),
                                  ),
                                  // CHIP JURUSAN
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 3,
                                    ),
                                    decoration: BoxDecoration(
                                      color: cardBgColor,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      jurusan == 'RPL'
                                          ? 'Rekayasa Perangkat Lunak'
                                          : jurusan == 'TKJ'
                                              ? 'Teknik Komputer Jaringan'
                                              : jurusan,
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w600,
                                        color: primaryColor,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 18),

                    // 3 KOTAK STATISTIK (PORTOFOLIO, PRESTASI, SERTIFIKAT)
                    Row(
                      children: [
                        _buildStatBox('Portofolio', '13'),
                        const SizedBox(width: 10),
                        _buildStatBox('Prestasi', '24'),
                        const SizedBox(width: 10),
                        _buildStatBox('Sertifikat', '18'),
                      ],
                    ),

                    const SizedBox(height: 16),

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
                          _buildInfoRow(
                            'Email',
                            siswa['email'] ??
                                '${nama.toLowerCase().replaceAll(' ', '')}@gmail.com',
                          ),
                          const SizedBox(height: 10),
                          _buildInfoRow(
                            'No Telpon',
                            siswa['telepon'] ?? '08819429283',
                          ),
                          const SizedBox(height: 10),
                          _buildInfoRow(
                            'Jenis Kelamin',
                            siswa['gender'] ?? 'Perempuan',
                          ),
                          const SizedBox(height: 10),
                          _buildInfoRow(
                            'Tahun Ajaran / Angkatan',
                            angkatan,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // DAFTAR PORTOFOLIO SISWA
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
                            'Daftar Portofolio Siswa',
                            style: TextStyle(
                              fontSize: 13.5,
                              fontWeight: FontWeight.bold,
                              color: primaryColor,
                            ),
                          ),
                          const SizedBox(height: 14),

                          // LIST ITEM PORTOFOLIO
                          ...portofolioList.map((item) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: Row(
                                children: [
                                  // THUMBNAIL FOTO / SERTIFIKAT
                                  Container(
                                    width: 58,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(6),
                                      border: Border.all(
                                        color: const Color(0xFFCBD5E1),
                                        width: 1,
                                      ),
                                    ),
                                    child: Center(
                                      child: Icon(
                                        Icons.image_outlined,
                                        size: 24,
                                        color: primaryColor,
                                      ),
                                    ),
                                  ),

                                  const SizedBox(width: 10),

                                  // JUDUL & KATEGORI
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item['judul']!,
                                          style: TextStyle(
                                            fontSize: 11.5,
                                            fontWeight: FontWeight.bold,
                                            color: primaryColor,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          item['kategori']!,
                                          style: TextStyle(
                                            fontSize: 9.5,
                                            color: const Color(0xBF356DA8),
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  // BADGE STATUS "DISETUJUI"
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF2E7D32),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: const Text(
                                      'Disetujui',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 9.5,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),

                          const SizedBox(height: 10),

                          // TOMBOL EXPORT PORTOFOLIO SISWA (PDF)
                          SizedBox(
                            width: double.infinity,
                            height: 44,
                            child: ElevatedButton(
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Fitur Export PDF sedang disiapkan',
                                    ),
                                    backgroundColor: Color(0xFF356DA8),
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
                                'Export Portofolio Siswa (PDF)',
                                style: TextStyle(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
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

  // WIDGET KOTAK STATISTIK
  Widget _buildStatBox(String title, String count) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: cardBgColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: primaryColor,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              count,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E293B),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // WIDGET BARIS INFORMASI PRIBADI (KIRI: LABEL, KANAN: NILAI)
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
        Text(
          value,
          style: TextStyle(
            fontSize: 11,
            color: primaryColor,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

