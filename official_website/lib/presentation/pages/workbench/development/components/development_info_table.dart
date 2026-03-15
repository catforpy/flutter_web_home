import 'package:flutter/material.dart';
import 'copy_button.dart';

/// 开发信息表格组件
class DevelopmentInfoTable extends StatelessWidget {
  const DevelopmentInfoTable({super.key});

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
            '开发信息',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF333333),
            ),
          ),
          SizedBox(height: 24),
          _DevelopmentTable(),
        ],
      ),
    );
  }
}

class _DevelopmentTable extends StatelessWidget {
  const _DevelopmentTable();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildTableRow('小程序名称', '唐极课得'),
        _buildTableRow('认证类型', '企业认证'),
        _buildTableRow(
          '回调URL',
          'https://api.tangjikede.com/callback',
          hasCopy: true,
        ),
        _buildTableRow(
          '回调Token',
          'tangjikede_token_2024_secure',
          hasCopy: true,
        ),
        _buildPermissionRow(),
      ],
    );
  }

  Widget _buildTableRow(String label, String value, {bool hasCopy = false}) {
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
            width: 120,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF666666),
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF333333),
              ),
            ),
          ),
          if (hasCopy) const CopyButton(),
        ],
      ),
    );
  }

  Widget _buildPermissionRow() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                width: 120,
                child: Text(
                  '权限集',
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: const TextSpan(
                          style: TextStyle(
                            fontSize: 13,
                            color: Color(0xFF333333),
                            height: 1.8,
                          ),
                          children: [
                            TextSpan(text: '已授权: ', style: TextStyle(color: Color(0xFF52C41A))),
                            TextSpan(text: '帐号管理权限（帮助小程序获取二维码，进行账号管理）\n'),
                            TextSpan(text: '已授权: ', style: TextStyle(color: Color(0xFF52C41A))),
                            TextSpan(text: '开发管理与数据分析权限（帮助小程序进行功能开发与数据分析）\n'),
                            TextSpan(text: '已授权: ', style: TextStyle(color: Color(0xFF52C41A))),
                            TextSpan(text: '客服消息管理权限（帮助小程序接收和发送客服消息）\n'),
                            TextSpan(text: '已授权: ', style: TextStyle(color: Color(0xFF52C41A))),
                            TextSpan(text: '开放平台帐号管理权限（帮助小程序绑定开放平台账号，实现用户身份打通）\n'),
                            TextSpan(text: '已授权: ', style: TextStyle(color: Color(0xFF52C41A))),
                            TextSpan(text: '小程序基本信息设置权限（帮助小程序设置名称、头像、简介、类目等基本信息）\n'),
                            TextSpan(text: '已授权: ', style: TextStyle(color: Color(0xFF52C41A))),
                            TextSpan(text: '小程序认证权限（帮助小程序申请认证）\n'),
                            TextSpan(text: '已授权: ', style: TextStyle(color: Color(0xFF52C41A))),
                            TextSpan(text: '微信卡路里权限（为小程序提供用户卡路里同步、授权查询、兑换功能）\n'),
                            TextSpan(text: '已授权: ', style: TextStyle(color: Color(0xFF52C41A))),
                            TextSpan(text: '附近地点权限（帮助小程序创建附件地点，可设置小程序展示在"附件的小程序"入口中）\n'),
                            TextSpan(text: '已授权: ', style: TextStyle(color: Color(0xFF52C41A))),
                            TextSpan(text: '插件管理权限（用于代小程序管理插件的添加和使用）\n'),
                            TextSpan(text: '已授权: ', style: TextStyle(color: Color(0xFF52C41A))),
                            TextSpan(text: '好物圈权限（帮助小程序将物品、订单、收藏等信息同步至好物圈，方便用户进行推荐）\n'),
                            TextSpan(text: '已授权: ', style: TextStyle(color: Color(0xFF52C41A))),
                            TextSpan(text: '物流助手权限（帮助有物流需求的开发者，快速高效对接多家物流公司。对接后用户可通过微信服务通知接收实时物流状态，提升用户体验）\n'),
                            TextSpan(text: '已授权: ', style: TextStyle(color: Color(0xFF52C41A))),
                            TextSpan(text: '即时配送权限（旨在解决餐饮、生鲜、超市等小程序的外卖配送需求，接入后小程序商家可通过统一的接口获得多家配送公司的配送服务，提高经营效率）\n'),
                            TextSpan(text: '已授权: ', style: TextStyle(color: Color(0xFF52C41A))),
                            TextSpan(text: '小程序直播权限（帮助有直播需求的小程序实现在小程序上直播边看边买的能力）\n'),
                            TextSpan(text: '已授权: ', style: TextStyle(color: Color(0xFF52C41A))),
                            TextSpan(text: '广告管理权限（帮助广告主进行微信广告的投放和管理）\n'),
                            TextSpan(text: '已授权: ', style: TextStyle(color: Color(0xFF52C41A))),
                            TextSpan(text: '商品管理权限（支持对小商店商品及库存信息进行管理）\n'),
                            TextSpan(text: '已授权: ', style: TextStyle(color: Color(0xFF52C41A))),
                            TextSpan(text: '订单与物流管理权限（支持对小商店订单及物流信息进行管理）\n'),
                            TextSpan(text: '已授权: ', style: TextStyle(color: Color(0xFF52C41A))),
                            TextSpan(text: '快速体验小程序权限（帮助用户快速创建试用小程序，以及对试用小程序快速转正）\n'),
                            TextSpan(text: '已授权: ', style: TextStyle(color: Color(0xFF52C41A))),
                            TextSpan(text: '优惠券权限集（小商店的优惠券权限集，可以使用此权限集完成小商店优惠券的制作、发放、信息的搜集等能力）\n'),
                            TextSpan(text: '已授权: ', style: TextStyle(color: Color(0xFF52C41A))),
                            TextSpan(text: '自定义版交易组件（包含自定义版交易组件的接入、商品、订单、物流、售后等接口）\n'),
                            TextSpan(text: '已授权: ', style: TextStyle(color: Color(0xFF52C41A))),
                            TextSpan(text: '获取URL Scheme权限（获取小程序scheme码，适用于从短信、邮件、微信外网页等场景打开小程序）\n'),
                            TextSpan(text: '已授权: ', style: TextStyle(color: Color(0xFF52C41A))),
                            TextSpan(text: '小程序发货管理服务（用于小程序支付单的发货信息录入、查询等）'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Padding(
            padding: EdgeInsets.only(left: 120),
            child: Text(
              '提示：若有权限集显示"未授权"，则先登录(https://mp.weixin.qq.com)微信小程序平台->设置->第三方服务->停止授权，然后再重新授权即可',
              style: TextStyle(
                fontSize: 12,
                color: Color(0xFFFF4D4F),
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

}

