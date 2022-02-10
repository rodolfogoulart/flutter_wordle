import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class Data {
  late String _ultimoDiaJogado;
  late int _diasJogados;
  late List<String> _pontuacao;
  late bool _jogoFinalizadoHoje;

  set setUltimoDiaJogado(String dia) {
    _ultimoDiaJogado = dia;
  }

  set setDiasJogados(int dias) {
    _diasJogados = dias;
  }

  String get getUltimoDiaJogado => _ultimoDiaJogado;

  int get getDiasJogados => _diasJogados;

  set setJogoFinalizadoHoje(bool value) {
    _jogoFinalizadoHoje = value;
  }

  bool get getJogoFinalizadoHoje => _jogoFinalizadoHoje;

  void setPontuacao(List<String> pontuacao, {typePontuacao? typePontuacao}) {
    if (typePontuacao != null) {
      _pontuacao[typePontuacao.index] = pontuacao.first;
    } else {
      _pontuacao = pontuacao;
    }
  }

  List<String> getPontuacao({typePontuacao? typePontuacao}) {
    if (typePontuacao != null) {
      return <String>[_pontuacao[typePontuacao.index]];
    } else {
      return _pontuacao;
    }
  }
}

class GlobalData extends Data {
  static final GlobalData _instance = GlobalData._internal();

  factory GlobalData() {
    return _instance;
  }

  GlobalData._internal() {
    _ultimoDiaJogado = "";
    _diasJogados = 0;
    _pontuacao = [];
  }
}

///type acesso preferencias
enum typePref { diasJogados, ultimoDiaJogado, jogoFinalizadoHoje, pontuacao }

///
/// [0] = acertos 1 tentativa - pontuacao = 6
///
/// [1] = acertos 2 tentativa - pontuacao = 5
///
/// [2] = acertos 3 tentativa - pontuacao = 4
///
/// [3] = acertos 4 tentativa - pontuacao = 3
///
/// [4] = acertos 5 tentativa - pontuacao = 2
///
/// [5] = acertos 6 tentativa - pontuacao = 1
///
/// [6] = pontuacao letra correta = 2
///
/// [7] = pontuacao letra existente = 1
///
/// [8] = numero derrotas = -1
enum typePontuacao {
  pontoTentativa1,
  pontoTentativa2,
  pontoTentativa3,
  pontoTentativa4,
  pontoTentativa5,
  pontoTentativa6,
  letrasCorretas,
  letrasExistentes,
  derrotas
}

Future<void> getPreference() async {
  final prefs = await SharedPreferences.getInstance();
  var diasJogados = prefs.getInt('diasJogados') ?? 0;
  var jogoFinalizadoHoje = prefs.getBool('jogoFinalizadoHoje') ?? false;
  var ultimoDiaJogado = DateTime.tryParse(prefs.getString('ultimoDiaJogado') ?? DateTime.now().toIso8601String());
  List<String> pontuacao = prefs.getStringList('pontuacao') ?? ['0', '0', '0', '0', '0', '0', '0', '0', '0'];
  //

  //
  String formattedDate = DateFormat('dd-MM-yyyy').format(ultimoDiaJogado!);

  GlobalData._instance.setUltimoDiaJogado = formattedDate;
  GlobalData._instance.setDiasJogados = diasJogados;
  GlobalData._instance.setPontuacao(pontuacao);

  if (formattedDate != DateFormat('dd-MM-yyyy').format(DateTime.now())) {
    diasJogados++;
    jogoFinalizadoHoje = false;
    ultimoDiaJogado = DateTime.now();
  }
  //
  await setPreference(typePref.diasJogados, diasJogados);
  await setPreference(typePref.ultimoDiaJogado, ultimoDiaJogado.toIso8601String());
  await setPreference(typePref.jogoFinalizadoHoje, jogoFinalizadoHoje);
  if (pontuacao.isEmpty) {
    await setPreference(typePref.pontuacao, pontuacao);
  }
}

Future<void> setPreference(typePref type, var value, {typePontuacao? typePontuacao, var valuePontuacao}) async {
  final prefs = await SharedPreferences.getInstance();

  switch (type) {
    case typePref.diasJogados:
      await prefs.setInt('diasJogados', value);
      GlobalData._instance.setDiasJogados = value;
      break;
    case typePref.ultimoDiaJogado:
      await prefs.setString('ultimoDiaJogado', value);
      GlobalData._instance.setUltimoDiaJogado = value;
      break;
    case typePref.jogoFinalizadoHoje:
      await prefs.setBool('jogoFinalizadoHoje', value);
      GlobalData._instance.setJogoFinalizadoHoje = value;
      break;
    case typePref.pontuacao:
      await prefs.setStringList('pontuacao', value);
      break;
  }
}

Future<void> setPreferencePontuacao(typePontuacao type, var value) async {
  final prefs = await SharedPreferences.getInstance();
  List<String> pontuacao = prefs.getStringList('pontuacao') ?? ['0', '0', '0', '0', '0', '0', '0', '0', '0'];
  pontuacao[type.index] = value.toString();
  await prefs.setStringList('pontuacao', pontuacao);
  GlobalData._instance._pontuacao = pontuacao;
}

List<String> getGameData() {
  int diasJogados = GlobalData().getDiasJogados;
  String ultimoDiaJogado = DateFormat('dd-MM-yyyy').format(DateTime.tryParse(GlobalData().getUltimoDiaJogado)!);
  bool jogoFinalizadoHoje = GlobalData().getJogoFinalizadoHoje;
  List<String> pontuacao = GlobalData().getPontuacao();

  List<String> frases = [
    'Dias jogados: $diasJogados',
    'Último dia jogado: $ultimoDiaJogado\n',
    // 'Jogo finalizado hoje: $jogoFinalizadoHoje',
    'Pontuação:',
    'Finalizado na 1º Tentativa: ${pontuacao[0]}',
    'Finalizado na 2º Tentativa: ${pontuacao[1]}',
    'Finalizado na 3º Tentativa: ${pontuacao[2]}',
    'Finalizado na 4º Tentativa: ${pontuacao[3]}',
    'Finalizado na 5º Tentativa: ${pontuacao[4]}',
    'Finalizado na 6º Tentativa: ${pontuacao[5]}',
    'Vezes que acertou a letra no lugar correto: ${pontuacao[6]}',
    'Vezes que acertou a letra no lugar errado: ${pontuacao[7]}',
    'Vezes que não acertou o desafio do dia: ${pontuacao[8]}',
  ];
  return frases;
}
