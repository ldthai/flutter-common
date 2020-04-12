import 'package:flutter/material.dart';

class VoteStar extends StatelessWidget {
  VoteStar.build(
      {@required this.width,
      @required this.height,
      @required this.space,
      @required this.star});

  final double width;
  final double height;
  final double star;
  final double space;

  @override
  Widget build(BuildContext context) {
    var _widthAll = width * 5 + space * 4;
    var _widthRs;

    if(star > 5) _widthRs = _widthAll;
    else
      if(star > 4) _widthRs = width * 4 + space * 4 + (star - 4) * width ;
      else
        if(star > 3) _widthRs = width * 3 + space * 3 + (star - 3) * width ;
        else
          if(star > 2) _widthRs = width * 2 + space * 2 + (star - 2) * width ;
          else
            if(star > 1) _widthRs = width + space + (star - 1) * width ;
            else
              if(star >= 0) _widthRs = star * width ;
              else _widthRs = 0;


    return Container(
      width: _widthAll,
      height: height,
      child: Stack(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _imageStar(isGray: true),
              _sizedBoxSpace(),
              _imageStar(isGray: true),
              _sizedBoxSpace(),
              _imageStar(isGray: true),
              _sizedBoxSpace(),
              _imageStar(isGray: true),
              _sizedBoxSpace(),
              _imageStar(isGray: true),
            ],
          ),
          Stack(
            children: <Widget>[
              Container(
                width: _widthRs,
                height: height,
                child: FittedBox(
                  fit: BoxFit.fitHeight,
                  alignment: Alignment.centerLeft,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      _imageStar(),
                      _sizedBoxSpace(),
                      _imageStar(),
                      _sizedBoxSpace(),
                      _imageStar(),
                      _sizedBoxSpace(),
                      _imageStar(),
                      _sizedBoxSpace(),
                      _imageStar(),
                    ],
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  _sizedBoxSpace() => SizedBox(
        width: space,
      );

  _imageStar({bool isGray = false}) => Image.asset(
        isGray ? 'assets/icons/star_gray.png' : 'assets/icons/star.png',
        height: height,
        width: width,
        fit: BoxFit.fill,
      );
}
