import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  final supabase = Supabase.instance.client;

  Future<void> testConnection() async {
    try {
      final response = await supabase
          .from('portofolio_siswa')
          .select();

      print('Koneksi Supabase berhasil!');
      print('Data: $response');

    } catch (e) {
      print('Koneksi Supabase gagal!');
      print('Error: $e');
    }
  }
}