import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:font_creator/utils/utils.dart';
import 'package:image/image.dart';
import 'dart:async';
import 'package:path/path.dart';

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
        value.fileList.add(FileItem(path: file));
      }
    }

    notifyListeners();

    final img = decodeImage(files[0].bytes);
    value.fontSize = img.height.round();
  }

  removeFile(FileItem file) {
    value.fileList.remove(file);
    notifyListeners();
  }

  setFileChar(String path, String char) {
    for (final file in value.fileList) {
      if (file.path == path) {
        file.setChar(char);
      }
    }
    notifyListeners();
  }

  Future<void> onCombine() async {
    Stopwatch stopwatch = new Stopwatch()..start();
    final res = await combine(this.value);
    print('doSomething() executed in:> ${stopwatch.elapsed}');
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
  PlatformFile path;
  int charcode;
  FileItem({this.path}) {
    String filename = basename(path.name);
    charcode = filename.codeUnitAt(0);
  }
  setChar(String char) {
    this.charcode = char.codeUnitAt(0);
  }
}
