import 'package:flutter/material.dart';

class ProgressHorizontal extends StatelessWidget {
  ProgressHorizontal.build(
      {@required this.width,
      @required this.height,
      this.progress = 0,
      this.color,
      this.colorBg = const Color.fromRGBO(204, 204, 204, 1)});

  final Color color;
  final Color colorBg;
  final int progress;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    double _widthChild;

    if (progress > 100)
      _widthChild = width;
    else if (progress < 0)
      _widthChild = 0;
    else
      _widthChild = (progress / 100) * width;

    return Stack(
      children: <Widget>[
        Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(height / 2),
            color: colorBg,
          ),
        ),
        Container(
          width: _widthChild,
          height: height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(height / 2),
            color: color != null ? color : Theme.of(context).primaryColor,
          ),
        )
      ],
    );
  }
}
