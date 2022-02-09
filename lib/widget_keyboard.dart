// import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_wordle/http.request.dart';
// import 'package:flutter_wordle/http.request.dart';
import 'package:flutter_wordle/mock.dart';
import 'package:flutter_wordle/theme.dart';
import 'package:flutter_wordle/widget.dart';

var _indexList = 0;
List _coluna = [];
String _palavra = '';
bool _finished = false;
List<Dicionario> significadoPalavra = [];

class Keyboard extends StatelessWidget {
  final ControlerRowPalavra controler1;
  final ControlerRowPalavra controler2;
  final ControlerRowPalavra controler3;
  final ControlerRowPalavra controler4;
  final ControlerRowPalavra controler5;
  final ControlerRowPalavra controler6;
  final String palavra;

  Keyboard({
    Key? key,
    required this.controler1,
    required this.controler2,
    required this.controler3,
    required this.controler4,
    required this.controler5,
    required this.controler6,
    required this.palavra,
  }) : super(key: key) {
    _palavra = palavra.toUpperCase();
    getSignificado();
  }

//   @override
//   State<Keyboard> createState() => _KeyboardState();
// }

// class _KeyboardState extends State<Keyboard> {
  // @override
  // void initState() {
  //   palavra = palavra.toUpperCase();
  //   super.initState();
  // }

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
                coluna: _coluna,
                controler1: controler1,
                controler2: controler2,
                controler3: controler3,
                controler4: controler4,
                controler5: controler5,
                controler6: controler6);
          }).toList(),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: keyboard2.map((e) {
            return LetraKeyboard(
                letra: e,
                coluna: _coluna,
                controler1: controler1,
                controler2: controler2,
                controler3: controler3,
                controler4: controler4,
                controler5: controler5,
                controler6: controler6);
          }).toList(),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: keyboard3.map((e) {
            return LetraKeyboard(
                letra: e,
                coluna: _coluna,
                controler1: controler1,
                controler2: controler2,
                controler3: controler3,
                controler4: controler4,
                controler5: controler5,
                controler6: controler6);
          }).toList(),
        ),
      ],
    );
  }

  void getSignificado() async {
    significadoPalavra = await getHttp(palavra);
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
  Color colorContainer = ThemeApp().keyboardColor;
  Color colorContainerShadown = ThemeApp().keyboardShadownColor;
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
    return GestureDetector(
      // splashColor: Colors.green.shade50,
      // highlightColor: Colors.green.shade100,
      // containedInkWell: true,
      onTap: () {
        int indexInicio = 0;
        bool goNext = false;
        switch (widget.letra) {
          case 'Enter':
            {
              if (_indexList == 0 && widget.coluna.length > 5 - 1) {
                indexInicio = 0;
                goNext = true;
              } else if (_indexList == 1 && widget.coluna.length > 10 - 1) {
                indexInicio = 5;
                goNext = true;
              } else if (_indexList == 2 && widget.coluna.length > 15 - 1) {
                indexInicio = 10;
                goNext = true;
              } else if (_indexList == 3 && widget.coluna.length > 20 - 1) {
                indexInicio = 15;
                goNext = true;
              } else if (_indexList == 4 && widget.coluna.length > 25 - 1) {
                indexInicio = 20;
                goNext = true;
              } else if (_indexList == 5 && widget.coluna.length > 30 - 1) {
                indexInicio = 25;
                goNext = true;
              }
              if (goNext) {
                String palavradigitada = widget.coluna.sublist(indexInicio, indexInicio + 5).join().toUpperCase();

                if (_palavra != palavradigitada) {
                  var checkPalavra =
                      mockPalavras.firstWhere((element) => element.toUpperCase() == palavradigitada, orElse: () => '-1');
                  if (checkPalavra == '-1') {
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
                  } else {
                    // setState(() {
                    //   colorContainer = ThemeApp().keyboardExistColor;
                    //   colorContainerShadown = ThemeApp().keyboardExistShadownColor;
                    // });
                  }
                }

                //proximo tentativa
                if (goNext) {
                  List<Color> colorsPalavra = [
                    palavradigitada[0] == _palavra[0]
                        ? Colors.green
                        : _palavra.contains(palavradigitada[0])
                            ? ThemeApp().keyboardExistColor
                            : ThemeApp().keyboardErrorColor,
                    palavradigitada[1] == _palavra[1]
                        ? ThemeApp().keyboadSuccessColor
                        : _palavra.contains(palavradigitada[1])
                            ? ThemeApp().keyboardExistColor
                            : ThemeApp().keyboardErrorColor,
                    palavradigitada[2] == _palavra[2]
                        ? ThemeApp().keyboadSuccessColor
                        : _palavra.contains(palavradigitada[2])
                            ? ThemeApp().keyboardExistColor
                            : ThemeApp().keyboardErrorColor,
                    palavradigitada[3] == _palavra[3]
                        ? ThemeApp().keyboadSuccessColor
                        : _palavra.contains(palavradigitada[3])
                            ? ThemeApp().keyboardExistColor
                            : ThemeApp().keyboardErrorColor,
                    palavradigitada[4] == _palavra[4]
                        ? ThemeApp().keyboadSuccessColor
                        : _palavra.contains(palavradigitada[4])
                            ? ThemeApp().keyboardExistColor
                            : ThemeApp().keyboardErrorColor,
                  ];
                  if (_indexList == 0) {
                    widget.controler1.changeColor(colorsPalavra);
                  } else if (_indexList == 1) {
                    widget.controler2.changeColor(colorsPalavra);
                  } else if (_indexList == 2) {
                    widget.controler3.changeColor(colorsPalavra);
                  } else if (_indexList == 3) {
                    widget.controler4.changeColor(colorsPalavra);
                  } else if (_indexList == 4) {
                    widget.controler5.changeColor(colorsPalavra);
                  } else if (_indexList == 5) {
                    widget.controler6.changeColor(colorsPalavra);
                  }
                  if (_palavra == palavradigitada) {
                    showDialog<String>(
                        useSafeArea: true,
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            backgroundColor: Colors.grey.shade800,
                            // title: const Text('AlertDialog Title'),
                            content: Column(
                              // ignore: prefer_const_literals_to_create_immutables
                              children: [
                                // const Text(
                                //   'Você acertou a palavra de hoje!',
                                //   style: TextStyle(color: Colors.white, fontSize: 20),
                                // ),
                                if (_indexList == 0)
                                  const Text(
                                    'Você é um GÊNIO, acertou de primeira!',
                                    style: TextStyle(color: Colors.white, fontSize: 20),
                                  ),
                                if (_indexList == 1)
                                  const Text(
                                    'Uau você foi incrível, acertou na segunda tentativa!',
                                    style: TextStyle(color: Colors.white, fontSize: 20),
                                  ),
                                if (_indexList == 2)
                                  const Text(
                                    'Uau você foi muito bem, acertou na terceira tentativa!',
                                    style: TextStyle(color: Colors.white, fontSize: 20),
                                  ),
                                if (_indexList == 3)
                                  const Text(
                                    'Muito bom, acertou na quarta tentativa!',
                                    style: TextStyle(color: Colors.white, fontSize: 20),
                                  ),
                                if (_indexList == 4)
                                  const Text(
                                    'Passou rastando eim rs, acertou na quarta tetantiva!',
                                    style: TextStyle(color: Colors.white, fontSize: 20),
                                  ),
                                if (_indexList == 5)
                                  const Text(
                                    'Nossa quase não acreditava que você iria acertar, mas parabéns!\n Amanhã tente seu melhor',
                                    style: TextStyle(color: Colors.white, fontSize: 20),
                                  ),
                                if (significadoPalavra.isNotEmpty) const SizedBox(height: 30),
                                if (significadoPalavra.isNotEmpty)
                                  Text('Gostaria de saber o significado da palavra de hoje?',
                                      style: TextStyle(color: ThemeApp().primaryTextColor, fontSize: 15)),
                                if (significadoPalavra.isNotEmpty)
                                  TextButton(
                                    onPressed: () => {
                                      showDialog(
                                          context: context,
                                          builder: (_) {
                                            return AlertDialog(
                                              backgroundColor: Colors.grey.shade800,
                                              actions: [
                                                TextButton(
                                                  child: const Text('Fechar'),
                                                  onPressed: () => Navigator.pop(context),
                                                )
                                              ],
                                              title: Text(
                                                'Significado da palavra (${_palavra.toUpperCase()})',
                                                style: const TextStyle(color: Colors.white),
                                              ),
                                              content: Column(
                                                children: significadoPalavra
                                                    .map((e) => Text(
                                                          e.meanings!.join('\n'),
                                                          style: TextStyle(color: ThemeApp().primaryTextColor),
                                                        ))
                                                    .toList(),
                                              ),
                                            );
                                          })
                                    },
                                    child: Text(
                                      'Ver significado',
                                      style: TextStyle(
                                        color: ThemeApp().primaryTextColor,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            actions: <Widget>[
                              // TextButton(
                              //   onPressed: () => Navigator.pop(context, 'Cancel'),
                              //   child: const Text('Cancel'),
                              // ),
                              TextButton(
                                onPressed: () => Navigator.pop(context, 'OK'),
                                child: const Text(
                                  'OK',
                                  style: TextStyle(color: Colors.white, fontSize: 20),
                                ),
                              ),
                            ],
                          );
                        });
                    _finished = true;
                  } else {
                    //somente avança se não terminou o jogo
                    _indexList++;
                  }
                }
              }
              break;
            }
          case 'Back':
            {
              if (!_finished) {
                // setState(() {
                if (widget.coluna.isNotEmpty) {
                  if (_indexList == 0) {
                    widget.coluna.removeLast();
                  } else if (_indexList == 1 && widget.coluna.length > 5) {
                    widget.coluna.removeLast();
                  } else if (_indexList == 2 && widget.coluna.length > 10) {
                    widget.coluna.removeLast();
                  } else if (_indexList == 3 && widget.coluna.length > 15) {
                    widget.coluna.removeLast();
                  } else if (_indexList == 4 && widget.coluna.length > 20) {
                    widget.coluna.removeLast();
                  } else if (_indexList == 5 && widget.coluna.length > 25) {
                    widget.coluna.removeLast();
                  }
                }
                // });
              }
              break;
            }
          default:
            {
              if (!_finished) {
                if (_indexList == 0 && widget.coluna.length < 5) {
                  widget.coluna.add(widget.letra);
                } else if (_indexList == 1 && widget.coluna.length < 10) {
                  widget.coluna.add(widget.letra);
                } else if (_indexList == 2 && widget.coluna.length < 15) {
                  widget.coluna.add(widget.letra);
                } else if (_indexList == 3 && widget.coluna.length < 20) {
                  widget.coluna.add(widget.letra);
                } else if (_indexList == 4 && widget.coluna.length < 25) {
                  widget.coluna.add(widget.letra);
                } else if (_indexList == 5 && widget.coluna.length < 30) {
                  widget.coluna.add(widget.letra);
                }
              }
              break;
            }
        }
        if (_indexList == 0) {
          widget.controler1.changePalavra(widget.coluna.sublist(0));
        }
        if (_indexList == 1) {
          widget.controler1.submited = true;
          widget.controler2.changePalavra(widget.coluna.sublist(5));
        }
        if (_indexList == 2) {
          widget.controler2.submited = true;
          widget.controler3.changePalavra(widget.coluna.sublist(10));
        }
        if (_indexList == 3) {
          widget.controler3.submited = true;
          widget.controler4.changePalavra(widget.coluna.sublist(15));
        }
        if (_indexList == 4) {
          widget.controler4.submited = true;
          widget.controler5.changePalavra(widget.coluna.sublist(20));
        }
        if (_indexList == 5) {
          widget.controler5.submited = true;
          widget.controler6.changePalavra(widget.coluna.sublist(25));
        }
        if (_indexList == 6) {
          widget.controler6.submited = true;
        }
        // if (kDebugMode) {
        //   print(widget.coluna);
        // }
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
                : FittedBox(
                    child: Icon(
                      icone,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
