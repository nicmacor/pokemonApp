//import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Servicio de api para comunicarse con el backend
class ApiService {
  final String baseUrl = "http://10.0.2.2:5000";
  final Dio dio = Dio();

  // Metodo para registrar un usuario
  Future<String?> registerUser(
    String cedula,
    String username,
    String password,
  ) async {
    try {
      final response = await dio.post(
        "$baseUrl/register",
        data: {"cedula": cedula, "username": username, "password": password},
        options: Options(headers: {"Content-Type": "application/json"}),
      );

      if (response.statusCode == 201) {
        return "Usuario registrado con éxito";
      } else {
        return response.data["error"];
      }
    } on DioException {
      return "No se pudo conectar al servidor. Verifica tu conexión.";
    } catch (e) {
      return "Error inesperado al registrar el usuario.";
    }
  }

  // Metodo para iniciar sesión y guardar el token
  Future<bool> loginUser(String username, String password) async {
    try {
      final response = await dio.post(
        "$baseUrl/login",
        data: {"username": username, "password": password},
        options: Options(headers: {"Content-Type": "application/json"}),
      );

      if (response.statusCode == 200) {
        final token = response.data["token"];
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString("auth_token", token);
        return true;
      } else {
        return false;
      }
    } on DioException {
      return false;
    } catch (e) {
      return false;
    }
  }

  // Metodo para obtener favoritos
  Future<List<String>> getFavorites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("auth_token");

    if (token == null) return [];

    try {
      final response = await dio.get(
        "$baseUrl/favorites",
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );

      if (response.statusCode == 200) {
        return List<String>.from(response.data["favorites"]);
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  // Metodo para agregar un Pokémon a favoritos
  Future<String?> addFavorite(String pokemonName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("auth_token");

    if (token == null) return "Usuario no autenticado";

    List<String> existingFavorites = await getFavorites();

    if (existingFavorites.contains(pokemonName)) {
      return "$pokemonName ya está en favoritos";
    }

    try {
      final response = await dio.post(
        "$baseUrl/favorites",
        data: {"pokemon_name": pokemonName},
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $token",
          },
        ),
      );
      //se agrego con exito
      if (response.statusCode == 201) {
        return "$pokemonName agregado a favoritos";
      } else {
        return response.data["error"];
      }
    } catch (e) {
      return "Error en la solicitud: $e";
    }
  }
}
