import 'package:flutter/material.dart';

class HomeView extends StatelessWidget {
  final String userName;

  const HomeView({super.key, this.userName = 'Usuario/a'});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Column(
          children: [
            // AppBar personalizada
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              color: const Color(0xFF10BEAE), // Verde azulado
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.menu, color: Colors.white),
                    onPressed: () {
                      // TODO: abrir menú lateral
                    },
                    tooltip: 'Menú',
                  ),
                  Expanded(
                    child: Center(
                      child: Text.rich(
                        TextSpan(
                          text: 'Bienvenido/a, ',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                          children: [
                            TextSpan(
                              text: userName,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.account_circle, color: Colors.white),
                    onPressed: () {
                      // TODO: ir a perfil
                    },
                    tooltip: 'Perfil',
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Logo central
            Center(
              child: Container(
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
            ),

            const SizedBox(height: 32),

            // Botonera funcional
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildMenuButton(
                      context,
                      icon: Icons.people,
                      label: 'Pacientes 🧑‍⚕️',
                      onTap: () {
                        // TODO: Navegar a vista Pacientes
                      },
                    ),
                    _buildMenuButton(
                      context,
                      icon: Icons.calendar_today,
                      label: 'Agenda 📅',
                      onTap: () {
                        // TODO: Navegar a vista Agenda
                      },
                    ),
                    _buildMenuButton(
                      context,
                      icon: Icons.person,
                      label: 'Perfil 👤',
                      onTap: () {
                        // TODO: Navegar a vista Perfil
                      },
                    ),
                    _buildMenuButton(
                      context,
                      icon: Icons.settings,
                      label: 'Ajustes ⚙️',
                      onTap: () {
                        // TODO: Navegar a vista Ajustes
                      },
                    ),
                  ],
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }

  Widget _buildMenuButton(
  BuildContext context, {
  required IconData icon,
  required String label,
  required VoidCallback onTap,
}) {
  final match = RegExp(r'(.+?)( [\u{1F300}-\u{1FAFF}\u{1F600}-\u{1F64F}\u{1F680}-\u{1F6FF}\u{2600}-\u{26FF}])?$',
          unicode: true)
      .firstMatch(label);

  final text = match?.group(1) ?? label;
  final emoji = match?.group(2) ?? '';

  return SizedBox(
    width: double.infinity,
    height: 60,
    child: ElevatedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 24, color: Colors.white),
      label: Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: text,
              style: const TextStyle(
                fontFamily: 'PlusJakartaSans',
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            TextSpan(
              text: emoji,
              style: const TextStyle(
                fontSize: 18,
                fontFamily: 'PlusJakartaSans',
                color: Colors.black, // mantiene color original del emoji
              ),
            ),
          ],
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF10BEAE),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),
  );
}

}
