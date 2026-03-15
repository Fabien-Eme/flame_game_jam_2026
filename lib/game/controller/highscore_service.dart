import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../utils/secrets.dart';

class HighscoreService {
  static const String _baseUrl = googleSheetUrl;

  // Envoyer le temps final (ex: 12.450 secondes)
  static Future<void> saveScore(String pseudo, double timeElapsed) async {
    final url = Uri.parse(_baseUrl).replace(queryParameters: {'action': 'add', 'name': pseudo, 'score': timeElapsed.toString()});
    await http.get(url);
  }

  // Récupérer le top 10
  static Future<List<dynamic>> fetchScores() async {
    final response = await http.get(Uri.parse('$_baseUrl?action=get'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }

    return [];
  }
}
