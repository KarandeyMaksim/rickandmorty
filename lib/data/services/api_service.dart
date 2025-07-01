// lib/data/services/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/character.dart';

class ApiService {
  static const baseUrl = 'https://rickandmortyapi.com/api/character';

  Future<List<Character>> fetchCharacters(int page) async {
    final response = await http.get(Uri.parse('$baseUrl?page=$page'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final results = data['results'] as List;
      return results.map((e) => Character.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load characters');
    }
  }
}
