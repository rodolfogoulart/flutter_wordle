import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_wordle/mock.dart';
import 'package:flutter_wordle/theme.dart';
import 'package:flutter_wordle/widget.dart';
import 'package:flutter_wordle/widget_keyboard.dart';

ControlerRowPalavra controler1 = ControlerRowPalavra();
ControlerRowPalavra controler2 = ControlerRowPalavra();
ControlerRowPalavra controler3 = ControlerRowPalavra();
ControlerRowPalavra controler4 = ControlerRowPalavra();
ControlerRowPalavra controler5 = ControlerRowPalavra();
ControlerRowPalavra controler6 = ControlerRowPalavra();
String palavra = '';

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
  void initState() {
    var date = DateTime.now().difference(DateTime(2022, 2, 7)).inDays;
    // print('date: $date');
    try {
      if (date > mockPalavras.length) {
        date = DateTime.now().difference(DateTime(DateTime.now().year, 1, 1)).inDays;
        palavra = mockPalavras[date];
      }
      palavra = mockPalavras.elementAt(date);
    } catch (e) {
      palavra = 'Não encontrado';
    }
    if (kDebugMode) {
      print('index: $palavra');
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ThemeApp().backgroundColor,
        title: Row(
          children: [
            Flexible(
                flex: 1,
                child: IconButton(
                    onPressed: () {
                      showHelp();
                    },
                    icon: Icon(Icons.help_outline, color: ThemeApp().primaryTextColor))),
            Flexible(
                flex: 3,
                child: Center(
                  child: Text(
                    widget.title,
                    style: TextStyle(color: ThemeApp().primaryTextColor),
                  ),
                )),
          ],
        ),
      ),
      backgroundColor: ThemeApp().backgroundColor,
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
                      controler6: controler6,
                      palavra: palavra),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void showHelp() {
    showDialog<String>(
      useSafeArea: true,
      context: context,
      builder: (BuildContext context) => AlertDialog(
        backgroundColor: Colors.grey.shade800,
        title: const Text('Regras do Jogo'),
        content: const Text(
          'Advinha a Palavra do Dia em 6 tentativas.\n' +
              'Adaptação para Português do Wordle de Josh Wardle.\n' +
              'Cada tentativa tem de ser uma palavra de 5 letras. Usa o botão Enter ↵ para submeter.\n' +
              'Depois de cada tentativa, a cor dos quadrados mudará para mostrar quão perto estás da solução.!',
          style: TextStyle(color: Colors.white),
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
      ),
    );
  }
}
