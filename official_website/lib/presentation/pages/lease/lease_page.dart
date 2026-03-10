import 'package:flutter/material.dart';

/// 租赁页面
class LeasePage extends StatelessWidget {
  const LeasePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('租赁'),
        backgroundColor: const Color(0xFFD93025),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.calendar_month,
              size: 80,
              color: Color(0xFFD93025),
            ),
            SizedBox(height: 24),
            Text(
              '租赁页面',
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
