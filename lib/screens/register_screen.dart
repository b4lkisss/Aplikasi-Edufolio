import 'package:flutter/material.dart';
import 'siswa/portofolio_data.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final Color primaryColor = const Color(0xFF356DA8);

  final _formKey = GlobalKey<FormState>();

  // Controllers
  final TextEditingController namaController = TextEditingController();
  final TextEditingController nisnController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController noTelponController = TextEditingController();
  final TextEditingController alamatController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  // Dropdowns Siswa
  String selectedKelas = 'X RPL A';
  String selectedJurusan = 'RPL';
  String selectedJenisKelamin = 'Laki-laki';

  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;

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
  void dispose() {
    namaController.dispose();
    nisnController.dispose();
    emailController.dispose();
    noTelponController.dispose();
    alamatController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleRegister() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (passwordController.text != confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password dan Konfirmasi Password tidak cocok!'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Simpan data profil siswa baru ke data store
    final dataStore = PortofolioDataStore();
    dataStore.profile.value = SiswaProfile(
      nama: namaController.text.trim(),
      nisn: nisnController.text.trim(),
      kelas: selectedKelas,
      jurusan: selectedJurusan,
      email: emailController.text.trim(),
      noTelpon: noTelponController.text.trim(),
      jenisKelamin: selectedJenisKelamin,
    );

    // Tampilkan notifikasi selamat datang
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Pendaftaran berhasil! Selamat datang di Edufolio, ${namaController.text.trim()}',
        ),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 3),
      ),
    );

    // Langsung auto-login ke Dashboard Siswa (hapus history navigasi login/register)
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/dashboard-siswa',
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: primaryColor, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Daftar Akun Siswa',
          style: TextStyle(
            color: primaryColor,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // SUBTITLE INTRO
                Center(
                  child: Text(
                    'Lengkapi data diri Anda untuk mulai\nmembuat dan mengelola portofolio digital.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12.5,
                      color: Colors.grey.shade600,
                      height: 1.4,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // NAMA LENGKAP
                _buildTextField(
                  label: 'Nama Lengkap',
                  hint: 'Masukkan nama lengkap',
                  controller: namaController,
                  icon: Icons.person_outline,
                  validator: (v) => v == null || v.trim().isEmpty ? 'Nama lengkap wajib diisi' : null,
                ),

                const SizedBox(height: 14),

                // NISN
                _buildTextField(
                  label: 'NISN (Nomor Induk Siswa Nasional)',
                  hint: 'Contoh: 1234567890',
                  controller: nisnController,
                  icon: Icons.badge_outlined,
                  keyboardType: TextInputType.number,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return 'NISN wajib diisi';
                    if (!RegExp(r'^\d+$').hasMatch(v.trim())) return 'NISN harus berupa angka';
                    return null;
                  },
                ),

                const SizedBox(height: 14),

                // EMAIL
                _buildTextField(
                  label: 'Email',
                  hint: 'contoh@edufolio.com',
                  controller: emailController,
                  icon: Icons.mail_outline,
                  keyboardType: TextInputType.emailAddress,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return 'Email wajib diisi';
                    if (!v.contains('@')) return 'Format email tidak valid';
                    return null;
                  },
                ),

                const SizedBox(height: 14),

                // KELAS & JURUSAN
                Row(
                  children: [
                    // JURUSAN
                    Expanded(
                      child: _buildDropdownField(
                        label: 'Jurusan',
                        value: selectedJurusan,
                        items: opsiJurusan,
                        onChanged: (val) {
                          if (val != null) setState(() => selectedJurusan = val);
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    // KELAS
                    Expanded(
                      child: _buildDropdownField(
                        label: 'Kelas',
                        value: selectedKelas,
                        items: opsiKelas,
                        onChanged: (val) {
                          if (val != null) setState(() => selectedKelas = val);
                        },
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                // JENIS KELAMIN
                _buildDropdownField(
                  label: 'Jenis Kelamin',
                  value: selectedJenisKelamin,
                  items: opsiJenisKelamin,
                  onChanged: (val) {
                    if (val != null) setState(() => selectedJenisKelamin = val);
                  },
                ),

                const SizedBox(height: 14),

                // NO TELEPON / WHATSAPP
                _buildTextField(
                  label: 'No. Handphone / WhatsApp',
                  hint: 'Contoh: 081234567890',
                  controller: noTelponController,
                  icon: Icons.phone_outlined,
                  keyboardType: TextInputType.phone,
                  validator: (v) => v == null || v.trim().isEmpty ? 'No. Handphone wajib diisi' : null,
                ),

                const SizedBox(height: 14),

                // ALAMAT
                _buildTextField(
                  label: 'Alamat Tempat Tinggal',
                  hint: 'Masukkan alamat lengkap domisili',
                  controller: alamatController,
                  icon: Icons.home_outlined,
                  maxLines: 2,
                  validator: (v) => v == null || v.trim().isEmpty ? 'Alamat wajib diisi' : null,
                ),

                const SizedBox(height: 14),

                // PASSWORD
                _buildTextField(
                  label: 'Password',
                  hint: 'Minimal 6 karakter',
                  controller: passwordController,
                  icon: Icons.lock_outline,
                  obscureText: !isPasswordVisible,
                  suffixIcon: IconButton(
                    icon: Icon(
                      isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                      color: Colors.grey,
                      size: 20,
                    ),
                    onPressed: () {
                      setState(() {
                        isPasswordVisible = !isPasswordVisible;
                      });
                    },
                  ),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return 'Password wajib diisi';
                    if (v.length < 6) return 'Password minimal 6 karakter';
                    return null;
                  },
                ),

                const SizedBox(height: 14),

                // KONFIRMASI PASSWORD
                _buildTextField(
                  label: 'Konfirmasi Password',
                  hint: 'Ulangi password',
                  controller: confirmPasswordController,
                  icon: Icons.lock_outline,
                  obscureText: !isConfirmPasswordVisible,
                  suffixIcon: IconButton(
                    icon: Icon(
                      isConfirmPasswordVisible ? Icons.visibility : Icons.visibility_off,
                      color: Colors.grey,
                      size: 20,
                    ),
                    onPressed: () {
                      setState(() {
                        isConfirmPasswordVisible = !isConfirmPasswordVisible;
                      });
                    },
                  ),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return 'Konfirmasi password wajib diisi';
                    if (v != passwordController.text) return 'Password tidak cocok';
                    return null;
                  },
                ),

                const SizedBox(height: 24),

                // TOMBOL DAFTAR SEKARANG
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: _handleRegister,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Daftar Sekarang',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // SUDAH PUNYA AKUN? MASUK
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Sudah punya akun? ',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.black54,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Masuk',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // WIDGET TEXT FIELD STANDAR
  Widget _buildTextField({
    required String label,
    required String hint,
    required TextEditingController controller,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
    Widget? suffixIcon,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12.5,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1E293B),
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          obscureText: obscureText,
          maxLines: maxLines,
          validator: validator,
          style: const TextStyle(fontSize: 13),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              fontSize: 12.5,
              color: Colors.grey.shade400,
            ),
            prefixIcon: Icon(icon, color: primaryColor, size: 20),
            suffixIcon: suffixIcon,
            filled: true,
            fillColor: const Color(0xFFF8FAFC),
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: primaryColor, width: 2),
            ),
          ),
        ),
      ],
    );
  }

  // WIDGET DROPDOWN FIELD
  Widget _buildDropdownField({
    required String label,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12.5,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1E293B),
          ),
        ),
        const SizedBox(height: 6),
        Container(
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFCBD5E1)),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              dropdownColor: Colors.white,
              icon: Icon(Icons.keyboard_arrow_down, color: primaryColor),
              items: items.map((item) {
                return DropdownMenuItem(
                  value: item,
                  child: Text(
                    item,
                    style: const TextStyle(fontSize: 13, color: Color(0xFF1E293B)),
                  ),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }
}
