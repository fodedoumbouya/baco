import 'package:baco/common/coreToast.dart';
import 'package:baco/common/network/network.dart';
import 'package:flutter/material.dart';

abstract class BaseWidget extends StatefulWidget {
  const BaseWidget({super.key});

  @override
  BaseWidgetState createState() {
    return getState();
  }

  BaseWidgetState getState();
}

typedef FunctionVoidCallback = void Function(void o);
typedef FunctionEmptyCallback = void Function();

abstract class BaseWidgetState<T extends BaseWidget> extends State<T>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future toPage(Widget w) {
    return Navigator.of(context).push(MaterialPageRoute(builder: (con) {
      return w;
    }));
  }

  void jumpToPage(Widget w) {
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (con) {
      return w;
    }));
  }

  void pop([Object? o]) {
    Navigator.of(context).pop(o);
  }

  double xx({required double p, required Size s}) {
    return p * s.width / 100;
  }

  double yy({required double p, required Size s}) {
    return p * s.height / 100;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: baseBuild(context),
    );
  }

  baseBuild(BuildContext context) {}

  rebuild() {
    if (mounted) {
      setState(() {});
    }
  }

  Offset getOffsetsPositionsLocal(GlobalKey key) {
    RenderBox box = key.currentContext?.findRenderObject() as RenderBox;
    Offset position = box.localToGlobal(Offset.zero);

    return position;
  }

  getMap(
    String url,
    var callback,
    FunctionVoidCallback errorCallback,
  ) async {
    var res = await DioUtil.globalRequest(
      path: url,
      isGet: true,
      body: {},
      errorCallback: errorCallback,
      networkErrorCallback: (o) {
        CoreToast.showError("Erreur de connection");
      },
    );
    callback(res);
    return res;
  }
}
