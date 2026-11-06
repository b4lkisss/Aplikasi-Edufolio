import 'package:flutter/material.dart';
import '../../widgets/logout_dialog.dart';
import 'profil_admin.dart';
import 'data_siswa.dart';
import 'data_guru.dart';
import 'kategori_portofolio.dart';

class DashboardAdmin extends StatefulWidget {
  const DashboardAdmin({super.key});

  @override
  State<DashboardAdmin> createState() => _DashboardAdminState();
}

class _DashboardAdminState extends State<DashboardAdmin> {
  // Warna konstan agar aman di Flutter Web / Mobile
  static const Color primaryBlue = Color(0xFF254BD1); // Warna biru pekat
  static const Color cyanAccent = Color(0xFF38BDF8); // Warna aksen cyan

  int selectedMenu = 0;
  String selectedPeriod = 'This Month';

  // MENU SIDEBAR (VERIFIKASI & AKTIVITAS TERBARU DIHAPUS)
  final List<Map<String, dynamic>> menuItems = [
    {'icon': Icons.home_rounded, 'title': 'Home'},
    {'icon': Icons.school_rounded, 'title': 'Data Guru'},
    {'icon': Icons.people_alt_rounded, 'title': 'Data Siswa'},
    {'icon': Icons.assignment_outlined, 'title': 'Kategori'},
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
                    onPressed: () {},
                    icon: const Icon(
                      Icons.notifications_outlined,
                      color: primaryBlue,
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

              // STATISTIK DASHBOARD
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.95,
                children: [
                  _buildStatCard(
                    Icons.school_rounded,
                    'Total Siswa',
                    '32',
                    const Color(0xFF4F46E5), // Indigo
                  ),
                  _buildStatCard(
                    Icons.folder_rounded,
                    'Portofolio',
                    '150',
                    const Color(0xFF2563EB), // Blue
                  ),
                  _buildStatCard(
                    Icons.emoji_events_rounded,
                    'Prestasi',
                    '28',
                    const Color(0xFFD97706), // Amber Pasti (Tidak gunakan .shade700)
                  ),
                  _buildStatCard(
                    Icons.people_alt_rounded,
                    'Total Guru',
                    '30',
                    const Color(0xFF0D9488), // Teal
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // SECTION 1: MENU AKSI CEPAT (QUICK ACTIONS ADMIN)
              _buildSectionTitle('Menu Aksi Cepat'),
              const SizedBox(height: 12),
              _buildQuickActions(),

              const SizedBox(height: 24),

              // SECTION 2: STATISTIK KEAKTIFAN JURUSAN & KELAS
              _buildSectionTitle('Keaktifan Jurusan & Kelas'),
              const SizedBox(height: 12),
              _buildKeaktifanJurusanDanKelas(),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // WIDGET CUSTOM DRAWER / SIDEBAR (PERSIS SEPERTI GAMBAR)
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
      backgroundColor: primaryBlue,
      child: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 12),

            // HEADER PROFIL DENGAN TOMBOL PANAH MENUTUP DI SEBELAH KANAN
            Padding(
              padding: const EdgeInsets.only(left: 18, right: 10, top: 8),
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
                              radius: 26,
                              backgroundColor: Colors.white,
                              child: Icon(
                                Icons.person,
                                size: 32,
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
                                  'Rlexandra',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: 2),
                                Text(
                                  'rlexandra@gmail.com',
                                  style: TextStyle(
                                    color: Color(0xFF7DD3FC), // Cyan muda
                                    fontSize: 11,
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

                  // TOMBOL CHEVRON / PANAH UNTUK MENUTUP SIDEBAR (SESUAI GAMBAR)
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

            const SizedBox(height: 16),

            // GARIS PEMISAH HALUS
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 18),
              child: Divider(
                color: Color(0x33FFFFFF),
                thickness: 1,
              ),
            ),

            const SizedBox(height: 8),

            // DAFTAR MENU
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                itemCount: menuItems.length,
                itemBuilder: (context, index) {
                  final item = menuItems[index];
                  final isSelected = selectedMenu == index;

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
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
                              ? const Color(0x2EFFFFFF)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            // ICON BERWARNA CYAN SESUAI GAMBAR
                            Icon(
                              item['icon'],
                              color: cyanAccent,
                              size: 22,
                            ),

                            const SizedBox(width: 16),

                            // NAMA MENU BERWARNA PUTIH
                            Text(
                              item['title'],
                              style: TextStyle(
                                color: Colors.white,
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
                color: Color(0x33FFFFFF),
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
                        color: cyanAccent,
                        size: 22,
                      ),
                      SizedBox(width: 16),
                      Text(
                        'Log Out',
                        style: TextStyle(
                          color: Colors.white,
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

  // WIDGET KARTU STATISTIK
  Widget _buildStatCard(
    IconData icon,
    String title,
    String value,
    Color iconColor,
  ) {
    final Color badgeBg = Color.fromARGB(
      30,
      iconColor.red,
      iconColor.green,
      iconColor.blue,
    );

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 1),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0F000000),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ICON BADGE + JUDUL DI ATAS
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: badgeBg,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, size: 20, color: iconColor),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF64748B),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),

          const Spacer(),

          // ANGKA BESAR DI BAWAH
          Text(
            value,
            style: const TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E293B),
            ),
          ),
        ],
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
