import 'package:flutter/material.dart';
import '../admin/detail_siswa.dart';

class DataSiswaGuru extends StatefulWidget {
  const DataSiswaGuru({super.key});

  @override
  State<DataSiswaGuru> createState() => _DataSiswaGuruState();
}

class _DataSiswaGuruState extends State<DataSiswaGuru> {
  final Color primaryColor = const Color(0xFF254BD1);
  final Color fieldColor = const Color(0xFFD9D9D9);

  final TextEditingController searchController = TextEditingController();

  String selectedKelas = 'Semua Kelas';
  String selectedJurusan = 'Semua Jurusan';
  String selectedAngkatan = 'Semua Angkatan';

  int currentPage = 1;
  final int itemsPerPage = 6;

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
  ];

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get _filteredSiswa {
    return daftarSiswa.where((siswa) {
      final query = searchController.text.toLowerCase();
      final matchNama =
          (siswa['nama'] as String).toLowerCase().contains(query);
      final matchNisn =
          (siswa['nisn'] as String).toLowerCase().contains(query);
      final matchSearch = matchNama || matchNisn;

      final matchKelas = selectedKelas == 'Semua Kelas' ||
          siswa['kelas'].toString().contains(selectedKelas.replaceAll('Kelas ', ''));

      final matchJurusan = selectedJurusan == 'Semua Jurusan' ||
          siswa['jurusan'] == selectedJurusan;

      final matchAngkatan = selectedAngkatan == 'Semua Angkatan' ||
          siswa['angkatan'] == selectedAngkatan;

      return matchSearch && matchKelas && matchJurusan && matchAngkatan;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredSiswa;
    final totalPages = (filtered.length / itemsPerPage).ceil().clamp(1, 99);
    final validPage = currentPage.clamp(1, totalPages);
    final startIndex = (validPage - 1) * itemsPerPage;
    final endIndex = (startIndex + itemsPerPage).clamp(0, filtered.length);
    final displayedSiswa =
        filtered.sublist(startIndex.clamp(0, filtered.length), endIndex);

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
          'Data Siswa',
          style: TextStyle(
            color: Color(0xFF1E293B),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // SEARCH BAR
                  Container(
                    height: 44,
                    decoration: BoxDecoration(
                      color: fieldColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    alignment: Alignment.center,
                    child: TextField(
                      controller: searchController,
                      onChanged: (val) {
                        setState(() {
                          currentPage = 1;
                        });
                      },
                      decoration: const InputDecoration(
                        icon: Icon(Icons.search,
                            color: Color(0xFF64748B), size: 20),
                        hintText: 'Cari nama/NISN..',
                        hintStyle: TextStyle(
                          color: Color(0xFF64748B),
                          fontSize: 13,
                        ),
                        border: InputBorder.none,
                        isDense: true,
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // FILTER KELAS, JURUSAN, ANGKATAN
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildDropdownFilter(
                          value: selectedKelas,
                          items: const [
                            'Semua Kelas',
                            'Kelas X',
                            'Kelas XI',
                            'Kelas XII',
                          ],
                          onChanged: (val) {
                            if (val != null) {
                              setState(() {
                                selectedKelas = val;
                                currentPage = 1;
                              });
                            }
                          },
                        ),
                        const SizedBox(width: 8),
                        _buildDropdownFilter(
                          value: selectedJurusan,
                          items: const [
                            'Semua Jurusan',
                            'RPL',
                            'TKJ',
                            'DKV',
                          ],
                          onChanged: (val) {
                            if (val != null) {
                              setState(() {
                                selectedJurusan = val;
                                currentPage = 1;
                              });
                            }
                          },
                        ),
                        const SizedBox(width: 8),
                        _buildDropdownFilter(
                          value: selectedAngkatan,
                          items: const [
                            'Semua Angkatan',
                            '2024',
                            '2025',
                            '2026',
                          ],
                          onChanged: (val) {
                            if (val != null) {
                              setState(() {
                                selectedAngkatan = val;
                                currentPage = 1;
                              });
                            }
                          },
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // DAFTAR KARTU SISWA
                  if (displayedSiswa.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 40),
                      child: Center(
                        child: Text(
                          'Tidak ada data siswa ditemukan',
                          style: TextStyle(color: Color(0xFF64748B)),
                        ),
                      ),
                    )
                  else
                    ...displayedSiswa.map((siswa) => _buildSiswaCard(siswa)),
                ],
              ),
            ),
          ),

          // PAGINATION
          _buildPagination(totalPages, validPage),
        ],
      ),
    );
  }

  Widget _buildDropdownFilter({
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      height: 36,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFCBD5E1)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          icon: const Icon(
            Icons.keyboard_arrow_down_rounded,
            size: 18,
            color: Color(0xFF64748B),
          ),
          style: const TextStyle(
            color: Color(0xFF1E293B),
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
          items: items.map((item) {
            return DropdownMenuItem(value: item, child: Text(item));
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildSiswaCard(Map<String, dynamic> siswa) {
    final bool isFemale = (siswa['avatar'] ?? 0) == 0;
    final String avatarUrl = isFemale
        ? 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=200&q=80'
        : 'https://images.unsplash.com/photo-1539571696357-5a69c17a67c6?auto=format&fit=crop&w=200&q=80';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFE2E8F0),
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailSiswa(siswa: siswa),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundImage: NetworkImage(avatarUrl),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      siswa['nama'] ?? '',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${siswa['kelas']} • NISN ${siswa['nisn']}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                color: Color(0xFF64748B),
                size: 24,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPagination(int totalPages, int currentPage) {
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
                ? () => setState(() => this.currentPage--)
                : null,
          ),
          ...List.generate(totalPages.clamp(1, 6), (index) {
            final page = index + 1;
            final isSelected = page == currentPage;
            return InkWell(
              onTap: () => setState(() => this.currentPage = page),
              borderRadius: BorderRadius.circular(6),
              child: Container(
                width: 28,
                height: 28,
                margin: const EdgeInsets.symmetric(horizontal: 3),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isSelected ? primaryColor : const Color(0xFFE2E8F0),
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
            onPressed: currentPage < totalPages
                ? () => setState(() => this.currentPage++)
                : null,
          ),
        ],
      ),
    );
  }
}

