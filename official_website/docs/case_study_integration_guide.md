# 服务详情页 - 案例展示功能

## 📱 功能说明

在购买页面的服务卡片详情页中，新增了**"案例展示"**标签页，展示智慧景区导览的完整案例页面。

## 🎯 使用方法

### 1. 访问详情页

```bash
# 启动项目
cd "/Volumes/DudaDate/微信小程序开发/flutter官网开发/official_website"
flutter run -d chrome --web-port 8080
```

### 2. 导航步骤

1. 打开购买页面：`http://localhost:8080/purchase`
2. 点击任意服务卡片
3. 进入详情页后，点击顶部的**"案例展示"**标签
4. 即可查看智慧景区导览的完整案例页面

## 🏗️ 技术实现

### 展示类型标签

详情页包含 5 个展示类型标签：

1. **轮播展示** - 图片/视频轮播
2. **图文介绍** - 图文混排展示
3. **长图列表** - 长图滚动展示
4. **文字说明** - 纯文字介绍
5. **案例展示** - 智慧景区导览完整页面 ⭐（新增）

### 代码结构

```dart
// service_detail_page.dart

class ServiceDetailPage extends StatefulWidget {
  // 展示类型列表
  final List<String> _displayTypes = [
    '轮播展示',
    '图文介绍',
    '长图列表',
    '文字说明',
    '案例展示', // 新增
  ];

  // 根据选择的类型显示不同内容
  Widget _buildContentArea() {
    switch (_selectedDisplayType) {
      // ...
      case '案例展示':
        return _buildCaseStudyContent(); // 新增
      default:
        return const SizedBox.shrink();
    }
  }

  // 案例展示内容
  Widget _buildCaseStudyContent() {
    return const ScenicSpotGuideFull();
  }
}
```

## ✨ 案例展示页面完整特性

### 实现的功能模块（基于原始HTML/CSS/JS）

#### 2. 顶部导航栏
- ✅ **初始状态**：透明背景
- ✅ **向下滚动**：白色背景 + 收缩效果（padding: 6px）
- ✅ **向上滚动**：白色背景 + 展开效果（padding: 20px）
- ✅ **回到顶部**：透明背景
- ✅ **包含元素**：Logo、联系方式（电话、微信）

#### 3. 全屏渐变背景
- ✅ **颜色渐变**：绿色(#52C41A) + 土黄色(#D4B106) → 浅灰(#FAFAFA) → 白色
- ✅ **高度**：100vh（一个屏幕高度）
- ✅ **毛玻璃效果**：BackdropFilter模糊
- ✅ **位置**：从页面最顶部开始，随滚动向上移动
- ✅ **底部**：纯白色，与页面背景无缝衔接

#### 4. Hero区域（标题区）
- ✅ **横向排列布局**
- ✅ **左侧**：大标题"智慧景区导览" + 副标题"Case Show"
- ✅ **右侧**：统计数据卡片
  - 访客停留时长：185秒（动态数字动画 0 → 185）
  - 有效转化率：68.5%（动态数字动画 0 → 68.5）
- ✅ **CTA按钮**："查看详情"按钮，带阴影和悬停效果

#### 5. Sticky侧边栏（右侧）
- ✅ **定位**：`SliverPersistentHeader` + `pinned: true`（Flutter实现CSS position: sticky）
- ✅ **阈值**：top: 0（自适应）
- ✅ **包含内容**：
  - 项目服务列表（8项，带✓图标）
  - 探索更多（3个按钮）
  - 案例导航（上一个/下一个）
- ✅ **效果**：随主内容滚动，在视口固定

#### 6. 主内容区域（白色框）
- ✅ **位置**：向上覆盖背景下半部分（margin-top: -400px）
- ✅ **包含内容**：
  - 案例图片（2022年标签，浏览热度98%）
  - 项目介绍（带背景色和边框）
  - 核心功能（4个功能卡片，网格布局）
  - 技术架构（8个技术标签）
  - 项目成果（4个数据展示）
  - 用户评价（带头像和评分）
  - 效果展示（3张图片展示）

#### 7. 其他页面区域
- ✅ **项目服务**：4列网格布局，8个服务项
- ✅ **更多案例**：3列案例卡片网格，6个案例
- ✅ **服务优势**：4个优势点展示
- ✅ **底部CTA**：渐变背景 + 行动召唤按钮
- ✅ **页脚**：深色背景 + 链接

#### 8. 交互效果
- ✅ **滚动动画**：导航栏根据滚动位置切换样式
- ✅ **悬停效果**：卡片、按钮的悬停反馈
- ✅ **数字滚动动画**：800ms缓动动画
- ✅ **平滑滚动**：CustomScrollView实现
- ✅ **悬浮按钮显示**：滚动超过100px时显示

#### 9. 悬浮按钮（右下角）
- ✅ **微信交谈**：绿色按钮
- ✅ **联系方式**：蓝色按钮
- ✅ **获取方案**：绿色按钮
- ✅ **线上会议**：橙色按钮
- ✅ **悬浮提示**：tooltip效果（待实现）

#### 10. 布局特点
- ✅ **容器宽度**：最大1800px
- ✅ **内容覆盖**：主内容向上覆盖背景（margin-top: -400px）
- ✅ **层级关系**：背景层 → 页面背景层 → 内容层

#### 11. 设计风格
- ✅ **渐变背景**：绿+土黄色渐变
- ✅ **白色卡片设计**：所有内容区使用白色圆角卡片
- ✅ **圆角+阴影**：统一的设计语言
- ✅ **毛玻璃效果**：Hero区域统计卡片
- ✅ **数字滚动动画**：平滑的数值变化

## 🎨 自定义配置

### 修改案例页面内容

如果需要修改智慧景区导览页面的内容，编辑：

```
/Volumes/DudaDate/微信小程序开发/flutter官网开发/official_website/lib/presentation/pages/case_studies/scenic_spot_guide_full.dart
```

### 添加更多案例页面

1. 创建新的案例页面文件：
   ```
   lib/presentation/pages/case_studies/your_case_page.dart
   ```

2. 在 `service_detail_page.dart` 中添加新的展示类型：
   ```dart
   final List<String> _displayTypes = [
     '轮播展示',
     '图文介绍',
     '长图列表',
     '文字说明',
     '案例展示',
     '您的案例', // 新增
   ];
   ```

3. 添加对应的构建方法：
   ```dart
   case '您的案例':
     return _buildYourCaseContent();
   ```

## 📊 页面结构

```
详情页
├── 顶部应用栏（返回、分享）
├── 展示类型标签（5个标签）
└── 内容区域
    ├── 轮播展示
    ├── 图文介绍
    ├── 长图列表
    ├── 文字说明
    └── 案例展示 ⭐
        └── 智慧景区导览页面（完整）
            ├── 2. 顶部导航栏（Sticky，根据滚动切换样式）
            ├── 3. 全屏渐变背景（绿→土黄→白）
            ├── 4. Hero区域
            │   ├── 左侧：标题 + 副标题 + CTA按钮
            │   └── 右侧：统计卡片（带数字动画）
            ├── 6. 主内容区域（白色卡片，向上覆盖背景）
            │   ├── 案例图片区域
            │   ├── 项目介绍
            │   ├── 核心功能（4个功能卡片）
            │   ├── 技术架构（8个技术标签）
            │   ├── 项目成果（4个数据展示）
            │   ├── 用户评价
            │   ├── 效果展示（3张图片）
            │   ├── 7. 项目服务（8个服务网格）
            │   ├── 更多案例（6个案例卡片）
            │   ├── 服务优势（4个优势点）
            │   └── 底部CTA
            ├── 5. Sticky侧边栏（右侧）
            │   ├── 项目服务列表
            │   ├── 探索更多
            │   └── 案例导航
            ├── 9. 悬浮按钮（右下角4个按钮）
            └── 页脚
```

## 🚀 快速测试

```dart
// 在任何地方导航到详情页
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => ServiceDetailPage(
      serviceId: 's001',
      title: '智慧景区导览',
      providerName: '示例提供商',
    ),
  ),
);
```

## 📝 技术要点

### Sticky定位实现

Flutter中使用`CustomScrollView` + `SliverPersistentHeader`实现CSS的`position: sticky`效果：

```dart
SliverPersistentHeader(
  pinned: true,  // 关键：启用固定效果
  floating: false,
  delegate: _StickySidebarDelegate(
    minHeight: 500,
    maxHeight: 700,
    child: sidebarContent,
  ),
)
```

### 数字动画实现

使用`AnimatedDefaultTextStyle`实现数字滚动效果：

```dart
AnimatedDefaultTextStyle(
  duration: const Duration(milliseconds: 800),
  curve: Curves.easeOutQuart,
  style: const TextStyle(
    fontSize: 48,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  ),
  child: Text('${_visitorTimeValue.toInt()}'),
)
```

### 渐变背景实现

使用`LinearGradient`实现多色渐变：

```dart
Container(
  decoration: BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Color(0xFF52C41A),  // 绿色
        Color(0xFFD4B106),  // 土黄色
        Color(0xFFFAFAFA),  // 浅灰
        Colors.white,       // 白色
      ],
      stops: [0.0, 0.3, 0.7, 1.0],
    ),
  ),
)
```

## 📝 注意事项

1. **响应式设计**：案例展示页面会自动适应不同屏幕尺寸
2. **粘性侧边栏**：使用SliverPersistentHeader实现真正的sticky效果
3. **滚动同步**：案例页面有自己的滚动控制，详情页的滚动条会自动调整
4. **性能优化**：使用了 Sliver 组件优化滚动性能
5. **图片占位**：使用picsum.photos作为占位图片，实际使用时需替换

## 🎯 后续优化建议

1. **数据驱动**：将案例数据从后端 API 获取
2. **多案例支持**：添加切换不同案例的功能
3. **搜索过滤**：在案例展示页面添加搜索和过滤功能
4. **分享功能**：支持分享单个案例页面
5. **收藏功能**：允许用户收藏喜欢的案例
6. **图片优化**：添加图片懒加载和缓存
7. **国际化**：添加多语言支持
8. **离线支持**：添加PWA离线功能

---

**最后更新**: 2026-03-13
**版本**: v2.0.0（完整实现版）
**参考**: /Users/shiweijuan/wisdom-scenic-page/
