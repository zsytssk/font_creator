import 'package:font_creator/components/on_hover.dart';
import 'package:flutter/material.dart';

class OnHoverImage extends OnHover {
  final double width;
  final double height;
  final String img1;
  final String img2;

  OnHoverImage({this.img1, this.img2, this.width, this.height, Function onTap})
      : super(
          onTap: onTap,
          child1: Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(img1),
                fit: BoxFit.cover,
              ),
            ),
          ),
          child2: Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(img2),
                fit: BoxFit.cover,
              ),
            ),
          ),
        );
}
