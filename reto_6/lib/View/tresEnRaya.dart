import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart';
import 'package:reto_3/Logic/bloc/ProviderBloc.dart';
import 'package:reto_3/Logic/bloc/TableroBloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TresEnRaya extends StatefulWidget {
  TresEnRaya();
  @override
  _TresEnRayaState createState() => _TresEnRayaState();
}

class _TresEnRayaState extends State<TresEnRaya> {
  late AudioPlayer pjMusic;
  late AudioPlayer pcMusic;

  @override
  void initState() {
    super.initState();
    pjMusic = AudioPlayer();
    pcMusic = AudioPlayer();
  }

  @override
  void dispose() {
    pjMusic.dispose();
    pcMusic.dispose();
    super.dispose();
  }

  void play() async {
    await pjMusic.setAsset('assets/Fun-Bass-Loop.mp3');
    await pcMusic.setAsset('assets/Battle Theme.mp3');
    pjMusic.play();
    pjMusic.setLoopMode(LoopMode.all);
    pcMusic.setLoopMode(LoopMode.all);
    pjMusic.setSpeed(1);
    pjMusic.setVolume(1);
    pcMusic.setVolume(1);
    pcMusic.pause();
  }

  @override
  Widget build(BuildContext context) {
    play();
    return Provider(
      key: UniqueKey(),
      child: StreamBuilder<Object>(
          stream: null,
          builder: (context, snapshot) {
            TableroBloc tableroBloc = Provider.tableroBloc(context);
            tableroBloc.changeTurno(true);
            tableroBloc.changePosiciones(
                [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ']);
            tableroBloc.changePrimeo(true);
            tableroBloc.changePuntajes([0, 0, 0]);

            tableroBloc.changeDificultad('Experto');
            tableroBloc.changeMute(false);
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              home: StreamBuilder<Object>(
                  stream: tableroBloc.turnoStream,
                  builder: (context, snapshot) {
                    // ignore: unrelated_type_equality_checks
                    if (snapshot.stackTrace == false) {
                      setState(() {});
                    }
                    return Scaffold(
                      appBar: AppBar(
                        title: Title(tableroBloc: tableroBloc),
                      ),
                      body: Container(
                        child: OrientationBuilder(
                          builder:
                              (BuildContext context, Orientation orientation) {
                            return Container(
                              child: orientation == Orientation.portrait
                                  ? BodyPortair(
                                      pjMusic: pjMusic, pcMusic: pcMusic)
                                  : BodyLandscape(
                                      pjMusic: pjMusic, pcMusic: pcMusic),
                            );
                          },
                        ),
                      ),
                      bottomNavigationBar: StreamBuilder<Object>(
                          stream: tableroBloc.puntajesStream,
                          builder: (context, snapshot) {
                            return BottomBar(pjMusic, pcMusic);
                          }),
                    );
                  }),
            );
          }),
    );
  }
}

class Title extends StatefulWidget {
  const Title({
    Key? key,
    required this.tableroBloc,
  }) : super(key: key);

  final TableroBloc tableroBloc;

  @override
  State<Title> createState() => _TitleState();
}

class _TitleState extends State<Title> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) => getData(context));
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Text(
          'Tres en Raya \nJugador: ${widget.tableroBloc.puntajes[0].toString()} PC: ${widget.tableroBloc.puntajes[1].toString()} Empate: ${widget.tableroBloc.puntajes[2].toString()}',
        ),
        FloatingActionButton(
          child: Icon(Icons.rotate_left),
          onPressed: () {
            final isPortatir =
                MediaQuery.of(context).orientation == Orientation.portrait;
            if (isPortatir) {
              setLandscape();
            } else {
              setPortair();
            }
          },
        ),
      ],
    );
  }

  void getData(context) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    int jugador = preferences.getInt('jugador') ?? 0;
    int pc = preferences.getInt('pc') ?? 0;
    int empate = preferences.getInt('empate') ?? 0;
    TableroBloc tableroBloc = Provider.tableroBloc(context);
    tableroBloc.changePuntajes([jugador, pc, empate]);
    setState(() {});
  }

  Future setPortair() async => await SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);

  Future setLandscape() async => await SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
}

class BodyPortair extends StatelessWidget {
  const BodyPortair({
    Key? key,
    required this.pjMusic,
    required this.pcMusic,
  }) : super(key: key);

  final AudioPlayer pjMusic;
  final AudioPlayer pcMusic;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Row(
            children: [
              Expanded(
                child: Boton(0, pjMusic, pcMusic),
              ),
              Expanded(
                child: Boton(1, pjMusic, pcMusic),
              ),
              Expanded(
                child: Boton(2, pjMusic, pcMusic),
              ),
            ],
          ),
        ),
        Expanded(
          child: Row(
            children: [
              Expanded(
                child: Boton(3, pjMusic, pcMusic),
              ),
              Expanded(
                child: Boton(4, pjMusic, pcMusic),
              ),
              Expanded(
                child: Boton(5, pjMusic, pcMusic),
              ),
            ],
          ),
        ),
        Expanded(
          child: Row(
            children: [
              Expanded(
                child: Boton(6, pjMusic, pcMusic),
              ),
              Expanded(
                child: Boton(7, pjMusic, pcMusic),
              ),
              Expanded(
                child: Boton(8, pjMusic, pcMusic),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class BodyLandscape extends StatelessWidget {
  const BodyLandscape({
    Key? key,
    required this.pjMusic,
    required this.pcMusic,
  }) : super(key: key);

  final AudioPlayer pjMusic;
  final AudioPlayer pcMusic;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Row(
            children: [
              Expanded(
                child: Boton(0, pjMusic, pcMusic),
              ),
              Expanded(
                child: Boton(1, pjMusic, pcMusic),
              ),
              Expanded(
                child: Boton(2, pjMusic, pcMusic),
              ),
            ],
          ),
        ),
        Expanded(
          child: Row(
            children: [
              Expanded(
                child: Boton(3, pjMusic, pcMusic),
              ),
              Expanded(
                child: Boton(4, pjMusic, pcMusic),
              ),
              Expanded(
                child: Boton(5, pjMusic, pcMusic),
              ),
            ],
          ),
        ),
        Expanded(
          child: Row(
            children: [
              Expanded(
                child: Boton(6, pjMusic, pcMusic),
              ),
              Expanded(
                child: Boton(7, pjMusic, pcMusic),
              ),
              Expanded(
                child: Boton(8, pjMusic, pcMusic),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class BottomBar extends StatefulWidget {
  final AudioPlayer pjMusic;
  final AudioPlayer pcMusic;
  BottomBar(this.pjMusic, this.pcMusic, {Key? key}) : super(key: key);

  @override
  _BottomBarState createState() => _BottomBarState(pjMusic, pcMusic);
}

class _BottomBarState extends State<BottomBar> {
  AudioPlayer pjMusic;
  AudioPlayer pcMusic;

  _BottomBarState(this.pjMusic, this.pcMusic);
  @override
  Widget build(BuildContext context) {
    final tableroBloc = Provider.tableroBloc(context);
    return BottomAppBar(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          FloatingActionButton.extended(
            label: Text(
              'Nuevo Juego',
              style: TextStyle(fontSize: 12),
            ),
            onPressed: () => {
              tableroBloc.changeTurno(true),
              tableroBloc.changePosiciones(
                  [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ']),
              tableroBloc.changePuntajes([0, 0, 0]),
              setState(() {}),
            },
          ),
          FloatingActionButton.extended(
            label: Text(
              'Dificultad',
              style: TextStyle(fontSize: 12),
            ),
            onPressed: () => {
              _showSelectDifficultyDialog(),
              setState(() {}),
            },
          ),
          FloatingActionButton.extended(
            label: Text(
              'Cerrar',
              style: TextStyle(fontSize: 12),
            ),
            onPressed: () => {
              _showCloseDialog(),
            },
          ),
          FloatingActionButton.extended(
            label: Text(
              tableroBloc.mute ? 'play' : 'Mute',
              style: TextStyle(fontSize: 12),
            ),
            onPressed: () => {
              tableroBloc.mute
                  ? {
                      pjMusic.play(),
                      tableroBloc.changeMute(false),
                    }
                  : {
                      pjMusic.pause(),
                      tableroBloc.changeMute(true),
                    },
              setState(() {})
            },
          ),
        ],
      ),
    );
  }

  void _showCloseDialog() {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: Text('Seguro que quieres salir'),
            // content: Text(mensaje),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  SystemNavigator.pop();
                },
                child: Text('SI'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('NO'),
              ),
            ],
          );
        });
  }

  void _showSelectDifficultyDialog() {
    showDialog(
        context: context,
        builder: (context) {
          TableroBloc tableroBloc = Provider.tableroBloc(context);
          return CupertinoAlertDialog(
            title: Text('Selecione la dificultad'),
            content: Text('Esta jugando en ${tableroBloc.dificultad}'),
            actions: <Widget>[
              Column(
                children: [
                  Container(
                    child: TextButton(
                      child: Text('Facil'),
                      onPressed: () {
                        tableroBloc.changeDificultad('Facil');
                        print('F');
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  Divider(
                    thickness: 0.4,
                  ),
                  TextButton(
                    child: Text('Dificil'),
                    onPressed: () {
                      tableroBloc.changeDificultad('Dificil');
                      print('D');
                      Navigator.pop(context);
                    },
                  ),
                  Divider(
                    thickness: 0.4,
                  ),
                  TextButton(
                    child: Text('Experto'),
                    onPressed: () {
                      tableroBloc.changeDificultad('Experto');
                      print('E');
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ],
          );
        });
  }
}

class Boton extends StatefulWidget {
  final int pos;
  final AudioPlayer pjMusic;
  final AudioPlayer pcMusic;
  Boton(this.pos, this.pjMusic, this.pcMusic, {Key? key}) : super(key: key);

  @override
  _BotonState createState() => _BotonState(pos, pjMusic, pcMusic);
}

class _BotonState extends State<Boton> {
  int pos;
  AudioPlayer pjMusic;
  AudioPlayer pcMusic;
  _BotonState(this.pos, this.pjMusic, this.pcMusic);
  final pj = 'O';
  final pc = 'X';
  @override
  Widget build(BuildContext context) {
    TableroBloc tableroBloc = Provider.tableroBloc(context);
    List<String> juego = tableroBloc.posiciones;
    return StreamBuilder<Object>(
        stream: null,
        builder: (context, snapshot) {
          Size size = MediaQuery.of(context).size;
          return Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black, width: 1),
              color: Colors.white,
              shape: BoxShape.rectangle,
            ),
            child: IconButton(
              icon: juego[pos] == ' '
                  ? Image.asset('assets/Blanco.jpg')
                  : juego[pos] == 'X'
                      ? Image.asset(
                          'assets/X_icon.png',
                          color: Colors.red[700],
                        )
                      : Image.asset(
                          'assets/O_icon.png',
                          color: Colors.lightBlue[300],
                        ),
              iconSize: size.height,
              onPressed: () => juego[pos] == ' '
                  ? {
                      _hacerJugada(tableroBloc, juego),
                      if (_checkForWinner(tableroBloc, juego) == 0)
                        {
                          _showPcDialog(),
                          _jugadaPC(tableroBloc, juego),
                        }
                      else
                        {
                          _mostrarResultado(tableroBloc, juego),
                        },
                      tableroBloc.changeTurno(!tableroBloc.turno),
                    }
                  : null,
            ),
          );
        });
  }

  void _hacerJugada(TableroBloc tableroBloc, List<String> juego) {
    juego[pos] = pj;
    tableroBloc.changePosiciones(juego);
  }

  void _jugadaPC(
    TableroBloc tableroBloc,
    List<String> juego,
  ) {
    if (!tableroBloc.mute) {
      pjMusic.pause();
      pcMusic.play();
    }

    Future.delayed(const Duration(milliseconds: 30), () {
      if (!tableroBloc.mute) {
        pcMusic.pause();
        pjMusic.play();
      }
      Navigator.pop(context);

      _mostrarResultado(tableroBloc, juego);
    });
    int move;
    if (tableroBloc.dificultad == 'Experto') {
      // First see if there's a move X can make to win
      for (int i = 0; i < juego.length; i++) {
        if (juego[i] != pj && juego[i] != pc) {
          String curr = juego[i]; // Save the current number
          juego[i] = pc;

          if (_checkForWinner(tableroBloc, juego) == 3) {
            juego[i] = pc;
            tableroBloc.changePosiciones(juego);
            return;
          } else
            juego[i] = curr;
        }
      }
    }

    if (tableroBloc.dificultad == 'Dificil' ||
        tableroBloc.dificultad == 'Experto') {
      // See if there's a move X can make to block O from winning
      for (int i = 0; i < juego.length; i++) {
        if (juego[i] != pc && juego[i] != pj) {
          String curr = juego[i];
          juego[i] = pj;
          if (_checkForWinner(tableroBloc, juego) == 2) {
            juego[i] = pc;
            tableroBloc.changePosiciones(juego);
            return;
          } else
            juego[i] = curr;
        }
      }
    }

    var rng = new Random();
    var aux = 0;
    do {
      aux++;
      move = rng.nextInt(juego.length);
    } while ((juego[move] == pj || juego[move] == pc) && aux < 9);
    juego[move] = pc;
    tableroBloc.changePosiciones(juego);
    return;
  }

  void _showPcDialog() {
    showDialog(
        barrierDismissible: false,
        barrierColor: Colors.black,
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: Text('Turno del PC'),
            //content: Text(mensaje),
          );
        });
  }

  void _showMaterialDialog(
      String titulo, String mensaje, TableroBloc tableroBloc) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: Text(titulo),
            content: Text(mensaje),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    _dismissDialog(tableroBloc);
                  },
                  child: Text('Close')),
            ],
          );
        });
  }

  _mostrarResultado(TableroBloc tableroBloc, List<String> juego) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    List<int> puntajes = tableroBloc.puntajes;
    if (_checkForWinner(tableroBloc, juego) == 1) {
      puntajes[2] = puntajes[2] + 1;
      preferences.setInt('empate', puntajes[2]);
      tableroBloc.changePuntajes(puntajes);
      _showMaterialDialog('Empeta', 'nadie gana', tableroBloc);
    } else if (_checkForWinner(tableroBloc, juego) == 2) {
      puntajes[0] = puntajes[0] + 1;
      preferences.setInt('jugador', puntajes[0]);
      tableroBloc.changePuntajes(puntajes);
      _showMaterialDialog('3 EN RAYA', 'Gana el Jugador', tableroBloc);
    } else if (_checkForWinner(tableroBloc, juego) == 3) {
      puntajes[1] = puntajes[1] + 1;
      preferences.setInt('pc', puntajes[1]);
      tableroBloc.changePuntajes(puntajes);
      _showMaterialDialog('3 EN RAYA', 'Gana el PC ', tableroBloc);
    }
  }

  _dismissDialog(TableroBloc tableroBloc) {
    Navigator.pop(context);
    List<String> rest = [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '];
    tableroBloc.changePrimeo(!tableroBloc.primero);
    if (tableroBloc.primero) {
      var rng = new Random();
      var move = rng.nextInt(rest.length);
      rest[move] = pc;
    }
    tableroBloc.changePosiciones(rest);
    tableroBloc.changeTurno(false);
  }

  // Check for a winner.  Return
  //  0 if no winner or tie yet
  //  1 if it's a tie
  //  2 if HUMAN_PLAYER won
  //  3 if COMPUTER_PLAYER won
  int _checkForWinner(TableroBloc tableroBloc, List<String> juego) {
    // Check horizontal wins
    for (int i = 0; i <= 6; i += 3) {
      if (juego[i] == pj && juego[i + 1] == pj && juego[i + 2] == pj) {
        return 2;
      }
      if (juego[i] == pc && juego[i + 1] == pc && juego[i + 2] == pc) {
        return 3;
      }
    }

    // Check vertical wins
    for (int i = 0; i <= 2; i++) {
      if (juego[i] == pj && juego[i + 3] == pj && juego[i + 6] == pj) {
        return 2;
      }
      if (juego[i] == pc && juego[i + 3] == pc && juego[i + 6] == pc) {
        return 3;
      }
    }

    // Check for diagonal wins
    if ((juego[0] == pj && juego[4] == pj && juego[8] == pj) ||
        (juego[2] == pj && juego[4] == pj && juego[6] == pj)) {
      return 2;
    }

    if ((juego[0] == pc && juego[4] == pc && juego[8] == pc) ||
        (juego[2] == pc && juego[4] == pc && juego[6] == pc)) {
      return 3;
    }

    // Check for tie
    for (int i = 0; i < juego.length; i++) {
      // If we find a number, then no one has won yet
      if (juego[i] != pj && juego[i] != pc) {
        return 0;
      }
    }

    // If we make it through the previous loop, all places are taken, so it's a tie
    return 1;
  }
}
