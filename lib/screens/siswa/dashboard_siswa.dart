import 'package:flutter/material.dart';
import '../../widgets/logout_dialog.dart';
import 'portofolio_data.dart';
import 'profil_siswa.dart';
import 'portofolio_siswa.dart';
import 'detail_portofolio_siswa.dart';
import 'tambah_portofolio_siswa.dart';
import 'status_verifikasi_siswa.dart';

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
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: primaryBlue, width: 1.5),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: selectedPeriod,
                        isDense: true,
                        icon: const Icon(
                          Icons.keyboard_arrow_down_rounded,
                          size: 20,
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
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Tidak ada notifikasi baru.'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },
                    icon: const Icon(
                      Icons.notifications_rounded,
                      color: primaryBlue,
                      size: 26,
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
                      _buildAdminStyleStatCard(
                        icon: Icons.folder_rounded,
                        title: 'Total Karya',
                        value: '${totalCount > 0 ? totalCount : 15}',
                        iconColor: const Color(0xFF2563EB),
                        onTap: () => _openPortofolioTab('Semua'),
                      ),
                      _buildAdminStyleStatCard(
                        icon: Icons.emoji_events_rounded,
                        title: 'Prestasi',
                        value: '${prestasiCount > 0 ? prestasiCount : 10}',
                        iconColor: const Color(0xFFD97706),
                        onTap: () => _openPortofolioTab('Prestasi & Lomba'),
                      ),
                      _buildAdminStyleStatCard(
                        icon: Icons.description_rounded,
                        title: 'Sertifikat',
                        value: '${sertifikatCount > 0 ? sertifikatCount : 5}',
                        iconColor: const Color(0xFF4F46E5),
                        onTap: () => _openPortofolioTab('Sertifikat'),
                      ),
                      _buildAdminStyleStatCard(
                        icon: Icons.groups_rounded,
                        title: 'Organisasi',
                        value: '${organisasiCount > 0 ? organisasiCount : 10}',
                        iconColor: const Color(0xFF0D9488),
                        onTap: () => _openPortofolioTab('Organisasi'),
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

              // CARD STATUS VERIFIKASI TERBARU
              InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () {
                  final item = dataStore.portofolioList.value.firstWhere(
                    (i) => i.status == 'Menunggu',
                    orElse: () => dataStore.portofolioList.value.first,
                  );
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
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x14000000),
                        blurRadius: 10,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      // ICON JAM PASIR ORANGE
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF7ED),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.hourglass_top_rounded,
                          color: Color(0xFFF97316),
                          size: 26,
                        ),
                      ),
                      const SizedBox(width: 14),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Sertifikat Web Design',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF0F172A),
                              ),
                            ),
                            SizedBox(height: 3),
                            Text(
                              'Menunggu Verifikasi Admin',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF334155),
                              ),
                            ),
                            SizedBox(height: 3),
                            Text(
                              'Diunggah 12 April 2025',
                              style: TextStyle(
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
              ),

              const SizedBox(height: 20),

              // KARYA UNGGULAN
              const Text(
                'Karya Unggulan',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F172A),
                ),
              ),

              const SizedBox(height: 10),

              // 3 THUMBNAIL KARYA UNGGULAN
              Row(
                children: [
                  Expanded(
                    child: _buildThumbnail(
                      'https://images.unsplash.com/photo-1531403009284-440f080d1e12?auto=format&fit=crop&w=400&q=80',
                      onTap: () => _openDetailFirst(),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildThumbnail(
                      'https://images.unsplash.com/photo-1522071820081-009f0129c71c?auto=format&fit=crop&w=400&q=80',
                      onTap: () => _openDetailFirst(),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildThumbnail(
                      'https://images.unsplash.com/photo-1589829545856-d10d557cf95f?auto=format&fit=crop&w=400&q=80',
                      onTap: () => _openDetailFirst(),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

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

  void _openDetailFirst() {
    if (dataStore.portofolioList.value.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DetailPortofolioSiswa(
            portofolio: dataStore.portofolioList.value.first,
          ),
        ),
      );
    }
  }

  Widget _buildAdminStyleStatCard({
    required IconData icon,
    required String title,
    required String value,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    final Color badgeBg = Color.fromARGB(
      30,
      iconColor.red,
      iconColor.green,
      iconColor.blue,
    );

    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Container(
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
            Text(
              value,
              style: const TextStyle(
                fontSize: 34,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E293B),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThumbnail(String url, {required VoidCallback onTap}) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Container(
          height: 65,
          color: const Color(0xFFE2E8F0),
          child: Image.network(
            url,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Container(
              color: const Color(0xFFE2E8F0),
              child: const Icon(Icons.image, color: Colors.grey),
            ),
          ),
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
