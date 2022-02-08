import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_wordle/mock.dart';
import 'package:flutter_wordle/widget.dart';

var indexList = 0;
List coluna = [];
String palavra = '';

class Keyboard extends StatefulWidget {
  final ControlerRowPalavra controler1;
  final ControlerRowPalavra controler2;
  final ControlerRowPalavra controler3;
  final ControlerRowPalavra controler4;
  final ControlerRowPalavra controler5;
  final ControlerRowPalavra controler6;
  final String palavra;

  const Keyboard({
    Key? key,
    required this.controler1,
    required this.controler2,
    required this.controler3,
    required this.controler4,
    required this.controler5,
    required this.controler6,
    required this.palavra,
  }) : super(key: key);

  @override
  State<Keyboard> createState() => _KeyboardState();
}

class _KeyboardState extends State<Keyboard> {
  @override
  void initState() {
    palavra = widget.palavra;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<String> keyboard1 = ['Q', 'W', 'E', 'R', 'T', 'Y', 'U', 'I', 'O', 'P'];
    List<String> keyboard2 = ['A', 'S', 'D', 'F', 'G', 'H', 'J', 'K', 'L', 'Ç'];
    List<String> keyboard3 = ['Enter', 'Z', 'X', 'C', 'V', 'B', 'N', 'M', 'Back'];

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: keyboard1.map((e) {
            return LetraKeyboard(
                letra: e,
                coluna: coluna,
                controler1: widget.controler1,
                controler2: widget.controler2,
                controler3: widget.controler3,
                controler4: widget.controler4,
                controler5: widget.controler5,
                controler6: widget.controler6);
          }).toList(),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: keyboard2.map((e) {
            return LetraKeyboard(
                letra: e,
                coluna: coluna,
                controler1: widget.controler1,
                controler2: widget.controler2,
                controler3: widget.controler3,
                controler4: widget.controler4,
                controler5: widget.controler5,
                controler6: widget.controler6);
          }).toList(),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: keyboard3.map((e) {
            return LetraKeyboard(
                letra: e,
                coluna: coluna,
                controler1: widget.controler1,
                controler2: widget.controler2,
                controler3: widget.controler3,
                controler4: widget.controler4,
                controler5: widget.controler5,
                controler6: widget.controler6);
          }).toList(),
        ),
      ],
    );
  }
}

class LetraKeyboard extends StatefulWidget {
  final String letra;
  final List coluna;
  final ControlerRowPalavra controler1;
  final ControlerRowPalavra controler2;
  final ControlerRowPalavra controler3;
  final ControlerRowPalavra controler4;
  final ControlerRowPalavra controler5;
  final ControlerRowPalavra controler6;

  const LetraKeyboard(
      {Key? key,
      required this.letra,
      required this.coluna,
      required this.controler1,
      required this.controler2,
      required this.controler3,
      required this.controler4,
      required this.controler5,
      required this.controler6})
      : super(key: key);

  @override
  State<LetraKeyboard> createState() => _LetraKeyboardState();
}

class _LetraKeyboardState extends State<LetraKeyboard> {
  @override
  Widget build(BuildContext context) {
    IconData? icone;
    switch (widget.letra) {
      case 'Enter':
        icone = Icons.subdirectory_arrow_left_outlined;
        break;
      case 'Back':
        icone = Icons.backspace_outlined;
        break;
      default:
        icone = null;
    }
    double? size = icone == null ? 38 : null;

    //
    Color colorContainer = Colors.blueGrey.shade600;
    Color colorContainerShadown = Colors.blueGrey.shade900;
    //
    return InkResponse(
      // splashColor: Colors.green.shade50,
      // highlightColor: Colors.green.shade100,
      containedInkWell: true,
      onTap: () {
        int indexInicio = 0;
        bool goNext = false;
        switch (widget.letra) {
          case 'Enter':
            {
              if (indexList == 0 && widget.coluna.length > 5 - 1) {
                indexInicio = 0;
                goNext = true;
              } else if (indexList == 1 && widget.coluna.length > 10 - 1) {
                indexInicio = 5;
                goNext = true;
              } else if (indexList == 2 && widget.coluna.length > 15 - 1) {
                indexInicio = 10;
                goNext = true;
              } else if (indexList == 3 && widget.coluna.length > 20 - 1) {
                indexInicio = 15;
                goNext = true;
              } else if (indexList == 4 && widget.coluna.length > 25 - 1) {
                indexInicio = 20;
                goNext = true;
              } else if (indexList == 5 && widget.coluna.length > 30 - 1) {
                indexInicio = 25;
                goNext = true;
              }
              if (goNext) {
                String palavradigitada = widget.coluna.sublist(indexInicio, indexInicio + 5).join();

                print('palavradigitada: $palavradigitada');
                if (palavra.toUpperCase() == palavradigitada.toUpperCase()) {
                  print('OK - PALAVRA CORRETA $palavra - $palavradigitada');
                } else {
                  var checkPalavra = mockPalavras.firstWhere((element) => element == palavradigitada, orElse: () => -1);
                  if (checkPalavra == -1) {
                    goNext = false;

                    var snack = SnackBar(
                      // backgroundColor: Colors.red,
                      content: Row(children: const [
                        Icon(Icons.error_outline, color: Colors.red),
                        Padding(
                          padding: EdgeInsets.only(left: 15),
                          child: Text('Palavra não existe'),
                        )
                      ]),
                      duration: const Duration(milliseconds: 1500),
                    );

                    ScaffoldMessenger.of(context).showSnackBar(snack);
                  }
                }

                //proximo tentativa
                if (goNext) {
                  indexList++;
                }
              }
              // }
              if (kDebugMode) {
                print(indexList);
              }
              break;
            }
          case 'Back':
            {
              setState(() {
                if (widget.coluna.isNotEmpty) {
                  if (indexList == 0) {
                    widget.coluna.removeLast();
                  } else if (indexList == 1 && widget.coluna.length > 5) {
                    widget.coluna.removeLast();
                  } else if (indexList == 2 && widget.coluna.length > 10) {
                    widget.coluna.removeLast();
                  } else if (indexList == 3 && widget.coluna.length > 15) {
                    widget.coluna.removeLast();
                  } else if (indexList == 4 && widget.coluna.length > 20) {
                    widget.coluna.removeLast();
                  } else if (indexList == 5 && widget.coluna.length > 25) {
                    widget.coluna.removeLast();
                  }
                }
              });
              break;
            }
          default:
            {
              if (indexList == 0 && widget.coluna.length < 5) {
                widget.coluna.add(widget.letra);
              } else if (indexList == 1 && widget.coluna.length < 10) {
                widget.coluna.add(widget.letra);
              } else if (indexList == 2 && widget.coluna.length < 15) {
                widget.coluna.add(widget.letra);
              } else if (indexList == 3 && widget.coluna.length < 20) {
                widget.coluna.add(widget.letra);
              } else if (indexList == 4 && widget.coluna.length < 25) {
                widget.coluna.add(widget.letra);
              } else if (indexList == 5 && widget.coluna.length < 30) {
                widget.coluna.add(widget.letra);
              }
              break;
            }
        }
        if (indexList == 0) {
          widget.controler1.changePalavra(widget.coluna.sublist(0));
        }
        if (indexList == 1) {
          widget.controler1.submited = true;
          widget.controler2.changePalavra(widget.coluna.sublist(5));
        }
        if (indexList == 2) {
          widget.controler2.submited = true;
          widget.controler3.changePalavra(widget.coluna.sublist(10));
        }
        if (indexList == 3) {
          widget.controler3.submited = true;
          widget.controler4.changePalavra(widget.coluna.sublist(15));
        }
        if (indexList == 4) {
          widget.controler4.submited = true;
          widget.controler5.changePalavra(widget.coluna.sublist(20));
        }
        if (indexList == 5) {
          widget.controler5.submited = true;
          widget.controler6.changePalavra(widget.coluna.sublist(25));
        }
        if (indexList == 6) {
          widget.controler6.submited = true;
        }
        if (kDebugMode) {
          print(widget.coluna);
        }
      },
      child: Padding(
        padding: const EdgeInsets.only(right: 5),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: size,
          height: size,
          padding: EdgeInsets.all(icone == null ? 6 : 10),
          decoration: BoxDecoration(
            color: colorContainer,
            borderRadius: BorderRadius.circular(3),
            boxShadow: [
              BoxShadow(
                color: colorContainerShadown,
                blurRadius: 4,
                spreadRadius: 1,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Center(
            child: icone == null
                ? FittedBox(
                    fit: BoxFit.contain,
                    child: Text(
                      widget.letra,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 200,
                      ),
                    ),
                  )
                : Icon(
                    icone,
                    color: Colors.white,
                    size: 30,
                  ),
          ),
        ),
      ),
    );
  }
}
