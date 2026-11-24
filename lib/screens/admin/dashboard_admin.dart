import 'package:flutter/material.dart';
import '../../widgets/logout_dialog.dart';
import 'profil_admin.dart';
import 'data_siswa.dart';
import 'data_guru.dart';
import 'kategori_portofolio.dart';
import 'grafik_statistik.dart';
import '../siswa/portofolio_siswa.dart';
import '../siswa/portofolio_data.dart';
import '../notifikasi_screen.dart';

class DashboardAdmin extends StatefulWidget {
  const DashboardAdmin({super.key});

  @override
  State<DashboardAdmin> createState() => _DashboardAdminState();
}

class _DashboardAdminState extends State<DashboardAdmin> {
  // Warna konstan agar aman di Flutter Web / Mobile
  static const Color primaryBlue = Color(0xFF254BD1); // Warna biru pekat
  static const Color cyanAccent = Color(0xFF38BDF8); // Warna aksen cyan

  final PortofolioDataStore dataStore = PortofolioDataStore();

  int selectedMenu = 0;
  String selectedPeriod = 'This Month';

  // MENU SIDEBAR (VERIFIKASI & AKTIVITAS TERBARU DIHAPUS)
  final List<Map<String, dynamic>> menuItems = [
    {'icon': Icons.home_rounded, 'title': 'Home'},
    {'icon': Icons.school_rounded, 'title': 'Data Guru'},
    {'icon': Icons.people_alt_rounded, 'title': 'Data Siswa'},
    {'icon': Icons.assignment_outlined, 'title': 'Kategori'},
    {'icon': Icons.bar_chart_rounded, 'title': 'Grafik'},
    {'icon': Icons.notifications_rounded, 'title': 'Notification'},
    {'icon': Icons.person_rounded, 'title': 'My Profile'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      // DRAWER GAYA SIDEBAR SESUAI GAMBAR REFERENSI
      drawer: _buildCustomDrawer(context),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // HEADER DASHBOARD DENGAN TOMBOL MENU HAMBURGER
              Row(
                children: [
                  Builder(
                    builder: (context) => InkWell(
                      borderRadius: BorderRadius.circular(10),
                      onTap: () {
                        setState(() {
                          selectedMenu = 0;
                        });
                        Scaffold.of(context).openDrawer();
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0x14254BD1), // Aman tanpa withOpacity
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.menu_rounded,
                          color: primaryBlue,
                          size: 26,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),

                  const Expanded(
                    child: Text(
                      'Dashboard',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                  ),

                  // DROPDOWN PILIHAN PERIODE
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

                  const SizedBox(width: 6),

                  // NOTIFIKASI
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const NotifikasiScreen(role: 'admin'),
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
                                        n.roleTarget == 'admin'))
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

              const SizedBox(height: 16),

              // BANNER SAPAAN ADMIN
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [primaryBlue, Color(0xFF3B67F6)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x59254BD1),
                      blurRadius: 12,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Halo, Admin 👋',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      'Selamat datang di panel Edufolio!\nKelola dan pantau data portofolio siswa dengan mudah.',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 22),

              // STATISTIK DASHBOARD (2 BARIS: 1: TOTAL SISWA & TOTAL GURU, 2: PORTOFOLIO & PRESTASI)
              ValueListenableBuilder<List<PortofolioItem>>(
                valueListenable: dataStore.portofolioList,
                builder: (context, allItems, _) {
                  final totalPorto = allItems.length;
                  final totalPrestasi = allItems
                      .where((i) => i.kategori.contains('Prestasi'))
                      .length;

                  return GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.95,
                    children: [
                      // BARIS 1: TOTAL SISWA & TOTAL GURU
                      _buildStatCard(
                        Icons.school_rounded,
                        'Total Siswa',
                        '32',
                        const Color(0xFF4F46E5), // Indigo
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const DataSiswa(),
                            ),
                          );
                        },
                      ),
                      _buildStatCard(
                        Icons.people_alt_rounded,
                        'Total Guru',
                        '30',
                        const Color(0xFF0D9488), // Teal
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const DataGuru(),
                            ),
                          );
                        },
                      ),
                      // BARIS 2: PORTOFOLIO & PRESTASI
                      _buildStatCard(
                        Icons.folder_rounded,
                        'Portofolio',
                        '$totalPorto',
                        const Color(0xFF2563EB), // Blue
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
                        Icons.emoji_events_rounded,
                        'Prestasi',
                        '$totalPrestasi',
                        const Color(0xFFFFA000), // Amber Gold
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

              const SizedBox(height: 24),

              // SECTION 1: MENU AKSI CEPAT (QUICK ACTIONS ADMIN)
              _buildSectionTitle('Menu Aksi Cepat'),
              const SizedBox(height: 12),
              _buildQuickActions(),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // WIDGET CUSTOM DRAWER / SIDEBAR (DISAMAKAN WARNANYA DENGAN ROLE SISWA)
  Widget _buildCustomDrawer(BuildContext context) {
    final drawerWidth = MediaQuery.of(context).size.width * 0.76;

    return Drawer(
      width: drawerWidth,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      backgroundColor: Colors.white,
      child: Column(
        children: [
          // HEADER PROFIL DENGAN WARNA BIRU SESUAI ROLE SISWA
          Container(
            padding: const EdgeInsets.fromLTRB(18, 50, 10, 20),
            color: primaryBlue,
            child: Row(
              children: [
                // AVATAR & NAMA ADMIN BISA DIKLIK KE PROFIL
                Expanded(
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () {
                      Navigator.pop(context); // Tutup drawer
                      Navigator.pushNamed(context, '/profil-admin');
                    },
                    child: Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0x33000000),
                                blurRadius: 6,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: const CircleAvatar(
                            radius: 24,
                            backgroundColor: Colors.white,
                            child: Icon(
                              Icons.person,
                              size: 30,
                              color: primaryBlue,
                            ),
                          ),
                        ),

                        const SizedBox(width: 12),

                        // NAMA DAN EMAIL ADMIN
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Admin Edufolio',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 2),
                              Text(
                                'admin@edufolio.com',
                                style: TextStyle(
                                  color: Color(0xFFBAE6FD),
                                  fontSize: 12,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // TOMBOL CHEVRON / PANAH UNTUK MENUTUP SIDEBAR
                InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: () {
                    Navigator.pop(context); // Tutup drawer
                  },
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(
                      color: Color(0x33FFFFFF),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.chevron_left_rounded,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // DAFTAR MENU DENGAN LATAR PUTIH
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: menuItems.length,
              itemBuilder: (context, index) {
                final item = menuItems[index];
                final isSelected = selectedMenu == index;

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 3),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () {
                      setState(() {
                        selectedMenu = index;
                      });

                      Navigator.pop(context);

                      if (item['title'] == 'Data Guru') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const DataGuru(),
                          ),
                        );
                      } else if (item['title'] == 'Data Siswa') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const DataSiswa(),
                          ),
                        );
                      } else if (item['title'] == 'Kategori') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const KategoriPortofolio(),
                          ),
                        );
                      } else if (item['title'] == 'Grafik' ||
                          item['title'] == 'Statistik & Grafik') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const GrafikStatistik(),
                          ),
                        );
                      } else if (item['title'] == 'Notification' ||
                          item['title'] == 'Notifikasi') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const NotifikasiScreen(role: 'admin'),
                          ),
                        );
                      } else if (item['title'] == 'My Profile') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ProfilAdmin(),
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
                            item['icon'],
                            color: isSelected
                                ? primaryBlue
                                : const Color(0xFF64748B),
                            size: 22,
                          ),
                          const SizedBox(width: 16),
                          Text(
                            item['title'],
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

          // GARIS PEMISAH SEBELUM LOGOUT
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 18),
            child: Divider(
              color: Color(0xFFE2E8F0),
              thickness: 1,
            ),
          ),

          // TOMBOL LOG OUT DI BAGIAN PALING BAWAH
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () {
                LogoutDialog.show(context, role: 'admin');
              },
              child: const Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
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
    );
  }

  // WIDGET KARTU STATISTIK
  Widget _buildStatCard(
    IconData icon,
    String title,
    String value,
    Color iconColor, {
    VoidCallback? onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFE2E8F0), width: 1.2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // JUDUL DI PALING ATAS
            Text(
              title,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E3A8A),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
            // ICON LEBIH BESARRRRR DI TENGAH (UKURAN 92)
            Expanded(
              child: Center(
                child: Icon(
                  icon,
                  size: 92,
                  color: iconColor,
                ),
              ),
            ),
            // ANGKA DI PALING BAWAH
            Text(
              value,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF64748B),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // JUDUL SECTION (BERSIH TANPA TOMBOL DI KANAN)
  Widget _buildSectionTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.bold,
          color: Color(0xFF1E293B),
          letterSpacing: -0.2,
        ),
      ),
    );
  }

  // 1. MENU AKSI CEPAT (LEBIH RAPI & PROPORSIONAL)
  Widget _buildQuickActions() {
    return Row(
      children: [
        _buildQuickActionItem(
          icon: Icons.person_add_alt_1_rounded,
          title: 'Tambah Siswa',
          bgColor: const Color(0xFFEFF6FF),
          iconColor: const Color(0xFF2563EB),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const DataSiswa()),
            );
          },
        ),
        const SizedBox(width: 10),
        _buildQuickActionItem(
          icon: Icons.school_rounded,
          title: 'Tambah Guru',
          bgColor: const Color(0xFFF0FDF4),
          iconColor: const Color(0xFF16A34A),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const DataGuru()),
            );
          },
        ),
        const SizedBox(width: 10),
        _buildQuickActionItem(
          icon: Icons.category_rounded,
          title: 'Kategori',
          bgColor: const Color(0xFFFAF5FF),
          iconColor: const Color(0xFF9333EA),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const KategoriPortofolio()),
            );
          },
        ),
      ],
    );
  }

  Widget _buildQuickActionItem({
    required IconData icon,
    required String title,
    required Color bgColor,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE2E8F0), width: 1),
            boxShadow: const [
              BoxShadow(
                color: Color(0x05000000),
                blurRadius: 6,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: bgColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: iconColor, size: 20),
              ),
              const SizedBox(height: 7),
              Text(
                title,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 10.5,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1E293B),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 2. STATISTIK KEAKTIFAN JURUSAN & KELAS (LEBIH RAPI & PADAT)
  Widget _buildKeaktifanJurusanDanKelas() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 1),
        boxShadow: const [
          BoxShadow(
            color: Color(0x05000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // SUBJUDUL JURUSAN
          const Text(
            'Perbandingan Portofolio per Jurusan',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Color(0xFF334155),
            ),
          ),
          const SizedBox(height: 10),

          // JURUSAN RPL
          _buildJurusanProgressBar(
            jurusan: 'Rekayasa Perangkat Lunak (RPL)',
            icon: Icons.code_rounded,
            count: '98 Portofolio',
            percent: 0.65,
            color: primaryBlue,
            bgColor: const Color(0x1F254BD1),
          ),

          const SizedBox(height: 8),

          // JURUSAN TKJ
          _buildJurusanProgressBar(
            jurusan: 'Teknik Komputer & Jaringan (TKJ)',
            icon: Icons.router_rounded,
            count: '52 Portofolio',
            percent: 0.35,
            color: const Color(0xFF0D9488),
            bgColor: const Color(0x1F0D9488),
          ),

          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(color: Color(0xFFE2E8F0), height: 1),
          ),

          // SUBJUDUL TOP KELAS TERAKTIF
          const Text(
            'Top 3 Kelas Teraktif',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Color(0xFF334155),
            ),
          ),
          const SizedBox(height: 10),

          // LIST KELAS TERAKTIF (LEBIH RAPI)
          _buildKelasLeaderboardItem(
            rank: '1',
            kelas: 'XII RPL B',
            total: '48 Portofolio',
            badgeColor: const Color(0xFFFEF3C7),
            textColor: const Color(0xFFD97706),
          ),
          const SizedBox(height: 6),
          _buildKelasLeaderboardItem(
            rank: '2',
            kelas: 'XI RPL A',
            total: '32 Portofolio',
            badgeColor: const Color(0xFFF1F5F9),
            textColor: const Color(0xFF64748B),
          ),
          const SizedBox(height: 6),
          _buildKelasLeaderboardItem(
            rank: '3',
            kelas: 'XII TKJ A',
            total: '28 Portofolio',
            badgeColor: const Color(0xFFFFEDD5),
            textColor: const Color(0xFFC2410C),
          ),
        ],
      ),
    );
  }

  Widget _buildJurusanProgressBar({
    required String jurusan,
    required IconData icon,
    required String count,
    required double percent,
    required Color color,
    required Color bgColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFF1F5F9)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 15, color: color),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  jurusan,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1E293B),
                  ),
                ),
              ),
              Text(
                count,
                style: TextStyle(
                  fontSize: 10.5,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: percent,
              minHeight: 5,
              backgroundColor: bgColor,
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKelasLeaderboardItem({
    required String rank,
    required String kelas,
    required String total,
    required Color badgeColor,
    required Color textColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFF1F5F9)),
      ),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: badgeColor,
              shape: BoxShape.circle,
            ),
            child: Text(
              '#$rank',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              kelas,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1E293B),
              ),
            ),
          ),
          Text(
            total,
            style: const TextStyle(
              fontSize: 10.5,
              color: Color(0xFF64748B),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
