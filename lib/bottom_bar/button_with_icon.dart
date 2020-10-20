import 'package:flutter/material.dart';

class ButtonWithIcon extends StatelessWidget {
  final IconData icon;
  final String label;
  final void Function() onPressed;

  ButtonWithIcon({this.icon, this.label, this.onPressed});

  @override
  build(BuildContext context) {
    return RaisedButton(
        color: Colors.blue,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white),
            SizedBox(width: 8),
            Text(label, style: TextStyle(color: Colors.white))
          ],
        ),
        onPressed: onPressed);
  }
}
