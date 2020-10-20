import 'package:flutter/material.dart';

tip(BuildContext context, String msg) {
  Scaffold.of(context).showSnackBar(SnackBar(
    content: Text(msg),
  ));
}
