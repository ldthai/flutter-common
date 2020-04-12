import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';

class MyAvatar extends StatelessWidget {
  double radius;
  String placeHolder;
  String link;

  MyAvatar(
      {this.radius = 50, this.placeHolder = "assets/avatar.png", this.link});

  @override
  Widget build(BuildContext context) {
    if (placeHolder != null && placeHolder.length > 0)
      return ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: CachedNetworkImage(
          width: radius * 2,
          height: radius * 2,
          fit: BoxFit.cover,
          placeholder: (context, url) => Image.asset(
            "$placeHolder",
            width: radius * 2,
            height: radius * 2,
            fit: BoxFit.cover,
          ),
          imageUrl: "$link",
        ),
      );
    else
      return ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: CachedNetworkImage(
          width: radius * 2,
          height: radius * 2,
          fit: BoxFit.cover,
          imageUrl: "$link",
        ),
      );
  }
}
