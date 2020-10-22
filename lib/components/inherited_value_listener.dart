import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class InheritedWidgetOnValueListener<T, M extends ValueListenable<T>>
    extends InheritedWidget {
  InheritedWidgetOnValueListener({
    Key key,
    @required this.model,
    @required Widget Function(BuildContext, T, Widget) builder,
  }) : super(
            key: key,
            child: ValueListenableBuilder(
                valueListenable: model, builder: builder));

  final M model;

  static InheritedWidgetOnValueListener of<T, M extends ValueListenable<T>>(
      BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<
        InheritedWidgetOnValueListener<T, M>>();
  }

  @override
  bool updateShouldNotify(InheritedWidgetOnValueListener old) => true;
}
