import 'package:flutter/material.dart';
import 'package:proyecto_moviles/views/patients_list_view.dart';
import 'package:proyecto_moviles/views/profile_view.dart';
import 'package:proyecto_moviles/views/settings_view.dart';

import 'package:proyecto_moviles/shared/sidebar_widget.dart';

class HomeView extends StatelessWidget {
  final String userName;
  final String userId;
  final String token;

  HomeView({
    super.key,
    required this.userName,
    required this.userId,
    required this.token,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      drawer: SidebarWidget(
        userName: userName,
        userId: userId,
        token: token,
      ),
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
                  Builder(
                    builder: (context) => IconButton(
                      icon: const Icon(Icons.menu, color: Colors.white),
                      onPressed: () {
                        Scaffold.of(context).openDrawer();
                      },
                      tooltip: 'Menú',
                    ),
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProfileView(
                            userName: userName,
                            userId: userId,
                            token: token,
                          ),
                        ),
                      );
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
                decoration: const BoxDecoration(
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
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PatientsListView(
                              userName: userName,
                              userId: userId,
                              token: token,
                            ),
                          ),
                        );
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
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProfileView(
                              userName: userName,
                              userId: userId,
                              token: token,
                            ),
                          ),
                        );
                      },
                    ),
                    _buildMenuButton(
                      context,
                      icon: Icons.settings,
                      label: 'Ajustes ⚙️',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SettingsView(
                              userName: userName,
                              userId: userId,
                              token: token,
                            ),
                          ),
                        );
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
                  color: Colors.black,
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
