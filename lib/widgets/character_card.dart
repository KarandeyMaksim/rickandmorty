// widgets/character_card.dart
import 'package:flutter/material.dart';
import '../data/models/character.dart';
import '../screens/character_detail_screen.dart';

class CharacterCard extends StatelessWidget {
  final Character character;
  final bool isFavorite;
  final VoidCallback onFavoriteToggle;

  const CharacterCard({
    required this.character,
    required this.isFavorite,
    required this.onFavoriteToggle,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => CharacterDetailScreen(character: character),
        ),
      ),
      child: Card(
        elevation: 4,
        margin: const EdgeInsets.all(8),
        child: ListTile(
          leading: Image.network(character.image),
          title: Text(character.name),
          subtitle: Text('${character.status} - ${character.species}\n${character.location}'),
          isThreeLine: true,
          trailing: IconButton(
            icon: Icon(isFavorite ? Icons.star : Icons.star_border),
            onPressed: onFavoriteToggle,
            color: isFavorite ? Colors.yellow : null,
          ),
        ),
      ),
    );
  }
}
