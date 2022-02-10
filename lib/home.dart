// import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_wordle/http.request.dart';
import 'package:flutter_wordle/mock.dart';
import 'package:flutter_wordle/theme.dart';
import 'package:flutter_wordle/widget.dart';
import 'package:flutter_wordle/widget_keyboard.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

    // if (kDebugMode) {
    //   print('index: $palavra');
    // }
    super.initState();

    getPreference();

    Future.delayed(const Duration(seconds: 1), () {
      // setState(() {});
      showHelp();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ThemeApp().backgroundColor,
        leading: IconButton(
            onPressed: () {
              showHelp();
            },
            icon: Icon(Icons.help_outline, color: ThemeApp().primaryTextColor)),
        title: Text(
          widget.title,
          style: TextStyle(color: ThemeApp().primaryTextColor),
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

  Future showHelp() {
    return showDialog<String>(
      useSafeArea: true,
      context: context,
      builder: (BuildContext context) => AlertDialog(
        backgroundColor: ThemeApp().backgroundColor,
        title: Text('Regras do Jogo',
            style: TextStyle(
              color: ThemeApp().primaryTextColor,
            )),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
              textAlign: TextAlign.justify,
              text: TextSpan(children: [
                TextSpan(
                  text: 'Tente advinhar palavra do dia em 6 tentativas.\n' +
                      'Adaptação para Português do Wordle de Josh Wardle.\n' +
                      'Cada tentativa tem de ser uma palavra de 5 letras. Use o botão Enter ↵ para submeter.\n' +
                      'Depois de cada tentativa, a cor dos quadrados mudará para mostrar quão perto você esta da solução.!',
                  style: TextStyle(
                    color: ThemeApp().primaryTextColor,
                  ),
                ),
              ]),
            ),
            const SizedBox(height: 10),
            const Divider(),
            Row(
              children: [
                SizedBox(
                  width: 50,
                  height: 50,
                  child: ContainerPalavra(
                    colorLetra: ThemeApp().keyboadSuccessColor,
                    letra: 'A',
                    animating: false,
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: Text(
                    'VERDE -> Indica que a letra esta no lugar certo.',
                    style: TextStyle(
                      color: ThemeApp().keyboadSuccessColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                SizedBox(
                  width: 50,
                  height: 50,
                  child: ContainerPalavra(
                    colorLetra: ThemeApp().keyboadSuccessColor,
                    letra: 'S',
                    animating: false,
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: Text(
                    'AMARELO -> Indica que a letra esta no lugar errado.',
                    style: TextStyle(
                      color: ThemeApp().keyboardExistColor,
                      fontWeight: FontWeight.bold,
                    ),
                    softWrap: true,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                SizedBox(
                  width: 50,
                  height: 50,
                  child: ContainerPalavra(
                    colorLetra: ThemeApp().keyboadSuccessColor,
                    letra: 'D',
                    animating: false,
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: Text(
                    'VERMELHO -> Indica que a letra não existe na palavra.',
                    style: TextStyle(
                      color: ThemeApp().keyboardErrorColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: <Widget>[
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

  Future<void> getPreference() async {
    final prefs = await SharedPreferences.getInstance();
    var dias_jogados = prefs.getInt('dias_jogados') ?? 0;
    var jogo_finalizado_hoje = prefs.getBool('jogo_finalizado_hoje') ?? false;
    // print(dias_jogados);
    // print(jogo_finalizado_hoje);
    //
    await prefs.setInt('dias_jogados', dias_jogados);
    await prefs.setBool('jogo_finalizado_hoje', jogo_finalizado_hoje);
    // await prefs.set
  }
}
