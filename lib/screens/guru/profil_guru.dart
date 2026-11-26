import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import '../../services/image_picker_service.dart';
import '../../services/storage_service.dart';
import '../../widgets/pilih_foto_dialog.dart';
import '../siswa/custom_date_picker_dialog.dart';
import '../siswa/portofolio_data.dart';
import 'dashboard_guru.dart';

class ProfilGuru extends StatefulWidget {
  const ProfilGuru({super.key});

  @override
  State<ProfilGuru> createState() => _ProfilGuruState();
}

class _ProfilGuruState extends State<ProfilGuru> {
  final TextEditingController namaController =
      TextEditingController(text: 'Andi Ardiansyah');
  final TextEditingController nipController =
      TextEditingController(text: '1625891829');
  final TextEditingController bidangController =
      TextEditingController(text: 'Bahasa Inggris');
  final TextEditingController emailController =
      TextEditingController(text: 'ardiiz@gmail.com');
  final TextEditingController tglLahirController =
      TextEditingController(text: '14-02-2008');
  final TextEditingController noTelponController =
      TextEditingController(text: '083930865308943');

  String selectedGender = 'Laki-laki';
  Uint8List? selectedImageBytes;

  final Color primaryBlue = const Color(0xFF254BD1);
  final Color fieldBg = const Color(0xFFD9D9D9);

  @override
  void initState() {
    super.initState();
    final guru = PortofolioDataStore().guruProfile.value;
    selectedImageBytes = guru.avatarBytes;
    namaController.text = guru.nama;
    nipController.text = guru.nip;
    bidangController.text = guru.bidang;
    emailController.text = guru.email;
    tglLahirController.text = guru.tglLahir;
    noTelponController.text = guru.noTelpon;
    selectedGender = guru.jenisKelamin;
  }

  @override
  void dispose() {
    namaController.dispose();
    nipController.dispose();
    bidangController.dispose();
    emailController.dispose();
    tglLahirController.dispose();
    noTelponController.dispose();
    super.dispose();
  }

  Future<void> _pickAvatar() async {
    await PilihFotoDialog.pilihFotoResponsive(
      context,
      onFotoTerpilih: (bytes) {
        setState(() {
          selectedImageBytes = bytes;
        });
      },
    );
  }

  Future<void> _pilihTanggal() async {
    DateTime initial = DateTime(1990, 1, 1);
    if (tglLahirController.text.isNotEmpty) {
      try {
        final parts = tglLahirController.text.split('-');
        if (parts.length == 3) {
          final day = int.parse(parts[0]);
          final month = int.parse(parts[1]);
          final year = int.parse(parts[2]);
          initial = DateTime(year, month, day);
        }
      } catch (_) {}
    }

    final DateTime? picked = await CustomDatePickerDialog.show(
      context,
      initialDate: initial,
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        tglLahirController.text =
            '${picked.day.toString().padLeft(2, '0')}-${picked.month.toString().padLeft(2, '0')}-${picked.year}';
      });
    }
  }

  Future<void> _simpanProfil() async {
    String avatarUrl = PortofolioDataStore().guruProfile.value.avatarUrl;
    final currentId = AuthService.currentUser?['id_guru']?.toString() ??
        PortofolioDataStore().guruProfile.value.nip;

    if (selectedImageBytes != null) {
      final uploadedUrl = await StorageService.uploadFotoProfil(
        selectedImageBytes!,
        role: 'guru',
        userId: currentId,
      );
      if (uploadedUrl != null && uploadedUrl.isNotEmpty) {
        avatarUrl = uploadedUrl;
      }
    }

    final updated = GuruProfile(
      nama: namaController.text.trim().isNotEmpty
          ? namaController.text.trim()
          : 'Balqis Demes Piscesa',
      nip: nipController.text.trim().isNotEmpty
          ? nipController.text.trim()
          : '1625891829',
      bidang: bidangController.text.trim().isNotEmpty
          ? bidangController.text.trim()
          : 'Bahasa Inggris',
      email: emailController.text.trim().isNotEmpty
          ? emailController.text.trim()
          : 'ardiiz@gmail.com',
      tglLahir: tglLahirController.text.trim().isNotEmpty
          ? tglLahirController.text.trim()
          : '14-02-2008',
      noTelpon: noTelponController.text.trim().isNotEmpty
          ? noTelponController.text.trim()
          : '083930865308943',
      jenisKelamin: selectedGender,
      avatarUrl: avatarUrl,
      avatarBytes: selectedImageBytes,
    );

    PortofolioDataStore().guruProfile.value = updated;

    // Perbarui foto_profil & data di tabel guru Supabase
    try {
      final supabase = StorageService.supabase;
      final email = emailController.text.trim();
      final nip = nipController.text.trim();
      final currentId = AuthService.currentUser?['id_guru'];

      final updatePayload = <String, dynamic>{
        'nama_guru': updated.nama,
        'bidang_mengajar': updated.bidang,
        if (avatarUrl.startsWith('http')) 'foto_profil': avatarUrl,
      };

      if (currentId != null) {
        await supabase.from('guru').update(updatePayload).eq('id_guru', currentId);
      } else if (email.isNotEmpty || nip.isNotEmpty) {
        await supabase.from('guru').update(updatePayload).or('email.eq.$email,nip.eq.$nip');
      }

      if (AuthService.currentUser != null) {
        AuthService.currentUser!['nama_guru'] = updated.nama;
        AuthService.currentUser!['bidang_mengajar'] = updated.bidang;
        if (avatarUrl.startsWith('http')) {
          AuthService.currentUser!['foto_profil'] = avatarUrl;
        }
      }
    } catch (_) {}

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.check_circle_rounded, color: Colors.white),
            SizedBox(width: 10),
            Text('Profil guru berhasil diperbarui'),
          ],
        ),
        backgroundColor: const Color(0xFF16A34A),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );

    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const DashboardGuru()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1E293B)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Profil Guru',
          style: TextStyle(
            color: Color(0xFF1E293B),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: InkWell(
                onTap: _simpanProfil,
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFD9D9D9),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.bookmark_rounded,
                        size: 16,
                        color: Color(0xFF1E293B),
                      ),
                      SizedBox(width: 6),
                      Text(
                        'Simpan',
                        style: TextStyle(
                          color: Color(0xFF1E293B),
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // FOTO PROFIL GURU (TENGAH)
            Center(
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  InkWell(
                    onTap: _pickAvatar,
                    borderRadius: BorderRadius.circular(60),
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 3),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x1F000000),
                            blurRadius: 10,
                            offset: Offset(0, 4),
                          ),
                        ],
                        image: DecorationImage(
                          image: PortofolioItem.getAvatarImageProvider(
                            selectedImageBytes,
                            PortofolioDataStore().guruProfile.value.avatarUrl,
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: _pickAvatar,
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: const EdgeInsets.all(7),
                      decoration: const BoxDecoration(
                        color: Color(0xFF254BD1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.camera_alt_rounded,
                        color: Colors.white,
                        size: 16,
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

            const SizedBox(height: 18),

            // NAMA LENGKAP
            _buildFieldLabel('Nama Lengkap'),
            _buildTextField(namaController),

            const SizedBox(height: 14),

            // NIP
            _buildFieldLabel('NIP'),
            _buildTextField(nipController, keyboardType: TextInputType.number),

            const SizedBox(height: 14),

            // BIDANG MENGAJAR
            _buildFieldLabel('Bidang Mengajar'),
            _buildTextField(bidangController),

            const SizedBox(height: 14),

            // EMAIL
            _buildFieldLabel('Email'),
            _buildTextField(emailController, keyboardType: TextInputType.emailAddress),

            const SizedBox(height: 14),

            // TANGGAL LAHIR
            _buildFieldLabel('Tanggal Lahir'),
            InkWell(
              onTap: _pilihTanggal,
              borderRadius: BorderRadius.circular(12),
              child: IgnorePointer(
                child: _buildTextField(
                  tglLahirController,
                  suffixIcon: const Icon(
                    Icons.calendar_today_rounded,
                    size: 18,
                    color: Color(0xFF64748B),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 14),

            // JENIS KELAMIN
            _buildFieldLabel('Jenis Kelamin'),
            Container(
              height: 48,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: fieldBg,
                borderRadius: BorderRadius.circular(12),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: selectedGender,
                  isExpanded: true,
                  icon: const Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: Color(0xFF64748B),
                  ),
                  style: const TextStyle(
                    color: Color(0xFF1E293B),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  dropdownColor: Colors.white,
                  items: const [
                    DropdownMenuItem(
                      value: 'Laki-laki',
                      child: Text('Laki-laki'),
                    ),
                    DropdownMenuItem(
                      value: 'Perempuan',
                      child: Text('Perempuan'),
                    ),
                  ],
                  onChanged: (val) {
                    if (val != null) {
                      setState(() {
                        selectedGender = val;
                      });
                    }
                  },
                ),
              ),
            ),

            const SizedBox(height: 14),

            // NO TELPON
            _buildFieldLabel('No Telpon'),
            _buildTextField(noTelponController, keyboardType: TextInputType.phone),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildFieldLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Color(0xFF1E293B),
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller, {
    TextInputType keyboardType = TextInputType.text,
    Widget? suffixIcon,
  }) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: fieldBg,
        borderRadius: BorderRadius.circular(12),
      ),
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        style: const TextStyle(
          color: Color(0xFF1E293B),
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          isDense: true,
          contentPadding: EdgeInsets.zero,
          suffixIcon: suffixIcon,
          suffixIconConstraints: const BoxConstraints(minWidth: 24, minHeight: 24),
        ),
      ),
    );
  }
}

