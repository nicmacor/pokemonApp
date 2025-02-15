import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/pokemon_provider.dart';
//import 'screens/home_screen.dart';
import 'providers/auth_provider.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        // Provedores para manejar el estado de la app
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => PokemonProvider()),
      ],
      child: MyApp(),
    ),
  );
}

//Clase principal de la app
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pokémon App',
      theme: ThemeData(primarySwatch: Colors.red),
      home: LoginScreen(), //Pantalla de inicio Login
    );
  }
}
