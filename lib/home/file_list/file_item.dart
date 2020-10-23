import 'package:flutter/material.dart';
import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:font_creator/components/on_hover_image.dart';
import 'package:font_creator/components/inherited_value_listener.dart';
import 'package:font_creator/home/home_model.dart' as Model;

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
    final model =
        InheritedWidgetOnValueListener.of<Model.HomeData, Model.HomeNotifier>(
                context)
            .model as Model.HomeNotifier;
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
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Image.file(
                        File(widget.file.path),
                        width: 60,
                        height: 60,
                      ),
                      SizedBox(width: 20),
                      Container(
                        width: 30,
                        height: 30,
                        child: TextField(
                          controller: TextEditingController()
                            ..text = String.fromCharCode(widget.file.charcode),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.w600),
                          decoration: const InputDecoration(
                            contentPadding:
                                const EdgeInsets.only(bottom: 13, top: 5),
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
                    ],
                  ),
                  if (isHover)
                    OnHoverImage(
                      onTap: () {
                        model.removeFile(widget.file);
                      },
                      width: 35,
                      height: 24,
                      img1: "assets/images/icon_del_normal.png",
                      img2: "assets/images/icon_del_hover.png",
                    )
                ]),
          ),
        ),
      ),
    );
  }
}
