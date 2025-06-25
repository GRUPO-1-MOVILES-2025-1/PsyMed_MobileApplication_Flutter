import 'package:flutter/material.dart';

class CalendarView extends StatelessWidget {
  final String userName;

  CalendarView({super.key, required this.userName});
  

  @override
  Widget build(BuildContext context) {
    final appointments = [
      {
        'name': 'Pedro Pablo Gutierrez Armador',
        'date': '09/12/24',
        'time': '10:00am–11:30am',
      },
      {
        'name': 'Joaquin Alberto del Campo',
        'date': '09/13/24',
        'time': '13:00am–14:30am',
      },
      {
        'name': 'Agustin Guillermo Ruiz Diaz',
        'date': '09/15/24',
        'time': '09:30am–10:30am',
      },
      {
        'name': 'Elliot Guevara Vizcarra',
        'date': '09/15/24',
        'time': '12:00pm–14:30am',
      },
      {
        'name': 'Mariano Guillen Armador',
        'date': '10/10/24',
        'time': '15:00am–16:30am',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF7BB1A2),
        title: const Text(
          'PSYMED',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: const Icon(Icons.menu),
        actions: const [Icon(Icons.settings)],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Calendario de Citas',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: const Color(0xFFF3EEE8),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const TextField(
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Buscar',
                  icon: Icon(Icons.search),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: appointments.length,
                itemBuilder: (context, index) {
                  final item = appointments[index];
                  return Card(
                    elevation: 0,
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    color: const Color(0xFFF8F4F7),
                    child: ListTile(
                      leading: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFF3EEE8),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.all(8),
                        child: const Icon(Icons.calendar_month_rounded),
                      ),
                      title: Text(item['name'] ?? ''),
                      subtitle: Text('${item['date']}   ${item['time']}'),
                      trailing: const Icon(Icons.star_border),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            Wrap(
              alignment: WrapAlignment.spaceBetween,
              spacing: 12,
              runSpacing: 12,
              children: [
                _buildBottomButton('Send recordatory'),
                _buildBottomButton('Modify schedule'),
                _buildBottomButton('New Consultation'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomButton(String text) {
    return SizedBox(
      width: 160,
      height: 45,
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF4B9C63),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
        ),
        child: Text(text),
      ),
    );
  }
}
