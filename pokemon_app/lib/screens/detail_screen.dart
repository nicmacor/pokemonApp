import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/pokemon_provider.dart';
import '../providers/auth_provider.dart';

// Pantalla de detalles, muestra la información del Pokémon
class DetailScreen extends StatefulWidget {
  final String pokemonName;

  const DetailScreen({super.key, required this.pokemonName});

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

  @override
  Widget build(BuildContext context) {
    final pokemonProvider = Provider.of<PokemonProvider>(context);
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(title: Text(widget.pokemonName.toUpperCase())),
      body:
          pokemonProvider.isLoading
              ? Center(child: CircularProgressIndicator())
              : pokemonProvider.selectedPokemon == null
              ? Center(child: Text("No se pudo cargar la información."))
              : _buildDetails(pokemonProvider, screenWidth),
    );
  }

  // Método que construye la UI con la información del Pokémon
  Widget _buildDetails(PokemonProvider pokemonProvider, double screenWidth) {
    final pokemon = pokemonProvider.selectedPokemon!;

    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Imagen del Pokémon con un fondo decorativo
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.redAccent.withOpacity(0.2),
            ),
            padding: EdgeInsets.all(20),
            child: Image.network(
              pokemon.imageUrl,
              width: screenWidth * 0.4,
              height: screenWidth * 0.4,
              fit: BoxFit.contain,
            ),
          ),
          SizedBox(height: 15),

          // Nombre del Pokémon
          Text(
            pokemon.name.toUpperCase(),
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 15),

          // Tarjeta de Tipos
          _buildCenteredCard(
            "Tipos",
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 8,
              children:
                  pokemon.types
                      .map(
                        (type) => Chip(
                          label: Text(type.toUpperCase()),
                          backgroundColor: Colors.blue.shade200,
                        ),
                      )
                      .toList(),
            ),
          ),

          // Tarjeta de Habilidades
          _buildCenteredCard(
            "Habilidades",
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children:
                  pokemon.abilities
                      .map(
                        (ability) => Text(
                          ability,
                          style: TextStyle(fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                      )
                      .toList(),
            ),
          ),

          // Tarjeta de Estadísticas
          _buildCenteredCard(
            "Estadísticas",
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children:
                  pokemon.stats.entries
                      .map(
                        (stat) => Text(
                          "${stat.key}: ${stat.value}",
                          style: TextStyle(fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                      )
                      .toList(),
            ),
          ),

          // Tarjeta de Evoluciones
          _buildCenteredCard(
            "Evoluciones",
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 8,
              children:
                  pokemon.evolutions
                      .map(
                        (evo) => Chip(
                          label: Text(evo.toUpperCase()),
                          backgroundColor: Colors.green.shade200,
                        ),
                      )
                      .toList(),
            ),
          ),

          SizedBox(height: 20),

          // Botón para evolucionar Pokémon
          _buildButton(
            pokemon.nextEvolution != null
                ? "Evolucionar a ${pokemon.nextEvolution!.toUpperCase()}"
                : "No puede evolucionar",
            pokemon.nextEvolution != null
                ? () {
                  pokemonProvider.evolvePokemon();
                }
                : null,
            Colors.orange,
          ),
          SizedBox(height: 10),

          // Botón para agregar a favoritos
          _buildButton("Agregar a Favoritos", () async {
            String? responseMessage = await Provider.of<AuthProvider>(
              context,
              listen: false,
            ).addFavorite(pokemon.name);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(responseMessage ?? "Error al agregar a favorito"),
              ),
            );
          }, Colors.redAccent),
        ],
      ),
    );
  }

  // Método para construir tarjetas centradas con mejor diseño
  Widget _buildCenteredCard(String title, Widget content) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.center, // Asegura que el contenido se centre
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            Divider(),
            Center(child: content), // Centra el contenido dentro de la tarjeta
          ],
        ),
      ),
    );
  }

  // Método para construir botones de acción
  Widget _buildButton(String text, VoidCallback? onPressed, Color color) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 12),
          backgroundColor: color,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Text(
          text,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
