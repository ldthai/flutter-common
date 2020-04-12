import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttercommon/utils/app_utils.dart';

class MyImageViewer extends StatefulWidget {
  List<String> images;

  MyImageViewer(this.images);

  @override
  _MyImageViewerState createState() => _MyImageViewerState();
}

class _MyImageViewerState extends State<MyImageViewer> {
  String current;
  PageController pageController;
  CarouselSlider carouselSlider;
  bool showMenu = true;

  @override
  void initState() {
    super.initState();
    pageController = PageController();
    if (widget.images != null && widget.images.length > 0)
      current = widget.images.first;
  }

  @override
  Widget build(BuildContext context) {
    AppUtils appUtils = AppUtils(context);
    return Container(
      width: double.maxFinite,
      height: double.maxFinite,
      color: Colors.black,
      child: Stack(
        children: <Widget>[
          GestureDetector(
            onTap: () {
              setState(() {
                showMenu = !showMenu;
              });
            },
            child: buildSlideFull(),
          ),
          showMenu ? buildMenuTop() : Container(),
          showMenu ? buildSlideMini() : Container()
        ],
      ),
    );
  }

  buildSlideFull() {
    if (widget.images != null && widget.images.length > 0) {
      carouselSlider = CarouselSlider(
        height: double.maxFinite,
        viewportFraction: 1.0,
        enableInfiniteScroll: true,
        enlargeCenterPage: true,
        items: widget.images
            .map<Widget>((String imageUrl) => buildImageFull(imageUrl))
            .toList(),
        onPageChanged: (index) {
          setState(() {
            current = widget.images[index];
          });
        },
      );
      return carouselSlider;
    } else
      return Container();
  }

  buildSlideMini() {
    if (widget.images != null && widget.images.length > 0) {
      return Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            height: 100,
            width: double.maxFinite,
            decoration: BoxDecoration(color: Colors.black.withOpacity(0.4)),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: widget.images.length,
              itemBuilder: (ct, index) => buildImageMini(widget.images[index]),
              scrollDirection: Axis.horizontal,
            ),
          ));
    } else
      return Container();
  }

  buildMenuTop() {
    return Container(
      padding: EdgeInsets.only(
          bottom: 10,
          left: 10,
          right: 10,
          top: AppUtils.getInstance().statusBarHeight + 10),
      decoration: BoxDecoration(color: Colors.black.withOpacity(0.4)),
      child: Row(
        children: <Widget>[
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Platform.isAndroid ? Icons.arrow_back : Icons.arrow_back_ios,
              color: Colors.white,
            ),
          )
        ],
      ),
    );
  }

  buildImageFull(String imageUrl) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      placeholder: (context, link) => Center(
        child: CircularProgressIndicator(
          strokeWidth: 1,
        ),
      ),
      width: double.maxFinite,
      height: double.maxFinite,
      fit: BoxFit.contain,
    );
  }

  buildImageMini(String imageUrl) {
    if (widget.images != null && widget.images.length > 1)
      return GestureDetector(
          onTap: () {
            setState(() {
              current = imageUrl;
            });
            if (carouselSlider != null) {
              carouselSlider.jumpToPage(widget.images.indexOf(imageUrl));
            }
          },
          child: Container(
              margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
              decoration: BoxDecoration(
                  border: Border.all(
                      color:
                          imageUrl == current ? Colors.amber : Colors.white)),
              child: CachedNetworkImage(
                imageUrl: imageUrl,
                width: 100,
                height: double.maxFinite,
                fit: BoxFit.cover,
              )));
    return Container();
  }
}
