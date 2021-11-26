import 'dart:async';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_creator/utils/utils.dart';
import 'package:path/path.dart';

import '../platform/fileUtilsNative.dart'
    if (dart.library.html) '../platform/fileUtilsWeb.dart';

enum FontType { XML, TEXT }

class HomeNotifier extends ChangeNotifier {
  HomeData value;

  HomeNotifier(this.value);

  setFontType(FontType fontType) {
    value.fontType = fontType;
    notifyListeners();
  }

  uploadFile() async {
    final files = await pickOpenFiles();

    if (files.length > 0) {
      for (final file in files) {
        value.fileList.add(FileItem(platform_file: file));
      }
    }

    notifyListeners();

    final img = await genImgFromPlatformFile(files[0]);
    value.fontSize = img.height.round();
  }

  removeFile(FileItem file) {
    value.fileList.remove(file);
    notifyListeners();
  }

  setFileChar(String path, String char) {
    for (final file in value.fileList) {
      if (file.platform_file == path) {
        file.setChar(char);
      }
    }
    notifyListeners();
  }

  Future<void> onCombine() async {
    // final res = await compute(combine, this.value);
    final res = await combine(this.value);
    return res;
  }

  setSpace(int space) {
    value.space = space;
    notifyListeners();
  }

  clear() {
    value.fileList.clear();
    notifyListeners();
  }
}

class HomeData {
  List<FileItem> fileList = [];
  int fontSize = 20;
  FontType fontType = FontType.XML;
  int space = 2;

  @override
  toString() => 'filelist: $fileList, fontSize: $fontSize, fontType: $fontType';
}

class FileItem {
  PlatformFile platform_file;
  int charcode;
  FileItem({this.platform_file}) {
    String filename = basename(platform_file.name);
    charcode = filename.codeUnitAt(0);
  }
  setChar(String char) {
    this.charcode = char.codeUnitAt(0);
  }
}
