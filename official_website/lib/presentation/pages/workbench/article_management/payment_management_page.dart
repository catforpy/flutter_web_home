import 'package:flutter/material.dart';
import 'payment_type_list_content.dart';
import 'paid_members_content.dart';
import 'article_payment_records_content.dart';
import 'member_purchase_records_content.dart';

/// 付费管理页面
/// 包含4个横向标签：付费会员类型、付费会员、文章付费记录、会员购买记录
class PaymentManagementPage extends StatefulWidget {
  const PaymentManagementPage({super.key});

  @override
  State<PaymentManagementPage> createState() => _PaymentManagementPageState();
}

class _PaymentManagementPageState extends State<PaymentManagementPage> {
  // 当前选中的标签
  int _selectedTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    // 直接返回 Column，让父组件提供高度约束
    return Column(
      children: [
        // 横向标签栏
        _buildTabBar(),

        // 标签内容区
        Expanded(
          child: Container(
            color: const Color(0xFFF5F6F7),
            child: _buildTabContent(),
          ),
        ),
      ],
    );
  }

  /// 构建横向标签栏
  Widget _buildTabBar() {
    return Container(
      color: Colors.white,
      child: Row(
        children: [
          _buildTabItem('付费会员类型', 0),
          _buildTabItem('付费会员', 1),
          _buildTabItem('文章付费记录', 2),
          _buildTabItem('会员购买记录', 3),
        ],
      ),
    );
  }

  /// 构建标签项
  Widget _buildTabItem(String label, int index) {
    final isSelected = _selectedTabIndex == index;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedTabIndex = index;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF1A9B8E) : Colors.transparent,
            border: Border(
              bottom: BorderSide(
                color: isSelected ? const Color(0xFF1A9B8E) : Colors.transparent,
                width: 3,
              ),
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: isSelected ? Colors.white : const Color(0xFF595959),
            ),
          ),
        ),
      ),
    );
  }

  /// 构建标签内容
  Widget _buildTabContent() {
    switch (_selectedTabIndex) {
      case 0:
        return const PaymentTypeListContent();
      case 1:
        return const PaidMembersContent();
      case 2:
        return const ArticlePaymentRecordsContent();
      case 3:
        return const MemberPurchaseRecordsContent();
      default:
        return const PaymentTypeListContent();
    }
  }
}
