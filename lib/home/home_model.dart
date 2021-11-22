import 'package:flutter/material.dart';
import 'package:font_creator/utils/utils.dart';
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

    await loadImg(files[0]).then((img) => value.fontSize = img.height.round());
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

  Future<void> onCombine() {
    return combine(this.value);
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
  String path;
  int charcode;
  FileItem({this.path}) {
    String filename = basename(path);
    charcode = filename.codeUnitAt(0);
  }
  setChar(String char) {
    this.charcode = char.codeUnitAt(0);
  }
}
