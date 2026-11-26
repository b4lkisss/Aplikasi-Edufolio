import 'dart:typed_data';
import 'package:supabase_flutter/supabase_flutter.dart';

class StorageService {
  static SupabaseClient get supabase => Supabase.instance.client;

  // 1. Upload Foto Profil ke bucket 'foto-profil'
  static Future<String?> uploadFotoProfil(
    Uint8List bytes, {
    String fileExtension = 'jpg',
    String role = 'user',
  }) async {
    try {
      final fileName = '${role}_${DateTime.now().millisecondsSinceEpoch}.$fileExtension';
      final path = 'avatars/$fileName';

      await supabase.storage.from('foto-profil').uploadBinary(
        path,
        bytes,
        fileOptions: const FileOptions(
          contentType: 'image/jpeg',
          upsert: true,
        ),
      );

      final publicUrl = supabase.storage.from('foto-profil').getPublicUrl(path);
      return publicUrl;
    } catch (e) {
      // Jika terjadi kendala RLS atau jaringan, tetap return null dan app gunakan memori lokal
      return null;
    }
  }

  // 2. Upload Foto Portofolio ke bucket 'foto-portofolio'
  static Future<String?> uploadFotoPortofolio(
    Uint8List bytes, {
    String fileExtension = 'jpg',
    String? customName,
  }) async {
    try {
      final name = customName ?? 'porto_${DateTime.now().millisecondsSinceEpoch}';
      final path = 'portofolio/$name.$fileExtension';

      await supabase.storage.from('foto-portofolio').uploadBinary(
        path,
        bytes,
        fileOptions: const FileOptions(
          contentType: 'image/jpeg',
          upsert: true,
        ),
      );

      final publicUrl = supabase.storage.from('foto-portofolio').getPublicUrl(path);
      return publicUrl;
    } catch (e) {
      return null;
    }
  }

  // 3. Upload File Dokumen ke bucket 'file-dokumen'
  static Future<String?> uploadDokumen(
    Uint8List bytes, {
    required String fileName,
    String contentType = 'application/pdf',
  }) async {
    try {
      final cleanName = fileName.replaceAll(RegExp(r'[^a-zA-Z0-9._-]'), '_');
      final path = 'dokumen/${DateTime.now().millisecondsSinceEpoch}_$cleanName';

      await supabase.storage.from('file-dokumen').uploadBinary(
        path,
        bytes,
        fileOptions: FileOptions(
          contentType: contentType,
          upsert: true,
        ),
      );

      final publicUrl = supabase.storage.from('file-dokumen').getPublicUrl(path);
      return publicUrl;
    } catch (e) {
      return null;
    }
  }
}
