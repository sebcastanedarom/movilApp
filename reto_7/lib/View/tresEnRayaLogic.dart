import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:reto_3/Logic/bloc/TableroBloc.dart';

class Posiciones {
  final List<String> posiciones;
  final String sala;
  final String simbolo;
  Posiciones(this.posiciones, this.sala, this.simbolo);

  Posiciones.fromJson(Map<dynamic, dynamic> json)
      : posiciones = [
          json['p0'],
          json['p1'],
          json['p2'],
          json['p3'],
          json['p4'],
          json['p5'],
          json['p6'],
          json['p7'],
          json['p8'],
        ],
        sala = json['sala'],
        simbolo = json['simbolo'];

  Map<dynamic, dynamic> toJson() => <dynamic, dynamic>{
        'sala': sala,
        'simbolo': simbolo,
        'p0': posiciones[0],
        'p1': posiciones[1],
        'p2': posiciones[2],
        'p3': posiciones[3],
        'p4': posiciones[4],
        'p5': posiciones[5],
        'p6': posiciones[6],
        'p7': posiciones[7],
        'p8': posiciones[8],
      };
}

class PosicionesDao {
  final String sala;
  PosicionesDao(this.sala);
  final DatabaseReference _reference =
      FirebaseDatabase.instance.ref().child('posiciones');
  void guardarPosicione(Posiciones posiciones) {
    _reference.child(sala).push().set(posiciones.toJson());
  }

  Query getPosiciones() {
    return _reference.child(sala);
  }
}
