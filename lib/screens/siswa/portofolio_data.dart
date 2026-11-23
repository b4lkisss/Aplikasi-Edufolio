import 'package:flutter/material.dart';

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
  final String status; // Disetujui, Menunggu, Ditolak
  final String? imageUrl;
  final String tanggalUnggah;

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
  });
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
    this.nama = 'Andi Ardiansyah',
    this.nisn = '123445678',
    this.kelas = 'XII RPL B',
    this.jurusan = 'RPL',
    this.email = 'andi@gmail.com',
    this.noTelpon = '08819437942',
    this.jenisKelamin = 'Perempuan',
    this.avatarUrl =
        'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=400&q=80',
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
      judul: 'Sertifikat Web Design',
      kategori: 'Sertifikat',
      tingkat: 'Nasional',
      tanggal: '2025',
      deskripsi:
          'Mengikuti pelatihan Web Design selama 3 bulan di Digital School. Mempelajari dasar-dasar HTML, CSS, dan UI/UX Design.',
      peran:
          'Sebagai peserta aktif dan menyelesaikan semua tugas akhir dengan nilai memuaskan.',
      skills: ['HTML', 'CSS', 'UI/UX Design', 'Figma'],
      link: 'https://drive.google.com/sertifikat',
      status: 'Menunggu',
      imageUrl:
          'https://images.unsplash.com/photo-1589829545856-d10d557cf95f?auto=format&fit=crop&w=600&q=80',
      tanggalUnggah: '12 Apr 2025',
    ),
    PortofolioItem(
      id: '2',
      judul: 'Sertifikat Web Design',
      kategori: 'Sertifikat',
      tingkat: 'Provinsi',
      tanggal: '2025',
      deskripsi:
          'Program sertifikasi pengembangan antarmuka web modern dengan standar industri.',
      peran: 'Peserta Pelatihan',
      skills: ['HTML', 'CSS', 'JavaScript'],
      link: 'https://drive.google.com/sertifikat-2',
      status: 'Menunggu',
      imageUrl:
          'https://images.unsplash.com/photo-1579389083078-4e7018379f7e?auto=format&fit=crop&w=600&q=80',
      tanggalUnggah: '12 Apr 2025',
    ),
    PortofolioItem(
      id: '3',
      judul: 'Sertifikat Web Design',
      kategori: 'Sertifikat',
      tingkat: 'Provinsi',
      tanggal: '2025',
      deskripsi:
          'Keberhasilan penyelesaian sertifikasi profesional dalam perancangan website dan portofolio.',
      peran: 'Frontend Developer',
      skills: ['HTML', 'CSS', 'UI/UX Design', 'Figma'],
      link: 'https://drive.google.com/sertifikat-3',
      status: 'Disetujui',
      imageUrl:
          'https://images.unsplash.com/photo-1567427017947-545c5f8d16ad?auto=format&fit=crop&w=600&q=80',
      tanggalUnggah: '12 Apr 2025',
    ),
    PortofolioItem(
      id: '4',
      judul: 'Sertifikat Web Design',
      kategori: 'Sertifikat',
      tingkat: 'Sekolah',
      tanggal: '2025',
      deskripsi:
          'Pengajuan sertifikat membutuhkan perbaikan pada kejelasan stempel instansi penerbit.',
      peran: 'Peserta',
      skills: ['Web Design', 'HTML'],
      link: 'https://drive.google.com/sertifikat-revisi',
      status: 'Ditolak',
      imageUrl:
          'https://images.unsplash.com/photo-1606326608606-aa0b62935f2b?auto=format&fit=crop&w=600&q=80',
      tanggalUnggah: '12 Apr 2025',
    ),
    PortofolioItem(
      id: '5',
      judul: 'Juara 1 Lomba Web Design',
      kategori: 'Prestasi & Lomba',
      tingkat: 'Provinsi',
      tanggal: '2025',
      deskripsi:
          'Mengikuti lomba web design tingkat provinsi yang diselenggarakan oleh Dinas Pendidikan, merancang solusi portal edukasi digital interaktif.',
      peran:
          'Sebagai ketua tim dan perancang utama UI/UX serta mengimplementasikan kode antarmuka dengan HTML, CSS, dan JavaScript.',
      skills: ['HTML', 'CSS', 'UI/UX Design', 'Figma', 'JavaScript'],
      link: 'https://drive.google.com/sertifikat-web-design',
      status: 'Disetujui',
      imageUrl:
          'https://images.unsplash.com/photo-1579389083078-4e7018379f7e?auto=format&fit=crop&w=600&q=80',
      tanggalUnggah: '12 Apr 2025',
    ),
    PortofolioItem(
      id: '6',
      judul: 'Juara 1 Lomba Web Design',
      kategori: 'Prestasi & Lomba',
      tingkat: 'Kota',
      tanggal: '2024',
      deskripsi:
          'Pemenang juara 1 kejuaraan pembuatan landing page inovatif untuk pariwisata daerah.',
      peran: 'Frontend Developer',
      skills: ['HTML', 'CSS', 'UI/UX Design'],
      link: 'https://drive.google.com/trophy-lomba',
      status: 'Disetujui',
      imageUrl:
          'https://images.unsplash.com/photo-1567427017947-545c5f8d16ad?auto=format&fit=crop&w=600&q=80',
      tanggalUnggah: '10 Feb 2025',
    ),
    PortofolioItem(
      id: '7',
      judul: 'Aplikasi Mobile Edufolio',
      kategori: 'Projek',
      tingkat: 'Sekolah',
      tanggal: '2025',
      deskripsi:
          'Pengembangan aplikasi mobile portofolio digital berbasis Flutter untuk mempermudah dokumentasi prestasi siswa.',
      peran: 'Mobile Developer',
      skills: ['Flutter', 'Dart', 'UI/UX Design', 'Git'],
      link: 'https://github.com/edufolio-mobile',
      status: 'Disetujui',
      imageUrl:
          'https://images.unsplash.com/photo-1551650975-87deedd944c3?auto=format&fit=crop&w=600&q=80',
      tanggalUnggah: '15 Mar 2025',
    ),
    PortofolioItem(
      id: '8',
      judul: 'Ketua Divisi IT OSIS',
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
    ),
  ]);

  final ValueNotifier<SiswaProfile> profile =
      ValueNotifier<SiswaProfile>(SiswaProfile());

  void addPortofolio(PortofolioItem item) {
    portofolioList.value = [item, ...portofolioList.value];
  }
}
