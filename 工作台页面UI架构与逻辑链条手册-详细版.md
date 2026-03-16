# 工作台页面 - UI架构与逻辑链条手册

> **版本**: v1.0
> **更新时间**: 2026-03-16
> **用途**: 清晰描述"工作台页面"的UI内容和完整逻辑链条

---

## 目录

1. [工作台页面：整体框架](#工作台页面整体框架)
2. [跳转链条1：工作台页面 → 小程序管理-开发设置](#跳转链条1工作台页面---小程序管理-开发设置)
3. [跳转链条2：工作台页面 → 配置管理-支付配置](#跳转链条2工作台页面---配置管理-支付配置)
4. [跳转链条3：工作台页面 → 课程管理-课程列表](#跳转链条3工作台页面---课程管理-课程列表)
5. [跳转链条4：工作台页面 → 订单管理-课程订单](#跳转链条4工作台页面---订单管理-课程订单)
6. [跳转链条5：工作台页面 → 常用工具编辑](#跳转链条5工作台页面---常用工具编辑)
7. [跳转链条6：工作台页面 → 消息通知弹窗](#跳转链条6工作台页面---消息通知弹窗)
8. [跳转链条7：工作台页面 → 退出登录](#跳转链条7工作台页面---退出登录)
9. [跳转链条8：工作台页面 → 返回逻辑](#跳转链条8工作台页面---返回逻辑)
10. [页面功能说明](#页面功能说明)

---

## 工作台页面：整体框架

```
MerchantDashboard（商户工作台页面）
├── PopScope（返回拦截组件）
│   ├── canPop: false（拦截所有返回事件）
│   └── onPopInvokedWithResult（返回事件处理）
│       ↓
│       调用：_handleBackPressed() 方法
│       ↓
│       判断来源页面
│       ├── 如果是从首页/购买/租赁/合作/定制开发进入 → 正常返回
│       └── 否则 → 返回到"我的"页面
│
├── Scaffold（脚手架组件）
│   └── backgroundColor: Color(0xFFF5F6F7)（浅灰背景）
│
└── Stack（堆叠布局容器）
    ├── Row（主行容器）
    │   ├── 左侧导航栏（200px，深灰黑背景）
    │   │   └── Container
    │   │       ├── width: 200（宽度200px）
    │   │       ├── color: Color(0xFF1F2329)（深灰黑背景色）
    │   │       └── Column（左侧栏列容器）
    │   │           ├── 菜单项列表区域（可滚动）
    │   │           │   └── Expanded + ListView
    │   │           │       └── ListView（padding: EdgeInsets.zero）
    │   │           │           └── 菜单项组件列表（15个父菜单）
    │   │           │               ├── 管理中心菜单项组件（无子菜单）
    │   │           │               │   ├── Icon: Icons.store
    │   │           │               │   ├── 菜单文字组件（显示"管理中心"）
    │   │           │               │   ├── height: 48（高度48px）
    │   │           │               │   ├── padding: EdgeInsets.symmetric(horizontal: 20)
    │   │           │               │   ├── 背景色：展开/选中时 Color(0xFF2D343A)，否则透明
    │   │           │               │   ├── 图标颜色：展开/选中时白色，否则 Color(0xFFCCCCCC)
    │   │           │               │   ├── 文字颜色：展开/选中时白色，否则 Color(0xFFCCCCCC)
    │   │           │               │   ├── 点击事件 → 清空子菜单选中状态
    │   │           │               │   └── 无右箭头图标
    │   │           │               │
    │   │           │               ├── 小程序管理菜单项组件（有6个子菜单）
    │   │           │               │   ├── Icon: Icons.phone_android
    │   │           │               │   ├── 菜单文字组件（显示"小程序管理"）
    │   │           │               │   ├── height: 48（高度48px）
    │   │           │               │   ├── padding: EdgeInsets.symmetric(horizontal: 20)
    │   │           │               │   ├── 背景色：展开/选中时 Color(0xFF2D343A)，否则透明
    │   │           │               │   ├── 图标颜色：展开/选中时白色，否则 Color(0xFFCCCCCC)
    │   │           │               │   ├── 文字颜色：展开/选中时白色，否则 Color(0xFFCCCCCC)
    │   │           │               │   ├── 右箭头图标：展开时 Icons.expand_less，收起时 Icons.keyboard_arrow_down
    │   │           │               │   ├── 点击事件 → 展开/收起子菜单
    │   │           │               │   └── 子菜单列表（展开时显示）
    │   │           │               │       ├── Container（padding: EdgeInsets.only(left: 20)）
    │   │           │               │       └── Column（子菜单列容器）
    │   │           │               │           └── 子菜单项列表（6个子菜单）
    │   │           │               │               ├── 开发设置子菜单项组件
    │   │           │               │               │   ├── height: 40（高度40px）
    │   │           │               │               │   ├── padding: EdgeInsets.symmetric(horizontal: 20)
    │   │           │               │               │   ├── 文字组件（显示"开发设置"）
    │   │           │               │               │   ├── 字体大小：15
    │   │           │               │               │   ├── 字体颜色：选中时白色，否则 Color(0xFFCCCCCC)
    │   │           │               │               │   ├── 字体粗细：选中时 FontWeight.w500
    │   │           │               │               │   ├── 点击事件 → 设置子菜单选中 + 更新URL参数
    │   │           │               │               │   └── 路由更新：context.push('${AppRouter.merchantDashboard}?tab=开发设置')
    │   │           │               │               │
    │   │           │               │               ├── 审核管理子菜单项组件
    │   │           │               │               │   ├── height: 40（高度40px）
    │   │           │               │               │   ├── 文字组件（显示"审核管理"）
    │   │           │               │               │   ├── 字体大小：15
    │   │           │               │               │   ├── 字体颜色：选中时白色，否则 Color(0xFFCCCCCC)
    │   │           │               │               │   ├── 点击事件 → 设置子菜单选中 + 更新URL参数
    │   │           │               │               │   └── 路由更新：context.push('${AppRouter.merchantDashboard}?tab=审核管理')
    │   │           │               │               │
    │   │           │               │               ├── 菜单导航子菜单项组件
    │   │           │               │               │   ├── 文字组件（显示"菜单导航"）
    │   │           │               │               │   ├── 点击事件 → 设置子菜单选中 + 更新URL参数
    │   │           │               │               │   └── 路由更新：context.push('${AppRouter.merchantDashboard}?tab=菜单导航')
    │   │           │               │               │
    │   │           │               │               ├── 订阅消息子菜单项组件
    │   │           │               │               │   ├── 文字组件（显示"订阅消息"）
    │   │           │               │               │   ├── 点击事件 → 设置子菜单选中 + 更新URL参数
    │   │           │               │               │   └── 路由更新：context.push('${AppRouter.merchantDashboard}?tab=订阅消息')
    │   │           │               │               │
    │   │           │               │               ├── 跳转小程序子菜单项组件
    │   │           │               │               │   ├── 文字组件（显示"跳转小程序"）
    │   │           │               │               │   ├── 点击事件 → 设置子菜单选中 + 更新URL参数
    │   │           │               │               │   └── 路由更新：context.push('${AppRouter.merchantDashboard}?tab=跳转小程序')
    │   │           │               │               │
    │   │           │               │               └── 开发者模式子菜单项组件
    │   │           │               │                   ├── 文字组件（显示"开发者模式"）
    │   │           │               │                   ├── 点击事件 → 设置子菜单选中 + 更新URL参数
    │   │           │               │                   └── 路由更新：context.push('${AppRouter.merchantDashboard}?tab=开发者模式')
    │   │           │               │
    │   │           │               ├── 配置管理菜单项组件（有6个子菜单）
    │   │           │               │   ├── Icon: Icons.settings
    │   │           │               │   ├── 菜单文字组件（显示"配置管理"）
    │   │           │               │   ├── 点击事件 → 展开/收起子菜单
    │   │           │               │   └── 子菜单列表（6个子菜单）
    │   │           │               │       ├── 支付配置子菜单项组件
    │   │           │               │       │   ├── 文字组件（显示"支付配置"）
    │   │           │               │       │   ├── 点击事件 → 设置子菜单选中 + 更新URL参数
    │   │           │               │       │   └── 路由更新：context.push('${AppRouter.merchantDashboard}?tab=支付配置')
    │   │           │               │       │
    │   │           │               │       ├── 分享海报设置子菜单项组件
    │   │           │               │       │   ├── 文字组件（显示"分享海报设置"）
    │   │           │               │       │   ├── 点击事件 → 设置子菜单选中
    │   │           │               │       │   └── 路由更新：context.push('${AppRouter.merchantDashboard}?tab=分享海报设置')
    │   │           │               │       │
    │   │           │               │       ├── 客服设置子菜单项组件
    │   │           │               │       │   ├── 文字组件（显示"客服设置"）
    │   │           │               │       │   ├── 点击事件 → 设置子菜单选中
    │   │           │               │       │   └── 路由更新：context.push('${AppRouter.merchantDashboard}?tab=客服设置')
    │   │           │               │       │
    │   │           │               │       ├── 短信设置子菜单项组件
    │   │           │               │       │   ├── 文字组件（显示"短信设置"）
    │   │           │               │       │   ├── 点击事件 → 设置子菜单选中
    │   │           │               │       │   └── 路由更新：context.push('${AppRouter.merchantDashboard}?tab=短信设置')
    │   │           │               │       │
    │   │           │               │       ├── 音视频存储子菜单项组件
    │   │           │               │       │   ├── 文字组件（显示"音视频存储"）
    │   │           │               │       │   ├── 点击事件 → 设置子菜单选中
    │   │           │               │       │   └── 路由更新：context.push('${AppRouter.merchantDashboard}?tab=音视频存储')
    │   │           │               │       │
    │   │           │               │       └── 广告位配置子菜单项组件
    │   │           │               │           ├── 文字组件（显示"广告位配置"）
    │   │           │               │           ├── 点击事件 → 设置子菜单选中
    │   │           │               │           └── 路由更新：context.push('${AppRouter.merchantDashboard}?tab=广告位配置')
    │   │           │               │
    │   │           │               ├── 模块管理菜单项组件（有5个子菜单）
    │   │           │               │   ├── Icon: Icons.extension
    │   │           │               │   ├── 菜单文字组件（显示"模块管理"）
    │   │           │               │   ├── 点击事件 → 展开/收起子菜单
    │   │           │               │   └── 子菜单列表（5个子菜单）
    │   │           │               │       ├── 文章管理子菜单项组件
    │   │           │               │       ├── 留言管理子菜单项组件
    │   │           │               │       ├── 启动图管理子菜单项组件
    │   │           │               │       ├── 活动页配置子菜单项组件
    │   │           │               │       └── 经典语录管理子菜单项组件
    │   │           │               │
    │   │           │               ├── 页面管理菜单项组件（有3个子菜单）
    │   │           │               │   ├── Icon: Icons.image
    │   │           │               │   ├── 菜单文字组件（显示"页面管理"）
    │   │           │               │   ├── 点击事件 → 展开/收起子菜单
    │   │           │               │   └── 子菜单列表（3个子菜单）
    │   │           │               │       ├── 导航页面管理子菜单项组件
    │   │           │               │       ├── 功能页面管理子菜单项组件
    │   │           │               │       └── 个人中心管理子菜单项组件
    │   │           │               │
    │   │           │               ├── 课程管理菜单项组件（有5个子菜单）
    │   │           │               │   ├── Icon: Icons.menu_book
    │   │           │               │   ├── 菜单文字组件（显示"课程管理"）
    │   │           │               │   ├── 点击事件 → 展开/收起子菜单
    │   │           │               │   └── 子菜单列表（5个子菜单）
    │   │           │               │       ├── 课程分类子菜单项组件
    │   │           │               │       ├── 课程列表子菜单项组件
    │   │           │               │       ├── 讲师管理子菜单项组件
    │   │           │               │       ├── 课程问答管理子菜单项组件
    │   │           │               │       └── 评论管理子菜单项组件
    │   │           │               │
    │   │           │               ├── 订单管理菜单项组件（有3个子菜单）
    │   │           │               │   ├── Icon: Icons.shopping_cart
    │   │           │               │   ├── 菜单文字组件（显示"订单管理"）
    │   │           │               │   ├── 点击事件 → 展开/收起子菜单
    │   │           │               │   └── 子菜单列表（3个子菜单）
    │   │           │               │       ├── 课程订单子菜单项组件
    │   │           │               │       ├── 商品订单子菜单项组件
    │   │           │               │       └── 租赁业务订单子菜单项组件
    │   │           │               │
    │   │           │               ├── 商城管理菜单项组件（有5个子菜单）
    │   │           │               │   ├── Icon: Icons.storefront
    │   │           │               │   ├── 菜单文字组件（显示"商城管理"）
    │   │           │               │   ├── 点击事件 → 展开/收起子菜单
    │   │           │               │   └── 子菜单列表（5个子菜单）
    │   │           │               │       ├── 货架管理子菜单项组件
    │   │           │               │       ├── 我的仓库子菜单项组件
    │   │           │               │       ├── 商品评价子菜单项组件
    │   │           │               │       ├── 运费模板子菜单项组件
    │   │           │               │       └── 订单设置子菜单项组件
    │   │           │               │
    │   │           │               ├── 用户管理菜单项组件（有5个子菜单）
    │   │           │               │   ├── Icon: Icons.people
    │   │           │               │   ├── 菜单文字组件（显示"用户管理"）
    │   │           │               │   ├── 点击事件 → 展开/收起子菜单
    │   │           │               │   └── 子菜单列表（5个子菜单）
    │   │           │               │       ├── 用户列表子菜单项组件
    │   │           │               │       ├── 用户分类子菜单项组件
    │   │           │               │       ├── 用户等级子菜单项组件
    │   │           │               │       ├── 签到记录子菜单项组件
    │   │           │               │       └── 搜索历史管理子菜单项组件
    │   │           │               │
    │   │           │               ├── 客服管理菜单项组件（有4个子菜单）
    │   │           │               │   ├── Icon: Icons.headset_mic
    │   │           │               │   ├── 菜单文字组件（显示"客服管理"）
    │   │           │               │   ├── 点击事件 → 展开/收起子菜单
    │   │           │               │   └── 子菜单列表（4个子菜单）
    │   │           │               │       ├── 售后处理子菜单项组件
    │   │           │               │       ├── 维权订单子菜单项组件
    │   │           │               │       ├── 客服话术子菜单项组件
    │   │           │               │       └── 咨询记录子菜单项组件
    │   │           │               │
    │   │           │               ├── 业务管理菜单项组件（有2个子菜单）
    │   │           │               │   ├── Icon: Icons.business_center
    │   │           │               │   ├── 菜单文字组件（显示"业务管理"）
    │   │           │               │   ├── 点击事件 → 展开/收起子菜单
    │   │           │               │   └── 子菜单列表（2个子菜单）
    │   │           │               │       ├── 租赁管理子菜单项组件
    │   │           │               │       └── 合作管理子菜单项组件
    │   │           │               │
    │   │           │               ├── 会员卡管理菜单项组件（有3个子菜单）
    │   │           │               │   ├── Icon: Icons.card_membership
    │   │           │               │   ├── 菜单文字组件（显示"会员卡管理"）
    │   │           │               │   ├── 点击事件 → 展开/收起子菜单
    │   │           │               │   └── 子菜单列表（3个子菜单）
    │   │           │               │       ├── 会员卡子菜单项组件
    │   │           │               │       ├── 储值卡子菜单项组件
    │   │           │               │       └── 会员对话码子菜单项组件
    │   │           │               │
    │   │           │               ├── 营销工具菜单项组件（有3个子菜单）
    │   │           │               │   ├── Icon: Icons.campaign
    │   │           │               │   ├── 菜单文字组件（显示"营销工具"）
    │   │           │               │   ├── 点击事件 → 展开/收起子菜单
    │   │           │               │   └── 子菜单列表（3个子菜单）
    │   │           │               │       ├── 优惠券子菜单项组件
    │   │           │               │       ├── 拼团子菜单项组件
    │   │           │               │       └── 秒杀子菜单项组件
    │   │           │               │
    │   │           │               ├── 商户概览菜单项组件（无子菜单）
    │   │           │               │   ├── Icon: Icons.bar_chart
    │   │           │               │   └── 无右箭头图标
    │   │           │               │
    │   │           │               ├── 操作日志菜单项组件（无子菜单）
    │   │           │               │   ├── Icon: Icons.edit_note
    │   │           │               │   └── 无右箭头图标
    │   │           │               │
    │   │           │               ├── 推送消息配置菜单项组件（无子菜单）
    │   │           │               │   ├── Icon: Icons.notifications
    │   │           │               │   └── 无右箭头图标
    │   │           │               │
    │   │           │               └── 权限设置菜单项组件（无子菜单）
    │   │           │                   ├── Icon: Icons.lock
    │   │           │                   └── 无右箭头图标
    │   │           │
    │   │           ├── 底部分隔线组件
    │   │           │   └── Container
    │   │           │       ├── height: 1（高度1px）
    │   │           │       └── color: Color(0xFF333333)（深灰色）
    │   │           │
    │   │           └── 底部品牌标识组件
    │   │               └── Container
    │   │                   ├── padding: EdgeInsets.symmetric(vertical: 24)
    │   │                   └── Column
    │   │                       ├── Logo容器组件
    │   │                       │   └── Container
    │   │                       │       ├── width: 40（宽度40px）
    │   │                       │       ├── height: 20（高度20px）
    │   │                       │       ├── decoration: BoxDecoration（渐变背景）
    │   │                       │       │   └── LinearGradient
    │   │                       │       │       ├── colors: [Color(0xFFFF6B35), Color(0xFF1A9B8E)]
    │   │                       │       │       └── borderRadius: BorderRadius.circular(4)
    │   │                       │       └── 模拟彩色波浪形Logo
    │   │                       │
    │   │                       └── 品牌名称文字组件
    │   │                           └── Text
    │   │                               ├── 文字内容："唐极课得"
    │   │                               ├── fontSize: 10
    │   │                               ├── color: Color(0xFFCCCCCC)
    │   │                               └── fontWeight: FontWeight.w300
    │   │
    │   └── 主内容区（包含顶部标题栏 + 主内容）
    │       └── Expanded + Column
    │           ├── 顶部标题栏组件（60px，青绿色背景）
    │           │   └── Container
    │           │       ├── height: 60（高度60px）
    │           │       ├── color: Color(0xFF1A9B8E)（青绿色背景）
    │           │       ├── padding: EdgeInsets.symmetric(horizontal: 24)
    │           │       └── Row
    │           │           ├── 左侧Logo + 系统名称组件
    │           │           │   └── MouseRegion + GestureDetector
    │           │           │       └── Row
    │           │           │           ├── Logo容器组件
    │           │           │           │   └── Container
    │           │           │           │       ├── width: 32（宽度32px）
    │           │           │           │       ├── height: 32（高度32px）
    │           │           │           │       ├── decoration: BoxDecoration
    │           │           │           │       │   ├── color: Colors.white
    │           │           │           │       │   └── shape: BoxShape.circle
    │           │           │           │       └── Center（居中组件）
    │           │           │           │           └── Text（字母W）
    │           │           │           │               ├── fontSize: 18
    │           │           │           │               ├── fontWeight: FontWeight.bold
    │           │           │           │               └── color: Color(0xFF1A9B8E)
    │           │           │           │
    │           │           │           ├── SizedBox(width: 12)
    │           │           │           │
    │           │           │           └── 系统名称文字组件
    │           │           │               └── Text
    │           │           │                   ├── 文字内容："唐极课得 管理系统 | 小程序"
    │           │           │                   ├── fontSize: 16
    │           │           │                   ├── fontWeight: FontWeight.bold
    │           │           │                   └── color: Colors.white
    │           │           │
    │           │           ├── Spacer（弹性间距）
    │           │           │
    │           │           └── 右侧功能按钮组
    │           │               └── Row
    │           │                   ├── 预览按钮组件
    │           │                   │   └── _buildHeaderButton('预览')
    │           │                   │       └── Container
    │           │                   │           ├── padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8)
    │           │                   │           ├── borderRadius: BorderRadius.circular(4)
    │           │                   │           └── Text
    │           │                   │               ├── 文字内容："预览"
    │           │                   │               ├── fontSize: 14
    │           │                   │               └── color: Colors.white
    │           │                   │
    │           │                   ├── SizedBox(width: 16)
    │           │                   │
    │           │                   ├── 提交按钮组件
    │           │                   │   └── _buildHeaderButton('提交')
    │           │                   │       └── Container
    │           │                   │           └── Text（文字内容："提交"）
    │           │                   │
    │           │                   ├── SizedBox(width: 16)
    │           │                   │
    │           │                   ├── 消息通知按钮组件（带未读数量徽章）
    │           │                   │   └── _buildNotificationButton()
    │           │                   │       └── Container
    │           │                   │           ├── key: _notificationButtonKey（用于定位弹窗）
    │           │                   │           ├── padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8)
    │           │                   │           ├── borderRadius: BorderRadius.circular(4)
    │           │                   │           ├── Row
    │           │                   │           │   ├── Text（文字内容："消息通知"）
    │           │                   │           │   │   ├── fontSize: 14
    │           │                   │           │   │   └── color: Colors.white
    │           │                   │           │   │
    │           │                   │           │   ├── SizedBox(width: 6)
    │           │                   │           │   │
    │           │                   │           │   └── 未读数量徽章组件
    │           │                   │           │       └── Container
    │           │                   │           │           ├── padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2)
    │           │                   │           │           ├── decoration: BoxDecoration
    │           │                   │           │           │   ├── color: Color(0xFFFF4D4F)（红色）
    │           │                   │           │           │   └── shape: BoxShape.circle
    │           │                   │           │           └── Text（显示未读数量）
    │           │                   │           │               ├── fontSize: 10
    │           │                   │           │               └── color: Colors.white
    │           │                   │           │
    │           │                   │           └── 点击事件 → 切换消息通知弹窗显示/隐藏
    │           │                   │
    │           │                   ├── SizedBox(width: 16)
    │           │                   │
    │           │                   ├── 店铺设置按钮组件
    │           │                   │   └── _buildHeaderButton('店铺设置', isSettings: true)
    │           │                   │       └── Container
    │           │                   │           └── Text（文字内容："店铺设置"）
    │           │                   │           └── 点击事件 → Navigator.push → StoreSettingsPage
    │           │                   │
    │           │                   ├── SizedBox(width: 16)
    │           │                   │
    │           │                   ├── 管理中心按钮组件
    │           │                   │   └── _buildHeaderButton('管理中心', isManagementCenter: true)
    │           │                   │       └── Container
    │           │                   │           └── Text（文字内容："管理中心"）
    │           │                   │           └── 点击事件 → context.go(AppRouter.merchantDashboard) → 清空子菜单选中状态
    │           │                   │
    │           │                   ├── SizedBox(width: 16)
    │           │                   │
    │           │                   ├── 用户头像按钮组件
    │           │                   │   └── MouseRegion + GestureDetector
    │           │                   │       └── Container
    │           │                   │           ├── width: 36（宽度36px）
    │           │                   │           ├── height: 36（高度36px）
    │           │                   │           ├── decoration: BoxDecoration
    │           │                   │           │   ├── color: Color(0xFF1A9B8E)
    │           │                   │           │   └── borderRadius: BorderRadius.circular(18)
    │           │                   │           └── Icon
    │           │                   │               ├── Icons.person
    │           │                   │               ├── size: 20
    │           │                   │               └── color: Colors.white
    │           │                   │           └── 点击事件 → context.go(AppRouter.profile) → 跳转到个人中心页面
    │           │                   │
    │           │                   ├── SizedBox(width: 16)
    │           │                   │
    │           │                   ├── 退出按钮组件
    │           │                   │   └── _buildHeaderButton('退出', isLogout: true)
    │           │                   │       └── Container
    │           │                   │           └── Text（文字内容："退出"）
    │           │                   │           └── 点击事件 → showDialog → 退出登录确认对话框
    │           │                   │
    │           │                   ├── SizedBox(width: 16)
    │           │                   │
    │           │                   └── 更多操作按钮组件
    │           │                       └── _buildHeaderButton('更多操作', isMoreButton: true)
    │           │                           └── Container
    │           │                               └── Icon
    │           │                                   ├── Icons.more_horiz
    │           │                                   ├── size: 16
    │           │                                   └── color: Colors.white
    │           │
    │           └── 主内容区组件（根据选中的子菜单项动态切换）
    │               └── Expanded + _buildContentArea()
    │                   ├── 如果 _selectedSubMenuItem.isEmpty（未选中子菜单）
    │                   │   └── SingleChildScrollView + _buildMainContent() → 显示管理中心主页
    │                   │
    │                   └── 如果 _selectedSubMenuItem.isNotEmpty（已选中子菜单）
    │                       └── switch(_selectedSubMenuItem) → 显示对应的内容组件
    │                           ├── case '开发设置': DevelopmentSettingsContent()
    │                           ├── case '审核管理': AuditManagementContent()
    │                           ├── case '菜单导航': MenuNavigationContent()
    │                           ├── case '支付配置': PaymentConfigContent()
    │                           ├── case '音视频存储': MediaListContent()
    │                           ├── case '文章管理': ArticleManagementPage(showFullNavigation: false)
    │                           ├── case '文章列表': ArticleListContent()
    │                           ├── case '打赏记录': RewardRecordsContent()
    │                           ├── case '课程分类': CourseCategoryManagementContent()
    │                           ├── case '讲师管理': InstructorManagementContent()
    │                           ├── case '课程问答管理': CourseQAManagementContent()
    │                           ├── case '课程列表': CourseListContent()
    │                           ├── case '课程订单': CourseOrderContent()
    │                           ├── case '货架管理': ProductCategoryManagementContent()
    │                           ├── case '我的仓库': MyWarehouseContent()
    │                           ├── case '商品评价': ProductReviewsContent()
    │                           ├── case '运费模板': FreightTemplateContent()
    │                           ├── case '订单设置': OrderSettingsContent()
    │                           ├── case '售后处理': AfterSaleContent()
    │                           ├── case '导航页面管理': NavigationPageManagementContent()
    │                           ├── case '个人中心管理': PageEditor(initialPageType: '个人中心')
    │                           └── default: _buildComingSoonContent(featureName) → 显示"即将推出"提示页
    │
    ├── 消息通知弹窗组件（Overlay实现）
    │   └── _buildNotificationOverlay()
    │       └── OverlayEntry
    │           └── GestureDetector（点击弹窗外部关闭）
    │               └── Container（全屏透明容器）
    │                   └── Stack
    │                       └── Positioned（绝对定位）
    │                           └── Container（弹窗主体）
    │                               ├── constraints: BoxConstraints(minWidth: 400, maxWidth: 400, maxHeight: 500)
    │                               ├── decoration: BoxDecoration
    │                               │   ├── color: Colors.white
    │                               │   ├── borderRadius: BorderRadius.circular(8)
    │                               │   └── boxShadow（阴影效果）
    │                               │       └── BoxShadow
    │                               │           ├── color: Colors.black.withValues(alpha: 0.15)
    │                               │           ├── blurRadius: 16
    │                               │           └── offset: Offset(0, 4)
    │                               └── Column
    │                                   ├── 头部操作区组件
    │                                   │   └── Container
    │                                   │       ├── height: 48（高度48px）
    │                                   │       ├── padding: EdgeInsets.symmetric(horizontal: 16)
    │                                   │       ├── decoration: BoxDecoration（底部边框）
    │                                   │       │   └── Border
    │                                   │       │       └── bottom: BorderSide(color: Color(0xFFF0F0F0), width: 1)
    │                                   │       └── Row
    │                                   │           ├── 标题文字组件
    │                                   │           │   └── Text
    │                                   │           │       ├── 文字内容："消息通知"
    │                                   │           │       ├── fontSize: 16
    │                                   │           │       ├── fontWeight: FontWeight.bold
    │                                   │           │       └── color: Color(0xFF333333)
    │                                   │           │
    │                                   │           ├── Spacer（弹性间距）
    │                                   │           │
    │                                   │           └── 全部已读按钮组件
    │                                   │               └── MouseRegion + GestureDetector
    │                                   │                   └── Text
    │                                   │                       ├── 文字内容："全部已读"
    │                                   │                       ├── fontSize: 14
    │                                   │                       └── color: Color(0xFF1890FF)
    │                                   │                       └── 点击事件 → 将所有消息标记为已读
    │                                   │
    │                                   └── 消息列表区组件
    │                                       └── ConstrainedBox
    │                                           ├── constraints: BoxConstraints(maxHeight: 400)
    │                                           └── SingleChildScrollView
    │                                               └── Column
    │                                                   └── 消息卡片列表（_messages.map）
    │                                                       └── _buildMessageItem(message, index)
    │                                                           └── Container
    │                                                               ├── padding: EdgeInsets.all(16)
    │                                                               ├── decoration: BoxDecoration（底部边框）
    │                                                               │   └── Border
    │                                                               │       └── bottom: BorderSide(color: Color(0xFFF5F5F5), width: 1)
    │                                                               └── Column
    │                                                                   ├── 标题行组件
    │                                                                   │   └── Row
    │                                                                   │       ├── 消息标题文字组件
    │                                                                   │       │   └── Text
    │                                                                   │       │       ├── 文字内容：message['title']（如"订单付款通知"）
    │                                                                   │       │       ├── fontSize: 16
    │                                                                   │       │       ├── fontWeight: FontWeight.bold
    │                                                                   │       │       └── color: isRead ? Color(0xFF666666) : Color(0xFF333333)
    │                                                                   │       │
    │                                                                   │       ├── Spacer（弹性间距）
    │                                                                   │       │
    │                                                                   │       └── 已读状态文字组件
    │                                                                   │           └── Text
    │                                                                   │               ├── 文字内容：isRead ? '[已读]' : '[未读]'
    │                                                                   │               ├── fontSize: 14
    │                                                                   │               └── color: isRead ? Color(0xFF999999) : Color(0xFF1890FF)
    │                                                                   │
    │                                                                   ├── SizedBox(height: 8)
    │                                                                   │
    │                                                                   ├── 摘要内容文字组件
    │                                                                   │   └── Text
    │                                                                   │       ├── 文字内容：message['content']（如"你管理的店铺唐极课得有新的订单已付款..."）
    │                                                                   │       ├── fontSize: 14
    │                                                                   │       ├── color: isRead ? Color(0xFF999999) : Color(0xFF666666)
    │                                                                   │       ├── height: 1.6（行高）
    │                                                                   │       ├── maxLines: 3（最多显示3行）
    │                                                                   │       └── overflow: TextOverflow.ellipsis（超出显示省略号）
    │                                                                   │
    │                                                                   ├── SizedBox(height: 8)
    │                                                                   │
    │                                                                   └── 时间与操作行组件
    │                                                                       └── Row
    │                                                                           ├── 时间文字组件
    │                                                                           │   └── Text
    │                                                                           │       ├── 文字内容：message['time']（如"2026-02-26 11:32:29"）
    │                                                                           │       ├── fontSize: 12
    │                                                                           │       └── color: Color(0xFF999999)
    │                                                                           │
    │                                                                           ├── Spacer（弹性间距）
    │                                                                           │
    │                                                                           └── 查看详情按钮组件
    │                                                                               └── MouseRegion + GestureDetector
    │                                                                                   └── Text
    │                                                                                       ├── 文字内容："查看详情"
    │                                                                                       ├── fontSize: 14
    │                                                                                       └── color: Color(0xFF1890FF)
    │                                                                                       └── 点击事件 → 标记该消息为已读
    │
    └── 工具编辑弹窗组件（Dialog实现）
        └── _buildToolEditorDialog()
            └── Dialog
                └── Container
                    ├── width: 800（宽度800px）
                    ├── height: 600（高度600px）
                    ├── padding: EdgeInsets.all(24)
                    ├── decoration: BoxDecoration
                    │   ├── color: Colors.white
                    │   └── borderRadius: BorderRadius.circular(8)
                    └── StatefulBuilder
                        └── Column
                            ├── 标题栏组件
                            │   └── Row
                            │       ├── 标题文字组件
                            │       │   └── Text
                            │       │       ├── 文字内容："编辑常用工具"
                            │       │       ├── fontSize: 20
                            │       │       ├── fontWeight: FontWeight.bold
                            │       │       └── color: Color(0xFF333333)
                            │       │
                            │       ├── Spacer（弹性间距）
                            │       │
                            │       └── 已选数量文字组件
                            │           └── Text
                            │               ├── 文字内容："已选 ${tempSelectedTools.length}/16"
                            │               ├── fontSize: 14
                            │               └── color: tempSelectedTools.length > 16 ? Color(0xFFFF4D4F) : Color(0xFF666666)
                            │
                            ├── Divider(height: 32)
                            │
                            ├── 工具列表区组件（可滚动）
                            │   └── Expanded + SingleChildScrollView
                            │       └── Column
                            │           └── _buildToolGroups(tempSelectedTools, setDialogState)
                            │               └── 工具分组列表（按父菜单分组）
                            │                   ├── 小程序管理分组组件
                            │                   │   └── Padding + Column
                            │                   │       ├── 父菜单标题组件
                            │                   │       │   └── Text
                            │                   │       │       ├── 文字内容："小程序管理"
                            │                   │       │       ├── fontSize: 16
                            │                   │       │       ├── fontWeight: FontWeight.bold
                            │                   │       │       └── color: Color(0xFF333333)
                            │                   │       │
                            │                   │       ├── SizedBox(height: 12)
                            │                   │       │
                            │                   │       └── Wrap（自动换行容器）
                            │                   │           ├── spacing: 12（子元素水平间距）
                            │                   │           ├── runSpacing: 12（子元素垂直间距）
                            │                   │           └── 子工具列表（6个工具）
                            │                   │               ├── 开发设置工具项组件
                            │                   │               │   └── MouseRegion + GestureDetector + Container
                            │                   │               │       ├── padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12)
                            │                   │               │       ├── decoration: BoxDecoration
                            │                   │               │       │   ├── color: isSelected ? Color(0xFFE6F7FF) : Color(0xFFF8F9FA)
                            │                   │               │       │   ├── border: Border.all
                            │                   │               │       │   │   └── color: isSelected ? Color(0xFF1890FF) : Color(0xFFD9D9D9)
                            │                   │               │       │   └── borderRadius: BorderRadius.circular(6)
                            │                   │               │       └── Row
                            │                   │               │           ├── 复选框图标组件
                            │                   │               │           │   └── Icon
                            │                   │               │           │       ├── isSelected ? Icons.check_box : Icons.check_box_outline_blank
                            │                   │               │           │       ├── size: 18
                            │                   │               │           │       └── color: isSelected ? Color(0xFF1890FF) : Color(0xFF999999)
                            │                   │               │           │
                            │                   │               │           ├── SizedBox(width: 8)
                            │                   │               │           │
                            │                   │               │           ├── 工具图标组件
                            │                   │               │           │   └── Icon(Icons.code, size: 16, color: Color(0xFF666666))
                            │                   │               │           │
                            │                   │               │           ├── SizedBox(width: 8)
                            │                   │               │           │
                            │                   │               │           └── 工具名称文字组件
                            │                   │               │               └── Text
                            │                   │               │                   ├── 文字内容："开发设置"
                            │                   │               │                   ├── fontSize: 14
                            │                   │               │                   ├── color: isSelected ? Color(0xFF1890FF) : Color(0xFF666666)
                            │                   │               │                   └── fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal
                            │                   │               │                   └── 点击事件 → 切换选中状态（最多16个）
                            │                   │               │
                            │                   │               ├── 审核管理工具项组件（类似结构）
                            │                   │               ├── 菜单导航工具项组件（类似结构）
                            │                   │               ├── 订阅消息工具项组件（类似结构）
                            │                   │               ├── 跳转小程序工具项组件（类似结构）
                            │                   │               └── 开发者模式工具项组件（类似结构）
                            │                   │
                            │                   ├── 配置管理分组组件（类似结构，6个工具）
                            │                   ├── 模块管理分组组件（类似结构，5个工具）
                            │                   ├── 页面管理分组组件（类似结构，3个工具）
                            │                   ├── 课程管理分组组件（类似结构，5个工具）
                            │                   ├── 订单管理分组组件（类似结构，3个工具）
                            │                   ├── 商城管理分组组件（类似结构，5个工具）
                            │                   ├── 用户管理分组组件（类似结构，5个工具）
                            │                   ├── 客服管理分组组件（类似结构，4个工具）
                            │                   ├── 业务管理分组组件（类似结构，2个工具）
                            │                   ├── 会员卡管理分组组件（类似结构，3个工具）
                            │                   └── 营销工具分组组件（类似结构，3个工具）
                            │
                            ├── Divider(height: 32)
                            │
                            └── 底部按钮区组件
                                └── Row
                                    ├── Spacer（弹性间距）
                                    │
                                    ├── 取消按钮组件
                                    │   └── TextButton
                                    │       ├── Text（文字内容："取消"）
                                    │       │   └── color: Color(0xFF666666)
                                    │       └── onPressed → setState(() { _showToolEditor = false; })
                                    │
                                    ├── SizedBox(width: 16)
                                    │
                                    └── 保存按钮组件
                                        └── ElevatedButton
                                            ├── Text（文字内容："保存"）
                                            │   └── color: Colors.white
                                            ├── style: ElevatedButton.styleFrom
                                            │   ├── backgroundColor: Color(0xFF1890FF)
                                            │   ├── disabledBackgroundColor: Color(0xFFD9D9D9)
                                            │   └── padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12)
                                            ├── onPressed: tempSelectedTools.length > 16 ? null : 保存逻辑
                                            │   ↓
                                            │   setState(() {
                                            │     _selectedTools.clear();
                                            │     _selectedTools.addAll(tempSelectedTools);
                                            │     _showToolEditor = false;
                                            │   })
                                            └── 超过16个时按钮禁用

---

## 管理中心主页：整体框架

```
_buildMainContent() → 管理中心主页内容
└── Container
    ├── color: Color(0xFFF5F6F7)（浅灰背景）
    ├── padding: EdgeInsets.all(24)
    └── Column
        ├── 基本信息区 + 运营数据面板（并排）
        │   └── Row
        │       ├── 左侧：基本信息区卡片
        │       │   └── Expanded(flex: 1) + _buildBasicInfoCard()
        │       │       └── Container
        │       │           ├── padding: EdgeInsets.all(24)
        │       │           ├── decoration: BoxDecoration
        │       │           │   ├── color: Colors.white
        │       │           │   ├── borderRadius: BorderRadius.circular(8)
        │       │           │   └── boxShadow（阴影效果）
        │       │           │       └── BoxShadow
        │       │           │           ├── color: Colors.black.withValues(alpha: 0.05)
        │       │           │           ├── blurRadius: 2
        │       │           │           └── offset: Offset(0, 2)
        │       │           └── IntrinsicHeight + Row
        │       │               ├── 左侧：基本信息区域
        │       │               │   └── Expanded + Column
        │       │               │       ├── 标题文字组件
        │       │               │       │   └── Text
        │       │               │       │       ├── 文字内容："基本信息"
        │       │               │       │       ├── fontSize: 18
        │       │               │       │       ├── fontWeight: FontWeight.bold
        │       │               │       │       └── color: Color(0xFF333333)
        │       │               │       │
        │       │               │       ├── 店铺名称行组件
        │       │               │       │   └── Row
        │       │               │       │       ├── 标签文字组件
        │       │               │       │       │   └── Text
        │       │               │       │       │       ├── 文字内容："店铺名称："
        │       │               │       │       │       ├── fontSize: 14
        │       │               │       │       │       └── color: Color(0xFF666666)
        │       │               │       │       │
        │       │               │       │       ├── SizedBox(width: 8)
        │       │               │       │       │
        │       │               │       │       ├── 店铺名称文字组件
        │       │               │       │       │   └── Text
        │       │               │       │       │       ├── 文字内容："唐极课得"
        │       │               │       │       │       ├── fontSize: 14
        │       │               │       │       │       ├── color: Color(0xFF333333)
        │       │               │       │       │       └── fontWeight: FontWeight.w500
        │       │               │       │       │
        │       │               │       │       ├── SizedBox(width: 8)
        │       │               │       │       │
        │       │               │       │       └── 编辑图标按钮组件
        │       │               │       │           └── MouseRegion + GestureDetector
        │       │               │       │               └── Icon
        │       │               │       │                   ├── Icons.edit
        │       │               │       │                   ├── size: 14
        │       │               │       │                   └── color: Color(0xFF999999)
        │       │               │       │                   └── 点击事件 → debugPrint('编辑店铺名称')
        │       │               │       │
        │       │               │       ├── 时间信息文字组件
        │       │               │       │   └── Text
        │       │               │       │       ├── 文字内容："开通时间：2018-06-19 到期时间：2027-07-30"
        │       │               │       │       ├── fontSize: 14
        │       │               │       │       └── color: Color(0xFF666666)
        │       │               │       │
        │       │               │       ├── SizedBox(height: 8)
        │       │               │       │
        │       │               │       └── 当前版本行组件
        │       │               │           └── Row
        │       │               │               ├── 版本信息文字组件
        │       │               │               │   └── Text
        │       │               │               │       ├── 文字内容："当前版本:4.2.2 ("
        │       │               │               │       ├── fontSize: 14
        │       │               │               │       └── color: Color(0xFF666666)
        │       │               │               │
        │       │               │               ├── 最新版本链接组件
        │       │               │               │   └── MouseRegion + GestureDetector + Text
        │       │               │               │       ├── 文字内容："最新版本4.2.5"
        │       │               │               │       ├── fontSize: 14
        │       │               │               │       ├── color: Color(0xFF1890FF)
        │       │               │               │       ├── decoration: TextDecoration.underline
        │       │               │               │       └── 点击事件 → debugPrint('升级版本')
        │       │               │               │
        │       │               │               └── 闭合括号文字组件
        │       │               │                   └── Text
        │       │               │                       ├── 文字内容：")"
        │       │               │                       ├── fontSize: 14
        │       │               │                       └── color: Color(0xFF666666)
        │       │               │
        │       │               ├── SizedBox(width: 16)
        │       │               │
        │       │               └── 右侧：关注公众号 + 续费按钮（Column，上下对齐）
        │       │                   └── Column
        │       │                       ├── 关注公众号开关组件
        │       │                       │   └── Row
        │       │                       │       ├── 关注公众号文字组件
        │       │                       │       │   └── Text
        │       │                       │       │       ├── 文字内容："关注公众号"
        │       │                       │       │       ├── fontSize: 14
        │       │                       │       │       └── color: Color(0xFF666666)
        │       │                       │       │
        │       │                       │       ├── SizedBox(width: 12)
        │       │                       │       │
        │       │                       │       └── Switch（开关组件）
        │       │                       │           ├── value: _isFollowOfficialAccount
        │       │       │           ├── activeColor: Color(0xFF52C41A)（绿色）
        │       │                       │           └── onChanged → setState(() { _isFollowOfficialAccount = value; })
        │       │                       │
        │       │                       ├── Spacer（弹性间距）
        │       │                       │
        │       │                       └── 续费按钮组件
        │       │                           └── MouseRegion + GestureDetector + Container
        │       │                               ├── padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8)
        │       │                               ├── decoration: BoxDecoration
        │       │                               │   ├── color: Color(0xFF1890FF)
        │       │                               │   └── borderRadius: BorderRadius.circular(4)
        │       │                               └── Text
        │       │                                   ├── 文字内容："续费"
        │       │                                   ├── fontSize: 14
        │       │                                   ├── color: Colors.white
        │       │                                   └── fontWeight: FontWeight.w500
        │       │                                   └── 点击事件 → debugPrint('点击续费')
        │       │
        │       ├── SizedBox(width: 16)
        │       │
        │       └── 右侧：运营数据面板卡片
        │           └── Expanded(flex: 1) + _buildOperationDataPanel()
        │               └── Container
        │                   ├── padding: EdgeInsets.all(24)
        │                   ├── decoration: BoxDecoration（白色卡片背景）
        │                   │   ├── color: Colors.white
        │                   │   ├── borderRadius: BorderRadius.circular(8)
        │                   │   └── boxShadow（阴影效果）
        │                   └── Column
        │                       ├── 标题文字组件
        │                       │   └── Text
        │                       │       ├── 文字内容："小程序运营数据"
        │                       │       ├── fontSize: 18
        │                       │       ├── fontWeight: FontWeight.bold
        │                       │       └── color: Color(0xFF333333)
        │                       │
        │                       ├── SizedBox(height: 20)
        │                       │
        │                       └── 数据网格组件（2列x3行）
        │                           └── Column
        │                               ├── 第一行数据组件
        │                               │   └── Row
        │                               │       ├── Expanded + _buildDataItem(Icons.visibility, '今日浏览量', '1,234', Color(0xFF1890FF))
        │                               │       │   └── Container
        │                               │       │       ├── padding: EdgeInsets.all(16)
        │                               │       │       ├── decoration: BoxDecoration
        │                               │       │       │   ├── color: Color(0xFFF8F9FA)
        │                               │       │       │   └── borderRadius: BorderRadius.circular(8)
        │                               │       │       └── Row
        │                               │       │           ├── 图标容器组件
        │                               │       │           │   └── Container
        │                               │       │           │       ├── width: 40
        │                               │       │           │       ├── height: 40
        │                               │       │           │       ├── decoration: BoxDecoration
        │                               │       │           │       │   ├── color: Color(0xFF1890FF).withValues(alpha: 0.1)
        │                               │       │           │       │   └── borderRadius: BorderRadius.circular(8)
        │                               │       │           │       └── Icon(Icons.visibility, size: 20, color: Color(0xFF1890FF))
        │                               │       │           │
        │                               │       │           ├── SizedBox(width: 12)
        │                               │       │           │
        │                               │       │           └── Expanded + Column
        │                               │       │               ├── 标签文字组件
        │                               │       │               │   └── Text
        │                               │       │               │       ├── 文字内容："今日浏览量"
        │                               │       │               │       ├── fontSize: 12
        │                               │       │               │       └── color: Color(0xFF666666)
        │                               │       │               │
        │                               │       │               ├── SizedBox(height: 4)
        │                               │       │               │
        │                               │       │               └── 数值文字组件
        │                               │       │                   └── Text
        │                               │       │                       ├── 文字内容："1,234"
        │                               │       │                       ├── fontSize: 18
        │                               │       │                       ├── fontWeight: FontWeight.bold
        │                               │       │                       └── color: Color(0xFF333333)
        │                               │       │
        │                               │       ├── SizedBox(width: 16)
        │                               │       │
        │                               │       └── Expanded + _buildDataItem(Icons.trending_up, '总浏览量', '52,846', Color(0xFF52C41A))
        │                               │           └── Container（类似结构，绿色主题）
        │                               │
        │                               ├── SizedBox(height: 16)
        │                               │
        │                               ├── 第二行数据组件
        │                               │   └── Row
        │                               │       ├── Expanded + _buildDataItem(Icons.receipt_long, '今日订单', '28', Color(0xFFFA8C16))
        │                               │       │   └── Container（类似结构，橙色主题）
        │                               │       │
        │                               │       ├── SizedBox(width: 16)
        │                               │       │
        │                               │       └── Expanded + _buildDataItem(Icons.inventory, '待处理订单', '5', Color(0xFFFF4D4F))
        │                               │           └── Container（类似结构，红色主题）
        │                               │
        │                               ├── SizedBox(height: 16)
        │                               │
        │                               └── 第三行数据组件
        │                                   └── Row
        │                                       ├── Expanded + _buildDataItem(Icons.star_rate, '用户评价', '156', Color(0xFF722ED1))
        │                                       │   └── Container（类似结构，紫色主题）
        │                                       │
        │                                       ├── SizedBox(width: 16)
        │                                       │
        │                                       └── Expanded + _buildDataItem(Icons.thumb_up, '好评率', '98.5%', Color(0xFF13C2C2))
        │                                           └── Container（类似结构，青色主题）
        │
        ├── SizedBox(height: 24)
        │
        └── 常用工具网格区组件
            └── _buildCommonToolsGrid()
                └── Column
                    ├── 标题行组件
                    │   └── Row
                    │       ├── 标题文字组件
                    │       │   └── Text
                    │       │       ├── 文字内容："常用工具"
                    │       │       ├── fontSize: 18
                    │       │       ├── fontWeight: FontWeight.bold
                    │       │       └── color: Color(0xFF333333)
                    │       │
                    │       ├── Spacer（弹性间距）
                    │       │
                    │       └── 编辑按钮组件
                    │           └── MouseRegion + GestureDetector + Container
                    │               ├── padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6)
                    │               ├── decoration: BoxDecoration
                    │               │   ├── border: Border.all(color: Color(0xFFD9D9D9))
                    │               │   └── borderRadius: BorderRadius.circular(4)
                    │               └── Row
                    │                   ├── Icon(Icons.edit, size: 14, color: Color(0xFF666666))
                    │                   ├── SizedBox(width: 4)
                    │                   └── Text（文字内容："编辑", fontSize: 14, color: Color(0xFF666666)）
                    │                   └── 点击事件 → setState(() { _showToolEditor = true; }) → 显示工具编辑弹窗
                    │
                    ├── SizedBox(height: 16)
                    │
                    └── 工具网格组件（4列）
                        └── GridView.count
                            ├── crossAxisCount: 4（4列布局）
                            ├── shrinkWrap: true
                            ├── physics: NeverScrollableScrollPhysics()
                            ├── mainAxisSpacing: 16（子元素垂直间距）
                            ├── crossAxisSpacing: 16（子元素水平间距）
                            ├── childAspectRatio: 3.5（子元素宽高比）
                            └── children: _selectedTools.map((toolName)
                                └── _buildToolCard(toolInfo['icon'], toolName, toolInfo['parent'])
                                    └── MouseRegion + GestureDetector + Container
                                        ├── padding: EdgeInsets.all(20)
                                        ├── decoration: BoxDecoration
                                        │   ├── color: Color(0xFFF8F9FA)
                                        │   └── borderRadius: BorderRadius.circular(8)
                                        └── Row
                                            ├── Icon（工具图标）
                                            │   ├── size: 32
                                            │   └── color: Color(0xFF1890FF)
                                            │
                                            ├── SizedBox(width: 16)
                                            │
                                            └── Expanded + Text（工具名称）
                                                ├── fontSize: 16
                                                ├── color: Color(0xFF333333)
                                                ├── fontWeight: FontWeight.w500
                                                └── 点击事件 → _handleToolClick(toolName)
                                                    ↓
                                                    展开/选中对应的父菜单和子菜单

---

## 跳转链条1：工作台页面 → 小程序管理-开发设置

```
MerchantDashboard（工作台页面）
├── 左侧导航栏
│   └── 小程序管理菜单项组件
│       ├── 状态：默认收起
│       └── 点击菜单项组件
│           ↓
│           setState(() {
│             _expandedMenus.add('小程序管理');
│           })
│           ↓
│           展开：子菜单列表
│           └── 子菜单列表
│               └── 开发设置子菜单项组件
│                   └── 点击子菜单项组件
│                       ↓
│                       setState(() {
│                         _selectedMenuItem = '小程序管理';
│                         _selectedSubMenuItem = '开发设置';
│                         _expandedMenus.add('小程序管理');
│                       })
│                       ↓
│                       context.push('${AppRouter.merchantDashboard}?tab=开发设置')
│                       ↓
│                       更新URL参数：?tab=开发设置
│                       ↓
│                       _buildContentArea() 执行
│                       ↓
│                       switch(_selectedSubMenuItem) → case '开发设置'
│                       ↓
│                       显示：DevelopmentSettingsContent() 组件

DevelopmentSettingsContent（开发设置内容页）
└── 完整的开发设置配置界面
    ├── 小程序AppID配置区
    ├── 小程序AppSecret配置区
    ├── 服务器域名配置区
    ├── 业务域名配置区
    ├── 开发者设置区
    └── 保存按钮组件
```

---

## 跳转链条2：工作台页面 → 配置管理-支付配置

```
MerchantDashboard（工作台页面）
├── 左侧导航栏
│   └── 配置管理菜单项组件
│       ├── 状态：默认收起
│       └── 点击菜单项组件
│           ↓
│           setState(() {
│             _expandedMenus.add('配置管理');
│           })
│           ↓
│           展开：子菜单列表
│           └── 子菜单列表
│               └── 支付配置子菜单项组件
│                   └── 点击子菜单项组件
│                       ↓
│                       setState(() {
│                         _selectedMenuItem = '配置管理';
│                         _selectedSubMenuItem = '支付配置';
│                         _expandedMenus.add('配置管理');
│                       })
│                       ↓
│                       context.push('${AppRouter.merchantDashboard}?tab=支付配置')
│                       ↓
│                       更新URL参数：?tab=支付配置
│                       ↓
│                       _buildContentArea() 执行
│                       ↓
│                       switch(_selectedSubMenuItem) → case '支付配置'
│                       ↓
│                       显示：PaymentConfigContent() 组件

PaymentConfigContent（支付配置内容页）
└── 完整的支付配置界面
    ├── 微信支付配置区
    │   ├── 商户号输入框
    │   ├── API密钥输入框
    │   ├── 证书上传组件
    │   └── 微信支付状态开关
    │
    ├── 支付宝支付配置区
    │   ├── 应用ID输入框
    │   ├── 应用私钥输入框
    │   ├── 支付宝公钥输入框
    │   └── 支付宝支付状态开关
    │
    ├── 支付方式配置区
    │   ├── 课程支付开关
    │   ├── 商品支付开关
    │   ├── 租赁支付开关
    │   └── 会员卡支付开关
    │
    └── 保存配置按钮组件
        └── 点击按钮 → 保存支付配置 → 显示成功提示
```

---

## 跳转链条3：工作台页面 → 课程管理-课程列表

```
MerchantDashboard（工作台页面）
├── 左侧导航栏
│   └── 课程管理菜单项组件
│       ├── 状态：默认收起
│       └── 点击菜单项组件
│           ↓
│           setState(() {
│             _expandedMenus.add('课程管理');
│           })
│           ↓
│           展开：子菜单列表
│           └── 子菜单列表
│               └── 课程列表子菜单项组件
│                   └── 点击子菜单项组件
│                       ↓
│                       setState(() {
│                         _selectedMenuItem = '课程管理';
│                         _selectedSubMenuItem = '课程列表';
│                         _expandedMenus.add('课程管理');
│                       })
│                       ↓
│                       context.push('${AppRouter.merchantDashboard}?tab=课程列表')
│                       ↓
│                       更新URL参数：?tab=课程列表
│                       ↓
│                       _buildContentArea() 执行
│                       ↓
│                       switch(_selectedSubMenuItem) → case '课程列表'
│                       ↓
│                       显示：CourseListContent() 组件

CourseListContent（课程列表内容页）
└── 完整的课程管理界面
    ├── 顶部搜索和筛选区
    │   ├── 搜索框组件
    │   │   ├── 搜索输入框
    │   │   └── 搜索按钮
    │   │
    │   ├── 课程分类下拉选择框
    │   ├── 课程状态下拉选择框
    │   └── 新建课程按钮
    │       └── 点击按钮 → 跳转到课程创建页面
    │
    ├── 课程列表表格组件
    │   ├── 表头行
    │   │   ├── 复选框列
    │   │   ├── 课程名称列
    │   │   ├── 课程分类列
    │   │   ├── 价格列
    │   │   ├── 学员数列
    │   │   ├── 状态列
    │   │   ├── 创建时间列
    │   │   └── 操作列
    │   │
    │   └── 课程数据行列表
    │       └── 课程行组件
    │           ├── 课程缩略图组件
    │           ├── 课程基本信息组件
    │           ├── 课程价格显示组件
    │           ├── 课程学员数显示组件
    │           ├── 课程状态标签组件
    │           └── 操作按钮组
    │               ├── 编辑按钮 → 跳转到课程编辑页面
    │               ├── 下架按钮 → 显示确认对话框
    │               └── 删除按钮 → 显示确认对话框
    │
    └── 分页组件
        ├── 每页显示数量选择器
        ├── 页码列表
        └── 上一页/下一页按钮
```

---

## 跳转链条4：工作台页面 → 订单管理-课程订单

```
MerchantDashboard（工作台页面）
├── 左侧导航栏
│   └── 订单管理菜单项组件
│       ├── 状态：默认收起
│       └── 点击菜单项组件
│           ↓
│           setState(() {
│             _expandedMenus.add('订单管理');
│           })
│           ↓
│           展开：子菜单列表
│           └── 子菜单列表
│               └── 课程订单子菜单项组件
│                   └── 点击子菜单项组件
│                       ↓
│                       setState(() {
│                         _selectedMenuItem = '订单管理';
│                         _selectedSubMenuItem = '课程订单';
│                         _expandedMenus.add('订单管理');
│                       })
│                       ↓
│                       context.push('${AppRouter.merchantDashboard}?tab=课程订单')
│                       ↓
│                       更新URL参数：?tab=课程订单
│                       ↓
│                       _buildContentArea() 执行
│                       ↓
│                       switch(_selectedSubMenuItem) → case '课程订单'
│                       ↓
│                       显示：CourseOrderContent() 组件

CourseOrderContent（课程订单内容页）
└── 完整的课程订单管理界面
    ├── 顶部筛选区
    │   ├── 订单状态Tab栏
    │   │   ├── 全部订单Tab（默认选中）
    │   │   ├── 待付款Tab（显示未付款订单数量）
    │   │   ├── 已完成Tab
    │   │   └── 已取消Tab
    │   │
    │   ├── 搜索框组件
    │   │   ├── 订单号搜索输入框
    │   │   ├── 用户手机号搜索输入框
    │   │   └── 搜索按钮
    │   │
    │   └── 时间范围选择器
    │       ├── 开始日期选择器
    │       └── 结束日期选择器
    │
    ├── 订单列表表格组件
    │   ├── 表头行
    │   │   ├── 订单号列
    │   │   ├── 课程名称列
    │   │   ├── 用户信息列
    │   │   ├── 订单金额列
    │   │   ├── 支付方式列
    │   │   ├── 订单状态列
    │   │   ├── 下单时间列
    │   │   └── 操作列
    │   │
    │   └── 订单数据行列表
    │       └── 订单行组件
    │           ├── 订单号显示组件
    │           ├── 课程信息组件
    │           ├── 用户信息组件（头像+昵称+手机号）
    │           ├── 订单金额显示组件
    │           ├── 支付方式显示组件（微信/支付宝）
    │           ├── 订单状态标签组件
    │           │   ├── 待付款：橙色标签
    │           │   ├── 已完成：绿色标签
    │           │   ├── 已取消：灰色标签
    │           │   └── 退款中：红色标签
    │           └── 操作按钮组
    │               ├── 查看详情按钮 → 打开订单详情弹窗
    │               ├── 催付款按钮（待付款订单显示）
    │               └── 退款按钮（已完成订单显示）
    │
    ├── 订单详情弹窗组件
    │   └── Dialog
    │       ├── 订单基本信息区
    │       │   ├── 订单号
    │       │   ├── 下单时间
    │       │   ├── 支付时间
    │       │   └── 完成时间
    │       │
    │       ├── 课程信息区
    │       │   ├── 课程封面图
    │       │   ├── 课程名称
    │       │   ├── 课程分类
    │       │   └── 课程价格
    │       │
    │       ├── 用户信息区
    │       │   ├── 用户头像
    │       │   ├── 用户昵称
    │       │   ├── 用户手机号
    │       │   └── 用户ID
    │       │
    │       ├── 支付信息区
    │       │   ├── 订单总金额
    │       │   ├── 实付金额
    │       │   ├── 支付方式
    │       │   └── 交易号
    │       │
    │       └── 关闭按钮
    │
    └── 分页组件
        ├── 每页显示数量选择器
        ├── 页码列表
        └── 上一页/下一页按钮
```

---

## 跳转链条5：工作台页面 → 常用工具编辑

```
MerchantDashboard（工作台页面）
├── 管理中心主页内容
│   └── 常用工具网格区组件
│       └── 标题行组件
│           ├── 标题文字组件（显示"常用工具"）
│           ├── Spacer（弹性间距）
│           └── 编辑按钮组件
│               └── MouseRegion + GestureDetector + Container
│                   ├── Icon(Icons.edit)
│                   ├── Text（文字内容："编辑"）
│                   └── 点击事件
│                       ↓
│                       setState(() {
│                         _showToolEditor = true;
│                       })
│                       ↓
│                       Stack 检测到 _showToolEditor == true
│                       ↓
│                       显示：_buildToolEditorDialog()

_buildToolEditorDialog() → 工具编辑弹窗
└── Dialog
    └── Container（800x600）
        └── StatefulBuilder
            └── Column
                ├── 标题栏组件
                │   └── Row
                │       ├── 标题文字组件（显示"编辑常用工具"）
                │       ├── Spacer（弹性间距）
                │       └── 已选数量文字组件
                │           └── Text（显示"已选 X/16"）
                │               ├── 超过16个时：color: Color(0xFFFF4D4F)（红色）
                │               └── 未超过16个时：color: Color(0xFF666666)（灰色）
                │
                ├── Divider(height: 32)
                │
                ├── 工具列表区组件（可滚动）
                │   └── Expanded + SingleChildScrollView
                │       └── Column
                │           └── _buildToolGroups(tempSelectedTools, setDialogState)
                │               └── 按父菜单分组的工具列表
                │                   ├── 小程序管理分组
                │                   │   ├── 父菜单标题组件
                │                   │   │   └── Text（显示"小程序管理"）
                │                   │   └── Wrap（自动换行容器）
                │                   │       └── 子工具列表（6个工具）
                │                   │           ├── 开发设置工具项组件
                │                   │           │   └── MouseRegion + GestureDetector + Container
                │                   │           │       ├── padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12)
                │                   │           │       ├── decoration: BoxDecoration
                │                   │           │       │   ├── color: isSelected ? Color(0xFFE6F7FF) : Color(0xFFF8F9FA)
                │                   │           │       │   ├── border: Border.all(color: isSelected ? Color(0xFF1890FF) : Color(0xFFD9D9D9))
                │                   │           │       │   └── borderRadius: BorderRadius.circular(6)
                │                   │           │       └── Row
                │                   │           │           ├── 复选框图标组件
                │                   │           │           │   └── Icon
                │                   │           │           │       ├── isSelected ? Icons.check_box : Icons.check_box_outline_blank
                │                   │           │           │       ├── color: isSelected ? Color(0xFF1890FF) : Color(0xFF999999)
                │                   │           │           │
                │                   │           │           ├── SizedBox(width: 8)
                │                   │           │           │
                │                   │           │           ├── 工具图标组件
                │                   │           │           │   └── Icon(Icons.code, size: 16, color: Color(0xFF666666))
                │                   │           │           │
                │                   │           │           ├── SizedBox(width: 8)
                │                   │           │           │
                │                   │           │           └── 工具名称文字组件
                │                   │           │               └── Text
                │                   │           │                   ├── fontSize: 14
                │                   │           │                   ├── color: isSelected ? Color(0xFF1890FF) : Color(0xFF666666)
                │                   │           │                   └── fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal
                │                   │           │                   └── 点击事件
                │                   │           │                       ↓
                │                   │           │                       setDialogState(() {
                │                   │           │                         if (isSelected) {
                │                   │           │                           tempSelectedTools.remove(toolName);
                │                   │           │                         } else {
                │                   │           │                           if (tempSelectedTools.length < 16) {
                │                   │           │                             tempSelectedTools.add(toolName);
                │                   │           │                           }
                │                   │           │                         }
                │                   │           │                       })
                │                   │           │                       ↓
                │                   │           │                       更新临时选中工具集合
                │                   │           │                       ↓
                │                   │           │                       重新构建弹窗内容
                │                   │           │                       ↓
                │                   │           │                       更新"已选 X/16"显示
                │                   │           │                       ↓
                │                   │           │                       超过16个时：
                │                   │           │                         - 显示红色数量文字
                │                   │           │                         - 禁用"保存"按钮
                │                   │           │
                │                   │           ├── 审核管理工具项组件（类似结构）
                │                   │           ├── 菜单导航工具项组件（类似结构）
                │                   │           ├── 订阅消息工具项组件（类似结构）
                │                   │           ├── 跳转小程序工具项组件（类似结构）
                │                   │           └── 开发者模式工具项组件（类似结构）
                │                   │
                │                   ├── 配置管理分组（类似结构，6个工具）
                │                   ├── 模块管理分组（类似结构，5个工具）
                │                   ├── 页面管理分组（类似结构，3个工具）
                │                   ├── 课程管理分组（类似结构，5个工具）
                │                   ├── 订单管理分组（类似结构，3个工具）
                │                   ├── 商城管理分组（类似结构，5个工具）
                │                   ├── 用户管理分组（类似结构，5个工具）
                │                   ├── 客服管理分组（类似结构，4个工具）
                │                   ├── 业务管理分组（类似结构，2个工具）
                │                   ├── 会员卡管理分组（类似结构，3个工具）
                │                   └── 营销工具分组（类似结构，3个工具）
                │
                ├── Divider(height: 32)
                │
                └── 底部按钮区组件
                    └── Row
                        ├── Spacer（弹性间距）
                        │
                        ├── 取消按钮组件
                        │   └── TextButton
                        │       ├── Text（文字内容："取消"）
                        │       │   └── color: Color(0xFF666666)
                        │       └── onPressed
                        │           ↓
                        │           setState(() {
                        │             _showToolEditor = false;
                        │           })
                        │           ↓
                        │           关闭弹窗（不保存）
                        │
                        ├── SizedBox(width: 16)
                        │
                        └── 保存按钮组件
                            └── ElevatedButton
                                ├── Text（文字内容："保存"）
                                │   └── color: Colors.white
                                ├── style: ElevatedButton.styleFrom
                                │   ├── backgroundColor: Color(0xFF1890FF)
                                │   ├── disabledBackgroundColor: Color(0xFFD9D9D9)（禁用时的背景色）
                                │   └── padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12)
                                ├── onPressed: tempSelectedTools.length > 16 ? null : 保存逻辑
                                │   ↓
                                │   如果 tempSelectedTools.length > 16
                                │   ├── onPressed: null（按钮禁用）
                                │   └── 按钮背景色变为：Color(0xFFD9D9D9)
                                │
                                │   如果 tempSelectedTools.length <= 16
                                │   └── onPressed 执行保存逻辑
                                │       ↓
                                │       setState(() {
                                │         _selectedTools.clear();
                                │         _selectedTools.addAll(tempSelectedTools);
                                │         _showToolEditor = false;
                                │       })
                                │       ↓
                                │       清空原有的选中工具列表
                                │       ↓
                                │       添加临时选中的工具到正式列表
                                │       ↓
                                │       关闭弹窗
                                │       ↓
                                │       重新构建常用工具网格
                                │       ↓
                                │       显示更新后的常用工具
```

---

## 跳转链条6：工作台页面 → 消息通知弹窗

```
MerchantDashboard（工作台页面）
├── 顶部标题栏
│   └── 右侧功能按钮组
│       └── 消息通知按钮组件
│           └── _buildNotificationButton()
│               └── MouseRegion + GestureDetector + Container
│                   ├── key: _notificationButtonKey（用于定位弹窗位置）
│                   ├── Row
│                   │   ├── Text（文字内容："消息通知"）
│                   │   ├── SizedBox(width: 6)
│                   │   └── 未读数量徽章组件
│                   │       └── Container
│                   │           ├── padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2)
│                   │           ├── decoration: BoxDecoration
│                   │           │   ├── color: Color(0xFFFF4D4F)（红色）
│                   │           │   └── shape: BoxShape.circle
│                   │           └── Text（显示未读数量）
│                   │               ├── 内容：_messages.where((m) => !m['isRead']).length
│                   │               ├── fontSize: 10
│                   │               └── color: Colors.white
│                   │
│                   └── 点击事件
│                       ↓
│                       if (_showNotificationPopover) {
│                         _removeOverlay();
│                       } else {
│                         _showOverlay();
│                       }
│                       setState(() {
│                         _showNotificationPopover = !_showNotificationPopover;
│                       })
│                       ↓
│                       Stack 检测到 _showNotificationPopover == true
│                       ↓
│                       显示：_buildNotificationOverlay()

_buildNotificationOverlay() → 消息通知弹窗（Overlay实现）
├── 获取按钮位置
│   └── final buttonRenderBox = _notificationButtonKey.currentContext?.findRenderObject() as RenderBox?
│   ├── final buttonPosition = buttonRenderBox.localToGlobal(Offset.zero)
│   └── final buttonSize = buttonRenderBox.size
│
└── OverlayEntry
    └── GestureDetector（点击弹窗外部关闭）
        └── Container（全屏透明容器）
            └── Stack
                └── Positioned（绝对定位）
                    └── Container（弹窗主体，400x500）
                        ├── constraints: BoxConstraints(minWidth: 400, maxWidth: 400, maxHeight: 500)
                        ├── decoration: BoxDecoration
                        │   ├── color: Colors.white
                        │   ├── borderRadius: BorderRadius.circular(8)
                        │   └── boxShadow（阴影效果）
                        │       └── BoxShadow
                        │           ├── color: Colors.black.withValues(alpha: 0.15)
                        │           ├── blurRadius: 16
                        │           └── offset: Offset(0, 4)
                        └── Column
                            ├── 头部操作区组件
                            │   └── Container（height: 48）
                            │       ├── padding: EdgeInsets.symmetric(horizontal: 16)
                            │       ├── decoration: BoxDecoration（底部边框）
                            │       │   └── Border(bottom: BorderSide(color: Color(0xFFF0F0F0), width: 1))
                            │       └── Row
                            │           ├── 标题文字组件
                            │           │   └── Text
                            │           │       ├── 文字内容："消息通知"
                            │           │       ├── fontSize: 16
                            │           │       ├── fontWeight: FontWeight.bold
                            │           │       └── color: Color(0xFF333333)
                            │           │
                            │           ├── Spacer（弹性间距）
                            │           │
                            │           └── 全部已读按钮组件
                            │               └── MouseRegion + GestureDetector
                            │                   └── Text
                            │                       ├── 文字内容："全部已读"
                            │                       ├── fontSize: 14
                            │                       └── color: Color(0xFF1890FF)
                            │                       └── 点击事件
                            │                           ↓
                            │                           setState(() {
                            │                             for (var message in _messages) {
                            │                               message['isRead'] = true;
                            │                             }
                            │                           })
                            │                           ↓
                            │                           将所有消息标记为已读
                            │                           ↓
                            │                           重新构建消息列表
                            │                           ↓
                            │                           所有消息的状态标签变为"[已读]"
                            │                           ↓
                            │                           所有消息的标题和摘要颜色变为灰色
                            │                           ↓
                            │                           未读数量徽章更新为0
                            │
                            └── 消息列表区组件
                                └── ConstrainedBox(maxHeight: 400)
                                    └── SingleChildScrollView
                                        └── Column
                                            └── 消息卡片列表（_messages.map）
                                                └── _buildMessageItem(message, index)
                                                    └── Container
                                                        ├── padding: EdgeInsets.all(16)
                                                        ├── decoration: BoxDecoration（底部边框）
                                                        │   └── Border(bottom: BorderSide(color: Color(0xFFF5F5F5), width: 1))
                                                        └── Column
                                                            ├── 标题行组件
                                                            │   └── Row
                                                            │       ├── 消息标题文字组件
                                                            │       │   └── Text
                                                            │       │       ├── 文字内容：message['title']（如"订单付款通知"）
                                                            │       │       ├── fontSize: 16
                                                            │       │       ├── fontWeight: FontWeight.bold
                                                            │       │       └── color: isRead ? Color(0xFF666666) : Color(0xFF333333)
                                                            │       │
                                                            │       ├── Spacer（弹性间距）
                                                            │       │
                                                            │       └── 已读状态文字组件
                                                            │           └── Text
                                                            │               ├── 文字内容：isRead ? '[已读]' : '[未读]'
                                                            │               ├── fontSize: 14
                                                            │               └── color: isRead ? Color(0xFF999999) : Color(0xFF1890FF)
                                                            │
                                                            ├── SizedBox(height: 8)
                                                            │
                                                            ├── 摘要内容文字组件
                                                            │   └── Text
                                                            │       ├── 文字内容：message['content']（如"你管理的店铺唐极课得有新的订单已付款，订单金额20.00，订单号：8473202602269028254252"）
                                                            │       ├── fontSize: 14
                                                            │       ├── color: isRead ? Color(0xFF999999) : Color(0xFF666666)
                                                            │       ├── height: 1.6（行高）
                                                            │       ├── maxLines: 3（最多显示3行）
                                                            │       └── overflow: TextOverflow.ellipsis（超出显示省略号）
                                                            │
                                                            ├── SizedBox(height: 8)
                                                            │
                                                            └── 时间与操作行组件
                                                                └── Row
                                                                    ├── 时间文字组件
                                                                    │   └── Text
                                                                    │       ├── 文字内容：message['time']（如"2026-02-26 11:32:29"）
                                                                    │       ├── fontSize: 12
                                                                    │       └── color: Color(0xFF999999)
                                                                    │
                                                                    ├── Spacer（弹性间距）
                                                                    │
                                                                    └── 查看详情按钮组件
                                                                        └── MouseRegion + GestureDetector
                                                                            └── Text
                                                                                ├── 文字内容："查看详情"
                                                                                ├── fontSize: 14
                                                                                └── color: Color(0xFF1890FF)
                                                                                └── 点击事件
                                                                                    ↓
                                                                                    setState(() {
                                                                                      message['isRead'] = true;
                                                                                    })
                                                                                    ↓
                                                                                    标记该消息为已读
                                                                                    ↓
                                                                                    重新构建该消息卡片
                                                                                    ↓
                                                                                    状态标签变为"[已读]"
                                                                                    ↓
                                                                                    标题和摘要颜色变为灰色
                                                                                    ↓
                                                                                    未读数量徽章数量-1
```

---

## 跳转链条7：工作台页面 → 退出登录

```
MerchantDashboard（工作台页面）
├── 顶部标题栏
│   └── 右侧功能按钮组
│       └── 退出按钮组件
│           └── _buildHeaderButton('退出', isLogout: true)
│               └── MouseRegion + GestureDetector + Container
│                   └── Text（文字内容："退出"）
│                       └── 点击事件
│                           ↓
│                           _showLogoutDialog()
│                           ↓
│                           showDialog（显示退出登录确认对话框）

_showLogoutDialog() → 退出登录确认对话框
└── showDialog
    └── AlertDialog
        ├── 标题组件
        │   └── Text
        │       └── 文字内容："退出登录"
        │
        ├── 内容组件
        │   └── Text
        │       └── 文字内容："确定要退出当前账号吗？"
        │
        └── 操作按钮区
            └── Row
                ├── 取消按钮组件
                │   └── TextButton
                │       ├── Text（文字内容："取消"）
                │       └── onPressed
                │           ↓
                │           Navigator.of(context).pop()
                │           ↓
                │           关闭对话框（不退出）
                │
                └── 确定按钮组件
                    └── TextButton
                        ├── Text（文字内容："确定"）
                        │   └── style: TextStyle(color: Color(0xFFFF4D4F))（红色）
                        └── onPressed
                            ↓
                            Navigator.of(context).pop()（关闭对话框）
                            ↓
                            authState.logout()（执行退出登录逻辑）
                            ↓
                            清除用户登录状态
                            ↓
                            清除用户认证信息
                            ↓
                            context.go(AppRouter.home)（跳转到首页）
                            ↓
                            返回到官网首页
```

---

## 跳转链条8：工作台页面 → 返回逻辑

```
MerchantDashboard（工作台页面）
├── initState() 初始化
│   └── WidgetsBinding.instance.addPostFrameCallback((_) {
│       _updateSelectedTabFromRoute();
│       _savePreviousRoute();
│     })
│     ↓
│     _savePreviousRoute() 执行
│     ↓
│     final state = GoRouterState.of(context)
│     ↓
│     final fromParam = state.uri.queryParameters['from']
│     ↓
│     if (fromParam != null) {
│       _previousRoute = '/$fromParam';
│       debugPrint('========== 工作台来源页面（从参数）: $_previousRoute ==========');
│     }
│     ↓
│     保存来源页面到 _previousRoute 变量
│     ↓
│     例如：从工作台页面进入，_previousRoute = '/workbench'
│
└── PopScope（返回拦截组件）
    ├── canPop: false（拦截所有返回事件）
    └── onPopInvokedWithResult
        ↓
        _handleBackPressed() 执行
        ↓
        _isFromAllowedPages() 判断
        ↓
        判断 _previousRoute 是否在允许的页面列表中
        ↓
        允许的页面列表：
        ├── AppRouter.home（首页）
        ├── AppRouter.purchase（购买页面）
        ├── AppRouter.lease（租赁页面）
        ├── AppRouter.partnership（合作页面）
        └── AppRouter.customDev（定制开发页面）
        ↓
        if (_isFromAllowedPages()) {
          ├── debugPrint('========== 从允许的页面进入，正常返回 ==========');
          ├── Navigator.of(context).pop();
          └── 执行正常返回逻辑
              ↓
              返回到来源页面
        } else {
          ├── debugPrint('========== 返回到"我的"页面 ==========');
          ├── context.go(AppRouter.profile);
          └── 返回到"我的"页面
              ↓
              跳转到个人中心页面
        }

示例场景1：从工作台页面进入工作台后台
├── 用户在"我的"页面
├── 点击"工作台"按钮
├── AppRouter.goToMerchantDashboard(context, from: AppRouter.workbench)
├── URL变为：/workbench/dashboard?from=workbench
├── _previousRoute = '/workbench'
├── 用户点击返回按钮
├── _isFromAllowedPages() → false（/workbench 不在允许列表中）
├── context.go(AppRouter.profile)
└── 返回到"我的"页面

示例场景2：从首页进入工作台后台
├── 用户在首页
├── 点击某个入口进入工作台后台
├── AppRouter.goToMerchantDashboard(context, from: AppRouter.home)
├── URL变为：/workbench/dashboard?from=home
├── _previousRoute = '/home'
├── 用户点击返回按钮
├── _isFromAllowedPages() → true（/home 在允许列表中）
├── Navigator.of(context).pop()
└── 正常返回到首页

示例场景3：直接访问工作台后台（无来源页面）
├── 用户直接访问：/workbench/dashboard
├── fromParam = null
├── _previousRoute = null
├── 用户点击返回按钮
├── _isFromAllowedPages() → false（_previousRoute == null）
├── context.go(AppRouter.profile)
└── 返回到"我的"页面
```

---

## 页面功能说明

### 1. 管理中心主页功能

#### 1.1 基本信息区功能
- **店铺名称显示**：显示当前登录用户管理的店铺名称
- **编辑店铺名称**：点击编辑图标，可以修改店铺名称
- **开通和到期时间显示**：显示店铺服务的开通时间和到期时间
- **版本信息显示**：显示当前使用的系统版本号
- **升级版本链接**：点击"最新版本X.X.X"链接，可以查看新版本信息并升级
- **关注公众号开关**：控制是否关注官方公众号的状态
- **续费按钮**：点击续费按钮，跳转到续费页面进行服务续费

#### 1.2 运营数据面板功能
- **今日浏览量显示**：显示小程序当天的浏览次数
- **总浏览量显示**：显示小程序累计的总浏览次数
- **今日订单显示**：显示当天的订单数量
- **待处理订单显示**：显示待处理的订单数量
- **用户评价显示**：显示收到的用户评价数量
- **好评率显示**：显示好评率百分比

#### 1.3 常用工具区功能
- **常用工具网格显示**：以4列网格的形式显示常用工具
- **工具卡片**：每个工具显示图标和名称
- **工具点击跳转**：点击工具卡片，自动展开对应的父菜单并跳转到对应的功能页面
- **编辑常用工具**：点击编辑按钮，打开工具编辑弹窗
  - 显示所有可用的工具（按父菜单分组）
  - 支持多选工具（最多16个）
  - 实时显示已选数量
  - 保存后更新常用工具网格

### 2. 左侧导航栏功能

#### 2.1 父菜单功能
- **展开/收起子菜单**：点击有子菜单的父菜单，展开或收起子菜单列表
- **菜单高亮显示**：展开或选中的菜单显示深灰色背景和高亮文字
- **管理中心特殊处理**：点击"管理中心"菜单，清空子菜单选中状态，返回管理中心主页

#### 2.2 子菜单功能
- **子菜单选择**：点击子菜单，设置该子菜单为选中状态
- **子菜单高亮显示**：选中的子菜单显示白色文字和加粗字体
- **URL参数同步**：点击子菜单时，更新URL的tab参数
- **内容区切换**：根据选中的子菜单，动态切换主内容区显示的内容

### 3. 顶部标题栏功能

#### 3.1 Logo和系统名称功能
- **返回管理中心**：点击Logo或系统名称，清空子菜单选中状态，返回管理中心主页

#### 3.2 功能按钮组功能
- **预览按钮**：预览小程序的效果
- **提交按钮**：提交当前的配置更改
- **消息通知按钮**：点击打开/关闭消息通知弹窗
  - 显示未读消息数量徽章
  - 弹窗显示消息列表
  - 支持全部已读操作
  - 点击单条消息可标记为已读
- **店铺设置按钮**：点击跳转到店铺设置页面（Navigator.push）
- **管理中心按钮**：点击清空子菜单选中状态，返回管理中心主页
- **用户头像按钮**：点击跳转到个人中心页面
- **退出按钮**：点击显示退出登录确认对话框
  - 点击取消：关闭对话框
  - 点击确定：执行退出登录逻辑，跳转到首页
- **更多操作按钮**：显示更多操作选项（暂未实现具体功能）

### 4. 消息通知弹窗功能

#### 4.1 弹窗显示功能
- **Overlay实现**：使用Flutter的Overlay机制实现弹窗
- **按钮定位**：根据消息通知按钮的位置，动态计算弹窗显示位置
- **点击外部关闭**：点击弹窗外部区域，关闭弹窗
- **阻止冒泡**：点击弹窗内容区域，不关闭弹窗

#### 4.2 消息列表功能
- **消息卡片显示**：每个消息显示标题、摘要、时间和状态
- **已读/未读状态**：已读消息显示灰色，未读消息显示蓝色
- **全部已读按钮**：点击将所有消息标记为已读
- **查看详情按钮**：点击单条消息的"查看详情"，标记该消息为已读
- **未读数量徽章**：实时显示未读消息数量

### 5. 工具编辑弹窗功能

#### 5.1 弹窗显示功能
- **Dialog实现**：使用Flutter的Dialog实现弹窗
- **固定尺寸**：弹窗固定大小为800x600
- **StatefulBuilder**：使用StatefulBuilder管理弹窗内部状态

#### 5.2 工具列表功能
- **按父菜单分组**：工具按照左侧导航栏的父菜单进行分组显示
- **工具卡片显示**：每个工具显示复选框、图标和名称
- **选中状态显示**：选中的工具显示蓝色背景和实心复选框
- **多选限制**：最多选择16个工具
- **实时计数**：实时显示已选工具数量（X/16）
- **超过限制提示**：超过16个时，数量文字显示红色，保存按钮禁用

#### 5.3 保存和取消功能
- **取消按钮**：点击关闭弹窗，不保存更改
- **保存按钮**：点击保存更改
  - 清空原有的选中工具列表
  - 添加临时选中的工具到正式列表
  - 关闭弹窗
  - 重新构建常用工具网格

### 6. 返回逻辑功能

#### 6.1 来源页面追踪
- **URL参数传递**：通过from参数传递来源页面信息
- **保存来源页面**：在initState中保存来源页面到_previousRoute变量
- **判断来源页面**：判断来源页面是否在允许的页面列表中

#### 6.2 智能返回逻辑
- **允许页面列表**：首页、购买、租赁、合作、定制开发
- **从允许页面进入**：执行正常返回（Navigator.pop）
- **从其他页面进入**：返回到"我的"页面（context.go(AppRouter.profile)）
- **无来源页面**：返回到"我的"页面

#### 6.3 返回拦截
- **PopScope拦截**：使用PopScope拦截所有返回事件
- **canPop设置为false**：阻止默认的返回行为
- **onPopInvokedWithResult**：在返回事件触发时执行自定义返回逻辑

### 7. 子页面内容区功能

#### 7.1 内容切换逻辑
- **判断子菜单选中状态**：根据_selectedSubMenuItem判断是否选中子菜单
- **未选中子菜单**：显示管理中心主页（_buildMainContent()）
- **选中子菜单**：使用switch语句根据子菜单名称显示对应的内容组件

#### 7.2 已实现的内容页面
- **开发设置**：DevelopmentSettingsContent
- **审核管理**：AuditManagementContent
- **菜单导航**：MenuNavigationContent
- **支付配置**：PaymentConfigContent
- **音视频存储**：MediaListContent
- **文章管理**：ArticleManagementPage(showFullNavigation: false)
- **课程分类**：CourseCategoryManagementContent
- **讲师管理**：InstructorManagementContent
- **课程问答管理**：CourseQAManagementContent
- **课程列表**：CourseListContent
- **课程订单**：CourseOrderContent
- **货架管理**：ProductCategoryManagementContent
- **我的仓库**：MyWarehouseContent
- **商品评价**：ProductReviewsContent
- **运费模板**：FreightTemplateContent
- **订单设置**：OrderSettingsContent
- **售后处理**：AfterSaleContent
- **导航页面管理**：NavigationPageManagementContent
- **个人中心管理**：PageEditor(initialPageType: '个人中心')

#### 7.3 未实现的内容页面
- **显示"即将推出"提示**：_buildComingSoonContent(featureName)
- **提示信息**：显示"XXX功能即将推出"和"该功能正在开发中，敬请期待"
- **图标提示**：显示信息图标（Icons.info_outline）

---

## 总结

工作台页面（MerchantDashboard）是一个功能完整的商户管理后台界面，采用三栏布局（左侧导航栏 + 顶部标题栏 + 主内容区），提供以下核心功能：

1. **左侧导航栏**：15个父菜单，支持展开/收起子菜单，包含小程序管理、配置管理、模块管理、页面管理、课程管理、订单管理、商城管理、用户管理、客服管理、业务管理、会员卡管理、营销工具等功能模块

2. **管理中心主页**：显示基本信息、运营数据面板（6个数据指标）和常用工具网格（最多16个工具，可编辑）

3. **顶部标题栏**：Logo、系统名称、预览、提交、消息通知（带弹窗）、店铺设置、管理中心、用户头像、退出登录、更多操作等按钮

4. **智能返回逻辑**：根据来源页面智能决定返回到"我的"页面还是正常返回

5. **消息通知弹窗**：显示消息列表，支持全部已读和单条消息已读操作

6. **工具编辑弹窗**：按父菜单分组显示所有工具，支持多选（最多16个），实时显示已选数量

7. **子页面内容区**：根据选中的子菜单动态显示对应的内容组件，未实现的页面显示"即将推出"提示

---

> **文档版本**: v1.0
> **最后更新**: 2026-03-16
> **文件路径**: /Volumes/DudaDate/微信小程序开发/flutter官网开发/official_website/lib/presentation/pages/workbench/merchant_dashboard.dart
> **页面路由**: /workbench/dashboard
> **依赖组件**: DevelopmentSettingsContent, AuditManagementContent, MenuNavigationContent, PaymentConfigContent, MediaListContent, ArticleManagementPage, CourseCategoryManagementContent, InstructorManagementContent, CourseQAManagementContent, CourseListContent, CourseOrderContent, ProductCategoryManagementContent, MyWarehouseContent, ProductReviewsContent, FreightTemplateContent, OrderSettingsContent, AfterSaleContent, NavigationPageManagementContent, PageEditor
