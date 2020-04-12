import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CircleContainer extends StatelessWidget {
  final double size;
  final double padding;
  final Color bgColor;
  final String child;
  final bool isLocal;

  const CircleContainer({Key key, this.child, this.isLocal=true, this.size=50.0, this.bgColor=Colors.transparent, this.padding=0.0}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return new Container(
      width: size,
      height: size,
      decoration: new BoxDecoration(
        image: DecorationImage(
            image: isLocal ? AssetImage(child) : NetworkImage(child),
            fit: BoxFit.cover
        ),
        color: bgColor,
        shape: BoxShape.circle,
      ),
    );
  }
}