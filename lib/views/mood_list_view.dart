import 'package:flutter/material.dart';
import 'package:proyecto_moviles/shared/sidebar_widget.dart';

class MoodListView extends StatefulWidget {
  final String userName;
  final String userId;
  final String token;

  const MoodListView({
    super.key,
    required this.userName,
    required this.userId,
    required this.token,
  });

  @override
  State<MoodListView> createState() => _MoodListViewState();
}

class _MoodListViewState extends State<MoodListView> {
  final List<Map<String, String>> _allMoods = [
    {
      'mood': 'So Happy',
      'description': 'Phone: +123456789\nEmail: happy@example.com',
      'emoji': '😄',
    },
    {
      'mood': 'Happy',
      'description': 'Phone: +987654321\nEmail: happy2@example.com',
      'emoji': '😊',
    },
    {
      'mood': 'Sad',
      'description': 'Phone: +555444333\nEmail: sad@example.com',
      'emoji': '😢',
    },
    {
      'mood': 'So Sad',
      'description': 'Phone: +000111222\nEmail: sosad@example.com',
      'emoji': '😭',
    },
  ];

  List<Map<String, String>> _filteredMoods = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _filteredMoods = List.from(_allMoods);
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();

    setState(() {
      _filteredMoods = _allMoods.where((item) {
        final mood = item['mood']!.toLowerCase();
        final description = item['description']!.toLowerCase();
        return mood.contains(query) || description.contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
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
            Container(
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
                  Expanded(
                    child: Center(
                      child: Text(
                        'Estados de Ánimo',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.account_circle, color: Colors.white),
                    onPressed: () {},
                    tooltip: 'Perfil',
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Buscar',
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: const Color(0xFFF5F5DC),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),

            Expanded(
              child: ListView.builder(
                itemCount: _filteredMoods.length,
                itemBuilder: (context, index) {
                  final item = _filteredMoods[index];
                  return ListTile(
                    leading: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          item['emoji']!,
                          style: const TextStyle(fontSize: 28),
                        ),
                      ),
                    ),
                    title: Text(
                      item['mood']!,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(item['description']!),
                    contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
