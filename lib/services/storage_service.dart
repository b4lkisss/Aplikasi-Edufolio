import 'dart:typed_data';
import 'package:supabase_flutter/supabase_flutter.dart';

class StorageService {
  static SupabaseClient get supabase => Supabase.instance.client;

  // 1. Upload Foto Profil ke bucket 'foto-profil' dengan ID pengguna & cache-buster
  static Future<String?> uploadFotoProfil(
    Uint8List bytes, {
    String fileExtension = 'jpg',
    String role = 'user',
    String? userId,
    String? identifier,
  }) async {
    try {
      final idPart = (userId != null && userId.trim().isNotEmpty)
          ? userId.trim().replaceAll(RegExp(r'[^a-zA-Z0-9_-]'), '')
          : 'u';
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final roleLower = role.toLowerCase();

      // Format file name: {role}_{userId}_{timestamp}.{ext}
      // dan simpan file tetap: {role}_{userId}_avatar.{ext} agar mudah di-lookup
      final fileName = '${roleLower}_${idPart}_$timestamp.$fileExtension';
      final staticFileName = '${roleLower}_${idPart}_avatar.$fileExtension';
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

      // Jika ada identifier tambahan (seperti NISN atau NIP), simpan juga aliasnya
      if (identifier != null &&
          identifier.trim().isNotEmpty &&
          identifier.trim() != idPart) {
        final cleanIdent =
            identifier.trim().replaceAll(RegExp(r'[^a-zA-Z0-9_-]'), '');
        if (cleanIdent.isNotEmpty) {
          try {
            await supabase.storage.from('foto-profil').uploadBinary(
              'avatars/${roleLower}_${cleanIdent}_avatar.$fileExtension',
              bytes,
              fileOptions: const FileOptions(
                contentType: 'image/jpeg',
                upsert: true,
              ),
            );
          } catch (_) {}
        }
      }

      // Gunakan URL bertanggal atau tambahkan query parameter cache-buster agar NetworkImage langsung ter-refresh
      final baseUrl = supabase.storage.from('foto-profil').getPublicUrl(staticPath);
      return '$baseUrl?t=$timestamp';
    } catch (e) {
      // Coba fallback jika bucket 'foto-profil' menggunakan nama bucket lain seperti 'foto-portofolio'
      try {
        final idPart = (userId != null && userId.trim().isNotEmpty)
            ? userId.trim().replaceAll(RegExp(r'[^a-zA-Z0-9_-]'), '')
            : 'u';
        final timestamp = DateTime.now().millisecondsSinceEpoch;
        final staticFileName = '${role.toLowerCase()}_${idPart}_avatar.$fileExtension';
        final staticPath = 'avatars/$staticFileName';
        await supabase.storage.from('foto-portofolio').uploadBinary(
          staticPath,
          bytes,
          fileOptions: const FileOptions(
            contentType: 'image/jpeg',
            upsert: true,
          ),
        );
        final baseUrl = supabase.storage.from('foto-portofolio').getPublicUrl(staticPath);
        return '$baseUrl?t=$timestamp';
      } catch (_) {}
      return null;
    }
  }

  // 1b. Dapatkan Foto Profil dari Storage berdasarkan Role dan User ID (atau NISN/NIP)
  static Future<String?> getFotoProfilUser(
    String role,
    String userId, {
    String? secondaryId,
    bool allowRoleFallback = false,
  }) async {
    try {
      final roleLower = role.toLowerCase();
      final cleanId = userId.trim().replaceAll(RegExp(r'[^a-zA-Z0-9_-]'), '');
      final cleanSec = (secondaryId ?? '').trim().replaceAll(RegExp(r'[^a-zA-Z0-9_-]'), '');

      final files = await supabase.storage.from('foto-profil').list(
        path: 'avatars',
      );

      if (files.isNotEmpty) {
        // Urutkan file dari yang paling baru diupdate/dibuat
        final sorted = [...files];
        sorted.sort((a, b) {
          final aTime = a.updatedAt ?? a.createdAt ?? '';
          final bTime = b.updatedAt ?? b.createdAt ?? '';
          return bTime.compareTo(aTime);
        });

        // 1. Cari yang cocok spesifik dengan role_userId_
        if (cleanId.isNotEmpty) {
          final exactMatches = sorted.where(
            (f) =>
                f.name.startsWith('${roleLower}_${cleanId}_') ||
                f.name == '${roleLower}_$cleanId.jpg',
          );
          if (exactMatches.isNotEmpty) {
            final chosen = exactMatches.first;
            final url = supabase.storage
                .from('foto-profil')
                .getPublicUrl('avatars/${chosen.name}');
            final ver = (chosen.updatedAt ?? chosen.createdAt ?? '').hashCode;
            return '$url?v=$ver';
          }
        }

        // 2. Cari yang cocok dengan secondaryId (misal NISN atau NIP)
        if (cleanSec.isNotEmpty) {
          final secMatches = sorted.where(
            (f) =>
                f.name.startsWith('${roleLower}_${cleanSec}_') ||
                f.name == '${roleLower}_$cleanSec.jpg',
          );
          if (secMatches.isNotEmpty) {
            final chosen = secMatches.first;
            final url = supabase.storage
                .from('foto-profil')
                .getPublicUrl('avatars/${chosen.name}');
            final ver = (chosen.updatedAt ?? chosen.createdAt ?? '').hashCode;
            return '$url?v=$ver';
          }
        }

        // 3. Fallback untuk file lama di storage yang berformat {role}_{timestamp}.jpg (tanpa userId di tengah)
        if (allowRoleFallback) {
          final roleMatches = sorted.where(
            (f) {
              if (!f.name.startsWith('${roleLower}_')) return false;
              // Hanya ambil file format lama yang hanya memiliki 2 bagian: role_timestamp.jpg
              final parts = f.name.split('_');
              return parts.length == 2;
            },
          );
          if (roleMatches.isNotEmpty) {
            final chosen = roleMatches.first;
            final url = supabase.storage
                .from('foto-profil')
                .getPublicUrl('avatars/${chosen.name}');
            final ver = (chosen.updatedAt ?? chosen.createdAt ?? '').hashCode;
            return '$url?v=$ver';
          }
        }
      }
    } catch (_) {}
    return null;
  }

  // 1c. Ambil peta semua foto di folder avatars untuk pencocokan cepat daftar Siswa/Guru
  static Future<Map<String, String>> getAllAvatarUrlsMap() async {
    final Map<String, String> result = {};
    try {
      final files = await supabase.storage.from('foto-profil').list(
        path: 'avatars',
      );
      if (files.isEmpty) return result;

      final sorted = [...files];
      sorted.sort((a, b) {
        final aTime = a.updatedAt ?? a.createdAt ?? '';
        final bTime = b.updatedAt ?? b.createdAt ?? '';
        return bTime.compareTo(aTime);
      });

      for (final f in sorted) {
        final url = supabase.storage
            .from('foto-profil')
            .getPublicUrl('avatars/${f.name}');
        final ver = (f.updatedAt ?? f.createdAt ?? '').hashCode;
        final fullUrl = '$url?v=$ver';

        // Format: {role}_{id}_{timestamp/avatar}.jpg
        final parts = f.name.split('_');
        if (parts.length >= 3) {
          final key = '${parts[0].toLowerCase()}_${parts[1]}';
          result.putIfAbsent(key, () => fullUrl);
        }
        if (parts.isNotEmpty) {
          final roleKey = '${parts[0].toLowerCase()}_latest';
          result.putIfAbsent(roleKey, () => fullUrl);
        }
      }
    } catch (_) {}
    return result;
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
