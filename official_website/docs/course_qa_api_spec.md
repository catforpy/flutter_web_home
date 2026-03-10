# 课程问答管理 API 数据结构文档

## 一、概述

本文档定义课程问答管理系统的完整数据结构，用于前后端API交互。

**核心设计理念**：
- 课前问答：购买前的咨询，回答者=客服或讲师
- 课后问答：学习过程中的问题，回答者=只有讲师
- 两者都以课程为主体展示

## 二、数据模型定义

### 2.1 问题模型（Question）

```json
{
  "Question": {
    "description": "课程问答问题模型",
    "fields": {
      "id": {
        "type": "String",
        "description": "问题ID",
        "example": "q_1234567890",
        "required": true
      },
      "courseId": {
        "type": "String",
        "description": "课程ID",
        "example": "course_python_001",
        "required": true
      },
      "courseName": {
        "type": "String",
        "description": "课程名称（冗余字段，便于查询）",
        "example": "Python全栈开发实战",
        "required": true
      },
      "qaType": {
        "type": "QAType",
        "description": "问答类型",
        "enum": ["pre_course", "post_course"],
        "example": "pre_course",
        "required": true
      },
      "userId": {
        "type": "String",
        "description": "提问用户ID",
        "example": "u_1234567890",
        "required": true
      },
      "userName": {
        "type": "String",
        "description": "提问用户名",
        "example": "学员A",
        "required": true,
        "maxLength": 50
      },
      "userAvatar": {
        "type": "String",
        "description": "提问用户头像",
        "example": "https://example.com/avatars/user_a.jpg",
        "required": true
      },
      "title": {
        "type": "String",
        "description": "问题标题",
        "example": "这个课程适合零基础吗？",
        "required": true,
        "maxLength": 200
      },
      "content": {
        "type": "String",
        "description": "问题内容",
        "example": "我想学Python，但是没有任何编程基础，这个课程能跟上吗？",
        "required": true,
        "maxLength": 2000
      },
      "askTime": {
        "type": "DateTime",
        "description": "提问时间",
        "example": "2024-03-09T08:30:00Z",
        "required": true
      },
      "isResolved": {
        "type": "boolean",
        "description": "是否已解决",
        "example": false,
        "required": true,
        "default": false
      },
      "answererType": {
        "type": "AnswererType?",
        "description": "回答人类型（已回答后才有值）",
        "enum": ["customer_service", "instructor"],
        "example": "instructor",
        "required": false
      },
      "answererId": {
        "type": "String?",
        "description": "回答人ID",
        "example": "ins_1234567890",
        "required": false
      },
      "answererName": {
        "type": "String?",
        "description": "回答人姓名",
        "example": "张三",
        "required": false,
        "maxLength": 50
      },
      "answerTime": {
        "type": "DateTime?",
        "description": "回答时间",
        "example": "2024-03-09T09:15:00Z",
        "required": false
      },
      "answerContent": {
        "type": "String?",
        "description": "回答内容",
        "example": "本课程专门为零基础学员设计...",
        "required": false,
        "maxLength": 5000
      },
      "likes": {
        "type": "int",
        "description": "点赞数",
        "example": 23,
        "required": true,
        "minimum": 0,
        "default": 0
      },
      "createdAt": {
        "type": "DateTime",
        "description": "创建时间",
        "example": "2024-03-09T08:30:00Z",
        "required": true
      },
      "updatedAt": {
        "type": "DateTime",
        "description": "更新时间",
        "example": "2024-03-09T09:15:00Z",
        "required": true
      }
    }
  }
}
```

### 2.2 课程问答统计模型（CourseQAStats）

```json
{
  "CourseQAStats": {
    "description": "课程问答统计（以课程为主体）",
    "fields": {
      "courseId": {
        "type": "String",
        "description": "课程ID",
        "example": "course_python_001",
        "required": true
      },
      "courseName": {
        "type": "String",
        "description": "课程名称",
        "example": "Python全栈开发实战",
        "required": true
      },
      "instructorId": {
        "type": "String",
        "description": "讲师ID",
        "example": "ins_1234567890",
        "required": true
      },
      "instructorName": {
        "type": "String",
        "description": "讲师姓名",
        "example": "张三",
        "required": true,
        "maxLength": 50
      },
      "instructorAvatar": {
        "type": "String",
        "description": "讲师头像",
        "example": "https://example.com/avatars/zhang_san.jpg",
        "required": true
      },
      "industryCategory": {
        "type": "String?",
        "description": "行业分类路径",
        "example": "计算机 > Python",
        "required": false
      },
      "formatCategory": {
        "type": "String?",
        "description": "课程形式分类路径",
        "example": "预录 > 视频",
        "required": false
      },
      "typeCategory": {
        "type": "String?",
        "description": "课程类型分类",
        "example": "单课",
        "required": false
      },
      "courseStatus": {
        "type": "CourseStatus",
        "description": "课程状态",
        "enum": ["presale", "in_production", "completed"],
        "example": "completed",
        "required": true
      },
      "followerCount": {
        "type": "int",
        "description": "关注人数",
        "example": 1234,
        "required": true,
        "minimum": 0
      },
      "studentCount": {
        "type": "int",
        "description": "学生人数",
        "example": 5678,
        "required": true,
        "minimum": 0
      },
      "totalQuestions": {
        "type": "int",
        "description": "问题总数",
        "example": 45,
        "required": true,
        "minimum": 0
      },
      "resolvedCount": {
        "type": "int",
        "description": "已解决数量",
        "example": 42,
        "required": true,
        "minimum": 0
      },
      "pendingCount": {
        "type": "int",
        "description": "待解决数量",
        "example": 3,
        "required": true,
        "minimum": 0
      },
      "averageRating": {
        "type": "double",
        "description": "课程评分",
        "example": 4.8,
        "required": true,
        "minimum": 1,
        "maximum": 5
      },
      "createdAt": {
        "type": "DateTime",
        "description": "课程创建时间",
        "example": "2024-01-15T10:30:00Z",
        "required": true
      }
    }
  }
}
```

### 2.3 枚举类型定义

```json
{
  "QAType": {
    "description": "问答类型",
    "values": [
      {
        "value": "pre_course",
        "label": "课前问答",
        "description": "用户购买课程前提出的问题",
        "answererTypes": ["customer_service", "instructor"]
      },
      {
        "value": "post_course",
        "label": "课后问答",
        "description": "学习过程中提出的问题",
        "answererTypes": ["instructor"]
      }
    ]
  },
  "CourseStatus": {
    "description": "课程状态",
    "values": [
      {
        "value": "presale",
        "label": "预售",
        "color": "#FFA500"
      },
      {
        "value": "in_production",
        "label": "制作中",
        "color": "#FF4D4F"
      },
      {
        "value": "completed",
        "label": "完结",
        "color": "#52C41A"
      }
    ]
  },
  "AnswererType": {
    "description": "回答人类型",
    "values": [
      {
        "value": "customer_service",
        "label": "客服",
        "icon": "📝",
        "color": "#1890FF"
      },
      {
        "value": "instructor",
        "label": "讲师",
        "icon": "👨‍🏫",
        "color": "#1A9B8E"
      }
    ]
  }
}
```

## 三、API 接口定义

### 3.1 课前问答接口

#### 3.1.1 获取课前问答课程列表

```http
GET /api/course-qa/pre-course/courses
```

**Query Parameters**:
```json
{
  "page": {
    "type": "int",
    "description": "页码",
    "default": 1,
    "minimum": 1
  },
  "pageSize": {
    "type": "int",
    "description": "每页数量",
    "default": 10,
    "minimum": 1,
    "maximum": 100
  },
  "keyword": {
    "type": "string",
    "description": "搜索关键词（课程名称或讲师姓名）",
    "example": "Python"
  },
  "industryCategory": {
    "type": "string",
    "description": "行业分类筛选",
    "example": "计算机 > Python"
  },
  "formatCategory": {
    "type": "string",
    "description": "课程形式筛选",
    "example": "预录 > 视频"
  },
  "typeCategory": {
    "type": "string",
    "description": "课程类型筛选",
    "example": "单课"
  },
  "courseStatus": {
    "type": "string",
    "description": "课程状态筛选",
    "enum": ["presale", "in_production", "completed"]
  },
  "sortBy": {
    "type": "string",
    "description": "排序字段",
    "enum": ["createTime", "studentCount", "followerCount", "questionCount", "rating"],
    "default": "questionCount"
  },
  "sortOrder": {
    "type": "string",
    "description": "排序方向",
    "enum": ["asc", "desc"],
    "default": "desc"
  }
}
```

**Response 200**:
```json
{
  "code": 200,
  "message": "success",
  "data": {
    "total": 15,
    "page": 1,
    "pageSize": 10,
    "totalPages": 2,
    "items": [
      {
        "courseId": "course_python_001",
        "courseName": "Python全栈开发实战",
        "instructorId": "ins_1234567890",
        "instructorName": "张三",
        "instructorAvatar": "https://example.com/avatars/zhang_san.jpg",
        "industryCategory": "计算机 > Python",
        "formatCategory": "预录 > 视频",
        "typeCategory": "单课",
        "courseStatus": "completed",
        "followerCount": 1234,
        "studentCount": 5678,
        "totalQuestions": 12,
        "resolvedCount": 8,
        "pendingCount": 4,
        "averageRating": 4.8,
        "createdAt": "2024-01-15T10:30:00Z"
      }
    ]
  }
}
```

#### 3.1.2 获取课程问答详情

```http
GET /api/course-qa/pre-course/courses/{courseId}/questions
```

**Query Parameters**:
```json
{
  "page": {
    "type": "int",
    "default": 1
  },
  "pageSize": {
    "type": "int",
    "default": 20
  },
  "isResolved": {
    "type": "boolean?",
    "description": "筛选解决状态（null=全部）",
    "example": false
  },
  "sortBy": {
    "type": "string",
    "enum": ["askTime", "likes", "answerTime"],
    "default": "askTime"
  },
  "sortOrder": {
    "type": "string",
    "enum": ["asc", "desc"],
    "default": "desc"
  }
}
```

**Response 200**:
```json
{
  "code": 200,
  "message": "success",
  "data": {
    "courseInfo": {
      "courseId": "course_python_001",
      "courseName": "Python全栈开发实战",
      "instructorName": "张三",
      "instructorAvatar": "https://example.com/avatars/zhang_san.jpg",
      "courseStatus": "completed",
      "followerCount": 1234,
      "studentCount": 5678,
      "totalQuestions": 12,
      "resolvedCount": 8,
      "pendingCount": 4,
      "averageRating": 4.8
    },
    "questions": {
      "total": 12,
      "page": 1,
      "pageSize": 20,
      "items": [
        {
          "id": "q_1234567890",
          "courseId": "course_python_001",
          "courseName": "Python全栈开发实战",
          "qaType": "pre_course",
          "userId": "u_1234567890",
          "userName": "学员A",
          "userAvatar": "https://example.com/avatars/user_a.jpg",
          "title": "这个课程适合零基础吗？",
          "content": "我想学Python，但是没有任何编程基础，这个课程能跟上吗？",
          "askTime": "2024-03-09T08:30:00Z",
          "isResolved": true,
          "answererType": "instructor",
          "answererId": "ins_1234567890",
          "answererName": "张三",
          "answerTime": "2024-03-09T09:15:00Z",
          "answerContent": "本课程专门为零基础学员设计，会从Python基础语法开始讲起...",
          "likes": 23,
          "createdAt": "2024-03-09T08:30:00Z",
          "updatedAt": "2024-03-09T09:15:00Z"
        }
      ]
    }
  }
}
```

#### 3.1.3 回复问题

```http
POST /api/course-qa/questions/{questionId}/answer
```

**Request Body**:
```json
{
  "answererType": "instructor",
  "answererId": "ins_1234567890",
  "content": "本课程专门为零基础学员设计，会从Python基础语法开始讲起，不需要有任何编程基础..."
}
```

**Response 200**:
```json
{
  "code": 200,
  "message": "回复成功",
  "data": {
    "id": "q_1234567890",
    "isResolved": true,
    "answererType": "instructor",
    "answererId": "ins_1234567890",
    "answererName": "张三",
    "answerTime": "2024-03-09T10:30:00Z",
    "answerContent": "本课程专门为零基础学员设计...",
    "updatedAt": "2024-03-09T10:30:00Z"
  }
}
```

### 3.2 课后问答接口

#### 3.2.1 获取课后问答课程列表

```http
GET /api/course-qa/post-course/courses
```

**Query Parameters**: 与课前问答相同

**Response 200**: 与课前问答相同

#### 3.2.2 获取课程问答详情

```http
GET /api/course-qa/post-course/courses/{courseId}/questions
```

**Query Parameters**: 与课前问答相同

**Response 200**: 结构相同，只是回答者都是讲师

### 3.3 通用接口

#### 3.3.1 点赞问题

```http
POST /api/course-qa/questions/{questionId}/like
```

**Response 200**:
```json
{
  "code": 200,
  "message": "点赞成功",
  "data": {
    "questionId": "q_1234567890",
    "likes": 24
  }
}
```

#### 3.3.2 取消点赞

```http
DELETE /api/course-qa/questions/{questionId}/like
```

#### 3.3.3 标记问题已解决

```http
PUT /api/course-qa/questions/{questionId}/resolve
```

**Request Body**:
```json
{
  "resolved": true
}
```

**Response 200**:
```json
{
  "code": 200,
  "message": "操作成功",
  "data": {
    "questionId": "q_1234567890",
    "isResolved": true,
    "resolvedAt": "2024-03-09T10:30:00Z"
  }
}
```

## 四、完整数据示例

### 4.1 课前问答完整示例

```json
{
  "example": {
    "courseQAStats": {
      "courseId": "course_python_001",
      "courseName": "Python全栈开发实战",
      "instructorId": "ins_1234567890",
      "instructorName": "张三",
      "instructorAvatar": "https://example.com/avatars/zhang_san.jpg",
      "industryCategory": "计算机 > Python",
      "formatCategory": "预录 > 视频",
      "typeCategory": "单课",
      "courseStatus": "completed",
      "followerCount": 1234,
      "studentCount": 5678,
      "totalQuestions": 12,
      "resolvedCount": 8,
      "pendingCount": 4,
      "averageRating": 4.8
    },
    "questions": [
      {
        "id": "q_1",
        "courseId": "course_python_001",
        "courseName": "Python全栈开发实战",
        "qaType": "pre_course",
        "userId": "u_1",
        "userName": "学员A",
        "userAvatar": "https://example.com/avatars/user_a.jpg",
        "title": "这个课程适合零基础吗？",
        "content": "我想学Python，但是没有任何编程基础...",
        "askTime": "2024-03-09T08:30:00Z",
        "isResolved": true,
        "answererType": "customer_service",
        "answererId": "cs_001",
        "answererName": "客服小王",
        "answerTime": "2024-03-09T09:00:00Z",
        "answerContent": "您好！这个课程非常适合零基础学员...",
        "likes": 15
      },
      {
        "id": "q_2",
        "courseId": "course_python_001",
        "courseName": "Python全栈开发实战",
        "qaType": "pre_course",
        "userId": "u_2",
        "userName": "学员B",
        "userAvatar": "https://example.com/avatars/user_b.jpg",
        "title": "课程有优惠吗？",
        "content": "想报名学习，请问有什么优惠活动吗？",
        "askTime": "2024-03-09T10:00:00Z",
        "isResolved": true,
        "answererType": "customer_service",
        "answererId": "cs_001",
        "answererName": "客服小王",
        "answerTime": "2024-03-09T10:05:00Z",
        "answerContent": "目前新用户首单立减100元...",
        "likes": 8
      }
    ]
  }
}
```

### 4.2 课后问答完整示例

```json
{
  "example": {
    "courseQAStats": {
      "courseId": "course_python_001",
      "courseName": "Python全栈开发实战",
      "instructorId": "ins_1234567890",
      "instructorName": "张三",
      "instructorAvatar": "https://example.com/avatars/zhang_san.jpg",
      "industryCategory": "计算机 > Python",
      "formatCategory": "预录 > 视频",
      "typeCategory": "单课",
      "courseStatus": "completed",
      "followerCount": 1234,
      "studentCount": 5678,
      "totalQuestions": 45,
      "resolvedCount": 42,
      "pendingCount": 3,
      "averageRating": 4.8
    },
    "questions": [
      {
        "id": "q_100",
        "courseId": "course_python_001",
        "courseName": "Python全栈开发实战",
        "qaType": "post_course",
        "userId": "u_100",
        "userName": "学员A",
        "userAvatar": "https://example.com/avatars/user_a.jpg",
        "title": "这个装饰器怎么用？",
        "content": "在第5章学习装饰器时遇到了问题，代码总是报错...",
        "askTime": "2024-03-09T08:30:00Z",
        "isResolved": true,
        "answererType": "instructor",
        "answererId": "ins_1234567890",
        "answererName": "张三",
        "answerTime": "2024-03-09T09:15:00Z",
        "answerContent": "装饰器是Python的高级特性，理解起来确实有难度...",
        "likes": 56
      },
      {
        "id": "q_101",
        "courseId": "course_python_001",
        "courseName": "Python全栈开发实战",
        "qaType": "post_course",
        "userId": "u_101",
        "userName": "学员B",
        "userAvatar": "https://example.com/avatars/user_b.jpg",
        "title": "环境配置问题",
        "content": "按照课程文档配置环境，但是运行时出现ModuleNotFoundError...",
        "askTime": "2024-03-09T10:00:00Z",
        "isResolved": false,
        "answererType": null,
        "answererId": null,
        "answererName": null,
        "answerTime": null,
        "answerContent": null,
        "likes": 0
      }
    ]
  }
}
```

## 五、数据验证规则

### 5.1 问题验证

```json
{
  "validation": {
    "title": {
      "required": true,
      "minLength": 5,
      "maxLength": 200
    },
    "content": {
      "required": true,
      "minLength": 10,
      "maxLength": 2000
    },
    "answerContent": {
      "required": false,
      "minLength": 10,
      "maxLength": 5000
    }
  }
}
```

### 5.2 业务规则验证

```json
{
  "businessRules": {
    "pre_course_answerer": {
      "rule": "课前问答可以由客服或讲师回答",
      "allowedTypes": ["customer_service", "instructor"]
    },
    "post_course_answerer": {
      "rule": "课后问答只能由讲师回答",
      "allowedTypes": ["instructor"]
    },
    "answer_permission": {
      "rule": "只有指定的客服或讲师才能回答问题",
      "validation": "检查answererId是否有权限回答该问题"
    },
    "resolve_permission": {
      "rule": "只有回答者可以标记问题为已解决",
      "validation": "检查当前用户是否为该问题的回答者"
    }
  }
}
```

## 六、错误码定义

```json
{
  "errorCodes": {
    "QUESTION_NOT_FOUND": {
      "code": 50101,
      "message": "问题不存在"
    },
    "COURSE_NOT_FOUND": {
      "code": 50102,
      "message": "课程不存在"
    },
    "UNAUTHORIZED_ANSWER": {
      "code": 50103,
      "message": "无权限回答该问题"
    },
    "ANSWER_ALREADY_EXISTS": {
      "code": 50104,
      "message": "该问题已被回答，无法重复回答"
    },
    "INVALID_ANSWERER": {
      "code": 50105,
      "message": "课后问答只能由讲师回答"
    },
    "CANNOT_RESOLVE_UNANSWERED": {
      "code": 50106,
      "message": "未回答的问题无法标记为已解决"
    },
    "LIKE_OWN_QUESTION": {
      "code": 50107,
      "message": "不能给自己的问题点赞"
    }
  }
}
```

## 七、数据库表结构建议

### 7.1 课程表（courses）- 简化版本

```sql
CREATE TABLE courses (
  id VARCHAR(50) PRIMARY KEY,
  name VARCHAR(200) NOT NULL,
  instructor_id VARCHAR(50) NOT NULL,
  industry_category_id VARCHAR(50),
  format_category_id VARCHAR(50),
  type_category_id VARCHAR(50),
  status ENUM('presale', 'in_production', 'completed') NOT NULL,
  follower_count INT NOT NULL DEFAULT 0,
  student_count INT NOT NULL DEFAULT 0,
  average_rating DECIMAL(2,1) NOT NULL DEFAULT 0,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

  INDEX idx_instructor_id (instructor_id),
  INDEX idx_status (status),
  INDEX idx_student_count (student_count),
  INDEX idx_average_rating (average_rating)
);
```

### 7.2 问题表（questions）

```sql
CREATE TABLE questions (
  id VARCHAR(50) PRIMARY KEY,
  course_id VARCHAR(50) NOT NULL,
  qa_type ENUM('pre_course', 'post_course') NOT NULL,
  user_id VARCHAR(50) NOT NULL,
  user_name VARCHAR(50) NOT NULL,
  user_avatar VARCHAR(500) NOT NULL,
  title VARCHAR(200) NOT NULL,
  content TEXT NOT NULL,
  ask_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  is_resolved BOOLEAN NOT NULL DEFAULT FALSE,
  answerer_type ENUM('customer_service', 'instructor'),
  answerer_id VARCHAR(50),
  answerer_name VARCHAR(50),
  answer_time TIMESTAMP NULL,
  answer_content TEXT,
  likes INT NOT NULL DEFAULT 0,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

  INDEX idx_course_id (course_id),
  INDEX idx_qa_type (qa_type),
  INDEX idx_user_id (user_id),
  INDEX idx_is_resolved (is_resolved),
  INDEX idx_ask_time (ask_time),
  INDEX idx_answerer_id (answerer_id),
  FOREIGN KEY (course_id) REFERENCES courses(id) ON DELETE CASCADE
);
```

### 7.3 问题分类关联表（question_categories）

```sql
CREATE TABLE question_categories (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  question_id VARCHAR(50) NOT NULL,
  category_type ENUM('industry', 'format', 'type') NOT NULL,
  category_id VARCHAR(50) NOT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

  UNIQUE KEY uk_question_category_type (question_id, category_type),
  INDEX idx_question_id (question_id),
  FOREIGN KEY (question_id) REFERENCES questions(id) ON DELETE CASCADE
);
```

## 八、性能优化建议

### 8.1 统计数据实时计算

- 问题总数、已解决数、待解决数建议使用COUNT聚合实时计算
- 可以考虑添加缓存字段定期更新

### 8.2 搜索优化

- 对问题标题和内容建立全文索引
- 课程名称和讲师姓名建立索引

### 8.3 分页优化

- 使用游标分页提升深度翻页性能
- 限制最大分页数量为100

### 8.4 实时通知

- 问题被回答时发送通知给提问用户
- 新问题通知讲师/客服

## 九、使用示例

### 9.1 前端使用示例（Dart/Flutter）

```dart
// 获取课前问答课程列表
Future<CourseQAListResponse> getPreCourseCourses({
  int page = 1,
  int pageSize = 10,
  String? keyword,
  String? industryCategory,
  String? courseStatus,
}) async {
  final queryParams = {
    'page': page.toString(),
    'pageSize': pageSize.toString(),
    if (keyword != null) 'keyword': keyword,
    if (industryCategory != null) 'industryCategory': industryCategory,
    if (courseStatus != null) 'courseStatus': courseStatus,
  };

  final response = await http.get(
    Uri.parse('$baseUrl/api/course-qa/pre-course/courses')
        .replace(queryParameters: queryParams),
  );

  if (response.statusCode == 200) {
    return CourseQAListResponse.fromJson(
      json.decode(response.body)['data']
    );
  }
  throw Exception('Failed to load courses');
}

// 回复问题
Future<void> answerQuestion(String questionId, String content) async {
  final response = await http.post(
    Uri.parse('$baseUrl/api/course-qa/questions/$questionId/answer'),
    headers: {'Content-Type': 'application/json'},
    body: json.encode({
      'answererType': 'instructor',
      'answererId': currentUserId,
      'content': content,
    }),
  );

  if (response.statusCode != 200) {
    throw Exception('Failed to answer question');
  }
}
```

### 9.2 后端使用示例（Node.js/Express）

```javascript
// 获取课前问答课程列表
router.get('/api/course-qa/pre-course/courses', async (req, res) => {
  try {
    const {
      page = 1,
      pageSize = 10,
      keyword,
      industryCategory,
      courseStatus,
      sortBy = 'questionCount',
      sortOrder = 'desc'
    } = req.query;

    const result = await CourseQAService.getPreCourseCourses({
      page: parseInt(page),
      pageSize: parseInt(pageSize),
      keyword,
      industryCategory,
      courseStatus,
      sortBy,
      sortOrder
    });

    res.json({
      code: 200,
      message: 'success',
      data: result
    });
  } catch (error) {
    res.status(500).json({
      code: 500,
      message: error.message,
      data: null
    });
  }
});

// 回复问题
router.post('/api/course-qa/questions/:questionId/answer', async (req, res) => {
  try {
    const { questionId } = req.params;
    const { answererType, answererId, content } = req.body;

    // 验证权限
    const hasPermission = await QuestionService.checkAnswerPermission(
      questionId,
      answererType,
      answererId
    );

    if (!hasPermission) {
      return res.status(403).json({
        code: 403,
        message: '无权限回答该问题',
        data: null
      });
    }

    // 创建回答
    const result = await QuestionService.answerQuestion(
      questionId,
      answererType,
      answererId,
      content
    );

    res.json({
      code: 200,
      message: '回复成功',
      data: result
    });
  } catch (error) {
    if (error.code === 'ANSWER_ALREADY_EXISTS') {
      res.status(400).json({
        code: 50104,
        message: '该问题已被回答，无法重复回答',
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

## 十、前端调用示例

### 10.1 Tab切换组件

```dart
class CourseQAPage extends StatefulWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          TabBar(
            tabs: [
              Tab(text: '课前问答'),
              Tab(text: '课后问答'),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                _PreCourseQAPage(),
                _PostCourseQAPage(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
```

### 10.2 课程列表组件

```dart
class _PreCourseQAPage extends StatefulWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildSearchArea(),
        _buildCourseList(),
      ],
    );
  }

  Widget _buildCourseList() {
    return FutureBuilder<CourseQAListResponse>(
      future: _loadCourses(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        final data = snapshot.data!;

        return ListView.builder(
          itemCount: data.items.length,
          itemBuilder: (context, index) {
            final course = data.items[index];
            return _buildCourseCard(course);
          },
        );
      },
    );
  }
}
```
