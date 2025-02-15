import 'package:flutter/material.dart';
import '../models/pokemon.dart';
import '../services/pokemon_service.dart';

// Provedor de datos para la gestion de pokemons
class PokemonProvider with ChangeNotifier {
  final PokemonService _service = PokemonService();
  Pokemon? _selectedPokemon;
  bool _isLoading = false;
  String _errorMessage = "";
  List<Pokemon> _pokemonList = []; //Lista de pokemons

  //getters para exponer el estado del proveedor
  Pokemon? get selectedPokemon => _selectedPokemon;
  String get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;
  List<Pokemon> get pokemonList => _pokemonList;

  //Metodo para obtener la lista de pokemon desde el servicio
  Future<void> fetchPokemon() async {
    _isLoading = true;
    _errorMessage = "";
    notifyListeners();

    try {
      _pokemonList = await _service.fetchPokemonList();
    } catch (e) {
      _errorMessage = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  // Metodo para obtener los detalles de un pokemon especifico
  Future<void> fetchPokemonDetails(String name) async {
    _isLoading = true;
    _errorMessage = "";
    notifyListeners();

    try {
      _selectedPokemon = await _service.fetchPokemonDetails(name);
    } catch (e) {
      _errorMessage = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  //Metodo para evolucionar un pokemon si tiene una siguiente evolucion
  void evolvePokemon() {
    if (_selectedPokemon?.nextEvolution != null) {
      String nextEvolutionName = _selectedPokemon!.nextEvolution!;
      _selectedPokemon = null;
      notifyListeners();
      fetchPokemonDetails(
        nextEvolutionName,
      ); //Obtiene los detalles de la evolucion
    } else {
      print("Este Pokémon no puede evolucionar más.");
    }
  }
}
