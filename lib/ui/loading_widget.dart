
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

typedef T Func0<T>();

class LoadingWidget  extends StatelessWidget {
  final bool isLoading;
  final Func0<Widget> onCompleted;

  LoadingWidget({Key key, @required this.isLoading, @required this.onCompleted}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return new Center(
        child: new CircularProgressIndicator(),
      );
      }else{
        return onCompleted();
    }
  }
}
