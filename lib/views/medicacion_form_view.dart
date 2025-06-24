import 'package:flutter/material.dart';

class MedicacionFormView extends StatelessWidget {
  const MedicacionFormView({super.key});

  @override
  Widget build(BuildContext context) {
    final inputDecoration = InputDecoration(
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      hintStyle: const TextStyle(color: Color(0xFF9E7F54)), // Marrón claro
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF7BB1A2), // Verde PSYMED
        title: const Text(
          'PSYMED',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: const Icon(Icons.all_inclusive),
        actions: const [Icon(Icons.settings)],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.only(bottom: 24),
              decoration: BoxDecoration(
                color: const Color(0xFF4FA89C), // Verde esmeralda más intenso
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'Medication Name: Alprazolam\n'
                    'Dosage/Frequency: 0.2x5 mg, Twice daily\n'
                    'Quantity: 60 tablets\n'
                    'Start Date: September 2, 2024\n'
                    'End Date: October 2, 2024',
                style: TextStyle(color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ),

            const Align(
              alignment: Alignment.centerLeft,
              child: Text('Medication Name'),
            ),
            const SizedBox(height: 6),
            TextFormField(
              decoration: inputDecoration.copyWith(hintText: 'Enter medication name'),
            ),
            const SizedBox(height: 16),

            const Align(
              alignment: Alignment.centerLeft,
              child: Text('Dosage/Frequency'),
            ),
            const SizedBox(height: 6),
            TextFormField(
              decoration: inputDecoration.copyWith(hintText: 'Enter dosage and frequency'),
            ),
            const SizedBox(height: 16),

            const Align(
              alignment: Alignment.centerLeft,
              child: Text('Quantity'),
            ),
            const SizedBox(height: 6),
            TextFormField(
              decoration: inputDecoration.copyWith(hintText: 'Enter quantity'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),

            const Align(
              alignment: Alignment.centerLeft,
              child: Text('Start Date'),
            ),
            const SizedBox(height: 6),
            TextFormField(
              decoration: inputDecoration.copyWith(hintText: 'Enter start date'),
            ),
            const SizedBox(height: 16),

            const Align(
              alignment: Alignment.centerLeft,
              child: Text('End Date'),
            ),
            const SizedBox(height: 6),
            TextFormField(
              decoration: inputDecoration.copyWith(hintText: 'Enter end date'),
            ),
            const SizedBox(height: 32),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4B9C63), // Verde botón
                  foregroundColor: Colors.white, // ✅ texto blanco
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  'Save',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
