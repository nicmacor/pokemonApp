import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'detail_screen.dart'; // Importa la pantalla de detalles

// Pantalla que muestra los Pokémon favoritos del usuario con mejor UI
class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  List<String> favorites = [];
  bool isLoading = true;
  String errorMessage = "";

  @override
  void initState() {
    super.initState();
    _loadFavorites(); // Cargar los Pokémon favoritos
  }

  // Método para obtener los favoritos con manejo de errores
  Future<void> _loadFavorites() async {
    final apiService = ApiService();
    try {
      final favs = await apiService.getFavorites();
      setState(() {
        favorites = favs;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = "Error al cargar favoritos. Verifica tu conexión.";
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Pokémon Favoritos')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child:
            isLoading
                ? Center(child: CircularProgressIndicator())
                : errorMessage.isNotEmpty
                ? _buildErrorWidget()
                : favorites.isEmpty
                ? _buildEmptyFavoritesWidget()
                : _buildFavoritesList(),
      ),
    );
  }

  // 🔹 Widget para mostrar mensaje de error con un botón de reintento
  Widget _buildErrorWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error, color: Colors.red, size: 50),
          SizedBox(height: 10),
          Text(
            errorMessage,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.red, fontSize: 18),
          ),
          SizedBox(height: 15),
          ElevatedButton(
            onPressed: _loadFavorites,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
            child: Text("Reintentar", style: TextStyle(fontSize: 16)),
          ),
        ],
      ),
    );
  }

  // 🔹 Widget para mostrar cuando no hay Pokémon favoritos
  Widget _buildEmptyFavoritesWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.favorite_border, color: Colors.grey, size: 50),
          SizedBox(height: 10),
          Text(
            "No tienes Pokémon favoritos",
            style: TextStyle(fontSize: 18, color: Colors.black54),
          ),
        ],
      ),
    );
  }

  // 🔹 Widget para mostrar la lista de Pokémon favoritos con tarjetas visuales
  Widget _buildFavoritesList() {
    return ListView.builder(
      itemCount: favorites.length,
      itemBuilder: (context, index) {
        return Card(
          elevation: 4,
          margin: EdgeInsets.symmetric(vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            leading: Icon(
              Icons.catching_pokemon,
              color: Colors.orange,
              size: 30,
            ),
            title: Text(
              favorites[index].toUpperCase(),
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            trailing: Icon(
              Icons.arrow_forward_ios,
              color: Colors.grey,
              size: 18,
            ),
            onTap: () {
              // Al hacer clic en un Pokémon, ir a la pantalla de detalles
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) => DetailScreen(pokemonName: favorites[index]),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
