import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import 'portofolio_data.dart';

class LoginSiswa extends StatefulWidget {
  const LoginSiswa({super.key});

  @override
  State<LoginSiswa> createState() => _LoginSiswaState();
}

class _LoginSiswaState extends State<LoginSiswa> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool isPasswordVisible = false;
  bool isLoading = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    final identifier = emailController.text.trim();
    final password = passwordController.text.trim();

    if (identifier.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Silakan masukkan Email / NISN dan Password!'),
          backgroundColor: Colors.orange,
          duration: Duration(seconds: 3),
        ),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    final account = await AuthService.login(identifier, password);

    if (!mounted) return;
    setState(() {
      isLoading = false;
    });

    if (account != null) {
      final role = account['role'] as String? ?? 'Siswa';
      final route = account['route'] as String? ?? '/dashboard-siswa';
      final user = account['user'] as Map<String, dynamic>?;

      final dataStore = PortofolioDataStore();
      if (role == 'Siswa') {
        if (user != null) {
          dataStore.profile.value = SiswaProfile(
            nama: user['nama_siswa'] ?? 'Siswa',
            nisn: user['nisn'] ?? '',
            kelas: user['kelas'] ?? 'XII RPL B',
            jurusan: user['jurusan'] ?? 'RPL',
            email: user['email'] ?? '',
            noTelpon: user['no_telepon'] ?? '',
            jenisKelamin: user['jenis_kelamin'] ?? 'Laki-laki',
          );
        }
      } else if (role == 'Guru') {
        if (user != null) {
          dataStore.guruProfile.value = GuruProfile(
            nama: user['nama_guru'] ?? 'Ahmad Dahlan, S.Pd',
            nip: user['nip'] ?? '',
            email: user['email'] ?? '',
            bidang: user['bidang_mengajar'] ?? 'RPL',
          );
        }
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Login berhasil! Selamat datang, ${account['nama']} ($role)'),
          backgroundColor: const Color(0xFF16A34A),
          duration: const Duration(seconds: 2),
        ),
      );

      Navigator.pushReplacementNamed(context, route);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Email / NISN atau Password salah! Periksa kembali akun Anda.'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: 30,
              vertical: 20,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo EduFolio
                Image.asset(
                  'assets/images/logo.png',
                  width: 130,
                  height: 130,
                  fit: BoxFit.contain,
                ),

                const SizedBox(height: 10),

                // Nama Aplikasi
                const Text(
                  'Edufolio',
                  style: TextStyle(
                    fontSize: 24,
                    color: Color(0xFF79B5D0),
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 15),

                // Slogan
                const Text(
                  'Tunjukkan Potensi Terbaikmu\n'
                  'Dengan Portofolio Digital',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF79B5D0),
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 30),

                // Email / Username
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    hintText: 'Email / Username',
                    prefixIcon: const Icon(
                      Icons.email,
                      color: Colors.grey,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: const BorderSide(
                        color: Color(0xFF356DA8),
                        width: 2,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: const BorderSide(
                        color: Color(0xFF356DA8),
                        width: 2,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // Password
                TextField(
                  controller: passwordController,
                  obscureText: !isPasswordVisible,
                  decoration: InputDecoration(
                    hintText: 'Password',
                    prefixIcon: const Icon(
                      Icons.lock,
                      color: Colors.grey,
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        isPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          isPasswordVisible = !isPasswordVisible;
                        });
                      },
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: const BorderSide(
                        color: Color(0xFF356DA8),
                        width: 2,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: const BorderSide(
                        color: Color(0xFF356DA8),
                        width: 2,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 18),

                // Tombol Login
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: isLoading ? null : _handleLogin,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF356DA8),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: isLoading
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2.5,
                            ),
                          )
                        : const Text(
                            'Login',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                            ),
                          ),
                  ),
                ),

                const SizedBox(height: 18),

                // BELUM PUNYA AKUN? DAFTAR
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Belum punya akun? ',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.black54,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/register');
                      },
                      child: const Text(
                        'Daftar',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF356DA8),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
