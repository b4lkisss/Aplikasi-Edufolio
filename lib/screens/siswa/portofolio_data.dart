import 'package:flutter/material.dart';
import '../../services/portofolio_service.dart';

class PortofolioItem {
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
  final String tanggalUnggah;
  final String namaSiswa;
  final String kelas;
  final String avatarUrl;
  String? catatan;
  int? kreativitas;
  int? kualitas;
  int? relevansi;
  int? dokumentasi;

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
    this.tanggalUnggah = '12 Apr 2025',
    this.namaSiswa = 'Balqis Demes Piscesa',
    this.kelas = 'XII RPL B',
    this.avatarUrl =
        'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=400&q=80',
    this.catatan,
    this.kreativitas,
    this.kualitas,
    this.relevansi,
    this.dokumentasi,
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

  SiswaProfile({
    this.nama = 'Balqis Demes Piscesa',
    this.nisn = '0091750552',
    this.kelas = 'XII RPL B',
    this.jurusan = 'RPL',
    this.email = 'balqis@gmail.com',
    this.noTelpon = '08819437942',
    this.jenisKelamin = 'Perempuan',
    this.avatarUrl =
        'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=400&q=80',
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
  static final PortofolioDataStore _instance = PortofolioDataStore._internal();
  factory PortofolioDataStore() => _instance;
  PortofolioDataStore._internal();

  final ValueNotifier<List<PortofolioItem>> portofolioList =
      ValueNotifier<List<PortofolioItem>>([
    PortofolioItem(
      id: '1',
      judul: 'Project Aplikasi E-Commerce Mobile',
      kategori: 'Projek',
      tingkat: 'Provinsi',
      tanggal: '2025',
      deskripsi:
          'Mengembangkan aplikasi mobile e-commerce UMKM lokal menggunakan Flutter dan Firebase dengan fitur katalog produk, keranjang belanja, dan pembayaran payment gateway.',
      peran: 'Lead Mobile Developer - Membangun arsitektur state management dan integrasi API payment gateway.',
      skills: ['Flutter', 'Dart', 'Firebase', 'REST API', 'Figma'],
      link: 'https://github.com/balqis/project-mobile-edufolio',
      status: 'Menunggu',
      imageUrl:
          'https://images.unsplash.com/photo-1589829545856-d10d557cf95f?auto=format&fit=crop&w=600&q=80',
      tanggalUnggah: '2 Jam yang lalu',
      namaSiswa: 'Balqis Demes Piscesa',
      kelas: 'XII RPL B',
      avatarUrl:
          'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=400&q=80',
    ),
    PortofolioItem(
      id: '2',
      judul: 'Sistem Perpustakaan QR Scanner',
      kategori: 'Projek',
      tingkat: 'Kota',
      tanggal: '2025',
      deskripsi:
          'Pembuatan sistem manajemen perpustakaan sekolah berbasis Android untuk mempermudah peminjaman dan pengembalian buku dengan QR Code scanner.',
      peran: 'Frontend Developer - Desain antarmuka responsif dan implementasi scanner QR.',
      skills: ['Flutter', 'QR Scanner', 'UI/UX'],
      link: 'https://github.com/balqis/library-app',
      status: 'Menunggu',
      imageUrl:
          'https://images.unsplash.com/photo-1579389083078-4e7018379f7e?auto=format&fit=crop&w=600&q=80',
      tanggalUnggah: '3 Jam yang lalu',
      namaSiswa: 'Karissa Zuleika',
      kelas: 'XII RPL B',
      avatarUrl:
          'https://images.unsplash.com/photo-1539571696357-5a69c17a67c6?auto=format&fit=crop&w=400&q=80',
    ),
    PortofolioItem(
      id: '3',
      judul: 'Aplikasi Absensi GPS & Face Detection',
      kategori: 'Projek',
      tingkat: 'Sekolah',
      tanggal: '2025',
      deskripsi:
          'Aplikasi monitoring kehadiran siswa berbasis lokasi GPS dan validasi wajah.',
      peran: 'Mobile Developer & UI Designer.',
      skills: ['Flutter', 'GPS Location', 'REST API'],
      link: 'https://github.com/balqis/absensi-gps',
      status: 'Menunggu',
      imageUrl:
          'https://images.unsplash.com/photo-1551650975-87deedd944c3?auto=format&fit=crop&w=600&q=80',
      tanggalUnggah: '5 Jam yang lalu',
      namaSiswa: 'Ahmad Fauzan',
      kelas: 'XII RPL A',
      avatarUrl:
          'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&w=400&q=80',
    ),
    PortofolioItem(
      id: '4',
      judul: 'Sertifikat UI/UX Design Intermediate',
      kategori: 'Sertifikat',
      tingkat: 'Nasional',
      tanggal: '2025',
      deskripsi:
          'Mengikuti pelatihan Web Design dan UI/UX selama 3 bulan di Digital School. Mempelajari desain antarmuka, wireframing, dan prototipe.',
      peran: 'Peserta aktif pelatihan.',
      skills: ['Figma', 'UI/UX Design', 'Design Thinking'],
      link: 'https://drive.google.com/sertifikat-uiux',
      status: 'Menunggu',
      imageUrl:
          'https://images.unsplash.com/photo-1567427017947-545c5f8d16ad?auto=format&fit=crop&w=600&q=80',
      tanggalUnggah: '1 Hari yang lalu',
      namaSiswa: 'Siti Rahmawati',
      kelas: 'XI RPL A',
      avatarUrl:
          'https://images.unsplash.com/photo-1494790108377-be9c29b29330?auto=format&fit=crop&w=400&q=80',
    ),
    PortofolioItem(
      id: '5',
      judul: 'Juara 1 Lomba Web Design Provinsi',
      kategori: 'Prestasi & Lomba',
      tingkat: 'Provinsi',
      tanggal: '2025',
      deskripsi:
          'Mengikuti lomba web design tingkat provinsi yang diselenggarakan oleh Dinas Pendidikan, merancang solusi portal edukasi digital interaktif.',
      peran: 'Ketua Tim dan perancang utama UI/UX serta mengimplementasikan antarmuka dengan HTML, CSS, dan Dart.',
      skills: ['Flutter Web', 'CSS', 'UI/UX Design', 'Figma'],
      link: 'https://drive.google.com/sertifikat-web-design',
      status: 'Disetujui',
      imageUrl:
          'https://images.unsplash.com/photo-1579389083078-4e7018379f7e?auto=format&fit=crop&w=600&q=80',
      tanggalUnggah: '12 Apr 2025',
      namaSiswa: 'Balqis Demes Piscesa',
      kelas: 'XII RPL B',
      kreativitas: 5,
      kualitas: 5,
      relevansi: 4,
      dokumentasi: 4,
      catatan: 'Karya sangat luar biasa dan rapi!',
    ),
    PortofolioItem(
      id: '6',
      judul: 'Sertifikat Flutter Developer Expert',
      kategori: 'Sertifikat',
      tingkat: 'Internasional',
      tanggal: '2025',
      deskripsi: 'Sertifikasi kompetensi keahlian Flutter dari Google Developer Groups.',
      peran: 'Peserta Ujian Sertifikasi.',
      skills: ['Flutter', 'State Management', 'Clean Architecture'],
      link: 'https://cert.dev/flutter-expert',
      status: 'Disetujui',
      imageUrl:
          'https://images.unsplash.com/photo-1567427017947-545c5f8d16ad?auto=format&fit=crop&w=600&q=80',
      tanggalUnggah: '10 Feb 2025',
      namaSiswa: 'Ahmad Fauzan',
      kelas: 'XII RPL A',
      kreativitas: 4,
      kualitas: 5,
      relevansi: 5,
      dokumentasi: 4,
    ),
    PortofolioItem(
      id: '7',
      judul: 'Proposal UI/UX Aplikasi Edukasi',
      kategori: 'Prestasi & Lomba',
      tingkat: 'Sekolah',
      tanggal: '2024',
      deskripsi: 'Proposal desain antarmuka aplikasi edukasi interaktif untuk anak usia dini.',
      peran: 'UI/UX Designer',
      skills: ['Figma', 'Prototyping'],
      link: 'https://figma.com/file/sample-edu',
      status: 'Ditolak',
      imageUrl:
          'https://images.unsplash.com/photo-1606326608606-aa0b62935f2b?auto=format&fit=crop&w=600&q=80',
      tanggalUnggah: '2 Hari yang lalu',
      namaSiswa: 'Siti Rahmawati',
      kelas: 'XI RPL A',
      catatan: 'Perlu revisi pada bagian dokumentasi dan flowchart aplikasi.',
    ),
    PortofolioItem(
      id: '8',
      judul: 'Ketua Divisi IT OSIS Periode 2024',
      kategori: 'Organisasi',
      tingkat: 'Sekolah',
      tanggal: '2024',
      deskripsi:
          'Bertanggung jawab dalam pengelolaan publikasi digital, sistem informasi, dan dokumentasi teknologi kegiatan kesiswaan.',
      peran: 'Ketua Divisi IT',
      skills: ['Kepemimpinan', 'Kerjasama Tim', 'IT Support', 'Manajemen Projek'],
      link: 'https://drive.google.com/sk-osis',
      status: 'Disetujui',
      imageUrl:
          'https://images.unsplash.com/photo-1522071820081-009f0129c71c?auto=format&fit=crop&w=600&q=80',
      tanggalUnggah: '10 Jan 2025',
      namaSiswa: 'Balqis Demes Piscesa',
      kelas: 'XII RPL B',
    ),
  ]);

  final ValueNotifier<SiswaProfile> profile =
      ValueNotifier<SiswaProfile>(SiswaProfile());

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
      if (supabaseItems.isNotEmpty) {
        portofolioList.value = supabaseItems;
      }
    } catch (e) {
      // Jika offline, pertahankan data lokal
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
