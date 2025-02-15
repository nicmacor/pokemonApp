import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'login_screen.dart';

// Pantalla de Registro de usuarios con diseño atractivo y responsivo
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // Controladores para capturar la entrada del usuario
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _cedulaController = TextEditingController();
  bool isLoading = false; // Para indicar si está procesando el registro

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final size = MediaQuery.of(context).size; // Obtener tamaño de la pantalla

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.orangeAccent, Colors.redAccent],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo o imagen decorativa
                  Image.asset("assets/pokeball.png", height: 300, width: 300),
                  SizedBox(height: 10),

                  // Tarjeta de Registro
                  Container(
                    width: size.width * 0.9,
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Text(
                          "Registro",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: 20),

                        // Campo Cédula
                        _buildTextField(
                          controller: _cedulaController,
                          hintText: "Cédula",
                          icon: Icons.credit_card,
                        ),
                        SizedBox(height: 12),

                        // Campo Usuario
                        _buildTextField(
                          controller: _usernameController,
                          hintText: "Usuario",
                          icon: Icons.person,
                        ),
                        SizedBox(height: 12),

                        // Campo Contraseña
                        _buildTextField(
                          controller: _passwordController,
                          hintText: "Contraseña",
                          icon: Icons.lock,
                          obscureText: true,
                        ),
                        SizedBox(height: 20),

                        // Botón de Registro
                        ElevatedButton(
                          onPressed:
                              isLoading
                                  ? null
                                  : () async {
                                    setState(() {
                                      isLoading = true;
                                    });

                                    String? message = await authProvider
                                        .register(
                                          _cedulaController.text,
                                          _usernameController.text,
                                          _passwordController.text,
                                        );

                                    setState(() {
                                      isLoading = false;
                                    });

                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          message ?? "Error al registrar",
                                        ),
                                      ),
                                    );

                                    if (message ==
                                        "Usuario registrado con éxito") {
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => LoginScreen(),
                                        ),
                                      );
                                    }
                                  },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            padding: EdgeInsets.symmetric(
                              horizontal: 50,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child:
                              isLoading
                                  ? CircularProgressIndicator(
                                    color: Colors.white,
                                  )
                                  : Text(
                                    "Registrarse",
                                    style: TextStyle(fontSize: 16),
                                  ),
                        ),

                        SizedBox(height: 15),

                        // Enlace a Login
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LoginScreen(),
                              ),
                            );
                          },
                          child: Text(
                            "¿Ya tienes cuenta? Inicia sesión",
                            style: TextStyle(color: Colors.blue),
                          ),
                        ),
                      ],
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

  // Widget reutilizable para los campos de texto
  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    bool obscureText = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.redAccent),
        hintText: hintText,
        filled: true,
        fillColor: Colors.grey[200],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
