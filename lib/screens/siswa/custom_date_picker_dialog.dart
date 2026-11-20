import 'package:flutter/material.dart';

class CustomDatePickerDialog extends StatefulWidget {
  final DateTime initialDate;
  final DateTime? firstDate;
  final DateTime? lastDate;

  const CustomDatePickerDialog({
    super.key,
    required this.initialDate,
    this.firstDate,
    this.lastDate,
  });

  static Future<DateTime?> show(
    BuildContext context, {
    DateTime? initialDate,
    DateTime? firstDate,
    DateTime? lastDate,
  }) {
    return showDialog<DateTime>(
      context: context,
      barrierDismissible: true,
      builder: (context) => CustomDatePickerDialog(
        initialDate: initialDate ?? DateTime.now(),
        firstDate: firstDate ?? DateTime(2000),
        lastDate: lastDate ?? DateTime(2035),
      ),
    );
  }

  @override
  State<CustomDatePickerDialog> createState() => _CustomDatePickerDialogState();
}

class _CustomDatePickerDialogState extends State<CustomDatePickerDialog> {
  static const Color primaryBlue = Color(0xFF356DA8);
  static const Color dialogBg = Color(0xFFD9DDE2);

  static const List<String> namaBulan = [
    'Januari',
    'Februari',
    'Maret',
    'April',
    'Mei',
    'Juni',
    'Juli',
    'Agustus',
    'September',
    'Oktober',
    'November',
    'Desember',
  ];

  late int displayedYear;
  late int displayedMonth; // 1-12
  late DateTime selectedDate;

  @override
  void initState() {
    super.initState();
    selectedDate = widget.initialDate;
    displayedYear = widget.initialDate.year;
    displayedMonth = widget.initialDate.month;
  }

  void _previousMonth() {
    setState(() {
      if (displayedMonth == 1) {
        displayedMonth = 12;
        displayedYear--;
      } else {
        displayedMonth--;
      }
    });
  }

  void _nextMonth() {
    setState(() {
      if (displayedMonth == 12) {
        displayedMonth = 1;
        displayedYear++;
      } else {
        displayedMonth++;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Hitung jumlah hari dalam bulan
    final daysInMonth = DateTime(displayedYear, displayedMonth + 1, 0).day;
    // Hari pertama dalam bulan (1 = Senin, 7 = Minggu)
    final firstWeekday = DateTime(displayedYear, displayedMonth, 1).weekday;
    // Offset untuk Mo, Tu, We, Th, Fr, Sa, Su (Mo = 1, Su = 7)
    final offset = firstWeekday - 1;

    final String dayStr = selectedDate.day.toString().padLeft(2, '0');
    final String monthStr = selectedDate.month.toString().padLeft(2, '0');
    final String formattedDate = '$dayStr / $monthStr / ${selectedDate.year}';

    return Dialog(
      backgroundColor: dialogBg,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // HEADER BULAN DENGAN PANAH KIRI & KANAN
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Material(
                  color: const Color(0xFFCBD5E1),
                  borderRadius: BorderRadius.circular(8),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(8),
                    onTap: _previousMonth,
                    child: const SizedBox(
                      width: 38,
                      height: 38,
                      child: Icon(
                        Icons.chevron_left_rounded,
                        color: Color(0xFF1E293B),
                        size: 26,
                      ),
                    ),
                  ),
                ),
                Text(
                  '${namaBulan[displayedMonth - 1]} $displayedYear',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F172A),
                  ),
                ),
                Material(
                  color: const Color(0xFFCBD5E1),
                  borderRadius: BorderRadius.circular(8),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(8),
                    onTap: _nextMonth,
                    child: const SizedBox(
                      width: 38,
                      height: 38,
                      child: Icon(
                        Icons.chevron_right_rounded,
                        color: Color(0xFF1E293B),
                        size: 26,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // NAMA HARI (Mo, Tu, We, Th, Fr, Sa, Su)
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _WeekdayHeader('Mo'),
                _WeekdayHeader('Tu'),
                _WeekdayHeader('We'),
                _WeekdayHeader('Th'),
                _WeekdayHeader('Fr'),
                _WeekdayHeader('Sa'),
                _WeekdayHeader('Su'),
              ],
            ),

            const SizedBox(height: 12),

            // GRID TANGGAL
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: offset + daysInMonth,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                mainAxisSpacing: 8,
                crossAxisSpacing: 6,
                childAspectRatio: 1.05,
              ),
              itemBuilder: (context, index) {
                if (index < offset) {
                  return const SizedBox();
                }

                final dayNumber = index - offset + 1;
                final isSelected = selectedDate.year == displayedYear &&
                    selectedDate.month == displayedMonth &&
                    selectedDate.day == dayNumber;

                return InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: () {
                    setState(() {
                      selectedDate = DateTime(
                        displayedYear,
                        displayedMonth,
                        dayNumber,
                      );
                    });
                  },
                  child: Center(
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isSelected ? primaryBlue : Colors.transparent,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        '$dayNumber',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.w600,
                          color: isSelected
                              ? Colors.white
                              : const Color(0xFF0F172A),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 24),

            // BOTTOM BAR: TANGGAL TERPILIH & TOMBOL "Set Date"
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  formattedDate,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: primaryBlue,
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(selectedDate);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryBlue,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 22,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Set Date',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _WeekdayHeader extends StatelessWidget {
  final String label;
  const _WeekdayHeader(this.label);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 36,
      child: Center(
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0F172A),
          ),
        ),
      ),
    );
  }
}
