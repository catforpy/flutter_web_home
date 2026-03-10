import 'package:flutter/material.dart';
import 'copy_button.dart';
import 'green_button.dart';

/// 服务器域名表格组件
class ServerDomainTable extends StatelessWidget {
  const ServerDomainTable({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 2,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                '服务器域名',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF333333),
                ),
              ),
              SizedBox(width: 8),
              GreenButton(text: '修改'),
            ],
          ),
          SizedBox(height: 24),
          _DomainTable(),
        ],
      ),
    );
  }
}

class _DomainTable extends StatelessWidget {
  const _DomainTable();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildDomainRow(
          'request合法域名',
          [
            'https://api.tangjikede.com',
            'https://cdn.tangjikede.com',
          ],
        ),
        _buildDomainRow(
          'socket合法域名',
          [
            'wss://socket.tangjikede.com',
          ],
        ),
        _buildDomainRow(
          'uploadFile合法域名',
          [
            'https://upload.tangjikede.com',
          ],
        ),
        _buildDomainRow(
          'downloadFile合法域名',
          [
            'https://cdn.tangjikede.com',
            'https://static.tangjikede.com',
          ],
        ),
        _buildDomainRow(
          '业务域名',
          [
            'https://www.tangjikede.com',
            'https://m.tangjikede.com',
          ],
        ),
      ],
    );
  }

  Widget _buildDomainRow(String label, List<String> domains) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Color(0xFFF0F0F0), width: 1),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 150,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF666666),
              ),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: domains.map((domain) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          domain,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF333333),
                          ),
                        ),
                      ),
                      const CopyButton(),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
