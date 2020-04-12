import 'package:flutter/material.dart';

class CustomSwitch extends StatefulWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final Color activeColor;
  final Color inactiveColor;
  final String activeText;
  final String inactiveText;
  final Color activeTextColor;
  final Color inactiveTextColor;
  final double width;
  final double height;
  final double radius;

  const CustomSwitch({
    Key key,
    this.value,
    this.onChanged,
    this.activeColor = Colors.grey,
    this.inactiveColor,
    this.activeText = 'On',
    this.inactiveText = 'Off',
    this.activeTextColor = Colors.white70,
    this.inactiveTextColor = Colors.white70,
    this.width=70.0,
    this.height=35.0,
    this.radius=20.0})
      : super(key: key);

  @override
  _CustomSwitchState createState() => _CustomSwitchState();
}

class _CustomSwitchState extends State<CustomSwitch>
    with SingleTickerProviderStateMixin {
  Animation _circleAnimation;
  AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 60));
    _circleAnimation = AlignmentTween(
        begin: widget.value ? Alignment.centerRight : Alignment.centerLeft,
        end: widget.value ? Alignment.centerLeft : Alignment.centerRight)
        .animate(CurvedAnimation(
        parent: _animationController, curve: Curves.linear));
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return GestureDetector(
          onTap: () {
            if (_animationController.isCompleted) {
              _animationController.reverse();
            } else {
              _animationController.forward();
            }
            widget.value == false
                ? widget.onChanged(true)
                : widget.onChanged(false);
            print(_circleAnimation.value);
          },
          child: Container(
            width: widget.width,
            height: widget.height,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(widget.radius),
                color: _circleAnimation.value == Alignment.centerLeft
                    ? widget.inactiveColor
                    : widget.activeColor),
            child: Padding(
              padding: const EdgeInsets.all(2),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  _circleAnimation.value == Alignment.centerRight ?
                  Container(width: 1,) : Align(
                    alignment: _circleAnimation.value,
                    child: Container(
                      width: widget.height - 4,
                      height: widget.height - 4,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle, color: Colors.white),
                    ),
                  ),
                  Expanded(
                    child:_circleAnimation.value == Alignment.centerLeft ?
                    Container(width: 1,): Align(
                      alignment: _circleAnimation.value,
                      child: Container(
                        width: widget.height - 4,
                        height: widget.height - 4,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}