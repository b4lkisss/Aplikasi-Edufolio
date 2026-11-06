import 'package:flutter/material.dart';

class ProfilGuru extends StatefulWidget {
  const ProfilGuru({super.key});

  @override
  State<ProfilGuru> createState() => _ProfilGuruState();
}

class _ProfilGuruState extends State<ProfilGuru> {
  final TextEditingController namaController =
      TextEditingController(text: 'Andi Ardiansyah');
  final TextEditingController nipController =
      TextEditingController(text: '1625891829');
  final TextEditingController bidangController =
      TextEditingController(text: 'Bahasa Inggris');
  final TextEditingController emailController =
      TextEditingController(text: 'ardiiz@gmail.com');
  final TextEditingController tglLahirController =
      TextEditingController(text: '14-02-2008');
  final TextEditingController noTelponController =
      TextEditingController(text: '083930865308943');

  String selectedGender = 'Laki-laki';

  final Color primaryBlue = const Color(0xFF254BD1);
  final Color fieldBg = const Color(0xFFD9D9D9);

  @override
  void dispose() {
    namaController.dispose();
    nipController.dispose();
    bidangController.dispose();
    emailController.dispose();
    tglLahirController.dispose();
    noTelponController.dispose();
    super.dispose();
  }

  Future<void> _pilihTanggal() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2008, 2, 14),
      firstDate: DateTime(1960),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: primaryBlue,
              onPrimary: Colors.white,
              onSurface: const Color(0xFF1E293B),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        tglLahirController.text =
            '${picked.day.toString().padLeft(2, '0')}-${picked.month.toString().padLeft(2, '0')}-${picked.year}';
      });
    }
  }

  void _simpanProfil() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.check_circle_rounded, color: Colors.white),
            SizedBox(width: 10),
            Text('Profil guru berhasil diperbarui'),
          ],
        ),
        backgroundColor: const Color(0xFF16A34A),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1E293B)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Profil Guru',
          style: TextStyle(
            color: Color(0xFF1E293B),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: InkWell(
                onTap: _simpanProfil,
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFD9D9D9),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.bookmark_rounded,
                        size: 16,
                        color: Color(0xFF1E293B),
                      ),
                      SizedBox(width: 6),
                      Text(
                        'Simpan',
                        style: TextStyle(
                          color: Color(0xFF1E293B),
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // FOTO PROFIL GURU (TENGAH)
            Center(
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 3),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x1F000000),
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                      ],
                      image: const DecorationImage(
                        image: NetworkImage(
                          'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=400&q=80',
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(
                      color: Color(0xFF254BD1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.camera_alt_rounded,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // NAMA LENGKAP
            _buildFieldLabel('Nama Lengkap'),
            _buildTextField(namaController),

            const SizedBox(height: 14),

            // NIP
            _buildFieldLabel('NIP'),
            _buildTextField(nipController, keyboardType: TextInputType.number),

            const SizedBox(height: 14),

            // BIDANG MENGAJAR
            _buildFieldLabel('Bidang Mengajar'),
            _buildTextField(bidangController),

            const SizedBox(height: 14),

            // EMAIL
            _buildFieldLabel('Email'),
            _buildTextField(emailController, keyboardType: TextInputType.emailAddress),

            const SizedBox(height: 14),

            // TANGGAL LAHIR
            _buildFieldLabel('Tanggal Lahir'),
            InkWell(
              onTap: _pilihTanggal,
              borderRadius: BorderRadius.circular(12),
              child: IgnorePointer(
                child: _buildTextField(
                  tglLahirController,
                  suffixIcon: const Icon(
                    Icons.calendar_today_rounded,
                    size: 18,
                    color: Color(0xFF64748B),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 14),

            // JENIS KELAMIN
            _buildFieldLabel('Jenis Kelamin'),
            Container(
              height: 48,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: fieldBg,
                borderRadius: BorderRadius.circular(12),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: selectedGender,
                  isExpanded: true,
                  icon: const Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: Color(0xFF64748B),
                  ),
                  style: const TextStyle(
                    color: Color(0xFF1E293B),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  dropdownColor: Colors.white,
                  items: const [
                    DropdownMenuItem(
                      value: 'Laki-laki',
                      child: Text('Laki-laki'),
                    ),
                    DropdownMenuItem(
                      value: 'Perempuan',
                      child: Text('Perempuan'),
                    ),
                  ],
                  onChanged: (val) {
                    if (val != null) {
                      setState(() {
                        selectedGender = val;
                      });
                    }
                  },
                ),
              ),
            ),

            const SizedBox(height: 14),

            // NO TELPON
            _buildFieldLabel('No Telpon'),
            _buildTextField(noTelponController, keyboardType: TextInputType.phone),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildFieldLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Color(0xFF1E293B),
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller, {
    TextInputType keyboardType = TextInputType.text,
    Widget? suffixIcon,
  }) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: fieldBg,
        borderRadius: BorderRadius.circular(12),
      ),
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        style: const TextStyle(
          color: Color(0xFF1E293B),
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          isDense: true,
          contentPadding: EdgeInsets.zero,
          suffixIcon: suffixIcon,
          suffixIconConstraints: const BoxConstraints(minWidth: 24, minHeight: 24),
        ),
      ),
    );
  }
}

