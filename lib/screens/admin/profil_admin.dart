import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import '../../services/image_picker_service.dart';
import '../../services/storage_service.dart';
import '../../widgets/pilih_foto_dialog.dart';
import '../siswa/portofolio_data.dart';
import 'dashboard_admin.dart';

class ProfilAdmin extends StatefulWidget {
  const ProfilAdmin({super.key});

  @override
  State<ProfilAdmin> createState() => _ProfilAdminState();
}

class _ProfilAdminState extends State<ProfilAdmin> {
  // Controller form
  final TextEditingController namaController =
      TextEditingController(text: 'Andi Ardiansyah');
  final TextEditingController emailController =
      TextEditingController(text: 'ardi@gmail.com');
  final TextEditingController tanggalLahirController =
      TextEditingController(text: '13-04-2007');
  final TextEditingController noTelponController =
      TextEditingController(text: '3740249284649');

  // State untuk tanggal lahir
  DateTime selectedDate = DateTime(2007, 4, 13);

  // State untuk jenis kelamin dropdown
  String selectedJenisKelamin = 'laki-laki';
  final List<String> opsiJenisKelamin = ['laki-laki', 'perempuan'];

  // State untuk foto profil yang dipilih
  Uint8List? fotoBytes;

  final Color fieldColor = const Color(0xFFD9D9D9); // Warna abu-abu field sesuai gambar

  @override
  void initState() {
    super.initState();
    final admin = PortofolioDataStore().adminProfile.value;
    fotoBytes = admin.avatarBytes;
    namaController.text = admin.nama;
    emailController.text = admin.email;
    tanggalLahirController.text = admin.tglLahir;
    noTelponController.text = admin.noTelpon;
    selectedJenisKelamin =
        admin.jenisKelamin.toLowerCase().contains('perempuan')
            ? 'perempuan'
            : 'laki-laki';
  }

  @override
  void dispose() {
    namaController.dispose();
    emailController.dispose();
    tanggalLahirController.dispose();
    noTelponController.dispose();
    super.dispose();
  }

  // FUNGSI 1: DATEPICKER UNTUK TANGGAL LAHIR
  Future<void> _pilihTanggalLahir() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1960),
      lastDate: DateTime.now(),
      helpText: 'Pilih Tanggal Lahir',
      cancelText: 'Batal',
      confirmText: 'Pilih',
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF254BD1),
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        selectedDate = picked;
        final day = picked.day.toString().padLeft(2, '0');
        final month = picked.month.toString().padLeft(2, '0');
        tanggalLahirController.text = '$day-$month-${picked.year}';
      });
    }
  }

  // FUNGSI 2: PICKER FOTO PROFIL (MEMBUKA FILE EXPLORER)
  Future<void> _pilihFoto() async {
    await PilihFotoDialog.pilihFotoResponsive(
      context,
      onFotoTerpilih: (bytes) {
        setState(() {
          fotoBytes = bytes;
        });
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Foto profil berhasil diubah!'),
            backgroundColor: Color(0xFF254BD1),
            duration: Duration(seconds: 2),
          ),
        );
      },
    );
  }

  // FUNGSI SIMPAN PROFIL
  Future<void> _simpanProfil() async {
    String avatarUrl = PortofolioDataStore().adminProfile.value.avatarUrl;
    final currentId = AuthService.currentUser?['id_admin']?.toString() ?? '1';

    if (fotoBytes != null) {
      final uploadedUrl = await StorageService.uploadFotoProfil(
        fotoBytes!,
        role: 'admin',
        userId: currentId,
      );
      if (uploadedUrl != null && uploadedUrl.isNotEmpty) {
        avatarUrl = uploadedUrl;
      }
    }

    final updated = AdminProfile(
      nama: namaController.text.trim().isNotEmpty
          ? namaController.text.trim()
          : 'Administrator',
      email: emailController.text.trim().isNotEmpty
          ? emailController.text.trim()
          : 'admin@edufolio.com',
      noTelpon: noTelponController.text.trim().isNotEmpty
          ? noTelponController.text.trim()
          : '081234567890',
      jenisKelamin: selectedJenisKelamin,
      tglLahir: tanggalLahirController.text.trim().isNotEmpty
          ? tanggalLahirController.text.trim()
          : '01-01-1995',
      avatarUrl: avatarUrl,
      avatarBytes: fotoBytes,
    );

    PortofolioDataStore().adminProfile.value = updated;

    // Perbarui foto_profil & data di tabel admin Supabase
    try {
      final supabase = StorageService.supabase;
      final email = emailController.text.trim();
      final currentId = AuthService.currentUser?['id_admin'];

      final updatePayload = <String, dynamic>{
        'nama_admin': updated.nama,
        if (avatarUrl.startsWith('http')) 'foto_profil': avatarUrl,
      };

      if (currentId != null) {
        await supabase.from('admin').update(updatePayload).eq('id_admin', currentId);
      } else if (email.isNotEmpty) {
        await supabase.from('admin').update(updatePayload).eq('email', email);
      }

      if (AuthService.currentUser != null) {
        AuthService.currentUser!['nama_admin'] = updated.nama;
        if (avatarUrl.startsWith('http')) {
          AuthService.currentUser!['foto_profil'] = avatarUrl;
        }
      }
    } catch (_) {}

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Profil Admin berhasil disimpan!'),
        backgroundColor: Color(0xFF254BD1),
        duration: Duration(seconds: 2),
      ),
    );

    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const DashboardAdmin()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // HEADER ATAS: TOMBOL KEMBALI + JUDUL + TOMBOL SIMPAN
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  // Tombol Panah Kembali
                  InkWell(
                    borderRadius: BorderRadius.circular(8),
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Padding(
                      padding: EdgeInsets.all(4),
                      child: Icon(
                        Icons.arrow_back,
                        size: 24,
                        color: Colors.black,
                      ),
                    ),
                  ),

                  const SizedBox(width: 8),

                  // Judul Halaman
                  const Expanded(
                    child: Text(
                      'Profil Admin',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),

                  // Tombol Simpan Abu-Abu
                  InkWell(
                    borderRadius: BorderRadius.circular(8),
                    onTap: _simpanProfil,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: fieldColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.bookmark,
                            size: 16,
                            color: Colors.black,
                          ),
                          SizedBox(width: 5),
                          Text(
                            'Simpan',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // KONTEN FORM (SCROLLABLE)
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),

                    // FOTO PROFIL DI TENGAH (BISA DIKLIK UNTUK MEMILIH FOTO DARI FILE EXPLORER)
                    Center(
                      child: Stack(
                        children: [
                          InkWell(
                            borderRadius: BorderRadius.circular(60),
                            onTap: _pilihFoto,
                            child: Container(
                              width: 120,
                              height: 120,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: const Color(0xFFCBD5E1),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Color(0x1A000000),
                                    blurRadius: 10,
                                    offset: Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: ClipOval(
                                child: Image(
                                  image: PortofolioItem.getAvatarImageProvider(
                                    fotoBytes,
                                    PortofolioDataStore().adminProfile.value.avatarUrl,
                                  ),
                                  width: 120,
                                  height: 120,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),

                          // Tombol Kamera Kecil di Pojok Kanan Bawah
                          Positioned(
                            bottom: 2,
                            right: 2,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(20),
                              onTap: _pilihFoto,
                              child: Container(
                                padding: const EdgeInsets.all(7),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF254BD1),
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 2,
                                  ),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Color(0x26000000),
                                      blurRadius: 4,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Icons.camera_alt_rounded,
                                  color: Colors.white,
                                  size: 15,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 12),

                    // BADGE INSTANSI TETAP: SMKN 8 MALANG
                    Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEFF6FF),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: const Color(0xFFBFDBFE), width: 1.2),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.school_rounded,
                              size: 16,
                              color: Color(0xFF254BD1),
                            ),
                            SizedBox(width: 6),
                            Text(
                              'Instansi: SMKN 8 Malang',
                              style: TextStyle(
                                fontSize: 12.5,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1E40AF),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // 1. NAMA LENGKAP
                    _buildFieldGroup('Nama Lengkap', namaController),

                    // 2. EMAIL
                    _buildFieldGroup(
                      'Email',
                      emailController,
                      keyboardType: TextInputType.emailAddress,
                    ),

                    // 3. TANGGAL LAHIR (DENGAN DATE PICKER)
                    _buildDatePickerField('Tanggal Lahir'),

                    // 4. JENIS KELAMIN (DENGAN DROPDOWN)
                    _buildDropdownJenisKelamin('Jenis Kelamin'),

                    // 5. NO TELPON
                    _buildFieldGroup(
                      'No Telpon',
                      noTelponController,
                      keyboardType: TextInputType.phone,
                    ),

                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // WIDGET STANDARD TEXT FIELD
  Widget _buildFieldGroup(
    String label,
    TextEditingController controller, {
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            height: 48,
            decoration: BoxDecoration(
              color: fieldColor,
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 14),
            alignment: Alignment.centerLeft,
            child: TextField(
              controller: controller,
              keyboardType: keyboardType,
              style: const TextStyle(
                fontSize: 13,
                color: Color(0xFF475569),
                fontWeight: FontWeight.w500,
              ),
              decoration: const InputDecoration(
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // WIDGET TANGGAL LAHIR (DATEPICKER)
  Widget _buildDatePickerField(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 8),
          InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: _pilihTanggalLahir,
            child: Container(
              height: 48,
              decoration: BoxDecoration(
                color: fieldColor,
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      tanggalLahirController.text,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF475569),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const Icon(
                    Icons.calendar_today_outlined,
                    size: 18,
                    color: Color(0xFF64748B),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // WIDGET JENIS KELAMIN (DROPDOWN)
  Widget _buildDropdownJenisKelamin(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            height: 48,
            decoration: BoxDecoration(
              color: fieldColor,
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: selectedJenisKelamin,
                isExpanded: true,
                icon: const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: Color(0xFF64748B),
                ),
                style: const TextStyle(
                  fontSize: 13,
                  color: Color(0xFF475569),
                  fontWeight: FontWeight.w500,
                ),
                dropdownColor: Colors.white,
                borderRadius: BorderRadius.circular(12),
                items: opsiJenisKelamin.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() {
                      selectedJenisKelamin = newValue;
                    });
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
