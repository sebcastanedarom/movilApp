import 'package:rxdart/rxdart.dart';

class TableroBloc {
  final _posicionesController = BehaviorSubject<List<String>>();
  final _turnoControler = BehaviorSubject<bool>();
  final _primeroControler = BehaviorSubject<bool>();
  final _puntajesControler = BehaviorSubject<List<int>>();
  final _dificultadControler = BehaviorSubject<String>();
  final _muteControler = BehaviorSubject<bool>();
  final _salaControler = BehaviorSubject<String>();
  final _simboloControler = BehaviorSubject<String>();

  Stream<List<String>> get posicionesStream => _posicionesController.stream;
  Stream<bool> get turnoStream => _turnoControler.stream;
  Stream<bool> get primeroStream => _primeroControler.stream;
  Stream<List<int>> get puntajesStream => _puntajesControler.stream;
  Stream<String> get dificultadStream => _dificultadControler.stream;
  Stream<bool> get muteStream => _muteControler.stream;
  Stream<String> get salaStream => _salaControler.stream;
  Stream<String> get simboloStream => _simboloControler.stream;
  Stream<bool> get validateCompleteForm =>
      Rx.combineLatest2(salaStream, simboloStream, (a, b) => true);

  Function(List<String>) get changePosiciones => _posicionesController.sink.add;
  Function(bool) get changeTurno => _turnoControler.sink.add;
  Function(bool) get changePrimeo => _primeroControler.sink.add;
  Function(List<int>) get changePuntajes => _puntajesControler.sink.add;
  Function(String) get changeDificultad => _dificultadControler.sink.add;
  Function(bool) get changeMute => _muteControler.sink.add;
  Function(String) get changeSala => _salaControler.sink.add;
  Function(String) get changeSimbolo => _simboloControler.sink.add;

  List<String> get posiciones => _posicionesController.value;
  bool get turno => _turnoControler.value;
  bool get primero => _primeroControler.value;
  List<int> get puntajes => _puntajesControler.value;
  String get dificultad => _dificultadControler.value;
  bool get mute => _muteControler.value;
  String get sala => _salaControler.value;
  String get simbolo => _simboloControler.value;

  dispose() {
    _posicionesController.close();
    _turnoControler.close();
    _primeroControler.close();
    _puntajesControler.close();
    _dificultadControler.close();
    _muteControler.close();
    _salaControler.close();
    _simboloControler.close();
  }
}
