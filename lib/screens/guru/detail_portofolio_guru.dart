import 'package:flutter/material.dart';

class DetailPortofolioGuru extends StatefulWidget {
  final Map<String, dynamic> portofolio;

  const DetailPortofolioGuru({
    super.key,
    required this.portofolio,
  });

  @override
  State<DetailPortofolioGuru> createState() => _DetailPortofolioGuruState();
}

class _DetailPortofolioGuruState extends State<DetailPortofolioGuru> {
  final Color primaryBlue = const Color(0xFF254BD1);
  final Color successGreen = const Color(0xFF16A34A);
  final Color dangerRed = const Color(0xFFDC2626);

  String? currentStatus;
  int? currentScore;
  String? currentNote;

  @override
  void initState() {
    super.initState();
    currentStatus = widget.portofolio['status'] ?? 'Menunggu';
    currentScore = widget.portofolio['nilai'];
    currentNote = widget.portofolio['catatan'];
  }

  void _showBeriPenilaianDialog() {
    final TextEditingController scoreController = TextEditingController(
      text: currentScore != null ? currentScore.toString() : '',
    );
    final TextEditingController noteController = TextEditingController(
      text: currentNote ?? '',
    );

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.rate_review_rounded, color: Color(0xFF254BD1)),
            SizedBox(width: 10),
            Text(
              'Beri Penilaian',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E293B),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Nilai Portofolio (0 - 100)',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: 6),
            TextField(
              controller: scoreController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: 'Contoh: 90',
                filled: true,
                fillColor: const Color(0xFFF1F5F9),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 14),
            const Text(
              'Catatan / Feedback Guru',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: 6),
            TextField(
              controller: noteController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Tuliskan apresiasi atau saran perbaikan...',
                filled: true,
                fillColor: const Color(0xFFF1F5F9),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              final parsed = int.tryParse(scoreController.text.trim());
              setState(() {
                currentScore = parsed;
                currentNote = noteController.text.trim();
              });
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Penilaian berhasil disimpan (Nilai: ${parsed ?? "-"})'),
                  backgroundColor: successGreen,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryBlue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text('Simpan', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _konfirmasiAksi(bool setuju) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          setuju ? 'Setujui Portofolio?' : 'Tolak Portofolio?',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Text(
          setuju
              ? 'Portofolio ini akan diverifikasi dan berstatus Disetujui.'
              : 'Portofolio ini akan ditolak dan memerlukan revisi oleh siswa.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                currentStatus = setuju ? 'Disetujui' : 'Ditolak';
              });
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    setuju
                        ? 'Portofolio berhasil Disetujui!'
                        : 'Portofolio telah Ditolak.',
                  ),
                  backgroundColor: setuju ? successGreen : dangerRed,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: setuju ? successGreen : dangerRed,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text(
              setuju ? 'Setujui' : 'Tolak',
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final String judul = widget.portofolio['judul'] ??
        'Juara 1 Lomba Web Design Tingkat Provinsi';
    final String kategori =
        widget.portofolio['kategori'] ?? 'Prestasi & Lomba • 2024';
    final String deskripsi = widget.portofolio['deskripsi'] ??
        'Memenangkan juara 1 dalam kompetisi pembuatan website interaktif bertema edukasi digital tingkat provinsi Jawa Barat yang diselenggarakan oleh Dinas Pendidikan.';
    final String peran = widget.portofolio['peran'] ??
        'Frontend Developer - Bertanggung jawab atas desain tampilan (UI/UX) dan implementasi antarmuka web menggunakan Flutter Web.';
    final List<String> skills = (widget.portofolio['skills'] as List<dynamic>?)
            ?.map((e) => e.toString())
            .toList() ??
        ['Flutter', 'Dart', 'Figma', 'REST API', 'Git'];
    final String link = widget.portofolio['link'] ??
        'https://github.com/balqis/project-web-edufolio';
    final String namaSiswa =
        widget.portofolio['nama_siswa'] ?? 'Balqis Demes Piscesa';
    final String kelasSiswa = widget.portofolio['kelas'] ?? 'XII RPL B';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1E293B)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Detail Portofolio',
          style: TextStyle(
            color: Color(0xFF1E293B),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // INFORMASI SISWA PEMILIK PORTOFOLIO
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: const Color(0xFFCBD5E1),
                    child: Text(
                      namaSiswa.isNotEmpty ? namaSiswa[0] : 'S',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          namaSiswa,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1E293B),
                          ),
                        ),
                        Text(
                          kelasSiswa,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // STATUS BADGE
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: currentStatus == 'Disetujui'
                          ? const Color(0xFFDCFCE7)
                          : currentStatus == 'Ditolak'
                              ? const Color(0xFFFEE2E2)
                              : const Color(0xFFFFE2E5),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      currentStatus!,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: currentStatus == 'Disetujui'
                            ? const Color(0xFF16A34A)
                            : currentStatus == 'Ditolak'
                                ? const Color(0xFFDC2626)
                                : const Color(0xFFEF4444),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // GAMBAR / PREVIEW SERTIFIKAT
            Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                color: const Color(0xFFE2E8F0),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFCBD5E1)),
                image: const DecorationImage(
                  image: NetworkImage(
                    'https://images.unsplash.com/photo-1589829545856-d10d557cf95f?auto=format&fit=crop&w=800&q=80',
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),

            const SizedBox(height: 16),

            // JUDUL PORTOFOLIO
            Text(
              judul,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E293B),
              ),
            ),

            const SizedBox(height: 4),

            // KATEGORI & TAHUN
            Text(
              kategori,
              style: const TextStyle(
                fontSize: 13,
                color: Color(0xFF64748B),
              ),
            ),

            if (currentScore != null) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF6FF),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFFBFDBFE)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.star_rounded, color: Color(0xFFF59E0B), size: 20),
                    const SizedBox(width: 8),
                    Text(
                      'Nilai: $currentScore / 100',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E3A8A),
                        fontSize: 13,
                      ),
                    ),
                    if (currentNote != null && currentNote!.isNotEmpty) ...[
                      const SizedBox(width: 8),
                      Text(
                        '• "$currentNote"',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF475569),
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],

            const SizedBox(height: 20),

            // DESKRIPSI
            _buildSectionHeader('Deskripsi'),
            Text(
              deskripsi,
              style: const TextStyle(
                fontSize: 13,
                height: 1.5,
                color: Color(0xFF334155),
              ),
            ),

            const SizedBox(height: 16),

            // PERAN SAYA
            _buildSectionHeader('Peran Saya'),
            Text(
              peran,
              style: const TextStyle(
                fontSize: 13,
                height: 1.5,
                color: Color(0xFF334155),
              ),
            ),

            const SizedBox(height: 16),

            // SKILL YANG TERLIBAT
            _buildSectionHeader('Skill yang Terlibat'),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: skills.map((skill) {
                return Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE2E8F0),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    skill,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 16),

            // LINK PENDUKUNG
            _buildSectionHeader('Link Pendukung'),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.link_rounded,
                      size: 18, color: Color(0xFF254BD1)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      link,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF254BD1),
                        decoration: TextDecoration.underline,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 36),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Color(0x0F000000),
              blurRadius: 10,
              offset: Offset(0, -4),
            ),
          ],
        ),
        child: Row(
          children: [
            // BERI PENILAIAN
            Expanded(
              flex: 3,
              child: SizedBox(
                height: 44,
                child: OutlinedButton(
                  onPressed: _showBeriPenilaianDialog,
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFF254BD1), width: 1.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Beri Penilaian',
                    style: TextStyle(
                      color: Color(0xFF254BD1),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(width: 8),

            // SETUJU
            Expanded(
              flex: 2,
              child: SizedBox(
                height: 44,
                child: ElevatedButton.icon(
                  onPressed: () => _konfirmasiAksi(true),
                  icon: const Icon(Icons.check_rounded, size: 16, color: Colors.white),
                  label: const Text(
                    'Setuju',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: successGreen,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(width: 8),

            // TOLAK
            Expanded(
              flex: 2,
              child: SizedBox(
                height: 44,
                child: ElevatedButton.icon(
                  onPressed: () => _konfirmasiAksi(false),
                  icon: const Icon(Icons.close_rounded, size: 16, color: Colors.white),
                  label: const Text(
                    'Tolak',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: dangerRed,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Color(0xFF1E293B),
        ),
      ),
    );
  }
}

