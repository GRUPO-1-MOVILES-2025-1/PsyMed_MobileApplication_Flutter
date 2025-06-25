import 'package:flutter/material.dart';
import 'patient_detail_view.dart';
import 'package:proyecto_moviles/shared/sidebar_widget.dart';

class PatientsListView extends StatelessWidget {
  final String userName;

  PatientsListView({super.key, required this.userName});
  

  @override
  Widget build(BuildContext context) {
    final patients = [
      {
        'name': 'Jhon Doe',
        'age': '32 años',
        'phone': '984 123 451',
        'email': 'correo@hotmail.com',
        'avatar': '👨‍💼',
      },
      {
        'name': 'Maria Becerra',
        'age': '32 años',
        'phone': '984 123 451',
        'email': 'correo@hotmail.com',
        'avatar': '👩‍💼',
      },
      {
        'name': 'Juan del Piero',
        'age': '32 años',
        'phone': '984 123 451',
        'email': 'correo@hotmail.com',
        'avatar': '👨‍🦱',
      },
      {
        'name': 'Jhon Doe',
        'age': '32 años',
        'phone': '984 123 451',
        'email': 'correo@hotmail.com',
        'avatar': '👨‍💼',
      },
      {
        'name': 'Maria Becerra',
        'age': '32 años',
        'phone': '984 123 451',
        'email': 'correo@hotmail.com',
        'avatar': '👩‍💼',
      },
      {
        'name': 'Juan del Piero',
        'age': '32 años',
        'phone': '984 123 451',
        'email': 'correo@hotmail.com',
        'avatar': '👨‍🦱',
      },
      {
        'name': 'Joshua Kimmich',
        'age': '32 años',
        'phone': '984 123 451',
        'email': 'correo@hotmail.com',
        'avatar': '👨‍🦲',
      },
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      drawer: SidebarWidget(userName: this.userName),
      appBar: AppBar(
        backgroundColor: const Color(0xFF10BEAE),
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () {
              Scaffold.of(context).openDrawer(); // ✅ Ahora sí funciona
            },
            tooltip: 'Menú',
          ),
        ),

        title: Text(
          'Welcome $userName',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: Stack(
        children: [
          // Contenido principal
          Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 64, 16, 16),
                  itemCount: patients.length,
                  itemBuilder: (context, index) {
                    final patient = patients[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(12),
                        leading: CircleAvatar(
                          radius: 25,
                          backgroundColor: Colors.grey[200],
                          child: Text(
                            patient['avatar']!,
                            style: const TextStyle(fontSize: 20),
                          ),
                        ),
                        title: Text(
                          patient['name']!,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 4),
                            Text(
                              patient['age']!,
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              '${patient['phone']} | ${patient['email']}',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.edit, color: Colors.grey),
                          onPressed: () {},
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PatientDetailView(
                                patientName: patient['name']!,
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF10BEAE),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        child: const Text(
                          'Add Patient',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF10BEAE),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        child: const Text(
                          'Watch Patients',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Botón de retroceso flotante
          Positioned(
            top: 12,
            left: 12,
            child: FloatingActionButton(
              mini: true,
              backgroundColor: Colors.white,
              elevation: 2,
              onPressed: () => Navigator.pop(context),
              child: const Icon(Icons.arrow_back, color: Colors.black),
              tooltip: 'Volver',
            ),
          ),
        ],
      ),

    );
  }
}
