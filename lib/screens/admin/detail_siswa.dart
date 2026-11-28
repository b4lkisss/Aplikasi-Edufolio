import 'package:flutter/material.dart';
import '../siswa/portofolio_data.dart';
import '../siswa/detail_portofolio_siswa.dart';

class DetailSiswa extends StatefulWidget {
  final Map<String, dynamic> siswa;

  const DetailSiswa({
    super.key,
    required this.siswa,
  });

  @override
  State<DetailSiswa> createState() => _DetailSiswaState();
}

class _DetailSiswaState extends State<DetailSiswa> {
  final Color primaryColor = const Color(0xFF356DA8);
  final Color cardBgColor = const Color(0xFFE2E8F0);
  final PortofolioDataStore dataStore = PortofolioDataStore();

  @override
  void initState() {
    super.initState();
    dataStore.fetchFromSupabase();
  }

  @override
  Widget build(BuildContext context) {
    final siswa = widget.siswa;
    final nama = siswa['nama'] ?? 'Siswa';
    final nisn = siswa['nisn'] ?? '-';
    final kelas = siswa['kelas'] ?? 'XII RPL B';
    final jurusan = siswa['jurusan'] ?? 'Rekayasa Perangkat Lunak';
    final angkatan = siswa['angkatan'] ?? '2024';
    final siswaId = siswa['id']?.toString();

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
                ],
              ),
            ),

            // KONTEN SCROLLABLE DENGAN DATA NYATA
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  await dataStore.fetchFromSupabase();
                },
                color: primaryColor,
                child: ValueListenableBuilder<List<PortofolioItem>>(
                  valueListenable: dataStore.portofolioList,
                  builder: (context, allPortofolio, _) {
                    // Filter portofolio yang benar-benar milik siswa ini
                    final studentPortofolio = allPortofolio.where((p) {
                      final matchId = siswaId != null && siswaId.isNotEmpty && p.idSiswa == siswaId;
                      final matchNisn = nisn != '-' && p.idSiswa == nisn;
                      final matchNama = p.namaSiswa.toLowerCase().trim() == nama.toString().toLowerCase().trim();
                      return matchId || matchNisn || matchNama;
                    }).toList();

                    // Hitung statistik real dari database
                    final totalPortofolio = studentPortofolio.length;
                    final totalPrestasi = studentPortofolio.where((p) =>
                        p.kategori.toLowerCase().contains('prestasi') ||
                        p.kategori.toLowerCase().contains('lomba')).length;
                    final totalSertifikat = studentPortofolio.where((p) =>
                        p.kategori.toLowerCase().contains('sertifikat')).length;

                    return SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
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
                                  image: DecorationImage(
                                    image: PortofolioItem.getAvatarImageProvider(
                                      null,
                                      siswa['avatarUrl']?.toString(),
                                    ),
                                    fit: BoxFit.cover,
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
                                      style: const TextStyle(
                                        fontSize: 11.5,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xE6356DA8),
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

                          // 3 KOTAK STATISTIK NYATA (PORTOFOLIO, PRESTASI, SERTIFIKAT)
                          Row(
                            children: [
                              _buildStatBox('Portofolio', '$totalPortofolio'),
                              const SizedBox(width: 10),
                              _buildStatBox('Prestasi', '$totalPrestasi'),
                              const SizedBox(width: 10),
                              _buildStatBox('Sertifikat', '$totalSertifikat'),
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
                                  siswa['email'] != null && siswa['email'].toString().isNotEmpty
                                      ? siswa['email'].toString()
                                      : '-',
                                ),
                                const SizedBox(height: 10),
                                _buildInfoRow(
                                  'No Telpon',
                                  siswa['no_telepon'] != null && siswa['no_telepon'].toString().isNotEmpty
                                      ? siswa['no_telepon'].toString()
                                      : (siswa['telepon'] ?? '-'),
                                ),
                                const SizedBox(height: 10),
                                _buildInfoRow(
                                  'Jenis Kelamin',
                                  siswa['jenis_kelamin'] != null && siswa['jenis_kelamin'].toString().isNotEmpty
                                      ? siswa['jenis_kelamin'].toString()
                                      : (siswa['gender'] ?? '-'),
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

                          // DAFTAR PORTOFOLIO SISWA (DATA NYATA SUPABASE)
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
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Daftar Portofolio Siswa',
                                      style: TextStyle(
                                        fontSize: 13.5,
                                        fontWeight: FontWeight.bold,
                                        color: primaryColor,
                                      ),
                                    ),
                                    Text(
                                      '$totalPortofolio Portofolio',
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                        color: primaryColor,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 14),

                                // EMPTY STATE JIKA BELUM ADA PORTOFOLIO
                                if (studentPortofolio.isEmpty)
                                  Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Center(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.folder_open_rounded,
                                            size: 38,
                                            color: Colors.grey.shade400,
                                          ),
                                          const SizedBox(height: 8),
                                          const Text(
                                            'Belum Ada Portofolio',
                                            style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xFF1E293B),
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            'Siswa ini belum mengunggah karya portofolio apapun.',
                                            style: TextStyle(
                                              fontSize: 11,
                                              color: Colors.grey.shade600,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                else
                                  // LIST ITEM PORTOFOLIO REAL DARI SUPABASE
                                  ...studentPortofolio.map((item) {
                                    final isDisetujui = item.status == 'Disetujui';
                                    final isDitolak = item.status == 'Ditolak';

                                    final statusBg = isDisetujui
                                        ? const Color(0xFF2E7D32)
                                        : (isDitolak ? const Color(0xFFDC2626) : const Color(0xFFEA580C));

                                    return InkWell(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => DetailPortofolioSiswa(
                                              portofolio: item,
                                            ),
                                          ),
                                        );
                                      },
                                      borderRadius: BorderRadius.circular(10),
                                      child: Container(
                                        margin: const EdgeInsets.only(bottom: 10),
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: Row(
                                          children: [
                                            // THUMBNAIL FOTO / GAMBAR PORTOFOLIO
                                            ClipRRect(
                                              borderRadius: BorderRadius.circular(8),
                                              child: Container(
                                                width: 58,
                                                height: 44,
                                                color: const Color(0xFFEFF6FF),
                                                child: (item.imageUrl != null &&
                                                        item.imageUrl!.isNotEmpty &&
                                                        item.imageUrl!.startsWith('http'))
                                                    ? Image.network(
                                                        item.imageUrl!,
                                                        fit: BoxFit.cover,
                                                        errorBuilder: (_, __, ___) => Center(
                                                          child: Icon(
                                                            Icons.description_outlined,
                                                            size: 22,
                                                            color: primaryColor,
                                                          ),
                                                        ),
                                                      )
                                                    : Center(
                                                        child: Icon(
                                                          Icons.description_outlined,
                                                          size: 22,
                                                          color: primaryColor,
                                                        ),
                                                      ),
                                              ),
                                            ),

                                            const SizedBox(width: 10),

                                            // JUDUL & KATEGORI
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    item.judul,
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight: FontWeight.bold,
                                                      color: primaryColor,
                                                    ),
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                  const SizedBox(height: 3),
                                                  Text(
                                                    '${item.kategori} • ${item.tanggalUnggah}',
                                                    style: const TextStyle(
                                                      fontSize: 10,
                                                      color: Color(0xFF64748B),
                                                      fontWeight: FontWeight.w500,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),

                                            const SizedBox(width: 8),

                                            // BADGE STATUS VERIFIKASI
                                            Container(
                                              padding: const EdgeInsets.symmetric(
                                                horizontal: 8,
                                                vertical: 4,
                                              ),
                                              decoration: BoxDecoration(
                                                color: statusBg,
                                                borderRadius: BorderRadius.circular(5),
                                              ),
                                              child: Text(
                                                item.status,
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 9.5,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
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
                    );
                  },
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

