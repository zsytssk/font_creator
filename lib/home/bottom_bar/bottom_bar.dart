import 'package:flutter/material.dart';
import 'package:font_creator/components/radio_label.dart';
import 'package:font_creator/home/bottom_bar/button_with_icon.dart';
import 'package:font_creator/home/home_model.dart';
import 'package:font_creator/utils/toast.dart';
import 'package:provider/provider.dart';

const textStyle = TextStyle(fontSize: 12);

class BottomBar extends StatelessWidget {
  BottomBar();

  @override
  Widget build(BuildContext context) {
    final model = context.watch<HomeNotifier>();
    ;
    return Row(
      children: [
        Container(
            margin: EdgeInsets.only(left: 10),
            width: 120,
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(
                children: [
                  Text('字号：', style: textStyle),
                  Container(
                    width: 50,
                    height: 30,
                    child: TextField(
                      style: TextStyle(fontSize: 12),
                      controller: TextEditingController()
                        ..text = model.value.fontSize.toString(),
                      decoration: InputDecoration(
                          contentPadding:
                              const EdgeInsets.only(bottom: 18, top: 0),
                          border: InputBorder.none,
                          hintText: '--'),
                    ),
                  )
                ],
              ),
              Text('字体类型', style: textStyle),
              Container(
                child: RadioLabel(
                  value: FontType.XML,
                  groupValue: model.value.fontType,
                  label: 'XML(Laya)',
                  onChanged: (FontType value) {
                    model.setFontType(value);
                  },
                ),
              ),
              Container(
                child: RadioLabel(
                  value: FontType.TEXT,
                  groupValue: model.value.fontType,
                  label: 'Text(Cocos2d)',
                  onChanged: (FontType value) {
                    model.setFontType(value);
                  },
                ),
              ),
            ])),
        Expanded(
          flex: 1,
          child: Container(
              width: 310,
              margin: EdgeInsets.only(right: 10),
              child: Column(
                children: [
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text('间距'),
                            SizedBox(width: 5),
                            Container(
                              width: 50,
                              height: 20,
                              child: TextField(
                                textAlign: TextAlign.center,
                                controller: TextEditingController()
                                  ..text = model.value.space.toString(),
                                decoration: InputDecoration(
                                  contentPadding:
                                      const EdgeInsets.only(bottom: 20, top: 0),
                                ),
                                keyboardType: TextInputType.number,
                                onChanged: (value) {
                                  model.setSpace(int.parse(value));
                                },
                              ),
                            ),
                          ],
                        ),
                        InkWell(
                            onTap: () {
                              model.clear();
                            },
                            child: Text('删除全部'))
                      ]),
                  SizedBox(height: 10),
                  Container(
                      height: 70,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                                flex: 1,
                                child: SizedBox(
                                    height: 40,
                                    child: ButtonWithIcon(
                                        onPressed: () {
                                          model.uploadFile().then((value) {
                                            return value;
                                          });
                                        },
                                        icon: Icons.add,
                                        label: '上传图片'))),
                            SizedBox(width: 10),
                            Expanded(
                                flex: 1,
                                child: SizedBox(
                                    height: 40,
                                    child: ButtonWithIcon(
                                        onPressed: () {
                                          model.onCombine().then((_val) {
                                            tip(context, '合并图片成功');
                                          });
                                        },
                                        icon: Icons.publish,
                                        label: '生成字体'))),
                          ]))
                ],
              )),
        ),
      ],
    );
  }
}
