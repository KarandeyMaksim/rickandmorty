// lib/data/services/local_storage_service.dart
import 'package:hive/hive.dart';
import '../models/character.dart';

class LocalStorageService {
  static const String favoritesBoxName = 'favoritesBox';

  Future<void> saveFavorite(Character character) async {
    final box = await Hive.openBox(favoritesBoxName);
    await box.put(character.id, character.toJson());
  }

  Future<void> removeFavorite(int id) async {
    final box = await Hive.openBox(favoritesBoxName);
    await box.delete(id);
  }

  Future<List<Character>> getFavorites() async {
    final box = await Hive.openBox(favoritesBoxName);
    return box.values.map((e) => Character.fromJson(Map<String, dynamic>.from(e))).toList();
  }

  Future<bool> isFavorite(int id) async {
    final box = await Hive.openBox(favoritesBoxName);
    return box.containsKey(id);
  }
}
