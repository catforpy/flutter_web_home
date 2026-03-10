# 腾讯云 IM 多端互通完整方案

## 🎯 目标

实现以下平台之间的即时通讯互通：
- ✅ **Flutter Web** - 使用腾讯 IM Web JS SDK
- ✅ **UniApp** - 使用腾讯 IM JS SDK
- ✅ **微信小程序** - 使用腾讯 IM JS SDK
- ✅ **支付宝小程序** - 使用腾讯 IM JS SDK

---

## 📐 架构设计

```
┌─────────────────────────────────────────────────────────────────┐
│                      你的后端服务器                              │
│                  (Node.js / Java / PHP 等)                     │
│                                                                │
│  功能:                                                          │
│  1. 用户登录认证                                                │
│  2. 生成 UserSig（使用腾讯云 IM 密钥）                           │
│  3. 业务数据处理                                                │
└────────────────────────┬────────────────────────────────────────┘
                         │
                         │ API 请求
                         │ 获取 UserSig
                         ↓
┌─────────────────────────────────────────────────────────────────┐
│                  腾讯云 IM 服务器 (中间件)                       │
│                    同一个 SDKAppID                              │
│                                                                │
│  功能:                                                          │
│  1. 消息存储和转发                                              │
│  2. 用户管理                                                   │
│  3. 群组管理                                                   │
│  4. 保证多端消息同步                                            │
└───┬──────────────┬──────────────┬──────────────┬───────────────┘
    │               │              │              │
    ↓               ↓              ↓              ↓
┌────────┐      ┌──────┐      ┌────────┐    ┌──────────┐
│Flutter │      │UniApp│      │ 微信   │    │ 支付宝   │
│  Web   │      │  App │      │ 小程序 │    │ 小程序   │
│        │      │      │      │        │    │          │
│使用Web  │      │使用JS│      │使用JS  │    │ 使用JS   │
│ JS SDK │      │ SDK  │      │ SDK    │    │  SDK     │
│        │      │      │      │        │    │          │
│userID: │      │userID:│      │userID: │    │ userID:  │
│user_001│      │user_001│     │user_001│    │ user_001 │
└────────┘      └──────┘      └────────┘    └──────────┘
```

---

## 🔑 关键概念

### 1. SDKAppID
- **作用**: 标识你的腾讯云 IM 应用
- **要求**: 所有端（Flutter Web、UniApp、小程序）必须使用**相同的 SDKAppID**
- **获取**: 腾讯云 IM 控制台

### 2. userID
- **作用**: 标识用户
- **要求**: 同一个用户在不同端使用**相同的 userID**
- **示例**: Flutter Web 用 "user_001"，UniApp 也必须用 "user_001"

### 3. userSig
- **作用**: 用户登录凭证
- **要求**: 必须**从服务端生成**（不能在前端生成）
- **原因**: 包含密钥，前端生成会泄露

### 4. 互通原理
```
Flutter Web (user_001) 发送消息给 user_002
    ↓
腾讯云 IM 服务器接收并存储消息
    ↓
UniApp (user_002) 从服务器拉取消息
    ↓
UniApp 显示收到的消息
```

---

## 🚀 各端集成步骤

### 一、Flutter Web 集成

#### 1. 安装 JS SDK（已完成）
```bash
cd web
npm install @tencentcloud/chat
```

#### 2. 配置 SDKAppID
编辑 `lib/core/im/im_config.dart`:
```dart
static const int sdkAppId = 1400xxxxxx; // 替换为你的 SDKAppID
```

#### 3. 获取测试 UserSig
1. 登录 [腾讯云 IM 控制台](https://console.cloud.tencent.com/im)
2. 选择应用 -> **开发辅助工具** -> **UserSig 生成&校验**
3. 输入 userID（如 `user_001`）
4. 生成测试 UserSig
5. 复制到 `lib/core/im/im_config.dart`:
```dart
static const Map<String, String> mockUserSigs = {
  'user_001': '生成的UserSig',
};
```

#### 4. 运行测试
```bash
cd official_website
flutter run -d chrome --web-port 8080
```

访问: `http://localhost:8080/#/im-demo`

---

### 二、UniApp 集成

#### 1. 安装 SDK
```bash
npm install @tencentcloud/chat --save
```

#### 2. 配置和使用
```javascript
// 引入 SDK
import TencentCloudChat from '@tencentcloud/chat';

// 初始化（使用相同的 SDKAppID）
let options = {
  SDKAppID: 1400xxxxxx  // 与 Flutter Web 相同
};
let tim = TencentCloudChat.create(options);

// 登录（使用相同的 userID）
let promise = tim.login({
  userID: 'user_001',  // 与 Flutter Web 相同
  userSig: '从后端获取'
});

// 发送消息
let message = tim.createTextMessage({
  to: 'user_002',
  conversationType: 'C2C',
  payload: {
    text: 'Hello from UniApp'
  }
});

let promise = tim.sendMessage(message);
```

---

### 三、微信小程序集成

#### 1. 安装 SDK
```bash
npm install @tencentcloud/chat --save
```

#### 2. 配置域名白名单
在小程序管理后台配置以下域名到白名单：
- `https://web.sdk.qcloud.com`
- `https://apass.chat.qcloud.com`
- `wss://wss.im.qcloud.com`

#### 3. 配置和使用
```javascript
// 与 UniApp 几乎完全相同
import TencentCloudChat from '@tencentcloud/chat';

let options = {
  SDKAppID: 1400xxxxxx  // 相同的 SDKAppID
};
let tim = TencentCloudChat.create(options);

// 登录（使用相同的 userID）
tim.login({
  userID: 'user_001',  // 相同的 userID
  userSig: '从后端获取'
});
```

---

## 🔧 后端服务搭建

### UserSig 生成接口

#### Node.js 示例
```javascript
const TLSSigAPIv2 = require('@tencentcloud/tls-sig-api-v2');
const express = require('express');
const app = express();

// 腾讯云 IM 密钥（从控制台获取）
const sdkAppId = 1400xxxxxx;
const key = '你的密钥';

app.get('/api/im/getUserSig', (req, res) => {
  const { userId } = req.query;

  // 生成 UserSig
  const api = new TLSSigAPIv2.Api(sdkAppId, key);
  const userSig = api.genUserSig(userId, 86400 * 180); // 180天有效

  res.json({ userSig });
});

app.listen(3000);
```

#### Java 示例
```java
@RestController
@RequestMapping("/api/im")
public class IMController {

    @GetMapping("/getUserSig")
    public Map<String, String> getUserSig(@RequestParam String userId) {
        // 使用腾讯云提供的 TLS 签名工具
        String userSig = TLSSigAPIv2.genUserSig(sdkAppId, key, userId, 86400 * 180);

        Map<String, String> result = new HashMap<>();
        result.put("userSig", userSig);
        return result;
    }
}
```

#### PHP 示例
```php
<?php
require_once 'TLSSigAPIv2.php';

$sdkAppId = 1400xxxxxx;
$key = '你的密钥';

$userId = $_GET['userId'];
$api = new TLSSigAPIv2($sdkAppId, $key);
$userSig = $api->genUserSig($userId, 86400 * 180);

header('Content-Type: application/json');
echo json_encode(['userSig' => $userSig]);
?>
```

---

## 📝 完整使用流程

### 开发环境（使用测试 UserSig）

#### 1. Flutter Web
```dart
// 1. 配置 SDKAppID
IMConfig.sdkAppId = 1400xxxxxx;

// 2. 配置测试 UserSig
IMConfig.mockUserSigs['user_001'] = '从控制台生成的UserSig';

// 3. 初始化并登录
final im = IMWebManager();
im.init(1400xxxxxx);
im.login('user_001', '测试UserSig');
```

#### 2. UniApp
```javascript
// 使用相同的 SDKAppID 和 userID
let tim = TencentCloudChat.create({ SDKAppID: 1400xxxxxx });
tim.login({
  userID: 'user_001',
  userSig: '测试UserSig' // 可以先用测试的
});
```

#### 3. 微信小程序
```javascript
// 与 UniApp 相同
```

---

### 生产环境（后端生成 UserSig）

#### 1. 后端提供 API
```
GET /api/im/getUserSig?userId=user_001
Response: { "userSig": "..." }
```

#### 2. Flutter Web 调用
```dart
final response = await dio.get('/api/im/getUserSig?userId=user_001');
final userSig = response.data['userSig'];
im.login('user_001', userSig);
```

#### 3. UniApp 调用
```javascript
const response = await uni.request({
  url: 'https://your-api.com/api/im/getUserSig?userId=user_001'
});
const userSig = response.data.userSig;
tim.login({ userID: 'user_001', userSig });
```

---

## 🧪 测试互通

### 测试步骤

1. **在 Flutter Web 发送消息**
   ```
   Flutter Web (user_001) → 发送 "Hello" → UniApp (user_002)
   ```

2. **在 UniApp 回复消息**
   ```
   UniApp (user_002) → 回复 "Hi" → Flutter Web (user_001)
   ```

3. **在微信小程序查看**
   ```
   微信小程序 (user_001) → 应该能看到所有消息历史
   ```

### 验证要点

✅ **相同 SDKAppID** - 所有端使用同一个
✅ **相同 userID** - 同一用户在不同端使用相同 ID
✅ **后端生成 UserSig** - 生产环境必须从后端获取
✅ **消息同步** - 从服务器拉取消息，确保多端一致

---

## 📚 参考文档

### 腾讯云 IM 官方文档
- [产品概述](https://cloud.tencent.com/document/product/269)
- [Web SDK 集成](https://cloud.tencent.com/document/product/269/68447)
- [UniApp 集成](https://cloud.tencent.com/document/product/269/38896)
- [小程序集成](https://cloud.tencent.com/document/product/269/38897)
- [UserSig 生成](https://cloud.tencent.com/document/product/269/32688)

### 本项目文档
- [Flutter Web IM 集成说明](./FLUTTER_WEB_IM集成说明.md)

---

## ⚠️ 注意事项

1. **安全**
   - ⚠️ 永远不要在前端生成 UserSig
   - ⚠️ 永远不要将密钥提交到代码仓库
   - ✅ 使用环境变量管理敏感信息

2. **性能**
   - Web 端消息存储在 IndexedDB，有容量限制
   - 建议定期清理旧消息
   - 使用分页加载历史消息

3. **兼容性**
   - Flutter Web 需要 Chrome 67+ / Safari 11+ / Edge 79+
   - UniApp 需要基础库 2.0+
   - 微信小程序需要基础库 2.10.0+

---

## 🎉 总结

你的理解完全正确！

- ✅ Flutter Web 使用腾讯 IM Web JS SDK
- ✅ UniApp 使用腾讯 IM JS SDK
- ✅ 小程序使用腾讯 IM JS SDK
- ✅ 共享同一个后端
- ✅ 使用相同的 SDKAppID 和 userID
- ✅ 通过腾讯云 IM 服务器实现多端互通

**这就是正确且可行的方案！** 👍

---

**最后更新**: 2026-03-05
**版本**: v2.0.0
