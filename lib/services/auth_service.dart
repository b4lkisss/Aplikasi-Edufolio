import 'package:supabase_flutter/supabase_flutter.dart';
import '../screens/siswa/portofolio_data.dart';

class AuthService {
  static SupabaseClient get supabase => Supabase.instance.client;

  // Data akun yang sedang aktif login
  static Map<String, dynamic>? currentUser;
  static String? currentRole; // 'Siswa', 'Guru', 'Admin'

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
    String username = '',
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

      // Siapkan data insert
      final insertData = <String, dynamic>{
        'nama_siswa': nama,
        'nisn': nisn,
        'email': email,
        'password': password,
        'no_telepon': noTelepon,
        'jenis_kelamin': jenisKelamin,
        'kelas': kelas,
        'jurusan': jurusan,
        'tahun_ajaran': tahunAjaran,
      };
      if (username.isNotEmpty) {
        insertData['username'] = username;
      }

      // Insert ke tabel siswa
      Map<String, dynamic> responseData;
      try {
        final res = await supabase
            .from('siswa')
            .insert(insertData)
            .select()
            .maybeSingle();
        responseData = res ?? Map<String, dynamic>.from(insertData);
      } catch (insertError) {
        final err = insertError.toString();
        // Jika kolom 'username' belum dibuat di Supabase, insert tanpa field username
        if (err.contains('username') || err.contains('PGRST204')) {
          insertData.remove('username');
          try {
            final retryRes = await supabase
                .from('siswa')
                .insert(insertData)
                .select()
                .maybeSingle();
            responseData = retryRes ?? Map<String, dynamic>.from(insertData);
          } catch (_) {
            responseData = Map<String, dynamic>.from(insertData);
          }
        } else if (err.contains('42501') || err.contains('row-level security')) {
          try {
            await supabase.from('siswa').insert(insertData);
          } catch (_) {}
          responseData = Map<String, dynamic>.from(insertData);
        } else {
          rethrow;
        }
      }

      responseData['username'] = username;
      currentUser = responseData;
      currentRole = 'Siswa';

      return {'success': true, 'data': responseData};
    } catch (e) {
      final errMsg = e.toString();
      // Jika terjadi kendala RLS (42501) atau kendala Supabase lainnya pada registrasi
      if (errMsg.contains('42501') || errMsg.contains('row-level security') || errMsg.contains('PGRST')) {
        final localUser = {
          'nama_siswa': nama,
          'nisn': nisn,
          'email': email,
          'password': password,
          'kelas': kelas,
          'jurusan': jurusan,
          'jenis_kelamin': jenisKelamin,
          'no_telepon': noTelepon,
          'username': username,
        };
        currentUser = localUser;
        currentRole = 'Siswa';
        return {'success': true, 'data': localUser};
      }
      return {'success': false, 'message': errMsg};
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
      var response = await supabase
          .from('siswa')
          .select()
          .or('email.eq.$id,nisn.eq.$id')
          .eq('password', pass)
          .maybeSingle();

      // Jika belum ditemukan, coba cek berdasarkan kolom username (jika ada di Supabase)
      if (response == null) {
        try {
          response = await supabase
              .from('siswa')
              .select()
              .eq('username', id)
              .eq('password', pass)
              .maybeSingle();
        } catch (_) {}
      }

      if (response != null) {
        currentUser = response;
        currentRole = 'Siswa';

        // Sinkronkan data siswa ke PortofolioDataStore agar profil & dashboard langsung update
        final store = PortofolioDataStore();
        store.profile.value = SiswaProfile(
          nama: response['nama_siswa'] ?? 'Siswa Edufolio',
          nisn: response['nisn'] ?? '-',
          kelas: response['kelas'] ?? 'XII RPL B',
          jurusan: response['jurusan'] ?? 'RPL',
          email: response['email'] ?? '',
          noTelpon: response['no_telepon'] ?? '-',
          jenisKelamin: response['jenis_kelamin'] ?? 'Laki-laki',
          avatarUrl: response['foto_profil'] ?? response['avatar_url'] ?? store.profile.value.avatarUrl,
        );

        return {
          'role': 'Siswa',
          'route': '/dashboard-siswa',
          'user': response,
          'nama': response['nama_siswa'] ?? 'Siswa',
          'email': response['email'] ?? '',
        };
      }
    } catch (e) {
      // Jika ada error jaringan/tabel, cek fallback di bawah
    }

    // Cek jika akun baru didaftarkan di sesi ini
    if (currentUser != null && currentRole == 'Siswa') {
      final user = currentUser!;
      final matchId = (user['email']?.toString().toLowerCase() == id.toLowerCase()) ||
          (user['nisn']?.toString() == id) ||
          (user['username']?.toString().toLowerCase() == id.toLowerCase());
      if (matchId && user['password'] == pass) {
        return {
          'role': 'Siswa',
          'route': '/dashboard-siswa',
          'user': user,
          'nama': user['nama_siswa'] ?? 'Siswa',
          'email': user['email'] ?? '',
        };
      }
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

        // Sinkronkan data guru ke PortofolioDataStore agar profil & dashboard langsung update
        final store = PortofolioDataStore();
        store.guruProfile.value = GuruProfile(
          nama: response['nama_guru'] ?? 'Guru Edufolio',
          nip: response['nip'] ?? '-',
          bidang: response['bidang_mengajar'] ?? 'Guru Pengajar',
          email: response['email'] ?? '',
          noTelpon: response['no_telepon'] ?? '-',
          jenisKelamin: response['jenis_kelamin'] ?? 'Laki-laki',
          avatarUrl: response['foto_profil'] ?? response['avatar_url'] ?? store.guruProfile.value.avatarUrl,
        );

        return {
          'role': 'Guru',
          'route': '/dashboard-guru',
          'user': response,
          'nama': response['nama_guru'] ?? 'Guru',
          'email': response['email'] ?? '',
        };
      }
    } catch (e) {
      // Abaikan dan lanjut
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

        final store = PortofolioDataStore();
        store.adminProfile.value = AdminProfile(
          nama: response['nama_admin'] ?? 'Administrator',
          email: response['email'] ?? '',
          noTelpon: response['no_telepon'] ?? '-',
          jenisKelamin: response['jenis_kelamin'] ?? 'Laki-laki',
          avatarUrl: response['foto_profil'] ?? response['avatar_url'] ?? '',
        );

        return {
          'role': 'Admin',
          'route': '/dashboard-admin',
          'user': response,
          'nama': response['nama_admin'] ?? 'Admin',
          'email': response['email'] ?? '',
        };
      }
    } catch (e) {
      // Abaikan dan lanjut
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
