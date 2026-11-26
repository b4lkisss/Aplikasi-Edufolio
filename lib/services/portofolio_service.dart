import 'package:supabase_flutter/supabase_flutter.dart';
import '../screens/siswa/portofolio_data.dart';
import 'auth_service.dart';

class PortofolioService {
  static SupabaseClient get supabase => Supabase.instance.client;

  // 1. DAPATKAN ATAU BUAT KATEGORI
  static Future<dynamic> getOrCreateKategoriId(String namaKategori) async {
    try {
      final existing = await supabase
          .from('kategori')
          .select('id_kategori')
          .ilike('nama_kategori', namaKategori.trim())
          .maybeSingle();

      if (existing != null) {
        return existing['id_kategori'];
      }

      // Jika belum ada, buat kategori baru
      final baru = await supabase.from('kategori').insert({
        'nama_kategori': namaKategori.trim(),
      }).select('id_kategori').single();

      return baru['id_kategori'];
    } catch (e) {
      return 1; // Fallback default id 1
    }
  }

  // 2. DAPATKAN ID SISWA AKTIF
  static Future<dynamic> getActiveSiswaId() async {
    if (AuthService.currentUser != null &&
        AuthService.currentUser!['id_siswa'] != null) {
      return AuthService.currentUser!['id_siswa'];
    }

    try {
      // Ambil siswa pertama yang ada di database jika belum login
      final firstSiswa = await supabase
          .from('siswa')
          .select('id_siswa')
          .limit(1)
          .maybeSingle();

      if (firstSiswa != null) {
        return firstSiswa['id_siswa'];
      }
    } catch (e) {
      // Abaikan
    }
    return 1;
  }

  // 3. TAMBAH PORTOFOLIO KE SUPABASE (Tabel portofolio_siswa & verifikasi)
  static Future<Map<String, dynamic>> tambahPortofolio({
    required String judul,
    required String kategori,
    required String deskripsi,
    required String link,
    String? tingkat,
    String? peran,
    List<String>? skills,
    String? tanggal,
  }) async {
    try {
      final idSiswa = await getActiveSiswaId();
      final idKategori = await getOrCreateKategoriId(kategori);

      final tglFormatted = tanggal ??
          DateTime.now().toIso8601String().substring(0, 10);

      // A. Insert ke tabel portofolio_siswa
      final portoResponse = await supabase.from('portofolio_siswa').insert({
        'id_siswa': idSiswa,
        'id_kategori': idKategori,
        'judul_portofolio': judul,
        'deskripsi': deskripsi,
        'tanggal_portofolio': tglFormatted,
        'link_pendukung': link,
        'file_pendukung': link,
      }).select().single();

      final idPortofolio = portoResponse['id_portofolio'];

      // B. Otomatis buat entri verifikasi dengan status 'Menunggu'
      try {
        await supabase.from('verifikasi').insert({
          'id_portofolio': idPortofolio,
          'status_verifikasi': 'Menunggu',
          'tanggal_verifikasi': tglFormatted,
        });
      } catch (e) {
        // Jika tabel verifikasi butuh kolom tertentu atau id_guru opsional
      }

      return {'success': true, 'data': portoResponse};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  // 4. AMBIL SEMUA PORTOFOLIO DARI SUPABASE
  static Future<List<PortofolioItem>> fetchAllPortofolio() async {
    try {
      final res = await supabase.from('portofolio_siswa').select('''
        id_portofolio,
        judul_portofolio,
        deskripsi,
        tanggal_portofolio,
        link_pendukung,
        file_pendukung,
        siswa:id_siswa (id_siswa, nama_siswa, kelas),
        kategori:id_kategori (id_kategori, nama_kategori),
        verifikasi (id_verifikasi, status_verifikasi, catatan),
        penilaian (id_penilaian, nilai, catatan)
      ''').order('id_portofolio', ascending: false);

      final List<PortofolioItem> items = [];

      for (var row in (res as List)) {
        final id = row['id_portofolio'].toString();
        final judul = row['judul_portofolio'] ?? 'Karya Siswa';
        final deskripsi = row['deskripsi'] ?? '';
        final tgl = row['tanggal_portofolio']?.toString() ?? '2025';
        final link = row['link_pendukung'] ?? '';

        // Kategori
        String namaKategori = 'Projek';
        if (row['kategori'] != null && row['kategori']['nama_kategori'] != null) {
          namaKategori = row['kategori']['nama_kategori'];
        }

        // Siswa
        String namaSiswa = 'Siswa Edufolio';
        String kelas = 'XII RPL B';
        String? idSiswaStr;
        if (row['siswa'] != null) {
          namaSiswa = row['siswa']['nama_siswa'] ?? namaSiswa;
          kelas = row['siswa']['kelas'] ?? kelas;
          idSiswaStr = row['siswa']['id_siswa']?.toString();
        } else if (row['id_siswa'] != null) {
          idSiswaStr = row['id_siswa'].toString();
        }

        // Status Verifikasi
        String status = 'Menunggu';
        String? catatanVerifikasi;
        if (row['verifikasi'] != null && (row['verifikasi'] as List).isNotEmpty) {
          final verif = (row['verifikasi'] as List).first;
          status = verif['status_verifikasi'] ?? 'Menunggu';
          catatanVerifikasi = verif['catatan'];
        }

        // Penilaian
        int? nilai;
        String? catatanNilai;
        if (row['penilaian'] != null && (row['penilaian'] as List).isNotEmpty) {
          final pen = (row['penilaian'] as List).first;
          if (pen['nilai'] != null) {
            nilai = int.tryParse(pen['nilai'].toString());
          }
          catatanNilai = pen['catatan'];
        }

        String img = (link.isNotEmpty && (link.startsWith('http://') || link.startsWith('https://')))
            ? link
            : (row['file_pendukung'] != null && row['file_pendukung'].toString().startsWith('http')
                ? row['file_pendukung'].toString()
                : 'https://images.unsplash.com/photo-1589829545856-d10d557cf95f?auto=format&fit=crop&w=600&q=80');

        items.add(PortofolioItem(
          id: id,
          judul: judul,
          kategori: namaKategori,
          deskripsi: deskripsi,
          tanggal: tgl,
          peran: 'Kontributor Utama',
          skills: ['Flutter', 'Desain', 'Kreativitas'],
          link: link,
          status: status,
          namaSiswa: namaSiswa,
          kelas: kelas,
          catatan: catatanNilai ?? catatanVerifikasi,
          kreativitas: nilai != null ? (nilai / 20).round().clamp(1, 5) : null,
          kualitas: nilai != null ? (nilai / 20).round().clamp(1, 5) : null,
          relevansi: nilai != null ? (nilai / 20).round().clamp(1, 5) : null,
          dokumentasi: nilai != null ? (nilai / 20).round().clamp(1, 5) : null,
          imageUrl: img,
          tanggalUnggah: tgl,
          idSiswa: idSiswaStr,
        ));
      }

      return items;
    } catch (e) {
      return [];
    }
  }

  // 5. UPDATE STATUS VERIFIKASI (ROLE GURU)
  static Future<bool> updateStatusVerifikasi({
    required dynamic idPortofolio,
    required String newStatus, // 'Disetujui' atau 'Ditolak'
    String? catatan,
  }) async {
    try {
      final tgl = DateTime.now().toIso8601String().substring(0, 10);
      final idGuru = AuthService.currentUser != null
          ? AuthService.currentUser!['id_guru']
          : null;

      // Cek apakah sudah ada entri verifikasi
      final existing = await supabase
          .from('verifikasi')
          .select('id_verifikasi')
          .eq('id_portofolio', idPortofolio)
          .maybeSingle();

      if (existing != null) {
        await supabase.from('verifikasi').update({
          'status_verifikasi': newStatus,
          'catatan': catatan,
          'tanggal_verifikasi': tgl,
          if (idGuru != null) 'id_guru': idGuru,
        }).eq('id_portofolio', idPortofolio);
      } else {
        await supabase.from('verifikasi').insert({
          'id_portofolio': idPortofolio,
          'status_verifikasi': newStatus,
          'catatan': catatan,
          'tanggal_verifikasi': tgl,
          if (idGuru != null) 'id_guru': idGuru,
        });
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  // 6. SIMPAN PENILAIAN (ROLE GURU)
  static Future<bool> simpanPenilaian({
    required dynamic idPortofolio,
    required int nilai, // 0 - 100
    String? catatan,
  }) async {
    try {
      final tgl = DateTime.now().toIso8601String().substring(0, 10);
      final idGuru = AuthService.currentUser != null
          ? AuthService.currentUser!['id_guru']
          : null;

      final existing = await supabase
          .from('penilaian')
          .select('id_penilaian')
          .eq('id_portofolio', idPortofolio)
          .maybeSingle();

      if (existing != null) {
        await supabase.from('penilaian').update({
          'nilai': nilai,
          'catatan': catatan,
          'tanggal_penilaian': tgl,
          if (idGuru != null) 'id_guru': idGuru,
        }).eq('id_portofolio', idPortofolio);
      } else {
        await supabase.from('penilaian').insert({
          'id_portofolio': idPortofolio,
          'nilai': nilai,
          'catatan': catatan,
          'tanggal_penilaian': tgl,
          if (idGuru != null) 'id_guru': idGuru,
        });
      }
      return true;
    } catch (e) {
      return false;
    }
  }
}
