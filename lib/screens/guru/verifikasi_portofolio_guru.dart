import 'package:flutter/material.dart';
import 'detail_portofolio_guru.dart';

class VerifikasiPortofolioGuru extends StatefulWidget {
  const VerifikasiPortofolioGuru({super.key});

  @override
  State<VerifikasiPortofolioGuru> createState() =>
      _VerifikasiPortofolioGuruState();
}

class _VerifikasiPortofolioGuruState extends State<VerifikasiPortofolioGuru> {
  final Color primaryBlue = const Color(0xFF254BD1);
  final Color successGreen = const Color(0xFF16A34A);
  final Color dangerRed = const Color(0xFFDC2626);
  final Color cardBg = const Color(0xFFE2E8F0);

  int selectedTab = 0; // 0: Menunggu, 1: Disetujui, 2: Ditolak
  String selectedKategori = 'Semua Kategori';
  final TextEditingController searchController = TextEditingController();

  int currentPage = 1;

  final List<Map<String, dynamic>> allSubmissions = [
    {
      'id': 1,
      'nama_siswa': 'Balqis Demes Piscesa',
      'kelas': 'XII RPL B',
      'judul': 'Project Aplikasi Mobile',
      'kategori': 'Project Karya',
      'status': 'Menunggu',
      'waktu': '2 Jam yang lalu',
      'deskripsi':
          'Mengembangkan aplikasi mobile e-commerce UMKM lokal menggunakan Flutter dan Firebase dengan fitur katalog produk, keranjang belanja, dan pembayaran payment gateway.',
      'peran':
          'Lead Mobile Developer - Membangun arsitektur state management dan integrasi API payment gateway.',
      'skills': ['Flutter', 'Dart', 'Firebase', 'REST API', 'Figma'],
      'link': 'https://github.com/balqis/project-mobile-edufolio',
      'avatar':
          'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=200&q=80',
      'thumbnail':
          'https://images.unsplash.com/photo-1589829545856-d10d557cf95f?auto=format&fit=crop&w=400&q=80',
    },
    {
      'id': 2,
      'nama_siswa': 'Balqis Demes Piscesa',
      'kelas': 'XII RPL B',
      'judul': 'Project Aplikasi Mobile',
      'kategori': 'Project Karya',
      'status': 'Menunggu',
      'waktu': '3 Jam yang lalu',
      'deskripsi':
          'Pembuatan sistem manajemen perpustakaan sekolah berbasis Android untuk mempermudah peminjaman dan pengembalian buku dengan QR Code scanner.',
      'peran': 'Frontend Developer - Desain antarmuka responsif dan implementasi scanner QR.',
      'skills': ['Flutter', 'QR Scanner', 'UI/UX'],
      'link': 'https://github.com/balqis/library-app',
      'avatar':
          'https://images.unsplash.com/photo-1539571696357-5a69c17a67c6?auto=format&fit=crop&w=200&q=80',
      'thumbnail':
          'https://images.unsplash.com/photo-1589829545856-d10d557cf95f?auto=format&fit=crop&w=400&q=80',
    },
    {
      'id': 3,
      'nama_siswa': 'Balqis Demes Piscesa',
      'kelas': 'XII RPL B',
      'judul': 'Project Aplikasi Mobile',
      'kategori': 'Project Karya',
      'status': 'Menunggu',
      'waktu': '5 Jam yang lalu',
      'deskripsi':
          'Aplikasi monitoring kehadiran siswa berbasis lokasi GPS dan validasi wajah.',
      'peran': 'Mobile Developer & UI Designer.',
      'skills': ['Flutter', 'GPS Location', 'REST API'],
      'link': 'https://github.com/balqis/absensi-gps',
      'avatar':
          'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=200&q=80',
      'thumbnail':
          'https://images.unsplash.com/photo-1589829545856-d10d557cf95f?auto=format&fit=crop&w=400&q=80',
    },
    {
      'id': 4,
      'nama_siswa': 'Balqis Demes Piscesa',
      'kelas': 'XII RPL B',
      'judul': 'Project Aplikasi Mobile',
      'kategori': 'Project Karya',
      'status': 'Menunggu',
      'waktu': '1 Hari yang lalu',
      'deskripsi':
          'Aplikasi portofolio digital berbasis Flutter Web dan Android.',
      'peran': 'Fullstack Developer.',
      'skills': ['Flutter', 'Supabase', 'Dart'],
      'link': 'https://github.com/balqis/edufolio',
      'avatar':
          'https://images.unsplash.com/photo-1539571696357-5a69c17a67c6?auto=format&fit=crop&w=200&q=80',
      'thumbnail':
          'https://images.unsplash.com/photo-1589829545856-d10d557cf95f?auto=format&fit=crop&w=400&q=80',
    },
    {
      'id': 5,
      'nama_siswa': 'Ahmad Fauzan',
      'kelas': 'XII RPL A',
      'judul': 'Sertifikat Flutter Developer',
      'kategori': 'Sertifikat',
      'status': 'Disetujui',
      'waktu': '1 Hari yang lalu',
      'deskripsi': 'Sertifikasi kompetensi keahlian Flutter dari Google Developer Groups.',
      'peran': 'Peserta Ujian Sertifikasi.',
      'skills': ['Flutter', 'State Management'],
      'link': 'https://cert.dev/ahmad-fauzan',
      'avatar':
          'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&w=200&q=80',
      'thumbnail':
          'https://images.unsplash.com/photo-1589829545856-d10d557cf95f?auto=format&fit=crop&w=400&q=80',
    },
    {
      'id': 6,
      'nama_siswa': 'Siti Rahmawati',
      'kelas': 'XI RPL A',
      'judul': 'Juara 2 Lomba UI/UX',
      'kategori': 'Prestasi & Lomba',
      'status': 'Ditolak',
      'waktu': '2 Hari yang lalu',
      'deskripsi': 'Proposal desain aplikasi edukasi interaktif untuk anak SD.',
      'peran': 'UI/UX Designer.',
      'skills': ['Figma', 'Prototyping'],
      'link': 'https://figma.com/file/sample',
      'avatar':
          'https://images.unsplash.com/photo-1494790108377-be9c29b29330?auto=format&fit=crop&w=200&q=80',
      'thumbnail':
          'https://images.unsplash.com/photo-1589829545856-d10d557cf95f?auto=format&fit=crop&w=400&q=80',
    },
  ];

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void _updateStatus(int id, String status) {
    setState(() {
      final index = allSubmissions.indexWhere((element) => element['id'] == id);
      if (index != -1) {
        allSubmissions[index]['status'] = status;
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          status == 'Disetujui'
              ? 'Portofolio berhasil disetujui!'
              : 'Portofolio ditolak.',
        ),
        backgroundColor: status == 'Disetujui' ? successGreen : dangerRed,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final statusFilter = selectedTab == 0
        ? 'Menunggu'
        : selectedTab == 1
            ? 'Disetujui'
            : 'Ditolak';

    final query = searchController.text.toLowerCase().trim();

    final filteredList = allSubmissions.where((item) {
      final matchStatus = item['status'] == statusFilter;
      final matchQuery = query.isEmpty ||
          (item['nama_siswa'] as String).toLowerCase().contains(query) ||
          (item['judul'] as String).toLowerCase().contains(query);
      final matchKategori = selectedKategori == 'Semua Kategori' ||
          item['kategori'] == selectedKategori;
      return matchStatus && matchQuery && matchKategori;
    }).toList();

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
          'Verifikasi Portofolio',
          style: TextStyle(
            color: Color(0xFF1E293B),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.notifications_outlined,
              color: Color(0xFF254BD1),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                children: [
                  // TABS STATUS
                  Row(
                    children: [
                      _buildTabButton(0, 'Menunggu(25)'),
                      const SizedBox(width: 8),
                      _buildTabButton(1, 'Disetujui(30)'),
                      const SizedBox(width: 8),
                      _buildTabButton(2, 'Ditolak(40)'),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // SEARCH BAR
                  Container(
                    height: 44,
                    decoration: BoxDecoration(
                      color: const Color(0xFFD9D9D9),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    alignment: Alignment.center,
                    child: TextField(
                      controller: searchController,
                      onChanged: (val) => setState(() {}),
                      decoration: const InputDecoration(
                        icon: Icon(Icons.search, color: Color(0xFF64748B), size: 20),
                        hintText: 'Cari Nama Siswa / Judul Portofolio',
                        hintStyle: TextStyle(
                          color: Color(0xFF64748B),
                          fontSize: 13,
                        ),
                        border: InputBorder.none,
                        isDense: true,
                      ),
                    ),
                  ),

                  const SizedBox(height: 14),

                  // FILTER KATEGORI CAPSULES
                  Row(
                    children: [
                      _buildFilterCapsule('Semua Kategori'),
                      const SizedBox(width: 10),
                      _buildFilterCapsule('Terbaru'),
                    ],
                  ),

                  const SizedBox(height: 18),

                  // DAFTAR KARTU PENGAJUAN
                  if (filteredList.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 40),
                      child: Center(
                        child: Column(
                          children: [
                            Icon(
                              Icons.folder_open_rounded,
                              size: 48,
                              color: Colors.grey.shade400,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Tidak ada portofolio $statusFilter',
                              style: const TextStyle(
                                color: Color(0xFF64748B),
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    ...filteredList.map((item) => _buildSubmissionCard(item)),
                ],
              ),
            ),
          ),

          // PAGINATION DI BAGIAN BAWAH
          _buildPagination(),
        ],
      ),
    );
  }

  Widget _buildTabButton(int index, String label) {
    final bool isSelected = selectedTab == index;
    return Expanded(
      child: InkWell(
        onTap: () {
          setState(() {
            selectedTab = index;
          });
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected ? primaryBlue : cardBg,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : const Color(0xFF1E293B),
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFilterCapsule(String label) {
    final bool isSelected = selectedKategori == label;
    return InkWell(
      onTap: () {
        setState(() {
          selectedKategori = label;
        });
      },
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? primaryBlue : cardBg,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : const Color(0xFF1E293B),
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildSubmissionCard(Map<String, dynamic> item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailPortofolioGuru(portofolio: item),
                ),
              );
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // FOTO SISWA
                CircleAvatar(
                  radius: 22,
                  backgroundImage: NetworkImage(item['avatar']),
                ),
                const SizedBox(width: 12),

                // INFO PORTOFOLIO
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item['nama_siswa'],
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                      Text(
                        item['kelas'],
                        style: const TextStyle(
                          fontSize: 11,
                          color: Color(0xFF64748B),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item['judul'],
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                      Text(
                        item['kategori'],
                        style: const TextStyle(
                          fontSize: 11,
                          color: Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 8),

                // THUMBNAIL SERTIFIKAT / KARYA
                Container(
                  width: 70,
                  height: 52,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    image: DecorationImage(
                      image: NetworkImage(item['thumbnail']),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          // TOMBOL AKSI: SETUJU & TOLAK
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // TOMBOL SETUJU (HIJAU)
              InkWell(
                onTap: () => _updateStatus(item['id'], 'Disetujui'),
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: successGreen,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.check_box_rounded,
                          size: 14, color: Colors.white),
                      SizedBox(width: 6),
                      Text(
                        'Setuju',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(width: 8),

              // TOMBOL TOLAK (MERAH)
              InkWell(
                onTap: () => _updateStatus(item['id'], 'Ditolak'),
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: dangerRed,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.disabled_by_default_rounded,
                          size: 14, color: Colors.white),
                      SizedBox(width: 6),
                      Text(
                        'Tolak',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPagination() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFF1F5F9))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left, size: 20),
            onPressed: currentPage > 1
                ? () => setState(() => currentPage--)
                : null,
          ),
          ...List.generate(6, (index) {
            final page = index + 1;
            final isSelected = page == currentPage;
            return InkWell(
              onTap: () => setState(() => currentPage = page),
              borderRadius: BorderRadius.circular(6),
              child: Container(
                width: 28,
                height: 28,
                margin: const EdgeInsets.symmetric(horizontal: 3),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isSelected ? primaryBlue : const Color(0xFFE2E8F0),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  '$page',
                  style: TextStyle(
                    color: isSelected ? Colors.white : const Color(0xFF1E293B),
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );
          }),
          IconButton(
            icon: const Icon(Icons.chevron_right, size: 20),
            onPressed: currentPage < 6
                ? () => setState(() => currentPage++)
                : null,
          ),
        ],
      ),
    );
  }
}

