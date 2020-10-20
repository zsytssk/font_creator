import 'package:flutter/material.dart';
import 'package:font_creator/utils/utils.dart';
import 'dart:io';
import 'dart:async';
import 'package:path/path.dart';

enum FontType { XML, TEXT }

class Model {
  List<FileItem> fileList = [];
  int fontSize = 20;
  FontType fontType = FontType.XML;
  int space = 2;
  setFontType(FontType fontType) {
    this.fontType = fontType;
  }

  uploadFile() async {
    final files = await pickOpenFiles();
    if (files.length > 0) {
      for (final file in files) {
        fileList.add(FileItem(path: file));
      }
    }

    await loadImg(files[0]).then((img) => fontSize = img.height.round());
  }

  removeFile(FileItem file) {
    fileList.remove(file);
  }

  setFileChar(String path, String char) {
    for (final file in fileList) {
      if (file.path == path) {
        file.setChar(char);
      }
    }
  }

  Future<void> onCombine() {
    return combine(this);
  }

  setSpace(int space) {
    this.space = space;
  }

  clear() {
    fileList.clear();
  }
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
