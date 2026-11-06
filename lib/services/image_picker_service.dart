import 'dart:typed_data';

import 'image_picker_stub.dart'
    if (dart.library.html) 'image_picker_web.dart' as platform;

class AppImagePicker {
  static Future<Uint8List?> pickImage() async {
    try {
      return await platform.ImagePickerService.pickImage();
    } catch (e) {
      return null;
    }
  }
}

