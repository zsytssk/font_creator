import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:font_creator/home/bottom_bar/bottom_bar.dart';
import 'package:font_creator/home/file_list/file_list.dart';
import 'home_model.dart';

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final allHeight = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top -
        MediaQuery.of(context).padding.bottom;
    final bottomHeight = 101.0;
    final space = 34.0;
    final model = context.watch<HomeNotifier>();

    return SafeArea(
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.white,
          body: Container(
            child: Column(children: [
              Container(
                  margin: EdgeInsets.all(10),
                  height: allHeight - bottomHeight - space - 20,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Color.fromRGBO(200, 202, 220, 200),
                      border: Border.all(
                        color: Colors.blueAccent,
                        width: 1,
                      )),
                  child: FileList(
                    fileList: model == null ? [] : model.value.fileList,
                  )),
              SizedBox(height: space),
              Container(
                child: BottomBar(),
                height: bottomHeight,
              )
            ]),
          )),
    );
  }
}
