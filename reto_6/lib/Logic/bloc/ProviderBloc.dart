import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:reto_3/Logic/bloc/TableroBloc.dart';

class Provider extends InheritedWidget {
  final _tablero = TableroBloc();
  Provider({required Key key, required Widget child})
      : super(key: key, child: child);

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => true;
  static TableroBloc tableroBloc(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<Provider>()!._tablero;
  }
}
