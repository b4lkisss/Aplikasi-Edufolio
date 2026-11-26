import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

class AppImagePicker {
  static final ImagePicker _picker = ImagePicker();

  /// Mengambil gambar baik dari Kamera maupun Galeri
  /// Mendukung Android, iOS, dan Web
  static Future<Uint8List?> pickImage({ImageSource source = ImageSource.gallery}) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        maxWidth: 1920,
        maxHeight: 1920,
        imageQuality: 85,
      );

      if (image != null) {
        return await image.readAsBytes();
      }
    } catch (e) {
      debugPrint('Error pickImage ($source): $e');
    }
    return null;
  }

  /// Ambil foto langsung dari kamera perangkat
  static Future<Uint8List?> pickFromCamera() async {
    return await pickImage(source: ImageSource.camera);
  }

  /// Ambil berkas/foto dari galeri / pengelola file
  static Future<Uint8List?> pickFromGallery() async {
    return await pickImage(source: ImageSource.gallery);
  }

  /// Rekam video dari kamera
  static Future<XFile?> pickVideo() async {
    try {
      return await _picker.pickVideo(source: ImageSource.camera);
    } catch (e) {
      debugPrint('Error pickVideo: $e');
      return null;
    }
  }
}
