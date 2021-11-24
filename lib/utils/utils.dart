import 'package:file_picker/file_picker.dart';
import 'package:image/image.dart';
import 'dart:async';
import 'dart:io';
import 'package:path/path.dart';
import 'package:rect_pack/rect_pack.dart';
import 'dart:convert';
import 'dart:html' as HTML;
import 'package:font_creator/utils/genXml.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import '../home/home_model.dart';
import 'package:archive/archive.dart';
import 'package:archive/archive_io.dart';

pickOpenFiles() async {
  final res = await FilePicker.platform.pickFiles(
    type: FileType.custom,
    allowedExtensions: ['jpg', 'png'],
  );

  final arr = [];
  for (final file in res.files) {
    arr.add(file);
  }

  return arr;
}

Future<String> pickSaveFile(FileType fileType, {String filename}) {
  return FilePicker.platform.saveFile(
      dialogTitle: 'Please select an output file:',
      fileName: filename,
      type: fileType);
}

combine(HomeData model) async {
  final space = model.space;

  List<InputItem> imgList = [];
  for (final file in model.fileList) {
    final img = decodeImage(file.path.bytes);
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

  String saveFilename = 'test';
  if (!kIsWeb) {
    saveFilename = (await pickSaveFile(FileType.image));
  }

  if (saveFilename == null && saveFilename.length > 0) {
    return;
  }

  final dir = dirname(saveFilename);
  var filename = basenameWithoutExtension(saveFilename);

  final xml = genXml(
      items: items,
      fontSize: model.fontSize,
      spacing: model.space,
      width: rect.width,
      height: rect.height,
      fileName: filename);

  final imgPath = join(dir, '$filename.png');
  final fntPath = join(dir, '$filename.fnt');

  final imgByte = encodePng(mergedImage);
  final fntByte = utf8.encode(xml);
  var encoder = ZipEncoder();
  var archive = Archive();
  ArchiveFile archiveImg = ArchiveFile.stream(
    imgPath,
    imgByte.length,
    imgByte,
  );
  ArchiveFile archiveFnt = ArchiveFile.stream(
    fntPath,
    fntByte.length,
    fntByte,
  );
  archive.addFile(archiveImg);
  archive.addFile(archiveFnt);
  final outputStream = OutputStream(
    byteOrder: LITTLE_ENDIAN,
  );
  final bytes = encoder.encode(archive,
      level: Deflate.BEST_COMPRESSION, output: outputStream);
  saveZipFile('download.zip', bytes);
  // await saveImgFile(imgPath, encodePng(mergedImage));

  // /** macos 智能保存用户选中的文件，所以必须两次选中文件 （我不知道有什么其他方法）*/
  // if (!kIsWeb) {
  //   final filenames = (await pickSaveFile(FileType.any, filename: filename));
  //   if (filenames == null && filenames.length > 0) {
  //     return;
  //   }
  //   final filePath = filenames[0];
  //   filename = basenameWithoutExtension(filePath);
  // }
  // final xmlPath = join(dir, '$filename.fnt');
  // await saveTextFile(xmlPath, xml);
}

saveImgFile(String path, List<int> content) async {
  if (kIsWeb) {
    final base64data = base64Encode(content);
    final anchorElement =
        HTML.AnchorElement(href: 'data:image/png;base64,$base64data');
    anchorElement.download = path;
    anchorElement.click();
  } else {
    var file = File(path);
    if (!await file.exists()) {
      file = await file.create();
    }
    return file.writeAsBytesSync(content);
  }
}

saveTextFile(String path, String content) async {
  if (kIsWeb) {
    final anchorElement = HTML.AnchorElement(
        href:
            '${Uri.dataFromString(content, mimeType: 'text/plain', encoding: utf8)}');
    anchorElement.download = path;
    anchorElement.click();
  } else {
    var file = File(path);
    if (!await file.exists()) {
      file = await file.create();
    }
    return file.writeAsBytesSync(utf8.encode(content));
  }
}

saveZipFile(String path, List<int> content) async {
  if (kIsWeb) {
    final blob = HTML.Blob([content]);
    final url = HTML.Url.createObjectUrlFromBlob(blob);
    final anchorElement = HTML.AnchorElement(href: url);
    anchorElement.download = path;
    anchorElement.click();
  } else {
    var file = File(path);
    if (!await file.exists()) {
      file = await file.create();
    }
    return file.writeAsBytesSync(content);
  }
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
