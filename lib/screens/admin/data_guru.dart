
import 'package:flutter/material.dart';
import 'detail_guru.dart';

class DataGuru extends StatefulWidget {
  const DataGuru({super.key});

  @override
  State<DataGuru> createState() => _DataGuruState();
}

class _DataGuruState extends State<DataGuru> {
  final Color primaryColor = const Color(0xFF356DA8);
  final Color fieldColor = const Color(0xFFD9D9D9);

  final TextEditingController searchController =
      TextEditingController();

  String selectedBidang = 'Semua Bidang';

  int currentPage = 1;
  final int itemsPerPage = 9;

  // DATA CONTOH GURU
  List<Map<String, dynamic>> daftarGuru = [
    {
      'nama': 'Balqis Demes Piscesa',
      'bidang': 'Bahasa Inggris',
      'email': 'balqis@gmail.com',
      'nip': '1245543',
      'telepon': '08819429283',
      'gender': 'Perempuan',
      'aktif': true,
    },
    {
      'nama': 'Andi Ardiansyah',
      'bidang': 'Bahasa Indonesia',
      'email': 'andi@gmail.com',
      'nip': '1245544',
      'telepon': '081234567891',
      'gender': 'Laki-laki',
      'aktif': true,
    },
    {
      'nama': 'Siti Aulia',
      'bidang': 'KK',
      'email': 'siti@gmail.com',
      'nip': '1245545',
      'telepon': '081234567892',
      'gender': 'Perempuan',
      'aktif': true,
    },
    {
      'nama': 'Muhammad Rizky',
      'bidang': 'Matematika',
      'email': 'rizky@gmail.com',
      'nip': '1245546',
      'telepon': '081234567893',
      'gender': 'Laki-laki',
      'aktif': true,
    },
    {
      'nama': 'Nadia Putri',
      'bidang': 'Bahasa Jawa',
      'email': 'nadia@gmail.com',
      'nip': '1245547',
      'telepon': '081234567894',
      'gender': 'Perempuan',
      'aktif': true,
    },
    {
      'nama': 'Dimas Pratama',
      'bidang': 'PKN',
      'email': 'dimas@gmail.com',
      'nip': '1245548',
      'telepon': '081234567895',
      'gender': 'Laki-laki',
      'aktif': true,
    },
    {
      'nama': 'Ayu Lestari',
      'bidang': 'MPPKod',
      'email': 'ayu@gmail.com',
      'nip': '1245549',
      'telepon': '081234567896',
      'gender': 'Perempuan',
      'aktif': true,
    },
    {
      'nama': 'Fajar Ramadhan',
      'bidang': 'P-Web',
      'email': 'fajar@gmail.com',
      'nip': '1245550',
      'telepon': '081234567897',
      'gender': 'Laki-laki',
      'aktif': true,
    },
    {
      'nama': 'Putri Amelia',
      'bidang': 'Basis Data',
      'email': 'putri@gmail.com',
      'nip': '1245551',
      'telepon': '081234567898',
      'gender': 'Perempuan',
      'aktif': true,
    },
    {
      'nama': 'Rian Saputra',
      'bidang': 'Matematika',
      'email': 'rian@gmail.com',
      'nip': '1245552',
      'telepon': '081234567899',
      'gender': 'Laki-laki',
      'aktif': true,
    },
  ];

  final List<String> daftarBidang = [
    'Bahasa Inggris',
    'Bahasa Indonesia',
    'KK',
    'Matematika',
    'Bahasa Jawa',
    'PKN',
    'MPPKod',
    'P-Web',
    'Basis Data',
  ];

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  // FILTER GURU
  List<Map<String, dynamic>> get filteredGuru {
    return daftarGuru.where((guru) {
      final search = searchController.text.toLowerCase();

      final cocokNama =
          guru['nama'].toString().toLowerCase().contains(search);

      final cocokBidang =
          guru['bidang'].toString().toLowerCase().contains(search);

      final cocokFilter =
          selectedBidang == 'Semua Bidang' ||
          guru['bidang'] == selectedBidang;

      return (cocokNama || cocokBidang) && cocokFilter;
    }).toList();
  }

  // TAMBAH GURU (BOTTOM SHEET SESUAI GAMBAR)
  void tambahGuru() {
    tampilkanFormTambahGuru();
  }

  // EDIT GURU
  void editGuru(int index) {
    tampilkanFormEditGuru(index);
  }

  // FORM TAMBAH GURU (BOTTOM SHEET)
  void tampilkanFormTambahGuru() {
    final namaController = TextEditingController();
    final emailController = TextEditingController();
    final nipController = TextEditingController();
    final passwordController = TextEditingController();
    final konfirmasiPasswordController = TextEditingController();

    String bidang = daftarBidang.first;
    bool showPassword = false;
    bool showKonfirmasi = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Container(
              width: double.infinity,
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // GARIS ATAS
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),

                    // JUDUL
                    Text(
                      'Tambah Data Guru',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                      ),
                    ),

                    const SizedBox(height: 18),

                    // NAMA GURU
                    _buildSheetInput(
                      'Nama Guru',
                      namaController,
                      'Bambang Sugiono',
                    ),

                    // EMAIL
                    _buildSheetInput(
                      'Email',
                      emailController,
                      'bambang@gmail.com',
                      keyboardType: TextInputType.emailAddress,
                    ),

                    // NIP
                    _buildSheetInput(
                      'Nip',
                      nipController,
                      '123456764',
                      keyboardType: TextInputType.number,
                    ),

                    // BIDANG MENGAJAR (DROPDOWN)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Bidang Mengajar',
                            style: TextStyle(
                              color: primaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Container(
                            height: 44,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: primaryColor,
                                width: 1,
                              ),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: bidang,
                                isExpanded: true,
                                hint: Text(
                                  'Pilih Bidang Mengajar',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade500,
                                  ),
                                ),
                                icon: Icon(
                                  Icons.keyboard_arrow_down,
                                  color: primaryColor,
                                  size: 20,
                                ),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: primaryColor,
                                ),
                                items: daftarBidang.map((item) {
                                  return DropdownMenuItem(
                                    value: item,
                                    child: Text(item),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  if (value != null) {
                                    setSheetState(() {
                                      bidang = value;
                                    });
                                  }
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 4),

                    // SECTION DATA AKUN
                    Text(
                      'Data Akun',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                      ),
                    ),

                    const SizedBox(height: 12),

                    // PASSWORD
                    _buildSheetPasswordInput(
                      'Password',
                      passwordController,
                      'Buat Password',
                      showPassword,
                      () {
                        setSheetState(() {
                          showPassword = !showPassword;
                        });
                      },
                    ),

                    // KONFIRMASI PASSWORD
                    _buildSheetPasswordInput(
                      'Konfirmasi Password',
                      konfirmasiPasswordController,
                      'Ulangi Password',
                      showKonfirmasi,
                      () {
                        setSheetState(() {
                          showKonfirmasi = !showKonfirmasi;
                        });
                      },
                    ),

                    const SizedBox(height: 10),

                    // TOMBOL SIMPAN DATA
                    SizedBox(
                      width: double.infinity,
                      height: 44,
                      child: ElevatedButton(
                        onPressed: () {
                          if (namaController.text.trim().isEmpty ||
                              emailController.text.trim().isEmpty ||
                              nipController.text.trim().isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Nama, Email, dan NIP wajib diisi',
                                ),
                              ),
                            );
                            return;
                          }

                          if (passwordController.text.isEmpty ||
                              konfirmasiPasswordController.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Password wajib diisi',
                                ),
                              ),
                            );
                            return;
                          }

                          if (passwordController.text !=
                              konfirmasiPasswordController.text) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Konfirmasi password tidak cocok',
                                ),
                              ),
                            );
                            return;
                          }

                          setState(() {
                            daftarGuru.add({
                              'nama': namaController.text.trim(),
                              'bidang': bidang,
                              'email': emailController.text.trim(),
                              'nip': nipController.text.trim(),
                              'telepon': '',
                              'gender': '',
                              'aktif': true,
                            });
                            currentPage = 1;
                          });

                          Navigator.pop(sheetContext);

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Guru berhasil ditambahkan',
                              ),
                              backgroundColor: Colors.green,
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        child: const Text(
                          'Simpan Data',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  // FORM EDIT GURU (BOTTOM SHEET SESUAI GAMBAR)
  void tampilkanFormEditGuru(int index) {
    final guru = daftarGuru[index];

    final namaController =
        TextEditingController(text: guru['nama'] ?? '');

    final emailController =
        TextEditingController(text: guru['email'] ?? '');

    final nipController =
        TextEditingController(text: guru['nip'] ?? '0091750552');

    final passwordController = TextEditingController();
    final konfirmasiPasswordController = TextEditingController();

    String bidang = guru['bidang'] ?? daftarBidang.first;
    if (!daftarBidang.contains(bidang)) {
      bidang = daftarBidang.first;
    }

    bool showPassword = false;
    bool showKonfirmasi = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Container(
              width: double.infinity,
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // GARIS ATAS
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),

                    // JUDUL: Edit Akun Guru
                    Text(
                      'Edit Akun Guru',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                      ),
                    ),

                    const SizedBox(height: 18),

                    // NAMA
                    _buildSheetInput(
                      'Nama',
                      namaController,
                      'Bambang Sugiono',
                    ),

                    // EMAIL
                    _buildSheetInput(
                      'Email',
                      emailController,
                      'muhammadbambang@gmail.com',
                      keyboardType: TextInputType.emailAddress,
                    ),

                    // NIP
                    _buildSheetInput(
                      'Nip',
                      nipController,
                      '0091750552',
                      keyboardType: TextInputType.number,
                    ),

                    // BIDANG MENGAJAR (DROPDOWN)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Bidang Mengajar',
                            style: TextStyle(
                              color: primaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Container(
                            height: 44,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: primaryColor,
                                width: 1,
                              ),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: bidang,
                                isExpanded: true,
                                hint: Text(
                                  'Pilih Bidang Mengajar',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade500,
                                  ),
                                ),
                                icon: Icon(
                                  Icons.keyboard_arrow_down,
                                  color: primaryColor,
                                  size: 20,
                                ),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: primaryColor,
                                ),
                                items: daftarBidang.map((item) {
                                  return DropdownMenuItem(
                                    value: item,
                                    child: Text(item),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  if (value != null) {
                                    setSheetState(() {
                                      bidang = value;
                                    });
                                  }
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 4),

                    // SECTION DATA AKUN
                    Text(
                      'Data Akun',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                      ),
                    ),

                    const SizedBox(height: 12),

                    // PASSWORD
                    _buildSheetPasswordInput(
                      'Password',
                      passwordController,
                      'Buat Pasword',
                      showPassword,
                      () {
                        setSheetState(() {
                          showPassword = !showPassword;
                        });
                      },
                    ),

                    // KONFIRMASI PASSWORD
                    _buildSheetPasswordInput(
                      'Konfirmasi Password',
                      konfirmasiPasswordController,
                      'Ulangi Password',
                      showKonfirmasi,
                      () {
                        setSheetState(() {
                          showKonfirmasi = !showKonfirmasi;
                        });
                      },
                    ),

                    const SizedBox(height: 10),

                    // TOMBOL SIMPAN DATA
                    SizedBox(
                      width: double.infinity,
                      height: 44,
                      child: ElevatedButton(
                        onPressed: () {
                          if (namaController.text.trim().isEmpty ||
                              emailController.text.trim().isEmpty ||
                              nipController.text.trim().isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Nama, Email, dan NIP wajib diisi',
                                ),
                              ),
                            );
                            return;
                          }

                          if (passwordController.text.isNotEmpty &&
                              passwordController.text !=
                                  konfirmasiPasswordController.text) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Konfirmasi password tidak cocok',
                                ),
                              ),
                            );
                            return;
                          }

                          setState(() {
                            daftarGuru[index] = {
                              ...daftarGuru[index],
                              'nama': namaController.text.trim(),
                              'email': emailController.text.trim(),
                              'nip': nipController.text.trim(),
                              'bidang': bidang,
                            };
                            currentPage = 1;
                          });

                          Navigator.pop(sheetContext);

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Data guru berhasil diperbarui',
                              ),
                              backgroundColor: Colors.green,
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        child: const Text(
                          'Simpan Data',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  // MENU AKSI (TETAP TITIK 3)
  void tampilkanMenuAksi(int index) {
    final guru = daftarGuru[index];

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: false,

      builder: (sheetContext) {
        return Container(
          margin: const EdgeInsets.fromLTRB(10, 0, 10, 15),

          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(13),
          ),

          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              const SizedBox(height: 5),

              // EDIT AKUN
              _menuAksiItem(
                Icons.edit,
                'Edit Akun',
                primaryColor,
                () {
                  Navigator.pop(sheetContext);
                  editGuru(index);
                },
              ),

              const Divider(height: 1),

              // RESET PASSWORD
              _menuAksiItem(
                Icons.vpn_key,
                'Reset Password',
                primaryColor,
                () {
                  Navigator.pop(sheetContext);
                  resetPassword(index);
                },
              ),

              const Divider(height: 1),

              // NONAKTIFKAN AKUN
              _menuAksiItem(
                Icons.toggle_on,
                guru['aktif']
                    ? 'Nonaktifkan Akun'
                    : 'Aktifkan Akun',
                Colors.black,
                () {
                  Navigator.pop(sheetContext);
                  ubahStatusAkun(index);
                },
              ),

              const Divider(height: 1),

              // HAPUS AKUN
              _menuAksiItem(
                Icons.delete,
                'Hapus Akun',
                Colors.red,
                () {
                  Navigator.pop(sheetContext);
                  konfirmasiHapus(index);
                },
              ),

              const Divider(height: 1),

              // BATAL
              Padding(
                padding: const EdgeInsets.all(12),

                child: SizedBox(
                  width: double.infinity,
                  height: 36,

                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(sheetContext);
                    },

                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFB0C8DF),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),

                    child: const Text(
                      'Batal',
                      style: TextStyle(fontSize: 11),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // WIDGET ITEM MENU AKSI
  Widget _menuAksiItem(
    IconData icon,
    String title,
    Color iconColor,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,

      child: SizedBox(
        height: 48,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22),

          child: Row(
            children: [

              Icon(
                icon,
                color: iconColor,
                size: 19,
              ),

              const SizedBox(width: 10),

              Text(
                title,
                style: TextStyle(
                  color: primaryColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // RESET PASSWORD (DIALOG SESUAI DESAIN EDUFOLIO)
  void resetPassword(int index) {
    final guru = daftarGuru[index];

    showDialog(
      context: context,
      builder: (dialogContext) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: Colors.white,
          insetPadding: const EdgeInsets.symmetric(horizontal: 32),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 22, 20, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // JUDUL
                Text(
                  'Reset Password',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                ),

                const SizedBox(height: 8),

                // SUBTITLE
                Text(
                  'Apakah anda yakin ingin mereset password akun guru ini?',
                  style: TextStyle(
                    fontSize: 12.5,
                    color: primaryColor,
                    height: 1.35,
                  ),
                ),

                const SizedBox(height: 16),

                // BOX PROFIL GURU (ABU-ABU ROUNDED)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE2E8F0),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      // AVATAR
                      CircleAvatar(
                        radius: 22,
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.person,
                          size: 26,
                          color: primaryColor,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              guru['nama'] ?? '',
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              guru['email'] ?? '',
                              style: const TextStyle(
                                fontSize: 11,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // TOMBOL BATAL & RESET
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 38,
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(dialogContext),
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(
                              color: primaryColor,
                              width: 1.5,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text(
                            'Batal',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: primaryColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: SizedBox(
                        height: 38,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(dialogContext);

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Password guru berhasil direset ke: edufolio123',
                                ),
                                backgroundColor: Colors.green,
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            'Reset',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // AKTIFKAN / NONAKTIFKAN AKUN (DIALOG SESUAI GAMBAR)
  void ubahStatusAkun(int index) {
    final guru = daftarGuru[index];
    final isAktif = guru['aktif'] == true;

    showDialog(
      context: context,
      builder: (dialogContext) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: Colors.white,
          insetPadding: const EdgeInsets.symmetric(horizontal: 32),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 22, 20, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // JUDUL
                Text(
                  isAktif ? 'Nonaktifkan Akun' : 'Aktifkan Akun',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                ),

                const SizedBox(height: 8),

                // SUBTITLE
                Text(
                  isAktif
                      ? 'Apakah anda yakin ingin menonaktifkan akun guru ini?'
                      : 'Apakah anda yakin ingin mengaktifkan akun guru ini?',
                  style: TextStyle(
                    fontSize: 12.5,
                    color: primaryColor,
                    height: 1.35,
                  ),
                ),

                const SizedBox(height: 16),

                // BOX PROFIL GURU (ABU-ABU ROUNDED)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE2E8F0),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      // AVATAR
                      CircleAvatar(
                        radius: 22,
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.person,
                          size: 26,
                          color: primaryColor,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              guru['nama'] ?? '',
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              guru['email'] ?? '',
                              style: const TextStyle(
                                fontSize: 11,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // TOMBOL BATAL & NONAKTIFKAN / AKTIFKAN
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 38,
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(dialogContext),
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(
                              color: primaryColor,
                              width: 1.5,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text(
                            'Batal',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: primaryColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: SizedBox(
                        height: 38,
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              daftarGuru[index]['aktif'] = !isAktif;
                            });

                            Navigator.pop(dialogContext);

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  isAktif
                                      ? 'Akun guru berhasil dinonaktifkan'
                                      : 'Akun guru berhasil diaktifkan',
                                ),
                                backgroundColor: isAktif
                                    ? Colors.red
                                    : Colors.green,
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isAktif
                                ? const Color(0xFFE53935)
                                : const Color(0xFF4CAF50),
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text(
                            isAktif ? 'Nonaktifkan' : 'Aktifkan',
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // HAPUS AKUN (DIALOG MERAH SEPERTI DATA SISWA)
  void konfirmasiHapus(int index) {
    final guru = daftarGuru[index];

    showDialog(
      context: context,
      builder: (dialogContext) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
          backgroundColor: Colors.white,
          insetPadding: const EdgeInsets.symmetric(horizontal: 36),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 26, 20, 22),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // ICON TONG SAMPAH BULAT MERAH
                Container(
                  width: 86,
                  height: 86,
                  decoration: const BoxDecoration(
                    color: Color(0xFFEF5350),
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.delete_rounded,
                      size: 48,
                      color: Colors.white,
                    ),
                  ),
                ),

                const SizedBox(height: 18),

                // JUDUL: Hapus Data Guru?
                const Text(
                  'Hapus Data Guru?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),

                const SizedBox(height: 8),

                // DESKRIPSI
                Text(
                  'Apakah Anda yakin ingin menghapus data\n${guru['nama']} ?',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 12.5,
                    color: Colors.black87,
                    height: 1.4,
                  ),
                ),

                const SizedBox(height: 22),

                // DUA TOMBOL: BATAL & HAPUS
                Row(
                  children: [
                    // TOMBOL BATAL (OUTLINE BIRU)
                    Expanded(
                      child: SizedBox(
                        height: 40,
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(dialogContext),
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(
                              color: primaryColor,
                              width: 1.5,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text(
                            'Batal',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: primaryColor,
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 12),

                    // TOMBOL HAPUS (MERAH)
                    Expanded(
                      child: SizedBox(
                        height: 40,
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              daftarGuru.removeAt(index);

                              final totalPages =
                                  (filteredGuru.length / itemsPerPage)
                                      .ceil();

                              if (currentPage > totalPages &&
                                  totalPages > 0) {
                                currentPage = totalPages;
                              } else if (totalPages == 0) {
                                currentPage = 1;
                              }
                            });

                            Navigator.pop(dialogContext);

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Data guru berhasil dihapus',
                                ),
                                backgroundColor: Colors.red,
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFE53935),
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            'Hapus',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // DETAIL GURU (MEMBUKA HALAMAN DETAIL)
  void tampilkanDetailGuru(Map<String, dynamic> guru, int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailGuru(guru: guru),
      ),
    ).then((result) {
      if (result == 'edit') {
        editGuru(index);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final data = filteredGuru;

    final totalPages =
        (data.length / itemsPerPage).ceil();

    final safePage = totalPages == 0
        ? 1
        : currentPage.clamp(1, totalPages);

    final startIndex = (safePage - 1) * itemsPerPage;

    final endIndex =
        (startIndex + itemsPerPage).clamp(0, data.length);

    final pageData = data.sublist(startIndex, endIndex);

    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: Column(
          children: [

            // HEADER
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 8,
              ),
              child: Row(
                children: [
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    child: const Row(
                      children: [
                        Icon(Icons.arrow_back, size: 22),
                        SizedBox(width: 6),
                        Text(
                          'Data Guru',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.notifications,
                      color: primaryColor,
                    ),
                  ),
                ],
              ),
            ),

            // PENCARIAN (FULL WIDTH)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: SizedBox(
                height: 38,
                child: TextField(
                  controller: searchController,
                  onChanged: (value) {
                    setState(() {
                      currentPage = 1;
                    });
                  },
                  style: TextStyle(
                    color: primaryColor,
                    fontSize: 12,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Cari nama/NIP...',
                    hintStyle: const TextStyle(
                      color: Color(0xA6356DA8),
                      fontSize: 12,
                    ),
                    prefixIcon: const Icon(
                      Icons.search,
                      color: Color(0xFF64AFCF),
                      size: 20,
                    ),
                    prefixIconConstraints: const BoxConstraints(
                      minWidth: 36,
                    ),
                    filled: true,
                    fillColor: fieldColor,
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 8,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 10),

            // BARIS FILTER BIDANG DAN TAMBAH GURU
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: [
                  // FILTER BIDANG (KOTAK KIRI 50%)
                  Expanded(
                    child: Container(
                      height: 38,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                      ),
                      decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      alignment: Alignment.center,
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: selectedBidang,
                          isExpanded: true,
                          icon: const Icon(
                            Icons.keyboard_arrow_down,
                            color: Colors.white,
                            size: 18,
                          ),
                          style: const TextStyle(
                            fontSize: 11.5,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                          dropdownColor: primaryColor,
                          items: [
                            'Semua Bidang',
                            ...daftarBidang,
                          ].map((item) {
                            return DropdownMenuItem(
                              value: item,
                              child: Text(
                                item,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedBidang = value!;
                              currentPage = 1;
                            });
                          },
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 10),

                  // TOMBOL TAMBAH GURU (KOTAK KANAN 50%)
                  Expanded(
                    child: InkWell(
                      borderRadius: BorderRadius.circular(8),
                      onTap: tambahGuru,
                      child: Container(
                        height: 38,
                        decoration: BoxDecoration(
                          color: primaryColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        alignment: Alignment.center,
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.add,
                              size: 18,
                              color: Colors.white,
                            ),
                            SizedBox(width: 6),
                            Text(
                              'Tambah Guru',
                              style: TextStyle(
                                fontSize: 11.5,
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 15),

            // DAFTAR GURU (CARD STYLE SEPERTI DATA SISWA)
            Expanded(
              child: pageData.isEmpty
                  ? const Center(
                      child: Text(
                        'Data guru tidak ditemukan',
                        style: TextStyle(fontSize: 12),
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      itemCount: pageData.length,
                      separatorBuilder: (context, index) {
                        return const SizedBox(height: 10);
                      },
                      itemBuilder: (context, index) {
                        final guru = pageData[index];
                        final originalIndex =
                            daftarGuru.indexOf(guru);

                        return _buildGuruItem(
                          guru,
                          originalIndex,
                        );
                      },
                    ),
            ),

            const SizedBox(height: 12),

            // PAGINATION
            Padding(
              padding: const EdgeInsets.only(
                bottom: 8,
                left: 10,
                right: 10,
              ),

              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  IconButton(
                    onPressed: safePage > 1
                        ? () {
                            setState(() {
                              currentPage--;
                            });
                          }
                        : null,

                    icon: Icon(
                      Icons.chevron_left,
                      color: primaryColor,
                    ),

                    iconSize: 19,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(
                      minWidth: 28,
                    ),
                  ),

                  if (totalPages > 0)
                    ...List.generate(totalPages, (index) {
                      final page = index + 1;
                      final selected = safePage == page;

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            currentPage = page;
                          });
                        },

                        child: Container(
                          width: 25,
                          height: 25,
                          margin: const EdgeInsets.symmetric(
                            horizontal: 5,
                          ),

                          alignment: Alignment.center,

                          decoration: BoxDecoration(
                            color: selected
                                ? primaryColor
                                : fieldColor,
                            borderRadius: BorderRadius.circular(5),
                          ),

                          child: Text(
                            '$page',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: selected
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                        ),
                      );
                    }),

                  IconButton(
                    onPressed: safePage < totalPages
                        ? () {
                            setState(() {
                              currentPage++;
                            });
                          }
                        : null,

                    icon: Icon(
                      Icons.chevron_right,
                      color: primaryColor,
                    ),

                    iconSize: 19,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(
                      minWidth: 28,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ITEM GURU (CARD STYLE SEPERTI DATA SISWA)
  Widget _buildGuruItem(
    Map<String, dynamic> guru,
    int index,
  ) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),

      child: InkWell(
        borderRadius: BorderRadius.circular(10),

        // KLIK CARD UNTUK MELIHAT DETAIL
        onTap: () {
          tampilkanDetailGuru(guru, index);
        },

        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 9,
            vertical: 10,
          ),

          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: const Color(0xFFE5E5E5),
              width: 1,
            ),
          ),

          child: Row(
            children: [

              // FOTO GURU
              CircleAvatar(
                radius: 25,
                backgroundColor: fieldColor,
                child: Icon(
                  Icons.person,
                  color: primaryColor,
                  size: 30,
                ),
              ),

              const SizedBox(width: 10),

              // NAMA DAN BIDANG
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Text(
                      guru['nama'],
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      guru['bidang'],
                      style: TextStyle(
                        fontSize: 10,
                        color: guru['aktif']
                            ? Colors.black54
                            : Colors.red,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                  ],
                ),
              ),

              // STATUS NONAKTIF
              if (!guru['aktif'])
                const Padding(
                  padding: EdgeInsets.only(right: 4),
                  child: Text(
                    'Nonaktif',
                    style: TextStyle(
                      fontSize: 9,
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

              // TOMBOL MENU TIGA TITIK (TIDAK DIUBAH)
              IconButton(
                onPressed: () {
                  tampilkanMenuAksi(index);
                },

                icon: const Icon(
                  Icons.more_vert,
                  size: 19,
                  color: Colors.black,
                ),

                style: IconButton.styleFrom(
                  backgroundColor: fieldColor,
                  padding: const EdgeInsets.all(5),
                  minimumSize: const Size(29, 29),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }

  // INPUT FORM BOTTOM SHEET (BORDER STYLE)
  Widget _buildSheetInput(
    String label,
    TextEditingController controller,
    String hint, {
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: primaryColor,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 6),
          SizedBox(
            height: 44,
            child: TextField(
              controller: controller,
              keyboardType: keyboardType,
              style: TextStyle(
                fontSize: 12,
                color: primaryColor,
              ),
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade400,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: primaryColor,
                    width: 1,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: primaryColor,
                    width: 1,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: primaryColor,
                    width: 1.5,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // INPUT PASSWORD BOTTOM SHEET
  Widget _buildSheetPasswordInput(
    String label,
    TextEditingController controller,
    String hint,
    bool isVisible,
    VoidCallback toggleVisibility,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: primaryColor,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 6),
          SizedBox(
            height: 44,
            child: TextField(
              controller: controller,
              obscureText: !isVisible,
              style: TextStyle(
                fontSize: 12,
                color: primaryColor,
              ),
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade400,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                suffixIcon: IconButton(
                  onPressed: toggleVisibility,
                  icon: Icon(
                    isVisible
                        ? Icons.visibility
                        : Icons.visibility_off,
                    size: 18,
                    color: primaryColor,
                  ),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: primaryColor,
                    width: 1,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: primaryColor,
                    width: 1,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: primaryColor,
                    width: 1.5,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // INPUT FORM DIALOG (UNTUK EDIT)
  Widget _formInput(
    String label,
    TextEditingController controller,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Text(
            label,
            style: TextStyle(
              color: primaryColor,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),

          const SizedBox(height: 5),

          TextField(
            controller: controller,

            decoration: InputDecoration(
              filled: true,
              fillColor: fieldColor,

              contentPadding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 10,
              ),

              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(7),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
