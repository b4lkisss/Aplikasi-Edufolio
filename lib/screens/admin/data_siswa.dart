
import 'package:flutter/material.dart';
import 'detail_siswa.dart';
import '../../services/master_data_service.dart';

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

  String selectedKelas = 'Kelas';
  String selectedJurusan = 'Jurusan';
  String selectedAngkatan = 'Angkatan';

  int currentPage = 1;
  final int itemsPerPage = 9;

  List<Map<String, dynamic>> daftarSiswa = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchSiswaFromSupabase();
  }

  Future<void> _fetchSiswaFromSupabase() async {
    setState(() => isLoading = true);
    final data = await MasterDataService.getDaftarSiswa();
    if (mounted) {
      setState(() {
        isLoading = false;
        daftarSiswa = data;
      });
    }
  }

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

      final cocokKelas = selectedKelas == 'Kelas' ||
          selectedKelas == 'Semua Kelas' ||
          siswa['kelas'] == selectedKelas;

      final cocokJurusan = selectedJurusan == 'Jurusan' ||
          selectedJurusan == 'Semua Jurusan' ||
          siswa['jurusan'] == selectedJurusan;

      final cocokAngkatan = selectedAngkatan == 'Angkatan' ||
          selectedAngkatan == 'Semua Angkatan' ||
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

    final List<String> opsiKelas = [
      'X RPL A',
      'X RPL B',
      'XI RPL A',
      'XI RPL B',
      'XII RPL B',
      'X TKJ B',
      'XI TKJ A',
      'XII TKJ A',
    ];

    final List<String> opsiJurusan = ['RPL', 'TKJ', 'DKV'];
    final List<String> opsiAngkatan = ['2024', '2025', '2026'];

    if (!opsiKelas.contains(kelas)) kelas = opsiKelas.first;
    if (!opsiJurusan.contains(jurusan)) jurusan = opsiJurusan.first;
    if (!opsiAngkatan.contains(angkatan)) angkatan = opsiAngkatan.first;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Container(
              width: double.infinity,
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // GARIS ATAS
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),

                    // JUDUL: Edit Data Siswa / Tambah Data Siswa
                    Text(
                      siswa == null ? 'Tambah Data Siswa' : 'Edit Data Siswa',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                      ),
                    ),

                    const SizedBox(height: 18),

                    // NAMA
                    _buildSheetInput(
                      'Nama',
                      namaController,
                      'Contoh: Balqis Demes',
                    ),

                    // NISN
                    _buildSheetInput(
                      'NISN',
                      nisnController,
                      'Contoh: 1234567890',
                      keyboardType: TextInputType.number,
                    ),

                    // KELAS
                    _buildSheetDropdown(
                      'Kelas',
                      kelas,
                      opsiKelas,
                      (val) {
                        if (val != null) {
                          setSheetState(() => kelas = val);
                        }
                      },
                    ),

                    // JURUSAN
                    _buildSheetDropdown(
                      'Jurusan',
                      jurusan,
                      opsiJurusan,
                      (val) {
                        if (val != null) {
                          setSheetState(() => jurusan = val);
                        }
                      },
                    ),

                    // ANGKATAN
                    _buildSheetDropdown(
                      'Angkatan',
                      angkatan,
                      opsiAngkatan,
                      (val) {
                        if (val != null) {
                          setSheetState(() => angkatan = val);
                        }
                      },
                    ),

                    const SizedBox(height: 10),

                    // TOMBOL SIMPAN DATA
                    SizedBox(
                      width: double.infinity,
                      height: 44,
                      child: ElevatedButton(
                        onPressed: () {
                          if (namaController.text.trim().isEmpty ||
                              nisnController.text.trim().isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Nama dan NISN wajib diisi'),
                              ),
                            );
                            return;
                          }

                          if (!RegExp(r'^\d{10}$')
                              .hasMatch(nisnController.text.trim())) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('NISN harus terdiri dari 10 angka'),
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

                          final namaFinal = namaController.text.trim();
                          final nisnFinal = nisn;
                          final kelasFinal = kelas;
                          final jurusanFinal = jurusan;
                          final angkatanFinal = angkatan;
                          final emailFinal = index != null ? (daftarSiswa[index]['email'] ?? '') : '';
                          final siswaIdFinal = index != null ? daftarSiswa[index]['id'] : null;

                          setState(() {
                            final dataBaru = {
                              'nama': namaFinal,
                              'nisn': nisnFinal,
                              'kelas': kelasFinal,
                              'jurusan': jurusanFinal,
                              'angkatan': angkatanFinal,
                              'avatar': 0,
                            };

                            if (index == null) {
                              daftarSiswa.add(dataBaru);
                            } else {
                              daftarSiswa[index] = dataBaru;
                            }
                            currentPage = 1;
                          });

                          Navigator.pop(sheetContext);

                          // Sync ke Supabase
                          if (index == null) {
                            MasterDataService.tambahSiswa(
                              nama: namaFinal,
                              nisn: nisnFinal,
                              email: '',
                              password: '',
                              kelas: kelasFinal,
                              jurusan: jurusanFinal,
                              angkatan: angkatanFinal,
                            );
                          } else {
                            if (siswaIdFinal != null) {
                              MasterDataService.updateSiswa(
                                id: siswaIdFinal,
                                nama: namaFinal,
                                nisn: nisnFinal,
                                email: emailFinal,
                                kelas: kelasFinal,
                                jurusan: jurusanFinal,
                                angkatan: angkatanFinal,
                              );
                            }
                          }

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
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        child: const Text(
                          'Simpan Data',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),
                  ],
                ),
              ),
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
                          onPressed: () async {
                            final siswaId = daftarSiswa[index]['id'];
                            setState(() {
                              daftarSiswa.removeAt(index);

                              if (currentPage > 1 &&
                                  (currentPage - 1) * itemsPerPage >=
                                      filteredSiswa.length) {
                                currentPage--;
                              }
                            });

                            Navigator.pop(dialogContext);

                            if (siswaId != null) {
                              await MasterDataService.hapusSiswa(siswaId);
                            }

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
                  Expanded(
                    child: _filterDropdown(
                      selectedKelas,
                      [
                        'Kelas',
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
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: _filterDropdown(
                      selectedJurusan,
                      [
                        'Jurusan',
                        'RPL',
                        'TKJ',
                      ],
                      (value) {
                        setState(() {
                          selectedJurusan = value!;
                          currentPage = 1;
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: _filterDropdown(
                      selectedAngkatan,
                      [
                        'Angkatan',
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
                  ),
                  const SizedBox(width: 8),

                  // TOMBOL TAMBAH SISWA (UKURAN PERSIS SAMA DENGAN DATA GURU)
                  InkWell(
                    borderRadius: BorderRadius.circular(8),
                    onTap: tambahSiswa,
                    child: Container(
                      height: 38,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
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
                          SizedBox(width: 4),
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
                backgroundImage: (siswa['avatarUrl'] != null &&
                        siswa['avatarUrl'].toString().startsWith('http'))
                    ? NetworkImage(siswa['avatarUrl'].toString())
                    : null,
                child: (siswa['avatarUrl'] == null ||
                        !siswa['avatarUrl'].toString().startsWith('http'))
                    ? Icon(
                        siswa['avatar'] == 0 ? Icons.person : Icons.face,
                        color: primaryColor,
                        size: 30,
                      )
                    : null,
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


  // INPUT FORM BOTTOM SHEET (BORDER STYLE)
  Widget _buildSheetInput(
    String label,
    TextEditingController controller,
    String hint, {
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
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
          const SizedBox(height: 6),
          SizedBox(
            height: 44,
            child: TextField(
              controller: controller,
              keyboardType: keyboardType,
              style: TextStyle(
                fontSize: 12,
                color: primaryColor,
              ),
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade400,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
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
          ),
        ],
      ),
    );
  }

  // DROPDOWN FORM BOTTOM SHEET (BORDER STYLE)
  Widget _buildSheetDropdown(
    String label,
    String value,
    List<String> items,
    ValueChanged<String?> onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
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
          const SizedBox(height: 6),
          Container(
            height: 44,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: primaryColor,
                width: 1,
              ),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: value,
                isExpanded: true,
                icon: Icon(
                  Icons.keyboard_arrow_down,
                  color: primaryColor,
                  size: 20,
                ),
                style: TextStyle(
                  fontSize: 12,
                  color: primaryColor,
                ),
                dropdownColor: Colors.white,
                items: items.map((item) {
                  return DropdownMenuItem(
                    value: item,
                    child: Text(
                      item,
                      style: TextStyle(
                        fontSize: 12,
                        color: primaryColor,
                      ),
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

  // DROPDOWN FILTER
  Widget _filterDropdown(
    String value,
    List<String> items,
    ValueChanged<String?> onChanged,
  ) {
    return Container(
      height: 38,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: const Color(0xFFCBD5E1),
          width: 1.2,
        ),
      ),
      alignment: Alignment.center,
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isDense: true,
          isExpanded: true,
          icon: const Icon(
            Icons.keyboard_arrow_down,
            size: 17,
            color: Colors.black87,
          ),
          style: const TextStyle(
            fontSize: 11,
            color: Color(0xFF1E293B),
            fontWeight: FontWeight.w600,
          ),
          dropdownColor: Colors.white,
          items: items.map((item) {
            return DropdownMenuItem(
              value: item,
              child: Text(
                item,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: const Color(0xFF1E293B),
                  fontWeight: item == value
                      ? FontWeight.bold
                      : FontWeight.normal,
                ),
              ),
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
