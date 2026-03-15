import 'package:flutter/material.dart';

/// 订单设置页面
/// 配置订单相关规则
class OrderSettingsPage extends StatefulWidget {
  const OrderSettingsPage({super.key});

  @override
  State<OrderSettingsPage> createState() => _OrderSettingsPageState();
}

class _OrderSettingsPageState extends State<OrderSettingsPage> {
  // 订单超时自动关闭时间（分钟）
  int _autoCloseMinutes = 30;

  // 订单自动确认收货时间（天）
  int _autoConfirmDays = 15;

  // 订单完成后自动评价时间（天）
  int _autoReviewDays = 7;

  // 是否允许买家评价
  bool _allowReview = true;

  // 是否需要审核才能显示评价
  bool _needReviewAudit = true;

  // 是否允许未付款用户加入购物车
  bool _allowAddToCartBeforePay = true;

  // 是否显示库存
  bool _showStock = true;

  // 库存不足时是否可以下单
  bool _allowOutOfStockOrder = false;

  // 每单最少商品数量
  int _minItemsPerOrder = 1;

  // 每单最多商品数量
  int _maxItemsPerOrder = 99;

  // 退款审核规则
  bool _needRefundAudit = true;

  // 退款期限（天）
  int _refundDeadlineDays = 7;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF5F6F7),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 页面标题
            const Text(
              '订单设置',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF333333),
              ),
            ),

            const SizedBox(height: 24),

            // 订单超时设置
            _buildSettingsCard(
              '订单超时设置',
              '设置订单自动关闭和确认的时间',
              Icons.access_time,
              [
                _buildTimeInputRow(
                  '订单超时自动关闭',
                  '未付款订单超过此时间将自动关闭',
                  _autoCloseMinutes,
                  '分钟',
                  (value) => setState(() => _autoCloseMinutes = value),
                ),
                _buildDivider,
                _buildTimeInputRow(
                  '自动确认收货',
                  '发货后超过此时间未确认将自动确认',
                  _autoConfirmDays,
                  '天',
                  (value) => setState(() => _autoConfirmDays = value),
                ),
                _buildDivider,
                _buildTimeInputRow(
                  '自动评价时间',
                  '订单完成后超过此时间将自动评价',
                  _autoReviewDays,
                  '天',
                  (value) => setState(() => _autoReviewDays = value),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // 评价设置
            _buildSettingsCard(
              '评价设置',
              '配置商品评价相关规则',
              Icons.star,
              [
                _buildSwitchRow(
                  '开启评价功能',
                  '开启后买家可以对商品进行评价',
                  _allowReview,
                  (value) => setState(() => _allowReview = value),
                ),
                _buildDivider,
                _buildSwitchRow(
                  '评价需要审核',
                  '开启后买家评价需要审核通过才能显示',
                  _needReviewAudit,
                  (value) => setState(() => _needReviewAudit = value),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // 购物设置
            _buildSettingsCard(
              '购物设置',
              '配置购物相关规则',
              Icons.shopping_cart,
              [
                _buildSwitchRow(
                  '允许未付款用户加入购物车',
                  '开启后未付款用户也可以添加商品到购物车',
                  _allowAddToCartBeforePay,
                  (value) => setState(() => _allowAddToCartBeforePay = value),
                ),
                _buildDivider,
                _buildSwitchRow(
                  '显示库存数量',
                  '开启后前台商品列表会显示库存',
                  _showStock,
                  (value) => setState(() => _showStock = value),
                ),
                _buildDivider,
                _buildSwitchRow(
                  '库存不足允许下单',
                  '开启后库存为0时用户仍可以下单',
                  _allowOutOfStockOrder,
                  (value) => setState(() => _allowOutOfStockOrder = value),
                ),
                _buildDivider,
                _buildNumberInputRow(
                  '每单最少商品数',
                  '每个订单最少需要购买的商品数量',
                  _minItemsPerOrder,
                  (value) => setState(() => _minItemsPerOrder = value),
                ),
                _buildDivider,
                _buildNumberInputRow(
                  '每单最多商品数',
                  '每个订单最多可以购买的商品数量',
                  _maxItemsPerOrder,
                  (value) => setState(() => _maxItemsPerOrder = value),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // 退款设置
            _buildSettingsCard(
              '退款设置',
              '配置退款相关规则',
              Icons.assignment_return,
              [
                _buildSwitchRow(
                  '退款需要审核',
                  '开启后买家申请退款需要商家审核',
                  _needRefundAudit,
                  (value) => setState(() => _needRefundAudit = value),
                ),
                _buildDivider,
                _buildTimeInputRow(
                  '退款期限',
                  '订单完成后在此时间内可申请退款',
                  _refundDeadlineDays,
                  '天',
                  (value) => setState(() => _refundDeadlineDays = value),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // 保存按钮
            Center(
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: _saveSettings,
                  child: Container(
                    width: 200,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A9B8E),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      '保存设置',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 构建设置卡片
  Widget _buildSettingsCard(
    String title,
    String subtitle,
    IconData icon,
    List<Widget> children,
  ) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE0E0E0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 标题
          Row(
            children: [
              Icon(icon, size: 24, color: const Color(0xFF1A9B8E)),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF333333),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF999999),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // 分隔线
          Container(
            height: 1,
            color: const Color(0xFFE0E0E0),
          ),

          const SizedBox(height: 16),

          // 设置项
          ...children,
        ],
      ),
    );
  }

  /// 分隔线
  static const _buildDivider = Padding(
    padding: EdgeInsets.symmetric(vertical: 16),
    child: Divider(height: 1),
  );

  /// 构建开关行
  Widget _buildSwitchRow(
    String title,
    String subtitle,
    bool value,
    void Function(bool) onChanged,
  ) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF333333),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF999999),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        Switch(
          value: value,
          onChanged: onChanged,
          activeColor: const Color(0xFF1A9B8E),
        ),
      ],
    );
  }

  /// 构建时间输入行
  Widget _buildTimeInputRow(
    String title,
    String subtitle,
    int value,
    String unit,
    void Function(int) onChanged,
  ) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF333333),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF999999),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        SizedBox(
          width: 100,
          child: TextField(
            controller: TextEditingController(text: value.toString()),
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              suffixText: unit,
            ),
            keyboardType: TextInputType.number,
            onChanged: (text) {
              final intValue = int.tryParse(text);
              if (intValue != null && intValue >= 0) {
                onChanged(intValue);
              }
            },
          ),
        ),
      ],
    );
  }

  /// 构建数字输入行
  Widget _buildNumberInputRow(
    String title,
    String subtitle,
    int value,
    void Function(int) onChanged,
  ) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF333333),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF999999),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        SizedBox(
          width: 100,
          child: TextField(
            controller: TextEditingController(text: value.toString()),
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
            keyboardType: TextInputType.number,
            onChanged: (text) {
              final intValue = int.tryParse(text);
              if (intValue != null && intValue > 0) {
                onChanged(intValue);
              }
            },
          ),
        ),
      ],
    );
  }

  /// 保存设置
  void _saveSettings() {
    // TODO: 保存到服务器
    debugPrint('保存订单设置');
    debugPrint('自动关闭时间: $_autoCloseMinutes 分钟');
    debugPrint('自动确认收货: $_autoConfirmDays 天');
    debugPrint('自动评价: $_autoReviewDays 天');
    debugPrint('允许评价: $_allowReview');
    debugPrint('评价审核: $_needReviewAudit');
    debugPrint('退款审核: $_needRefundAudit');

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('订单设置已保存')),
    );
  }
}

/// 订单设置内容组件（嵌入在merchant_dashboard中使用）
class OrderSettingsContent extends StatelessWidget {
  const OrderSettingsContent({super.key});

  @override
  Widget build(BuildContext context) {
    return const OrderSettingsPage();
  }
}
