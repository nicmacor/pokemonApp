import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'login_screen.dart';

//Pantalla de registro de usuarios
class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // Controladores para capturar la entrada de texto del usuario
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _cedulaController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      // titulo
      appBar: AppBar(title: Text("Registro")),
      // cuerpo
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            //cedula
            TextField(
              controller: _cedulaController,
              decoration: InputDecoration(labelText: "Cedula"),
            ),
            //nombre de usuario
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: "Usuario"),
            ),
            //contrasena
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: "Contraseña"),
              obscureText: true,
            ),
            SizedBox(height: 20),
            //Boton para registrar
            ElevatedButton(
              onPressed: () async {
                String? message = await authProvider.register(
                  _cedulaController.text,
                  _usernameController.text,
                  _passwordController.text,
                );
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(message ?? "Error al registrar")),
                );

                if (message == "Usuario registrado con éxito") {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                  );
                }
              },
              child: Text("Registrarse"),
            ),
          ],
        ),
      ),
    );
  }
}
