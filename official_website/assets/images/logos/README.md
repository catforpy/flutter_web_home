# 客户Logo图片说明

## 用途
此目录用于存放客户案例展示墙中使用的客户Logo图片。

## 图片要求
- 格式：PNG 或 SVG
- 建议尺寸：200x200px 或更大
- 背景：透明背景或白色背景
- 命名规范：使用公司名称的拼音或英文，小写，例如：
  - vanke.png
  - tencent.png
  - alibaba.png

## 当前占位数据
组件中已配置以下客户数据（图片需要添加）：
- 万科 (vanke.png)
- 中建七局 (cscec.png)
- 国家电网 (state-grid.png)
- 腾讯 (tencent.png)
- 阿里巴巴 (alibaba.png)
- 字节跳动 (bytedance.png)
- 美团 (meituan.png)
- 京东 (jd.png)
- 华为 (huawei.png)
- 小米 (xiaomi.png)
- 滴滴 (didi.png)
- 网易 (netease.png)

## 后续对接
当后端API开发完成后，可以在 `ClientShowcaseWidget` 中替换为动态数据：

```dart
// 从API获取客户数据
final response = await dio.get('/api/clients');
final clients = response.data as List;
```

数据结构：
```json
[
  {
    "id": 1,
    "name": "万科",
    "logoUrl": "assets/images/logos/vanke.png",
    "linkUrl": "https://www.vanke.com"
  }
]
```
