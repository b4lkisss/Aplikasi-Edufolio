import 'package:flutter/material.dart';
import 'portofolio_data.dart';
import 'detail_portofolio_siswa.dart';
import '../notifikasi_screen.dart';

class StatusVerifikasiSiswa extends StatefulWidget {
  final String? initialStatus;

  const StatusVerifikasiSiswa({super.key, this.initialStatus});

  @override
  State<StatusVerifikasiSiswa> createState() => _StatusVerifikasiSiswaState();
}

class _StatusVerifikasiSiswaState extends State<StatusVerifikasiSiswa> {
  static const Color primaryBlue = Color(0xFF356DA8);
  static const Color cardBg = Color(0xFFD9DDE2);
  static const Color inactivePillBg = Color(0xFFE2E8F0);

  final dataStore = PortofolioDataStore();

  late String selectedStatus; // 'Semua', 'Menunggu', 'Disetujui', 'Ditolak'
  int currentPage = 1;
  final int itemsPerPage = 8;

  final List<String> statusTabs = [
    'Semua',
    'Menunggu',
    'Disetujui',
    'Ditolak',
  ];

  @override
  void initState() {
    super.initState();
    selectedStatus = widget.initialStatus ?? 'Semua';
    if (!statusTabs.contains(selectedStatus)) {
      selectedStatus = 'Semua';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F4),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF4F4F4),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Status Verifikasi',
          style: TextStyle(
            color: Color(0xFF0F172A),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const NotifikasiScreen(role: 'siswa'),
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
                            (n.roleTarget == 'all' || n.roleTarget == 'siswa'))
                        .length;
                    if (unread == 0) return const SizedBox.shrink();
                    return Positioned(
                      right: -3,
                      top: -3,
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
      body: ValueListenableBuilder<List<PortofolioItem>>(
        valueListenable: dataStore.portofolioList,
        builder: (context, allItems, _) {
          // FILTER ITEMS SESUAI TAB
          final filtered = allItems.where((item) {
            if (selectedStatus == 'Semua') return true;
            if (selectedStatus == 'Menunggu') {
              return item.status.toLowerCase().contains('menunggu');
            }
            if (selectedStatus == 'Disetujui') {
              return item.status.toLowerCase().contains('setuju');
            }
            if (selectedStatus == 'Ditolak') {
              return item.status.toLowerCase().contains('tolak');
            }
            return true;
          }).toList();

          // PAGINATION
          final totalPages =
              (filtered.length / itemsPerPage).ceil().clamp(1, 999);
          final safeCurrentPage = currentPage.clamp(1, totalPages);
          final startIndex = (safeCurrentPage - 1) * itemsPerPage;
          final endIndex =
              (startIndex + itemsPerPage).clamp(0, filtered.length);
          final pageItems = filtered.sublist(startIndex, endIndex);

          return Column(
            children: [
              const SizedBox(height: 8),

              // FILTER TABS (Semua, Menunggu, Disetujui, Ditolak)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: statusTabs.map((tab) {
                    final isSelected = selectedStatus == tab;
                    return Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 3),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(8),
                          onTap: () {
                            setState(() {
                              selectedStatus = tab;
                              currentPage = 1;
                            });
                          },
                          child: Container(
                            height: 38,
                            decoration: BoxDecoration(
                              color: isSelected ? primaryBlue : inactivePillBg,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              tab,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: isSelected
                                    ? Colors.white
                                    : const Color(0xFF334155),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),

              const SizedBox(height: 16),

              // LIST KARTU STATUS VERIFIKASI
              Expanded(
                child: pageItems.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.assignment_outlined,
                              size: 54,
                              color: Colors.grey.shade400,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Tidak ada data dengan status "$selectedStatus"',
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: pageItems.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 14),
                        itemBuilder: (context, index) {
                          final item = pageItems[index];
                          return _buildVerificationCard(item);
                        },
                      ),
              ),

              // PAGINATION BAWAH
              Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 20),
                child: _buildPagination(totalPages, safeCurrentPage),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildVerificationCard(PortofolioItem item) {
    // Tentukan Ikon, Warna Ikon, dan Badge Status
    final isMenunggu = item.status.toLowerCase().contains('menunggu');
    final isDitolak = item.status.toLowerCase().contains('tolak');

    Color iconBg;
    Color iconColor;
    IconData iconData;

    Color badgeBg;
    Color badgeTextColor;
    String badgeText;

    if (isMenunggu) {
      iconBg = const Color(0xFFFFEDD5);
      iconColor = const Color(0xFFEA580C);
      iconData = Icons.access_time_filled_rounded;

      badgeBg = const Color(0xFFFFEDD5);
      badgeTextColor = const Color(0xFFEA580C);
      badgeText = 'Menunggu Verifikasi';
    } else if (isDitolak) {
      iconBg = const Color(0xFFFEE2E2);
      iconColor = const Color(0xFFEF4444);
      iconData = Icons.cancel_rounded;

      badgeBg = const Color(0xFFFEE2E2);
      badgeTextColor = const Color(0xFFDC2626);
      badgeText = 'Ditolak';
    } else {
      // Disetujui
      iconBg = const Color(0xFFDCFCE7);
      iconColor = const Color(0xFF16A34A);
      iconData = Icons.check_circle_rounded;

      badgeBg = const Color(0xFFDCFCE7);
      badgeTextColor = const Color(0xFF16A34A);
      badgeText = 'Disetujui';
    }

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailPortofolioSiswa(portofolio: item),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // BULATAN IKON
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: iconBg,
                shape: BoxShape.circle,
              ),
              child: Icon(
                iconData,
                color: iconColor,
                size: 26,
              ),
            ),
            const SizedBox(width: 14),

            // DETAIL KARYA
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.judul,
                    style: const TextStyle(
                      fontSize: 14.5,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E3A8A),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Kategori : ${item.kategori}',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF64748B),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Diunggah: ${item.tanggalUnggah}',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF64748B),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // PILL STATUS
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: badgeBg,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      badgeText,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: badgeTextColor,
                      ),
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

  Widget _buildPagination(int totalPages, int activePage) {
    if (totalPages <= 1) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 6, vertical: 4),
            child: Icon(
              Icons.chevron_left_rounded,
              color: Color(0xFFCBD5E1),
              size: 20,
            ),
          ),
          const SizedBox(width: 4),
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: primaryBlue,
              borderRadius: BorderRadius.circular(6),
            ),
            alignment: Alignment.center,
            child: const Text(
              '1',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 4),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 6, vertical: 4),
            child: Icon(
              Icons.chevron_right_rounded,
              color: Color(0xFFCBD5E1),
              size: 20,
            ),
          ),
        ],
      );
    }

    final displayCount = totalPages > 6 ? 6 : totalPages;
    final List<int> pages = List.generate(displayCount, (i) => i + 1);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // PANAH PREV
        InkWell(
          borderRadius: BorderRadius.circular(6),
          onTap: activePage > 1
              ? () {
                  setState(() {
                    currentPage = activePage - 1;
                  });
                }
              : null,
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 6, vertical: 4),
            child: Icon(
              Icons.chevron_left_rounded,
              color: primaryBlue,
              size: 20,
            ),
          ),
        ),

        const SizedBox(width: 4),

        // NOMOR HALAMAN
        ...pages.map((p) {
          final isCurrent = p == activePage;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 3),
            child: InkWell(
              borderRadius: BorderRadius.circular(6),
              onTap: () {
                setState(() {
                  currentPage = p;
                });
              },
              child: Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: isCurrent ? primaryBlue : inactivePillBg,
                  borderRadius: BorderRadius.circular(6),
                ),
                alignment: Alignment.center,
                child: Text(
                  '$p',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: isCurrent ? Colors.white : const Color(0xFF1E293B),
                  ),
                ),
              ),
            ),
          );
        }),

        const SizedBox(width: 4),

        // PANAH NEXT
        InkWell(
          borderRadius: BorderRadius.circular(6),
          onTap: activePage < totalPages
              ? () {
                  setState(() {
                    currentPage = activePage + 1;
                  });
                }
              : null,
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 6, vertical: 4),
            child: Icon(
              Icons.chevron_right_rounded,
              color: primaryBlue,
              size: 20,
            ),
          ),
        ),
      ],
    );
  }
}
