import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../../services/image_picker_service.dart';
import 'portofolio_data.dart';
import 'custom_date_picker_dialog.dart';

class TambahPortofolioSiswa extends StatefulWidget {
  const TambahPortofolioSiswa({super.key});

  @override
  State<TambahPortofolioSiswa> createState() => _TambahPortofolioSiswaState();
}

class _TambahPortofolioSiswaState extends State<TambahPortofolioSiswa> {
  static const Color primaryBlue = Color(0xFF356DA8);

  final _formKey = GlobalKey<FormState>();

  final TextEditingController judulController = TextEditingController();
  final TextEditingController deskripsiController = TextEditingController();
  final TextEditingController skillController = TextEditingController();
  final TextEditingController linkController = TextEditingController();

  String? selectedKategori;
  String? selectedTingkat;
  String? selectedPeran;
  DateTime? selectedDate;
  Uint8List? selectedImageBytes;
  String? uploadedFileName;

  final List<String> opsiKategori = [
    'Prestasi & Lomba',
    'Sertifikat',
    'Projek',
    'Organisasi',
    'Lainnya',
  ];

  final List<String> opsiTingkat = [
    'Sekolah',
    'Kecamatan / Wilayah',
    'Kota / Kabupaten',
    'Provinsi',
    'Nasional',
    'Internasional',
  ];

  final List<String> opsiPeran = [
    'Ketua Tim',
    'Anggota Tim',
    'Peserta Aktif',
    'Pemenang / Juara',
    'Frontend Developer',
    'Backend Developer',
    'UI/UX Designer',
    'Mobile Developer',
    'Lainnya',
  ];

  @override
  void dispose() {
    judulController.dispose();
    deskripsiController.dispose();
    skillController.dispose();
    linkController.dispose();
    super.dispose();
  }

  Future<void> _bukaDatePicker() async {
    final picked = await CustomDatePickerDialog.show(
      context,
      initialDate: selectedDate ?? DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<void> _pickFile() async {
    final bytes = await AppImagePicker.pickImage();
    if (bytes != null) {
      setState(() {
        selectedImageBytes = bytes;
        uploadedFileName = 'bukti_portofolio_${DateTime.now().millisecondsSinceEpoch}.jpg';
      });
    }
  }

  void _kirimPortofolio() {
    if (judulController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Judul portofolio wajib diisi!'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (selectedKategori == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Silakan pilih kategori portofolio!'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (selectedTingkat == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Silakan pilih tingkat kompetisi/kegiatan!'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Silakan pilih tanggal perolehan / pelaksanaan!'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (selectedPeran == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Silakan pilih peran!'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Ambil skills dari input dipisahkan koma
    List<String> skillsList = [];
    if (skillController.text.trim().isNotEmpty) {
      skillsList = skillController.text
          .split(',')
          .map((s) => s.trim())
          .where((s) => s.isNotEmpty)
          .toList();
    }
    if (skillsList.isEmpty) {
      skillsList = ['Kreativitas', 'Kerjasama Tim'];
    }

    final dayStr = selectedDate!.day.toString().padLeft(2, '0');
    final monthStr = selectedDate!.month.toString().padLeft(2, '0');
    final formattedDate = '$dayStr/$monthStr/${selectedDate!.year}';

    final newItem = PortofolioItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      judul: judulController.text.trim(),
      kategori: selectedKategori!,
      tingkat: selectedTingkat!,
      tanggal: selectedDate!.year.toString(),
      deskripsi: deskripsiController.text.trim().isNotEmpty
          ? deskripsiController.text.trim()
          : 'Portofolio karya mandiri siswa dalam bidang ${selectedKategori!}.',
      peran: selectedPeran!,
      skills: skillsList,
      link: linkController.text.trim().isNotEmpty
          ? linkController.text.trim()
          : 'https://drive.google.com/portofolio-edufolio',
      status: 'Menunggu',
      imageUrl:
          'https://images.unsplash.com/photo-1589829545856-d10d557cf95f?auto=format&fit=crop&w=600&q=80',
      tanggalUnggah: formattedDate,
    );

    PortofolioDataStore().addPortofolio(newItem);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.check_circle_rounded, color: Colors.white),
            SizedBox(width: 10),
            Expanded(
              child: Text('Portofolio berhasil dikirim untuk verifikasi!'),
            ),
          ],
        ),
        backgroundColor: primaryBlue,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final String tanggalFormatted = selectedDate != null
        ? '${selectedDate!.day.toString().padLeft(2, "0")} / ${selectedDate!.month.toString().padLeft(2, "0")} / ${selectedDate!.year}'
        : '';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Tambah Portofolio',
          style: TextStyle(
            color: Color(0xFF0F172A),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.notifications_rounded,
              color: primaryBlue,
              size: 26,
            ),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Tidak ada notifikasi baru.'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. JUDUL PORTOFOLIO / PRESTASI
              _buildLabel('Judul Portofolio / Prestasi'),
              _buildTextInput(
                controller: judulController,
                hintText: 'Contoh: Juara 1 Lomba Web Design',
              ),

              const SizedBox(height: 14),

              // 2. KATEGORI (DROPDOWN)
              _buildLabel('Kategori'),
              _buildDropdown(
                value: selectedKategori,
                hintText: 'Pilih Kategori',
                items: opsiKategori,
                onChanged: (val) {
                  setState(() => selectedKategori = val);
                },
              ),

              const SizedBox(height: 14),

              // 3. TINGKAT (DROPDOWN)
              _buildLabel('Tingkat'),
              _buildDropdown(
                value: selectedTingkat,
                hintText: 'Pilih Tingkat',
                items: opsiTingkat,
                onChanged: (val) {
                  setState(() => selectedTingkat = val);
                },
              ),

              const SizedBox(height: 14),

              // 4. TANGGAL PEROLEHAN / PELAKSANAAN (DATE PICKER)
              _buildLabel('Tanggal Perolehan / Pelaksanaan'),
              InkWell(
                borderRadius: BorderRadius.circular(14),
                onTap: _bukaDatePicker,
                child: Container(
                  height: 48,
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: primaryBlue, width: 1.5),
                  ),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    selectedDate != null
                        ? tanggalFormatted
                        : 'Pilih Tanggal',
                    style: TextStyle(
                      fontSize: 13,
                      color: selectedDate != null
                          ? const Color(0xFF1E293B)
                          : const Color(0xFF94A3B8),
                      fontWeight: selectedDate != null
                          ? FontWeight.w600
                          : FontWeight.normal,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 14),

              // 5. DESKRIPSI
              _buildLabel('Deskripsi'),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: primaryBlue, width: 1.5),
                ),
                child: TextField(
                  controller: deskripsiController,
                  maxLines: 3,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF1E293B),
                  ),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText:
                        'Jelaskan apa yang kamu lakukan dan hasil yang dicapai...',
                    hintStyle: TextStyle(
                      color: Color(0xFF94A3B8),
                      fontSize: 13,
                    ),
                    contentPadding: EdgeInsets.all(12),
                  ),
                ),
              ),

              const SizedBox(height: 14),

              // 6. PERAN (DROPDOWN)
              _buildLabel('Peran'),
              _buildDropdown(
                value: selectedPeran,
                hintText: 'Pilih Peran',
                items: opsiPeran,
                onChanged: (val) {
                  setState(() => selectedPeran = val);
                },
              ),

              const SizedBox(height: 14),

              // 7. SKILL YANG TERLIBAT
              _buildLabel('Skill yang Terlibat'),
              _buildTextInput(
                controller: skillController,
                hintText: 'Tambah skill',
              ),

              const SizedBox(height: 14),

              // 8. UPLOAD BUKTI FOTO / SERTIFIKAT
              _buildLabel('Upload bukti foto / Sertifikat'),
              InkWell(
                borderRadius: BorderRadius.circular(14),
                onTap: _pickFile,
                child: Container(
                  width: double.infinity,
                  height: 120,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: primaryBlue, width: 1.5),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (selectedImageBytes != null) ...[
                          const Icon(
                            Icons.check_circle_rounded,
                            color: Colors.green,
                            size: 28,
                          ),
                          const SizedBox(height: 6),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              uploadedFileName ?? 'File dipilih',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: primaryBlue,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Klik untuk ganti file',
                            style: TextStyle(
                              fontSize: 11,
                              color: Color(0xFF64748B),
                            ),
                          ),
                        ] else ...[
                          const Text(
                            'Pilih File / Upload',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: primaryBlue,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'JPG, PNG, PDF (Maks 10MB)',
                            style: TextStyle(
                              fontSize: 11,
                              color: Color(0xFF64748B),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 14),

              // 9. TAUTAN / LINK PENDUKUNG (OPSIONAL)
              _buildLabel('Tautan / Link Pendukung (Opsional)'),
              _buildTextInput(
                controller: linkController,
                hintText: 'https://contoh.link.com',
                keyboardType: TextInputType.url,
              ),

              const SizedBox(height: 24),

              // 10. TOMBOL SUBMIT "Kirim untuk Verifikasi"
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: _kirimPortofolio,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryBlue,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Kirim untuk Verifikasi',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.bold,
          color: primaryBlue,
        ),
      ),
    );
  }

  Widget _buildTextInput({
    required TextEditingController controller,
    required String hintText,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: primaryBlue, width: 1.5),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        style: const TextStyle(
          fontSize: 13,
          color: Color(0xFF1E293B),
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hintText,
          hintStyle: const TextStyle(
            color: Color(0xFF94A3B8),
            fontSize: 13,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 14,
          ),
          isDense: true,
        ),
      ),
    );
  }

  Widget _buildDropdown({
    required String? value,
    required String hintText,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: primaryBlue, width: 1.5),
      ),
      alignment: Alignment.center,
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          hint: Text(
            hintText,
            style: const TextStyle(
              color: Color(0xFF94A3B8),
              fontSize: 13,
            ),
          ),
          icon: const Icon(
            Icons.keyboard_arrow_down_rounded,
            color: primaryBlue,
          ),
          style: const TextStyle(
            fontSize: 13,
            color: Color(0xFF1E293B),
            fontWeight: FontWeight.w500,
          ),
          items: items.map((item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
