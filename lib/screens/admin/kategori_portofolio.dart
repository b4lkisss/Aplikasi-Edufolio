import 'package:flutter/material.dart';

class KategoriPortofolio extends StatefulWidget {
  const KategoriPortofolio({super.key});

  @override
  State<KategoriPortofolio> createState() => _KategoriPortofolioState();
}

class _KategoriPortofolioState extends State<KategoriPortofolio> {
  final Color primaryColor = const Color(0xFF356DA8);
  final Color fieldColor = const Color(0xFFD9D9D9);
  final Color cardBgColor = const Color(0xFFD5D8DC);

  int currentPage = 1;
  final int itemsPerPage = 5;

  List<Map<String, dynamic>> daftarKategori = [
    {
      'nama': 'Prestasi & Lomba',
      'jumlah': '122 data',
      'icon': Icons.emoji_events_outlined,
    },
    {
      'nama': 'Sertifikat',
      'jumlah': '122 data',
      'icon': Icons.card_membership_outlined,
    },
    {
      'nama': 'Project / Karya',
      'jumlah': '122 data',
      'icon': Icons.military_tech_outlined,
    },
    {
      'nama': 'Organisasi',
      'jumlah': '122 data',
      'icon': Icons.account_tree_outlined,
    },
    {
      'nama': 'Ekstrakulikuler',
      'jumlah': '122 data',
      'icon': Icons.menu_book_outlined,
    },
  ];

  // FORM TAMBAH / EDIT KATEGORI
  void tampilkanFormKategori({Map<String, dynamic>? kategori, int? index}) {
    final controller = TextEditingController(text: kategori?['nama'] ?? '');

    showDialog(
      context: context,
      builder: (dialogContext) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          backgroundColor: Colors.white,
          insetPadding: const EdgeInsets.symmetric(horizontal: 28),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 22, 20, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Nama Kategori',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: controller,
                  autofocus: true,
                  style: TextStyle(
                    fontSize: 13,
                    color: primaryColor,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Masukkan nama kategori...',
                    hintStyle: TextStyle(
                      fontSize: 12.5,
                      color: Colors.grey.shade400,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: primaryColor,
                        width: 1,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: primaryColor,
                        width: 1,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: primaryColor,
                        width: 1.5,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 42,
                  child: ElevatedButton(
                    onPressed: () {
                      final namaBaru = controller.text.trim();
                      if (namaBaru.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Nama kategori tidak boleh kosong'),
                          ),
                        );
                        return;
                      }

                      setState(() {
                        if (index == null) {
                          daftarKategori.add({
                            'nama': namaBaru,
                            'jumlah': '0 data',
                            'icon': Icons.folder_outlined,
                          });
                        } else {
                          daftarKategori[index]['nama'] = namaBaru;
                        }
                      });

                      Navigator.pop(dialogContext);

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            index == null
                                ? 'Kategori berhasil ditambahkan'
                                : 'Kategori berhasil diperbarui',
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
                      'Simpan Kategori',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // DIALOG KONFIRMASI HAPUS KATEGORI
  void konfirmasiHapusKategori(int index) {
    final kategori = daftarKategori[index];

    showDialog(
      context: context,
      builder: (dialogContext) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
          backgroundColor: Colors.white,
          insetPadding: const EdgeInsets.symmetric(horizontal: 36),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 26, 20, 22),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // ICON TONG SAMPAH BULAT MERAH
                Container(
                  width: 80,
                  height: 80,
                  decoration: const BoxDecoration(
                    color: Color(0xFFEF5350),
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.delete_rounded,
                      size: 44,
                      color: Colors.white,
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                const Text(
                  'Hapus Kategori?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  'Apakah Anda yakin ingin menghapus kategori\n${kategori['nama']} ?',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 12.5,
                    color: Colors.black87,
                    height: 1.4,
                  ),
                ),

                const SizedBox(height: 22),

                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 40,
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(dialogContext),
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: primaryColor, width: 1.5),
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
                        height: 40,
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              daftarKategori.removeAt(index);
                              final totalPages =
                                  (daftarKategori.length / itemsPerPage).ceil();
                              if (currentPage > totalPages && totalPages > 0) {
                                currentPage = totalPages;
                              }
                            });

                            Navigator.pop(dialogContext);

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Kategori berhasil dihapus'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFE53935),
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            'Hapus',
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
  }

  @override
  Widget build(BuildContext context) {
    final totalPages = (daftarKategori.length / itemsPerPage).ceil();
    final safePage = totalPages == 0 ? 1 : currentPage.clamp(1, totalPages);
    final startIndex = (safePage - 1) * itemsPerPage;
    final endIndex = (startIndex + itemsPerPage).clamp(0, daftarKategori.length);
    final pageData = daftarKategori.sublist(startIndex, endIndex);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
                    'Kategori',
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

            const SizedBox(height: 6),

            // SUBTITLE KATEGORI PORTOFOLIO
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Kategori Portofolio',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),

            const SizedBox(height: 14),

            // DAFTAR ITEM KATEGORI
            Expanded(
              child: pageData.isEmpty
                  ? const Center(
                      child: Text(
                        'Belum ada kategori',
                        style: TextStyle(fontSize: 12),
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: pageData.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        final item = pageData[index];
                        final originalIndex = daftarKategori.indexOf(item);

                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: cardBgColor,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              // ICON BULAT PUTIH
                              Container(
                                width: 44,
                                height: 44,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  item['icon'] as IconData,
                                  color: Colors.black87,
                                  size: 22,
                                ),
                              ),

                              const SizedBox(width: 14),

                              // JUDUL & JUMLAH DATA
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item['nama'] as String,
                                      style: const TextStyle(
                                        fontSize: 12.5,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    const SizedBox(height: 3),
                                    Text(
                                      item['jumlah'] as String,
                                      style: const TextStyle(
                                        fontSize: 10.5,
                                        color: Colors.black54,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // TOMBOL EDIT (KOTAK PUTIH KECIL)
                              InkWell(
                                borderRadius: BorderRadius.circular(6),
                                onTap: () => tampilkanFormKategori(
                                  kategori: item,
                                  index: originalIndex,
                                ),
                                child: Container(
                                  width: 32,
                                  height: 32,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: const Icon(
                                    Icons.edit_rounded,
                                    size: 16,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),

                              const SizedBox(width: 8),

                              // TOMBOL HAPUS (KOTAK PUTIH KECIL)
                              InkWell(
                                borderRadius: BorderRadius.circular(6),
                                onTap: () => konfirmasiHapusKategori(originalIndex),
                                child: Container(
                                  width: 32,
                                  height: 32,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: const Icon(
                                    Icons.delete_rounded,
                                    size: 16,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),

            const SizedBox(height: 10),

            // TOMBOL + TAMBAH KATEGORI (LEBAR PENUH)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                width: double.infinity,
                height: 44,
                child: ElevatedButton.icon(
                  onPressed: () => tampilkanFormKategori(),
                  icon: const Icon(
                    Icons.add,
                    color: Colors.white,
                    size: 20,
                  ),
                  label: const Text(
                    'Tambah Kategori',
                    style: TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // PAGINATION
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: safePage > 1
                        ? () {
                            setState(() {
                              currentPage--;
                            });
                          }
                        : null,
                    icon: Icon(
                      Icons.chevron_left,
                      color: primaryColor,
                    ),
                    iconSize: 19,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(minWidth: 28),
                  ),
                  ...List.generate(totalPages > 0 ? totalPages : 1, (index) {
                    final page = index + 1;
                    final selected = safePage == page;

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          currentPage = page;
                        });
                      },
                      child: Container(
                        width: 25,
                        height: 25,
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: selected ? primaryColor : fieldColor,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          '$page',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: selected ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                    );
                  }),
                  IconButton(
                    onPressed: safePage < totalPages
                        ? () {
                            setState(() {
                              currentPage++;
                            });
                          }
                        : null,
                    icon: Icon(
                      Icons.chevron_right,
                      color: primaryColor,
                    ),
                    iconSize: 19,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(minWidth: 28),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

