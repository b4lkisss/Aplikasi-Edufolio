import 'package:flutter/material.dart';
import 'portofolio_data.dart';
import 'detail_portofolio_siswa.dart';
import 'tambah_portofolio_siswa.dart';

class PortofolioSaya extends StatefulWidget {
  final String? initialKategori;

  const PortofolioSaya({super.key, this.initialKategori});

  @override
  State<PortofolioSaya> createState() => _PortofolioSayaState();
}

class _PortofolioSayaState extends State<PortofolioSaya> {
  static const Color primaryBlue = Color(0xFF356DA8);
  static const Color inactivePillBg = Color(0xFFD9DFE5);

  final TextEditingController searchController = TextEditingController();
  final dataStore = PortofolioDataStore();

  late String selectedKategori;
  int currentPage = 1;
  final int itemsPerPage = 5;

  final List<String> kategoriList = [
    'Semua',
    'Prestasi & Lomba',
    'Sertifikat',
    'Projek',
    'Organisasi',
  ];

  @override
  void initState() {
    super.initState();
    selectedKategori = widget.initialKategori ?? 'Semua';
    if (!kategoriList.contains(selectedKategori)) {
      selectedKategori = 'Semua';
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
        title: const Text(
          'Portofolio Saya',
          style: TextStyle(
            color: Color(0xFF0F172A),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.notifications_rounded,
              color: primaryBlue,
              size: 26,
            ),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Tidak ada notifikasi baru.'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
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
          final filtered = allItems.where((item) {
            final matchesKategori = selectedKategori == 'Semua' ||
                item.kategori.toLowerCase() == selectedKategori.toLowerCase();
            final matchesQuery = query.isEmpty ||
                item.judul.toLowerCase().contains(query) ||
                item.deskripsi.toLowerCase().contains(query);
            return matchesKategori && matchesQuery;
          }).toList();

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

              // TAB FILTER KATEGORI (HORIZONTAL SCROLL)
              SizedBox(
                height: 42,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  itemCount: kategoriList.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    final kat = kategoriList[index];
                    final isSelected = selectedKategori == kat;
                    return InkWell(
                      borderRadius: BorderRadius.circular(8),
                      onTap: () {
                        setState(() {
                          selectedKategori = kat;
                          currentPage = 1;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected ? primaryBlue : inactivePillBg,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          kat,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: isSelected
                                ? Colors.white
                                : const Color(0xFF334155),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 12),

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
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: Color(0x14000000),
              blurRadius: 10,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            // GAMBAR THUMBNAIL
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Container(
                width: 85,
                height: 60,
                color: const Color(0xFFE2E8F0),
                child: item.imageUrl != null
                    ? Image.network(
                        item.imageUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.image, color: Colors.grey),
                      )
                    : const Icon(Icons.image, color: Colors.grey),
              ),
            ),
            const SizedBox(width: 14),

            // JUDUL DAN KATEGORI
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.judul,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F172A),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.kategori,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF334155),
                    ),
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
}
