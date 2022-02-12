import 'package:flutter/material.dart';
import 'package:flutter_wordle/theme.dart';

class ControlerRowPalavra extends ChangeNotifier {
  List _palavra = [];
  bool submited = false;
  List<Color>? _colorsPalavra;
  int indexChanging = -1;
  bool setAnimation = false;

  changePalavra(List palavra) {
    if (!submited) {
      indexChanging = palavra.length - 1;
      _palavra = palavra;
      notifyListeners();
      animateSize();
    }
  }

  changeColor(List<Color> colorsPalavra) {
    _colorsPalavra = colorsPalavra;
    setAnimation = false;
    notifyListeners();
    // }
  }

  void animateSize() {
    setAnimation = true;
    notifyListeners();
    Future.delayed(const Duration(milliseconds: 100), () {
      setAnimation = false;
      notifyListeners();
    });
  }
}

class RowPalavra extends StatefulWidget {
  final ControlerRowPalavra controler;

  const RowPalavra({
    Key? key,
    required this.controler,
  }) : super(key: key);

  @override
  State<RowPalavra> createState() => _RowPalavraState();
}

class _RowPalavraState extends State<RowPalavra> {
  @override
  void initState() {
    super.initState();

    widget.controler.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    //POSSIVEL IMPLEMENTAÇÃO USANDO WidgetSpan
    // https: //api.flutter.dev/flutter/widgets/WidgetSpan-class.html
    // RichText(
    //             text: TextSpan(children: [
    //           WidgetSpan(
    //               child: SizedBox(
    //             width: 100,
    //             height: 100,
    //             child: Card(
    //               color: ThemeApp().keyboardErrorColor,
    //               elevation: 3,
    //               shadowColor: ThemeApp().shadownColor,
    //               shape: RoundedRectangleBorder(
    //                 borderRadius: BorderRadius.circular(10),
    //               ),
    //               child: FittedBox(child: Center(child: Text('A'))),
    //             ),
    //           )),
    //         ]))

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ContainerPalavra(
          letra: widget.controler._palavra.isNotEmpty ? widget.controler._palavra[0] : '',
          colorLetra: widget.controler._colorsPalavra?[0],
          animating: widget.controler.indexChanging == 0 ? widget.controler.setAnimation : false,
        ),
        ContainerPalavra(
          letra: widget.controler._palavra.isNotEmpty && widget.controler._palavra.length > 1 ? widget.controler._palavra[1] : '',
          colorLetra: widget.controler._colorsPalavra?[1],
          animating: widget.controler.indexChanging == 1 ? widget.controler.setAnimation : false,
        ),
        ContainerPalavra(
          letra: widget.controler._palavra.isNotEmpty && widget.controler._palavra.length > 2 ? widget.controler._palavra[2] : '',
          colorLetra: widget.controler._colorsPalavra?[2],
          animating: widget.controler.indexChanging == 2 ? widget.controler.setAnimation : false,
        ),
        ContainerPalavra(
          letra: widget.controler._palavra.isNotEmpty && widget.controler._palavra.length > 3 ? widget.controler._palavra[3] : '',
          colorLetra: widget.controler._colorsPalavra?[3],
          animating: widget.controler.indexChanging == 3 ? widget.controler.setAnimation : false,
        ),
        ContainerPalavra(
          letra: widget.controler._palavra.isNotEmpty && widget.controler._palavra.length > 4 ? widget.controler._palavra[4] : '',
          colorLetra: widget.controler._colorsPalavra?[4],
          animating: widget.controler.indexChanging == 4 ? widget.controler.setAnimation : false,
        ),
      ],
    );
  }
}

class ContainerPalavra extends StatefulWidget {
  final String letra;
  final Color? colorLetra;
  final bool animating;
  const ContainerPalavra({
    Key? key,
    required this.letra,
    required this.colorLetra,
    required this.animating,
  }) : super(key: key);

  @override
  State<ContainerPalavra> createState() => _ContainerPalavraState();
}

class _ContainerPalavraState extends State<ContainerPalavra> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size.height * 0.7;
    size = size * 0.13;

    return FittedBox(
      child: Padding(
        padding: const EdgeInsets.only(right: 5, bottom: 10),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 10),
          curve: Curves.linear,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: (widget.animating ? ThemeApp().shadownColor : Colors.transparent),
                blurRadius: (widget.animating ? 5 : 0),
                spreadRadius: (widget.animating ? 2 : 0),
                offset: const Offset(0.0, 2.0),
              ),
            ],
          ),
          child: AnimatedContainer(
            duration: Duration(milliseconds: (widget.animating ? 10 : 500)),
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: widget.colorLetra ?? ThemeApp().backgroundColor,
              boxShadow: [
                BoxShadow(
                  color: ThemeApp().shadownColor,
                  blurRadius: 5,
                  spreadRadius: 1,
                  offset: const Offset(0.0, 2.0),
                ),
              ],
              borderRadius: BorderRadius.circular(9),
            ),
            child: widget.letra != ''
                ? Center(
                    child: FittedBox(
                      child: Text(
                        widget.letra,
                        style: TextStyle(
                          fontSize: 450,
                          color: ThemeApp().primaryTextColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  )
                : Container(),
          ),
        ),
      ),
    );
  }
}
