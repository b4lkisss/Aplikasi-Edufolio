import 'package:flutter/material.dart';

class GrafikStatistik extends StatefulWidget {
  const GrafikStatistik({super.key});

  @override
  State<GrafikStatistik> createState() => _GrafikStatistikState();
}

class _GrafikStatistikState extends State<GrafikStatistik> {
  static const Color primaryBlue = Color(0xFF254BD1);

  String selectedPeriod = 'This Month';

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
          'Statistik & Grafik',
          style: TextStyle(
            color: Color(0xFF1E293B),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          // DROPDOWN FILTER PERIODE
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
                items: [
                  'This Month',
                  'Last Month',
                  'This Year',
                  'All Time',
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
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // KARTU RINGKASAN AKTIVITAS PORTOFOLIO
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total Portofolio Terunggah',
                        style: TextStyle(
                          color: Color(0xFFBAE6FD),
                          fontSize: 12.5,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0x33FFFFFF),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.trending_up_rounded,
                              color: Colors.white,
                              size: 14,
                            ),
                            SizedBox(width: 4),
                            Text(
                              '+18% bulan ini',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '150 Portofolio',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Dihitung berdasarkan seluruh karya, sertifikat, dan prestasi siswa.',
                    style: TextStyle(
                      color: Color(0xFFE0F2FE),
                      fontSize: 11.5,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            // DIAGRAM BATANG VISUAL KEAKTIFAN BULANAN
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
                  const Row(
                    children: [
                      Icon(Icons.bar_chart_rounded, color: primaryBlue, size: 20),
                      SizedBox(width: 8),
                      Text(
                        'Tren Pengajuan Portofolio',
                        style: TextStyle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Aktivitas unggahan portofolio dalam 6 bulan terakhir',
                    style: TextStyle(
                      fontSize: 11,
                      color: Color(0xFF64748B),
                    ),
                  ),
                  const SizedBox(height: 18),

                  // BATANG GRAFIK
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      _buildBarItem('Mei', 0.45, '18'),
                      _buildBarItem('Jun', 0.60, '24'),
                      _buildBarItem('Jul', 0.35, '14'),
                      _buildBarItem('Agt', 0.80, '32'),
                      _buildBarItem('Sep', 0.70, '28'),
                      _buildBarItem('Okt', 0.95, '38', isHighest: true),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            // SECTION 1: PERBANDINGAN PORTOFOLIO PER JURUSAN
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
                    count: '98 Portofolio',
                    percent: 0.65,
                    color: primaryBlue,
                    bgColor: const Color(0x1F254BD1),
                  ),

                  const SizedBox(height: 10),

                  // JURUSAN TKJ
                  _buildJurusanProgressBar(
                    jurusan: 'Teknik Komputer & Jaringan (TKJ)',
                    icon: Icons.router_rounded,
                    count: '52 Portofolio',
                    percent: 0.35,
                    color: const Color(0xFF0D9488),
                    bgColor: const Color(0x1F0D9488),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            // SECTION 2: TOP KELAS TERAKTIF
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

                  _buildKelasLeaderboardItem(
                    rank: '1',
                    kelas: 'XII RPL B',
                    total: '48 Portofolio',
                    badgeColor: const Color(0xFFFEF3C7),
                    textColor: const Color(0xFFD97706),
                  ),
                  const SizedBox(height: 8),
                  _buildKelasLeaderboardItem(
                    rank: '2',
                    kelas: 'XI RPL A',
                    total: '32 Portofolio',
                    badgeColor: const Color(0xFFF1F5F9),
                    textColor: const Color(0xFF64748B),
                  ),
                  const SizedBox(height: 8),
                  _buildKelasLeaderboardItem(
                    rank: '3',
                    kelas: 'XII TKJ A',
                    total: '28 Portofolio',
                    badgeColor: const Color(0xFFFFEDD5),
                    textColor: const Color(0xFFC2410C),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildBarItem(String month, double heightRatio, String count,
      {bool isHighest = false}) {
    const maxHeight = 100.0;
    final barHeight = maxHeight * heightRatio;

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          count,
          style: TextStyle(
            fontSize: 10.5,
            fontWeight: FontWeight.bold,
            color: isHighest ? primaryBlue : const Color(0xFF64748B),
          ),
        ),
        const SizedBox(height: 4),
        Container(
          width: 28,
          height: barHeight,
          decoration: BoxDecoration(
            color: isHighest ? primaryBlue : const Color(0xFF93C5FD),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          month,
          style: TextStyle(
            fontSize: 11,
            fontWeight: isHighest ? FontWeight.bold : FontWeight.w500,
            color: isHighest ? primaryBlue : const Color(0xFF475569),
          ),
        ),
      ],
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
