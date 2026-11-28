import 'package:flutter/material.dart';
import 'siswa/portofolio_data.dart';
import 'guru/detail_portofolio_guru.dart';
import 'siswa/detail_portofolio_siswa.dart';
import 'admin/data_siswa.dart';

class NotifikasiScreen extends StatefulWidget {
  final String role; // 'admin', 'guru', 'siswa', 'all'

  const NotifikasiScreen({super.key, this.role = 'all'});

  @override
  State<NotifikasiScreen> createState() => _NotifikasiScreenState();
}

class _NotifikasiScreenState extends State<NotifikasiScreen> {
  static const Color primaryBlue = Color(0xFF254BD1);
  final PortofolioDataStore dataStore = PortofolioDataStore();

  @override
  void initState() {
    super.initState();
    dataStore.fetchFromSupabase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Color(0xFF1E293B)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Notifikasi',
          style: TextStyle(
            color: Color(0xFF1E293B),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert_rounded, color: Color(0xFF1E293B)),
            onSelected: (value) {
              if (value == 'clear_all') {
                dataStore.clearAllNotifications(widget.role);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Semua notifikasi telah dihapus'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'clear_all',
                child: Row(
                  children: [
                    Icon(Icons.delete_sweep_rounded, size: 18, color: Colors.red),
                    SizedBox(width: 8),
                    Text('Hapus Semua Notifikasi'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await dataStore.fetchFromSupabase();
        },
        color: primaryBlue,
        child: ValueListenableBuilder<List<AppNotification>>(
          valueListenable: dataStore.notifications,
          builder: (context, notifs, _) {
            final list = notifs.where((n) {
              if (widget.role == 'all') return true;
              return n.role == 'all' || n.role == widget.role;
            }).toList();

            if (list.isEmpty) {
              return ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.7,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: const BoxDecoration(
                              color: Color(0xFFEFF6FF),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.notifications_off_outlined,
                              size: 48,
                              color: primaryBlue,
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Tidak Ada Notifikasi',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1E293B),
                            ),
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            'Semua aktivitas terbaru akan muncul di sini secara otomatis.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 12.5,
                              color: Color(0xFF64748B),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }

          return ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            itemCount: list.length,
            separatorBuilder: (context, index) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final item = list[index];

              return Dismissible(
                key: Key(item.id),
                direction: DismissDirection.endToStart,
                onDismissed: (_) {
                  dataStore.deleteNotification(item.id);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Notifikasi dihapus'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
                background: Container(
                  padding: const EdgeInsets.only(right: 20),
                  alignment: Alignment.centerRight,
                  decoration: BoxDecoration(
                    color: Colors.red.shade400,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(Icons.delete_rounded, color: Colors.white),
                ),
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () {
                    setState(() {
                      item.isRead = true;
                    });

                    // Cari portofolio yang cocok dengan notifikasi
                    PortofolioItem? targetPortofolio;
                    final allPorto = dataStore.portofolioList.value;
                    for (var p in allPorto) {
                      if (item.message.toLowerCase().contains(p.judul.toLowerCase()) ||
                          item.title.toLowerCase().contains(p.judul.toLowerCase())) {
                        targetPortofolio = p;
                        break;
                      }
                    }
                    targetPortofolio ??= allPorto.isNotEmpty ? allPorto.first : null;

                    if (item.title.contains('Pengajuan') ||
                        item.title.contains('Portofolio') ||
                        item.title.contains('Penilaian') ||
                        item.title.contains('Revisi')) {
                      if (targetPortofolio != null) {
                        if (widget.role == 'guru') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailPortofolioGuru(
                                portofolio: targetPortofolio!.toMap(),
                              ),
                            ),
                          );
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailPortofolioSiswa(
                                portofolio: targetPortofolio!,
                              ),
                            ),
                          );
                        }
                      }
                    } else if (item.title.contains('Akun') ||
                        item.message.contains('terdaftar') ||
                        item.message.contains('Siswa baru')) {
                      if (widget.role == 'admin') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const DataSiswa(),
                          ),
                        );
                      }
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: item.isRead
                            ? const Color(0xFFE2E8F0)
                            : const Color(0xFFBFDBFE),
                        width: item.isRead ? 1 : 1.5,
                      ),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x06000000),
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ICON NOTIFIKASI
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: item.iconColor.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            item.icon,
                            color: item.iconColor,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 14),

                        // KONTEN NOTIFIKASI
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      item.title,
                                      style: TextStyle(
                                        fontSize: 13.5,
                                        fontWeight: item.isRead
                                            ? FontWeight.w600
                                            : FontWeight.bold,
                                        color: const Color(0xFF0F172A),
                                      ),
                                    ),
                                  ),
                                  if (!item.isRead)
                                    Container(
                                      width: 8,
                                      height: 8,
                                      decoration: const BoxDecoration(
                                        color: primaryBlue,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                item.message,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF475569),
                                  height: 1.35,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.access_time_rounded,
                                    size: 13,
                                    color: Color(0xFF94A3B8),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    item.time,
                                    style: const TextStyle(
                                      fontSize: 11,
                                      color: Color(0xFF94A3B8),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    ),
  );
}
}
