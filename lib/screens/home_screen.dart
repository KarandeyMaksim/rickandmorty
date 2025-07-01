// screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/character_provider.dart';
import '../widgets/character_card.dart';
import '../widgets/search_field.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CharacterProvider>(context);
    final controller = ScrollController();

    controller.addListener(() {
      if (controller.position.pixels >= controller.position.maxScrollExtent - 200) {
        provider.fetchCharacters();
      }
    });

    return Column(
      children: [
        SearchField(onChanged: (value) => provider.searchQuery = value),
        Expanded(
          child: ListView.builder(
            controller: controller,
            itemCount: provider.filteredCharacters.length,
            itemBuilder: (context, index) {
              final character = provider.filteredCharacters[index];
              return CharacterCard(
                character: character,
                isFavorite: provider.isFavorite(character.id),
                onFavoriteToggle: () => provider.toggleFavorite(character),
              );
            },
          ),
        ),
      ],
    );
  }
}
