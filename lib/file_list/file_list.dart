import 'package:flutter/material.dart';
import 'package:font_creator/file_list/file_item.dart';
import 'package:font_creator/model.dart' as Model;

class FileList extends StatelessWidget {
  final List<Model.FileItem> fileList;
  final Model.Model model;
  final Function updateModel;
  FileList({this.fileList, this.model, this.updateModel});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xc8cadc),
      child: ListView.builder(
          itemCount: fileList.length,
          itemBuilder: (BuildContext context, int index) {
            return FileItem(
                file: fileList[index], model: model, updateModel: updateModel);
          }),
    );
  }
}
