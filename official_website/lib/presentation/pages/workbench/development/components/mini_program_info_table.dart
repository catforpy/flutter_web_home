import 'package:flutter/material.dart';
import 'copy_button.dart';
import 'green_button.dart';
import 'add_category_modal.dart';
import 'edit_category_modal.dart';
import 'delete_category_dialog.dart';
import 'category_select_dialog.dart';

/// 小程序信息表格组件
class MiniProgramInfoTable extends StatelessWidget {
  const MiniProgramInfoTable({super.key});

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
          Text(
            '小程序信息',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF333333),
            ),
          ),
          SizedBox(height: 24),
          _MiniProgramTable(),
        ],
      ),
    );
  }
}

class _MiniProgramTable extends StatelessWidget {
  const _MiniProgramTable();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildTableRow(context, 'APPID', 'wx1234567890abcdef', hasCopy: true),
        _buildTableRow(context, '原始ID', 'gh_xxxxxxxxxxxx', hasCopy: true),
        _buildTableRow(context, '头像', '_buildAvatar'),
        _buildTableRow(context, '主体', '企业'),
        _buildTableRow(context, '介绍', '唐极课得是一款专业的在线教育小程序'),
        _buildTableRow(context, '服务类目', '_buildServiceCategories'),
        _buildLocationInterfaceRow(context),
        _buildTableRow(context, '小程序码', '_buildQrCode'),
        _buildTableRow(
          context,
          '体验版二维码',
          '_buildExperienceQrCode',
        ),
        _buildTableRow(context, '审核状态', '_buildAuditStatus'),
      ],
    );
  }

  Widget _buildTableRow(BuildContext context, String label, String content, {bool hasCopy = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Color(0xFFF0F0F0), width: 1),
        ),
      ),
      child: Row(
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
            child: _buildContent(context, content, hasCopy: hasCopy),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context, String content, {bool hasCopy = false}) {
    switch (content) {
      case '_buildAvatar':
        return _buildAvatar();
      case '_buildServiceCategories':
        return _buildServiceCategories(context);
      case '_buildQrCode':
        return _buildQrCode();
      case '_buildExperienceQrCode':
        return _buildExperienceQrCode();
      case '_buildAuditStatus':
        return _buildAuditStatus();
      default:
        return Row(
          children: [
            Expanded(
              child: Text(
                content,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF333333),
                ),
              ),
            ),
            if (hasCopy) const CopyButton(),
          ],
        );
    }
  }

  Widget _buildAvatar() {
    return Row(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: const Color(0xFF1A9B8E),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(
            Icons.image,
            size: 30,
            color: Colors.white,
          ),
        ),
        const Spacer(),
        const GreenButton(text: '更换头像'),
      ],
    );
  }

  Widget _buildServiceCategories(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                children: [
                  Container(
                    padding: const EdgeInsets.only(left: 12, top: 12, bottom: 12, right: 100),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F5F5),
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: const Color(0xFFE0E0E0), width: 1),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildCategoryItem('工具类 > 信息查询', true),
                        _buildCategoryItem('生活服务 > 家政服务', true),
                        _buildCategoryItem('生活服务 > 丽人服务 > 美甲', true),
                        _buildCategoryItem('生活服务 > 丽人服务 > 美容', true),
                        _buildCategoryItem('生活服务 > 丽人服务 > 美睫', true),
                        _buildCategoryItem('生活服务 > 丽人服务 > 美发', true),
                        _buildCategoryItem('生活服务 > 丽人服务 > 纹身', true),
                        _buildCategoryItem('生活服务 > 丽人服务 > 祛痘', true),
                        _buildCategoryItem('生活服务 > 丽人服务 > 纤体瘦身', true),
                        _buildCategoryItem('生活服务 > 丽人服务 > spa', true),
                        _buildCategoryItem('生活服务 > 丽人服务 > 舞蹈', true),
                        _buildCategoryItem('生活服务 > 丽人服务 > 瑜伽', true),
                        _buildCategoryItem('生活服务 > 丽人服务 > 其他', true),
                      ],
                    ),
                  ),
                  // 文本框内部的右侧按钮
                  Positioned(
                    right: 12,
                    top: 0,
                    bottom: 0,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildInlineButton(context, '增加类目'),
                        const SizedBox(height: 6),
                        _buildInlineButton(context, '修改类目'),
                        const SizedBox(height: 6),
                        _buildInlineButton(context, '删除类目'),
                        const SizedBox(height: 6),
                        _buildInlineButton(context, '同步类目'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        const Padding(
          padding: EdgeInsets.only(left: 0),
          child: Text(
            '提示：服务类目最多添加5个，本月可添加5次，每次提交修改之后修改次数就减少1次',
            style: TextStyle(
              fontSize: 12,
              color: Color(0xFFFF4D4F),
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInlineButton(BuildContext context, String text) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          if (text == '增加类目') {
            _showAddCategoryDialog(context);
          } else if (text == '修改类目') {
            _showEditCategoryDialog(context);
          } else if (text == '删除类目') {
            _showDeleteCategoryDialog(context);
          } else if (text == '同步类目') {
            debugPrint('同步类目');
          }
          debugPrint('点击：$text');
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFF52C41A),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  void _showAddCategoryDialog(BuildContext context) {
    showAddCategoryModal(context);
  }

  void _showEditCategoryDialog(BuildContext context) {
    showCategorySelectDialog(
      context,
      '选择要修改的类目',
      '下一步',
      (categoryName) {
        showEditCategoryModal(context, categoryName);
      },
    );
  }

  void _showDeleteCategoryDialog(BuildContext context) {
    showCategorySelectDialog(
      context,
      '选择要删除的类目',
      '删除',
      (categoryName) {
        showDeleteCategoryDialog(context, categoryName);
      },
    );
  }

  Widget _buildCategoryItem(String category, bool isApproved) {
    return Row(
      children: [
        Text(
          category,
          style: const TextStyle(
            fontSize: 13,
            color: Color(0xFF333333),
            height: 1.8,
          ),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: isApproved ? const Color(0xFFF0F9FF) : const Color(0xFFFFF7E6),
            borderRadius: BorderRadius.circular(4),
            border: Border.all(
              color: isApproved ? const Color(0xFF52C41A) : const Color(0xFFFFA940),
              width: 1,
            ),
          ),
          child: Text(
            isApproved ? '已审核' : '审核中',
            style: TextStyle(
              fontSize: 11,
              color: isApproved ? const Color(0xFF52C41A) : const Color(0xFFFFA940),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildQrCode() {
    return Row(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: const Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(4),
          ),
          child: const Icon(
            Icons.qr_code_2,
            size: 60,
            color: Color(0xFF999999),
          ),
        ),
        const SizedBox(width: 16),
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GreenButton(text: '下载小程序码'),
            SizedBox(height: 8),
            GreenButton(text: '设置小程序码'),
          ],
        ),
      ],
    );
  }

  Widget _buildExperienceQrCode() {
    return Row(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: const Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(4),
          ),
          child: const Icon(
            Icons.qr_code_2,
            size: 60,
            color: Color(0xFF999999),
          ),
        ),
        const SizedBox(width: 16),
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GreenButton(text: '下载体验版二维码'),
            SizedBox(height: 8),
            GreenButton(text: '预览'),
          ],
        ),
      ],
    );
  }

  Widget _buildAuditStatus() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF7E6),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: const Color(0xFFFFA940), width: 1),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.access_time,
            size: 16,
            color: Color(0xFFFFA940),
          ),
          SizedBox(width: 8),
          Text(
            '审核中（预计1-3个工作日）',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFFFFA940),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationInterfaceRow(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            width: 150,
            child: Text(
              '获取地理位置接口',
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF666666),
              ),
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: const Color(0xFFE0E0E0), width: 1),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'wx.getLocation     申请成功\n'
                    'wx.chooseLocation     申请成功\n'
                    'wx.chooseAddress     申请成功',
                    style: TextStyle(
                      fontSize: 13,
                      color: Color(0xFF333333),
                      height: 1.8,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 16),
          const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '申请成功',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF52C41A),
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 8),
              GreenButton(text: '重新申请'),
            ],
          ),
        ],
      ),
    );
  }
}
