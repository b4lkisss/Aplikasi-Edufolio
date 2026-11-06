// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'dart:typed_data';
import 'dart:async';

abstract class ImagePickerService {
  static Future<Uint8List?> pickImage() async {
    final completer = Completer<Uint8List?>();

    final uploadInput = html.FileUploadInputElement()
      ..accept = 'image/*';
    uploadInput.click();

    uploadInput.onChange.listen((e) {
      final files = uploadInput.files;
      if (files != null && files.isNotEmpty) {
        final file = files[0];
        final reader = html.FileReader();

        reader.onLoadEnd.listen((e) {
          final result = reader.result;
          if (result is Uint8List) {
            completer.complete(result);
          } else if (result is ByteBuffer) {
            completer.complete(result.asUint8List());
          } else {
            completer.complete(null);
          }
        });

        reader.onError.listen((e) {
          completer.complete(null);
        });

        reader.readAsArrayBuffer(file);
      } else {
        completer.complete(null);
      }
    });

    return completer.future;
  }
}

