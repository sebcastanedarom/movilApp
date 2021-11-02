import 'package:rxdart/rxdart.dart';

class TableroBloc {
  final _posicionesController = BehaviorSubject<List<String>>();
  final _turnoControler = BehaviorSubject<bool>();
  final _primeroControler = BehaviorSubject<bool>();
  final _puntajesControler = BehaviorSubject<List<int>>();

  Stream<List<String>> get posicionesStream => _posicionesController.stream;
  Stream<bool> get turnoStream => _turnoControler.stream;
  Stream<bool> get primeroStream => _primeroControler.stream;
  Stream<List<int>> get puntajesStream => _puntajesControler.stream;

  Function(List<String>) get changePosiciones => _posicionesController.sink.add;
  Function(bool) get changeTurno => _turnoControler.sink.add;
  Function(bool) get changePrimeo => _primeroControler.sink.add;
  Function(List<int>) get changePuntajes => _puntajesControler.sink.add;

  List<String> get posiciones => _posicionesController.value;
  bool get turno => _turnoControler.value;
  bool get primero => _primeroControler.value;
  List<int> get puntajes => _puntajesControler.value;

  dispose() {
    _posicionesController.close();
    _turnoControler.close();
    _primeroControler.close();
    _puntajesControler.close();
  }
}
