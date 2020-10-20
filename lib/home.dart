import 'package:flutter/material.dart';
import 'package:font_creator/bottom_bar/bottom_bar.dart';
import 'file_list/file_list.dart';
import './model.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Model model = new Model();

  updateModel() {
    setState(() => {
          model: model,
        });
  }

  @override
  Widget build(BuildContext context) {
    final allHeight = MediaQuery.of(context).size.height;
    final bottomHeight = 101.0;
    final space = 34.0;

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
                      fileList: model.fileList,
                      model: model,
                      updateModel: updateModel)),
              SizedBox(height: space),
              Container(
                child: BottomBar(model: model, updateModel: updateModel),
                height: bottomHeight,
              )
            ]),
          )),
    );
  }
}
