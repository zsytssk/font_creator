import 'dart:html';
import 'package:flutter/material.dart' as Material;
import 'package:file_picker/file_picker.dart';
import 'package:image/image.dart' as IMG;

saveFile(String path, List<int> content) async {
  final blob = Blob([content]);
  final url = Url.createObjectUrlFromBlob(blob);
  final anchorElement = AnchorElement(href: url);
  anchorElement.download = path;
  anchorElement.click();
}

Future<IMG.Image> genImgFromPlatformFile(PlatformFile file) async {
  return IMG.decodeImage(file.bytes);
}

Material.Image genImgWidgetFromPlatformFile(
    PlatformFile file, double width, double height) {
  return Material.Image.memory(
    file.bytes,
    width: width,
    height: height,
  );
}
