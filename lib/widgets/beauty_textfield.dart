import 'package:flutter/material.dart';

class BeautyTextfield extends StatefulWidget {
  final BorderRadius cornerRadius;
  final double width, height, wordSpacing, fontSize;
  final Color backgroundColor, accentColor, textColor, textHintColor;
  final String placeholder, fontFamily;
  final Icon prefixIcon, suffixIcon;
  final TextInputType inputType;
  final EdgeInsets margin;
  final Duration duration;
  final VoidCallback onClickSuffix;
  final TextBaseline textBaseline;
  final FontStyle fontStyle;
  final FontWeight fontWeight;
  final bool autofocus, autocorrect, enabled, obscureText, isShadow;
  final FocusNode focusNode;
  final int maxLength, minLines, maxLines;
  final ValueChanged<String> onChanged, onSubmitted;
  final GestureTapCallback onTap;
  final TextEditingController controller;
  final TextInputAction textInputAction;

  const BeautyTextfield(
      {@required this.width,
      @required this.height,
      this.prefixIcon,
      @required this.inputType,
      this.suffixIcon,
      this.duration = const Duration(milliseconds: 500),
      this.margin = const EdgeInsets.all(0),
      this.obscureText = false,
      this.backgroundColor = const Color.fromRGBO(255, 255, 255, 1),
      this.cornerRadius = const BorderRadius.all(Radius.circular(10)),
      this.textColor = Colors.black,
      this.accentColor = Colors.white,
      this.placeholder = "Placeholder",
      this.textHintColor = const Color.fromRGBO(153, 153, 153, 1),
      this.isShadow = true,
      this.onClickSuffix,
      this.wordSpacing,
      this.textBaseline,
      this.fontFamily,
      this.fontStyle,
      this.fontWeight,
      this.autofocus = false,
      this.autocorrect = false,
      this.focusNode,
      this.enabled = true,
      this.maxLength,
      this.maxLines = 1,
      this.minLines,
      this.onChanged,
      this.onTap,
      this.onSubmitted,
      this.fontSize = 18,
      this.controller,
      this.textInputAction = TextInputAction.done})
      : assert(width != null),
        assert(height != null),
        assert(inputType != null);

  @override
  _BeautyTextfieldState createState() => _BeautyTextfieldState();
}

class _BeautyTextfieldState extends State<BeautyTextfield> {
  bool isFocus = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      width: widget.width,
      height: widget.height,
      margin: widget.margin,
      alignment: Alignment.centerRight,
      decoration: BoxDecoration(
          boxShadow: widget.isShadow
              ? [BoxShadow(color: Colors.grey, blurRadius: 2, spreadRadius: 1)]
              : BoxShadow(spreadRadius: 0, blurRadius: 0),
          borderRadius: widget.cornerRadius,
          color: widget.suffixIcon == null
              ? isFocus ? widget.accentColor : widget.backgroundColor
              : widget.backgroundColor),
      child: Stack(
        children: <Widget>[
          widget.suffixIcon == null
              ? Container()
              : Align(
                  alignment: Alignment.centerRight,
                  child: AnimatedContainer(
                    width: isFocus ? 500 : 40,
                    height: isFocus ? widget.height : 40,
                    margin: EdgeInsets.only(right: isFocus ? 0 : 7),
                    duration: widget.duration,
                    decoration: BoxDecoration(
                      borderRadius: isFocus
                          ? widget.cornerRadius
                          : BorderRadius.all(Radius.circular(60)),
                      color: widget.accentColor,
                    ),
                  ),
                ),
          widget.suffixIcon == null
              ? Container()
              : GestureDetector(
                  onTap: () {
                    setState(() {
                      isFocus ? isFocus = false : isFocus = true;
                      if (widget.onClickSuffix != null) {
                        widget.onClickSuffix();
                      }
                    });
                  },
                  child: Container(
                    margin: EdgeInsets.only(right: 15),
                    alignment: Alignment.centerRight,
                    child: widget.suffixIcon,
                  ),
                ),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                widget.prefixIcon != null
                    ? Expanded(
                        flex: 1,
                        child: widget.prefixIcon,
                      )
                    : Container(
                        width: widget.cornerRadius.topLeft.x,
                      ),
                Expanded(
                  flex: 5,
                  child: Container(
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.only(
                        right: widget.suffixIcon == null
                            ? widget.cornerRadius.topRight.x
                            : 50),
                    child: TextField(
                      textAlignVertical: TextAlignVertical.center,
                      cursorWidth: 2,
                      obscureText: widget.obscureText,
                      keyboardType: widget.inputType,
                      controller: widget.controller,
                      style: TextStyle(
                        fontFamily: widget.fontFamily,
                        fontStyle: widget.fontStyle,
                        fontWeight: widget.fontWeight,
                        wordSpacing: widget.wordSpacing,
                        textBaseline: widget.textBaseline,
                        fontSize: widget.fontSize,
                        letterSpacing: 2,
                        color: widget.textColor,
                      ),
                      autofocus: widget.autofocus,
                      autocorrect: widget.autocorrect,
                      focusNode: widget.focusNode,
                      enabled: widget.enabled,
                      maxLength: widget.maxLength,
                      maxLines: widget.maxLines,
                      minLines: widget.minLines,
                      onChanged: widget.onChanged,
                      onTap: () {
                        setState(() {
                          isFocus = true;
                        });
                        if (widget.onTap != null) {
                          widget.onTap();
                        }
                      },
                      onSubmitted: (t) {
                        setState(() {
                          isFocus = false;
                        });
                        widget.onSubmitted(t);
                      },
                      textInputAction: widget.textInputAction,
                      decoration: InputDecoration(
                          hintStyle: TextStyle(color: widget.textHintColor),
                          hintText: widget.placeholder,
                          contentPadding: EdgeInsets.all(0),
                          border: InputBorder.none),
                      cursorColor: widget.textColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      duration: widget.duration,
    );
  }
}
