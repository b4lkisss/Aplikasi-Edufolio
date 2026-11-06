import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'services/supabase_service.dart';
import 'screens/splash_screen.dart';
import 'screens/admin/login_admin.dart';
import 'screens/admin/dashboard_admin.dart';
import 'screens/admin/profil_admin.dart';
import 'screens/admin/data_guru.dart';
import 'screens/admin/data_siswa.dart';
import 'screens/siswa/login_siswa.dart';
import 'screens/guru/login_guru.dart';
import 'screens/guru/dashboard_guru.dart';
import 'screens/guru/profil_guru.dart';
import 'screens/guru/data_siswa_guru.dart';
import 'screens/guru/verifikasi_portofolio_guru.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi Supabase
  await Supabase.initialize(
    url: 'https://mvuhzaxwtikdszfjsdqs.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im12dWh6YXh3dGlrZHN6ZmpzZHFzIiwicm9sZSI6ImFub24iLCJpYXQiOjE3OTI3MDU0OTUsImV4cCI6MjEwODI4MTQ5NX0.90ttOHiiJgQKXRFc9WNNBObG2G491e-1acgora-SqvQ',
  );

  // Menguji koneksi Supabase
  SupabaseService().testConnection();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      // Halaman pertama aplikasi
      home: const SplashScreen(),
      routes: {
        '/login': (context) => const LoginAdmin(),
        '/dashboard-admin': (context) => const DashboardAdmin(),
        '/profil-admin': (context) => const ProfilAdmin(),
        '/data-guru': (context) => const DataGuru(),
        '/data-siswa': (context) => const DataSiswa(),
        '/login-siswa': (context) => const LoginSiswa(),    
        '/login-guru': (context) => const LoginGuru(),
        '/dashboard-guru': (context) => const DashboardGuru(),
        '/profil-guru': (context) => const ProfilGuru(),
        '/data-siswa-guru': (context) => const DataSiswaGuru(),
        '/verifikasi-portofolio-guru': (context) => const VerifikasiPortofolioGuru(),
      },
    );
  }
}
