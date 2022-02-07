import 'package:flutter/material.dart';

class ControlerRowPalavra extends ChangeNotifier {
  List _palavra = [];
  bool submited = false;

  changePalavra(List palavra) {
    if (!submited) {
      _palavra = palavra;
      notifyListeners();
    }
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ContainerPalavra(letra: widget.controler._palavra.isNotEmpty ? widget.controler._palavra[0] : ''),
        ContainerPalavra(
            letra:
                widget.controler._palavra.isNotEmpty && widget.controler._palavra.length > 1 ? widget.controler._palavra[1] : ''),
        ContainerPalavra(
            letra:
                widget.controler._palavra.isNotEmpty && widget.controler._palavra.length > 2 ? widget.controler._palavra[2] : ''),
        ContainerPalavra(
            letra:
                widget.controler._palavra.isNotEmpty && widget.controler._palavra.length > 3 ? widget.controler._palavra[3] : ''),
        ContainerPalavra(
            letra:
                widget.controler._palavra.isNotEmpty && widget.controler._palavra.length > 4 ? widget.controler._palavra[4] : ''),
      ],
    );
  }
}

class ContainerPalavra extends StatefulWidget {
  final String letra;
  const ContainerPalavra({
    Key? key,
    required this.letra,
  }) : super(key: key);

  @override
  State<ContainerPalavra> createState() => _ContainerPalavraState();
}

class _ContainerPalavraState extends State<ContainerPalavra> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size.height * 0.7;
    size = size * 0.13;
    print('size: $size');

    return FittedBox(
      child: Padding(
        padding: const EdgeInsets.only(right: 5, bottom: 10),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          // width: MediaQuery.of(context).size.width * 0.13,
          // height: MediaQuery.of(context).size.width * 0.13,
          width: size,
          height: size,
          // width: 65,
          // height: 65,
          decoration: BoxDecoration(
            color: Colors.grey.shade800,
            border: Border.all(
              color: Colors.grey.shade800,
              width: 2.0,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade900,
                blurRadius: 5.0,
                spreadRadius: 1.0,
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
                      style: const TextStyle(
                        fontSize: 450,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                )
              : Container(),
        ),
      ),
    );
  }
}
