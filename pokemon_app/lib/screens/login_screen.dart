import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'home_screen.dart';
import 'register_screen.dart';

// Pantalla de Login de usuarios
class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  //Controladores para capturar los valores ingresados por usuarios
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String errorMessage = "";

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text("Iniciar Sesión")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            //Nombre usuario
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: "Usuario"),
            ),
            //Entrada contrasena
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: "Contraseña"),
              obscureText: true,
            ),
            SizedBox(height: 20),
            if (errorMessage.isNotEmpty)
              Text(
                errorMessage,
                style: TextStyle(color: Colors.red, fontSize: 16),
                textAlign: TextAlign.center,
              ),
            //boton de inicio de sesion
            ElevatedButton(
              onPressed: () async {
                setState(() {
                  errorMessage =
                      ""; //Resetea el mensaje de error antes de iniciar sesión.
                });
                try {
                  bool success = await authProvider.login(
                    _usernameController.text,
                    _passwordController.text,
                  );

                  if (success) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => HomeScreen()),
                    );
                  } else {
                    setState(() {
                      errorMessage =
                          "Credenciales incorrectas. Intenta de nuevo.";
                    });
                  }
                } catch (e) {
                  setState(() {
                    errorMessage =
                        "Error al conectar con el servidor. Verifica tu conexión.";
                  });
                }
              },
              child: Text("Ingresar"),
            ),
            //link registrarse
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RegisterScreen()),
                );
              },
              child: Text("¿No tienes cuenta? Regístrate aquí"),
            ),
          ],
        ),
      ),
    );
  }
}
