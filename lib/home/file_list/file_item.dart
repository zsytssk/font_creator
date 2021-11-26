import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:font_creator/components/on_hover_image.dart';
import 'package:font_creator/home/home_model.dart' as Model;
import 'package:provider/provider.dart';

import '../../platform/fileUtilsNative.dart'
    if (dart.library.html) '../../platform/fileUtilsWeb.dart';

class FileItem extends StatefulWidget {
  final Model.FileItem file;
  FileItem({this.file});

  @override
  _FileItemState createState() => _FileItemState();
}

class _FileItemState extends State<FileItem> {
  bool isHover = false;

  @override
  Widget build(BuildContext context) {
    final removeFile = context.select((Model.HomeNotifier m) => m.removeFile);

    return Container(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        hoverColor: Colors.transparent,
        onTap: () {},
        onHover: (value) {
          if (value) {
            setState(() {
              isHover = true;
            });
          } else {
            setState(() {
              isHover = false;
            });
          }
        },
        child: DottedBorder(
          strokeWidth: 1,
          color: Color(0x33333333),
          customPath: (size) {
            return Path()
              ..moveTo(0, size.height)
              ..lineTo(size.width, size.height);
          },
          child: Container(
            padding: const EdgeInsets.all(8.0),
            child: ListTile(
              leading: genImgWidgetFromPlatformFile(
                  widget.file.platform_file, 60, 60),
              title: Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  width: 30,
                  height: 30,
                  child: TextField(
                    controller: TextEditingController()
                      ..text = String.fromCharCode(widget.file.charcode),
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600),
                    decoration: const InputDecoration(
                      contentPadding: const EdgeInsets.only(bottom: 13, top: 5),
                    ),
                    onChanged: (value) {
                      widget.file.setChar(value);
                    },
                  ),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/images/icon_grid.png"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              trailing: OnHoverImage(
                onTap: () {
                  removeFile(widget.file);
                },
                width: 35,
                height: 24,
                img1: "assets/images/icon_del_normal.png",
                img2: "assets/images/icon_del_hover.png",
              ),
            ),
          ),
        ),
      ),
    );
  }
}
