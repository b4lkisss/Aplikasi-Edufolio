import 'package:flutter/material.dart';
import 'portofolio_data.dart';
import 'detail_portofolio_siswa.dart';
import 'tambah_portofolio_siswa.dart';
import '../notifikasi_screen.dart';

class PortofolioSaya extends StatefulWidget {
  final String? initialKategori;
  final String? title;

  const PortofolioSaya({super.key, this.initialKategori, this.title});

  @override
  State<PortofolioSaya> createState() => _PortofolioSayaState();
}

class _PortofolioSayaState extends State<PortofolioSaya> {
  static const Color primaryBlue = Color(0xFF356DA8);
  static const Color inactivePillBg = Color(0xFFD9DFE5);

  final TextEditingController searchController = TextEditingController();
  final dataStore = PortofolioDataStore();

  late String selectedKategori;
  String selectedSort = 'Terbaru'; // 'Terbaru' atau 'Terlama'
  int currentPage = 1;
  final int itemsPerPage = 8;

  final List<String> kategoriList = [
    'Kategori',
    'Prestasi & Lomba',
    'Sertifikat',
    'Projek',
    'Organisasi',
  ];

  @override
  void initState() {
    super.initState();
    dataStore.fetchFromSupabase();
    selectedKategori = widget.initialKategori ?? 'Kategori';
    if (selectedKategori == 'Semua' || selectedKategori == 'Semua Kategori') {
      selectedKategori = 'Kategori';
    }
    if (!kategoriList.contains(selectedKategori)) {
      selectedKategori = 'Kategori';
    }
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

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
        title: Text(
          widget.title ?? 'Portofolio Saya',
          style: const TextStyle(
            color: Color(0xFF0F172A),
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
                  builder: (context) => const NotifikasiScreen(role: 'siswa'),
                ),
              );
            },
            icon: Stack(
              clipBehavior: Clip.none,
              children: [
                const Icon(
                  Icons.notifications_rounded,
                  color: primaryBlue,
                  size: 26,
                ),
                ValueListenableBuilder<List<AppNotification>>(
                  valueListenable: dataStore.notifications,
                  builder: (context, notifs, _) {
                    final unread = notifs
                        .where((n) =>
                            !n.isRead &&
                            (n.roleTarget == 'all' || n.roleTarget == 'siswa'))
                        .length;
                    if (unread == 0) return const SizedBox.shrink();
                    return Positioned(
                      right: -3,
                      top: -3,
                      child: Container(
                        padding: const EdgeInsets.all(3),
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 14,
                          minHeight: 14,
                        ),
                        child: Text(
                          '$unread',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryBlue,
        foregroundColor: Colors.white,
        tooltip: 'Tambah Portofolio',
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const TambahPortofolioSiswa(),
            ),
          );
        },
      ),
      body: ValueListenableBuilder<List<PortofolioItem>>(
        valueListenable: dataStore.portofolioList,
        builder: (context, allItems, _) {
          // FILTER BERDASARKAN KATEGORI & PENCARIAN
          final query = searchController.text.trim().toLowerCase();
          List<PortofolioItem> filtered = allItems.where((item) {
            final matchesKategori = selectedKategori == 'Kategori' ||
                selectedKategori == 'Semua Kategori' ||
                selectedKategori == 'Semua' ||
                item.kategori.toLowerCase().contains(selectedKategori.toLowerCase()) ||
                selectedKategori.toLowerCase().contains(item.kategori.toLowerCase());
            final matchesQuery = query.isEmpty ||
                item.judul.toLowerCase().contains(query) ||
                item.deskripsi.toLowerCase().contains(query);
            return matchesKategori && matchesQuery;
          }).toList();

          if (selectedSort == 'Terlama') {
            filtered = filtered.reversed.toList();
          }

          // PAGINATION
          final totalPages =
              (filtered.length / itemsPerPage).ceil().clamp(1, 999);
          final safeCurrentPage = currentPage.clamp(1, totalPages);
          final startIndex = (safeCurrentPage - 1) * itemsPerPage;
          final endIndex =
              (startIndex + itemsPerPage).clamp(0, filtered.length);
          final pageItems = filtered.sublist(startIndex, endIndex);

          return Column(
            children: [
              // SEARCH BAR DENGAN OUTLINE BIRU
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 8,
                ),
                child: Container(
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: primaryBlue, width: 2),
                  ),
                  child: TextField(
                    controller: searchController,
                    onChanged: (val) {
                      setState(() {
                        currentPage = 1;
                      });
                    },
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF1E293B),
                    ),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      prefixIcon: const Icon(
                        Icons.search_rounded,
                        color: primaryBlue,
                        size: 24,
                      ),
                      hintText: 'Cari judul karya...',
                      hintStyle: const TextStyle(
                        color: Color(0xFF94A3B8),
                        fontSize: 14,
                      ),
                      suffixIcon: searchController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(
                                Icons.clear_rounded,
                                color: Colors.grey,
                                size: 18,
                              ),
                              onPressed: () {
                                setState(() {
                                  searchController.clear();
                                  currentPage = 1;
                                });
                              },
                            )
                          : null,
                      contentPadding:
                          const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ),

              // TAB TERBARU/TERLAMA DI KIRI DAN DROPDOWN KATEGORI DI KANAN
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Row(
                  children: [
                    // TOMBOL SORT TERBARU & TERLAMA (DIPISAH) DAN DROPDOWN KATEGORI
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
                            icon: const Icon(
                              Icons.keyboard_arrow_down_rounded,
                              color: primaryBlue,
                              size: 20,
                            ),
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
                                  currentPage = 1;
                                });
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 14),

              // LIST ITEM PORTOFOLIO
              Expanded(
                child: pageItems.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.folder_open_rounded,
                              size: 54,
                              color: Colors.grey.shade400,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Belum ada karya untuk kategori ini',
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 6,
                        ),
                        itemCount: pageItems.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final item = pageItems[index];
                          return _buildPortofolioCard(item);
                        },
                      ),
              ),

              // PAGINATION DI BAGIAN BAWAH
              Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 20),
                child: _buildPagination(totalPages, safeCurrentPage),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildPortofolioCard(PortofolioItem item) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailPortofolioSiswa(portofolio: item),
          ),
        );
      },
      child: Container(
        height: 86, // Ukuran card disamakan seragam
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE2E8F0), width: 1),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0C000000),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // GAMBAR THUMBNAIL BERUKURAN SAMA
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: SizedBox(
                width: 85,
                height: 64,
                child: item.imageBytes != null
                    ? Image.memory(
                        item.imageBytes!,
                        fit: BoxFit.cover,
                      )
                    : (item.imageUrl != null
                        ? Image.network(
                            item.imageUrl!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Container(
                              color: const Color(0xFFF1F5F9),
                              child: const Icon(Icons.image_outlined, color: Colors.grey),
                            ),
                          )
                        : Container(
                            color: const Color(0xFFF1F5F9),
                            child: const Icon(Icons.image_outlined, color: Colors.grey),
                          )),
              ),
            ),
            const SizedBox(width: 14),

            // JUDUL DAN KATEGORI
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.judul,
                    style: const TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F172A),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    '${item.kategori} • ${item.tanggalUnggah.isNotEmpty ? item.tanggalUnggah : item.tanggal}',
                    style: const TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF64748B),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            // CHEVRON PANAH KANAN BIRU
            const Icon(
              Icons.chevron_right_rounded,
              color: primaryBlue,
              size: 24,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPagination(int totalPages, int activePage) {
    if (totalPages <= 1) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 6, vertical: 4),
            child: Icon(
              Icons.chevron_left_rounded,
              color: Color(0xFFCBD5E1),
              size: 20,
            ),
          ),
          const SizedBox(width: 4),
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: primaryBlue,
              borderRadius: BorderRadius.circular(6),
            ),
            alignment: Alignment.center,
            child: const Text(
              '1',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 4),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 6, vertical: 4),
            child: Icon(
              Icons.chevron_right_rounded,
              color: Color(0xFFCBD5E1),
              size: 20,
            ),
          ),
        ],
      );
    }

    // Tombol 1 sampai max 6 atau totalPages
    final displayCount = totalPages > 6 ? 6 : totalPages;
    final List<int> pages = List.generate(displayCount, (i) => i + 1);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // PANAH PREV
        InkWell(
          borderRadius: BorderRadius.circular(6),
          onTap: activePage > 1
              ? () {
                  setState(() {
                    currentPage = activePage - 1;
                  });
                }
              : null,
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 6, vertical: 4),
            child: Icon(
              Icons.chevron_left_rounded,
              color: primaryBlue,
              size: 20,
            ),
          ),
        ),

        const SizedBox(width: 4),

        // NOMOR HALAMAN
        ...pages.map((p) {
          final isCurrent = p == activePage;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 3),
            child: InkWell(
              borderRadius: BorderRadius.circular(6),
              onTap: () {
                setState(() {
                  currentPage = p;
                });
              },
              child: Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: isCurrent ? primaryBlue : inactivePillBg,
                  borderRadius: BorderRadius.circular(6),
                ),
                alignment: Alignment.center,
                child: Text(
                  '$p',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: isCurrent ? Colors.white : const Color(0xFF1E293B),
                  ),
                ),
              ),
            ),
          );
        }),

        const SizedBox(width: 4),

        // PANAH NEXT
        InkWell(
          borderRadius: BorderRadius.circular(6),
          onTap: activePage < totalPages
              ? () {
                  setState(() {
                    currentPage = activePage + 1;
                  });
                }
              : null,
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 6, vertical: 4),
            child: Icon(
              Icons.chevron_right_rounded,
              color: primaryBlue,
              size: 20,
            ),
          ),
        ),
      ],
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
            currentPage = 1;
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
