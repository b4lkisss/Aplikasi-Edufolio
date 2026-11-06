
import 'package:flutter/material.dart';
import 'detail_siswa.dart';

class DataSiswa extends StatefulWidget {
  const DataSiswa({super.key});

  @override
  State<DataSiswa> createState() => _DataSiswaState();
}

class _DataSiswaState extends State<DataSiswa> {
  final Color primaryColor = const Color(0xFF356DA8);
  final Color fieldColor = const Color(0xFFD9D9D9);

  final TextEditingController searchController =
      TextEditingController();

  String selectedKelas = 'Semua Kelas';
  String selectedJurusan = 'Semua Jurusan';
  String selectedAngkatan = 'Semua Angkatan';

  int currentPage = 1;
  final int itemsPerPage = 9;

  // DATA CONTOH SISWA
  List<Map<String, dynamic>> daftarSiswa = [
    {
      'nama': 'Balqis Demes Piscesa',
      'nisn': '1234567890',
      'kelas': 'XII RPL B',
      'jurusan': 'RPL',
      'angkatan': '2024',
      'avatar': 0,
    },
    {
      'nama': 'Andi Ardiansyah',
      'nisn': '1234567891',
      'kelas': 'XII RPL B',
      'jurusan': 'RPL',
      'angkatan': '2024',
      'avatar': 1,
    },
    {
      'nama': 'Siti Aulia',
      'nisn': '1234567892',
      'kelas': 'XI RPL A',
      'jurusan': 'RPL',
      'angkatan': '2025',
      'avatar': 0,
    },
    {
      'nama': 'Muhammad Rizky',
      'nisn': '1234567893',
      'kelas': 'XI TKJ A',
      'jurusan': 'TKJ',
      'angkatan': '2025',
      'avatar': 1,
    },
    {
      'nama': 'Nadia Putri',
      'nisn': '1234567894',
      'kelas': 'XII RPL B',
      'jurusan': 'RPL',
      'angkatan': '2024',
      'avatar': 0,
    },
    {
      'nama': 'Dimas Pratama',
      'nisn': '1234567895',
      'kelas': 'X TKJ B',
      'jurusan': 'TKJ',
      'angkatan': '2026',
      'avatar': 1,
    },
    {
      'nama': 'Ayu Lestari',
      'nisn': '1234567896',
      'kelas': 'XI RPL A',
      'jurusan': 'RPL',
      'angkatan': '2025',
      'avatar': 0,
    },
    {
      'nama': 'Fajar Ramadhan',
      'nisn': '1234567897',
      'kelas': 'XII TKJ A',
      'jurusan': 'TKJ',
      'angkatan': '2024',
      'avatar': 1,
    },
    {
      'nama': 'Putri Amelia',
      'nisn': '1234567898',
      'kelas': 'X RPL A',
      'jurusan': 'RPL',
      'angkatan': '2026',
      'avatar': 0,
    },
    {
      'nama': 'Rian Saputra',
      'nisn': '1234567899',
      'kelas': 'XI TKJ A',
      'jurusan': 'TKJ',
      'angkatan': '2025',
      'avatar': 1,
    },
    {
      'nama': 'Dewi Anggraini',
      'nisn': '1234567800',
      'kelas': 'X RPL B',
      'jurusan': 'RPL',
      'angkatan': '2026',
      'avatar': 0,
    },
  ];

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  // FILTER DATA SISWA
  List<Map<String, dynamic>> get filteredSiswa {
    return daftarSiswa.where((siswa) {
      final search = searchController.text.toLowerCase();

      final cocokPencarian =
          siswa['nama'].toString().toLowerCase().contains(search) ||
          siswa['nisn'].toString().contains(search);

      final cocokKelas = selectedKelas == 'Semua Kelas' ||
          siswa['kelas'] == selectedKelas;

      final cocokJurusan = selectedJurusan == 'Semua Jurusan' ||
          siswa['jurusan'] == selectedJurusan;

      final cocokAngkatan = selectedAngkatan == 'Semua Angkatan' ||
          siswa['angkatan'] == selectedAngkatan;

      return cocokPencarian &&
          cocokKelas &&
          cocokJurusan &&
          cocokAngkatan;
    }).toList();
  }

  // TAMBAH SISWA
  void tambahSiswa() {
    tampilkanFormSiswa();
  }

  // EDIT SISWA
  void editSiswa(int index) {
    final siswa = daftarSiswa[index];
    tampilkanFormSiswa(siswa: siswa, index: index);
  }

  // FORM TAMBAH DAN EDIT
  void tampilkanFormSiswa({
    Map<String, dynamic>? siswa,
    int? index,
  }) {
    final namaController =
        TextEditingController(text: siswa?['nama'] ?? '');

    final nisnController =
        TextEditingController(text: siswa?['nisn'] ?? '');

    String kelas = siswa?['kelas'] ?? 'X RPL A';
    String jurusan = siswa?['jurusan'] ?? 'RPL';
    String angkatan = siswa?['angkatan'] ?? '2026';

    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text(
                siswa == null ? 'Tambah Siswa' : 'Edit Siswa',
                style: TextStyle(
                  color: primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),

              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [

                    _formInput(
                      'Nama Lengkap',
                      namaController,
                    ),

                    _formInput(
                      'NISN',
                      nisnController,
                      keyboardType: TextInputType.number,
                    ),

                    _formDropdown(
                      'Kelas',
                      kelas,
                      [
                        'X RPL A',
                        'X RPL B',
                        'XI RPL A',
                        'XI RPL B',
                        'XII RPL B',
                        'X TKJ B',
                        'XI TKJ A',
                        'XII TKJ A',
                      ],
                      (value) {
                        setDialogState(() {
                          kelas = value!;
                        });
                      },
                    ),

                    _formDropdown(
                      'Jurusan',
                      jurusan,
                      ['RPL', 'TKJ'],
                      (value) {
                        setDialogState(() {
                          jurusan = value!;
                        });
                      },
                    ),

                    _formDropdown(
                      'Angkatan',
                      angkatan,
                      ['2024', '2025', '2026'],
                      (value) {
                        setDialogState(() {
                          angkatan = value!;
                        });
                      },
                    ),
                  ],
                ),
              ),

              actions: [

                TextButton(
                  onPressed: () {
                    Navigator.pop(dialogContext);
                  },
                  child: const Text('Batal'),
                ),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                  ),

                  onPressed: () {
                    if (namaController.text.trim().isEmpty ||
                        nisnController.text.trim().isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Nama dan NISN wajib diisi',
                          ),
                        ),
                      );
                      return;
                    }

                    if (!RegExp(r'^\d{10}$')
                        .hasMatch(nisnController.text.trim())) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'NISN harus terdiri dari 10 angka',
                          ),
                        ),
                      );
                      return;
                    }

                    final nisn = nisnController.text.trim();

                    final nisnSudahAda = daftarSiswa.any((item) {
                      return item['nisn'] == nisn &&
                          (index == null ||
                              daftarSiswa.indexOf(item) != index);
                    });

                    if (nisnSudahAda) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('NISN sudah terdaftar'),
                        ),
                      );
                      return;
                    }

                    setState(() {
                      final dataBaru = {
                        'nama': namaController.text.trim(),
                        'nisn': nisn,
                        'kelas': kelas,
                        'jurusan': jurusan,
                        'angkatan': angkatan,
                        'avatar': 0,
                      };

                      if (index == null) {
                        daftarSiswa.add(dataBaru);
                      } else {
                        daftarSiswa[index] = dataBaru;
                      }

                      currentPage = 1;
                    });

                    Navigator.pop(dialogContext);

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          siswa == null
                              ? 'Siswa berhasil ditambahkan'
                              : 'Data siswa berhasil diperbarui',
                        ),
                        backgroundColor: Colors.green,
                      ),
                    );
                  },

                  child: Text(
                    siswa == null ? 'Tambah' : 'Simpan',
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // HAPUS SISWA (SESUAI GAMBAR CONTOH)
  void hapusSiswa(int index) {
    final siswa = daftarSiswa[index];

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
                  width: 86,
                  height: 86,
                  decoration: const BoxDecoration(
                    color: Color(0xFFEF5350),
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.delete_rounded,
                      size: 48,
                      color: Colors.white,
                    ),
                  ),
                ),

                const SizedBox(height: 18),

                // JUDUL: Hapus Data Siswa?
                const Text(
                  'Hapus Data Siswa?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),

                const SizedBox(height: 8),

                // DESKRIPSI
                Text(
                  'Apakah Anda yakin ingin menghapus data\n${siswa['nama']} ?',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 12.5,
                    color: Colors.black87,
                    height: 1.4,
                  ),
                ),

                const SizedBox(height: 22),

                // DUA TOMBOL: BATAL & HAPUS
                Row(
                  children: [
                    // TOMBOL BATAL (OUTLINE BIRU)
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

                    // TOMBOL HAPUS (MERAH)
                    Expanded(
                      child: SizedBox(
                        height: 40,
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              daftarSiswa.removeAt(index);

                              if (currentPage > 1 &&
                                  (currentPage - 1) * itemsPerPage >=
                                      filteredSiswa.length) {
                                currentPage--;
                              }
                            });

                            Navigator.pop(dialogContext);

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Data siswa berhasil dihapus'),
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

  // DETAIL SISWA (MEMBUKA HALAMAN DETAIL SISWA SESUAI GAMBAR CONTOH)
  void tampilkanDetailSiswa(Map<String, dynamic> siswa) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailSiswa(siswa: siswa),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final data = filteredSiswa;

    final totalPages =
        (data.length / itemsPerPage).ceil();

    final safePage = totalPages == 0
        ? 1
        : currentPage.clamp(1, totalPages);

    final startIndex = (safePage - 1) * itemsPerPage;

    final endIndex =
        (startIndex + itemsPerPage).clamp(0, data.length);

    final pageData = data.sublist(startIndex, endIndex);

    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: Column(
          children: [

            // HEADER
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 10,
              ),

              child: Row(
                children: [

                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },

                    child: const Row(
                      children: [
                        Icon(Icons.arrow_back, size: 20),
                        SizedBox(width: 5),
                        Text(
                          'Data Siswa',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const Spacer(),

                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.notifications,
                      color: primaryColor,
                      size: 24,
                    ),
                  ),
                ],
              ),
            ),

            // PENCARIAN (FULL WIDTH)
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
              ),
              child: SizedBox(
                height: 36,
                child: TextField(
                  controller: searchController,
                  onChanged: (value) {
                    setState(() {
                      currentPage = 1;
                    });
                  },
                  style: TextStyle(
                    color: primaryColor,
                    fontSize: 11,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Cari nama/NISN...',
                    hintStyle: TextStyle(
                      color: const Color(0xB3356DA8),
                      fontSize: 11,
                    ),
                    prefixIcon: const Icon(
                      Icons.search,
                      color: Color(0xFF64AFCF),
                      size: 18,
                    ),
                    prefixIconConstraints: const BoxConstraints(
                      minWidth: 30,
                    ),
                    filled: true,
                    fillColor: fieldColor,
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 8,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 10),

            // BARIS FILTER DAN TOMBOL TAMBAH SISWA (SEJAJAR & UKURAN SAMA PERSIS)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: [
                  // DAFTAR FILTER DROPDOWN
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _filterDropdown(
                            selectedKelas,
                            [
                              'Semua Kelas',
                              'X RPL A',
                              'X RPL B',
                              'XI RPL A',
                              'XI RPL B',
                              'XII RPL B',
                              'X TKJ B',
                              'XI TKJ A',
                              'XII TKJ A',
                            ],
                            (value) {
                              setState(() {
                                selectedKelas = value!;
                                currentPage = 1;
                              });
                            },
                          ),
                          const SizedBox(width: 6),
                          _filterDropdown(
                            selectedJurusan,
                            [
                              'Semua Jurusan',
                              'RPL',
                              'TKJ',
                            ],
                            (value) {
                              setState(() {
                                selectedJurusan = value!;
                                currentPage = 1;
                              });
                            },
                            isPrimary: true,
                          ),
                          const SizedBox(width: 6),
                          _filterDropdown(
                            selectedAngkatan,
                            [
                              'Semua Angkatan',
                              '2024',
                              '2025',
                              '2026',
                            ],
                            (value) {
                              setState(() {
                                selectedAngkatan = value!;
                                currentPage = 1;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(width: 8),

                  // TOMBOL TAMBAH SISWA (UKURAN PERSIS SAMA DENGAN DATA GURU)
                  InkWell(
                    borderRadius: BorderRadius.circular(8),
                    onTap: tambahSiswa,
                    child: Container(
                      height: 38,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      alignment: Alignment.center,
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.add,
                            size: 18,
                            color: Colors.white,
                          ),
                          SizedBox(width: 5),
                          Text(
                            'Tambah Siswa',
                            style: TextStyle(
                              fontSize: 11.5,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 15),

            // DAFTAR SISWA
            Expanded(
              child: pageData.isEmpty
                  ? const Center(
                      child: Text(
                        'Data siswa tidak ditemukan',
                        style: TextStyle(fontSize: 12),
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      itemCount: pageData.length,
                      separatorBuilder: (context, index) {
                        return const SizedBox(height: 10);
                      },
                      itemBuilder: (context, index) {
                        final siswa = pageData[index];

                        final originalIndex =
                            daftarSiswa.indexOf(siswa);

                        return _buildStudentItem(
                          siswa,
                          originalIndex,
                        );
                      },
                    ),
            ),

            const SizedBox(height: 12),

            // PAGINATION
            Padding(
              padding: const EdgeInsets.only(
                bottom: 8,
                left: 10,
                right: 10,
              ),

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
                    constraints: const BoxConstraints(
                      minWidth: 28,
                    ),
                  ),

                  if (totalPages > 0)
                    ...List.generate(totalPages, (index) {
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
                          margin: const EdgeInsets.symmetric(
                            horizontal: 5,
                          ),

                          alignment: Alignment.center,

                          decoration: BoxDecoration(
                            color: selected
                                ? primaryColor
                                : fieldColor,
                            borderRadius: BorderRadius.circular(5),
                          ),

                          child: Text(
                            '$page',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: selected
                                  ? Colors.white
                                  : Colors.black,
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
                    constraints: const BoxConstraints(
                      minWidth: 28,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }


  // ITEM SISWA
  Widget _buildStudentItem(
    Map<String, dynamic> siswa,
    int originalIndex,
  ) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),

      child: InkWell(
        borderRadius: BorderRadius.circular(10),

        // KLIK CARD UNTUK MELIHAT DETAIL
        onTap: () {
          tampilkanDetailSiswa(siswa);
        },

        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 9,
            vertical: 10,
          ),

          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: const Color(0xFFE5E5E5),
              width: 1,
            ),
          ),

          child: Row(
            children: [

              // FOTO SISWA
              CircleAvatar(
                radius: 25,
                backgroundColor: fieldColor,
                child: Icon(
                  siswa['avatar'] == 0
                      ? Icons.person
                      : Icons.face,
                  color: primaryColor,
                  size: 30,
                ),
              ),

              const SizedBox(width: 10),

              // NAMA DAN KELAS
              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [

                    Text(
                      siswa['nama'],
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      siswa['kelas'],
                      style: const TextStyle(
                        fontSize: 10,
                        color: Colors.black54,
                      ),
                    ),

                  ],
                ),
              ),

              // TOMBOL EDIT
              IconButton(
                onPressed: () {
                  editSiswa(originalIndex);
                },
                icon: const Icon(
                  Icons.edit,
                  size: 19,
                  color: Colors.black,
                ),
                style: IconButton.styleFrom(
                  backgroundColor: fieldColor,
                  padding: const EdgeInsets.all(5),
                  minimumSize: const Size(29, 29),
                ),
              ),

              const SizedBox(width: 5),

              // TOMBOL HAPUS
              IconButton(
                onPressed: () {
                  hapusSiswa(originalIndex);
                },
                icon: const Icon(
                  Icons.delete,
                  size: 19,
                  color: Colors.black,
                ),
                style: IconButton.styleFrom(
                  backgroundColor: fieldColor,
                  padding: const EdgeInsets.all(5),
                  minimumSize: const Size(29, 29),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }


  // DROPDOWN FILTER
  Widget _filterDropdown(
    String value,
    List<String> items,
    ValueChanged<String?> onChanged, {
    bool isPrimary = false,
  }) {
    return Container(
      height: 38,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: isPrimary ? primaryColor : fieldColor,
        borderRadius: BorderRadius.circular(8),
      ),
      alignment: Alignment.center,
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isDense: true,
          icon: Icon(
            Icons.keyboard_arrow_down,
            size: 17,
            color: isPrimary ? Colors.white : Colors.black,
          ),
          style: TextStyle(
            fontSize: 11,
            color: isPrimary ? Colors.white : Colors.black,
            fontWeight: FontWeight.w600,
          ),
          dropdownColor: isPrimary ? primaryColor : Colors.white,
          items: items.map((item) {
            return DropdownMenuItem(
              value: item,
              child: Text(item),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  // INPUT FORM DIALOG
  Widget _formInput(
    String label,
    TextEditingController controller, {
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Text(
            label,
            style: TextStyle(
              color: primaryColor,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),

          const SizedBox(height: 5),

          TextField(
            controller: controller,
            keyboardType: keyboardType,

            decoration: InputDecoration(
              filled: true,
              fillColor: fieldColor,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 10,
              ),

              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(7),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // DROPDOWN FORM
  Widget _formDropdown(
    String label,
    String value,
    List<String> items,
    ValueChanged<String?> onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Text(
            label,
            style: TextStyle(
              color: primaryColor,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),

          const SizedBox(height: 5),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),

            decoration: BoxDecoration(
              color: fieldColor,
              borderRadius: BorderRadius.circular(7),
            ),

            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: value,
                isExpanded: true,

                items: items.map((item) {
                  return DropdownMenuItem(
                    value: item,
                    child: Text(
                      item,
                      style: const TextStyle(fontSize: 12),
                    ),
                  );
                }).toList(),

                onChanged: onChanged,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
