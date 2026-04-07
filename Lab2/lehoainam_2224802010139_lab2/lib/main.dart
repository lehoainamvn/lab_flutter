import 'package:flutter/material.dart';

// Import các phần của bạn
import 'part_1.dart';
import 'part_2.dart';
import 'part_3.dart';
import 'part_4.dart';

void main() {
  runApp(const MyLabApp());
}

class MyLabApp extends StatelessWidget {
  const MyLabApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Lab 2 - Full App',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
      ),
      routes: {
        '/second': (context) => const SecondScreen(),
      },
      home: const MainDashboard(),
    );
  }
}

class MainDashboard extends StatefulWidget {
  const MainDashboard({super.key});

  @override
  State<MainDashboard> createState() => _MainDashboardState();
}

class _MainDashboardState extends State<MainDashboard> {
  int _selectedIndex = 0;

  final List<Widget> _screens = const [
    LayoutApp(),
    ResponsiveHomePage(),
    HomeScreen(),
    RegistrationPage(),
  ];

  final List<String> _titles = [
    "Part 1",
    "Part 2",
    "Part 3",
    "Part 4"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 🔝 AppBar đơn giản
      appBar: AppBar(
        title: Text(_titles[_selectedIndex]),
        centerTitle: true,
      ),

      // 📱 Nội dung
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),

      // 🔻 NavigationBar đơn giản
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(label: 'Part 1', icon: Icon(Icons.circle)),
          NavigationDestination(label: 'Part 2', icon: Icon(Icons.circle)),
          NavigationDestination(label: 'Part 3', icon: Icon(Icons.circle)),
          NavigationDestination(label: 'Part 4', icon: Icon(Icons.circle)),
        ],
      ),
    );
  }
}