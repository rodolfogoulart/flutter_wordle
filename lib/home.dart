import 'package:flutter/material.dart';
import 'package:flutter_wordle/local.data.dart';
import 'package:flutter_wordle/mock.dart';
import 'package:flutter_wordle/theme.dart';
import 'package:flutter_wordle/widget.dart';
import 'package:flutter_wordle/widget_keyboard.dart';
import 'package:intl/intl.dart';

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
    super.initState();

    getPreference();

    Future.delayed(const Duration(seconds: 1), () {
      showHelp();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ThemeApp().backgroundColor,
        leading: IconButton(
            tooltip: 'Ajuda',
            onPressed: () {
              showHelp();
            },
            icon: Icon(Icons.help_outline, color: ThemeApp().primaryTextColor)),
        title: Text(
          widget.title,
          style: TextStyle(color: ThemeApp().primaryTextColor),
        ),
        actions: [
          IconButton(
              tooltip: 'Estatísticas',
              onPressed: () {
                showStatistics();
              },
              icon: Icon(Icons.stacked_bar_chart, color: ThemeApp().primaryTextColor)),
        ],
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
                  text: 'Tente advinhar palavra do dia em 6 tentativas.\n'
                      'Cada tentativa tem de ser uma palavra de 5 letras. Use o botão Enter ↵ para submeter.\n'
                      'Depois de cada tentativa, a cor dos quadrados mudará para mostrar quão perto você esta da solução.!',
                  style: TextStyle(
                    color: ThemeApp().primaryTextColor,
                  ),
                ),
              ]),
            ),
            const SizedBox(height: 10),
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
                    colorLetra: ThemeApp().keyboardExistColor,
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
                    colorLetra: ThemeApp().keyboardErrorColor,
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
            const SizedBox(height: 10),
            Divider(color: ThemeApp().shadownColor),
            Text(
              '* Use letra C para Ç\n'
              '* Fique atento, as palavras do desafio do dia podem possuir acento, mas o jogo desconsidera acento para melhor jogabilidade.\n'
              '\nEsta é uma adaptação para Português do Wordle de Josh Wardle.\n',
              style: TextStyle(
                color: ThemeApp().primaryTextColor,
              ),
              textAlign: TextAlign.justify,
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

  // Future<void> getPreference() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   var dias_jogados = prefs.getInt('dias_jogados') ?? 0;
  //   var jogo_finalizado_hoje = prefs.getBool('jogo_finalizado_hoje') ?? false;
  //   var ultimo_dia_jogado = DateTime.tryParse(prefs.getString('ultimo_dia_jogado') ?? DateTime.now().toIso8601String());
  //   //
  //   String formattedDate = DateFormat('dd-MM-yyyy').format(ultimo_dia_jogado!);
  //   _ultimoDiaJogado = formattedDate;

  //   _diasJogados = dias_jogados;
  //   if (formattedDate != DateFormat('dd-MM-yyyy').format(DateTime.now())) {
  //     dias_jogados++;
  //     jogo_finalizado_hoje = false;
  //     ultimo_dia_jogado = DateTime.now();
  //   }
  //   //
  //   await prefs.setString('ultimo_dia_jogado', ultimo_dia_jogado.toIso8601String());
  //   await prefs.setInt('dias_jogados', dias_jogados);
  //   await prefs.setBool('jogo_finalizado_hoje', jogo_finalizado_hoje);
  // }

  Future showStatistics() async {
    List<String> frases = getGameData();

    return showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: Text('Estatísticas do Jogo', style: TextStyle(color: ThemeApp().primaryTextColor)),
            backgroundColor: ThemeApp().backgroundColor,
            actions: [
              TextButton(
                child: Text('Fechar', style: TextStyle(color: ThemeApp().primaryTextColor)),
                onPressed: () => Navigator.pop(context),
              )
            ],
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: frases
                  .map((e) => Text(e, style: TextStyle(color: ThemeApp().primaryTextColor), textAlign: TextAlign.left))
                  .toList(),
              // children: [
              //   Text('Dias jogados: $diasJogados',
              //       style: TextStyle(color: ThemeApp().primaryTextColor), textAlign: TextAlign.left),
              //   Text('Último dia jogado: $ultimoDiaJogado',
              //       style: TextStyle(color: ThemeApp().primaryTextColor), textAlign: TextAlign.left),
              // ],
            ),
          );
        });
  }
}
