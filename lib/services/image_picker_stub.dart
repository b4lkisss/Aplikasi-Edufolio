import 'dart:typed_data';

abstract class ImagePickerService {
  static Future<Uint8List?> pickImage() async {
    throw UnimplementedError();
  }
}

