import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'home_screen.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String errorMessage = "";
  bool isLoading = false; // Para manejar el estado de carga

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    //final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.red.shade400, Colors.orange.shade200],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Logo de la app
                  Image.asset(
                    "assets/pokeball.png",
                    width: 300, // Ajusta el tamaño aquí
                    height: 300, // Ajusta el tamaño aquí
                    fit: BoxFit.contain,
                  ),
                  SizedBox(height: 20),

                  // Tarjeta de Login
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    elevation: 8,
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        children: [
                          Text(
                            "Iniciar Sesión",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          SizedBox(height: 20),

                          // Usuario
                          TextField(
                            controller: _usernameController,
                            decoration: InputDecoration(
                              labelText: "Usuario",
                              prefixIcon: Icon(Icons.person, color: Colors.red),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          SizedBox(height: 15),

                          // Contraseña
                          TextField(
                            controller: _passwordController,
                            obscureText: true,
                            decoration: InputDecoration(
                              labelText: "Contraseña",
                              prefixIcon: Icon(Icons.lock, color: Colors.red),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          SizedBox(height: 15),

                          // Mensaje de error
                          if (errorMessage.isNotEmpty)
                            Padding(
                              padding: EdgeInsets.only(bottom: 10),
                              child: Text(
                                errorMessage,
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 16,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),

                          // Botón de Login
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed:
                                  isLoading
                                      ? null
                                      : () async {
                                        setState(() {
                                          errorMessage = "";
                                          isLoading = true;
                                        });

                                        try {
                                          bool success = await authProvider
                                              .login(
                                                _usernameController.text,
                                                _passwordController.text,
                                              );

                                          if (success) {
                                            Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                builder: (_) => HomeScreen(),
                                              ),
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
                                        } finally {
                                          setState(() {
                                            isLoading = false;
                                          });
                                        }
                                      },
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                backgroundColor: Colors.red,
                              ),
                              child:
                                  isLoading
                                      ? CircularProgressIndicator(
                                        color: Colors.white,
                                      )
                                      : Text(
                                        "Ingresar",
                                        style: TextStyle(fontSize: 18),
                                      ),
                            ),
                          ),

                          SizedBox(height: 15),

                          // Registro
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => RegisterScreen(),
                                ),
                              );
                            },
                            child: Text(
                              "¿No tienes cuenta? Regístrate aquí",
                              style: TextStyle(
                                color: Colors.blue,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
