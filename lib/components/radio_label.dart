import 'package:flutter/material.dart';

class RadioLabel<T> extends StatelessWidget {
  final T value;
  final T groupValue;
  final ValueChanged<T> onChanged;
  final String label;
  RadioLabel({this.value, this.groupValue, this.onChanged, this.label});

  @override
  build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          onChanged(value);
        },
        child: Row(children: [
          Container(
            width: 20,
            height: 20,
            child: Transform.scale(
              scale: .6,
              child: Radio(
                  value: value,
                  groupValue: groupValue,
                  onChanged: (T value) {
                    onChanged(value);
                  }),
            ),
          ),
          Text(label, style: TextStyle(fontSize: 12)),
        ]));
  }
}
