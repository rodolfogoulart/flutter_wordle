import 'package:flutter/material.dart';
import 'package:flutter_wordle/http.request.dart';
import 'package:flutter_wordle/local.data.dart';
import 'package:flutter_wordle/mock.dart';
import 'package:flutter_wordle/theme.dart';
import 'package:flutter_wordle/widget.dart';

var _indexList = 0;
List _coluna = [];
String _palavra = '';
bool _finished = false;
List<Dicionario> significadoPalavra = [];

int _letrasCorretas = 0;
int _letrasExistentes = 0;

bool isShowVitoriaActive = false;

List<String> _keyboard1 = ['Q', 'W', 'E', 'R', 'T', 'Y', 'U', 'I', 'O', 'P'];
List<String> _keyboard2 = ['A', 'S', 'D', 'F', 'G', 'H', 'J', 'K', 'L' /*, 'Ç'*/];
List<String> _keyboard3 = ['Enter', 'Z', 'X', 'C', 'V', 'B', 'N', 'M', 'Back'];

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
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: _keyboard1.map((e) {
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
          children: _keyboard2.map((e) {
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
          children: _keyboard3.map((e) {
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
    return RawKeyboardListener(
      autofocus: true,
      focusNode: FocusNode(),
      onKey: (event) {
        final key = event.logicalKey;
        if (event.isKeyPressed(key)) {
          if (_keyboard1.contains(key.keyLabel.toUpperCase()) ||
              _keyboard2.contains(key.keyLabel.toUpperCase()) ||
              _keyboard3.contains(key.keyLabel.toUpperCase())) {
            keyPressed(context, letra: key.keyLabel.toUpperCase());
          } else {
            if (key.keyLabel == 'Backspace') {
              keyPressed(context, letra: 'Back');
            } else if (key.keyLabel == 'Enter') {
              keyPressed(context, letra: 'Enter');
            }
          }
        }
      },
      child: InkResponse(
        // splashColor: Colors.green.shade50,
        // highlightColor: Colors.green.shade100,
        containedInkWell: true,
        onTap: () {
          keyPressed(context, letra: widget.letra);
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
      ),
    );
  }

  void keyPressed(BuildContext context, {required String letra}) {
    int indexInicio = 0;
    bool goNext = false;
    switch (letra) {
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
              List<Color> colorsPalavra = [];
              List listaLetrasCorretas = List.filled(5, 0);
              List letrasCheck = _palavra.characters.toList();

              for (int i = 0; i < _palavra.length; i++) {
                int count = letrasCheck.where((e) => e == palavradigitada[i]).length;
                listaLetrasCorretas[i] = listaLetrasCorretas[i] + count;
                letrasCheck.remove(palavradigitada[i]);

                if (palavradigitada[i] == _palavra[i]) {
                  listaLetrasCorretas[i] = 999;

                  for (int j = 0; j < palavradigitada.length; j++) {
                    if ((palavradigitada[j] == palavradigitada[i]) & (j != i)) {
                      if (listaLetrasCorretas[j] != 999 && listaLetrasCorretas[j] != -999) {
                        listaLetrasCorretas[j] = listaLetrasCorretas[j] - 1;
                      }
                    }
                  }
                } else if (!_palavra.contains(palavradigitada[i])) {
                  listaLetrasCorretas[i] = -999;
                }
              }

              for (int i = 0; i < 5; i++) {
                Color cor;
                if (listaLetrasCorretas[i] == 999) {
                  cor = ThemeApp().keyboadSuccessColor;
                } else if (listaLetrasCorretas[i] == -999) {
                  cor = ThemeApp().keyboardErrorColor;
                } else {
                  if (listaLetrasCorretas[i] > 0) {
                    cor = ThemeApp().keyboardExistColor;
                  } else {
                    cor = ThemeApp().keyboardErrorColor;
                  }
                }
                colorsPalavra.add(cor);
              }
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
                if (!isShowVitoriaActive) {
                  showVitoria(context);
                }
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
              widget.coluna.add(letra);
            } else if (_indexList == 1 && widget.coluna.length < 10) {
              widget.coluna.add(letra);
            } else if (_indexList == 2 && widget.coluna.length < 15) {
              widget.coluna.add(letra);
            } else if (_indexList == 3 && widget.coluna.length < 20) {
              widget.coluna.add(letra);
            } else if (_indexList == 4 && widget.coluna.length < 25) {
              widget.coluna.add(letra);
            } else if (_indexList == 5 && widget.coluna.length < 30) {
              widget.coluna.add(letra);
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
      showDerrota();
    }
  }

  Future showVitoria(BuildContext context) async {
    setPreference(typePref.jogoFinalizadoHoje, true);
    int pontuacao = int.tryParse(GlobalData().getPontuacao(typePontuacao: typePontuacao.values[_indexList]).first) ?? 0;
    pontuacao++;
    setPreferencePontuacao(typePontuacao.values[_indexList], pontuacao.toString());
    int pontuacaoLetrasCorretas = int.tryParse(GlobalData().getPontuacao(typePontuacao: typePontuacao.letrasCorretas).first) ?? 0;
    int pontuacaoLetrasExistentes =
        int.tryParse(GlobalData().getPontuacao(typePontuacao: typePontuacao.letrasExistentes).first) ?? 0;

    setPreferencePontuacao(typePontuacao.letrasCorretas, _letrasCorretas + pontuacaoLetrasCorretas);
    await setPreferencePontuacao(typePontuacao.letrasExistentes, _letrasExistentes + pontuacaoLetrasExistentes);

    List<String> frases = getGameData();
    isShowVitoriaActive = true;
    return showDialog<String>(
        useSafeArea: true,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.grey.shade800,
            content: SingleChildScrollView(
              child: Column(
                // ignore: prefer_const_literals_to_create_immutables
                children: [
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                          color: ThemeApp().atentionTextColor,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  const SizedBox(height: 15),
                  ...frases
                      .map((e) => Text(e, style: TextStyle(color: ThemeApp().primaryTextColor), textAlign: TextAlign.left))
                      .toList()
                ],
              ),
            ),
            actions: <Widget>[
              // TextButton(
              //   onPressed: () => Navigator.pop(context, 'Cancel'),
              //   child: const Text('Cancel'),
              // ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context, 'Fechar');
                  isShowVitoriaActive = false;
                },
                child: const Text(
                  'Fechar',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
            ],
          );
        });
  }

  Future showDerrota() {
    int pontuacao = int.tryParse(GlobalData().getPontuacao(typePontuacao: typePontuacao.derrotas).first) ?? 0;
    pontuacao++;
    setPreferencePontuacao(typePontuacao.derrotas, pontuacao.toString());
    setPreference(typePref.jogoFinalizadoHoje, true);

    return showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            backgroundColor: ThemeApp().backgroundColor,
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'Fechar',
                  style: TextStyle(color: ThemeApp().primaryTextColor),
                ),
              )
            ],
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Hoje não foi seu dia de acertar',
                  style: TextStyle(
                    color: ThemeApp().primaryTextColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  'Mas quem sabe amanhã?🤔',
                  style: TextStyle(
                    color: ThemeApp().primaryTextColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          );
        });
  }
}
