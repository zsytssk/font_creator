import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart' as Material;
import 'package:image/image.dart' as IMG;
import 'package:path_provider/path_provider.dart';

Future<IMG.Image> genImgFromPlatformFile(PlatformFile file) async {
  return IMG.decodeImage(File(file.path).readAsBytesSync());
}

Material.Image genImgWidgetFromPlatformFile(
    PlatformFile file, double width, double height) {
  return Material.Image.file(
    File(file.path),
    width: width,
    height: height,
  );
}

saveFile(String path, List<int> content) async {
  if (Platform.isIOS) {
    Directory appDocDir = await getApplicationDocumentsDirectory();

    var file = File('${appDocDir.path}/${path}');
    if (!await file.exists()) {
      file = await file.create();
    }
    return file.writeAsBytesSync(content);
  }
}
