//Modelo de un pokemon con sus atributos
class Pokemon {
  final String name;
  final String imageUrl;
  final List<String> types;
  final List<String> abilities;
  final Map<String, int> stats;
  final List<String> evolutions;
  final String? nextEvolution;

  //Constructor
  Pokemon({
    required this.name,
    required this.imageUrl,
    required this.types,
    required this.abilities,
    required this.stats,
    required this.evolutions,
    this.nextEvolution,
  });

  //Convertimos los datos de json a un objeto pokemon
  factory Pokemon.fromJson(Map<String, dynamic> json, List<String> evolutions) {
    return Pokemon(
      name: json['name'],
      imageUrl: json['sprites']['front_default'] ?? '',
      types:
          (json['types'] as List)
              .map((t) => t['type']['name'].toString())
              .toList(),
      abilities:
          (json['abilities'] as List)
              .map((a) => a['ability']['name'].toString())
              .toList(),
      stats: {
        'HP': json['stats'][0]['base_stat'],
        'Ataque': json['stats'][1]['base_stat'],
        'Defensa': json['stats'][2]['base_stat'],
        'Velocidad': json['stats'][5]['base_stat'],
      },
      evolutions: evolutions,
      nextEvolution: () {
        int currentIndex = evolutions.indexOf(json['name']);
        if (currentIndex != -1 && currentIndex < evolutions.length - 1) {
          return evolutions[currentIndex + 1];
        }
        return null;
      }(),
    );
  }
}
