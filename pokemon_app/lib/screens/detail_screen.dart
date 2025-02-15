import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
//import '../models/pokemon.dart';
import '../providers/pokemon_provider.dart';
import '../providers/auth_provider.dart';

//Pantalla de detalles, muestra la informacion del pokemon
class DetailScreen extends StatefulWidget {
  final String pokemonName; //Nombre del pokemon

  DetailScreen({required this.pokemonName});

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  String errorMessage = "";
  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      try {
        await Provider.of<PokemonProvider>(
          context,
          listen: false,
        ).fetchPokemonDetails(widget.pokemonName);
      } catch (e) {
        setState(() {
          errorMessage = "Error al cargar detalles. Verifica tu conexión.";
        });
      }
    });
  }

  //Si la info del pokemon es correcta se crea la UI
  @override
  Widget build(BuildContext context) {
    final pokemonProvider = Provider.of<PokemonProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text(widget.pokemonName.toUpperCase())),
      body:
          pokemonProvider.isLoading
              ? Center(child: CircularProgressIndicator())
              : pokemonProvider.selectedPokemon == null
              ? Center(child: Text("No se pudo cargar la información."))
              : _buildDetails(pokemonProvider),
    );
  }

  // Metodo que contruye la UI con la info de pokemon
  Widget _buildDetails(PokemonProvider pokemonProvider) {
    final pokemon = pokemonProvider.selectedPokemon!;
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.network(pokemon.imageUrl, height: 150), //Imagen del pokemon
          SizedBox(height: 10), //Nombre del pokemon
          Text(
            pokemon.name.toUpperCase(),
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),

          // Tipos del pokemon
          _buildSectionTitle("Tipos"),
          Wrap(
            spacing: 8,
            children:
                pokemon.types
                    .map((type) => Chip(label: Text(type.toUpperCase())))
                    .toList(),
          ),
          SizedBox(height: 10),

          // Habilidades del pokemon
          _buildSectionTitle("Habilidades"),
          Column(
            children:
                pokemon.abilities
                    .map(
                      (ability) =>
                          Text(ability, style: TextStyle(fontSize: 16)),
                    )
                    .toList(),
          ),
          SizedBox(height: 10),

          // Estadísticas del pokemon
          _buildSectionTitle("Estadísticas"),
          Column(
            children:
                pokemon.stats.entries
                    .map(
                      (stat) => Text(
                        "${stat.key}: ${stat.value}",
                        style: TextStyle(fontSize: 16),
                      ),
                    )
                    .toList(),
          ),
          SizedBox(height: 10),

          // Evoluciones del pokemon
          _buildSectionTitle("Evoluciones"),
          Wrap(
            spacing: 8,
            children:
                pokemon.evolutions
                    .map((evo) => Chip(label: Text(evo.toUpperCase())))
                    .toList(),
          ),
          SizedBox(height: 20),

          // Boton para ver la evolucion del pokemon
          ElevatedButton(
            onPressed:
                pokemon.nextEvolution != null
                    ? () {
                      pokemonProvider.evolvePokemon();
                    }
                    : null,
            child: Text(
              pokemon.nextEvolution != null
                  ? "Evolucionar a ${pokemon.nextEvolution!.toUpperCase()}"
                  : "No puede evolucionar",
            ),
          ),

          // Boton para agregar a favoritos
          ElevatedButton(
            onPressed: () async {
              String? responseMessage = await Provider.of<AuthProvider>(
                context,
                listen: false,
              ).addFavorite(pokemon.name);
              ScaffoldMessenger.of(context).showSnackBar(
                // Muestra mensaje con que se agrego a favoritos
                SnackBar(
                  content: Text(
                    responseMessage ?? "Error al agregar a favorito",
                  ),
                ),
              );
            },
            child: Text("Agregar a Favoritos"),
          ),
        ],
      ),
    );
  }

  // Metodo para los titulos con su respectivo divisor
  Widget _buildSectionTitle(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 10),
        Text(
          title,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Divider(),
      ],
    );
  }
}
