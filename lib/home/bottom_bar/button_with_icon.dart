import 'package:flutter/material.dart';

class ButtonWithIcon extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool loading;
  final void Function() onPressed;

  ButtonWithIcon({this.icon, this.label, this.onPressed, this.loading = false});

  @override
  build(BuildContext context) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: Colors.blue,
          onPrimary: Colors.blue[300],
          shadowColor: Colors.blue,
          elevation: 3,
          padding: EdgeInsets.all(4.0),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          minimumSize: Size(100, 40),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: loading
              ? [
                  SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                      backgroundColor: Colors.grey[200],
                    ),
                  )
                ]
              : [
                  Icon(icon, color: Colors.white, size: 20),
                  SizedBox(width: 8),
                  Text(loading ? "Loading..." : label,
                      style: TextStyle(color: Colors.white))
                ],
        ),
        onPressed: onPressed);
  }
}
