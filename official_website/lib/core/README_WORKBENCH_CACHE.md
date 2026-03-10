# 工作台缓存与API服务体系

## 架构设计

```
┌─────────────────────────────────────────────────────────────┐
│                      用户界面层                             │
│  (ArticleManagementPage, PaymentConfigPage, etc.)           │
└────────────────────┬────────────────────────────────────────┘
                     │
                     ▼
┌─────────────────────────────────────────────────────────────┐
│                   缓存服务层                                │
│  WorkbenchCacheService - 管理本地存储                        │
│  - 读取/保存配置到 SharedPreferences                        │
│  - 提供默认配置                                             │
└────────────────────┬────────────────────────────────────────┘
                     │
                     ▼
┌─────────────────────────────────────────────────────────────┐
│                   API 服务层                                 │
│  WorkbenchApiService - 与服务器通信                          │
│  - 上传配置到服务器                                         │
│  - 从服务器下载配置                                         │
└────────────────────┬────────────────────────────────────────┘
                     │
                     ▼
┌─────────────────────────────────────────────────────────────┐
│                   初始化服务层                               │
│  WorkbenchInitService - 协调缓存和API                        │
│  - 应用启动时初始化                                         │
│  - 同步配置到服务器                                         │
└─────────────────────────────────────────────────────────────┘
```

## 数据流程

### 1. 应用启动/登录后
```
用户登录 → WorkbenchInitService.initializeWorkbench()
           ↓
    从服务器批量获取配置
           ↓
    ┌──────┴──────┐
    │             │
成功              失败
    │             │
    ▼             ▼
保存到本地缓存   检查本地缓存
    │             │
    │       ┌─────┴─────┐
    │       │           │
    │     有缓存      无缓存
    │       │           │
    │       ▼           ▼
    │    使用缓存    使用默认配置
    │
    ▼
标记为已同步
```

### 2. 用户修改配置
```
用户修改配置 → 更新内存中的状态
               ↓
          点击"保存"按钮
               ↓
    WorkbenchCacheService.saveXxxConfig()
               ↓
        保存到本地缓存
               ↓
        标记 syncedWithServer = false
```

### 3. 用户点击"提交"按钮
```
用户点击"提交" → WorkbenchInitService.syncToServer()
                 ↓
          从本地缓存读取所有配置
                 ↓
          WorkbenchApiService.uploadAllWorkbenchConfigs()
                 ↓
    ┌────────────┴────────────┐
    │                         │
成功                          失败
    │                         │
    ▼                         ▼
更新本地缓存              显示错误提示
syncedWithServer = true
    │
    ▼
显示"提交成功"提示
```

## 使用示例

### 示例 1: 文章管理页面

```dart
import 'package:flutter/material.dart';
import '../../../../core/cache/workbench_cache_service.dart';

class ArticleManagementPage extends StatefulWidget {
  @override
  State<ArticleManagementPage> createState() => _ArticleManagementPageState();
}

class _ArticleManagementPageState extends State<ArticleManagementPage> {
  final WorkbenchCacheService _cacheService = WorkbenchCacheService();

  // 配置数据
  List<ArticleCategory> _categories = [];
  bool _isRewardEnabled = true;
  String _listStyle = '上图下文';

  @override
  void initState() {
    super.initState();
    _loadConfig();
  }

  /// 从缓存加载配置
  Future<void> _loadConfig() async {
    final config = await _cacheService.getArticleManagementConfig();
    setState(() {
      _categories = config.categories;
      _isRewardEnabled = config.rewardEnabled;
      _listStyle = config.listStyle;
    });
  }

  /// 保存配置到缓存
  Future<void> _saveConfig() async {
    final config = ArticleManagementConfig(
      categories: _categories,
      rewardEnabled: _isRewardEnabled,
      listStyle: _listStyle,
      lastUpdateTime: DateTime.now(),
      syncedWithServer: false,
    );

    await _cacheService.saveArticleManagementConfig(config);

    // 显示提示
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('配置已保存到本地')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // 配置界面...
          ElevatedButton(
            onPressed: _saveConfig,
            child: Text('保存'),
          ),
        ],
      ),
    );
  }
}
```

### 示例 2: 应用启动时初始化

```dart
import 'package:flutter/material.dart';
import 'core/services/workbench_init_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 初始化工作台配置
  final initService = WorkbenchInitService();
  await initService.initializeWorkbench();

  runApp(MyApp());
}
```

或者在用户登录后：

```dart
class LoginPage extends StatefulWidget {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        // 登录成功
        await _loginSuccess();
      },
      child: Text('登录'),
    );
  }

  Future<void> _loginSuccess() async {
    // 1. 执行登录逻辑...
    // 2. 登录成功后，初始化工作台配置
    final initService = WorkbenchInitService();
    await initService.initializeWorkbench();

    // 3. 跳转到工作台
    Navigator.pushReplacementNamed(context, '/workbench');
  }
}
```

### 示例 3: 提交所有配置到服务器

```dart
class WorkbenchPage extends StatefulWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('工作台'),
        actions: [
          IconButton(
            icon: Icon(Icons.cloud_upload),
            onPressed: _syncToServer,
            tooltip: '提交到服务器',
          ),
        ],
      ),
    );
  }

  Future<void> _syncToServer() async {
    final initService = WorkbenchInitService();

    // 显示加载对话框
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(child: CircularProgressIndicator()),
    );

    try {
      final success = await initService.syncToServer();

      // 关闭加载对话框
      Navigator.pop(context);

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('提交成功'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('提交失败，请检查网络连接'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('提交出错: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
```

## 数据模型

### ArticleCategory (文章分类)
```dart
class ArticleCategory {
  final String id;        // 唯一标识
  String name;            // 分类名称
  int sortOrder;          // 排序顺序

  ArticleCategory({
    required this.id,
    required this.name,
    this.sortOrder = 0,
  });
}
```

### ArticleManagementConfig (文章管理配置)
```dart
class ArticleManagementConfig {
  List<ArticleCategory> categories;    // 分类列表
  bool rewardEnabled;                  // 是否启用打赏
  String listStyle;                    // 列表展示样式
  DateTime? lastUpdateTime;            // 最后更新时间
  bool syncedWithServer;               // 是否已同步到服务器

  // 默认配置
  factory ArticleManagementConfig.defaultConfig() {
    return ArticleManagementConfig(
      categories: [
        ArticleCategory(id: '1', name: '部门简介'),
        ArticleCategory(id: '2', name: '培训师资'),
        // ...
      ],
      rewardEnabled: true,
      listStyle: '上图下文',
      syncedWithServer: false,
    );
  }
}
```

## API 接口规范

### 批量获取配置
```
GET /api/workbench/configs/all

Response 200:
{
  "articleManagement": {
    "categories": [...],
    "rewardEnabled": true,
    "listStyle": "上图下文",
    ...
  },
  "payment": {...},
  "mediaStorage": {...}
}
```

### 批量上传配置
```
POST /api/workbench/configs/all

Request Body:
{
  "articleManagement": {
    "categories": [...],
    ...
  },
  "payment": {...},
  "mediaStorage": {...}
}

Response 200:
{
  "success": true,
  "message": "配置保存成功"
}
```

## 最佳实践

1. **初始化时机**: 在用户登录成功后立即初始化工作台配置
2. **离线优先**: 优先使用本地缓存，网络请求失败不影响基本功能
3. **延迟同步**: 修改配置先保存到本地，用户主动点击"提交"时再上传到服务器
4. **状态标记**: 使用 `syncedWithServer` 字段标识配置是否已同步
5. **错误处理**: 所有网络请求都要进行错误处理，给用户友好提示

## 注意事项

1. **API 地址**: 需要在 `WorkbenchApiService` 中将 `_baseUrl` 替换为实际的 API 地址
2. **认证 Token**: 需要在登录成功后调用 `WorkbenchApiService().setAuthToken(token)`
3. **数据同步**: 多设备登录时，需要考虑数据冲突问题
4. **缓存清理**: 提供清除缓存功能，让用户可以重置配置
