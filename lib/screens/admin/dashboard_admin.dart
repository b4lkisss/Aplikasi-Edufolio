import 'package:flutter/material.dart';

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

  final List<Map<String, dynamic>> menuItems = [
    {'icon': Icons.home_rounded, 'title': 'Home'},
    {'icon': Icons.school_rounded, 'title': 'Data Guru'},
    {'icon': Icons.people_alt_rounded, 'title': 'Data Siswa'},
    {'icon': Icons.folder_rounded, 'title': 'Portofolio'},
    {'icon': Icons.verified_user_rounded, 'title': 'Verifikasi'},
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

              // PENGAJUAN MENUNGGU VERIFIKASI
              _buildSectionTitle('Pengajuan Menunggu Verifikasi', 'Lihat Semua'),
              const SizedBox(height: 10),

              _buildVerificationCard(
                'Balqis Demes Piscesa',
                'XII RPL B',
                'Juara 1 Lomba Web Design',
                '2 Jam yang lalu',
                'Menunggu',
              ),
              const SizedBox(height: 10),
              _buildVerificationCard(
                'Ahmad Fauzan',
                'XII RPL A',
                'Sertifikat Flutter Developer',
                '5 Jam yang lalu',
                'Menunggu',
              ),

              const SizedBox(height: 24),

              // AKTIVITAS TERBARU
              _buildSectionTitle('Aktivitas Terbaru', 'Lihat Semua'),
              const SizedBox(height: 10),

              _buildActivityCard(
                'Budi Santoso',
                'XII RPL B',
                'Mengunggah Sertifikat TOEFL',
                '4 Jam yang lalu',
              ),
              _buildActivityCard(
                'Siti Rahmawati',
                'XI RPL A',
                'Memperbarui Portofolio Proyek',
                '6 Jam yang lalu',
              ),
              _buildActivityCard(
                'Rizky Pratama',
                'XII RPL C',
                'Mengunggah Piagam Penghargaan',
                '1 Hari yang lalu',
              ),
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
                  // AVATAR DENGAN BORDER PUTIH
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
                        Navigator.pop(context); // Tutup drawer setelah memilih

                        if (index != 0) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Menu ${item['title']} dipilih'),
                              duration: const Duration(seconds: 1),
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
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/login',
                    (route) => false,
                  );
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

  // JUDUL SECTION
  Widget _buildSectionTitle(String title, String action) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E293B),
            ),
          ),
        ),
        InkWell(
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('$action belum tersedia')),
            );
          },
          child: Row(
            children: [
              Text(
                action,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: primaryBlue,
                ),
              ),
              const Icon(Icons.chevron_right, size: 18, color: primaryBlue),
            ],
          ),
        ),
      ],
    );
  }

  // KARTU PENGAJUAN VERIFIKASI
  Widget _buildVerificationCard(
    String name,
    String kelas,
    String description,
    String time,
    String status,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 20,
            backgroundColor: Color(0x1A254BD1),
            child: Icon(Icons.person, color: primaryBlue, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      color: Color(0xFF1E293B),
                      fontSize: 12,
                    ),
                    children: [
                      TextSpan(
                        text: name,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text: ' ($kelas)',
                        style: const TextStyle(color: Color(0xFF64748B)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF475569),
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  time,
                  style: const TextStyle(
                    fontSize: 10,
                    color: Color(0xFF94A3B8),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFFEE2E2),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              status,
              style: const TextStyle(
                color: Color(0xFFEF4444),
                fontSize: 10,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // KARTU AKTIVITAS TERBARU
  Widget _buildActivityCard(
    String name,
    String kelas,
    String activity,
    String time,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Color(0x08000000),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 17,
            backgroundColor: Color(0xFFEFF6FF),
            child: Icon(Icons.person_outline, color: primaryBlue, size: 20),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      color: Color(0xFF1E293B),
                      fontSize: 11,
                    ),
                    children: [
                      TextSpan(
                        text: name,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text: ' ($kelas)',
                        style: const TextStyle(color: Color(0xFF64748B)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  activity,
                  style: const TextStyle(
                    fontSize: 10,
                    color: Color(0xFF475569),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  time,
                  style: const TextStyle(
                    fontSize: 9,
                    color: Color(0xFF94A3B8),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
