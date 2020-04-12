import 'package:flutter/material.dart';

class DialogListSelection extends StatefulWidget {
  List<ItemModel> data;

  DialogListSelection(this.data);

  @override
  _ListDialogState createState() => _ListDialogState();

  static Future<ItemModel> show(
      BuildContext context, List<ItemModel> items) async {
    return await showDialog(
        context: context,
        builder: (context) {
          return DialogListSelection(items);
        });
  }
}

class _ListDialogState extends State<DialogListSelection> {
  @override
  Widget build(BuildContext context) {
    var body = GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Scaffold(
            backgroundColor: Colors.transparent,
            body: GestureDetector(
                onTap: () {},
                child: Align(
                    alignment: Alignment.center,
                    child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        width: double.infinity,
                        margin: EdgeInsets.only(left: 40, right: 40),
                        padding: EdgeInsets.only(top: 20, bottom: 20),
                        child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children:
                                widget.data != null && widget.data.length > 0
                                    ? widget.data.map((ItemModel model) {
                                        return GestureDetector(
                                            onTap: () {
                                              Navigator.of(context).pop(model);
                                            },
                                            child: Container(
                                              width: double.maxFinite,
                                              color: Colors.white,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  SizedBox(height: 10),
                                                  Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 20, right: 20),
                                                      child: Text(model.title)),
                                                  SizedBox(height: 10),
                                                  Container(
                                                    margin: EdgeInsets.only(
                                                        left: 20, right: 20),
                                                    color: Colors.black12,
                                                    height: 1,
                                                  )
                                                ],
                                              ),
                                            ));
                                      }).toList()
                                    : []))))));
    return Scaffold(backgroundColor: Colors.transparent, body: body);
  }
}

class ItemModel {
  String title;
  dynamic value;

  ItemModel({this.title, this.value});
}
