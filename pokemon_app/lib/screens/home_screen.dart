import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/pokemon_provider.dart';
import '../screens/detail_screen.dart';
import '../providers/auth_provider.dart';
import '../screens/login_screen.dart';
import '../screens/favorites_screen.dart';

// Pantalla principal, pantalla con la lista del pokemon
class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => Provider.of<PokemonProvider>(context, listen: false).fetchPokemon(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pokemonProvider = Provider.of<PokemonProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Pokémon List'),
        actions: [
          // Menu desplegable para las opciones del usuario
          PopupMenuButton<String>(
            icon: Icon(Icons.account_circle), // Ícono de usuario
            onSelected: (String result) {
              if (result == 'favorites') {
                Navigator.push(
                  //Navega a pantalla favoritos
                  context,
                  MaterialPageRoute(builder: (context) => FavoritesScreen()),
                );
              } else if (result == 'logout') {
                //Cierra sesion y dirige al log in, quita token
                Provider.of<AuthProvider>(context, listen: false).logout();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              }
            },
            itemBuilder:
                (BuildContext context) => <PopupMenuEntry<String>>[
                  // Favoritos
                  PopupMenuItem<String>(
                    value: 'favorites',
                    child: ListTile(
                      leading: Icon(Icons.favorite, color: Colors.red),
                      title: Text('Ver Favoritos'),
                    ),
                  ),
                  // Logout
                  PopupMenuItem<String>(
                    value: 'logout',
                    child: ListTile(
                      leading: Icon(Icons.logout, color: Colors.black),
                      title: Text('Cerrar Sesión'),
                    ),
                  ),
                ],
          ),
        ],
      ),
      // Cuerpo de pantalla, La lista el pokemon
      body:
          pokemonProvider.isLoading
              ? Center(child: CircularProgressIndicator())
              : pokemonProvider.errorMessage.isNotEmpty
              ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      pokemonProvider.errorMessage,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.red, fontSize: 18),
                    ),
                    SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () => pokemonProvider.fetchPokemon(),
                      child: Text("Reintentar"),
                    ),
                  ],
                ),
              )
              : ListView.builder(
                itemCount: pokemonProvider.pokemonList.length,
                itemBuilder: (context, index) {
                  final pokemon = pokemonProvider.pokemonList[index];
                  return Card(
                    child: ListTile(
                      leading: Image.network(pokemon.imageUrl),
                      title: Text(pokemon.name.toUpperCase()),
                      onTap: () {
                        //Al seleccionar dirige a pantalla detalles
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) =>
                                    DetailScreen(pokemonName: pokemon.name),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
    );
  }
}
