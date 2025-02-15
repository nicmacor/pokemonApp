import 'package:flutter/material.dart';
import '../services/api_service.dart';

// Pantalla que muestra los pokemon favoritos del usuario
class FavoritesScreen extends StatefulWidget {
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
    _loadFavorites(); // Carga los pokemones favoritos
  }

  // Metodo para obtener los favoritos
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

  //
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Pokémon Favoritos')),
      body:
          isLoading
              ? Center(child: CircularProgressIndicator())
              //Si no se carga los pokemon favoritos, error de consumir la api
              : errorMessage.isNotEmpty
              ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      errorMessage,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.red, fontSize: 18),
                    ),
                    SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: _loadFavorites,
                      child: Text("Reintentar"),
                    ),
                  ],
                ),
              )
              : favorites.isEmpty
              // Mensaje si no hay pokemon favoritos
              ? Center(child: Text('No tienes Pokémon favoritos'))
              // Lista de pokemon favoritos
              : ListView.builder(
                itemCount: favorites.length,
                itemBuilder: (context, index) {
                  return ListTile(title: Text(favorites[index]));
                },
              ),
    );
  }
}
