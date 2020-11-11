import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:fluttertoast/fluttertoast.dart';

import 'package:url_launcher/url_launcher.dart';

Widget getPadding(Widget child) {
  return Padding(
    padding: EdgeInsets.all(15),
    child: child,
  );
}

Widget userInputTextField(TextEditingController controller, String hintText,
    bool isObscure, String errorText, String labelText) {
  return Padding(
    padding: const EdgeInsets.all(10.0),
    child: TextFormField(
      controller: controller,
      keyboardType: TextInputType.phone,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(
            fontSize: 15, fontWeight: FontWeight.w200, color: Colors.black),
        hintStyle: TextStyle(color: Colors.black),
        hintText: hintText,
        focusedBorder: _makeOutlineBorder(5, Colors.deepPurple),
        enabledBorder: _makeOutlineBorder(5, Colors.deepPurple),
      ),
      obscureText: isObscure,
    ),
  );
}

OutlineInputBorder _makeOutlineBorder(double radius, Color color) {
  return OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(radius)),
      borderSide: BorderSide(width: 2, color: color));
}

Widget makeCardView(
    double radius, double width, double height, Widget child, Function action) {
  return Container(
    width: width,
    height: height,
    child: Card(
      color: Colors.deepPurple,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(radius)),
      ),
      child: InkWell(
        splashColor: Colors.blue,
        onTap: () async {
          action();
        },
        child: Center(child: child),
      ),
    ),
  );
}

Widget makeGoogleCardView(
    double radius, double width, double height, Function action) {
  return Container(
      width: width,
      height: height,
      child: GestureDetector(
        onTap: () async {
          action();
        },
        child: Card(
          color: Colors.red,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(radius)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Icon(
                Icons.location_searching,
                color: Colors.white,
              ),
              Text(
                "Log in with Google",
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.w300),
              )
            ],
          ),
        ),
      ));
}

TextStyle getHeadingTextStyle() {
  return TextStyle(
      fontSize: 50, fontWeight: FontWeight.w200, color: Colors.black);
}

TextStyle getSubHeadingTextStyle() {
  return TextStyle(
      fontSize: 20, fontWeight: FontWeight.w200, color: Colors.black);
}

void makeFullScreenUi() {
  SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
}

class FieldDivider extends StatelessWidget {
  final String fieldCat;
  final Color color;
  final double size;
  const FieldDivider(this.fieldCat, {this.color = Colors.purple, this.size});
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Divider(
            color: color,
            thickness: 1.5,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            fieldCat,
            style: TextStyle(fontStyle: FontStyle.italic, fontSize: size),
          ),
        ),
        Expanded(
          child: Divider(
            thickness: 1.5,
            color: color,
          ),
        )
      ],
    );
  }
}


class DetailsTextField extends StatefulWidget {
  final String labelText;
  final TextInputType textInputType;
  final int maxLines;
  final controller;
  DetailsTextField(
      {this.labelText, this.textInputType, this.maxLines, this.controller});
  @override
  _DetailsTextFieldState createState() => _DetailsTextFieldState();
}

class _DetailsTextFieldState extends State<DetailsTextField> {
  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
          child: TextFormField(
            validator: (value) {
              if (value.isEmpty) {
                return "All fields are mandatory";
              }
              return null;
            },
            maxLines: widget.maxLines,
            enableInteractiveSelection: true,
            keyboardType: widget.textInputType,
            controller: widget.controller,
            decoration: InputDecoration(
                labelText: widget.labelText,
                hintText: widget.labelText,
                focusedErrorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red),
                    borderRadius: BorderRadius.all(Radius.circular(5))),
                errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red),
                    borderRadius: BorderRadius.all(Radius.circular(5))),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue, width: 2),
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                ),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    borderSide: BorderSide(color: Colors.black, width: 2))),
          ),
        ),
      ),
    );
  }
}

class Heading extends StatelessWidget {
  final String heading;
  final Color color;
  final double fontSize;
  final FontWeight fontW;

  const Heading({Key key, this.heading, this.color, this.fontSize, this.fontW})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Text(
        heading,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: color,
          fontWeight: (this.fontW != null) ? fontW : FontWeight.w200,
          fontSize: (fontSize == null) ? 50 : fontSize,
        ),
      ),
    );
  }
}

class SegmentCard extends StatefulWidget {
  final Widget child;
  final String sectionTitle;
  final double headingFontSize;
  final FontWeight titleTextWeight;
  const SegmentCard(
      {Key key,
      this.sectionTitle,
      this.child,
      this.headingFontSize,
      this.titleTextWeight})
      : super(key: key);

  @override
  _SegmentCardState createState() => _SegmentCardState();
}

class _SegmentCardState extends State<SegmentCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: Card(
          child: Column(
            children: [
              (widget.sectionTitle != null)
                  ? Heading(
                      fontSize: widget.headingFontSize,
                      heading: widget.sectionTitle,
                      color: Colors.black,
                      fontW: widget.titleTextWeight,
                    )
                  : Text("Test"),
              (widget.child != null) ? widget.child : Container(),
            ],
          ),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10))),
        ),
      ),
    );
  }
}

raiseErrorForNoPictureSelected() {
  Fluttertoast.showToast(
      msg: "Picture not selected ",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0);
}



class CallButton extends StatelessWidget {
  final Function action;
  final String phoneNumber;
  const CallButton({Key key, this.action,@required this.phoneNumber}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 100,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          color: Colors.green,
          elevation: 3,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10))),
          child: InkWell(
            splashColor: Colors.blue,
            onTap: () {
              launch(
                  "tel:+91${phoneNumber}");
            },
            child: Center(
                child: Text(
              "Call",
              style: TextStyle(
                  fontSize: 30,
                  color: Colors.white,
                  fontWeight: FontWeight.w200),
            )),
          ),
        ),
      ),
    );
  }
}

