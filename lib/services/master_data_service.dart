import 'package:supabase_flutter/supabase_flutter.dart';

class MasterDataService {
  static SupabaseClient get supabase => Supabase.instance.client;

  // ==========================================
  // GURU CRUD (TABEL: guru)
  // ==========================================

  // 1. Ambil Semua Data Guru
  static Future<List<Map<String, dynamic>>> getDaftarGuru() async {
    try {
      final res = await supabase
          .from('guru')
          .select()
          .order('id_guru', ascending: false);

      final List<Map<String, dynamic>> list = [];
      for (var item in (res as List)) {
        list.add({
          'id': item['id_guru'],
          'nama': item['nama_guru'] ?? '',
          'bidang': item['bidang_mengajar'] ?? 'Umum',
          'email': item['email'] ?? '',
          'nip': item['nip'] ?? '',
          'password': item['password'] ?? '',
          'jenis_kelamin': item['jenis_kelamin'] ?? 'Laki-laki',
        });
      }
      return list;
    } catch (e) {
      return [];
    }
  }

  // 2. Tambah Guru Baru
  static Future<Map<String, dynamic>> tambahGuru({
    required String nama,
    required String nip,
    required String email,
    required String password,
    required String bidang,
    String jenisKelamin = 'Laki-laki',
  }) async {
    try {
      final res = await supabase.from('guru').insert({
        'nama_guru': nama,
        'nip': nip,
        'email': email,
        'password': password,
        'bidang_mengajar': bidang,
        'jenis_kelamin': jenisKelamin,
      }).select().single();

      return {
        'success': true,
        'data': {
          'id': res['id_guru'],
          'nama': res['nama_guru'],
          'bidang': res['bidang_mengajar'],
          'email': res['email'],
          'nip': res['nip'],
          'password': res['password'],
        }
      };
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  // 3. Update Data Guru
  static Future<bool> updateGuru({
    required dynamic id,
    required String nama,
    required String nip,
    required String email,
    required String bidang,
    String? password,
  }) async {
    try {
      final data = {
        'nama_guru': nama,
        'nip': nip,
        'email': email,
        'bidang_mengajar': bidang,
        if (password != null && password.isNotEmpty) 'password': password,
      };

      await supabase.from('guru').update(data).eq('id_guru', id);
      return true;
    } catch (e) {
      return false;
    }
  }

  // 4. Hapus Guru
  static Future<bool> hapusGuru(dynamic id) async {
    try {
      await supabase.from('guru').delete().eq('id_guru', id);
      return true;
    } catch (e) {
      return false;
    }
  }

  // ==========================================
  // SISWA CRUD (TABEL: siswa)
  // ==========================================

  // 1. Ambil Semua Data Siswa
  static Future<List<Map<String, dynamic>>> getDaftarSiswa() async {
    try {
      final res = await supabase
          .from('siswa')
          .select()
          .order('id_siswa', ascending: false);

      final List<Map<String, dynamic>> list = [];
      for (var item in (res as List)) {
        list.add({
          'id': item['id_siswa'],
          'nama': item['nama_siswa'] ?? '',
          'nisn': item['nisn'] ?? '',
          'email': item['email'] ?? '',
          'kelas': item['kelas'] ?? 'X RPL A',
          'jurusan': item['jurusan'] ?? 'RPL',
          'angkatan': item['tahun_ajaran'] ?? '2024',
          'no_telepon': item['no_telepon'] ?? '',
          'jenis_kelamin': item['jenis_kelamin'] ?? 'Laki-laki',
          'password': item['password'] ?? '',
        });
      }
      return list;
    } catch (e) {
      return [];
    }
  }

  // 2. Tambah Siswa Baru
  static Future<Map<String, dynamic>> tambahSiswa({
    required String nama,
    required String nisn,
    required String email,
    required String password,
    required String kelas,
    required String jurusan,
    String angkatan = '2024',
    String jenisKelamin = 'Laki-laki',
    String noTelepon = '-',
  }) async {
    try {
      final res = await supabase.from('siswa').insert({
        'nama_siswa': nama,
        'nisn': nisn,
        'email': email,
        'password': password,
        'kelas': kelas,
        'jurusan': jurusan,
        'tahun_ajaran': angkatan,
        'jenis_kelamin': jenisKelamin,
        'no_telepon': noTelepon,
      }).select().single();

      return {
        'success': true,
        'data': {
          'id': res['id_siswa'],
          'nama': res['nama_siswa'],
          'nisn': res['nisn'],
          'email': res['email'],
          'kelas': res['kelas'],
          'jurusan': res['jurusan'],
          'angkatan': res['tahun_ajaran'],
        }
      };
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  // 3. Update Data Siswa
  static Future<bool> updateSiswa({
    required dynamic id,
    required String nama,
    required String nisn,
    required String email,
    required String kelas,
    required String jurusan,
    String? angkatan,
    String? password,
  }) async {
    try {
      final data = {
        'nama_siswa': nama,
        'nisn': nisn,
        'email': email,
        'kelas': kelas,
        'jurusan': jurusan,
        if (angkatan != null) 'tahun_ajaran': angkatan,
        if (password != null && password.isNotEmpty) 'password': password,
      };

      await supabase.from('siswa').update(data).eq('id_siswa', id);
      return true;
    } catch (e) {
      return false;
    }
  }

  // 4. Hapus Siswa
  static Future<bool> hapusSiswa(dynamic id) async {
    try {
      await supabase.from('siswa').delete().eq('id_siswa', id);
      return true;
    } catch (e) {
      return false;
    }
  }
}
