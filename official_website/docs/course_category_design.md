# 课程分类管理系统设计方案

## 一、功能概述

实现一个最多4级的课程分类管理系统，采用嵌入式滑动标签容器展示，支持自定义添加、修改、删除分类。

## 二、数据结构设计

### 2.1 分类节点数据模型

```dart
class CourseCategory {
  String id;                    // 唯一标识
  String name;                  // 分类名称
  int level;                    // 层级（1-4）
  String? parentId;             // 父分类ID
  int sortOrder;                // 排序序号
  DateTime createdAt;           // 创建时间
  DateTime updatedAt;           // 更新时间
  List<CourseCategory> children; // 子分类列表
}
```

### 2.2 默认一级分类

```dart
const defaultFirstLevelCategories = [
  {'name': '物流交通', 'icon': Icons.local_shipping},
  {'name': '科技培训', 'icon': Icons.school},
  {'name': '餐饮生活', 'icon': Icons.restaurant},
  {'name': '生活娱乐', 'icon': Icons.movie},
  {'name': '电商平台', 'icon': Icons.shopping_cart},
];
```

## 三、UI界面设计

### 3.1 整体布局

```
┌────────────────────────────────────────────────────────────────┐
│ 课程分类管理                                              [返回]│
├────────────────────────────────────────────────────────────────┤
│                                                                │
│  【一级分类标签容器 - 横向滚动】                                │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │ 物流交通 │ 科技培训 │ 餐饮生活 │ 生活娱乐 │ 电商平台 │ + │  │
│  └──────────────────────────────────────────────────────────┘  │
│                                                                │
│  【二级分类标签容器 - 横向滚动】                                │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │ 计算机 │ 心理健康 │ 美食 │ 摄影 │ +                      │  │
│  └──────────────────────────────────────────────────────────┘  │
│                                                                │
│  【三级分类标签容器 - 横向滚动】                                │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │ Python │ Java │ Web │ 前端 │ 后端 │ +                    │  │
│  └──────────────────────────────────────────────────────────┘  │
│                                                                │
│  【四级分类标签容器 - 横向滚动】                                │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │ 基础 │ 进阶 │ 项目实战 │ +                                │  │
│  └──────────────────────────────────────────────────────────┘  │
│                                                                │
│  【面包屑导航】                                                │
│  科技培训 > 计算机 > Python > 基础                             │
│                                                                │
├────────────────────────────────────────────────────────────────┤
│  【操作区域】                                                  │
│                                                                │
│  分类详情：                                                    │
│  ┌────────────────────────────────────────────────────────┐   │
│  │ 当前分类：基础                                            │   │
│  │ 分类层级：第4级                                          │   │
│  │ 课程数量：15门                                           │   │
│  │ 创建时间：2025-01-09                                     │   │
│  │                                                          │   │
│  │ [📝 编辑名称] [🗑️ 删除] [➕添加子分类] [➕添加同级]     │   │
│  └────────────────────────────────────────────────────────┘   │
│                                                                │
│  当前分类下的课程列表：                                        │
│  ┌────────────────────────────────────────────────────────┐   │
│  │ 课程1：Python基础入门              [编辑] [删除]         │   │
│  │ 课程2：Python进阶实战              [编辑] [删除]         │   │
│  │ ...                                                      │   │
│  │ [+ 添加课程到当前分类]                                  │   │
│  └────────────────────────────────────────────────────────┘   │
└────────────────────────────────────────────────────────────────┘
```

## 四、交互设计

### 4.1 标签容器特性

#### 视觉特性
- **当前选中**：高亮背景色（主色调 #1A9B8E）
- **普通状态**：白色背景 + 灰色边框
- **悬停状态**：浅色背景 + 阴影
- **"+"按钮**：虚线边框 + 加号图标

#### 交互行为
1. **点击标签**：选中该分类，显示其子分类
2. **点击"+"按钮**：弹出对话框添加同级分类
3. **右键点击标签**：显示上下文菜单（编辑、删除、添加子分类、添加同级）

### 4.2 面包屑导航
- 显示当前选中的完整路径
- 可点击任意级别快速跳转
- 格式：`一级 > 二级 > 三级 > 四级`

### 4.3 分类操作

#### 4.3.1 添加分类
**触发方式**：
- 点击标签容器右侧的"+"按钮
- 右键点击标签 → "添加子分类"
- 点击操作区域的"添加子分类"按钮

**对话框内容**：
```
┌─────────────────────────────────────┐
│ 添加分类                             │
├─────────────────────────────────────┤
│ 分类名称：[_____________]           │
│ 排序：    [___] (可选)              │
│                                     │
│ [取消]              [确定]         │
└─────────────────────────────────────┘
```

#### 4.3.2 编辑分类
**触发方式**：
- 右键点击标签 → "编辑"
- 点击操作区域的"编辑名称"按钮

**对话框内容**：
```
┌─────────────────────────────────────┐
│ 编辑分类                             │
├─────────────────────────────────────┤
│ 分类名称：[基础_________]           │
│ 排序：    [1_________]              │
│                                     │
│ [取消]              [确定]         │
└─────────────────────────────────────┘
```

#### 4.3.3 删除分类
**触发方式**：
- 右键点击标签 → "删除"
- 点击操作区域的"删除"按钮

**确认对话框**：
```
┌─────────────────────────────────────┐
│ 确认删除                             │
├─────────────────────────────────────┤
│ 确定要删除"基础"分类吗？             │
│                                     │
│ ⚠️ 注意：                          │
│ • 该分类下有3个子分类               │
│ • 该分类下有15门课程                 │
│ • 删除后子分类和课程将变为未分类     │
│                                     │
│ [取消]              [确定删除]     │
└─────────────────────────────────────┘
```

**删除规则**：
- 如果有子分类，提示用户并要求确认
- 如果有课程，提示用户并要求确认
- 级联删除：删除父分类时，所有子孙分类也被删除

## 五、技术实现要点

### 5.1 数据管理
```dart
class CourseCategoryManager extends ChangeNotifier {
  // 树形结构存储
  List<CourseCategory> rootCategories; // 一级分类列表

  // 辅助方法
  CourseCategory? findCategory(String id);
  List<CourseCategory> getChildren(String parentId);
  void addCategory(String name, String? parentId);
  void updateCategory(String id, String newName);
  void deleteCategory(String id);
  List<CourseCategory> getCategoryPath(String id); // 获取面包屑路径
}
```

### 5.2 状态管理
```dart
class CategorySelectionState extends ChangeNotifier {
  CourseCategory? selectedL1; // 选中的一级
  CourseCategory? selectedL2; // 选中的二级
  CourseCategory? selectedL3; // 选中的三级
  CourseCategory? selectedL4; // 选中的四级

  // 当前选中的叶子节点（最底层的选中项）
  CourseCategory? get currentSelection {
    return selectedL4 ?? selectedL3 ?? selectedL2 ?? selectedL1;
  }

  // 获取面包屑路径
  List<CourseCategory> get breadcrumb {
    final path = <CourseCategory>[];
    if (selectedL1 != null) path.add(selectedL1!);
    if (selectedL2 != null) path.add(selectedL2!);
    if (selectedL3 != null) path.add(selectedL3!);
    if (selectedL4 != null) path.add(selectedL4!);
    return path;
  }
}
```

### 5.3 标签容器组件
```dart
class CategoryTabBar extends StatelessWidget {
  final List<CourseCategory> categories;
  final CourseCategory? selectedCategory;
  final int level;
  final Function(CourseCategory) onTap;
  final Function() onAdd;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFE5E5E5))),
      ),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16),
        itemCount: categories.length + 1, // +1 for add button
        separatorBuilder: (_, __) => SizedBox(width: 12),
        itemBuilder: (context, index) {
          if (index == categories.length) {
            // 添加按钮
            return _buildAddButton();
          }
          final category = categories[index];
          final isSelected = category.id == selectedCategory?.id;
          return _buildTab(category, isSelected);
        },
      ),
    );
  }
}
```

## 六、优势特点

1. **直观展示**：嵌入式标签容器清晰展示层级关系
2. **快速定位**：面包屑导航快速跳转到任意层级
3. **灵活管理**：支持任意层级的添加、修改、删除
4. **扩展性强**：虽然默认4级，但可以轻松扩展到更多层级
5. **批量操作**：支持批量排序、批量移动等高级功能

## 七、后续扩展

1. **拖拽排序**：标签可拖拽调整顺序
2. **搜索过滤**：支持按名称搜索分类
3. **批量导入**：从Excel批量导入分类
4. **权限控制**：不同用户角色对分类的操作权限
5. **数据统计**：每个分类下的课程数量统计

## 八、参考效果

参考网站：
- 京东分类导航：https://www.jd.com
- 淘宝类目选择：https://sell.taobao.com
- 有道课程分类：https://ke.youdao.com
