import 'package:flutter/material.dart';
import 'package:proyecto_moviles/views/register_view.dart';
import 'package:proyecto_moviles/views/home_view.dart';
import 'package:proyecto_moviles/services/auth_service.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'dart:convert';



class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usuarioController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _mostrarPassword = false;
  bool _loading = false;

  @override
  void dispose() {
    _usuarioController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _iniciarSesion() async {
  if (_formKey.currentState!.validate()) {
    setState(() => _loading = true);

    final response = await AuthService.login(
      username: _usuarioController.text.trim(),
      password: _passwordController.text.trim(),
    );

    setState(() => _loading = false);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final username = data['username'] ?? 'Usuario/a'; // Obtén el nombre de usuario
      final success = data['success'];
      final error = data['error'];

      if (success == true) {
        final token = data['token'];
        Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
        String userId = decodedToken["nameid"] ?? "";

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Sesión iniciada")),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomeView(
              userName: username,
              token: token,
              userId: userId,
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $error")),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error de red: ${response.statusCode}")),
      );
    }
  }
}


  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Logo obligatorio
                  Container(
                    width: double.infinity,
                    height: size.height * 0.25,
                    decoration: BoxDecoration(
                      color: Color(0xFF10BEAE),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(40),
                        bottomRight: Radius.circular(40),
                      ),
                    ),
                    child: Center(
                      child: Image.asset(
                        'assets/images/logo_psymed.png',
                        height: size.height * 0.12,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Iniciar Sesión",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal[800],
                    ),
                  ),
                  SizedBox(height: 32),

                  // Input Usuario
                  TextFormField(
                    controller: _usuarioController,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      labelText: 'Usuario, correo o teléfono',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Este campo es obligatorio';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),

                  // Input Contraseña
                  TextFormField(
                    controller: _passwordController,
                    obscureText: !_mostrarPassword,
                    decoration: InputDecoration(
                      labelText: 'Contraseña',
                      border: OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: Icon(_mostrarPassword
                            ? Icons.visibility_off
                            : Icons.visibility),
                        onPressed: () {
                          setState(() => _mostrarPassword = !_mostrarPassword);
                        },
                        tooltip: _mostrarPassword
                            ? 'Ocultar contraseña'
                            : 'Mostrar contraseña',
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Ingrese su contraseña';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 24),

                  // Botón Ingresar
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF10BEAE),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: _loading ? null : _iniciarSesion,
                      child: _loading
                          ? CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            )
                          : Text(
                              "Login",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ),

                  SizedBox(height: 24),

                  // Ingresar con Google y Microsoft
                  Text(
                    "O ingresa con",
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                  SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _botonSocial(
                        asset: 'assets/icons/google.png',
                        label: 'Google',
                        onPressed: () {
                          // TODO: login con Google
                        },
                      ),
                      _botonSocial(
                        asset: 'assets/icons/microsoft.png',
                        label: 'Microsoft',
                        onPressed: () {
                          // TODO: login con Microsoft
                        },
                      ),
                    ],
                  ),

                  SizedBox(height: 32),

                  // Enlaces secundarios
                  TextButton(
                    onPressed: () {
                      // TODO: recuperar contraseña
                    },
                    child: Text(
                      "¿Olvidaste tu contraseña?",
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                        color: Colors.teal[700],
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const RegisterView()),
                      );
                    },
                    child: Text(
                      "¿No tienes cuenta? Regístrate",
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                        color: Colors.teal[700],
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

  Widget _botonSocial({
    required String asset,
    required String label,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Image.asset(asset, height: 20),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        side: BorderSide(color: Colors.grey.shade300),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        minimumSize: Size(140, 45),
      ),
    );
  }
}
