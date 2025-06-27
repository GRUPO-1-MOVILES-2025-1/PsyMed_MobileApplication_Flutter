import 'package:flutter/material.dart';
import 'package:proyecto_moviles/views/mood_list_view.dart';
import 'package:proyecto_moviles/shared/sidebar_widget.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProfileView extends StatefulWidget {
  final String userName;
  final String userId;
  final String token;

  const ProfileView({
    super.key,
    required this.userName,
    required this.userId,
    required this.token,
  });

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  Map<String, dynamic>? profileData;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _fetchProfile();
  }

  Future<void> _fetchProfile() async {
    try {
      final response = await http.get(
        Uri.parse('http://localhost:5236/api/v1/Profiles/byUserId/${widget.userId}'),
        headers: {
          'Authorization': 'Bearer ${widget.token}',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          profileData = jsonDecode(response.body);
          loading = false;
        });
      } else {
        print('Error al obtener profile: ${response.statusCode}');
        setState(() => loading = false);
      }
    } catch (e) {
      print('Excepción al obtener profile: $e');
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      drawer: SidebarWidget(
        userName: widget.userName,
        userId: widget.userId,
        token: widget.token,
      ),
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(),

            const SizedBox(height: 20),

            Expanded(
              child: loading
                  ? const Center(child: CircularProgressIndicator())
                  : profileData == null
                  ? const Center(child: Text('No se pudo cargar el perfil.'))
                  : SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const CircleAvatar(
                      radius: 60,
                      backgroundImage: NetworkImage('https://picsum.photos/150/150'),
                    ),
                    const SizedBox(height: 16),

                    Text(
                      widget.userName,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 24),

                    _buildProfileField(label: 'Nombre', value: profileData!['firstName'] ?? ''),
                    _buildProfileField(label: 'Apellido', value: profileData!['lastName'] ?? ''),
                    _buildProfileField(label: 'Email', value: profileData!['email'] ?? ''),
                    _buildProfileField(label: 'Teléfono', value: profileData!['phone'] ?? ''),
                    _buildProfileField(
                      label: 'Fecha de nacimiento',
                      value: _formatearFecha(profileData!['birthDate']),
                    ),

                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MoodListView(
                userName: widget.userName,
                userId: widget.userId,
                token: widget.token,
              ),
            ),
          );
        },
        backgroundColor: Colors.green,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: const Color(0xFF10BEAE),
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
          const Expanded(
            child: Center(
              child: Text(
                'Perfil',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
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
                    userName: widget.userName,
                    userId: widget.userId,
                    token: widget.token,
                  ),
                ),
              );
            },
            tooltip: 'Perfil',
          ),
        ],
      ),
    );
  }

  Widget _buildProfileField({required String label, required String value}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        const SizedBox(height: 6),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            value,
            style: const TextStyle(fontSize: 16, color: Colors.black87),
          ),
        ),
      ],
    );
  }

  String _formatearFecha(String fechaIso) {
    try {
      final fecha = DateTime.parse(fechaIso);
      return "${fecha.day.toString().padLeft(2, '0')}/${fecha.month.toString().padLeft(2, '0')}/${fecha.year}";
    } catch (e) {
      return "Fecha inválida";
    }
  }
}
