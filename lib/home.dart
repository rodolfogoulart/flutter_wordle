import 'package:flutter/material.dart';
import 'package:flutter_wordle/widget.dart';
import 'package:flutter_wordle/widget_keyboard.dart';

ControlerRowPalavra controler1 = ControlerRowPalavra();
ControlerRowPalavra controler2 = ControlerRowPalavra();
ControlerRowPalavra controler3 = ControlerRowPalavra();
ControlerRowPalavra controler4 = ControlerRowPalavra();
ControlerRowPalavra controler5 = ControlerRowPalavra();
ControlerRowPalavra controler6 = ControlerRowPalavra();

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void dispose() {
    super.dispose();
    controler1.dispose();
    controler2.dispose();
    controler3.dispose();
    controler4.dispose();
    controler5.dispose();
    controler6.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey.shade800,
        title: Center(
            child: Text(
          widget.title,
          style: const TextStyle(color: Colors.white),
        )),
      ),
      backgroundColor: Colors.grey.shade800,
      body: SafeArea(
        child: Center(
          child: FittedBox(
            fit: BoxFit.contain,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: <Widget>[
                  SizedBox(
                    // color: Colors.red,
                    height: MediaQuery.of(context).size.height * 0.7,
                    child: Column(
                      children: [
                        RowPalavra(controler: controler1),
                        RowPalavra(controler: controler2),
                        RowPalavra(controler: controler3),
                        RowPalavra(controler: controler4),
                        RowPalavra(controler: controler5),
                        RowPalavra(controler: controler6),
                      ],
                    ),
                  ),
                  //
                  const SizedBox(height: 20),
                  Keyboard(
                      controler1: controler1,
                      controler2: controler2,
                      controler3: controler3,
                      controler4: controler4,
                      controler5: controler5,
                      controler6: controler6),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}