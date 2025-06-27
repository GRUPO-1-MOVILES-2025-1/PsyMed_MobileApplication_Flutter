import 'package:flutter/material.dart';
import 'package:proyecto_moviles/views/home_view.dart';
import 'package:proyecto_moviles/views/login_view.dart';
import 'package:proyecto_moviles/views/settings_view.dart';
import 'package:proyecto_moviles/views/iam/login_view.dart';

class SidebarWidget extends StatelessWidget {
  final String userName;
  final String userId;
  final String token;

  SidebarWidget({
    super.key,
    required this.userName,
    required this.userId,
    required this.token,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            
            decoration: BoxDecoration(color: Color(0xFF10BEAE)),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.account_circle, size: 64, color: Colors.white),
                  SizedBox(height: 8),
                  Text(
                    'Hola, $userName',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Menú Principal',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Inicio'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => HomeView(
                    userName: userName,
                    userId: userId,
                    token: token,
                  ),
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Configuración'),
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
          ListTile(
            leading: Icon(Icons.help),
            title: Text('Ayuda'),
            onTap: () {
              // TODO: Navegar a ayuda
            },
          ),
          const Spacer(),
          ListTile(
            leading: Icon(Icons.logout, color: Colors.red),
            title: Text('Cerrar Sesión', style: TextStyle(color: Colors.red)),
            onTap: () {
              // TODO: Lógica de logout, por ejemplo:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginView()),
              );
            },
          ),
        ],
      ),
    );
  }
}
