import 'package:flutter/material.dart';
import '../siswa/portofolio_data.dart';

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

  // Nilai kriteria portofolio (0 - 5) persis seperti referensi user
  int kreativitasScore = 5;
  int kualitasScore = 4;
  int relevansiScore = 3;
  int dokumentasiScore = 3;

  @override
  void initState() {
    super.initState();
    currentStatus = widget.portofolio['status'] ?? 'Menunggu';
    currentScore = widget.portofolio['nilai'];
    currentNote = widget.portofolio['catatan'];
  }

  void _showBeriPenilaianBottomSheet() {
    int tempKreativitas = kreativitasScore;
    int tempKualitas = kualitasScore;
    int tempRelevansi = relevansiScore;
    int tempDokumentasi = dokumentasiScore;
    final TextEditingController noteController = TextEditingController(
      text: currentNote ?? '',
    );

    final namaSiswa = widget.portofolio['nama_siswa'] ?? 'Karissa Zuleika';
    final kelasSiswa = widget.portofolio['kelas'] ?? 'XII RPL B';
    final avatar = widget.portofolio['avatar'] ??
        'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=400&q=80';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            Widget buildStarRating(
                String title, int currentVal, Function(int) onRatingChanged) {
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x0A000000),
                      blurRadius: 6,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E3A8A),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: List.generate(5, (index) {
                        final starIndex = index + 1;
                        final isFilled = starIndex <= currentVal;
                        return InkWell(
                          onTap: () {
                            setModalState(() {
                              if (currentVal == starIndex) {
                                onRatingChanged(0);
                              } else {
                                onRatingChanged(starIndex);
                              }
                            });
                          },
                          borderRadius: BorderRadius.circular(20),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 4, vertical: 2),
                            child: Icon(
                              Icons.star_rounded,
                              size: 32,
                              color: isFilled
                                  ? const Color(0xFF254BD1) // Biru bintang aktif
                                  : const Color(0xFF679BBB), // Biru muda bintang non-aktif
                            ),
                          ),
                        );
                      }),
                    ),
                  ],
                ),
              );
            }

            return Container(
              height: MediaQuery.of(context).size.height * 0.88,
              decoration: const BoxDecoration(
                color: Color(0xFFE2E8F0),
                borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  // DRAG HANDLE
                  Container(
                    width: 44,
                    height: 5,
                    decoration: BoxDecoration(
                      color: const Color(0xFF94A3B8),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  const SizedBox(height: 14),

                  // CONTENT
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // PROFIL SISWA
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 32,
                                backgroundImage: PortofolioItem.getAvatarImageProvider(
                                  null,
                                  avatar?.toString(),
                                ),
                                backgroundColor: const Color(0xFFCBD5E1),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      namaSiswa,
                                      style: const TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF1E3A8A),
                                      ),
                                    ),
                                    const SizedBox(height: 3),
                                    Text(
                                      '$kelasSiswa . NISN 0091750552',
                                      style: const TextStyle(
                                        fontSize: 11.5,
                                        color: Color(0xFF64748B),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 20),

                          // 4 CARDS ASPEK PENILAIAN (0 - 5 BINTANG)
                          buildStarRating('Kreativitas', tempKreativitas,
                              (val) => tempKreativitas = val),
                          buildStarRating('Kualitas Karya', tempKualitas,
                              (val) => tempKualitas = val),
                          buildStarRating('Relevansi Skill', tempRelevansi,
                              (val) => tempRelevansi = val),
                          buildStarRating('Dokumentasi', tempDokumentasi,
                              (val) => tempDokumentasi = val),

                          const SizedBox(height: 10),

                          // INPUT CATATAN DENGAN OUTLINE BIRU
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                  color: const Color(0xFF254BD1), width: 1.5),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 8),
                            child: TextField(
                              controller: noteController,
                              maxLines: 3,
                              style: const TextStyle(
                                fontSize: 13,
                                color: Color(0xFF1E293B),
                              ),
                              decoration: const InputDecoration(
                                hintText: 'Tulis catatan untuk siswa..',
                                hintStyle: TextStyle(
                                  fontSize: 12.5,
                                  color: Color(0xFF64748B),
                                ),
                                border: InputBorder.none,
                                isDense: true,
                              ),
                            ),
                          ),

                          const SizedBox(height: 20),

                          // TOMBOL SIMPAN PENILAIAN
                          SizedBox(
                            width: double.infinity,
                            height: 48,
                            child: ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  kreativitasScore = tempKreativitas;
                                  kualitasScore = tempKualitas;
                                  relevansiScore = tempRelevansi;
                                  dokumentasiScore = tempDokumentasi;
                                  currentNote = noteController.text.trim();
                                  final avg = (kreativitasScore +
                                          kualitasScore +
                                          relevansiScore +
                                          dokumentasiScore) /
                                      4.0;
                                  currentScore = (avg * 20).round();
                                });
                                final id = widget.portofolio['id']?.toString();
                                if (id != null) {
                                  PortofolioDataStore().updatePenilaian(
                                    id,
                                    kreativitas: tempKreativitas,
                                    kualitas: tempKualitas,
                                    relevansi: tempRelevansi,
                                    dokumentasi: tempDokumentasi,
                                    catatan: currentNote,
                                  );
                                }
                                Navigator.pop(ctx);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Penilaian berhasil disimpan (Kreativitas: $kreativitasScore, Kualitas: $kualitasScore, Relevansi: $relevansiScore, Dokumentasi: $dokumentasiScore)',
                                    ),
                                    backgroundColor: successGreen,
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF2B5EA7),
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text(
                                'simpan penilaian',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 28),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
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
              final newStatus = setuju ? 'Disetujui' : 'Ditolak';
              setState(() {
                currentStatus = newStatus;
              });
              final id = widget.portofolio['id']?.toString();
              if (id != null) {
                PortofolioDataStore().updateStatus(id, newStatus);
              }
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
    final String? fotoKarya = (widget.portofolio['imageUrl'] ??
            widget.portofolio['thumbnail'] ??
            widget.portofolio['file_pendukung'])
        ?.toString();
    final String previewImageUrl =
        (fotoKarya != null && fotoKarya.startsWith('http'))
            ? fotoKarya
            : (link.startsWith('http://') || link.startsWith('https://'))
                ? link
                : 'https://images.unsplash.com/photo-1589829545856-d10d557cf95f?auto=format&fit=crop&w=800&q=80';
    final String? siswaAvatarUrl = widget.portofolio['avatar']?.toString();

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
                    backgroundImage: (siswaAvatarUrl != null &&
                            siswaAvatarUrl.startsWith('http'))
                        ? NetworkImage(siswaAvatarUrl)
                        : null,
                    child: (siswaAvatarUrl == null ||
                            !siswaAvatarUrl.startsWith('http'))
                        ? Text(
                            namaSiswa.isNotEmpty ? namaSiswa[0] : 'S',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1E293B),
                            ),
                          )
                        : null,
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
                  // STATUS BADGE (MENUNGGU WARNA OREN)
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: currentStatus == 'Disetujui'
                          ? const Color(0xFFDCFCE7)
                          : currentStatus == 'Ditolak'
                              ? const Color(0xFFFEE2E2)
                              : const Color(0xFFFFEDD5),
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
                                : const Color(0xFFEA580C),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // GAMBAR / PREVIEW SERTIFIKAT ASLI DARI SUPABASE
            Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                color: const Color(0xFFE2E8F0),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFCBD5E1)),
                image: DecorationImage(
                  image: NetworkImage(previewImageUrl),
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
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ROW 1: TOMBOL BERI PENILAIAN PENUH (PERSIS SEPERTI GAMBAR REFERENSI USER)
            SizedBox(
              width: double.infinity,
              height: 48,
              child: OutlinedButton.icon(
                onPressed: _showBeriPenilaianBottomSheet,
                icon: const Icon(
                  Icons.assignment_outlined,
                  size: 22,
                  color: Color(0xFF4A8AC4),
                ),
                label: const Text(
                  'Beri Penilaian',
                  style: TextStyle(
                    color: Color(0xFF4A8AC4),
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFF4A8AC4), width: 1.8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  backgroundColor: Colors.white,
                ),
              ),
            ),

            if (currentStatus == 'Menunggu') ...[
              const SizedBox(height: 12),

              // ROW 2: DUA TOMBOL BERDAMPINGAN: SETUJUI (HIJAU) & TOLAK (MERAH) — HANYA MUNCUL JIKA MASIH MENUNGGU
              Row(
                children: [
                  // SETUJUI
                  Expanded(
                    child: SizedBox(
                      height: 48,
                      child: ElevatedButton.icon(
                        onPressed: () => _konfirmasiAksi(true),
                        icon: const Icon(
                          Icons.assignment_turned_in_outlined,
                          size: 20,
                          color: Colors.white,
                        ),
                        label: const Text(
                          'Setujui',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF22C55E),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),

                  // TOLAK
                  Expanded(
                    child: SizedBox(
                      height: 48,
                      child: ElevatedButton.icon(
                        onPressed: () => _konfirmasiAksi(false),
                        icon: const Icon(
                          Icons.disabled_by_default_outlined,
                          size: 20,
                          color: Colors.white,
                        ),
                        label: const Text(
                          'Tolak',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFEF4444),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
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

