import 'package:flutter/material.dart';

/// 定制开发页面
class CustomDevPage extends StatelessWidget {
  const CustomDevPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('定制开发'),
        backgroundColor: const Color(0xFFD93025),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.developer_mode,
              size: 80,
              color: Color(0xFFD93025),
            ),
            SizedBox(height: 24),
            Text(
              '定制开发页面',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Text(
              '页面开发中...',
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFF999999),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
