import 'package:flutter/material.dart';
import 'package:font_creator/components/inherited_value_listener.dart';

import 'package:font_creator/home/bottom_bar/bottom_bar.dart';
import 'package:font_creator/home/file_list/file_list.dart';
import 'home_model.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    final allHeight = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top -
        MediaQuery.of(context).padding.bottom;
    final bottomHeight = 101.0;
    final space = 34.0;

    return SafeArea(
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.white,
          body: InheritedWidgetOnValueListener(
              model: HomeNotifier(HomeData()),
              builder: (BuildContext context, HomeData model, _) {
                return Container(
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
                          fileList: model.fileList,
                        )),
                    SizedBox(height: space),
                    Container(
                      child: BottomBar(),
                      height: bottomHeight,
                    )
                  ]),
                );
              })),
    );
  }
}
