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
      home: ResponsiveHomePage(),
    );
  }
}

class ResponsiveHomePage extends StatelessWidget {
  const ResponsiveHomePage({super.key});

  // 1. Khai báo hằng số màu sắc rõ ràng thay vì dùng Record/Map để truy xuất nhanh hơn
  static const Color _bodyColor = Color(0xFFF8E287);
  static const Color _navColor = Color(0xFFC5ECCE);
  static const Color _paneColor = Color(0xFFEEE2BC);

  // 2. Khai báo style và widget tĩnh dạng const để tránh rebuild
  static const TextStyle _textStyle = TextStyle(
    fontSize: 20, 
    fontWeight: FontWeight.bold,
  );

  static const Widget _bodyContent = Center(child: Text('Body', style: _textStyle));
  static const Widget _navContent = Center(child: Text('Navigation', style: _textStyle));
  static const Widget _paneContent = Center(child: Text('Pane', style: _textStyle));

  @override
  Widget build(BuildContext context) {
    // Dùng MediaQuery.sizeOf(context) thay vì MediaQuery.of(context).size
    // giúp Widget chỉ rebuild khi kích thước màn hình đổi, tối ưu hiệu suất.
    final double screenWidth = MediaQuery.sizeOf(context).width;

    return Scaffold(
      appBar: AppBar(
        title: Text(_getAppBarTitle(screenWidth)),
      ),
      body: SafeArea(
        child: _buildResponsiveLayout(screenWidth),
      ),
    );
  }

  // 3. Tách logic lấy Title ra một hàm riêng biệt, thay thế cho IIFE
  String _getAppBarTitle(double width) {
    if (width < 600) return 'Responsive UI - Phone';
    if (width < 840) return 'Responsive UI - Tablet';
    if (width < 1200) return 'Responsive UI - Landscape';
    return 'Responsive UI - Large Desktop';
  }

  // 4. Tách logic chọn Layout ra hàm riêng
  Widget _buildResponsiveLayout(double width) {
    if (width < 600) return _buildCompactScreen();
    if (width < 840) return _buildMediumScreen();
    if (width < 1200) return _buildExpandedScreen();
    return _buildLargeScreen();
  }

  // Các hàm build giao diện tương ứng với từng kích thước
  Widget _buildCompactScreen() {
    return Column(
      children: [
        const Expanded(
          child: ColoredBox(color: _bodyColor, child: _bodyContent),
        ),
        Container(height: 80, color: _navColor, child: _navContent),
      ],
    );
  }

  Widget _buildMediumScreen() {
    return Row(
      children: [
        Container(width: 80, color: _navColor, child: _navContent),
        const Expanded(
          child: ColoredBox(color: _bodyColor, child: _bodyContent),
        ),
      ],
    );
  }

  Widget _buildExpandedScreen() {
    return Row(
      children: [
        Container(width: 80, color: _navColor, child: _navContent),
        Container(width: 360, color: _bodyColor, child: _bodyContent),
        const Expanded(
          child: ColoredBox(color: _paneColor, child: _paneContent),
        ),
      ],
    );
  }

  Widget _buildLargeScreen() {
    return Row(
      children: [
        Container(width: 360, color: _navColor, child: _navContent),
        Container(width: 360, color: _bodyColor, child: _bodyContent),
        const Expanded(
          child: ColoredBox(color: _paneColor, child: _paneContent),
        ),
      ],
    );
  }
}