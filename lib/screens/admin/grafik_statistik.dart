import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../services/master_data_service.dart';
import '../siswa/portofolio_data.dart';

class GrafikStatistik extends StatefulWidget {
  const GrafikStatistik({super.key});

  @override
  State<GrafikStatistik> createState() => _GrafikStatistikState();
}

class _PeriodData {
  final List<String> labels;
  final List<double> values;
  final double maxY;
  final List<double> yLabels;
  final int total;
  final String subtitle;

  const _PeriodData({
    required this.labels,
    required this.values,
    required this.maxY,
    required this.yLabels,
    required this.total,
    required this.subtitle,
  });
}

class _GrafikStatistikState extends State<GrafikStatistik> {
  static const Color primaryBlue = Color(0xFF254BD1);

  // Filter waktu disamakan persis dengan di Dashboard Admin
  final List<String> periodOptions = [
    'All',
    'Today',
    'Yesterday',
    'This Week',
    'Last Week',
    'This Month',
    'Last Month',
    'This Year',
    'Last Year',
  ];

  String selectedPeriod = 'This Month';
  // Tooltip secara default TIDAK MUNCUL (null). Hanya muncul ketika disentuh/di-tap/di-hover.
  int? selectedMonthIndex;
  int? selectedCategoryIndex;

  // DATASET BERDASARKAN FILTER WAKTU (TOTAL MENGIKUTI FILTER WAKTU)
  final Map<String, _PeriodData> periodDataMap = {
    'Today': const _PeriodData(
      labels: ['06:00', '09:00', '12:00', '15:00', '18:00', '21:00'],
      values: [1.0, 0.0, 3.0, 2.0, 2.0, 0.0],
      maxY: 4.0,
      yLabels: [4.0, 3.0, 2.0, 1.0, 0.0],
      total: 8,
      subtitle: '8 Pengajuan portofolio hari ini',
    ),
    'Yesterday': const _PeriodData(
      labels: ['06:00', '09:00', '12:00', '15:00', '18:00', '21:00'],
      values: [0.0, 2.0, 5.0, 4.0, 2.0, 1.0],
      maxY: 6.0,
      yLabels: [6.0, 4.0, 2.0, 0.0],
      total: 14,
      subtitle: '14 Pengajuan portofolio kemarin',
    ),
    'This Week': const _PeriodData(
      labels: ['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min'],
      values: [6.0, 8.0, 12.0, 10.0, 5.0, 3.0, 1.0],
      maxY: 15.0,
      yLabels: [15.0, 10.0, 5.0, 0.0],
      total: 45,
      subtitle: '45 Pengajuan portofolio minggu ini',
    ),
    'Last Week': const _PeriodData(
      labels: ['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min'],
      values: [5.0, 9.0, 14.0, 11.0, 7.0, 4.0, 2.0],
      maxY: 15.0,
      yLabels: [15.0, 10.0, 5.0, 0.0],
      total: 52,
      subtitle: '52 Pengajuan portofolio minggu lalu',
    ),
    'This Month': const _PeriodData(
      labels: [
        'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
        'Jul', 'Ags', 'Sep', 'Okt', 'Nov', 'Des'
      ],
      values: [38.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 54.0, 76.0, 20.0, 12.0, 0.0],
      maxY: 80.0,
      yLabels: [80.0, 60.0, 40.0, 20.0, 0.0],
      total: 200,
      subtitle: '200 Pengajuan portofolio tahun berjalan',
    ),
    'Last Month': const _PeriodData(
      labels: ['Mgg 1', 'Mgg 2', 'Mgg 3', 'Mgg 4'],
      values: [24.0, 38.0, 46.0, 22.0],
      maxY: 50.0,
      yLabels: [50.0, 40.0, 30.0, 20.0, 10.0, 0.0],
      total: 130,
      subtitle: '130 Pengajuan portofolio bulan lalu',
    ),
    'This Year': const _PeriodData(
      labels: [
        'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
        'Jul', 'Ags', 'Sep', 'Okt', 'Nov', 'Des'
      ],
      values: [38.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 54.0, 76.0, 20.0, 12.0, 0.0],
      maxY: 80.0,
      yLabels: [80.0, 60.0, 40.0, 20.0, 0.0],
      total: 200,
      subtitle: '200 Pengajuan portofolio tahun ini',
    ),
    'Last Year': const _PeriodData(
      labels: [
        'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
        'Jul', 'Ags', 'Sep', 'Okt', 'Nov', 'Des'
      ],
      values: [15.0, 20.0, 18.0, 25.0, 30.0, 28.0, 35.0, 40.0, 45.0, 38.0, 30.0, 26.0],
      maxY: 50.0,
      yLabels: [50.0, 40.0, 30.0, 20.0, 10.0, 0.0],
      total: 350,
      subtitle: '350 Pengajuan portofolio tahun lalu',
    ),
    'All': const _PeriodData(
      labels: ['2022', '2023', '2024', '2025', '2026'],
      values: [65.0, 120.0, 210.0, 280.0, 200.0],
      maxY: 300.0,
      yLabels: [300.0, 200.0, 100.0, 0.0],
      total: 875,
      subtitle: '875 Seluruh total portofolio tercatat',
    ),
  };

  // DATA KATEGORI PORTOFOLIO UNTUK DONUT CHART (WARNA ORANYE DIGANTI BIRU SESUAI PERMINTAAN)
  final List<Map<String, dynamic>> categoryData = [
    {'name': 'Sertifikat', 'count': 82, 'color': const Color(0xFF8B9EB3)},
    {'name': 'Prestasi & Lomba', 'count': 35, 'color': const Color(0xFF254BD1)}, // Biru utama
    {'name': 'Projek Mandiri', 'count': 25, 'color': const Color(0xFF0284C7)}, // Sky Blue
    {'name': 'Organisasi', 'count': 18, 'color': const Color(0xFF38BDF8)}, // Light Blue
    {'name': 'Magang & PKL', 'count': 12, 'color': const Color(0xFF6366F1)}, // Indigo
    {'name': 'Workshop & Pelatihan', 'count': 8, 'color': const Color(0xFF10B981)}, // Emerald
    {'name': 'Publikasi / Karya', 'count': 4, 'color': const Color(0xFF8B5CF6)}, // Purple
    {'name': 'Lomba Internal', 'count': 2, 'color': const Color(0xFF06B6D4)}, // Cyan
    {'name': 'Penghargaan', 'count': 1, 'color': const Color(0xFF14B8A6)}, // Teal
  ];

  final PortofolioDataStore dataStore = PortofolioDataStore();

  @override
  void initState() {
    super.initState();
    dataStore.fetchFromSupabase();
  }

  // Menghitung dataset grafik garis dari data Supabase secara real-time
  _PeriodData _computePeriodData(List<PortofolioItem> allPortofolio, String period) {
    final filtered = allPortofolio.where((i) {
      final dt = MasterDataService.parseTanggalString(i.tanggalUnggah) ??
          MasterDataService.parseTanggalString(i.tanggal);
      return MasterDataService.matchFilterPeriode(dt, period);
    }).toList();

    final total = filtered.length;

    List<String> labels = [];
    List<double> values = [];

    if (period == 'Today' || period == 'Yesterday') {
      labels = ['06:00', '09:00', '12:00', '15:00', '18:00', '21:00'];
      values = List.filled(labels.length, 0.0);
      if (total > 0) {
        values[2] = total.toDouble(); // Tempatkan pada jam tengah
      }
    } else if (period == 'This Week' || period == 'Last Week') {
      labels = ['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min'];
      values = List.filled(labels.length, 0.0);
      for (var item in filtered) {
        final dt = MasterDataService.parseTanggalString(item.tanggalUnggah) ??
            MasterDataService.parseTanggalString(item.tanggal);
        if (dt != null) {
          final idx = (dt.weekday - 1).clamp(0, 6);
          values[idx] += 1.0;
        }
      }
    } else {
      // Month / Year / All -> 12 Bulan
      labels = ['Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun', 'Jul', 'Ags', 'Sep', 'Okt', 'Nov', 'Des'];
      values = List.filled(labels.length, 0.0);
      for (var item in filtered) {
        final dt = MasterDataService.parseTanggalString(item.tanggalUnggah) ??
            MasterDataService.parseTanggalString(item.tanggal);
        if (dt != null) {
          final idx = (dt.month - 1).clamp(0, 11);
          values[idx] += 1.0;
        }
      }
    }

    final maxVal = values.isNotEmpty ? values.reduce(math.max) : 0.0;
    final maxY = maxVal > 0 ? (maxVal <= 4 ? 4.0 : (maxVal * 1.25).ceilToDouble()) : 4.0;
    final yLabels = [maxY, (maxY * 0.75).roundToDouble(), (maxY * 0.5).roundToDouble(), (maxY * 0.25).roundToDouble(), 0.0];

    return _PeriodData(
      labels: labels,
      values: values,
      maxY: maxY,
      yLabels: yLabels,
      total: total,
      subtitle: total == 0 ? 'Belum ada pengajuan portofolio pada periode ini' : '$total Pengajuan portofolio tercatat',
    );
  }

  // Menghitung donat kategori dari data Supabase secara real-time
  List<Map<String, dynamic>> _computeCategoryData(List<PortofolioItem> allPortofolio, String period) {
    final filtered = allPortofolio.where((i) {
      final dt = MasterDataService.parseTanggalString(i.tanggalUnggah) ??
          MasterDataService.parseTanggalString(i.tanggal);
      return MasterDataService.matchFilterPeriode(dt, period);
    }).toList();

    final Map<String, int> counts = {};
    for (var item in filtered) {
      final kat = item.kategori.trim().isEmpty ? 'Lainnya' : item.kategori.trim();
      counts[kat] = (counts[kat] ?? 0) + 1;
    }

    final colors = [
      const Color(0xFF254BD1),
      const Color(0xFF0284C7),
      const Color(0xFF38BDF8),
      const Color(0xFF0D9488),
      const Color(0xFF10B981),
      const Color(0xFF6366F1),
      const Color(0xFF8B5CF6),
      const Color(0xFFEC4899),
    ];

    if (counts.isEmpty) {
      return [
        {'name': 'Belum Ada Data', 'count': 0, 'color': const Color(0xFFCBD5E1)},
      ];
    }

    int colorIdx = 0;
    return counts.entries.map((entry) {
      final color = colors[colorIdx % colors.length];
      colorIdx++;
      return {
        'name': entry.key,
        'count': entry.value,
        'color': color,
      };
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<PortofolioItem>>(
      valueListenable: dataStore.portofolioList,
      builder: (context, allPortofolio, _) {
        final activeData = _computePeriodData(allPortofolio, selectedPeriod);
        final dynamicCategoryData = _computeCategoryData(allPortofolio, selectedPeriod);

        // Hitung perbandingan per jurusan dari data portofolio
        final totalPorto = activeData.total;
        final rplCount = allPortofolio.where((p) => p.kelas.toLowerCase().contains('rpl')).length;
        final tkjCount = allPortofolio.where((p) => p.kelas.toLowerCase().contains('tkj')).length;
        final totalJurusan = (rplCount + tkjCount) > 0 ? (rplCount + tkjCount) : 1;

        // Hitung top kelas teraktif
        final Map<String, int> kelasMap = {};
        for (var p in allPortofolio) {
          if (p.kelas.isNotEmpty) {
            kelasMap[p.kelas] = (kelasMap[p.kelas] ?? 0) + 1;
          }
        }
        final sortedKelas = kelasMap.entries.toList()
          ..sort((a, b) => b.value.compareTo(a.value));

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
          'Grafik',
          style: TextStyle(
            color: Color(0xFF1E293B),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          // DROPDOWN FILTER PERIODE PERSIS SEPERTI DI DASHBOARD ADMIN
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0x66254BD1)),
              borderRadius: BorderRadius.circular(10),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: selectedPeriod,
                icon: const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  size: 16,
                  color: primaryBlue,
                ),
                style: const TextStyle(
                  color: primaryBlue,
                  fontSize: 11.5,
                  fontWeight: FontWeight.w600,
                ),
                items: periodOptions.map((p) {
                  return DropdownMenuItem(value: p, child: Text(p));
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      selectedPeriod = value;
                      selectedMonthIndex = null; // Reset tooltip saat filter periode berganti
                      selectedCategoryIndex = null;
                    });
                  }
                },
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // KARTU RINGKASAN AKTIVITAS PORTOFOLIO (BERSIH SESUAI PERMINTAAN USER)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF254BD1), Color(0xFF3B82F6)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x26254BD1),
                    blurRadius: 12,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Total Portofolio',
                    style: TextStyle(
                      color: Color(0xFFBAE6FD),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${activeData.total} Portofolio',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            // ==============================================================
            // 1. GRAFIK TREN PENGAJUAN PORTOFOLIO (LINE / SPLINE CHART BIRU)
            // ==============================================================
            _buildTrenPengajuanCard(activeData),

            const SizedBox(height: 18),

            // ==============================================================
            // 2. GRAFIK KATEGORI PORTOFOLIO (DONUT / CIRCULAR CHART BIRU)
            // ==============================================================
            _buildKategoriPortofolioDonutCard(dynamicCategoryData),

            const SizedBox(height: 18),

            // SECTION 3: PERBANDINGAN PORTOFOLIO PER JURUSAN
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE2E8F0)),
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
                  const Text(
                    'Perbandingan Portofolio per Jurusan',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // JURUSAN RPL
                  _buildJurusanProgressBar(
                    jurusan: 'Rekayasa Perangkat Lunak (RPL)',
                    icon: Icons.code_rounded,
                    count: '$rplCount Portofolio',
                    percent: (rplCount / totalJurusan).clamp(0.0, 1.0),
                    color: primaryBlue,
                    bgColor: const Color(0x1F254BD1),
                  ),

                  const SizedBox(height: 10),

                  // JURUSAN TKJ
                  _buildJurusanProgressBar(
                    jurusan: 'Teknik Komputer & Jaringan (TKJ)',
                    icon: Icons.router_rounded,
                    count: '$tkjCount Portofolio',
                    percent: (tkjCount / totalJurusan).clamp(0.0, 1.0),
                    color: const Color(0xFF0D9488),
                    bgColor: const Color(0x1F0D9488),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            // SECTION 4: TOP KELAS TERAKTIF
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE2E8F0)),
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
                  const Text(
                    'Top 3 Kelas Teraktif',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                  const SizedBox(height: 12),

                  if (sortedKelas.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        'Belum ada aktivitas portofolio dari kelas manapun.',
                        style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                      ),
                    )
                  else
                    ...List.generate(sortedKelas.take(3).length, (idx) {
                      final item = sortedKelas[idx];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: _buildKelasLeaderboardItem(
                          rank: '${idx + 1}',
                          kelas: item.key,
                          total: '${item.value} Portofolio',
                          badgeColor: idx == 0
                              ? const Color(0xFFEFF6FF)
                              : const Color(0xFFF1F5F9),
                          textColor: idx == 0 ? primaryBlue : const Color(0xFF64748B),
                        ),
                      );
                    }),
                ],
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  },
);
  }

  // ==========================================================================
  // WIDGET KARTU TREN PENGAJUAN (WARNA BIRU, TOOLTIP HANYA MUNCUL KETIKA DITOUCH)
  // ==========================================================================
  Widget _buildTrenPengajuanCard(_PeriodData data) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
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
          // HEADER KARTU (ICON BIRU + JUDUL + BADGE TOTAL SESUAI PERIODE)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(
                    Icons.trending_up_rounded,
                    color: primaryBlue,
                    size: 22,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Tren Pengajuan Portofolio',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  'Total: ${data.total}',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF475569),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // GRAFIK SPLINE LINE BERWARNA BIRU
          LayoutBuilder(
            builder: (context, constraints) {
              final chartWidth = constraints.maxWidth;
              const chartHeight = 170.0;

              const leftPadding = 26.0;
              const rightPadding = 12.0;
              const topPadding = 16.0;
              const bottomPadding = 24.0;

              final availableWidth = chartWidth - leftPadding - rightPadding;
              final availableHeight = chartHeight - topPadding - bottomPadding;

              final count = data.labels.length;
              final stepX = count > 1 ? availableWidth / (count - 1) : availableWidth;

              // Posisi titik yang dipilih jika ada
              double? selectedX;
              double? selectedY;
              double? selectedVal;

              if (selectedMonthIndex != null &&
                  selectedMonthIndex! >= 0 &&
                  selectedMonthIndex! < count) {
                selectedVal = data.values[selectedMonthIndex!];
                selectedX = leftPadding + selectedMonthIndex! * stepX;
                selectedY = topPadding + (1 - (selectedVal / data.maxY)) * availableHeight;
              }

              return SizedBox(
                width: chartWidth,
                height: chartHeight,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    // CUSTOM PAINTER LINE CHART BIRU DENGAN HOVER & TRACKING TOUCH
                    Positioned.fill(
                      child: MouseRegion(
                        onHover: (event) {
                          final localX = event.localPosition.dx;
                          int closestIdx = 0;
                          double closestDist = double.infinity;

                          for (int i = 0; i < count; i++) {
                            final x = leftPadding + i * stepX;
                            final dist = (localX - x).abs();
                            if (dist < closestDist) {
                              closestDist = dist;
                              closestIdx = i;
                            }
                          }

                          if (selectedMonthIndex != closestIdx) {
                            setState(() {
                              selectedMonthIndex = closestIdx;
                            });
                          }
                        },
                        onExit: (_) {
                          if (selectedMonthIndex != null) {
                            setState(() {
                              selectedMonthIndex = null;
                            });
                          }
                        },
                        child: GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onHorizontalDragUpdate: (details) {
                            final localX = details.localPosition.dx;
                            int closestIdx = 0;
                            double closestDist = double.infinity;

                            for (int i = 0; i < count; i++) {
                              final x = leftPadding + i * stepX;
                              final dist = (localX - x).abs();
                              if (dist < closestDist) {
                                closestDist = dist;
                                closestIdx = i;
                              }
                            }

                            if (selectedMonthIndex != closestIdx) {
                              setState(() {
                                selectedMonthIndex = closestIdx;
                              });
                            }
                          },
                          onTapDown: (details) {
                            final localX = details.localPosition.dx;
                            int closestIdx = 0;
                            double closestDist = double.infinity;

                            for (int i = 0; i < count; i++) {
                              final x = leftPadding + i * stepX;
                              final dist = (localX - x).abs();
                              if (dist < closestDist) {
                                closestDist = dist;
                                closestIdx = i;
                              }
                            }

                            setState(() {
                              if (selectedMonthIndex == closestIdx) {
                                selectedMonthIndex = null;
                              } else {
                                selectedMonthIndex = closestIdx;
                              }
                            });
                          },
                          child: CustomPaint(
                            painter: SplineChartPainter(
                              months: data.labels,
                              values: data.values,
                              selectedIdx: selectedMonthIndex,
                              maxY: data.maxY,
                              yLabels: data.yLabels,
                              primaryColor: primaryBlue,
                            ),
                          ),
                        ),
                      ),
                    ),

                    // TOOLTIP POPUP HANYA MUNCUL KETIKA TITIK DISENTUH / DITAP (TOUCH / TRUNCATE)
                    if (selectedMonthIndex != null && selectedX != null && selectedY != null)
                      Positioned(
                        left: (selectedX - 55).clamp(8.0, chartWidth - 110.0),
                        top: (selectedY - 42).clamp(0.0, chartHeight - 50.0),
                        child: IgnorePointer(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.12),
                                  blurRadius: 8,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                              border: Border.all(
                                color: const Color(0xFFE2E8F0),
                                width: 1,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 9,
                                  height: 9,
                                  decoration: BoxDecoration(
                                    color: primaryBlue,
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                ),
                                const SizedBox(width: 6),
                                const Text(
                                  'Pengajuan',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Color(0xFF64748B),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  '${selectedVal?.toInt() ?? 0}',
                                  style: const TextStyle(
                                    fontSize: 11.5,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF0F172A),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  // ==========================================================================
  // WIDGET KARTU KATEGORI PORTOFOLIO (DONUT / CIRCULAR CHART BIRU DENGAN HOVER TOOLTIP)
  // ==========================================================================
  Widget _buildKategoriPortofolioDonutCard(List<Map<String, dynamic>> categoryData) {
    final total = categoryData.fold<double>(
      0.0,
      (sum, item) => sum + (item['count'] as num).toDouble(),
    );

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
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
          // HEADER KARTU DENGAN ICON BIRU
          const Row(
            children: [
              Icon(
                Icons.pie_chart_outline_rounded,
                color: primaryBlue,
                size: 22,
              ),
              SizedBox(width: 8),
              Text(
                'Kategori Portofolio',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F172A),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // LINGKARAN DONUT CHART DENGAN HOVER & TOUCH TRACKING TOOLTIP
          LayoutBuilder(
            builder: (context, constraints) {
              final chartWidth = constraints.maxWidth;
              const chartHeight = 190.0;
              final center = Offset(chartWidth / 2, chartHeight / 2);
              const radius = 68.0;

              // Hitung posisi segmen untuk tooltip jika terpilih
              double? tooltipLeft;
              double? tooltipTop;
              Map<String, dynamic>? activeCategory;

              if (selectedCategoryIndex != null &&
                  selectedCategoryIndex! >= 0 &&
                  selectedCategoryIndex! < categoryData.length &&
                  total > 0) {
                activeCategory = categoryData[selectedCategoryIndex!];

                // Hitung sudut pertengahan segmen terpilih
                double currentStart = -math.pi / 2;
                for (int i = 0; i < selectedCategoryIndex!; i++) {
                  final sweep = ((categoryData[i]['count'] as num).toDouble() / total) * 2 * math.pi;
                  currentStart += sweep;
                }
                final activeSweep = ((activeCategory['count'] as num).toDouble() / total) * 2 * math.pi;
                final midAngle = currentStart + activeSweep / 2;

                // Anchor di luar lingkaran
                final anchorX = center.dx + (radius + 20) * math.cos(midAngle);
                final anchorY = center.dy + (radius + 20) * math.sin(midAngle);

                if (math.cos(midAngle) >= 0) {
                  tooltipLeft = anchorX.clamp(10.0, chartWidth - 150.0);
                } else {
                  tooltipLeft = (anchorX - 130.0).clamp(10.0, chartWidth - 150.0);
                }
                tooltipTop = (anchorY - 20.0).clamp(6.0, chartHeight - 44.0);
              }

              return SizedBox(
                width: chartWidth,
                height: chartHeight,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    // CUSTOM PAINTER DONUT CHART DENGAN HOVER REGION
                    Positioned.fill(
                      child: MouseRegion(
                        onHover: (event) {
                          final local = event.localPosition;
                          final dx = local.dx - center.dx;
                          final dy = local.dy - center.dy;
                          final dist = math.sqrt(dx * dx + dy * dy);

                          // Hanya responsif jika mouse berada di area lingkaran
                          if (dist >= 20 && dist <= radius + 35) {
                            final angle = math.atan2(dy, dx);
                            double normalizedAngle = angle - (-math.pi / 2);
                            while (normalizedAngle < 0) {
                              normalizedAngle += 2 * math.pi;
                            }
                            while (normalizedAngle >= 2 * math.pi) {
                              normalizedAngle -= 2 * math.pi;
                            }

                            double accum = 0.0;
                            int? foundIdx;
                            for (int i = 0; i < categoryData.length; i++) {
                              final sweep = ((categoryData[i]['count'] as num).toDouble() / total) * 2 * math.pi;
                              if (normalizedAngle >= accum && normalizedAngle < accum + sweep) {
                                foundIdx = i;
                                break;
                              }
                              accum += sweep;
                            }

                            if (selectedCategoryIndex != foundIdx) {
                              setState(() {
                                selectedCategoryIndex = foundIdx;
                              });
                            }
                          } else {
                            if (selectedCategoryIndex != null) {
                              setState(() {
                                selectedCategoryIndex = null;
                              });
                            }
                          }
                        },
                        onExit: (_) {
                          if (selectedCategoryIndex != null) {
                            setState(() {
                              selectedCategoryIndex = null;
                            });
                          }
                        },
                        child: GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onPanUpdate: (details) {
                            final local = details.localPosition;
                            final dx = local.dx - center.dx;
                            final dy = local.dy - center.dy;
                            final dist = math.sqrt(dx * dx + dy * dy);

                            if (dist >= 20 && dist <= radius + 40) {
                              final angle = math.atan2(dy, dx);
                              double normalizedAngle = angle - (-math.pi / 2);
                              while (normalizedAngle < 0) {
                                normalizedAngle += 2 * math.pi;
                              }
                              while (normalizedAngle >= 2 * math.pi) {
                                normalizedAngle -= 2 * math.pi;
                              }

                              double accum = 0.0;
                              int? foundIdx;
                              for (int i = 0; i < categoryData.length; i++) {
                                final sweep = ((categoryData[i]['count'] as num).toDouble() / total) * 2 * math.pi;
                                if (normalizedAngle >= accum && normalizedAngle < accum + sweep) {
                                  foundIdx = i;
                                  break;
                                }
                                accum += sweep;
                              }

                              if (selectedCategoryIndex != foundIdx) {
                                setState(() {
                                  selectedCategoryIndex = foundIdx;
                                });
                              }
                            }
                          },
                          onTapDown: (details) {
                            final local = details.localPosition;
                            final dx = local.dx - center.dx;
                            final dy = local.dy - center.dy;
                            final dist = math.sqrt(dx * dx + dy * dy);

                            if (dist >= 20 && dist <= radius + 40) {
                              final angle = math.atan2(dy, dx);
                              double normalizedAngle = angle - (-math.pi / 2);
                              while (normalizedAngle < 0) {
                                normalizedAngle += 2 * math.pi;
                              }
                              while (normalizedAngle >= 2 * math.pi) {
                                normalizedAngle -= 2 * math.pi;
                              }

                              double accum = 0.0;
                              int? foundIdx;
                              for (int i = 0; i < categoryData.length; i++) {
                                final sweep = ((categoryData[i]['count'] as num).toDouble() / total) * 2 * math.pi;
                                if (normalizedAngle >= accum && normalizedAngle < accum + sweep) {
                                  foundIdx = i;
                                  break;
                                }
                                accum += sweep;
                              }

                              setState(() {
                                if (selectedCategoryIndex == foundIdx) {
                                  selectedCategoryIndex = null;
                                } else {
                                  selectedCategoryIndex = foundIdx;
                                }
                              });
                            }
                          },
                          child: CustomPaint(
                            painter: DonutChartPainter(
                              data: categoryData,
                              selectedIdx: selectedCategoryIndex,
                            ),
                          ),
                        ),
                      ),
                    ),

                    // TOOLTIP POPUP PERSIS SEPERTI GAMBAR CONTOH USER (media_1795485105643_2492807f.png)
                    if (activeCategory != null && tooltipLeft != null && tooltipTop != null)
                      Positioned(
                        left: tooltipLeft,
                        top: tooltipTop,
                        child: IgnorePointer(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.14),
                                  blurRadius: 10,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                              border: Border.all(
                                color: const Color(0xFFE2E8F0),
                                width: 1,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 10,
                                  height: 10,
                                  decoration: BoxDecoration(
                                    color: activeCategory['color'] as Color,
                                    borderRadius: BorderRadius.circular(3),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  activeCategory['name'] as String,
                                  style: const TextStyle(
                                    fontSize: 11.5,
                                    color: Color(0xFF475569),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(width: 14),
                                Text(
                                  '${activeCategory['count']}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF0F172A),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              );
            },
          ),

          const SizedBox(height: 24),

          // DAFTAR LEGEND (DENGAN TITIK WARNA & JUMLAH DALAM KURUNG)
          Wrap(
            spacing: 16,
            runSpacing: 10,
            alignment: WrapAlignment.center,
            children: categoryData.map((item) {
              final String name = item['name'];
              final int count = item['count'];
              final Color color = item['color'];

              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '$name ($count)',
                    style: const TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF475569),
                    ),
                  ),
                ],
              );
            }).toList(),
          ),

          const SizedBox(height: 8),
        ],
      ),
    );
  }

  // WIDGET PROGRESS BAR JURUSAN
  Widget _buildJurusanProgressBar({
    required String jurusan,
    required IconData icon,
    required String count,
    required double percent,
    required Color color,
    required Color bgColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
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
              Icon(icon, size: 16, color: color),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  jurusan,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1E293B),
                  ),
                ),
              ),
              Text(
                count,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: percent,
              minHeight: 6,
              backgroundColor: bgColor,
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
        ],
      ),
    );
  }

  // WIDGET LEADERBOARD KELAS
  Widget _buildKelasLeaderboardItem({
    required String rank,
    required String kelas,
    required String total,
    required Color badgeColor,
    required Color textColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFF1F5F9)),
      ),
      child: Row(
        children: [
          Container(
            width: 26,
            height: 26,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: badgeColor,
              shape: BoxShape.circle,
            ),
            child: Text(
              '#$rank',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              kelas,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1E293B),
              ),
            ),
          ),
          Text(
            total,
            style: const TextStyle(
              fontSize: 11,
              color: Color(0xFF64748B),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// CUSTOM PAINTER 1: SPLINE LINE CHART (TREN PENGAJUAN PORTOFOLIO - BIRU)
// ============================================================================
class SplineChartPainter extends CustomPainter {
  final List<String> months;
  final List<double> values;
  final int? selectedIdx;
  final double maxY;
  final List<double> yLabels;
  final Color primaryColor;

  SplineChartPainter({
    required this.months,
    required this.values,
    this.selectedIdx,
    this.maxY = 80.0,
    required this.yLabels,
    this.primaryColor = const Color(0xFF254BD1),
  });

  @override
  void paint(Canvas canvas, Size size) {
    const leftPadding = 26.0;
    const rightPadding = 12.0;
    const topPadding = 16.0;
    const bottomPadding = 24.0;

    final chartWidth = size.width - leftPadding - rightPadding;
    final chartHeight = size.height - topPadding - bottomPadding;

    final gridPaint = Paint()
      ..color = const Color(0xFFF1F5F9)
      ..strokeWidth = 1;

    final textStyle = const TextStyle(
      fontSize: 10,
      color: Color(0xFF94A3B8),
      fontWeight: FontWeight.w500,
    );

    // 1. GAMBAR GRID HORIZONTAL & LABEL Y-AXIS
    for (int i = 0; i < yLabels.length; i++) {
      final y = topPadding + i * (chartHeight / (yLabels.length - 1));

      // Grid line
      canvas.drawLine(
        Offset(leftPadding, y),
        Offset(size.width - rightPadding, y),
        gridPaint,
      );

      // Label Y
      final labelText = yLabels[i] % 1 == 0
          ? '${yLabels[i].toInt()}'
          : yLabels[i].toStringAsFixed(1);

      final tp = TextPainter(
        text: TextSpan(text: labelText, style: textStyle),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, Offset(leftPadding - tp.width - 6, y - tp.height / 2));
    }

    // 2. HITUNG TITIK KOORDINAT (X, Y)
    final stepX = months.length > 1 ? chartWidth / (months.length - 1) : chartWidth / 2;
    final List<Offset> points = [];

    for (int i = 0; i < months.length; i++) {
      final x = leftPadding + i * stepX;
      final val = values[i];
      final y = topPadding + (1 - (val / maxY)) * chartHeight;
      points.add(Offset(x, y));
    }

    // 3. GAMBAR CURVE HALUS (SPLINE / BEZIER CURVE BIRU)
    final path = Path();
    if (points.isNotEmpty) {
      path.moveTo(points.first.dx, points.first.dy);

      for (int i = 0; i < points.length - 1; i++) {
        final p0 = i > 0 ? points[i - 1] : points[i];
        final p1 = points[i];
        final p2 = points[i + 1];
        final p3 = i < points.length - 2 ? points[i + 2] : p2;

        final cp1x = p1.dx + (p2.dx - p0.dx) / 6;
        final cp1y = p1.dy + (p2.dy - p0.dy) / 6;

        final cp2x = p2.dx - (p3.dx - p1.dx) / 6;
        final cp2y = p2.dy - (p3.dy - p1.dy) / 6;

        path.cubicTo(cp1x, cp1y, cp2x, cp2y, p2.dx, p2.dy);
      }
    }

    // Line paint biru
    final linePaint = Paint()
      ..color = primaryColor
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..strokeWidth = 3.2;

    canvas.drawPath(path, linePaint);

    // 4. GAMBAR TITIK DATA (DOTS) & BULAN / PERIODE DI X-AXIS
    final dotPaint = Paint()..color = primaryColor;

    for (int i = 0; i < points.length; i++) {
      final p = points[i];

      if (selectedIdx != null && i == selectedIdx) {
        // Titik aktif yang disentuh (lebih besar dengan ring putih)
        canvas.drawCircle(p, 6.5, dotPaint);
        canvas.drawCircle(
          p,
          6.5,
          Paint()
            ..color = Colors.white
            ..style = PaintingStyle.stroke
            ..strokeWidth = 2,
        );
      } else {
        // Titik biasa
        canvas.drawCircle(p, 3.8, dotPaint);
      }

      // Label X-Axis di bawah
      final label = months[i];
      final labelTp = TextPainter(
        text: TextSpan(
          text: label,
          style: TextStyle(
            fontSize: 10,
            fontWeight: selectedIdx != null && i == selectedIdx
                ? FontWeight.bold
                : FontWeight.w500,
            color: selectedIdx != null && i == selectedIdx
                ? const Color(0xFF0F172A)
                : const Color(0xFF64748B),
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();

      labelTp.paint(
        canvas,
        Offset(p.dx - labelTp.width / 2, size.height - bottomPadding + 8),
      );
    }
  }

  @override
  bool shouldRepaint(covariant SplineChartPainter oldDelegate) {
    return oldDelegate.selectedIdx != selectedIdx ||
        oldDelegate.values != values ||
        oldDelegate.months != months ||
        oldDelegate.maxY != maxY;
  }
}

// ============================================================================
// CUSTOM PAINTER 2: DONUT / CIRCULAR CHART (KATEGORI PORTOFOLIO DENGAN HIGHLIGHT)
// ============================================================================
class DonutChartPainter extends CustomPainter {
  final List<Map<String, dynamic>> data;
  final int? selectedIdx;

  DonutChartPainter({required this.data, this.selectedIdx});

  @override
  void paint(Canvas canvas, Size size) {
    final total = data.fold<double>(
      0.0,
      (sum, item) => sum + (item['count'] as num).toDouble(),
    );

    if (total == 0) return;

    final center = Offset(size.width / 2, size.height / 2);
    const radius = 68.0;
    const defaultStroke = 28.0;
    const activeStroke = 34.0;

    double startAngle = -math.pi / 2; // Mulai dari atas (jam 12)
    const gapAngle = 0.04; // Celah kecil pemisah segmen

    for (int i = 0; i < data.length; i++) {
      final item = data[i];
      final isSelected = selectedIdx != null && selectedIdx == i;
      final count = (item['count'] as num).toDouble();
      final sweepAngle = (count / total) * 2 * math.pi;

      final paint = Paint()
        ..color = item['color'] as Color
        ..style = PaintingStyle.stroke
        ..strokeWidth = isSelected ? activeStroke : defaultStroke
        ..strokeCap = StrokeCap.butt;

      final rect = Rect.fromCircle(
        center: center,
        radius: isSelected ? radius + 2 : radius,
      );

      if (sweepAngle > gapAngle) {
        canvas.drawArc(
          rect,
          startAngle + gapAngle / 2,
          sweepAngle - gapAngle,
          false,
          paint,
        );
      }

      startAngle += sweepAngle;
    }
  }

  @override
  bool shouldRepaint(covariant DonutChartPainter oldDelegate) {
    return oldDelegate.data != data || oldDelegate.selectedIdx != selectedIdx;
  }
}

