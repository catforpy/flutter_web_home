# 腾讯云 IM 集成文档

## 📖 概述

本项目已成功集成腾讯云 IM SDK，支持多端互通：
- ✅ Flutter Web（本项目）
- ✅ Flutter App（iOS/Android）
- ✅ UniApp App
- ✅ 微信小程序
- ✅ 支付宝小程序

---

## 🚀 快速开始

### 1. 获取 SDKAppID

1. 登录 [腾讯云 IM 控制台](https://console.cloud.tencent.com/im)
2. 创建应用或选择已有应用
3. 记录应用的 **SDKAppID**

### 2. 配置 SDKAppID

编辑 `lib/core/im/im_config.dart`：

```dart
class IMConfig {
  // 替换为你的 SDKAppID
  static const int sdkAppId = 1400xxxxxx; // TODO: 替换为实际的 SDKAppID
  // ...
}
```

### 3. 获取 UserSig（重要）

⚠️ **安全警告**：UserSig 必须在服务端生成，不能在前端生成！

#### 开发环境（测试用）

1. 在腾讯云 IM 控制台
2. 选择应用 -> 开发辅助工具 -> UserSig 生成&校验
3. 输入 userId（如 `user_001`），生成测试用 userSig
4. 将生成的 userSig 配置到 `lib/core/im/services/im_auth_service.dart`：

```dart
static String? getMockUserSig(String userId) {
  final Map<String, String> mockUserSigs = {
    'user_001': 'your_generated_userSig_here', // 粘贴生成的 userSig
    'user_002': 'your_generated_userSig_here',
  };
  return mockUserSigs[userId];
}
```

#### 生产环境

需要实现后端 API 来生成 userSig。参考文档：
- [服务端生成 UserSig](https://cloud.tencent.com/document/product/269/32688)

### 4. 运行项目

```bash
cd official_website

# 安装依赖
flutter pub get

# 运行 Web 版本
flutter run -d chrome --web-port 8080
```

### 5. 测试 IM 功能

1. 打开浏览器访问 `http://localhost:8080`
2. 在导航中添加或访问 `/conversations` 路由
3. 点击"登录 IM"按钮（使用测试账号 `user_001`）
4. 开始聊天！

---

## 📁 项目结构

```
lib/
├── core/
│   └── im/                              # IM 核心模块
│       ├── im_config.dart               # IM 配置
│       ├── tencent_im_manager.dart       # IM 管理器（单例）
│       └── services/
│           └── im_auth_service.dart     # IM 认证服务
│
├── application/
│   └── blocs/im/                        # IM 状态管理
│       ├── im_connection_bloc.dart      # 连接状态 BLoC
│       ├── conversation_bloc.dart       # 会话列表 BLoC
│       └── message_bloc.dart            # 消息 BLoC
│
└── presentation/
    ├── pages/chat/                       # 聊天页面
    │   ├── conversations_page.dart      # 会话列表页
    │   └── chat_page.dart               # 聊天详情页
    └── routes/
        └── app_router.dart              # 路由配置（已添加聊天路由）
```

---

## 💡 使用方法

### 1. 初始化 IM SDK（已在 main.dart 中自动完成）

```dart
// 在 main.dart 中
BlocProvider(
  create: (context) => IMConnectionBloc()
    ..add(IMInitializeEvent()),  // 自动初始化
)
```

### 2. 登录 IM

```dart
context.read<IMConnectionBloc>().add(
  IMLoginEvent('user_001'),
);
```

### 3. 查看会话列表

```dart
// 导航到会话列表页面
AppRouter.goToConversations(context);

// 或直接使用路由
context.go('/conversations');
```

### 4. 打开聊天页面

```dart
AppRouter.goToChat(
  context,
  conversationID: conversationID,
  userID: userID,
  type: type,
);
```

### 5. 发送消息（自动处理）

在聊天页面输入消息后点击发送按钮即可。

---

## 🔌 API 说明

### TencentIMManager（IM 管理器）

单例类，提供所有 IM 功能：

```dart
final imManager = TencentIMManager();

// 初始化
await imManager.init(sdkAppId: 1400xxxxxx);

// 登录
await imManager.login(userId: 'user_001', userSig: '...');

// 发送文本消息
await imManager.sendTextMessage(
  text: 'Hello',
  receiver: 'user_002',
);

// 发送图片消息
await imManager.sendImageMessage(
  imagePath: '/path/to/image.jpg',
  receiver: 'user_002',
);

// 获取会话列表
final conversations = await imManager.getConversationList();

// 获取历史消息
final messages = await imManager.getHistoryMessage(userId: 'user_002');

// 标记会话已读
await imManager.markConversationAsRead(conversationID: '...');

// 设置用户资料
await imManager.setSelfInfo(
  nickname: '张三',
  faceUrl: 'https://example.com/avatar.jpg',
);

// 登出
await imManager.logout();
```

### BLoC 状态管理

#### IMConnectionBloc（连接状态）

```dart
// 监听连接状态
BlocBuilder<IMConnectionBloc, IMConnectionState>(
  builder: (context, state) {
    if (state.status == IMConnectionStateStatus.connected) {
      return Text('已登录: ${state.currentUserId}');
    }
    return Text('未连接');
  },
);
```

#### ConversationBloc（会话列表）

```dart
// 加载会话列表
context.read<ConversationBloc>().add(LoadConversationsEvent());

// 监听会话变化
BlocBuilder<ConversationBloc, ConversationState>(
  builder: (context, state) {
    return ListView.builder(
      itemCount: state.conversations.length,
      itemBuilder: (context, index) {
        final conversation = state.conversations[index];
        return ConversationTile(conversation: conversation);
      },
    );
  },
);
```

#### MessageBloc（消息列表）

```dart
// 加载历史消息
context.read<MessageBloc>().add(
  LoadHistoryMessagesEvent('user_002'),
);

// 发送消息
context.read<MessageBloc>().add(
  SendTextMessageEvent('Hello', 'user_002'),
);

// 监听新消息
BlocBuilder<MessageBloc, MessageState>(
  builder: (context, state) {
    return ListView.builder(
      itemCount: state.messages.length,
      itemBuilder: (context, index) {
        final message = state.messages[index];
        return MessageBubble(message: message);
      },
    );
  },
);
```

---

## 🌐 多端互通实现

### 关键点

1. **使用相同的 SDKAppID**
   - 所有端使用相同的 SDKAppID
   - 在腾讯云 IM 控制台创建应用后获取

2. **使用相同的 userID**
   - 同一个用户在不同端使用相同的 userID
   - 建议使用业务系统的用户 ID

3. **同步用户信息**
   - 调用 `setSelfInfo` 设置用户昵称和头像
   - 确保各端显示一致

### 示例：Flutter Web 与 UniApp 互通

**Flutter Web 端**：
```dart
await imManager.login(userId: 'user_123', userSig: '...');
await imManager.sendTextMessage(
  text: 'Hello from Flutter Web',
  receiver: 'user_456',
);
```

**UniApp 端**：
```javascript
// UniApp 使用 JS SDK
tim.login({userID: 'user_456', userSig: '...'});

// 接收来自 Flutter Web 的消息
tim.on(TIM.EVENT.MESSAGE_RECEIVED, (event) => {
  const message = event.data[0];
  console.log('收到消息:', message.payload.text);
});
```

---

## 🔧 配置选项

### IMConfig（im_config.dart）

```dart
class IMConfig {
  // SDKAppID - 必须配置
  static const int sdkAppId = 0; // TODO: 替换为实际的 SDKAppID

  // 日志级别
  static const String logLevel = 'normal'; // 'debug', 'normal', 'release'

  // API 基础地址（用于获取 userSig）
  static const String apiBaseUrl = 'https://your-api.com/api';

  // 获取 UserSig 的 API 端点
  static const String getUserSigEndpoint = '/im/getUserSig';

  // 最大消息历史数量
  static const int maxMessageCount = 100;

  // 会话列表每页数量
  static const int conversationPageSize = 50;
}
```

---

## 📝 路由配置

新增路由：

```dart
// 会话列表
AppRouter.goToConversations(context);

// 聊天页面
AppRouter.goToChat(
  context,
  conversationID: '...',
  userID: '...',
  type: 1,
);
```

---

## ⚠️ 注意事项

### 安全相关

1. **UserSig 必须在服务端生成**
   - 前端不能直接使用密钥生成 userSig
   - 否则会泄露密钥，造成安全风险

2. **生产环境配置**
   - 使用环境变量管理敏感信息
   - 不要将密钥提交到代码仓库

### Web 端限制

1. **不支持本地存储大量消息**
   - 依赖 IndexedDB
   - 建议只加载最近的消息

2. **WebSocket 连接**
   - 页面关闭后连接断开
   - 重新打开页面需要重新登录

3. **部分高级功能不支持**
   - 参考 [Web SDK 功能说明](https://cloud.tencent.com/document/product/269/75286)

### 性能优化

1. **按需加载消息**
   ```dart
   // 首次加载
   getHistoryMessage(userId: 'user_001', count: 20);

   // 加载更多
   getHistoryMessage(
     userId: 'user_001',
     lastMsgId: lastMessage.msgID,
     count: 20,
   );
   ```

2. **消息分页**
   - 使用 `count` 和 `lastMsgId` 参数
   - 避免一次性加载大量消息

---

## 🐛 常见问题

### 1. 初始化失败

**问题**：IM SDK 初始化失败

**解决**：
- 检查 SDKAppID 是否正确
- 检查网络连接
- 查看控制台日志

### 2. 登录失败

**问题**：无法登录 IM

**解决**：
- 检查 userSig 是否正确
- 确保 userSig 未过期
- 检查 userId 格式

### 3. 收不到消息

**问题**：无法接收新消息

**解决**：
- 确保已登录
- 检查消息监听器是否设置
- 确认发送方的 userID 正确

### 4. Web 端无法加载

**问题**：Web 端报错找不到 TIM SDK

**解决**：
- 确保 JS 依赖已安装：`cd web && npm install`
- 检查 index.html 中的 script 引入
- 清理缓存：`flutter clean && flutter pub get`

---

## 📚 参考文档

- [腾讯云 IM Flutter SDK 文档](https://cloud.tencent.com/document/product/269/75286)
- [腾讯云 IM Web SDK 文档](https://cloud.tencent.com/document/product/269/68447)
- [UserSig 生成与校验](https://cloud.tencent.com/document/product/269/32688)
- [多端互通最佳实践](https://cloud.tencent.com/document/product/269/100621)

---

## 🎯 下一步计划

- [ ] 实现图片选择和发送
- [ ] 实现语音消息
- [ ] 实现群聊功能
- [ ] 实现视频通话
- [ ] 实现 Push 推送
- [ ] 实现消息撤回
- [ ] 实现消息已读回执

---

**最后更新**: 2026-03-05
**文档版本**: v1.0.0
