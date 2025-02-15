import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Provedor de autenticacion y gestion de los pokemon favoritos
class AuthProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  bool _isAuthenticated = false;
  List<String> _favorites = [];

  //getters para acceder al estado de autenticacion y favoritos
  bool get isAuthenticated => _isAuthenticated;
  List<String> get favorites => _favorites;

  //metodo para iniciar sesion con username y contrasena
  Future<bool> login(String username, String password) async {
    bool success = await _apiService.loginUser(username, password);
    if (success) {
      _isAuthenticated = true;
      notifyListeners();
    }
    return success;
  }

  // Metodo para registrar un nuevo usuario con cedula, usuario y contrasena
  Future<String?> register(
    String cedula,
    String username,
    String password,
  ) async {
    return await _apiService.registerUser(cedula, username, password);
  }

  // Metodo para cargar los favoritos del usuario
  Future<void> loadFavorites() async {
    _favorites = await _apiService.getFavorites();
    notifyListeners();
  }

  //Metodo para agregar favoritos
  Future<String?> addFavorite(String pokemonName) async {
    String? responseMessage = await _apiService.addFavorite(pokemonName);
    await loadFavorites();
    return responseMessage; // Retornar el mensaje
  }

  //Metodo para cerrar sesion, elimina el token almacenado y actualiza el estado
  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove("auth_token");
    _isAuthenticated = false;
    notifyListeners();
  }
}
