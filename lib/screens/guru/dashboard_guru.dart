import 'package:flutter/material.dart';
import '../../services/master_data_service.dart';
import '../../widgets/logout_dialog.dart';
import 'profil_guru.dart';
import 'data_siswa_guru.dart';
import 'verifikasi_portofolio_guru.dart';
import 'detail_portofolio_guru.dart';
import '../admin/grafik_statistik.dart';
import '../siswa/portofolio_siswa.dart';
import '../siswa/portofolio_data.dart';
import '../notifikasi_screen.dart';

class DashboardGuru extends StatefulWidget {
  const DashboardGuru({super.key});

  @override
  State<DashboardGuru> createState() => _DashboardGuruState();
}

class _DashboardGuruState extends State<DashboardGuru> {
  static const Color primaryBlue = Color(0xFF254BD1);
  static const Color cyanAccent = Color(0xFF38BDF8);
  static const Color cardBg = Color(0xFFE2E8F0);

  final PortofolioDataStore dataStore = PortofolioDataStore();

  int selectedMenu = 0;
  String selectedPeriod = 'This Month';
  int totalSiswaCount = 0;

  @override
  void initState() {
    super.initState();
    dataStore.fetchFromSupabase();
    _fetchSiswaCount();
  }

  Future<void> _fetchSiswaCount() async {
    final list = await MasterDataService.getDaftarSiswa();
    if (!mounted) return;
    setState(() {
      totalSiswaCount = list.length;
    });
  }

  final List<Map<String, dynamic>> menuItems = [
    {'icon': Icons.grid_view_rounded, 'title': 'Dashboard'},
    {'icon': Icons.group_rounded, 'title': 'Data Siswa'},
    {'icon': Icons.folder_rounded, 'title': 'Portofolio'},
    {'icon': Icons.assignment_turned_in_rounded, 'title': 'Verifikasi Portofolio'},
    {'icon': Icons.bar_chart_rounded, 'title': 'Grafik'},
    {'icon': Icons.person_rounded, 'title': 'Profil Guru'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      drawer: _buildGuruDrawer(),
      body: SafeArea(
        child: RefreshIndicator(
          color: primaryBlue,
          backgroundColor: Colors.white,
          onRefresh: () async {
            await Future.wait([
              dataStore.fetchFromSupabase(),
              _fetchSiswaCount(),
            ]);
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
            child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // HEADER: MENU DRAWER + TITLE + DROPDOWN PERIOD + NOTIFICATION
              Row(
                children: [
                  Builder(
                    builder: (btnContext) => IconButton(
                      icon: const Icon(Icons.menu_rounded, color: primaryBlue, size: 28),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      onPressed: () {
                        setState(() { selectedMenu = 0; });
                        Scaffold.of(btnContext).openDrawer();
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Dashboard',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                  const Spacer(),

                  // DROPDOWN FILTER PERIODE
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color(0x66254BD1)),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: selectedPeriod,
                        icon: const Icon(
                          Icons.keyboard_arrow_down_rounded,
                          size: 18,
                          color: primaryBlue,
                        ),
                        style: const TextStyle(
                          color: primaryBlue,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                        items: [
                          'All',
                          'Today',
                          'Yesterday',
                          'This Week',
                          'Last Week',
                          'This Month',
                          'Last Month',
                          'This Year',
                          'Last Year',
                        ].map((p) {
                          return DropdownMenuItem(value: p, child: Text(p));
                        }).toList(),
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              selectedPeriod = value;
                            });
                          }
                        },
                      ),
                    ),
                  ),

                  const SizedBox(width: 8),

                  // NOTIFIKASI
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const NotifikasiScreen(role: 'guru'),
                        ),
                      );
                    },
                    icon: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        const Icon(
                          Icons.notifications_outlined,
                          color: primaryBlue,
                        ),
                        ValueListenableBuilder<List<AppNotification>>(
                          valueListenable: dataStore.notifications,
                          builder: (context, notifs, _) {
                            final unread = notifs
                                .where((n) =>
                                    !n.isRead &&
                                    (n.roleTarget == 'all' ||
                                        n.roleTarget == 'guru'))
                                .length;
                            if (unread == 0) return const SizedBox.shrink();
                            return Positioned(
                              right: -4,
                              top: -4,
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

              const SizedBox(height: 14),

              // GREETING DAN AVATAR GURU (PERSIS SEPERTI DASHBOARD SISWA)
              ValueListenableBuilder<GuruProfile>(
                valueListenable: dataStore.guruProfile,
                builder: (context, guru, _) {
                  final namaTampil = guru.nama.isNotEmpty ? guru.nama : 'Guru Edufolio';
                  final bidangTampil = guru.bidang.isNotEmpty ? guru.bidang : 'Guru Pengajar';
                  final nipTampil = guru.nip.isNotEmpty ? guru.nip : '-';
                  return InkWell(
                    borderRadius: BorderRadius.circular(14),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ProfilGuru(),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        children: [
                          // AVATAR GURU
                          Container(
                            width: 64,
                            height: 64,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: const Color(0xFFE2E8F0),
                                width: 2,
                              ),
                              image: DecorationImage(
                                image: PortofolioItem.getAvatarImageProvider(
                                  guru.avatarBytes,
                                  guru.avatarUrl,
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Halo, $namaTampil',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: primaryBlue,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  '$bidangTampil , NIP $nipTampil',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF64748B),
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 14),

              // BANNER SAPAAN GURU
              ValueListenableBuilder<GuruProfile>(
                valueListenable: dataStore.guruProfile,
                builder: (context, guru, _) {
                  final namaTampil = guru.nama.isNotEmpty ? guru.nama : 'Guru';
                  return Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: primaryBlue,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x33254BD1),
                          blurRadius: 12,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Selamat datang, $namaTampil 👋',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'Kelola dan pantau data portofolio siswa dengan mudah.',
                          style: TextStyle(
                            color: Color(0xE6FFFFFF),
                            fontSize: 12,
                            height: 1.35,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),

              const SizedBox(height: 18),

              // 4 KARTU STATISTIK (2 BARIS: 1: TOTAL SISWA & MENUNGGU, 2: PORTOFOLIO & PRESTASI)
              ValueListenableBuilder<List<PortofolioItem>>(
                valueListenable: dataStore.portofolioList,
                builder: (context, allItems, _) {
                  // Filter berdasarkan periode waktu yang dipilih
                  final filteredItems = allItems.where((i) {
                    final dt = MasterDataService.parseTanggalString(i.tanggalUnggah) ??
                        MasterDataService.parseTanggalString(i.tanggal);
                    return MasterDataService.matchFilterPeriode(dt, selectedPeriod);
                  }).toList();

                  final totalMenunggu =
                      filteredItems.where((i) => i.status == 'Menunggu').length;
                  final totalPorto = filteredItems.length;
                  final totalPrestasi = filteredItems
                      .where((i) => i.kategori.toLowerCase().contains('prestasi') || i.kategori.toLowerCase().contains('lomba'))
                      .length;

                  return GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.95,
                    children: [
                      // BARIS 1: TOTAL SISWA & MENUNGGU
                      _buildStatCard(
                        icon: Icons.people_alt_rounded,
                        title: 'Total Siswa',
                        value: '$totalSiswaCount',
                        iconColor: const Color(0xFF5E48E8),
                        cardBg: const Color(0xFFF0EDFF), // Lavender pastel
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const DataSiswaGuru(),
                            ),
                          );
                        },
                      ),
                      _buildStatCard(
                        icon: Icons.access_time_filled_rounded,
                        title: 'Menunggu',
                        value: '$totalMenunggu',
                        iconColor: const Color(0xFF0D9488),
                        cardBg: const Color(0xFFE5F6F3), // Mint pastel
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const VerifikasiPortofolioGuru(),
                            ),
                          );
                        },
                      ),
                      // BARIS 2: PORTOFOLIO & PRESTASI
                      _buildStatCard(
                        icon: Icons.folder_rounded,
                        title: 'Portofolio',
                        value: '$totalPorto',
                        iconColor: const Color(0xFF2563EB),
                        cardBg: const Color(0xFFEAF1FF), // Baby blue
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const PortofolioSaya(
                                title: 'Seluruh Portofolio',
                                initialKategori: 'Semua',
                              ),
                            ),
                          );
                        },
                      ),
                      _buildStatCard(
                        icon: Icons.emoji_events_rounded,
                        title: 'Prestasi',
                        value: '$totalPrestasi',
                        iconColor: const Color(0xFFD97706),
                        cardBg: const Color(0xFFFFF3DF), // Cream pastel
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const PortofolioSaya(
                                title: 'Portofolio Prestasi',
                                initialKategori: 'Prestasi & Lomba',
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  );
                },
              ),

              const SizedBox(height: 22),

              // SECTION PENGAJUAN VERIFIKASI — CARD FLAT LIST STYLE
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // HEADER DI LUAR CARD
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Pengajuan Verifikasi',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const VerifikasiPortofolioGuru(),
                            ),
                          );
                        },
                        borderRadius: BorderRadius.circular(6),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                          child: Text(
                            'Lihat Semua',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: primaryBlue,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // CARD BESAR BERISI BARIS-BARIS
                  ValueListenableBuilder<List<PortofolioItem>>(
                    valueListenable: dataStore.portofolioList,
                    builder: (context, items, _) {
                      final pendingFiltered = items.where((i) {
                        if (i.status != 'Menunggu') return false;
                        final dt = MasterDataService.parseTanggalString(i.tanggalUnggah) ??
                            MasterDataService.parseTanggalString(i.tanggal);
                        return MasterDataService.matchFilterPeriode(dt, selectedPeriod);
                      }).toList();

                      if (pendingFiltered.isEmpty) {
                        return Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: const Color(0xFFE2E8F0), width: 1.2),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.04),
                                blurRadius: 10,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 16),
                          child: Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 64,
                                  height: 64,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFFF1F5F9),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Center(
                                    child: Icon(
                                      Icons.inbox_rounded,
                                      size: 36,
                                      color: Color(0xFF94A3B8),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  'Belum ada pengajuan verifikasi',
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF1E293B),
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 4),
                                const Text(
                                  'Tidak ada portofolio yang menunggu verifikasi.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                                ),
                              ],
                            ),
                          ),
                        );
                      }

                      // CARD BESAR SATU DENGAN BARIS-BARIS DI DALAMNYA
                      return Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color(0xFFE2E8F0), width: 1.2),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.04),
                              blurRadius: 10,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Column(
                            children: [
                              for (int i = 0; i < pendingFiltered.take(6).length; i++) ...[
                                _buildFlatRow(pendingFiltered[i]),
                                if (i < pendingFiltered.take(6).length - 1)
                                  const Divider(height: 1, thickness: 1, color: Color(0xFFF1F5F9)),
                              ],
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    ),
  );
  }

  // WIDGET KARTU STATISTIK (MODEL SAMA PERSIS SEPERTI DI ADMIN)
  Widget _buildStatCard({
    required IconData icon,
    required String title,
    required String value,
    required Color iconColor,
    required Color cardBg,
    VoidCallback? onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 1. JUDUL DI PALING ATAS
            Text(
              title,
              style: const TextStyle(
                fontSize: 14.5,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E293B),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
            // 2. ICON LEBIH BESAR DI TENGAH
            Expanded(
              child: Center(
                child: Icon(
                  icon,
                  size: 78,
                  color: iconColor,
                ),
              ),
            ),
            // 3. ANGKA DI PALING BAWAH
            Text(
              value,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0F172A),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // BARIS FLAT DI DALAM CARD BESAR (GAYA FLAT LIST)
  Widget _buildFlatRow(PortofolioItem item) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailPortofolioGuru(portofolio: item.toMap()),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // AVATAR SISWA
            CircleAvatar(
              radius: 20,
              backgroundColor: const Color(0xFFE2E8F0),
              backgroundImage: PortofolioItem.getAvatarImageProvider(null, item.avatarUrl),
            ),
            const SizedBox(width: 12),

            // KONTEN KIRI
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
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0F172A),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEFF6FF),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          item.kelas,
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF1E40AF),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(
                    item.judul,
                    style: const TextStyle(
                      fontSize: 11.5,
                      color: Color(0xFF64748B),
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    item.tanggalUnggah,
                    style: const TextStyle(
                      fontSize: 10.5,
                      color: Color(0xFF94A3B8),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 10),

            // BADGE MENUNGGU
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF7ED),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFFEDCAC)),
              ),
              child: const Text(
                'Menunggu',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFEA580C),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // SIDEBAR DRAWER GURU (DISAMAKAN WARNANYA DENGAN ROLE SISWA)
  Widget _buildGuruDrawer() {
    return Drawer(
      child: Container(
        color: Colors.white,
        child: Column(
          children: [
            // HEADER DRAWER DENGAN FOTO PROFIL GURU
            ValueListenableBuilder<GuruProfile>(
              valueListenable: dataStore.guruProfile,
              builder: (context, guru, _) {
                return Container(
                  padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
                  width: double.infinity,
                  color: primaryBlue,
                  child: Row(
                    children: [
                      Container(
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                          image: DecorationImage(
                            image: PortofolioItem.getAvatarImageProvider(
                              guru.avatarBytes,
                              guru.avatarUrl,
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              guru.nama,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 3),
                            Text(
                              'Guru • ${guru.bidang}',
                              style: const TextStyle(
                                color: Color(0xFFBAE6FD),
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),

            const SizedBox(height: 12),

            // LIST MENU ITEM SIDEBAR
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                itemCount: menuItems.length,
                itemBuilder: (context, index) {
                  final isSelected = selectedMenu == index;
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 3),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () {
                        setState(() {
                          selectedMenu = index;
                        });
                        Navigator.pop(context); // Tutup drawer

                        final title = menuItems[index]['title'];
                        if (title == 'Data Siswa') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const DataSiswaGuru(),
                            ),
                          );
                        } else if (title == 'Portofolio') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const PortofolioSaya(
                                title: 'Seluruh Portofolio',
                                initialKategori: 'Semua',
                              ),
                            ),
                          );
                        } else if (title == 'Verifikasi Portofolio') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const VerifikasiPortofolioGuru(),
                            ),
                          );
                        } else if (title == 'Grafik') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const GrafikStatistik(),
                            ),
                          );
                        } else if (title == 'Profil Guru') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ProfilGuru(),
                            ),
                          );
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? const Color(0x14254BD1)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              menuItems[index]['icon'] as IconData,
                              color: isSelected
                                  ? primaryBlue
                                  : const Color(0xFF64748B),
                              size: 22,
                            ),
                            const SizedBox(width: 16),
                            Text(
                              menuItems[index]['title'] as String,
                              style: TextStyle(
                                color: isSelected
                                    ? primaryBlue
                                    : const Color(0xFF1E293B),
                                fontSize: 14,
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            // DIVIDER SEBELUM LOGOUT
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 18),
              child: Divider(
                color: Color(0xFFE2E8F0),
                thickness: 1,
              ),
            ),

            // LOG OUT
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () {
                  LogoutDialog.show(context, role: 'guru');
                },
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  child: Row(
                    children: [
                      Icon(
                        Icons.logout_rounded,
                        color: Colors.red,
                        size: 22,
                      ),
                      SizedBox(width: 16),
                      Text(
                        'Log Out',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

