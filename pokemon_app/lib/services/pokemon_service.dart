import 'package:dio/dio.dart';
import '../models/pokemon.dart';

// Servicio para obtener datos del pokemon desde pokeAPI
class PokemonService {
  final Dio _dio = Dio();
  final String _baseUrl = "https://pokeapi.co/api/v2/pokemon";

  // Método para obtener la lista de Pokémon
  Future<List<Pokemon>> fetchPokemonList() async {
    try {
      final response = await _dio.get(_baseUrl);
      List results = response.data['results'];
      List<Pokemon> pokemonList = [];
      // Iterar sobre resultados para obtener detalles de los pokemones
      for (var result in results) {
        var pokemonResponse = await _dio.get(result['url']);
        pokemonList.add(Pokemon.fromJson(pokemonResponse.data, []));
      }

      return pokemonList;
    } on DioException catch (e) {
      print("Error de conexión: ${e.message}");
      throw Exception("Error al obtener la lista de Pokémon");
    } catch (e) {
      print("Error desconocido: $e");
      throw Exception("Error inesperado al obtener la lista de Pokémon.");
    }
  }

  //Metodo para obtener los detalles de un pokemon especifico
  Future<Pokemon> fetchPokemonDetails(String name) async {
    try {
      final response = await _dio.get("$_baseUrl/$name");

      final speciesResponse = await _dio.get(response.data['species']['url']);
      final evolutionChainUrl = speciesResponse.data['evolution_chain']['url'];
      final evolutionResponse = await _dio.get(evolutionChainUrl);
      List<String> evolutions = _parseEvolutionChain(evolutionResponse.data);

      return Pokemon.fromJson(response.data, evolutions);
    } on DioException catch (e) {
      print("Error de conexión al obtener detalles: ${e.message}");
      throw Exception(
        "No se pudo obtener los detalles del Pokémon. Verifica tu conexión.",
      );
    } catch (e) {
      print("Error inesperado al obtener detalles: $e");
      throw Exception("Error desconocido al obtener detalles del Pokémon.");
    }
  }

  // Metodo para extraer la línea evolutiva de un pokemon
  List<String> _parseEvolutionChain(Map<String, dynamic> data) {
    List<String> evolutionNames = [];

    var chain = data['chain'];
    while (chain != null) {
      evolutionNames.add(chain['species']['name']);
      chain = chain['evolves_to'].isNotEmpty ? chain['evolves_to'][0] : null;
    }

    return evolutionNames;
  }
}
