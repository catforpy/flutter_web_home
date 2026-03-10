# Android APP下载功能实现指南

## 1. 准备APK文件

将你的APK文件放到以下目录：
```
assets/apk/app-release.apk
```

## 2. 使用方式

### 方案A：在联系页面添加二维码（已实现）

在联系页面（Contact Page）添加APP下载二维码区域，用户扫码后：
- 微信扫码：提示"在浏览器中打开"
- 浏览器扫码：直接下载APK

### 方案B：独立的下载页面

已创建独立下载页面：
```
assets/download.html
```

访问地址：
```
http://192.168.2.14:3000/assets/download.html
```

## 3. 生成二维码

可以使用以下方式生成下载页面的二维码：

### 方式1：使用在线工具
- 草料二维码：https://cli.im/
- 联图二维码：https://www.liantu.com/

将以下URL生成二维码：
```
http://192.168.2.14:3000/assets/download.html
```

注意：部署到正式环境后，需要替换为实际的域名

### 方式2：使用代码生成（qr_flutter）

在Flutter中动态生成二维码：

```dart
import 'package:qr_flutter/qr_flutter.dart';

// 生成二维码
QrImageView(
  data: 'http://192.168.2.14:3000/assets/download.html',
  version: QrVersions.auto,
  size: 200.0,
)
```

## 4. 微信限制说明

⚠️ **微信内置浏览器无法直接下载APK**

微信会阻止APK文件下载（安全策略），所以流程是：
1. 用户扫码
2. 页面检测到微信环境
3. 显示提示："点击右上角，选择在浏览器中打开"
4. 用户在系统浏览器中打开
5. 点击下载按钮下载APK

## 5. 替代方案

### 使用第三方分发平台（推荐）

如果希望微信内也能下载，可以使用：

**1. 蒲公英（Pgyer）**
- 网址：https://www.pgyer.com/
- 上传APK后生成下载链接
- 微信内可直接下载

**2. 应用宝**
- 腾讯官方应用市场
- 微信内可直接下载

**3. Fir.im**
- 网址：https://fir.im/
- 简单易用的分发平台

## 6. 部署到生产环境

部署到正式服务器后，需要：

1. 更新下载页面中的APK链接
2. 生成新的二维码（使用正式域名）
3. 将二维码添加到网站合适位置

## 7. 测试流程

1. 本地测试：
   ```bash
   # 1. 放置APK文件到 assets/apk/
   # 2. 启动服务器
   cd build/web && npx http-server -p 3000
   # 3. 访问 http://192.168.2.14:3000/assets/download.html
   # 4. 生成二维码并测试扫码
   ```

2. 手机扫码测试：
   - 微信扫码测试
   - 浏览器扫码测试
   - 确认下载流程正常
