// screens/favorites_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/character_provider.dart';
import '../widgets/character_card.dart';
import '../widgets/search_field.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CharacterProvider>(context);

    return Column(
      children: [
        SearchField(onChanged: (value) => provider.searchQuery = value),
        ElevatedButton(
          onPressed: provider.sortFavoritesByName,
          child: const Text('Сортировать по имени'),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: provider.filteredFavorites.length,
            itemBuilder: (context, index) {
              final character = provider.filteredFavorites[index];
              return CharacterCard(
                character: character,
                isFavorite: true,
                onFavoriteToggle: () => provider.toggleFavorite(character),
              );
            },
          ),
        ),
      ],
    );
  }
}
