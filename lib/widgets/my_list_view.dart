import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

typedef Future<List> DataRequester(int offset);
//typedef Future<List> InitRequester();
typedef Widget ItemBuilder(List data, BuildContext context, int index);

class MyListView extends StatefulWidget {
  MyListView.build(
      {Key key,
      this.header,
      @required this.itemBuilder,
      @required this.dataRequester,
      this.needLoadMore = true,
      this.textHint = "Không có dữ liệu"})
      : assert(itemBuilder != null),
        assert(dataRequester != null),
        //assert(initRequester != null),
        super(key: key);

  final ItemBuilder itemBuilder;
  final DataRequester dataRequester;

  //final InitRequester initRequester;
  Widget header;
  String textHint;
  bool needLoadMore;

  @override
  State createState() => new MyListViewState();
}

class MyListViewState extends State<MyListView> {
  bool isPerformingRequest = false, isLoading = false;
  ScrollController _controller = new ScrollController();
  List _dataList;

  @override
  void initState() {
    super.initState();
    this.onRefresh();
    _controller.addListener(() {
      if (_controller.position.pixels == _controller.position.maxScrollExtent &&
          widget.needLoadMore) {
        _loadMore();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Color loadingColor = Theme.of(context).primaryColor;
    int size = (_dataList != null ? _dataList.length : 0) +
        1 +
        (widget.header != null ? 1 : 0);
    return this.isLoading
        ? (widget.header == null
            ? loadingProgress(loadingColor)
            : SingleChildScrollView(
                child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  widget.header,
                  Container(
                    padding: EdgeInsets.only(top: 10),
                    child: loadingProgress(loadingColor),
                  )
                ],
              )))
        : (this._dataList != null && this._dataList.length > 0
            ? RefreshIndicator(
                color: loadingColor,
                onRefresh: this.onRefresh,
                child: ListView.builder(
                  itemCount: size,
                  itemBuilder: (context, index) {
                    if (index == size - 1) {
                      return opacityLoadingProgress(
                          isPerformingRequest, loadingColor);
                    } else {
                      if (widget.header != null && index == 0)
                        return widget.header;
                      else
                        return widget.itemBuilder(_dataList, context,
                            index - (widget.header != null ? 1 : 0));
                    }
                  },
                  controller: _controller,
                  padding: EdgeInsets.all(0),
                ),
              )
            : (widget.header == null
                ? Center(child: Text("${widget.textHint}"))
                : SingleChildScrollView(
                    child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      widget.header,
                      Container(
                        padding: EdgeInsets.only(top: 10),
                        child: Center(child: Text("${widget.textHint}")),
                      )
                    ],
                  ))));
  }

  Future<Null> onRefresh() async {
    if (mounted) {
      this.setState(() {
        isLoading = true;
        this._dataList = List();
      });
      List initDataList = await widget.dataRequester(0);
      if (initDataList != null) this._dataList = initDataList;
      isLoading = false;
      this.setState(() {});
    }
    return;
  }

  _loadMore() async {
    if (mounted) {
      this.setState(() => isPerformingRequest = true);
      int currentSize = 0;
      if (_dataList != null) currentSize = _dataList.length;

      List newDataList = await widget.dataRequester(currentSize);
      if (newDataList != null) {
        if (newDataList.length == 0) {
          double edge = 50.0;
          double offsetFromBottom = _controller.position.maxScrollExtent -
              _controller.position.pixels;
          if (offsetFromBottom < edge) {
            _controller.animateTo(
                _controller.offset - (edge - offsetFromBottom),
                duration: new Duration(milliseconds: 500),
                curve: Curves.easeOut);
          }
        } else {
          _dataList.addAll(newDataList);
        }
      }
      if (mounted) this.setState(() => isPerformingRequest = false);
    }
  }

  void insertItem(dynamic item, int index) {
    if (mounted) {
      if (_dataList == null) _dataList = List();
      setState(() {
        _dataList.insert(index, item);
      });
    }
  }

  void addItem(dynamic item) {
    if (mounted) {
      if (_dataList == null) _dataList = List();
      setState(() {
        _dataList.add(item);
      });
    }
  }

  void removeItem(dynamic item) {
    if (mounted) {
      if (_dataList == null) _dataList = List();
      if (_dataList.contains(item))
        setState(() {
          _dataList.remove(item);
        });
    }
  }
  List getData(){
    return this._dataList;
  }
}

Widget loadingProgress(loadingColor) {
  return Center(
    child: CircularProgressIndicator(
      strokeWidth: 2.0,
      valueColor: AlwaysStoppedAnimation<Color>(loadingColor),
    ),
  );
}

Widget opacityLoadingProgress(isPerformingRequest, loadingColor) {
  return new Padding(
    padding: const EdgeInsets.all(8.0),
    child: new Center(
      child: new Opacity(
        opacity: isPerformingRequest ? 1.0 : 0.0,
        child: new CircularProgressIndicator(
          strokeWidth: 2.0,
          valueColor: AlwaysStoppedAnimation<Color>(loadingColor),
        ),
      ),
    ),
  );
}
