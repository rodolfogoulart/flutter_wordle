import 'dart:convert';
import 'package:http/http.dart' as http;

String _url = 'https://significado.herokuapp.com/';

Future<List<Dicionario>> getHttp(String palavra) async {
  final response = await http.get(Uri.parse(_url + palavra));

  if (response.statusCode == 200) {
    var decodedResponse = jsonDecode(response.body) as List;

    var significados = decodedResponse.map((e) => Dicionario.fromJson(e)).toList();
    // var dicio = Dicionario.fromJson(decodedResponse.first);
    //homenagem a minha namorada
    if (palavra.toLowerCase() == 'linda') {
      significados.add(Dicionario(meanings: [
        'Linda: Excessivamente bonita; que chama a atenção pela beleza fora do comum; bela, belíssima,',
        ' que é bom de se ouvir e/ou ver.',
        'Linda ou melhor dizendo Amanda ❤️'
      ]));
    }
    return significados;
  } else {
    return [];
    // throw Exception('Failed to load significados');
  }
}

class Dicionario {
  List? meanings;
  Dicionario({required this.meanings});

  Dicionario.fromJson(Map<String, dynamic> json) {
    meanings = json['meanings'];
  }
}
