import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import '../../services/image_picker_service.dart';
import '../../services/storage_service.dart';
import '../../widgets/pilih_foto_dialog.dart';
import 'dashboard_siswa.dart';
import 'portofolio_data.dart';

class ProfilSiswa extends StatefulWidget {
  const ProfilSiswa({super.key});

  @override
  State<ProfilSiswa> createState() => _ProfilSiswaState();
}

class _ProfilSiswaState extends State<ProfilSiswa> {
  static const Color primaryBlue = Color(0xFF356DA8);
  static const Color fieldBg = Color(0xFFD9DDE2);

  final dataStore = PortofolioDataStore();

  late TextEditingController namaController;
  late TextEditingController nisnController;
  late TextEditingController emailController;
  late TextEditingController noTelponController;

  late String selectedKelas;
  late String selectedJurusan;
  late String selectedJenisKelamin;

  Uint8List? selectedImageBytes;

  final List<String> opsiKelas = [
    'X RPL A',
    'X RPL B',
    'XI RPL A',
    'XI RPL B',
    'XII RPL A',
    'XII RPL B',
    'X TKJ A',
    'XI TKJ A',
    'XII TKJ A',
    'X DKV A',
    'XI DKV A',
    'XII DKV A',
  ];

  final List<String> opsiJurusan = [
    'RPL',
    'TKJ',
    'DKV',
    'AKL',
    'MPLB',
  ];

  final List<String> opsiJenisKelamin = [
    'Laki-laki',
    'Perempuan',
  ];

  @override
  void initState() {
    super.initState();
    final profile = dataStore.profile.value;
    selectedImageBytes = profile.avatarBytes;
    namaController = TextEditingController(text: profile.nama);
    nisnController = TextEditingController(text: profile.nisn);
    emailController = TextEditingController(text: profile.email);
    noTelponController = TextEditingController(text: profile.noTelpon);

    selectedKelas = opsiKelas.contains(profile.kelas)
        ? profile.kelas
        : 'XII RPL B';
    selectedJurusan = opsiJurusan.contains(profile.jurusan)
        ? profile.jurusan
        : 'RPL';
    selectedJenisKelamin = opsiJenisKelamin.contains(profile.jenisKelamin)
        ? profile.jenisKelamin
        : 'Perempuan';
  }

  @override
  void dispose() {
    namaController.dispose();
    nisnController.dispose();
    emailController.dispose();
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

  Future<void> _simpanProfil() async {
    String avatarUrl = dataStore.profile.value.avatarUrl;
    final currentId = AuthService.currentUser?['id_siswa']?.toString() ??
        dataStore.profile.value.nisn;
    final currentNisn = nisnController.text.trim().isNotEmpty
        ? nisnController.text.trim()
        : dataStore.profile.value.nisn;

    if (selectedImageBytes != null) {
      final uploadedUrl = await StorageService.uploadFotoProfil(
        selectedImageBytes!,
        role: 'siswa',
        userId: currentId,
        identifier: currentNisn,
      );
      if (uploadedUrl != null && uploadedUrl.isNotEmpty) {
        avatarUrl = uploadedUrl;
      }
    }

    final updated = SiswaProfile(
      nama: namaController.text.trim().isNotEmpty
          ? namaController.text.trim()
          : 'Andi Ardiansyah',
      nisn: nisnController.text.trim().isNotEmpty
          ? nisnController.text.trim()
          : '123445678',
      kelas: selectedKelas,
      jurusan: selectedJurusan,
      email: emailController.text.trim().isNotEmpty
          ? emailController.text.trim()
          : 'andi@gmail.com',
      noTelpon: noTelponController.text.trim().isNotEmpty
          ? noTelponController.text.trim()
          : '08819437942',
      jenisKelamin: selectedJenisKelamin,
      avatarUrl: avatarUrl,
      avatarBytes: selectedImageBytes,
    );

    dataStore.profile.value = updated;

    // Perbarui data di database Supabase jika ada siswa aktif
    try {
      final supabase = StorageService.supabase;
      final email = emailController.text.trim();
      final nisn = nisnController.text.trim();
      final currentId = AuthService.currentUser?['id_siswa'];

      final basePayload = <String, dynamic>{
        'nama_siswa': updated.nama,
        'nisn': updated.nisn,
        'email': updated.email,
        'kelas': updated.kelas,
        'jurusan': updated.jurusan,
        'no_telepon': updated.noTelpon,
        'jenis_kelamin': updated.jenisKelamin,
      };

      // Coba update dengan foto_profil terlebih dahulu; jika kolom foto_profil belum ada di tabel siswa,
      // otomatis fallback update data siswa tanpa foto_profil agar update profil tidak gagal (PGRST204).
      Future<void> runUpdate(Map<String, dynamic> payload) async {
        if (currentId != null) {
          await supabase.from('siswa').update(payload).eq('id_siswa', currentId);
        } else if (email.isNotEmpty || nisn.isNotEmpty) {
          await supabase
              .from('siswa')
              .update(payload)
              .or('email.eq.$email,nisn.eq.$nisn');
        }
      }

      if (avatarUrl.startsWith('http')) {
        try {
          await runUpdate({...basePayload, 'foto_profil': avatarUrl});
        } catch (_) {
          await runUpdate(basePayload);
        }
      } else {
        await runUpdate(basePayload);
      }

      if (AuthService.currentUser != null) {
        AuthService.currentUser!['nama_siswa'] = updated.nama;
        AuthService.currentUser!['nisn'] = updated.nisn;
        AuthService.currentUser!['email'] = updated.email;
        AuthService.currentUser!['kelas'] = updated.kelas;
        AuthService.currentUser!['jurusan'] = updated.jurusan;
        AuthService.currentUser!['no_telepon'] = updated.noTelpon;
        AuthService.currentUser!['jenis_kelamin'] = updated.jenisKelamin;
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
            Text('Profil siswa berhasil disimpan!'),
          ],
        ),
        backgroundColor: primaryBlue,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );

    // Setelah disimpan mengarah ke dashboard
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const DashboardSiswa()),
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
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Profil Saya',
          style: TextStyle(
            color: Color(0xFF0F172A),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          // TOMBOL "Simpan" DI HEADER
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: InkWell(
                borderRadius: BorderRadius.circular(8),
                onTap: _simpanProfil,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE2E8F0),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.bookmark_rounded,
                        color: Color(0xFF0F172A),
                        size: 16,
                      ),
                      SizedBox(width: 4),
                      Text(
                        'Simpan',
                        style: TextStyle(
                          color: Color(0xFF0F172A),
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
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
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // AVATAR DENGAN IKON PENSIL EDIT
            Center(
              child: Stack(
                children: [
                  Container(
                    width: 110,
                    height: 110,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFFE2E8F0),
                        width: 3,
                      ),
                      image: DecorationImage(
                        image: PortofolioItem.getAvatarImageProvider(
                          selectedImageBytes,
                          dataStore.profile.value.avatarUrl,
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 4,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(20),
                      onTap: _pickAvatar,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: const BoxDecoration(
                          color: Color(0xFF254BD1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.camera_alt,
                          size: 16,
                          color: Colors.white,
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

            const SizedBox(height: 18),

            // 1. NAMA LENGKAP
            _buildFieldLabel('Nama Lengkap'),
            _buildTextField(controller: namaController),

            const SizedBox(height: 16),

            // 2. NISN
            _buildFieldLabel('NISN'),
            _buildTextField(
              controller: nisnController,
              keyboardType: TextInputType.number,
            ),

            const SizedBox(height: 16),

            // 3. KELAS (DROPDOWN SESUAI REQUEST)
            _buildFieldLabel('Kelas'),
            _buildDropdownField(
              value: selectedKelas,
              items: opsiKelas,
              onChanged: (val) {
                if (val != null) {
                  setState(() => selectedKelas = val);
                }
              },
            ),

            const SizedBox(height: 16),

            // 4. JURUSAN (DROPDOWN SESUAI REQUEST)
            _buildFieldLabel('Jurusan'),
            _buildDropdownField(
              value: selectedJurusan,
              items: opsiJurusan,
              onChanged: (val) {
                if (val != null) {
                  setState(() => selectedJurusan = val);
                }
              },
            ),

            const SizedBox(height: 16),

            // 5. EMAIL
            _buildFieldLabel('Email'),
            _buildTextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
            ),

            const SizedBox(height: 16),

            // 6. NO TELPON
            _buildFieldLabel('No Telpon'),
            _buildTextField(
              controller: noTelponController,
              keyboardType: TextInputType.phone,
            ),

            const SizedBox(height: 16),

            // 7. JENIS KELAMIN (DROPDOWN SESUAI REQUEST)
            _buildFieldLabel('Jenis Kelamin'),
            _buildDropdownField(
              value: selectedJenisKelamin,
              items: opsiJenisKelamin,
              onChanged: (val) {
                if (val != null) {
                  setState(() => selectedJenisKelamin = val);
                }
              },
            ),

            const SizedBox(height: 32),
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
          fontSize: 13,
          fontWeight: FontWeight.bold,
          color: primaryBlue,
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: fieldBg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        style: const TextStyle(
          color: Color(0xFF1E293B),
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
        decoration: const InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          isDense: true,
        ),
      ),
    );
  }

  Widget _buildDropdownField({
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: fieldBg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          icon: const Icon(
            Icons.keyboard_arrow_down_rounded,
            color: Color(0xFF334155),
          ),
          style: const TextStyle(
            color: Color(0xFF1E293B),
            fontSize: 13,
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
