import 'package:flutter/material.dart' as Material;
import 'package:file_chooser/file_chooser.dart';
import 'package:image/image.dart';
import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:path/path.dart';
import 'package:rect_pack/rect_pack.dart';
import 'dart:convert';

import 'package:font_creator/utils/genXml.dart';

import '../model.dart';

pickOpenFiles() {
  return showOpenPanel(
    allowsMultipleSelection: true,
    allowedFileTypes: [
      FileTypeFilterGroup(label: 'image', fileExtensions: ['png', 'jpg']),
    ],
  ).then((val) {
    return val.paths;
  });
}

Future<List<String>> pickSaveFile(String fileType, {String filename}) {
  return showSavePanel(
    suggestedFileName: filename,
    allowedFileTypes: [
      FileTypeFilterGroup(label: 'image', fileExtensions: [fileType]),
    ],
  ).then((result) => result.paths);
}

combine(Model model) async {
  final space = model.space;

  List<InputItem> imgList = [];
  for (final file in model.fileList) {
    final img = decodeImage(File(file.path).readAsBytesSync());
    imgList.add(InputItem(
        item: {'img': img, 'file': file},
        width: img.width + space,
        height: img.height + space));
  }
  final rect = rectPack(imgList);
  List<XMLItem> items = [];
  final Image mergedImage = Image(rect.width, rect.height);
  for (final rectItem in rect.items) {
    final item = rectItem.item;
    items.add(XMLItem(
        id: item['file'].charcode,
        x: rectItem.x,
        y: rectItem.y,
        width: rectItem.width,
        height: rectItem.height));

    copyInto(mergedImage, item['img'], dstX: rectItem.x, dstY: rectItem.y);
  }

  final filenames = (await pickSaveFile('png'));

  if (filenames == null && filenames.length > 0) {
    return;
  }

  final filePath = filenames[0];
  final dir = dirname(filePath);
  var filename = basenameWithoutExtension(filePath);

  final xml = genXml(
      items: items,
      fontSize: model.fontSize,
      spacing: model.space,
      width: rect.width,
      height: rect.height,
      fileName: filename);

  final imgPath = join(dir, '$filename.png');
  await saveFile(imgPath, encodePng(mergedImage));

  /** macos 智能保存用户选中的文件，所以必须两次选中文件 （我不知道有什么其他方法）*/
  if (Platform.isMacOS) {
    final filenames = (await pickSaveFile('fnt', filename: filename));
    if (filenames == null && filenames.length > 0) {
      return;
    }
    final filePath = filenames[0];
    filename = basenameWithoutExtension(filePath);
  }
  final xmlPath = join(dir, '$filename.fnt');
  await saveFile(xmlPath, utf8.encode(xml));
}

saveFile(String path, List<int> content) async {
  var file = File(path);
  if (!await file.exists()) {
    file = await file.create();
  }
  return file.writeAsBytesSync(content);
}

Future<List<FileSystemEntity>> dirContents(String dirStr) async {
  var files = <FileSystemEntity>[];
  final dir = new Directory(dirStr);
  final exist = await dir.exists();

  if (!exist) {
    return files;
  }
  var completer = Completer<List<FileSystemEntity>>();
  var lister = dir.list(recursive: false);
  lister.listen((file) => files.add(file),
      // should also register onError
      onDone: () => completer.complete(files));
  return completer.future;
}

Future<ui.Image> loadImg(String path) {
  final Completer<ui.Image> completer = Completer();
  final image = Material.FileImage(File(path));

  image.resolve(Material.ImageConfiguration()).addListener(
      Material.ImageStreamListener((Material.ImageInfo info, bool isSync) {
    completer.complete(info.image);
  }));

  return completer.future;
}
