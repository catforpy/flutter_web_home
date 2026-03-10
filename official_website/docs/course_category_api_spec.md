# 课程分类管理 API 数据结构文档

## 一、概述

本文档定义课程分类管理系统的完整数据结构，用于前后端API交互。

## 二、数据模型定义

### 2.1 行业分类（Industry Category）

支持4级层级结构，例如：`计算机 > Python > Web开发 > Django`

#### 2.1.1 分类节点模型

```json
{
  "IndustryCategory": {
    "description": "行业分类节点模型",
    "fields": {
      "id": {
        "type": "String",
        "description": "分类ID，唯一标识",
        "example": "ind_1001",
        "required": true
      },
      "name": {
        "type": "String",
        "description": "分类名称",
        "example": "Python",
        "required": true,
        "maxLength": 50
      },
      "parentId": {
        "type": "String?",
        "description": "父分类ID，顶级分类为null",
        "example": "ind_1000",
        "required": false
      },
      "level": {
        "type": "int",
        "description": "层级深度（1-4）",
        "example": 2,
        "required": true,
        "minimum": 1,
        "maximum": 4
      },
      "path": {
        "type": "String",
        "description": "完整路径，用 > 分隔",
        "example": "计算机 > Python",
        "required": true
      },
      "sortOrder": {
        "type": "int",
        "description": "排序序号，数字越小越靠前",
        "example": 1,
        "required": true,
        "default": 0
      },
      "icon": {
        "type": "String?",
        "description": "分类图标URL",
        "example": "https://example.com/icons/python.png",
        "required": false
      },
      "description": {
        "type": "String?",
        "description": "分类描述",
        "example": "Python编程语言相关课程",
        "required": false,
        "maxLength": 500
      },
      "isActive": {
        "type": "bool",
        "description": "是否启用",
        "example": true,
        "required": true,
        "default": true
      },
      "createdAt": {
        "type": "DateTime",
        "description": "创建时间",
        "example": "2024-01-15T10:30:00Z",
        "required": true
      },
      "updatedAt": {
        "type": "DateTime",
        "description": "更新时间",
        "example": "2024-01-20T14:25:00Z",
        "required": true
      }
    }
  }
}
```

#### 2.1.2 分类树形结构

```json
{
  "IndustryCategoryTree": {
    "description": "行业分类树形结构",
    "example": {
      "id": "ind_root",
      "name": "全部分类",
      "level": 0,
      "children": [
        {
          "id": "ind_1",
          "name": "计算机",
          "level": 1,
          "parentId": "ind_root",
          "path": "计算机",
          "sortOrder": 1,
          "children": [
            {
              "id": "ind_100",
              "name": "Python",
              "level": 2,
              "parentId": "ind_1",
              "path": "计算机 > Python",
              "sortOrder": 1,
              "children": [
                {
                  "id": "ind_1000",
                  "name": "Web开发",
                  "level": 3,
                  "parentId": "ind_100",
                  "path": "计算机 > Python > Web开发",
                  "sortOrder": 1,
                  "children": [
                    {
                      "id": "ind_10000",
                      "name": "Django",
                      "level": 4,
                      "parentId": "ind_1000",
                      "path": "计算机 > Python > Web开发 > Django",
                      "sortOrder": 1
                    },
                    {
                      "id": "ind_10001",
                      "name": "Flask",
                      "level": 4,
                      "parentId": "ind_1000",
                      "path": "计算机 > Python > Web开发 > Flask",
                      "sortOrder": 2
                    }
                  ]
                }
              ]
            }
          ]
        }
      ]
    }
  }
}
```

### 2.2 课程形式分类（Format Category）

支持2级层级：`预录 > 视频`、`直播 > 互动直播`

#### 2.2.1 形式分类模型

```json
{
  "FormatCategory": {
    "description": "课程形式分类模型",
    "fields": {
      "id": {
        "type": "String",
        "description": "分类ID",
        "example": "fmt_1",
        "required": true
      },
      "name": {
        "type": "String",
        "description": "分类名称",
        "example": "预录",
        "required": true,
        "maxLength": 50
      },
      "parentId": {
        "type": "String?",
        "description": "父分类ID，顶级分类为null",
        "example": "fmt_root",
        "required": false
      },
      "level": {
        "type": "int",
        "description": "层级深度（1-2）",
        "example": 1,
        "required": true,
        "minimum": 1,
        "maximum": 2
      },
      "path": {
        "type": "String",
        "description": "完整路径",
        "example": "预录 > 视频",
        "required": true
      },
      "sortOrder": {
        "type": "int",
        "description": "排序序号",
        "example": 1,
        "required": true,
        "default": 0
      },
      "icon": {
        "type": "String?",
        "description": "分类图标URL",
        "example": "https://example.com/icons/video.png",
        "required": false
      },
      "isActive": {
        "type": "bool",
        "description": "是否启用",
        "example": true,
        "required": true,
        "default": true
      },
      "createdAt": {
        "type": "DateTime",
        "description": "创建时间",
        "required": true
      },
      "updatedAt": {
        "type": "DateTime",
        "description": "更新时间",
        "required": true
      }
    }
  }
}
```

#### 2.2.2 形式分类预定义数据

```json
{
  "FormatCategories": {
    "description": "课程形式分类预定义数据",
    "data": [
      {
        "id": "fmt_1",
        "name": "预录",
        "level": 1,
        "parentId": null,
        "path": "预录",
        "sortOrder": 1,
        "children": [
          {
            "id": "fmt_100",
            "name": "视频",
            "level": 2,
            "parentId": "fmt_1",
            "path": "预录 > 视频",
            "sortOrder": 1
          },
          {
            "id": "fmt_101",
            "name": "图文",
            "level": 2,
            "parentId": "fmt_1",
            "path": "预录 > 图文",
            "sortOrder": 2
          },
          {
            "id": "fmt_102",
            "name": "音频",
            "level": 2,
            "parentId": "fmt_1",
            "path": "预录 > 音频",
            "sortOrder": 3
          }
        ]
      },
      {
        "id": "fmt_2",
        "name": "直播",
        "level": 1,
        "parentId": null,
        "path": "直播",
        "sortOrder": 2,
        "children": [
          {
            "id": "fmt_200",
            "name": "视频直播",
            "level": 2,
            "parentId": "fmt_2",
            "path": "直播 > 视频直播",
            "sortOrder": 1
          },
          {
            "id": "fmt_201",
            "name": "互动直播",
            "level": 2,
            "parentId": "fmt_2",
            "path": "直播 > 互动直播",
            "sortOrder": 2
          }
        ]
      }
    ]
  }
}
```

### 2.3 课程类型分类（Type Category）

支持2级层级：`单课`、`套课`

#### 2.3.1 类型分类模型

```json
{
  "TypeCategory": {
    "description": "课程类型分类模型",
    "fields": {
      "id": {
        "type": "String",
        "description": "分类ID",
        "example": "type_1",
        "required": true
      },
      "name": {
        "type": "String",
        "description": "分类名称",
        "example": "单课",
        "required": true,
        "maxLength": 50
      },
      "parentId": {
        "type": "String?",
        "description": "父分类ID，顶级分类为null",
        "example": null,
        "required": false
      },
      "level": {
        "type": "int",
        "description": "层级深度（1-2）",
        "example": 1,
        "required": true,
        "minimum": 1,
        "maximum": 2
      },
      "path": {
        "type": "String",
        "description": "完整路径",
        "example": "单课",
        "required": true
      },
      "sortOrder": {
        "type": "int",
        "description": "排序序号",
        "example": 1,
        "required": true,
        "default": 0
      },
      "icon": {
        "type": "String?",
        "description": "分类图标URL",
        "required": false
      },
      "isActive": {
        "type": "bool",
        "description": "是否启用",
        "example": true,
        "required": true,
        "default": true
      },
      "createdAt": {
        "type": "DateTime",
        "description": "创建时间",
        "required": true
      },
      "updatedAt": {
        "type": "DateTime",
        "description": "更新时间",
        "required": true
      }
    }
  }
}
```

#### 2.3.2 类型分类预定义数据

```json
{
  "TypeCategories": {
    "description": "课程类型分类预定义数据",
    "data": [
      {
        "id": "type_1",
        "name": "单课",
        "level": 1,
        "parentId": null,
        "path": "单课",
        "sortOrder": 1,
        "description": "单个独立的课程，可单独购买和学习"
      },
      {
        "id": "type_2",
        "name": "套课",
        "level": 1,
        "parentId": null,
        "path": "套课",
        "sortOrder": 2,
        "description": "系列课程合集，包含多个相关联的课程"
      }
    ]
  }
}
```

## 三、API 接口定义

### 3.1 行业分类接口

#### 3.1.1 获取行业分类树

```http
GET /api/course-category/industry/tree
```

**Query Parameters**:
```json
{
  "includeInactive": {
    "type": "boolean",
    "description": "是否包含未启用的分类",
    "default": false
  }
}
```

**Response 200**:
```json
{
  "code": 200,
  "message": "success",
  "data": {
    "id": "ind_root",
    "name": "全部分类",
    "level": 0,
    "children": [
      {
        "id": "ind_1",
        "name": "计算机",
        "level": 1,
        "parentId": "ind_root",
        "path": "计算机",
        "sortOrder": 1,
        "children": [
          {
            "id": "ind_100",
            "name": "Python",
            "level": 2,
            "parentId": "ind_1",
            "path": "计算机 > Python",
            "sortOrder": 1,
            "children": []
          }
        ]
      }
    ]
  }
}
```

#### 3.1.2 创建行业分类

```http
POST /api/course-category/industry
```

**Request Body**:
```json
{
  "name": "Python",
  "parentId": "ind_1",
  "sortOrder": 1,
  "icon": "https://example.com/icon.png",
  "description": "Python编程相关课程"
}
```

**Response 201**:
```json
{
  "code": 201,
  "message": "创建成功",
  "data": {
    "id": "ind_100",
    "name": "Python",
    "parentId": "ind_1",
    "level": 2,
    "path": "计算机 > Python",
    "sortOrder": 1,
    "icon": "https://example.com/icon.png",
    "description": "Python编程相关课程",
    "isActive": true,
    "createdAt": "2024-01-15T10:30:00Z",
    "updatedAt": "2024-01-15T10:30:00Z"
  }
}
```

#### 3.1.3 更新行业分类

```http
PUT /api/course-category/industry/{id}
```

**Request Body**:
```json
{
  "name": "Python高级",
  "sortOrder": 2,
  "description": "Python高级编程课程",
  "isActive": true
}
```

**Response 200**:
```json
{
  "code": 200,
  "message": "更新成功",
  "data": {
    "id": "ind_100",
    "name": "Python高级",
    "level": 2,
    "path": "计算机 > Python高级",
    "sortOrder": 2,
    "description": "Python高级编程课程",
    "isActive": true,
    "updatedAt": "2024-01-20T14:25:00Z"
  }
}
```

#### 3.1.4 删除行业分类

```http
DELETE /api/course-category/industry/{id}
```

**Response 200**:
```json
{
  "code": 200,
  "message": "删除成功"
}
```

**Error Response 400**:
```json
{
  "code": 400,
  "message": "该分类下有子分类，无法删除",
  "data": null
}
```

#### 3.1.5 获取子分类列表

```http
GET /api/course-category/industry/{parentId}/children
```

**Response 200**:
```json
{
  "code": 200,
  "message": "success",
  "data": [
    {
      "id": "ind_100",
      "name": "Python",
      "level": 2,
      "parentId": "ind_1",
      "path": "计算机 > Python",
      "sortOrder": 1,
      "isActive": true,
      "hasChildren": true
    }
  ]
}
```

### 3.2 课程形式分类接口

#### 3.2.1 获取形式分类树

```http
GET /api/course-category/format/tree
```

**Response 200**:
```json
{
  "code": 200,
  "message": "success",
  "data": {
    "categories": [
      {
        "id": "fmt_1",
        "name": "预录",
        "level": 1,
        "children": [
          {
            "id": "fmt_100",
            "name": "视频",
            "level": 2,
            "path": "预录 > 视频"
          }
        ]
      }
    ]
  }
}
```

#### 3.2.2 创建形式分类

```http
POST /api/course-category/format
```

**Request Body**:
```json
{
  "name": "视频",
  "parentId": "fmt_1",
  "sortOrder": 1
}
```

### 3.3 课程类型分类接口

#### 3.3.1 获取类型分类列表

```http
GET /api/course-category/type/list
```

**Response 200**:
```json
{
  "code": 200,
  "message": "success",
  "data": [
    {
      "id": "type_1",
      "name": "单课",
      "level": 1,
      "path": "单课",
      "sortOrder": 1,
      "isActive": true
    },
    {
      "id": "type_2",
      "name": "套课",
      "level": 1,
      "path": "套课",
      "sortOrder": 2,
      "isActive": true
    }
  ]
}
```

## 四、数据验证规则

### 4.1 分类名称验证

```json
{
  "validation": {
    "name": {
      "required": true,
      "minLength": 1,
      "maxLength": 50,
      "pattern": "^[\\u4e00-\\u9fa5a-zA-Z0-9\\s]+$",
      "message": "分类名称只能包含中文、英文、数字和空格"
    }
  }
}
```

### 4.2 层级限制

```json
{
  "validation": {
    "industryCategory": {
      "maxLevel": 4,
      "message": "行业分类最多支持4级"
    },
    "formatCategory": {
      "maxLevel": 2,
      "message": "课程形式分类最多支持2级"
    },
    "typeCategory": {
      "maxLevel": 2,
      "message": "课程类型分类最多支持2级"
    }
  }
}
```

### 4.3 删除限制

```json
{
  "businessRules": {
    "deleteRestriction": {
      "hasChildren": "如果分类下有子分类，则不允许删除",
      "hasCourses": "如果分类下有课程，则不允许删除",
      "suggestion": "需要先删除或移动子分类/课程后才能删除父分类"
    }
  }
}
```

## 五、错误码定义

```json
{
  "errorCodes": {
    "CATEGORY_NOT_FOUND": {
      "code": 40001,
      "message": "分类不存在"
    },
    "CATEGORY_NAME_DUPLICATE": {
      "code": 40002,
      "message": "同级分类名称已存在"
    },
    "CATEGORY_LEVEL_EXCEEDED": {
      "code": 40003,
      "message": "分类层级超过限制"
    },
    "CATEGORY_HAS_CHILDREN": {
      "code": 40004,
      "message": "该分类下有子分类，无法删除"
    },
    "CATEGORY_HAS_COURSES": {
      "code": 40005,
      "message": "该分类下有课程，无法删除"
    },
    "PARENT_CATEGORY_NOT_FOUND": {
      "code": 40006,
      "message": "父分类不存在"
    },
    "INVALID_SORT_ORDER": {
      "code": 40007,
      "message": "排序序号无效"
    }
  }
}
```

## 六、使用示例

### 6.1 前端使用示例（Dart/Flutter）

```dart
// 获取行业分类树
Future<List<IndustryCategory>> getIndustryTree() async {
  final response = await http.get(
    Uri.parse('$baseUrl/api/course-category/industry/tree'),
  );

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    return IndustryCategoryTree.fromJson(data['data']).children;
  }
  throw Exception('Failed to load industry categories');
}

// 创建分类
Future<IndustryCategory> createCategory(CreateCategoryRequest request) async {
  final response = await http.post(
    Uri.parse('$baseUrl/api/course-category/industry'),
    headers: {'Content-Type': 'application/json'},
    body: json.encode(request.toJson()),
  );

  if (response.statusCode == 201) {
    final data = json.decode(response.body);
    return IndustryCategory.fromJson(data['data']);
  }
  throw Exception('Failed to create category');
}
```

### 6.2 后端使用示例（Node.js/Express）

```javascript
// 获取分类树
router.get('/api/course-category/industry/tree', async (req, res) => {
  try {
    const includeInactive = req.query.includeInactive === 'true';
    const tree = await IndustryCategoryService.getTree(includeInactive);
    res.json({
      code: 200,
      message: 'success',
      data: tree
    });
  } catch (error) {
    res.status(500).json({
      code: 500,
      message: error.message,
      data: null
    });
  }
});

// 创建分类
router.post('/api/course-category/industry', async (req, res) => {
  try {
    const dto = new CreateIndustryCategoryDto(req.body);
    await dto.validate();

    const category = await IndustryCategoryService.create(dto);

    res.status(201).json({
      code: 201,
      message: '创建成功',
      data: category
    });
  } catch (error) {
    if (error.code === 'CATEGORY_NAME_DUPLICATE') {
      res.status(400).json({
        code: 40002,
        message: '同级分类名称已存在',
        data: null
      });
    } else {
      res.status(500).json({
        code: 500,
        message: error.message,
        data: null
      });
    }
  }
});
```

## 七、数据库表结构建议

### 7.1 行业分类表（industry_categories）

```sql
CREATE TABLE industry_categories (
  id VARCHAR(50) PRIMARY KEY,
  name VARCHAR(50) NOT NULL,
  parent_id VARCHAR(50),
  level INT NOT NULL CHECK (level >= 1 AND level <= 4),
  path VARCHAR(500) NOT NULL,
  sort_order INT NOT NULL DEFAULT 0,
  icon VARCHAR(500),
  description TEXT,
  is_active BOOLEAN NOT NULL DEFAULT TRUE,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

  INDEX idx_parent_id (parent_id),
  INDEX idx_level (level),
  INDEX idx_is_active (is_active),
  UNIQUE KEY uk_name_parent_level (name, parent_id, level)
);
```

### 7.2 课程形式分类表（format_categories）

```sql
CREATE TABLE format_categories (
  id VARCHAR(50) PRIMARY KEY,
  name VARCHAR(50) NOT NULL,
  parent_id VARCHAR(50),
  level INT NOT NULL CHECK (level >= 1 AND level <= 2),
  path VARCHAR(200) NOT NULL,
  sort_order INT NOT NULL DEFAULT 0,
  icon VARCHAR(500),
  is_active BOOLEAN NOT NULL DEFAULT TRUE,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

  INDEX idx_parent_id (parent_id),
  INDEX idx_level (level)
);
```

### 7.3 课程类型分类表（type_categories）

```sql
CREATE TABLE type_categories (
  id VARCHAR(50) PRIMARY KEY,
  name VARCHAR(50) NOT NULL,
  parent_id VARCHAR(50),
  level INT NOT NULL CHECK (level >= 1 AND level <= 2),
  path VARCHAR(200) NOT NULL,
  sort_order INT NOT NULL DEFAULT 0,
  icon VARCHAR(500),
  is_active BOOLEAN NOT NULL DEFAULT TRUE,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);
```

## 八、性能优化建议

### 8.1 缓存策略

- 分类树结构变化不频繁，建议缓存1小时
- 使用Redis缓存热门分类的子分类列表

### 8.2 查询优化

- 使用索引加速父节点查询
- 批量查询时使用IN语句
- 避免N+1查询问题，使用JOIN或批量查询

### 8.3 数据预加载

- 应用启动时预加载所有分类数据
- 定时刷新缓存（如每5分钟）
