import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:archive/archive.dart';
import 'package:archive/archive_io.dart';
import 'package:file_picker/file_picker.dart';
import 'package:font_creator/utils/genXml.dart';
import 'package:image/image.dart';
import 'package:path/path.dart';
import 'package:rect_pack/rect_pack.dart';

import '../home/home_model.dart';
import '../platform/fileUtilsNative.dart'
    if (dart.library.html) '../platform/fileUtilsWeb.dart';

combine(HomeData model) async {
  final space = model.space;
  Stopwatch stopwatch = new Stopwatch()..start();
  List<InputItem> imgList = [];

  print('combine() executed in:>0 ${stopwatch.elapsed}');
  for (final file in model.fileList) {
    final img = await genImgFromPlatformFile(file.platform_file);

    imgList.add(InputItem(
        item: {'img': img, 'file': file},
        width: img.width + space,
        height: img.height + space));
  }

  print('combine() executed in:>1 ${stopwatch.elapsed}');
  final rect = rectPack(imgList);
  print('combine() executed in:>2 ${stopwatch.elapsed}');
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

  if (saveFilename == null && saveFilename.length > 0) {
    return;
  }
  print('combine() executed in:>3 ${stopwatch.elapsed}');
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

  print('combine() executed in:>3.5 ${stopwatch.elapsed}');
  final imgByte = encodePng(mergedImage);
  print('combine() executed in:>3.6 ${stopwatch.elapsed}');
  final fntByte = utf8.encode(xml);

  print('combine() executed in:>3.7 ${stopwatch.elapsed}');
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
  print('combine() executed in:>3.8 ${stopwatch.elapsed}');
  final bytes = encoder.encode(archive,
      level: Deflate.BEST_COMPRESSION, output: outputStream);
  print('combine() executed in:>4 ${stopwatch.elapsed}');
  await saveFile('download.zip', bytes);
  print('combine() executed in:>5 ${stopwatch.elapsed}');
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

pickOpenFiles() async {
  final res = await FilePicker.platform.pickFiles(
    type: FileType.custom,
    allowMultiple: true,
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

sleep(int num) {
  return new Future.delayed(Duration(seconds: num));
}
