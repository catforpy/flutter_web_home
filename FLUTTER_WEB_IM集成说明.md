# Flutter Web 腾讯云 IM 集成说明

## ⚠️ 重要提示

**腾讯云 IM 的 Flutter SDK (`tencent_cloud_chat_sdk`) 目前不支持 Web 平台！**

该 SDK 仅支持：
- ✅ iOS
- ✅ Android
- ✅ macOS
- ✅ Windows
- ❌ **Web（不支持）**

---

## 🌐 Flutter Web 集成方案

对于 **Flutter Web** 项目，你有以下几种选择：

### 方案一：使用 Web JS SDK（推荐）

直接在 Flutter Web 中使用腾讯云 IM 的 **JavaScript SDK**。

#### 优点
- ✅ 官方支持
- ✅ 功能完整
- ✅ 稳定可靠

#### 缺点
- ⚠️ 需要使用 `dart:js_interop` 或 `package:js` 进行桥接
- ⚠️ 需要手动编写类型定义

#### 实现步骤

1. **安装 JS SDK**（已完成）
   ```bash
   cd web
   npm install @tencentcloud/chat
   ```

2. **在 `web/index.html` 中引入**（已完成）
   ```html
   <script src="node_modules/@tencentcloud/chat/index.js"></script>
   ```

3. **在 Dart 中调用 JS SDK**
   ```dart
   import 'dart:js_interop';

   @JS('TencentCloudChat')
   external class TencentCloudChat {
     external static JSObject create(JSObject options);
   }

   // 使用
   final chat = TencentCloudChat.create(JSObject.fromMap({
     'SDKAppID': 1400xxxxxx,
   }));
   ```

### 方案二：等待官方支持

腾讯云 IM 团队可能会在未来版本中添加 Web 平台支持。

关注官方仓库：
- [tencent-cloud-chat-sdk-flutter](https://github.com/TencentCloud/TIMSDK/tree/main/Flutter/Dart/tencent_cloud_chat_sdk)

### 方案三：使用其他 IM 服务

如果需要同时支持 Flutter 原生和 Web，可以考虑支持全平台的 IM 服务：

#### 环信（Easemob）
- ✅ 支持 Flutter Web
- ✅ 文档完善
- 官网：https://www.easemob.com/

#### 融云（RongCloud）
- ⚠️ Flutter SDK 从 5.6.12 开始不再支持 Web
- 需要单独集成 Web SDK

#### 爱秒签（IM SDK）
- 支持多端
- 官网：https://www.mysubmail.com/

#### Agora Chat
- ✅ 支持 Flutter Web
- 官网：https://www.agora.io/

#### 自建 IM 方案
- 使用 WebSocket + Firebase/Supabase
- 使用 Socket.io + Node.js
- 使用 GraphQL 订阅

---

## 📱 如果只需要原生平台支持

如果你**只需要支持 iOS 和 Android**（不需要 Web），那么可以直接使用腾讯云 IM Flutter SDK：

### 1. 添加依赖
```yaml
dependencies:
  tencent_cloud_chat_sdk: ^8.7.7201
```

### 2. 仅在原生平台运行
```dart
import 'package:flutter/foundation.dart' show kIsWeb;

void initIM() async {
  if (kIsWeb) {
    print('IM SDK 不支持 Web 平台');
    return;
  }

  // 原生平台初始化代码
  await TencentImSDKPlugin.v2TIMManager.initSDK(...);
}
```

### 3. 条件导入
```dart
import 'im_manager_stub.dart'
    if (dart.library.io) 'im_manager_native.dart'
    if (dart.library.html) 'im_manager_web.dart';
```

---

## 🚀 推荐方案总结

### 对于当前项目（Flutter Web 官网）

**建议：使用 Web JS SDK + JS Interop**

1. 保留已安装的 `@tencentcloud/chat` npm 包
2. 使用 `dart:js_interop` 创建 Dart 到 JS 的桥接
3. 编写类型安全的 Dart 包装器

### 示例代码

```dart
// lib/core/im/web_im_manager.dart
import 'dart:js_interop';

@JS('TencentCloudChat')
external class TencentCloudChat {
  external static JSObject create(JSObject options);
}

@JS()
@anonymous
@staticInterop
class TIMConfig {
  external factory TIMConfig({
    required int SDKAppID,
  });
}

class WebIMManager {
  late JSObject _tim;

  Future<void> init(int sdkAppId) async {
    _tim = TencentCloudChat.create(TIMConfig(SDKAppID: sdkAppId));
  }

  Future<void> login(String userId, String userSig) async {
    // 调用 JS SDK 的 login 方法
  }

  // ... 其他方法
}
```

---

## 📚 参考资料

### 腾讯云 IM Web SDK
- [Web SDK 文档](https://cloud.tencent.com/document/product/269/68447)
- [Web SDK API](https://web.sdk.qcloud.com/im/doc/v3/zh-cn/)
- [GitHub 仓库](https://github.com/TencentCloud/TIMSDK)

### Dart JS Interop
- [dart:js_interop 文档](https://dart.dev/interop/js-interop)
- [Flutter Web 调用 JS](https://docs.flutter.dev/platform-integration/web#calling-javascript-from-dart)

---

## 🤔 如何选择？

### 选择腾讯云 IM 的场景
- ✅ 主要支持原生平台（iOS/Android）
- ✅ Web 端可以接受使用 JS SDK 的方案
- ✅ 需要丰富的 IM 功能

### 选择其他 IM 服务的场景
- ✅ 需要一套代码同时支持原生和 Web
- ✅ 不想维护两套 SDK 集成代码
- ✅ 需要更好的 Flutter Web 支持

---

## 📞 需要帮助？

如果你想继续集成腾讯云 IM 到这个项目，请告诉我你的需求：

1. **选项 A**：只支持原生平台（iOS/Android），忽略 Web
2. **选项 B**：使用 Web JS SDK + JS Interop（需要额外开发工作）
3. **选项 C**：切换到其他支持全平台的 IM 服务
4. **选项 D**：暂时不集成 IM，先完成其他功能

我可以根据你的选择提供详细的实现方案。

---

**最后更新**: 2026-03-05
