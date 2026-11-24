import 'package:flutter/material.dart';
import 'detail_portofolio_guru.dart';
import '../siswa/portofolio_data.dart';
import '../notifikasi_screen.dart';

class VerifikasiPortofolioGuru extends StatefulWidget {
  const VerifikasiPortofolioGuru({super.key});

  @override
  State<VerifikasiPortofolioGuru> createState() =>
      _VerifikasiPortofolioGuruState();
}

class _VerifikasiPortofolioGuruState extends State<VerifikasiPortofolioGuru> {
  static const Color primaryBlue = Color(0xFF254BD1);
  static const Color successGreen = Color(0xFF16A34A);
  static const Color dangerRed = Color(0xFFDC2626);

  final PortofolioDataStore dataStore = PortofolioDataStore();
  final TextEditingController searchController = TextEditingController();

  int selectedTab = 0; // 0: Menunggu, 1: Disetujui, 2: Ditolak
  String selectedKategori = 'Kategori';
  String selectedSort = 'Terbaru'; // 'Terbaru' atau 'Terlama'

  final List<String> kategoriList = [
    'Kategori',
    'Prestasi & Lomba',
    'Sertifikat',
    'Projek',
    'Organisasi',
  ];

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void _updateStatus(String id, String status) {
    dataStore.updateStatus(id, status);

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
    return ValueListenableBuilder<List<PortofolioItem>>(
      valueListenable: dataStore.portofolioList,
      builder: (context, allItems, _) {
        final statusFilter = selectedTab == 0
            ? 'Menunggu'
            : selectedTab == 1
                ? 'Disetujui'
                : 'Ditolak';

        final query = searchController.text.toLowerCase().trim();

        // Hitung total untuk badge tab
        final totalMenunggu = allItems.where((i) => i.status == 'Menunggu').length;
        final totalDisetujui = allItems.where((i) => i.status == 'Disetujui').length;
        final totalDitolak = allItems.where((i) => i.status == 'Ditolak').length;

        List<PortofolioItem> filteredList = allItems.where((item) {
          final matchStatus = item.status == statusFilter;
          final matchQuery = query.isEmpty ||
              item.namaSiswa.toLowerCase().contains(query) ||
              item.judul.toLowerCase().contains(query) ||
              item.kategori.toLowerCase().contains(query) ||
              item.kelas.toLowerCase().contains(query);
          final matchKategori = selectedKategori == 'Kategori' ||
              selectedKategori == 'Semua Kategori' ||
              item.kategori.toLowerCase().contains(selectedKategori.toLowerCase()) ||
              selectedKategori.toLowerCase().contains(item.kategori.toLowerCase());
          return matchStatus && matchQuery && matchKategori;
        }).toList();

        if (selectedSort == 'Terlama') {
          filteredList = filteredList.reversed.toList();
        }

        return Scaffold(
          backgroundColor: const Color(0xFFF8FAFC),
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_rounded, color: Color(0xFF1E293B)),
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
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const NotifikasiScreen(role: 'guru'),
                    ),
                  );
                },
                icon: const Icon(
                  Icons.notifications_outlined,
                  color: primaryBlue,
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
                      // TABS STATUS DENGAN JUMLAH DINAMIS & TEPAT
                      Row(
                        children: [
                          _buildTabButton(0, 'Menunggu ($totalMenunggu)'),
                          const SizedBox(width: 8),
                          _buildTabButton(1, 'Disetujui ($totalDisetujui)'),
                          const SizedBox(width: 8),
                          _buildTabButton(2, 'Ditolak ($totalDitolak)'),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // SEARCH BAR SINKRON & JELAS
                      Container(
                        height: 46,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFCBD5E1), width: 1.2),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x05000000),
                              blurRadius: 6,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        alignment: Alignment.center,
                        child: TextField(
                          controller: searchController,
                          onChanged: (_) => setState(() {}),
                          style: const TextStyle(fontSize: 13, color: Color(0xFF1E293B)),
                          decoration: InputDecoration(
                            icon: const Icon(Icons.search_rounded, color: primaryBlue, size: 20),
                            hintText: 'Cari Nama Siswa / Judul Portofolio',
                            hintStyle: const TextStyle(
                              color: Color(0xFF94A3B8),
                              fontSize: 13,
                            ),
                            border: InputBorder.none,
                            isDense: true,
                            suffixIcon: searchController.text.isNotEmpty
                                ? IconButton(
                                    icon: const Icon(Icons.clear_rounded, size: 16, color: Colors.grey),
                                    onPressed: () {
                                      setState(() {
                                        searchController.clear();
                                      });
                                    },
                                  )
                                : null,
                          ),
                        ),
                      ),

                      const SizedBox(height: 14),

                      // TOMBOL SORT TERBARU & TERLAMA (DIPISAH) DAN DROPDOWN KATEGORI
                      Row(
                        children: [
                          _buildSortButton('Terbaru'),
                          const SizedBox(width: 8),
                          _buildSortButton('Terlama'),
                          const SizedBox(width: 8),

                          // DROPDOWN FILTER KATEGORI
                          Expanded(
                            child: Container(
                              height: 40,
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: const Color(0xFFCBD5E1), width: 1.2),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: selectedKategori,
                                  isExpanded: true,
                                  icon: const Icon(Icons.keyboard_arrow_down_rounded, color: primaryBlue),
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF1E293B),
                                  ),
                                  items: kategoriList.map((kat) {
                                    return DropdownMenuItem<String>(
                                      value: kat,
                                      child: Text(
                                        kat,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (val) {
                                    if (val != null) {
                                      setState(() {
                                        selectedKategori = val;
                                      });
                                    }
                                  },
                                ),
                              ),
                            ),
                          ),
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
            ],
          ),
        );
      },
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
            color: isSelected ? primaryBlue : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? primaryBlue : const Color(0xFFCBD5E1),
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: isSelected ? const Color(0x33254BD1) : const Color(0x05000000),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : const Color(0xFF1E293B),
              fontSize: 11.5,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSubmissionCard(PortofolioItem item) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 1.2),
        boxShadow: const [
          BoxShadow(
            color: Color(0x06000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailPortofolioGuru(portofolio: item.toMap()),
                ),
              );
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // FOTO SISWA
                CircleAvatar(
                  radius: 24,
                  backgroundImage: NetworkImage(item.avatarUrl),
                  backgroundColor: const Color(0xFFCBD5E1),
                ),
                const SizedBox(width: 12),

                // INFO PORTOFOLIO
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              item.namaSiswa,
                              style: const TextStyle(
                                fontSize: 13.5,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF0F172A),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                            decoration: BoxDecoration(
                              color: item.status == 'Disetujui'
                                  ? const Color(0xFFDCFCE7)
                                  : item.status == 'Ditolak'
                                      ? const Color(0xFFFEE2E2)
                                      : const Color(0xFFFFEDD5),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              item.status,
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: item.status == 'Disetujui'
                                    ? successGreen
                                    : item.status == 'Ditolak'
                                        ? dangerRed
                                        : const Color(0xFFEA580C),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Text(
                        item.kelas,
                        style: const TextStyle(
                          fontSize: 11,
                          color: Color(0xFF64748B),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        item.judul,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E293B),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${item.kategori} • ${item.tanggalUnggah}',
                        style: const TextStyle(
                          fontSize: 11,
                          color: Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 10),

                // THUMBNAIL SERTIFIKAT / KARYA
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    width: 72,
                    height: 54,
                    color: const Color(0xFFF1F5F9),
                    child: item.imageUrl != null
                        ? Image.network(
                            item.imageUrl!,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) =>
                                const Icon(Icons.image, color: Colors.grey),
                          )
                        : const Icon(Icons.image, color: Colors.grey),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // TOMBOL AKSI: SETUJU & TOLAK
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // TOMBOL SETUJU (HIJAU)
              InkWell(
                onTap: () => _updateStatus(item.id, 'Disetujui'),
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
                  decoration: BoxDecoration(
                    color: successGreen,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x2416A34A),
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.check_box_rounded, size: 15, color: Colors.white),
                      SizedBox(width: 6),
                      Text(
                        'Setuju',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
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
                onTap: () => _updateStatus(item.id, 'Ditolak'),
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
                  decoration: BoxDecoration(
                    color: dangerRed,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x24DC2626),
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.disabled_by_default_rounded, size: 15, color: Colors.white),
                      SizedBox(width: 6),
                      Text(
                        'Tolak',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
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

  Widget _buildSortButton(String label) {
    final bool isSelected = selectedSort == label;
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: () {
        if (selectedSort != label) {
          setState(() {
            selectedSort = label;
          });
        }
      },
      child: Container(
        height: 40,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: isSelected ? primaryBlue : const Color(0xFFF1F5F9),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? primaryBlue : const Color(0xFFCBD5E1),
            width: 1.2,
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12.5,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            color: isSelected ? Colors.white : const Color(0xFF64748B),
          ),
        ),
      ),
    );
  }
}
