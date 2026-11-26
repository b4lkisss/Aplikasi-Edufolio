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
          'avatarUrl': item['foto_profil'] ?? item['avatar_url'],
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
    String? avatarUrl,
  }) async {
    try {
      final data = {
        'nama_guru': nama,
        'nip': nip,
        'email': email,
        'bidang_mengajar': bidang,
        if (password != null && password.isNotEmpty) 'password': password,
        if (avatarUrl != null) 'foto_profil': avatarUrl,
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
          'username': item['username'] ?? '',
          'avatarUrl': item['foto_profil'] ?? item['avatar_url'],
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
    String username = '',
  }) async {
    try {
      final data = {
        'nama_siswa': nama,
        'nisn': nisn,
        'email': email,
        'password': password,
        'kelas': kelas,
        'jurusan': jurusan,
        'tahun_ajaran': angkatan,
        'jenis_kelamin': jenisKelamin,
        'no_telepon': noTelepon,
      };
      if (username.isNotEmpty) {
        data['username'] = username;
      }

      Map<String, dynamic> res;
      try {
        res = await supabase.from('siswa').insert(data).select().single();
      } catch (e) {
        if (data.containsKey('username')) {
          data.remove('username');
          res = await supabase.from('siswa').insert(data).select().single();
        } else {
          rethrow;
        }
      }

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
    String? avatarUrl,
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
        if (avatarUrl != null) 'foto_profil': avatarUrl,
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

  // ==========================================
  // KATEGORI CRUD (TABEL: kategori)
  // ==========================================

  // 1. Ambil Semua Kategori beserta jumlah portofolionya
  static Future<List<Map<String, dynamic>>> getDaftarKategori() async {
    try {
      final res = await supabase
          .from('kategori')
          .select('id_kategori, nama_kategori, portofolio_siswa(id_portofolio)')
          .order('id_kategori', ascending: true);

      final List<Map<String, dynamic>> list = [];
      for (var row in (res as List)) {
        int count = 0;
        if (row['portofolio_siswa'] != null && row['portofolio_siswa'] is List) {
          count = (row['portofolio_siswa'] as List).length;
        }
        list.add({
          'id': row['id_kategori'],
          'nama': row['nama_kategori'] ?? '',
          'jumlah': '$count data',
          'count': count,
        });
      }
      return list;
    } catch (e) {
      return [];
    }
  }

  // 2. Tambah Kategori Baru
  static Future<Map<String, dynamic>> tambahKategori(String nama) async {
    try {
      final res = await supabase.from('kategori').insert({
        'nama_kategori': nama.trim(),
      }).select().single();

      return {
        'success': true,
        'data': {
          'id': res['id_kategori'],
          'nama': res['nama_kategori'],
          'jumlah': '0 data',
          'count': 0,
        }
      };
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  // 3. Update Kategori
  static Future<bool> updateKategori(dynamic id, String namaBaru) async {
    try {
      await supabase.from('kategori').update({
        'nama_kategori': namaBaru.trim(),
      }).eq('id_kategori', id);
      return true;
    } catch (e) {
      return false;
    }
  }

  // 4. Hapus Kategori
  static Future<bool> hapusKategori(dynamic id) async {
    try {
      await supabase.from('kategori').delete().eq('id_kategori', id);
      return true;
    } catch (e) {
      return false;
    }
  }

  // ==========================================
  // HELPER STATISTIK DENGAN FILTER WAKTU SUPABASE
  // ==========================================

  /// Memfilter daftar record berdasarkan periode tanggal upload/created_at
  static bool matchFilterPeriode(DateTime? date, String period) {
    if (period == 'All') return true;
    if (date == null) return false;

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final targetDate = DateTime(date.year, date.month, date.day);

    switch (period) {
      case 'Today':
        return targetDate.isAtSameMomentAs(today);
      case 'Yesterday':
        final yesterday = today.subtract(const Duration(days: 1));
        return targetDate.isAtSameMomentAs(yesterday);
      case 'This Week':
        // Awal minggu (Senin)
        final weekday = now.weekday; // 1 = Monday
        final startOfWeek = today.subtract(Duration(days: weekday - 1));
        final endOfWeek = startOfWeek.add(const Duration(days: 7));
        return !targetDate.isBefore(startOfWeek) && targetDate.isBefore(endOfWeek);
      case 'Last Week':
        final weekday = now.weekday;
        final startOfLastWeek = today.subtract(Duration(days: weekday + 6));
        final endOfLastWeek = startOfLastWeek.add(const Duration(days: 7));
        return !targetDate.isBefore(startOfLastWeek) && targetDate.isBefore(endOfLastWeek);
      case 'This Month':
        return date.year == now.year && date.month == now.month;
      case 'Last Month':
        final prevMonth = now.month == 1 ? 12 : now.month - 1;
        final prevYear = now.month == 1 ? now.year - 1 : now.year;
        return date.year == prevYear && date.month == prevMonth;
      case 'This Year':
        return date.year == now.year;
      case 'Last Year':
        return date.year == now.year - 1;
      default:
        return true;
    }
  }

  /// Helper untuk mem-parsing berbagai format tanggal string (dd/MM/yyyy atau yyyy-MM-dd)
  static DateTime? parseTanggalString(String? tglStr) {
    if (tglStr == null || tglStr.trim().isEmpty) return null;
    final clean = tglStr.trim();

    // Cek format dd/MM/yyyy
    final slashParts = clean.split('/');
    if (slashParts.length == 3) {
      final d = int.tryParse(slashParts[0]);
      final m = int.tryParse(slashParts[1]);
      final y = int.tryParse(slashParts[2]);
      if (d != null && m != null && y != null) {
        return DateTime(y, m, d);
      }
    }

    // Cek format ISO yyyy-MM-dd atau yyyy-MM-ddTHH:mm:ss
    final parsed = DateTime.tryParse(clean);
    if (parsed != null) return parsed;

    // Jika berupa tahun saja "2025"
    if (clean.length == 4 && int.tryParse(clean) != null) {
      return DateTime(int.parse(clean), 1, 1);
    }

    return null;
  }
}
