import 'package:flutter/material.dart';
import '../../widgets/logout_dialog.dart';
import 'portofolio_data.dart';
import 'profil_siswa.dart';
import 'portofolio_siswa.dart';
import 'detail_portofolio_siswa.dart';
import 'tambah_portofolio_siswa.dart';
import 'status_verifikasi_siswa.dart';
import '../notifikasi_screen.dart';

class DashboardSiswa extends StatefulWidget {
  const DashboardSiswa({super.key});

  @override
  State<DashboardSiswa> createState() => _DashboardSiswaState();
}

class _DashboardSiswaState extends State<DashboardSiswa> {
  static const Color primaryBlue = Color(0xFF356DA8);
  static const Color bannerBg = Color(0xFF5E9BB9);
  static const Color statCardBg = Color(0xFFF1F5F9);

  String selectedPeriod = 'This Month';
  final dataStore = PortofolioDataStore();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      drawer: _buildSiswaDrawer(context),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // HEADER: DASHBOARD + FILTER PERIODE + NOTIFIKASI
              Row(
                children: [
                  Builder(
                    builder: (btnContext) => InkWell(
                      borderRadius: BorderRadius.circular(8),
                      onTap: () {
                        Scaffold.of(btnContext).openDrawer();
                      },
                      child: const Padding(
                        padding: EdgeInsets.only(right: 6),
                        child: Icon(
                          Icons.menu_rounded,
                          color: primaryBlue,
                          size: 26,
                        ),
                      ),
                    ),
                  ),
                  const Text(
                    'Dashboard',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F172A),
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
                              const NotifikasiScreen(role: 'siswa'),
                        ),
                      );
                    },
                    icon: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        const Icon(
                          Icons.notifications_rounded,
                          color: primaryBlue,
                          size: 26,
                        ),
                        ValueListenableBuilder<List<AppNotification>>(
                          valueListenable: dataStore.notifications,
                          builder: (context, notifs, _) {
                            final unread = notifs
                                .where((n) =>
                                    !n.isRead &&
                                    (n.roleTarget == 'all' ||
                                        n.roleTarget == 'siswa'))
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

              // GREETING DAN AVATAR SISWA
              ValueListenableBuilder<SiswaProfile>(
                valueListenable: dataStore.profile,
                builder: (context, profile, _) {
                  return InkWell(
                    borderRadius: BorderRadius.circular(14),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ProfilSiswa(),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        children: [
                          // AVATAR
                          Container(
                            width: 64,
                            height: 64,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: const Color(0xFFE2E8F0),
                                width: 2,
                              ),
                              image: const DecorationImage(
                                image: NetworkImage(
                                  'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=400&q=80',
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
                                  'Halo, ${profile.nama.isNotEmpty ? profile.nama : "Balkis Demes"}',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: primaryBlue,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  '${profile.kelas} , NISN ${profile.nisn}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF64748B),
                                  ),
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

              const SizedBox(height: 16),

              // BANNER MOTIVASI
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  color: bannerBg,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x255E9BB9),
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: const Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Tunjukkan Karyamu, Wujudkan Prestasimu!',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 6),
                          Text(
                            'Kumpulkan karya dan prestasi terbaikmu dalam satu portofolio digital. Terus berkembang dan tunjukkan potensi dirimu!',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              height: 1.35,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 12),
                    // SILUET TOGA & SISWA
                    Opacity(
                      opacity: 0.5,
                      child: Icon(
                        Icons.school_rounded,
                        size: 64,
                        color: Color(0xFF1E3A8A),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 18),

              // 4 STAT CARDS (2X2 GRID DENGAN MODEL PERSIS SEPERTI DI ADMIN)
              ValueListenableBuilder<List<PortofolioItem>>(
                valueListenable: dataStore.portofolioList,
                builder: (context, items, _) {
                  final totalCount = items.length;
                  final prestasiCount =
                      items.where((e) => e.kategori == 'Prestasi & Lomba').length;
                  final sertifikatCount =
                      items.where((e) => e.kategori == 'Sertifikat').length;
                  final organisasiCount =
                      items.where((e) => e.kategori == 'Organisasi').length;

                  return GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.95,
                    children: [
                      // BARIS 1: TOTAL KARYA & ORGANISASI
                      _buildAdminStyleStatCard(
                        icon: Icons.folder_rounded,
                        title: 'Total Karya',
                        value: '${totalCount > 0 ? totalCount : 15}',
                        iconColor: const Color(0xFF2563EB),
                        onTap: () => _openPortofolioTab('Semua'),
                      ),
                      _buildAdminStyleStatCard(
                        icon: Icons.groups_rounded,
                        title: 'Organisasi',
                        value: '${organisasiCount > 0 ? organisasiCount : 10}',
                        iconColor: const Color(0xFF0D9488),
                        onTap: () => _openPortofolioTab('Organisasi'),
                      ),
                      // BARIS 2: SERTIFIKAT & PRESTASI
                      _buildAdminStyleStatCard(
                        icon: Icons.description_rounded,
                        title: 'Sertifikat',
                        value: '${sertifikatCount > 0 ? sertifikatCount : 5}',
                        iconColor: const Color(0xFF4F46E5),
                        onTap: () => _openPortofolioTab('Sertifikat'),
                      ),
                      _buildAdminStyleStatCard(
                        icon: Icons.emoji_events_rounded,
                        title: 'Prestasi',
                        value: '${prestasiCount > 0 ? prestasiCount : 10}',
                        iconColor: const Color(0xFFFFA000),
                        onTap: () => _openPortofolioTab('Prestasi & Lomba'),
                      ),
                    ],
                  );
                },
              ),

              const SizedBox(height: 20),

              // STATUS VERIFIKASI TERBARU
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Status Verifikasi Terbaru',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const StatusVerifikasiSiswa(),
                        ),
                      );
                    },
                    child: const Row(
                      children: [
                        Text(
                          'Lihat Semua',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: primaryBlue,
                          ),
                        ),
                        SizedBox(width: 2),
                        Icon(
                          Icons.chevron_right_rounded,
                          size: 16,
                          color: primaryBlue,
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              // CARD STATUS VERIFIKASI TERBARU (SINKRON REAL-TIME DARI DATA STORE)
              ValueListenableBuilder<List<PortofolioItem>>(
                valueListenable: dataStore.portofolioList,
                builder: (context, items, _) {
                  if (items.isEmpty) {
                    return const SizedBox.shrink();
                  }

                  final item = items.first;
                  final isMenunggu = item.status == 'Menunggu';
                  final isDitolak = item.status == 'Ditolak';

                  Color iconBg = isMenunggu
                      ? const Color(0xFFFFEDD5)
                      : (isDitolak
                          ? const Color(0xFFFEE2E2)
                          : const Color(0xFFDCFCE7));
                  Color iconColor = isMenunggu
                      ? const Color(0xFFEA580C)
                      : (isDitolak
                          ? const Color(0xFFDC2626)
                          : const Color(0xFF16A34A));
                  IconData icon = isMenunggu
                      ? Icons.access_time_filled_rounded
                      : (isDitolak
                          ? Icons.cancel_rounded
                          : Icons.check_circle_rounded);

                  return InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              DetailPortofolioSiswa(portofolio: item),
                        ),
                      );
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: const Color(0xFFE2E8F0),
                          width: 1.2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.04),
                            blurRadius: 10,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: iconBg,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              icon,
                              color: iconColor,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.judul,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF0F172A),
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  isMenunggu
                                      ? 'Menunggu Verifikasi Guru'
                                      : (isDitolak
                                          ? 'Ditolak: ${item.catatan ?? "Perlu revisi"}'
                                          : 'Disetujui'),
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: iconColor,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  'Diunggah: ${item.tanggalUnggah}',
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: Color(0xFF64748B),
                                  ),
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

              const SizedBox(height: 22),

              // TOMBOL "+ Upload Karya Baru"
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            const TambahPortofolioSiswa(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.add, color: Colors.white, size: 22),
                  label: const Text(
                    'Upload Karya Baru',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryBlue,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // TOMBOL "Download CV Portofolio (PDF)"
              SizedBox(
                width: double.infinity,
                height: 44,
                child: ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Row(
                          children: [
                            Icon(Icons.check_circle, color: Colors.white),
                            SizedBox(width: 10),
                            Text('CV Portofolio (PDF) berhasil diunduh!'),
                          ],
                        ),
                        backgroundColor: primaryBlue,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFD9DFE5),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Download CV Portofolio (PDF)',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: primaryBlue,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  void _openPortofolioTab(String kategori) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PortofolioSaya(initialKategori: kategori),
      ),
    );
  }

  Widget _buildAdminStyleStatCard({
    required IconData icon,
    required String title,
    required String value,
    required Color iconColor,
    required VoidCallback onTap,
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

  Widget _buildSiswaDrawer(BuildContext context) {
    return Drawer(
      child: Container(
        color: Colors.white,
        child: Column(
          children: [
            // HEADER DRAWER
            ValueListenableBuilder<SiswaProfile>(
              valueListenable: dataStore.profile,
              builder: (context, profile, _) {
                return Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
                  color: primaryBlue,
                  child: Row(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
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
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              profile.nama,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 3),
                            Text(
                              'Siswa • ${profile.kelas}',
                              style: const TextStyle(
                                color: Color(0xFFBAE6FD),
                                fontSize: 12,
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

            // LIST MENU
            _drawerItem(
              icon: Icons.dashboard_rounded,
              title: 'Dashboard',
              isSelected: true,
              onTap: () => Navigator.pop(context),
            ),
            _drawerItem(
              icon: Icons.person_rounded,
              title: 'Profil Siswa',
              isSelected: false,
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ProfilSiswa()),
                );
              },
            ),
            _drawerItem(
              icon: Icons.folder_special_rounded,
              title: 'Portofolio Saya',
              isSelected: false,
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PortofolioSaya(),
                  ),
                );
              },
            ),
            _drawerItem(
              icon: Icons.assignment_turned_in_rounded,
              title: 'Status Verifikasi',
              isSelected: false,
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const StatusVerifikasiSiswa(),
                  ),
                );
              },
            ),
            _drawerItem(
              icon: Icons.notifications_rounded,
              title: 'Notifikasi',
              isSelected: false,
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const NotifikasiScreen(role: 'siswa'),
                  ),
                );
              },
            ),
            _drawerItem(
              icon: Icons.add_circle_outline_rounded,
              title: 'Tambah Portofolio',
              isSelected: false,
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        const TambahPortofolioSiswa(),
                  ),
                );
              },
            ),

            const Spacer(),

            // GARIS PEMISAH SEBELUM LOGOUT
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 18),
              child: Divider(
                color: Color(0xFFE2E8F0),
                thickness: 1,
              ),
            ),

            // TOMBOL LOG OUT PERSIS SEPERTI DI ADMIN
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () {
                  LogoutDialog.show(context, role: 'siswa');
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
      ),
    );
  }

  Widget _drawerItem({
    required IconData icon,
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: isSelected ? primaryBlue : const Color(0xFF64748B),
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isSelected ? primaryBlue : const Color(0xFF1E293B),
          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
        ),
      ),
      selected: isSelected,
      onTap: onTap,
    );
  }
}
