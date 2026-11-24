import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  static SupabaseClient get supabase => Supabase.instance.client;

  // Data akun yang sedang aktif login
  static Map<String, dynamic>? currentUser;
  static String? currentRole; // 'Siswa', 'Guru', 'Admin'

  // Default credentials cadangan (fallback jika offline / database belum terisi)
  static const List<Map<String, String>> mockCredentials = [
    {
      'role': 'Admin',
      'username': 'admin',
      'email': 'admin@edufolio.com',
      'password': 'admin123',
      'route': '/dashboard-admin',
    },
    {
      'role': 'Guru',
      'username': 'guru',
      'email': 'guru@edufolio.com',
      'password': 'guru123',
      'route': '/dashboard-guru',
    },
    {
      'role': 'Siswa',
      'username': 'siswa',
      'email': 'siswa@edufolio.com',
      'password': 'siswa123',
      'route': '/dashboard-siswa',
    },
  ];

  // 1. REGISTER SISWA KE SUPABASE
  static Future<Map<String, dynamic>> registerSiswa({
    required String nama,
    required String nisn,
    required String email,
    required String password,
    required String noTelepon,
    required String jenisKelamin,
    required String kelas,
    required String jurusan,
    String tahunAjaran = '2024/2025',
  }) async {
    try {
      // Cek apakah email atau NISN sudah terdaftar
      final existing = await supabase
          .from('siswa')
          .select('id_siswa, email, nisn')
          .or('email.eq.$email,nisn.eq.$nisn')
          .maybeSingle();

      if (existing != null) {
        if (existing['email'] == email) {
          return {'success': false, 'message': 'Email sudah terdaftar!'};
        }
        if (existing['nisn'] == nisn) {
          return {'success': false, 'message': 'NISN sudah terdaftar!'};
        }
      }

      // Insert ke tabel siswa
      final response = await supabase.from('siswa').insert({
        'nama_siswa': nama,
        'nisn': nisn,
        'email': email,
        'password': password,
        'no_telepon': noTelepon,
        'jenis_kelamin': jenisKelamin,
        'kelas': kelas,
        'jurusan': jurusan,
        'tahun_ajaran': tahunAjaran,
      }).select().single();

      currentUser = response;
      currentRole = 'Siswa';

      return {'success': true, 'data': response};
    } catch (e) {
      // Jika terjadi kendala koneksi Supabase, return error detail
      return {'success': false, 'message': e.toString()};
    }
  }

  // 2. LOGIN SISWA (CEK TABEL SISWA)
  static Future<Map<String, dynamic>?> loginSiswa(
    String identifier,
    String password,
  ) async {
    final id = identifier.trim();
    final pass = password.trim();

    try {
      final response = await supabase
          .from('siswa')
          .select()
          .or('email.eq.$id,nisn.eq.$id')
          .eq('password', pass)
          .maybeSingle();

      if (response != null) {
        currentUser = response;
        currentRole = 'Siswa';
        return {
          'role': 'Siswa',
          'route': '/dashboard-siswa',
          'user': response,
          'nama': response['nama_siswa'] ?? 'Siswa',
          'email': response['email'] ?? '',
        };
      }
    } catch (e) {
      // Jika ada error jaringan/tabel, cek fallback mock di bawah
    }

    // Fallback Mock Akun Siswa
    if ((id.toLowerCase() == 'siswa' || id.toLowerCase() == 'siswa@edufolio.com') &&
        pass == 'siswa123') {
      currentUser = {
        'nama_siswa': 'Balqis Demes Piscesa',
        'nisn': '0091750552',
        'email': 'siswa@edufolio.com',
        'kelas': 'XII RPL B',
        'jurusan': 'RPL',
      };
      currentRole = 'Siswa';
      return {
        'role': 'Siswa',
        'route': '/dashboard-siswa',
        'user': currentUser,
        'nama': 'Balqis Demes Piscesa',
        'email': 'siswa@edufolio.com',
      };
    }

    return null;
  }

  // 3. LOGIN GURU (CEK TABEL GURU)
  static Future<Map<String, dynamic>?> loginGuru(
    String identifier,
    String password,
  ) async {
    final id = identifier.trim();
    final pass = password.trim();

    try {
      final response = await supabase
          .from('guru')
          .select()
          .or('email.eq.$id,nip.eq.$id')
          .eq('password', pass)
          .maybeSingle();

      if (response != null) {
        currentUser = response;
        currentRole = 'Guru';
        return {
          'role': 'Guru',
          'route': '/dashboard-guru',
          'user': response,
          'nama': response['nama_guru'] ?? 'Guru',
          'email': response['email'] ?? '',
        };
      }
    } catch (e) {
      // Abaikan dan lanjut ke fallback
    }

    // Fallback Mock Akun Guru
    if ((id.toLowerCase() == 'guru' || id.toLowerCase() == 'guru@edufolio.com') &&
        pass == 'guru123') {
      currentUser = {
        'nama_guru': 'Ahmad Dahlan, S.Pd',
        'nip': '198701012015011001',
        'email': 'guru@edufolio.com',
        'bidang_mengajar': 'RPL',
      };
      currentRole = 'Guru';
      return {
        'role': 'Guru',
        'route': '/dashboard-guru',
        'user': currentUser,
        'nama': 'Ahmad Dahlan, S.Pd',
        'email': 'guru@edufolio.com',
      };
    }

    return null;
  }

  // 4. LOGIN ADMIN (CEK TABEL ADMIN)
  static Future<Map<String, dynamic>?> loginAdmin(
    String identifier,
    String password,
  ) async {
    final id = identifier.trim();
    final pass = password.trim();

    try {
      final response = await supabase
          .from('admin')
          .select()
          .or('email.eq.$id,nama_admin.eq.$id')
          .eq('password', pass)
          .maybeSingle();

      if (response != null) {
        currentUser = response;
        currentRole = 'Admin';
        return {
          'role': 'Admin',
          'route': '/dashboard-admin',
          'user': response,
          'nama': response['nama_admin'] ?? 'Admin',
          'email': response['email'] ?? '',
        };
      }
    } catch (e) {
      // Abaikan dan lanjut ke fallback
    }

    // Fallback Mock Akun Admin
    if ((id.toLowerCase() == 'admin' || id.toLowerCase() == 'admin@edufolio.com') &&
        pass == 'admin123') {
      currentUser = {
        'nama_admin': 'Administrator',
        'email': 'admin@edufolio.com',
      };
      currentRole = 'Admin';
      return {
        'role': 'Admin',
        'route': '/dashboard-admin',
        'user': currentUser,
        'nama': 'Administrator',
        'email': 'admin@edufolio.com',
      };
    }

    return null;
  }

  // 5. LOGIN UNIVERSAL (Bisa digunakan di mana saja)
  static Future<Map<String, dynamic>?> login(
    String identifier,
    String password,
  ) async {
    // Cek siswa
    final siswa = await loginSiswa(identifier, password);
    if (siswa != null) return siswa;

    // Cek guru
    final guru = await loginGuru(identifier, password);
    if (guru != null) return guru;

    // Cek admin
    final admin = await loginAdmin(identifier, password);
    if (admin != null) return admin;

    return null;
  }

  // LOGOUT
  static void logout() {
    currentUser = null;
    currentRole = null;
  }
}
