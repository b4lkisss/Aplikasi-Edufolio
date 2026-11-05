import 'package:flutter/material.dart';

class ProfilAdmin extends StatefulWidget {
  const ProfilAdmin({super.key});

  @override
  State<ProfilAdmin> createState() => _ProfilAdminState();
}

class _ProfilAdminState extends State<ProfilAdmin> {
  final namaController = TextEditingController(text: 'Andi Ardiansyah');
  final emailController = TextEditingController(text: 'ardi@gmail.com');
  final tanggalLahirController = TextEditingController(text: '13-04-2007');
  final jenisKelaminController = TextEditingController(text: 'Laki-laki');
  final noTelponController = TextEditingController(text: '3740249284649');

  @override
  void dispose() {
    namaController.dispose();
    emailController.dispose();
    tanggalLahirController.dispose();
    jenisKelaminController.dispose();
    noTelponController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // HEADER: Tombol Kembali + Judul + Tombol Simpan
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  // Tombol Kembali
                  InkWell(
                    borderRadius: BorderRadius.circular(8),
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Padding(
                      padding: EdgeInsets.all(4),
                      child: Icon(
                        Icons.arrow_back,
                        size: 24,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                  ),

                  const SizedBox(width: 8),

                  // Judul
                  const Expanded(
                    child: Text(
                      'Profil Admin',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                  ),

                  // Tombol Simpan
                  ElevatedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Profil berhasil disimpan!'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },
                    icon: const Icon(Icons.save_rounded, size: 18),
                    label: const Text(
                      'Simpan',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1E293B),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 8,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 0,
                    ),
                  ),
                ],
              ),
            ),

            // KONTEN PROFIL (SCROLLABLE)
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),

                    // FOTO PROFIL DI TENGAH
                    Center(
                      child: Stack(
                        children: [
                          Container(
                            width: 110,
                            height: 110,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: const Color(0xFFE2E8F0),
                                width: 3,
                              ),
                              color: const Color(0xFFF1F5F9),
                            ),
                            child: const CircleAvatar(
                              radius: 52,
                              backgroundColor: Color(0xFFF1F5F9),
                              child: Icon(
                                Icons.person,
                                size: 56,
                                color: Color(0xFF94A3B8),
                              ),
                            ),
                          ),

                          // Tombol edit foto kecil di pojok kanan bawah
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: InkWell(
                              onTap: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Ganti foto belum tersedia'),
                                  ),
                                );
                              },
                              child: Container(
                                padding: const EdgeInsets.all(6),
                                decoration: const BoxDecoration(
                                  color: Color(0xFF1E293B),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.camera_alt_rounded,
                                  size: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 32),

                    // FORM FIELD: Nama Lengkap
                    _buildFieldLabel('Nama Lengkap'),
                    const SizedBox(height: 6),
                    _buildTextField(namaController),

                    const SizedBox(height: 20),

                    // FORM FIELD: Email
                    _buildFieldLabel('Email'),
                    const SizedBox(height: 6),
                    _buildTextField(emailController),

                    const SizedBox(height: 20),

                    // FORM FIELD: Tanggal Lahir
                    _buildFieldLabel('Tanggal Lahir'),
                    const SizedBox(height: 6),
                    _buildTextField(tanggalLahirController),

                    const SizedBox(height: 20),

                    // FORM FIELD: Jenis Kelamin
                    _buildFieldLabel('Jenis Kelamin'),
                    const SizedBox(height: 6),
                    _buildTextField(jenisKelaminController),

                    const SizedBox(height: 20),

                    // FORM FIELD: No Telpon
                    _buildFieldLabel('No Telpon'),
                    const SizedBox(height: 6),
                    _buildTextField(noTelponController),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // LABEL FIELD
  Widget _buildFieldLabel(String label) {
    return Text(
      label,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: Color(0xFF1E293B),
      ),
    );
  }

  // TEXT FIELD DENGAN STYLE ABU-ABU ROUNDED
  Widget _buildTextField(TextEditingController controller) {
    return TextField(
      controller: controller,
      style: const TextStyle(
        fontSize: 14,
        color: Color(0xFF64748B),
      ),
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color(0xFFF1F5F9),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Color(0xFF254BD1),
            width: 1.5,
          ),
        ),
      ),
    );
  }
}

