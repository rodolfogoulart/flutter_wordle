import 'dart:convert';
import 'package:http/http.dart' as http;

String _url = 'https://significado.herokuapp.com/';

Future<List<Dicionario>> getHttp(String palavra) async {
  final response = await http.get(Uri.parse(_url + palavra));

  if (response.statusCode == 200) {
    var decodedResponse = jsonDecode(response.body) as List;

    var significados = decodedResponse.map((e) => Dicionario.fromJson(e)).toList();
    // var dicio = Dicionario.fromJson(decodedResponse.first);
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
