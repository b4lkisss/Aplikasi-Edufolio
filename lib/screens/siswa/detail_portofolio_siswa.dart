import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'portofolio_data.dart';

class DetailPortofolioSiswa extends StatelessWidget {
  final PortofolioItem portofolio;

  const DetailPortofolioSiswa({
    super.key,
    required this.portofolio,
  });

  static const Color primaryBlue = Color(0xFF356DA8);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Detail Portofolio',
          style: TextStyle(
            color: Color(0xFF0F172A),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        // SESUAI REQUEST: (tanpa ada icon notifikasi)
        actions: const [],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: primaryBlue,
              width: 2,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // BANNER GAMBAR / SERTIFIKAT
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  height: 190,
                  width: double.infinity,
                  color: const Color(0xFFE2E8F0),
                  child: portofolio.imageBytes != null
                      ? Image.memory(
                          portofolio.imageBytes!,
                          fit: BoxFit.cover,
                        )
                      : (portofolio.imageUrl != null
                          ? Image.network(
                              portofolio.imageUrl!,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Center(
                                child: Icon(
                                  Icons.image_outlined,
                                  size: 48,
                                  color: Colors.grey,
                                ),
                              ),
                            )
                          : const Center(
                              child: Icon(
                                Icons.image_outlined,
                                size: 48,
                                color: Colors.grey,
                              ),
                            )),
                ),
              ),

              const SizedBox(height: 16),

              // JUDUL PORTOFOLIO
              Text(
                portofolio.judul,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: primaryBlue,
                ),
              ),

              const SizedBox(height: 8),

              // BADGE KATEGORI & TAHUN
              Row(
                children: [
                  const Icon(
                    Icons.workspace_premium_rounded,
                    color: primaryBlue,
                    size: 20,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    portofolio.kategori,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: primaryBlue,
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Icon(
                    Icons.calendar_today_rounded,
                    color: primaryBlue,
                    size: 18,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    portofolio.tanggal,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: primaryBlue,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // DESKRIPSI
              const Text(
                'Deskripsi',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: primaryBlue,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                portofolio.deskripsi,
                style: const TextStyle(
                  fontSize: 12.5,
                  color: Color(0xFF334155),
                  height: 1.4,
                ),
              ),

              const SizedBox(height: 16),

              // PERAN SAYA
              const Text(
                'Peran Saya',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: primaryBlue,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                portofolio.peran,
                style: const TextStyle(
                  fontSize: 12.5,
                  color: Color(0xFF334155),
                  height: 1.4,
                ),
              ),

              const SizedBox(height: 16),

              // SKILL YANG TERLIBAT
              const Text(
                'Skill yang Terlibat',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: primaryBlue,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: portofolio.skills.map((skill) {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFD9DFE5),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      skill,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF334155),
                      ),
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 16),

              // LINK PENDUKUNG
              const Text(
                'Link Pendukung',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: primaryBlue,
                ),
              ),
              const SizedBox(height: 6),
              InkWell(
                borderRadius: BorderRadius.circular(10),
                onTap: () {
                  Clipboard.setData(ClipboardData(text: portofolio.link));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Tautan berhasil disalin ke clipboard!'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: primaryBlue, width: 1.5),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          portofolio.link,
                          style: const TextStyle(
                            fontSize: 12,
                            color: primaryBlue,
                            decoration: TextDecoration.underline,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(
                        Icons.copy_rounded,
                        size: 16,
                        color: primaryBlue,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // STATUS BADGE DI BAGIAN BAWAH
              _buildStatusBadge(portofolio.status),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color bg;
    Color textColor;
    String label;

    if (status.toLowerCase().contains('menunggu')) {
      bg = const Color(0xFFFEF3C7);
      textColor = const Color(0xFFD97706);
      label = 'Menunggu Verifikasi';
    } else if (status.toLowerCase().contains('tolak')) {
      bg = const Color(0xFFFEE2E2);
      textColor = const Color(0xFFDC2626);
      label = 'Ditolak';
    } else {
      bg = const Color(0xFFBAF7C5);
      textColor = const Color(0xFF16A34A);
      label = 'Disetujui';
    }

    return Container(
      width: double.infinity,
      height: 42,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(10),
      ),
      alignment: Alignment.center,
      child: Text(
        label,
        style: TextStyle(
          color: textColor,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
