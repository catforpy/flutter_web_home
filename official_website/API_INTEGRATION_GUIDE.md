# 后端接口对接指南

本文档说明如何将前端项目从 Mock 数据逐步迁移到真实后端 API。

## 📋 准备工作

### 1. 配置 API 地址

编辑 `lib/core/network/api_config.dart`，修改 `baseUrl`：

```dart
static const String baseUrl = String.fromEnvironment(
  'API_BASE_URL',
  defaultValue: 'http://localhost:8080/api', // 修改为你的实际API地址
);
```

或者通过环境变量设置：

```bash
# 开发环境
flutter run -dart-define=API_BASE_URL=http://localhost:8080/api

# 生产环境
flutter run -dart-define=API_BASE_URL=https://api.yourdomain.com
```

### 2. 确认后端 API 规范

确保后端 API 遵循以下规范：

- **请求格式**: JSON
- **响应格式**: JSON
- **认证方式**: Bearer Token (JWT)
- **状态码**: 标准 HTTP 状态码

#### 标准响应格式

```json
{
  "code": 200,
  "message": "success",
  "data": { ... }
}
```

或者

```json
{
  "success": true,
  "data": { ... },
  "error": null
}
```

## 🔄 对接步骤

### 步骤 1: 在 ApiConfig 中添加接口路径

在 `lib/core/network/api_config.dart` 中添加新的 API 路径常量：

```dart
/// API 路径常量
static const String yourNewEndpoint = '/your/endpoint';
```

### 步骤 2: 创建 API Datasource

在 `lib/data/datasources/` 下创建数据源文件（如果不存在）：

```dart
// lib/data/datasources/your_api_datasource.dart
import 'package:dartz/dartz.dart';
import 'package:official_website/core/error/failures.dart';
import 'package:official_website/core/network/api_client.dart';
import 'package:official_website/core/network/api_config.dart';
import 'package:official_website/domain/entities/your_entity.dart';

class YourApiDatasource {
  final ApiClient _apiClient = ApiClient();

  Future<Either<Failure, YourEntity>> fetchData() async {
    return _apiClient.get<YourEntity>(
      ApiConfig.yourNewEndpoint,
      fromJson: (json) {
        return YourEntity.fromJson(json as Map<String, dynamic>);
      },
    );
  }
}
```

### 步骤 3: 创建/修改 Repository 实现

在 `lib/data/repositories/` 下创建或修改 Repository 实现：

```dart
// lib/data/repositories/your_repository_impl.dart
import 'package:dartz/dartz.dart';
import 'package:official_website/core/error/failures.dart';
import 'package:official_website/data/datasources/your_api_datasource.dart';
import 'package:official_website/domain/entities/your_entity.dart';
import 'package:official_website/domain/repositories/your_repository.dart';

class YourRepositoryImpl implements YourRepository {
  final YourApiDatasource _datasource = YourApiDatasource();

  @override
  Future<Either<Failure, YourEntity>> getData() async {
    try {
      return await _datasource.fetchData();
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }
}
```

### 步骤 4: 更新依赖注入

如果你的项目使用 `get_it` 或其他依赖注入，更新注册：

```dart
// 在你的依赖注入配置中
@injectableInit
void configureDependencies() {
  get_it.registerLazySingleton<YourRepository>(
    () => YourRepositoryImpl(),
  );
}
```

### 步骤 5: 测试接口

运行项目并测试接口是否正常工作：

```bash
flutter run
```

观察日志输出，确认 API 调用是否成功。

## 📝 对接示例

### 示例 1: 用户登录接口

**后端接口:**
- URL: `POST /api/auth/login`
- 请求体:
  ```json
  {
    "phone": "13800138000",
    "password": "123456"
  }
  ```
- 响应:
  ```json
  {
    "code": 200,
    "message": "登录成功",
    "data": {
      "user": {
        "id": "1",
        "phone": "13800138000",
        "nickname": "张三"
      },
      "accessToken": "eyJhbGciOiJIUzI1NiIs...",
      "refreshToken": "eyJhbGciOiJIUzI1NiIs..."
    }
  }
  ```

**前端实现:**

参考 `lib/data/datasources/auth_api_datasource.dart` 中的 `login` 方法。

### 示例 2: 获取文章列表

**后端接口:**
- URL: `GET /api/articles`
- 查询参数:
  - `categoryId`: 可选，分类ID
  - `page`: 页码，默认1
  - `pageSize`: 每页数量，默认10

**前端实现:**

参考 `lib/data/repositories/article_api_repository_impl.dart` 中的 `getArticles` 方法。

## ⚠️ 常见问题

### 1. 跨域问题

如果遇到 CORS 错误，确保后端已配置允许跨域：

```http
Access-Control-Allow-Origin: *
Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS
Access-Control-Allow-Headers: Content-Type, Authorization
```

### 2. Token 过期

ApiClient 已自动处理 Token 刷新逻辑：

- 检测到 401 错误时自动尝试刷新 Token
- 刷新成功后自动重试原请求
- 刷新失败则返回错误

### 3. 数据格式不匹配

如果后端返回的数据格式与前端实体类不匹配，有两种解决方案：

**方案 A: 修改前端实体类**
```dart
factory YourEntity.fromJson(Map<String, dynamic> json) {
  return YourEntity(
    id: json['id'] as String?,
    // 根据后端实际字段调整
  );
}
```

**方案 B: 在 fromJson 中转换**
```dart
fromJson: (json) {
  final data = json as Map<String, dynamic>;
  // 转换数据格式
  return YourEntity(
    id: data['id']?.toString() ?? '',
    name: data['name'] ?? data['title'] ?? '',
  );
}
```

### 4. 网络请求失败

检查以下几点：

1. ✅ 确认 API 地址正确
2. ✅ 确认网络连接正常
3. ✅ 检查防火墙设置
4. ✅ 查看控制台日志获取详细错误信息

## 🎯 对接检查清单

对接每个接口时，确保完成以下检查：

- [ ] 在 ApiConfig 中添加了接口路径常量
- [ ] 创建了 API Datasource
- [ ] 创建/修改了 Repository 实现
- [ ] 实体类 (Entity) 的 fromJson 方法正确解析后端数据
- [ ] 更新了依赖注入配置
- [ ] 测试了接口调用成功
- [ ] 测试了错误处理（网络错误、服务器错误、数据验证错误）
- [ ] 确认 UI 正确显示接口返回的数据
- [ ] 确认认证 Token 正确设置和使用

## 📊 接口对接进度跟踪

使用以下表格跟踪接口对接进度：

| 模块 | 接口名称 | 状态 | 备注 |
|------|---------|------|------|
| 认证 | 登录 | ⏳ 待对接 | 优先级：高 |
| 认证 | 注册 | ⏳ 待对接 | 优先级：高 |
| 认证 | 发送验证码 | ⏳ 待对接 | 优先级：高 |
| 用户 | 获取用户信息 | ⏳ 待对接 | |
| 用户 | 更新用户信息 | ⏳ 待对接 | |
| 文章 | 获取文章列表 | ⏳ 待对接 | |
| 文章 | 获取文章详情 | ⏳ 待对接 | |
| 文章 | 创建文章 | ⏳ 待对接 | |
| 文章 | 更新文章 | ⏳ 待对接 | |
| 文章 | 删除文章 | ⏳ 待对接 | |
| 文章 | 获取分类列表 | ⏳ 待对接 | |
| 账户设置 | 获取账户设置 | ⏳ 待对接 | |
| 账户设置 | 修改密码 | ⏳ 待对接 | |
| 账户设置 | 上传头像 | ⏳ 待对接 | |
| 工作台 | 文章管理配置 | ⏳ 待对接 | |

**状态说明:**
- ⏳ 待对接
- 🔄 对接中
- ✅ 已完成
- ❌ 对接失败

## 🚀 下一步

1. **从登录接口开始** - 这是最重要的接口，其他接口依赖它
2. **逐个模块对接** - 完成一个模块后再进行下一个
3. **保持 Mock 数据** - 在对接过程中保留 Mock 实现，方便对比测试
4. **记录接口差异** - 如果后端接口与预期不符，记录下来统一处理

## 📞 联系后端开发

如果在对接过程中遇到问题，需要与后端开发确认：

1. 接口 URL 和请求方法
2. 请求参数格式和验证规则
3. 响应数据结构
4. 错误码定义
5. 认证方式和 Token 格式
6. 文件上传接口的特殊处理

---

**最后更新**: 2026-03-11
**维护者**: 开发团队
