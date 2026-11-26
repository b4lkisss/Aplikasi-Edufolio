import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../../services/portofolio_service.dart';

class PortofolioItem {
  static const String defaultAvatar = 'assets/images/default_avatar.png';

  static ImageProvider getAvatarImageProvider(Uint8List? bytes, String? url) {
    if (bytes != null && bytes.isNotEmpty) {
      return MemoryImage(bytes);
    }
    if (url != null && url.trim().isNotEmpty && url.startsWith('http')) {
      return NetworkImage(url.trim());
    }
    return const AssetImage(defaultAvatar);
  }

  final String id;
  final String judul;
  final String kategori; // Prestasi & Lomba, Sertifikat, Projek, Organisasi
  final String tingkat; // Sekolah, Kecamatan / Kota, Provinsi, Nasional, Internasional
  final String tanggal;
  final String deskripsi;
  final String peran;
  final List<String> skills;
  final String link;
  String status; // Disetujui, Menunggu, Ditolak
  final String? imageUrl;
  final Uint8List? imageBytes;
  final String tanggalUnggah;
  final String namaSiswa;
  final String kelas;
  final String avatarUrl;
  String? catatan;
  int? kreativitas;
  int? kualitas;
  int? relevansi;
  int? dokumentasi;

  final String? idSiswa;

  PortofolioItem({
    required this.id,
    required this.judul,
    required this.kategori,
    this.tingkat = 'Provinsi',
    required this.tanggal,
    required this.deskripsi,
    required this.peran,
    required this.skills,
    required this.link,
    this.status = 'Disetujui',
    this.imageUrl,
    this.imageBytes,
    this.tanggalUnggah = '12 Apr 2025',
    this.namaSiswa = 'Siswa',
    this.kelas = 'XII RPL B',
    this.avatarUrl = defaultAvatar,
    this.catatan,
    this.kreativitas,
    this.kualitas,
    this.relevansi,
    this.dokumentasi,
    this.idSiswa,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'judul': judul,
      'kategori': kategori,
      'tingkat': tingkat,
      'tanggal': tanggal,
      'deskripsi': deskripsi,
      'peran': peran,
      'skills': skills,
      'link': link,
      'status': status,
      'imageUrl': imageUrl,
      'thumbnail': imageUrl,
      'tanggalUnggah': tanggalUnggah,
      'waktu': tanggalUnggah,
      'nama_siswa': namaSiswa,
      'kelas': kelas,
      'avatar': avatarUrl,
      'catatan': catatan,
      'kreativitas': kreativitas,
      'kualitas': kualitas,
      'relevansi': relevansi,
      'dokumentasi': dokumentasi,
      'id_siswa': idSiswa,
      'nilai': (kreativitas != null &&
              kualitas != null &&
              relevansi != null &&
              dokumentasi != null)
          ? ((kreativitas! + kualitas! + relevansi! + dokumentasi!) * 5)
          : null,
    };
  }
}

class SiswaProfile {
  String nama;
  String nisn;
  String kelas;
  String jurusan;
  String email;
  String noTelpon;
  String jenisKelamin;
  String avatarUrl;
  Uint8List? avatarBytes;

  SiswaProfile({
    this.nama = 'Siswa',
    this.nisn = '-',
    this.kelas = 'XII RPL B',
    this.jurusan = 'RPL',
    this.email = '',
    this.noTelpon = '-',
    this.jenisKelamin = 'Laki-laki',
    this.avatarUrl = 'assets/images/default_avatar.png',
    this.avatarBytes,
  });
}

class GuruProfile {
  String nama;
  String nip;
  String bidang;
  String email;
  String tglLahir;
  String noTelpon;
  String jenisKelamin;
  String avatarUrl;
  Uint8List? avatarBytes;

  GuruProfile({
    this.nama = 'Guru',
    this.nip = '-',
    this.bidang = 'Guru Pengajar',
    this.email = '',
    this.tglLahir = '-',
    this.noTelpon = '-',
    this.jenisKelamin = 'Laki-laki',
    this.avatarUrl = 'assets/images/default_avatar.png',
    this.avatarBytes,
  });
}

class AdminProfile {
  String nama;
  String email;
  String noTelpon;
  String jenisKelamin;
  String tglLahir;
  String avatarUrl;
  Uint8List? avatarBytes;

  AdminProfile({
    this.nama = 'Administrator',
    this.email = 'admin@edufolio.com',
    this.noTelpon = '-',
    this.jenisKelamin = 'Laki-laki',
    this.tglLahir = '-',
    this.avatarUrl = 'assets/images/default_avatar.png',
    this.avatarBytes,
  });
}

class AppNotification {
  final String id;
  final String title;
  final String message;
  final String time;
  bool isRead;
  final String role; // 'all', 'siswa', 'guru', 'admin'
  final IconData icon;
  final Color iconColor;

  String get roleTarget => role;

  AppNotification({
    required this.id,
    required this.title,
    required this.message,
    required this.time,
    this.isRead = false,
    this.role = 'all',
    this.icon = Icons.notifications_rounded,
    this.iconColor = const Color(0xFF254BD1),
  });
}

class PortofolioDataStore {
  static const String defaultAvatar = PortofolioItem.defaultAvatar;
  static final PortofolioDataStore _instance = PortofolioDataStore._internal();
  factory PortofolioDataStore() => _instance;
  PortofolioDataStore._internal();

  final ValueNotifier<List<PortofolioItem>> portofolioList =
      ValueNotifier<List<PortofolioItem>>([]);

  final ValueNotifier<SiswaProfile> profile =
      ValueNotifier<SiswaProfile>(SiswaProfile());

  final ValueNotifier<GuruProfile> guruProfile =
      ValueNotifier<GuruProfile>(GuruProfile());

  final ValueNotifier<AdminProfile> adminProfile =
      ValueNotifier<AdminProfile>(AdminProfile());

  // NOTIFIKASI TERSINKRONISASI
  final ValueNotifier<List<AppNotification>> notifications =
      ValueNotifier<List<AppNotification>>([
    AppNotification(
      id: '1',
      title: 'Pengajuan Baru Masuk',
      message: 'Balqis Demes Piscesa mengajukan "Project Aplikasi E-Commerce Mobile".',
      time: '2 Jam yang lalu',
      role: 'guru',
      icon: Icons.upload_file_rounded,
      iconColor: const Color(0xFF254BD1),
    ),
    AppNotification(
      id: '2',
      title: 'Portofolio Disetujui',
      message: 'Selamat! Portofolio "Juara 1 Lomba Web Design Provinsi" telah disetujui Guru.',
      time: '1 Hari yang lalu',
      role: 'siswa',
      icon: Icons.check_circle_rounded,
      iconColor: const Color(0xFF16A34A),
    ),
    AppNotification(
      id: '3',
      title: 'Perlu Revisi',
      message: 'Portofolio "Proposal UI/UX Aplikasi Edukasi" ditolak. Catatan: Perlu perbaikan dokumentasi.',
      time: '2 Hari yang lalu',
      role: 'siswa',
      icon: Icons.cancel_rounded,
      iconColor: const Color(0xFFDC2626),
    ),
    AppNotification(
      id: '4',
      title: 'Pendaftaran Akun Baru',
      message: 'Siswa baru Karissa Zuleika (XII RPL B) telah berhasil terdaftar ke sistem Edufolio.',
      time: '3 Jam yang lalu',
      role: 'admin',
      icon: Icons.person_add_rounded,
      iconColor: const Color(0xFF254BD1),
    ),
  ]);

  // CRUD METODE PORTOFOLIO DENGAN SINKRONISASI SUPABASE
  Future<void> fetchFromSupabase() async {
    try {
      final supabaseItems = await PortofolioService.fetchAllPortofolio();
      // Selalu gunakan data dari Supabase (jika kosong di Supabase maka kosongkan list)
      portofolioList.value = supabaseItems;
    } catch (e) {
      // Jika error / offline
    }
  }

  void addPortofolio(PortofolioItem item) {
    portofolioList.value = [item, ...portofolioList.value];

    // Tambahkan notifikasi otomatis untuk Guru & Admin
    addNotification(AppNotification(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: 'Pengajuan Baru Masuk',
      message: '${item.namaSiswa} mengajukan portofolio "${item.judul}".',
      time: 'Baru saja',
      role: 'all',
      icon: Icons.upload_file_rounded,
      iconColor: const Color(0xFF254BD1),
    ));

    // Sinkronkan ke Supabase
    PortofolioService.tambahPortofolio(
      judul: item.judul,
      kategori: item.kategori,
      deskripsi: item.deskripsi,
      link: item.link,
      tingkat: item.tingkat,
      peran: item.peran,
      skills: item.skills,
      tanggal: item.tanggalUnggah,
    );
  }

  void updateStatus(String id, String newStatus, {String? catatan}) {
    final list = [...portofolioList.value];
    final index = list.indexWhere((element) => element.id == id);
    if (index != -1) {
      final old = list[index];
      old.status = newStatus;
      if (catatan != null) old.catatan = catatan;
      portofolioList.value = list;

      // Tambahkan notifikasi untuk siswa
      addNotification(AppNotification(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: newStatus == 'Disetujui' ? 'Portofolio Disetujui' : 'Portofolio Ditolak',
        message: 'Portofolio "${old.judul}" telah $newStatus oleh guru verifikator.',
        time: 'Baru saja',
        role: 'all',
        icon: newStatus == 'Disetujui' ? Icons.check_circle_rounded : Icons.cancel_rounded,
        iconColor: newStatus == 'Disetujui' ? const Color(0xFF16A34A) : const Color(0xFFDC2626),
      ));

      // Update ke tabel verifikasi di Supabase
      PortofolioService.updateStatusVerifikasi(
        idPortofolio: id,
        newStatus: newStatus,
        catatan: catatan,
      );
    }
  }

  void updatePenilaian(
    String id, {
    int? kreativitas,
    int? kualitas,
    int? relevansi,
    int? dokumentasi,
    String? catatan,
  }) {
    final list = [...portofolioList.value];
    final index = list.indexWhere((element) => element.id == id);
    if (index != -1) {
      final old = list[index];
      old.kreativitas = kreativitas;
      old.kualitas = kualitas;
      old.relevansi = relevansi;
      old.dokumentasi = dokumentasi;
      old.catatan = catatan;
      portofolioList.value = list;

      final totalScore = ((kreativitas ?? 0) +
              (kualitas ?? 0) +
              (relevansi ?? 0) +
              (dokumentasi ?? 0)) *
          5;

      addNotification(AppNotification(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: 'Penilaian Diterima',
        message: 'Guru telah memberikan penilaian bintang untuk portofolio "${old.judul}".',
        time: 'Baru saja',
        role: 'siswa',
        icon: Icons.star_rounded,
        iconColor: const Color(0xFFF59E0B),
      ));

      // Simpan penilaian ke Supabase
      PortofolioService.simpanPenilaian(
        idPortofolio: id,
        nilai: totalScore,
        catatan: catatan,
      );
    }
  }

  void deletePortofolio(String id) {
    portofolioList.value = portofolioList.value.where((element) => element.id != id).toList();
  }

  void editPortofolio(PortofolioItem updatedItem) {
    final list = [...portofolioList.value];
    final index = list.indexWhere((element) => element.id == updatedItem.id);
    if (index != -1) {
      list[index] = updatedItem;
      portofolioList.value = list;
    }
  }

  // METODE NOTIFIKASI
  void addNotification(AppNotification notif) {
    notifications.value = [notif, ...notifications.value];
  }

  void markAllNotificationsAsRead(String role) {
    final list = [...notifications.value];
    for (var n in list) {
      if (role == 'all' || n.role == 'all' || n.role == role) {
        n.isRead = true;
      }
    }
    notifications.value = list;
  }

  void deleteNotification(String id) {
    notifications.value = notifications.value.where((n) => n.id != id).toList();
  }

  void clearAllNotifications(String role) {
    notifications.value = notifications.value.where((n) {
      if (role == 'all') return false;
      return n.role != 'all' && n.role != role;
    }).toList();
  }
}
