import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SafeArea( // Thêm SafeArea để tránh tai thỏ/nốt ruồi trên mobile
          child: LayoutApp(),
        ),
      ),
    );
  }
}

class LayoutApp extends StatelessWidget {
  const LayoutApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Task 3: Add Padding around widgets
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center, // Centered vertically
        children: [
          const Text(
            'I\'m in a Column and Centered. The below is a row.',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          
          // Task 1: Change Row alignment to MainAxisAlignment.center
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Task 4: Replace loop with manual Containers
              _buildColorBox(Colors.red),
              const SizedBox(width: 8), // Thêm khoảng cách nhỏ vì Row đang ở trạng thái center
              _buildColorBox(Colors.green),
              const SizedBox(width: 8),
              _buildColorBox(Colors.blue),
            ],
          ),
          const SizedBox(height: 20),
          
          // Task 2: Change Stack alignment to Alignment.topLeft
          Stack(
            alignment: Alignment.topLeft,
            children: [
              Container(
                width: 300,
                height: 200,
                color: Colors.yellow,
              ),
              const Padding(
                // Thêm padding nhẹ để Text không dính sát viền của Stack topLeft
                padding: EdgeInsets.all(12.0),
                child: Text(
                  'Stacked on Yellow Box',
                  style: TextStyle(
                    fontSize: 24, 
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Helper method để tạo các ô màu, giúp tránh việc lặp lại code 
  /// (Don't Repeat Yourself - DRY) khi khai báo manual Containers.
  Widget _buildColorBox(Color color) {
    return Container(
      width: 100,
      height: 100,
      color: color,
    );
  }
}