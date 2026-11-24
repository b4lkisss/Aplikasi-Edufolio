import 'package:flutter/material.dart';
import '../../widgets/logout_dialog.dart';
import 'profil_guru.dart';
import 'data_siswa_guru.dart';
import 'verifikasi_portofolio_guru.dart';
import 'detail_portofolio_guru.dart';
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

  final List<Map<String, dynamic>> menuItems = [
    {'icon': Icons.grid_view_rounded, 'title': 'Dashboard'},
    {'icon': Icons.group_rounded, 'title': 'Data Siswa'},
    {'icon': Icons.assignment_turned_in_rounded, 'title': 'Verifikasi Portofolio'},
    {'icon': Icons.notifications_rounded, 'title': 'Notifikasi'},
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

              // 4 KARTU STATISTIK (2 BARIS: 1: TOTAL SISWA & MENUNGGU, 2: PORTOFOLIO & PRESTASI)
              ValueListenableBuilder<List<PortofolioItem>>(
                valueListenable: dataStore.portofolioList,
                builder: (context, allItems, _) {
                  final totalMenunggu =
                      allItems.where((i) => i.status == 'Menunggu').length;
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
                      // BARIS 1: TOTAL SISWA & MENUNGGU
                      _buildStatCard(
                        icon: Icons.people_alt_rounded,
                        title: 'Total Siswa',
                        value: '32',
                        iconColor: const Color(0xFF4F46E5),
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
                        iconColor: const Color(0xFFEA580C),
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
                        iconColor: const Color(0xFFFFA000),
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

              // LIST PENGAJUAN (SINKRON DARI DATA STORE)
              ValueListenableBuilder<List<PortofolioItem>>(
                valueListenable: dataStore.portofolioList,
                builder: (context, items, _) {
                  final pendingItems =
                      items.where((i) => i.status == 'Menunggu').take(3).toList();

                  if (pendingItems.isEmpty) {
                    return Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: const Column(
                        children: [
                          Icon(
                            Icons.check_circle_outline_rounded,
                            size: 40,
                            color: Color(0xFF10B981),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Semua Pengajuan Sudah Diverifikasi',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1E293B),
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Tidak ada pengajuan portofolio yang menunggu antrean saat ini.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF64748B),
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return Column(
                    children: pendingItems
                        .map((item) => _buildPengajuanCard(item.toMap()))
                        .toList(),
                  );
                },
              ),

              const SizedBox(height: 20),
            ],
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

  // WIDGET KARTU PENGAJUAN MENUNGGU (CARD BERSIH PUTIH DENGAN BORDER & SHADOW)
  Widget _buildPengajuanCard(Map<String, dynamic> item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
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
                backgroundImage: NetworkImage(item['avatar'] ?? ''),
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
                            text: item['nama_siswa'] ?? '',
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1E293B),
                            ),
                          ),
                          TextSpan(
                            text: '  (${item['kelas'] ?? ''})',
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
                      item['judul'] ?? '',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      item['waktu'] ?? '',
                      style: const TextStyle(
                        fontSize: 11,
                        color: Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 8),

              // BADGE "MENUNGGU" (WARNA OREN SESUAI PERMINTAAN USER)
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFEDD5),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFFFED7AA)),
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
            Container(
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
                          // Notifikasi
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const NotifikasiScreen(role: 'guru'),
                            ),
                          );
                        } else if (index == 4) {
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

