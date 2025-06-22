import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl_phone_field/intl_phone_field.dart';


class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _apellidoController = TextEditingController();
  final _emailController = TextEditingController();
  final _telefonoController = TextEditingController();
  final _ubicacionController = TextEditingController();
  DateTime? _fechaNacimiento;
  String? _genero;

  bool _loading = false;

  @override
  void dispose() {
    _nombreController.dispose();
    _apellidoController.dispose();
    _emailController.dispose();
    _telefonoController.dispose();
    _ubicacionController.dispose();
    super.dispose();
  }

  void _seleccionarFechaNacimiento() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _fechaNacimiento = picked;
      });
    }
  }

  void _crearCuenta() {
    if (_formKey.currentState!.validate()) {
      setState(() => _loading = true);

      // Simular envío
      Future.delayed(Duration(seconds: 2), () {
        setState(() => _loading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Cuenta registrada con éxito")),
        );
      });
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
                // Header decorativo
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
                      // Nombre y Apellido
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
                              textCapitalization: TextCapitalization.words,
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
                              textCapitalization: TextCapitalization.words,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),

                      // Fecha de nacimiento
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

                      // Correo
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: "Correo electrónico",
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) return "Campo obligatorio";
                          if (!RegExp(r"^[\w\.-]+@[\w\.-]+\.\w+$")
                              .hasMatch(value)) {
                            return "Correo inválido";
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16),

                      // Género
                      DropdownButtonFormField<String>(
                        value: _genero,
                        items: ["Masculino", "Femenino", "Otro"]
                            .map((gen) => DropdownMenuItem(
                                  child: Text(gen),
                                  value: gen,
                                ))
                            .toList(),
                        onChanged: (val) => setState(() => _genero = val),
                        decoration: InputDecoration(
                          labelText: "Género",
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) =>
                            value == null ? "Selecciona un género" : null,
                      ),
                      SizedBox(height: 16),

                      // Teléfono
                      IntlPhoneField(
                        decoration: InputDecoration(
                          labelText: 'Teléfono',
                          border: OutlineInputBorder(
                            borderSide: BorderSide(),
                          ),
                        ),
                        initialCountryCode: 'PE', // Perú
                        onChanged: (phone) {
                          print('Número completo: ${phone.completeNumber}');
                          // Puedes guardarlo en una variable si lo necesitas
                        },
                        onSaved: (phone) {
                          // Guardar el número completo si usas un form
                        },
                        validator: (value) {
                          if (value == null || value.number.length < 6) {
                            return 'Número muy corto';
                          }
                          return null;
                        },
                      ),

                      SizedBox(height: 16),

                      // Ubicación
                      TextFormField(
                        controller: _ubicacionController,
                        decoration: InputDecoration(
                          labelText: "Ubicación",
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) =>
                            value!.isEmpty ? "Campo obligatorio" : null,
                      ),
                      SizedBox(height: 24),

                      // Botón crear cuenta
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
                              ? CircularProgressIndicator(
                                  color: Colors.white, strokeWidth: 2)
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

                      // Enlace de retorno
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context); // o ir a LoginView
                        },
                        child: Text(
                          "¿Ya tienes una cuenta? Inicia sesión",
                          style: TextStyle(
                            color: Colors.teal[700],
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                      SizedBox(height: 24),
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
