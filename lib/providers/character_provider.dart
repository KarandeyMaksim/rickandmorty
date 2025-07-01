// lib/providers/character_provider.dart
import 'package:flutter/material.dart';
import '../data/models/character.dart';
import '../data/services/api_service.dart';
import '../data/services/local_storage_service.dart';

class CharacterProvider extends ChangeNotifier {
  final _apiService = ApiService();
  final _localStorage = LocalStorageService();

  List<Character> _characters = [];
  List<Character> get characters => _characters;

  List<Character> _favorites = [];
  List<Character> get favorites => _favorites;

  int _currentPage = 1;
  bool _isLoading = false;
  // providers/character_provider.dart (добавим внутрь класса)
String _searchQuery = '';
String get searchQuery => _searchQuery;

set searchQuery(String value) {
  _searchQuery = value;
  notifyListeners();
}

List<Character> get filteredCharacters {
  if (_searchQuery.isEmpty) return _characters;
  return _characters
      .where((c) => c.name.toLowerCase().contains(_searchQuery.toLowerCase()))
      .toList();
}

List<Character> get filteredFavorites {
  if (_searchQuery.isEmpty) return _favorites;
  return _favorites
      .where((c) => c.name.toLowerCase().contains(_searchQuery.toLowerCase()))
      .toList();
}


  CharacterProvider() {
    fetchCharacters();
    loadFavorites();
  }

  Future<void> fetchCharacters() async {
    if (_isLoading) return;
    _isLoading = true;

    try {
      final newCharacters = await _apiService.fetchCharacters(_currentPage);
      _characters.addAll(newCharacters);
      _currentPage++;
      notifyListeners();
    } finally {
      _isLoading = false;
    }
  }

  Future<void> loadFavorites() async {
    _favorites = await _localStorage.getFavorites();
    notifyListeners();
  }

  Future<void> toggleFavorite(Character character) async {
    if (_favorites.any((c) => c.id == character.id)) {
      _favorites.removeWhere((c) => c.id == character.id);
      await _localStorage.removeFavorite(character.id);
    } else {
      _favorites.add(character);
      await _localStorage.saveFavorite(character);
    }
    notifyListeners();
  }

  bool isFavorite(int id) {
    return _favorites.any((c) => c.id == id);
  }

  void sortFavoritesByName() {
    _favorites.sort((a, b) => a.name.compareTo(b.name));
    notifyListeners();
  }
}
