import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:proyecto_moviles/services/auth_service.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _apellidoController = TextEditingController();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _ubicacionController = TextEditingController();
  final _passwordController = TextEditingController();
  DateTime? _fechaNacimiento;
  String? _genero;
  String? _numeroCompleto;
  bool _loading = false;
  bool _verPassword = false;

  @override
  void dispose() {
    _nombreController.dispose();
    _apellidoController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _ubicacionController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _seleccionarFechaNacimiento() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() => _fechaNacimiento = picked);
    }
  }

  void _crearCuenta() async {
    if (_formKey.currentState!.validate() &&
        _fechaNacimiento != null &&
        _genero != null &&
        _numeroCompleto != null) {
      setState(() => _loading = true);

      final response = await AuthService.register(
        username: _usernameController.text.trim(),
        name: _nombreController.text.trim(),
        lastName: _apellidoController.text.trim(),
        birthDate: _fechaNacimiento!,
        email: _emailController.text.trim(),
        gender: _genero!,
        phone: _numeroCompleto!,
        ubication: _ubicacionController.text.trim(),
        password: _passwordController.text.trim(),
      );

      setState(() => _loading = false);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final success = data['success'];
        final error = data['error'];

        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Cuenta registrada con éxito")),
          );
          Navigator.pop(context);
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
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  height: size.height * 0.2,
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
                SizedBox(height: 24),
                Text(
                  "Crear Cuenta",
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal[800],
                  ),
                ),
                SizedBox(height: 24),

                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _nombreController,
                              decoration: InputDecoration(
                                labelText: "Nombre",
                                border: OutlineInputBorder(),
                              ),
                              validator: (value) =>
                                  value!.isEmpty ? "Campo obligatorio" : null,
                            ),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: TextFormField(
                              controller: _apellidoController,
                              decoration: InputDecoration(
                                labelText: "Apellido",
                                border: OutlineInputBorder(),
                              ),
                              validator: (value) =>
                                  value!.isEmpty ? "Campo obligatorio" : null,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        controller: _usernameController,
                        decoration: InputDecoration(
                          labelText: "Nombre de usuario",
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) =>
                            value!.isEmpty ? "Campo obligatorio" : null,
                      ),
                      SizedBox(height: 16),
                      InkWell(
                        onTap: _seleccionarFechaNacimiento,
                        child: InputDecorator(
                          decoration: InputDecoration(
                            labelText: "Fecha de nacimiento",
                            border: OutlineInputBorder(),
                          ),
                          child: Text(
                            _fechaNacimiento == null
                                ? "Selecciona una fecha"
                                : "${_fechaNacimiento!.day}/${_fechaNacimiento!.month}/${_fechaNacimiento!.year}",
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: "Correo electrónico",
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) return "Campo obligatorio";
                          if (!RegExp(r"^[\w\.-]+@[\w\.-]+\.\w+$").hasMatch(value)) {
                            return "Correo inválido";
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        value: _genero,
                        decoration: InputDecoration(
                          labelText: "Género",
                          border: OutlineInputBorder(),
                        ),
                        items: ["Masculino", "Femenino", "Otro"]
                            .map((gen) => DropdownMenuItem(
                                  child: Text(gen),
                                  value: gen,
                                ))
                            .toList(),
                        onChanged: (val) => setState(() => _genero = val),
                        validator: (value) =>
                            value == null ? "Selecciona un género" : null,
                      ),
                      SizedBox(height: 16),
                      IntlPhoneField(
                        decoration: InputDecoration(
                          labelText: 'Teléfono',
                          border: OutlineInputBorder(),
                        ),
                        initialCountryCode: 'PE',
                        onChanged: (phone) {
                          _numeroCompleto = phone.completeNumber;
                        },
                        validator: (value) {
                          if (value == null || value.number.length < 6) {
                            return 'Número muy corto';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        controller: _ubicacionController,
                        decoration: InputDecoration(
                          labelText: "Ubicación",
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) =>
                            value!.isEmpty ? "Campo obligatorio" : null,
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: !_verPassword,
                        decoration: InputDecoration(
                          labelText: "Contraseña",
                          border: OutlineInputBorder(),
                          suffixIcon: IconButton(
                            icon: Icon(_verPassword ? Icons.visibility : Icons.visibility_off),
                            onPressed: () => setState(() => _verPassword = !_verPassword),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Campo obligatorio";
                          } else if (value.length < 6) {
                            return "Mínimo 6 caracteres";
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: _loading ? null : _crearCuenta,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF10BEAE),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: _loading
                              ? CircularProgressIndicator(color: Colors.white)
                              : Text(
                                  "Crear cuenta",
                                  style: GoogleFonts.plusJakartaSans(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                        ),
                      ),
                      SizedBox(height: 16),
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(
                          "¿Ya tienes una cuenta? Inicia sesión",
                          style: TextStyle(
                            color: Colors.teal[700],
                            decoration: TextDecoration.underline,
                          ),
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
    );
  }
}
