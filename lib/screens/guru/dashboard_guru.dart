import 'package:flutter/material.dart';
import '../../widgets/logout_dialog.dart';
import 'profil_guru.dart';
import 'data_siswa_guru.dart';
import 'verifikasi_portofolio_guru.dart';
import 'detail_portofolio_guru.dart';

class DashboardGuru extends StatefulWidget {
  const DashboardGuru({super.key});

  @override
  State<DashboardGuru> createState() => _DashboardGuruState();
}

class _DashboardGuruState extends State<DashboardGuru> {
  static const Color primaryBlue = Color(0xFF254BD1);
  static const Color cyanAccent = Color(0xFF38BDF8);
  static const Color cardBg = Color(0xFFE2E8F0);

  int selectedMenu = 0;
  String selectedPeriod = 'This Month';

  final List<Map<String, dynamic>> menuItems = [
    {'icon': Icons.grid_view_rounded, 'title': 'Dashboard'},
    {'icon': Icons.group_rounded, 'title': 'Data Siswa'},
    {'icon': Icons.assignment_turned_in_rounded, 'title': 'Verifikasi Portofolio'},
    {'icon': Icons.person_rounded, 'title': 'Profil Guru'},
  ];

  final List<Map<String, dynamic>> pengajuanMenunggu = [
    {
      'id': 1,
      'nama_siswa': 'Balqis Demes Piscesa',
      'kelas': 'XII RPL B',
      'judul': 'Juara 1 Lomba Web design',
      'kategori': 'Prestasi & Lomba • 2024',
      'waktu': '2 Jam yang lalu',
      'status': 'Menunggu',
      'deskripsi':
          'Memenangkan juara 1 kompetisi desain web tingkat provinsi dengan tema edukasi interaktif.',
      'peran': 'Frontend Developer & UI/UX Designer',
      'skills': ['Flutter Web', 'Figma', 'Dart'],
      'link': 'https://github.com/balqis/web-design-champion',
      'avatar':
          'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=200&q=80',
      'thumbnail':
          'https://images.unsplash.com/photo-1589829545856-d10d557cf95f?auto=format&fit=crop&w=400&q=80',
    },
    {
      'id': 2,
      'nama_siswa': 'Balqis Demes Piscesa',
      'kelas': 'XII RPL B',
      'judul': 'Juara 1 Lomba Web design',
      'kategori': 'Prestasi & Lomba • 2024',
      'waktu': '2 Jam yang lalu',
      'status': 'Menunggu',
      'deskripsi':
          'Pengembangan sistem dashboard portofolio siswa responsif dan cepat.',
      'peran': 'Mobile Developer',
      'skills': ['Flutter', 'REST API'],
      'link': 'https://github.com/balqis/portfolio-app',
      'avatar':
          'https://images.unsplash.com/photo-1539571696357-5a69c17a67c6?auto=format&fit=crop&w=200&q=80',
      'thumbnail':
          'https://images.unsplash.com/photo-1589829545856-d10d557cf95f?auto=format&fit=crop&w=400&q=80',
    },
    {
      'id': 3,
      'nama_siswa': 'Ahmad Fauzan',
      'kelas': 'XII RPL A',
      'judul': 'Sertifikat Flutter Developer',
      'kategori': 'Sertifikat • 2024',
      'waktu': '5 Jam yang lalu',
      'status': 'Menunggu',
      'deskripsi': 'Kelulusan program sertifikasi Flutter tingkat intermediate.',
      'peran': 'Peserta Program',
      'skills': ['Flutter', 'Dart'],
      'link': 'https://cert.dev/flutter-fauzan',
      'avatar':
          'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&w=200&q=80',
      'thumbnail':
          'https://images.unsplash.com/photo-1589829545856-d10d557cf95f?auto=format&fit=crop&w=400&q=80',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      drawer: _buildGuruDrawer(),
      body: SafeArea(
        child: SingleChildScrollView(
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
                          'This Month',
                          'Last Month',
                          'This Week',
                          'This Year',
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
                    onPressed: () {},
                    icon: const Icon(
                      Icons.notifications_outlined,
                      color: primaryBlue,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // BANNER SAPAAN GURU
              Container(
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
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Halo, Bu Balqis',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      'Selamat datang, Balqis 👋',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Kelola dan pantau data portofolio siswa dengan mudah.',
                      style: TextStyle(
                        color: Color(0xE6FFFFFF),
                        fontSize: 12,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 18),

              // GRID 4 KARTU STATISTIK (2 X 2)
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 14,
                mainAxisSpacing: 14,
                childAspectRatio: 1.35,
                children: [
                  _buildStatCard(
                    icon: Icons.people_alt_rounded,
                    title: 'Total Siswa',
                    value: '32',
                    iconColor: const Color(0xFF1E293B),
                  ),
                  _buildStatCard(
                    icon: Icons.folder_rounded,
                    title: 'Portofolio',
                    value: '150',
                    iconColor: const Color(0xFF1E293B),
                  ),
                  _buildStatCard(
                    icon: Icons.emoji_events_rounded,
                    title: 'Prestasi',
                    value: '28',
                    iconColor: const Color(0xFFF59E0B),
                  ),
                  _buildStatCard(
                    icon: Icons.access_time_filled_rounded,
                    title: 'Menunggu Verifikasi',
                    value: '30',
                    iconColor: const Color(0xFF1E293B),
                  ),
                ],
              ),

              const SizedBox(height: 22),

              // SECTION PENGAJUAN MENUNGGU VERIFIKASI
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Pengajuan Menunggu Verifikasi',
                    style: TextStyle(
                      fontSize: 14,
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

              const SizedBox(height: 12),

              // LIST PENGAJUAN
              ...pengajuanMenunggu.map((item) => _buildPengajuanCard(item)),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // WIDGET KARTU STATISTIK (DESAIN PERSIS REFERENSI)
  Widget _buildStatCard({
    required IconData icon,
    required String title,
    required String value,
    required Color iconColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: iconColor),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E293B),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          Center(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E293B),
              ),
            ),
          ),
          const SizedBox(height: 2),
        ],
      ),
    );
  }

  // WIDGET KARTU PENGAJUAN MENUNGGU
  Widget _buildPengajuanCard(Map<String, dynamic> item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailPortofolioGuru(portofolio: item),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // FOTO SISWA
              CircleAvatar(
                radius: 22,
                backgroundImage: NetworkImage(item['avatar']),
              ),
              const SizedBox(width: 12),

              // NAMA SISWA, KELAS, JUDUL & WAKTU
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: item['nama_siswa'],
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1E293B),
                            ),
                          ),
                          TextSpan(
                            text: '  (${item['kelas']})',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF64748B),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      item['judul'],
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      item['waktu'],
                      style: const TextStyle(
                        fontSize: 11,
                        color: Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 8),

              // BADGE "MENUNGGU"
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFE2E5),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'Menunggu',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFEF4444),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // SIDEBAR DRAWER GURU
  Widget _buildGuruDrawer() {
    return Drawer(
      child: Container(
        color: const Color(0xFF1E3A8A),
        child: Column(
          children: [
            // HEADER DRAWER DENGAN FOTO PROFIL GURU
            Container(
              padding: const EdgeInsets.fromLTRB(20, 50, 20, 24),
              width: double.infinity,
              color: const Color(0xFF172554),
              child: Row(
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                      image: const DecorationImage(
                        image: NetworkImage(
                          'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=400&q=80',
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Balqis Demes Piscesa',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 3),
                        Text(
                          'Guru Pembimbing',
                          style: TextStyle(
                            color: cyanAccent,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
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
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () {
                        setState(() {
                          selectedMenu = index;
                        });
                        Navigator.pop(context); // Tutup drawer

                        if (index == 0) {
                          // Dashboard
                        } else if (index == 1) {
                          // Data Siswa
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const DataSiswaGuru(),
                            ),
                          );
                        } else if (index == 2) {
                          // Verifikasi Portofolio
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const VerifikasiPortofolioGuru(),
                            ),
                          );
                        } else if (index == 3) {
                          // Profil Guru
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
                          horizontal: 16,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? const Color(0x3338BDF8)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              menuItems[index]['icon'] as IconData,
                              color: isSelected ? cyanAccent : Colors.white,
                              size: 22,
                            ),
                            const SizedBox(width: 16),
                            Text(
                              menuItems[index]['title'] as String,
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

            // DIVIDER SEBELUM LOGOUT
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 18),
              child: Divider(
                color: Color(0x33FFFFFF),
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
}

