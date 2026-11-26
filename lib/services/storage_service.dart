import 'dart:typed_data';
import 'package:supabase_flutter/supabase_flutter.dart';

class StorageService {
  static SupabaseClient get supabase => Supabase.instance.client;

  // 1. Upload Foto Profil ke bucket 'foto-profil' dengan ID pengguna
  static Future<String?> uploadFotoProfil(
    Uint8List bytes, {
    String fileExtension = 'jpg',
    String role = 'user',
    String? userId,
  }) async {
    try {
      final idPart = (userId != null && userId.isNotEmpty) ? userId : 'u';
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      // Format file name: {role}_{userId}_{timestamp}.{ext}
      // dan simpan file tetap: {role}_{userId}_avatar.{ext} agar mudah di-lookup
      final fileName = '${role}_${idPart}_$timestamp.$fileExtension';
      final staticFileName = '${role}_${idPart}_avatar.$fileExtension';
      final path = 'avatars/$fileName';
      final staticPath = 'avatars/$staticFileName';

      // Upload file bertanggal
      await supabase.storage.from('foto-profil').uploadBinary(
        path,
        bytes,
        fileOptions: const FileOptions(
          contentType: 'image/jpeg',
          upsert: true,
        ),
      );

      // Upload file statis khusus ID ini (upsert)
      try {
        await supabase.storage.from('foto-profil').uploadBinary(
          staticPath,
          bytes,
          fileOptions: const FileOptions(
            contentType: 'image/jpeg',
            upsert: true,
          ),
        );
      } catch (_) {}

      final publicUrl = supabase.storage.from('foto-profil').getPublicUrl(staticPath);
      return publicUrl;
    } catch (e) {
      // Coba fallback jika bucket 'foto-profil' menggunakan nama bucket lain seperti 'foto-portofolio'
      try {
        final idPart = (userId != null && userId.isNotEmpty) ? userId : 'u';
        final staticFileName = '${role}_${idPart}_avatar.$fileExtension';
        final staticPath = 'avatars/$staticFileName';
        await supabase.storage.from('foto-portofolio').uploadBinary(
          staticPath,
          bytes,
          fileOptions: const FileOptions(
            contentType: 'image/jpeg',
            upsert: true,
          ),
        );
        return supabase.storage.from('foto-portofolio').getPublicUrl(staticPath);
      } catch (_) {}
      return null;
    }
  }

  // 1b. Dapatkan Foto Profil dari Storage berdasarkan Role dan User ID
  static Future<String?> getFotoProfilUser(String role, String userId) async {
    try {
      if (userId.isEmpty) return null;
      final roleLower = role.toLowerCase();
      final staticFileName = '${roleLower}_${userId}_avatar.jpg';
      final staticPath = 'avatars/$staticFileName';

      // Cek apakah file ada di storage dengan me-list avatars
      final files = await supabase.storage.from('foto-profil').list(
        path: 'avatars',
        searchOptions: SearchOptions(
          search: '${roleLower}_${userId}',
        ),
      );

      if (files.isNotEmpty) {
        // Cari file yang paling sesuai (prioritaskan static atau urutkan yang terbaru)
        final match = files.firstWhere(
          (f) => f.name.contains('${roleLower}_${userId}'),
          orElse: () => files.first,
        );
        return supabase.storage.from('foto-profil').getPublicUrl('avatars/${match.name}');
      }

      // Coba juga di foto-portofolio jika ada
      final fallbackFiles = await supabase.storage.from('foto-portofolio').list(
        path: 'avatars',
        searchOptions: SearchOptions(
          search: '${roleLower}_${userId}',
        ),
      );
      if (fallbackFiles.isNotEmpty) {
        return supabase.storage.from('foto-portofolio').getPublicUrl('avatars/${fallbackFiles.first.name}');
      }
    } catch (_) {}
    return null;
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
