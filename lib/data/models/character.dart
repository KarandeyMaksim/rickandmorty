// lib/data/models/character.dart
class Character {
  final int id;
  final String name;
  final String image;
  final String status;
  final String species;
  final String location;

  Character({
    required this.id,
    required this.name,
    required this.image,
    required this.status,
    required this.species,
    required this.location,
  });

  factory Character.fromJson(Map<String, dynamic> json) => Character(
        id: json['id'],
        name: json['name'],
        image: json['image'],
        status: json['status'],
        species: json['species'],
        location: json['location'] != null && json['location'] is Map
    ? json['location']['name']
    : json['location'].toString(),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'image': image,
        'status': status,
        'species': species,
        'location': location,
      };
}
