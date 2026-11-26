import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import '../siswa/portofolio_data.dart';

class LoginAdmin extends StatefulWidget {
  const LoginAdmin({super.key});

  @override
  State<LoginAdmin> createState() => _LoginAdminState();
}

class _LoginAdminState extends State<LoginAdmin> {
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
    final id = emailController.text.trim();
    final pwd = passwordController.text.trim();

    if (id.isEmpty || pwd.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Silakan masukkan Email / Username dan Password!'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    final account = await AuthService.login(id, pwd);

    if (!mounted) return;
    setState(() {
      isLoading = false;
    });

    if (account != null) {
      final role = account['role'] as String? ?? 'Admin';
      final route = account['route'] as String? ?? '/dashboard-admin';
      final user = account['user'] as Map<String, dynamic>?;

      // Sinkronisasi profil berdasarkan role pengguna
      final dataStore = PortofolioDataStore();
      if (role == 'Siswa') {
        if (user != null) {
          final loadedAvatar = dataStore.profile.value.avatarUrl;
          final rawFoto = (user['foto_profil'] ?? user['avatar_url'])?.toString().trim();
          final effectiveAvatar = (loadedAvatar.isNotEmpty && loadedAvatar.startsWith('http'))
              ? loadedAvatar
              : ((rawFoto != null && rawFoto.isNotEmpty) ? rawFoto : PortofolioDataStore.defaultAvatar);
          dataStore.profile.value = SiswaProfile(
            nama: user['nama_siswa'] ?? 'Siswa',
            nisn: user['nisn'] ?? '',
            kelas: user['kelas'] ?? 'XII RPL B',
            jurusan: user['jurusan'] ?? 'RPL',
            email: user['email'] ?? '',
            noTelpon: user['no_telepon'] ?? '',
            jenisKelamin: user['jenis_kelamin'] ?? 'Laki-laki',
            avatarUrl: effectiveAvatar,
            avatarBytes: null,
          );
        }
      } else if (role == 'Guru') {
        if (user != null) {
          final loadedAvatar = dataStore.guruProfile.value.avatarUrl;
          final rawFoto = (user['foto_profil'] ?? user['avatar_url'])?.toString().trim();
          final effectiveAvatar = (loadedAvatar.isNotEmpty && loadedAvatar.startsWith('http'))
              ? loadedAvatar
              : ((rawFoto != null && rawFoto.isNotEmpty) ? rawFoto : PortofolioDataStore.defaultAvatar);
          dataStore.guruProfile.value = GuruProfile(
            nama: user['nama_guru'] ?? 'Guru',
            nip: user['nip'] ?? '',
            email: user['email'] ?? '',
            bidang: user['bidang_mengajar'] ?? 'Guru Pengajar',
            avatarUrl: effectiveAvatar,
            avatarBytes: null,
          );
        }
      } else if (role == 'Admin') {
        if (user != null) {
          final loadedAvatar = dataStore.adminProfile.value.avatarUrl;
          final rawFoto = (user['foto_profil'] ?? user['avatar_url'])?.toString().trim();
          final effectiveAvatar = (loadedAvatar.isNotEmpty && loadedAvatar.startsWith('http'))
              ? loadedAvatar
              : ((rawFoto != null && rawFoto.isNotEmpty) ? rawFoto : PortofolioDataStore.defaultAvatar);
          dataStore.adminProfile.value = AdminProfile(
            nama: user['nama_admin'] ?? 'Administrator',
            email: user['email'] ?? 'admin@edufolio.com',
            avatarUrl: effectiveAvatar,
            avatarBytes: null,
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
          content: Text('Email / Username atau Password salah!'),
          backgroundColor: Colors.red,
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

                const SizedBox(height: 15),

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

                const SizedBox(height: 35),

                // Email
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    hintText: 'Email / Username',
                    prefixIcon: const Icon(
                      Icons.email,
                      color: Colors.grey,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: const BorderSide(
                        color: Color(0xFF356DA8),
                        width: 2,
                      ),
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
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
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