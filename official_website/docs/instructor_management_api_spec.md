# 讲师管理 API 数据结构文档

## 一、概述

本文档定义讲师管理系统的完整数据结构，用于前后端API交互。

## 二、数据模型定义

### 2.1 讲师基本信息模型

```json
{
  "Instructor": {
    "description": "讲师信息模型",
    "fields": {
      "id": {
        "type": "String",
        "description": "讲师ID，唯一标识",
        "example": "ins_1234567890",
        "required": true
      },
      "name": {
        "type": "String",
        "description": "讲师姓名",
        "example": "张三",
        "required": true,
        "maxLength": 50
      },
      "avatar": {
        "type": "String",
        "description": "头像URL",
        "example": "https://example.com/avatars/instructor_123.jpg",
        "required": true,
        "format": "uri"
      },
      "bio": {
        "type": "String",
        "description": "讲师简介",
        "example": "资深Python讲师，10年开发经验...",
        "required": true,
        "maxLength": 2000
      },
      "subjects": {
        "type": "array<String>",
        "description": "学科标签列表",
        "example": ["计算机", "Python", "人工智能"],
        "required": true,
        "minItems": 1
      },
      "registerTime": {
        "type": "DateTime",
        "description": "注册时间",
        "example": "2023-01-15T10:30:00Z",
        "required": true
      },
      "status": {
        "type": "InstructorStatus",
        "description": "登录状态",
        "example": "online",
        "required": true
      },
      "cooperationMode": {
        "type": "CooperationMode",
        "description": "合作模式",
        "example": "partner",
        "required": true
      },
      "lastLoginTime": {
        "type": "DateTime?",
        "description": "最近登录时间",
        "example": "2024-03-09T08:30:00Z",
        "required": false
      },
      "qualifications": {
        "type": "array<QualificationCertificate>",
        "description": "资质证书列表",
        "example": [],
        "required": true,
        "default": []
      }
    }
  }
}
```

### 2.2 讲师统计数据模型

```json
{
  "InstructorStatistics": {
    "description": "讲师统计数据",
    "fields": {
      "instructorId": {
        "type": "String",
        "description": "讲师ID",
        "required": true
      },
      "studentCount": {
        "type": "int",
        "description": "学生数量",
        "example": 1234,
        "required": true,
        "minimum": 0
      },
      "followerCount": {
        "type": "int",
        "description": "关注数量",
        "example": 5678,
        "required": true,
        "minimum": 0
      },
      "questionAnswerRate": {
        "type": "double",
        "description": "问答率（0-1）",
        "example": 0.92,
        "required": true,
        "minimum": 0,
        "maximum": 1
      },
      "courseLikeRate": {
        "type": "double",
        "description": "课程点赞率（0-1）",
        "example": 0.87,
        "required": true,
        "minimum": 0,
        "maximum": 1
      },
      "courseShareRate": {
        "type": "double",
        "description": "课程转发率（0-1）",
        "example": 0.65,
        "required": true,
        "minimum": 0,
        "maximum": 1
      },
      "averageRating": {
        "type": "double",
        "description": "平均评分（1-5）",
        "example": 4.8,
        "required": true,
        "minimum": 1,
        "maximum": 5
      },
      "reservedCourseCount": {
        "type": "int",
        "description": "预购课程数量",
        "example": 5,
        "required": true,
        "minimum": 0
      },
      "completedCourseCount": {
        "type": "int",
        "description": "已完结课程数量",
        "example": 23,
        "required": true,
        "minimum": 0
      }
    }
  }
}
```

### 2.3 课程统计模型

```json
{
  "CourseStatistics": {
    "description": "课程统计详情",
    "fields": {
      "singleCourses": {
        "type": "int",
        "description": "单课数量",
        "example": 12,
        "required": true,
        "minimum": 0
      },
      "seriesCourses": {
        "type": "int",
        "description": "套课数量",
        "example": 8,
        "required": true,
        "minimum": 0
      },
      "videoCourses": {
        "type": "int",
        "description": "视频数量",
        "example": 5,
        "required": true,
        "minimum": 0
      },
      "liveReplays": {
        "type": "int",
        "description": "直播回放数量",
        "example": 3,
        "required": true,
        "minimum": 0
      }
    }
  }
}
```

### 2.4 收入统计模型

```json
{
  "RevenueStatistics": {
    "description": "收入统计",
    "fields": {
      "weeklyRevenue": {
        "type": "double",
        "description": "最近一周收入",
        "example": 2100.00,
        "required": true,
        "minimum": 0
      },
      "monthlyRevenue": {
        "type": "double",
        "description": "最近一月收入",
        "example": 8900.00,
        "required": true,
        "minimum": 0
      },
      "quarterlyRevenue": {
        "type": "double",
        "description": "最近一季度收入",
        "example": 26700.00,
        "required": true,
        "minimum": 0
      },
      "totalRevenue": {
        "type": "double",
        "description": "总收入",
        "example": 156000.00,
        "required": true,
        "minimum": 0
      }
    }
  }
}
```

### 2.5 资质证书模型

```json
{
  "QualificationCertificate": {
    "description": "资质证书",
    "fields": {
      "id": {
        "type": "String",
        "description": "证书ID",
        "example": "cert_123456",
        "required": true
      },
      "name": {
        "type": "String",
        "description": "证书名称",
        "example": "Python高级开发工程师认证",
        "required": true,
        "maxLength": 100
      },
      "imageUrl": {
        "type": "String",
        "description": "证书图片URL",
        "example": "https://example.com/certificates/python_cert.jpg",
        "required": true,
        "format": "uri"
      },
      "issuingOrganization": {
        "type": "String",
        "description": "颁发机构",
        "example": "中国软件行业协会",
        "required": true,
        "maxLength": 100
      },
      "issueDate": {
        "type": "DateTime",
        "description": "颁发日期",
        "example": "2020-06-15T00:00:00Z",
        "required": true
      },
      "expiryDate": {
        "type": "DateTime?",
        "description": "过期日期，永久有效为null",
        "example": "2025-06-15T00:00:00Z",
        "required": false
      },
      "certificateNumber": {
        "type": "String",
        "description": "证书编号",
        "example": "PY2020100123",
        "required": true,
        "maxLength": 50
      }
    }
  }
}
```

### 2.6 学员评价模型

```json
{
  "StudentReview": {
    "description": "学员评价",
    "fields": {
      "id": {
        "type": "String",
        "description": "评价ID",
        "example": "rev_123456",
        "required": true
      },
      "studentName": {
        "type": "String",
        "description": "学员姓名",
        "example": "学员A",
        "required": true,
        "maxLength": 50
      },
      "content": {
        "type": "String",
        "description": "评价内容",
        "example": "老师讲解非常详细，受益匪浅！",
        "required": true,
        "maxLength": 500
      },
      "rating": {
        "type": "double",
        "description": "评分（1-5）",
        "example": 5.0,
        "required": true,
        "minimum": 1,
        "maximum": 5
      },
      "createTime": {
        "type": "DateTime",
        "description": "评价时间",
        "example": "2024-03-01T10:30:00Z",
        "required": true
      }
    }
  }
}
```

### 2.7 枚举类型定义

```json
{
  "InstructorStatus": {
    "description": "讲师登录状态",
    "values": [
      {
        "value": "online",
        "label": "在线",
        "color": "#52C41A"
      },
      {
        "value": "busy",
        "label": "忙碌",
        "color": "#FF4D4F"
      },
      {
        "value": "offline",
        "label": "离线",
        "color": "#D9D9D9"
      }
    ]
  },
  "CooperationMode": {
    "description": "合作模式",
    "values": [
      {
        "value": "partner",
        "label": "合作模式",
        "color": "#1890FF"
      },
      {
        "value": "lease",
        "label": "租赁模式",
        "color": "#FF7A00"
      }
    ]
  }
}
```

## 三、完整讲师数据示例

```json
{
  "example": {
    "id": "ins_1234567890",
    "name": "张三",
    "avatar": "https://example.com/avatars/zhang_san.jpg",
    "bio": "资深Python讲师，10年开发经验，擅长Python全栈开发、人工智能应用开发。曾服务过多家知名企业，累计培训学员超过1200人。",
    "subjects": ["计算机", "Python", "人工智能"],
    "registerTime": "2023-01-15T10:30:00Z",
    "status": "online",
    "cooperationMode": "partner",
    "lastLoginTime": "2024-03-09T08:30:00Z",
    "studentCount": 1234,
    "followerCount": 5678,
    "questionAnswerRate": 0.92,
    "courseLikeRate": 0.87,
    "courseShareRate": 0.65,
    "averageRating": 4.8,
    "courseStats": {
      "singleCourses": 12,
      "seriesCourses": 8,
      "videoCourses": 5,
      "liveReplays": 3
    },
    "revenueStats": {
      "weeklyRevenue": 2100.00,
      "monthlyRevenue": 8900.00,
      "quarterlyRevenue": 26700.00,
      "totalRevenue": 156000.00
    },
    "reservedCourseCount": 5,
    "completedCourseCount": 23,
    "qualifications": [
      {
        "id": "cert_1",
        "name": "Python高级开发工程师认证",
        "imageUrl": "https://example.com/certs/python_cert.jpg",
        "issuingOrganization": "中国软件行业协会",
        "issueDate": "2020-06-15T00:00:00Z",
        "expiryDate": "2025-06-15T00:00:00Z",
        "certificateNumber": "PY2020100123"
      },
      {
        "id": "cert_2",
        "name": "人工智能算法专家认证",
        "imageUrl": "https://example.com/certs/ai_cert.jpg",
        "issuingOrganization": "国际人工智能联盟",
        "issueDate": "2022-03-20T00:00:00Z",
        "expiryDate": null,
        "certificateNumber": "AI2022001456"
      }
    ],
    "reviews": [
      {
        "id": "rev_1",
        "studentName": "学员A",
        "content": "老师讲解非常详细，受益匪浅！",
        "rating": 5.0,
        "createTime": "2024-03-01T10:30:00Z"
      }
    ]
  }
}
```

## 四、API 接口定义

### 4.1 讲师列表接口

#### 4.1.1 获取讲师列表（分页）

```http
GET /api/instructors
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
    "description": "搜索关键词（讲师姓名或学科）",
    "example": "Python"
  },
  "subject": {
    "type": "string",
    "description": "学科筛选",
    "example": "计算机"
  },
  "status": {
    "type": "string",
    "description": "状态筛选",
    "enum": ["online", "busy", "offline"]
  },
  "cooperationMode": {
    "type": "string",
    "description": "合作模式筛选",
    "enum": ["partner", "lease"]
  },
  "sortBy": {
    "type": "string",
    "description": "排序字段",
    "enum": ["registerTime", "studentCount", "followerCount", "revenue", "rating"],
    "default": "registerTime"
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
    "total": 156,
    "page": 1,
    "pageSize": 10,
    "totalPages": 16,
    "items": [
      {
        "id": "ins_1234567890",
        "name": "张三",
        "avatar": "https://example.com/avatars/zhang_san.jpg",
        "subjects": ["计算机", "Python", "人工智能"],
        "registerTime": "2023-01-15T10:30:00Z",
        "status": "online",
        "cooperationMode": "partner",
        "studentCount": 1234,
        "followerCount": 5678,
        "averageRating": 4.8,
        "courseStats": {
          "total": 28,
          "singleCourses": 12,
          "seriesCourses": 8,
          "videoCourses": 5,
          "liveReplays": 3
        },
        "revenueStats": {
          "monthlyRevenue": 8900.00,
          "totalRevenue": 156000.00
        }
      }
    ]
  }
}
```

#### 4.1.2 获取讲师详情

```http
GET /api/instructors/{id}
```

**Response 200**:
```json
{
  "code": 200,
  "message": "success",
  "data": {
    "id": "ins_1234567890",
    "name": "张三",
    "avatar": "https://example.com/avatars/zhang_san.jpg",
    "bio": "资深Python讲师...",
    "subjects": ["计算机", "Python", "人工智能"],
    "registerTime": "2023-01-15T10:30:00Z",
    "status": "online",
    "cooperationMode": "partner",
    "lastLoginTime": "2024-03-09T08:30:00Z",
    "studentCount": 1234,
    "followerCount": 5678,
    "questionAnswerRate": 0.92,
    "courseLikeRate": 0.87,
    "courseShareRate": 0.65,
    "averageRating": 4.8,
    "courseStats": {
      "singleCourses": 12,
      "seriesCourses": 8,
      "videoCourses": 5,
      "liveReplays": 3
    },
    "revenueStats": {
      "weeklyRevenue": 2100.00,
      "monthlyRevenue": 8900.00,
      "quarterlyRevenue": 26700.00,
      "totalRevenue": 156000.00
    },
    "reservedCourseCount": 5,
    "completedCourseCount": 23,
    "qualifications": [
      {
        "id": "cert_1",
        "name": "Python高级开发工程师认证",
        "imageUrl": "https://example.com/certs/python_cert.jpg",
        "issuingOrganization": "中国软件行业协会",
        "issueDate": "2020-06-15T00:00:00Z",
        "expiryDate": "2025-06-15T00:00:00Z",
        "certificateNumber": "PY2020100123",
        "isExpired": false,
        "isExpiringSoon": false
      }
    ],
    "reviews": [
      {
        "id": "rev_1",
        "studentName": "学员A",
        "content": "老师讲解非常详细，受益匪浅！",
        "rating": 5.0,
        "createTime": "2024-03-01T10:30:00Z"
      }
    ]
  }
}
```

### 4.2 讲师管理接口

#### 4.2.1 创建讲师

```http
POST /api/instructors
```

**Request Body**:
```json
{
  "name": "张三",
  "avatar": "https://example.com/avatars/zhang_san.jpg",
  "bio": "资深Python讲师，10年开发经验...",
  "subjects": ["计算机", "Python"],
  "cooperationMode": "partner"
}
```

**Response 201**:
```json
{
  "code": 201,
  "message": "创建成功",
  "data": {
    "id": "ins_1234567890",
    "name": "张三",
    "avatar": "https://example.com/avatars/zhang_san.jpg",
    "bio": "资深Python讲师，10年开发经验...",
    "subjects": ["计算机", "Python"],
    "registerTime": "2024-03-09T10:30:00Z",
    "status": "offline",
    "cooperationMode": "partner",
    "studentCount": 0,
    "followerCount": 0,
    "averageRating": 0,
    "courseStats": {
      "singleCourses": 0,
      "seriesCourses": 0,
      "videoCourses": 0,
      "liveReplays": 0
    },
    "revenueStats": {
      "weeklyRevenue": 0,
      "monthlyRevenue": 0,
      "quarterlyRevenue": 0,
      "totalRevenue": 0
    },
    "qualifications": [],
    "reviews": []
  }
}
```

#### 4.2.2 更新讲师信息

```http
PUT /api/instructors/{id}
```

**Request Body**:
```json
{
  "name": "张三（高级讲师）",
  "bio": "更新后的简介...",
  "subjects": ["计算机", "Python", "人工智能", "大数据"]
}
```

**Response 200**:
```json
{
  "code": 200,
  "message": "更新成功",
  "data": {
    "id": "ins_1234567890",
    "name": "张三（高级讲师）",
    "bio": "更新后的简介...",
    "subjects": ["计算机", "Python", "人工智能", "大数据"],
    "updatedAt": "2024-03-09T11:00:00Z"
  }
}
```

#### 4.2.3 删除讲师

```http
DELETE /api/instructors/{id}
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
  "message": "该讲师名下有课程，无法删除",
  "data": {
    "courseCount": 28,
    "studentCount": 1234
  }
}
```

### 4.3 资质证书管理接口

#### 4.3.1 添加证书

```http
POST /api/instructors/{instructorId}/qualifications
```

**Request Body**:
```json
{
  "name": "Python高级开发工程师认证",
  "imageUrl": "https://example.com/certs/python_cert.jpg",
  "issuingOrganization": "中国软件行业协会",
  "issueDate": "2020-06-15T00:00:00Z",
  "expiryDate": "2025-06-15T00:00:00Z",
  "certificateNumber": "PY2020100123"
}
```

**Response 201**:
```json
{
  "code": 201,
  "message": "证书添加成功",
  "data": {
    "id": "cert_123456",
    "name": "Python高级开发工程师认证",
    "imageUrl": "https://example.com/certs/python_cert.jpg",
    "issuingOrganization": "中国软件行业协会",
    "issueDate": "2020-06-15T00:00:00Z",
    "expiryDate": "2025-06-15T00:00:00Z",
    "certificateNumber": "PY2020100123",
    "isExpired": false,
    "isExpiringSoon": false,
    "createdAt": "2024-03-09T10:30:00Z"
  }
}
```

#### 4.3.2 更新证书

```http
PUT /api/instructors/{instructorId}/qualifications/{certId}
```

**Request Body**:
```json
{
  "name": "Python高级开发工程师认证（高级）",
  "expiryDate": "2026-06-15T00:00:00Z"
}
```

#### 4.3.3 删除证书

```http
DELETE /api/instructors/{instructorId}/qualifications/{certId}
```

**Response 200**:
```json
{
  "code": 200,
  "message": "证书删除成功"
}
```

### 4.4 讲师申请审核接口

#### 4.4.1 获取待审核申请列表

```http
GET /api/instructor-applications/pending
```

**Response 200**:
```json
{
  "code": 200,
  "message": "success",
  "data": {
    "total": 2,
    "items": [
      {
        "id": "app_1",
        "name": "小明",
        "avatar": "https://example.com/avatars/xiaoming.jpg",
        "bio": "热爱编程的全栈开发者...",
        "subjects": ["计算机", "Web开发"],
        "cooperationMode": "partner",
        "phone": "13800138000",
        "email": "xiaoming@example.com",
        "applyTime": "2024-03-09T07:30:00Z",
        "qualifications": [
          {
            "id": "cert_app_1",
            "name": "全栈工程师认证",
            "imageUrl": "https://example.com/certs/fullstack.jpg",
            "issuingOrganization": "中国信息技术认证中心",
            "issueDate": "2022-01-15T00:00:00Z",
            "expiryDate": "2025-01-15T00:00:00Z",
            "certificateNumber": "IT2020123456"
          }
        ]
      }
    ]
  }
}
```

#### 4.4.2 审核通过

```http
POST /api/instructor-applications/{applicationId}/approve
```

**Request Body**:
```json
{
  "note": "资质齐全，同意通过"
}
```

**Response 200**:
```json
{
  "code": 200,
  "message": "审核通过",
  "data": {
    "instructorId": "ins_1234567890",
    "approvedAt": "2024-03-09T10:30:00Z"
  }
}
```

#### 4.4.3 审核拒绝

```http
POST /api/instructor-applications/{applicationId}/reject
```

**Request Body**:
```json
{
  "reason": "资质证书不全"
}
```

**Response 200**:
```json
{
  "code": 200,
  "message": "已拒绝申请",
  "data": {
    "rejectedAt": "2024-03-09T10:30:00Z"
  }
}
```

## 五、数据验证规则

### 5.1 讲师信息验证

```json
{
  "validation": {
    "name": {
      "required": true,
      "minLength": 2,
      "maxLength": 50,
      "pattern": "^[\\u4e00-\\u9fa5a-zA-Z\\s]+$"
    },
    "avatar": {
      "required": true,
      "format": "uri",
      "pattern": "^https?://.+"
    },
    "bio": {
      "required": true,
      "minLength": 10,
      "maxLength": 2000
    },
    "subjects": {
      "required": true,
      "minItems": 1,
      "maxItems": 5,
      "uniqueItems": true
    }
  }
}
```

### 5.2 证书验证

```json
{
  "validation": {
    "name": {
      "required": true,
      "maxLength": 100
    },
    "imageUrl": {
      "required": true,
      "format": "uri"
    },
    "certificateNumber": {
      "required": true,
      "maxLength": 50,
      "pattern": "^[A-Z0-9]+$"
    },
    "expiryDate": {
      "validator": "must_be_after_issue_date"
    }
  }
}
```

## 六、错误码定义

```json
{
  "errorCodes": {
    "INSTRUCTOR_NOT_FOUND": {
      "code": 40101,
      "message": "讲师不存在"
    },
    "INSTRUCTOR_NAME_DUPLICATE": {
      "code": 40102,
      "message": "讲师姓名已存在"
    },
    "INSTRUCTOR_HAS_COURSES": {
      "code": 40103,
      "message": "该讲师名下有课程，无法删除"
    },
    "INVALID_SUBJECTS": {
      "code": 40104,
      "message": "学科标签无效"
    },
    "CERTIFICATE_NOT_FOUND": {
      "code": 40105,
      "message": "证书不存在"
    },
    "CERTIFICATE_DUPLICATE": {
      "code": 40106,
      "message": "证书编号已存在"
    },
    "APPLICATION_NOT_FOUND": {
      "code": 40107,
      "message": "申请不存在"
    },
    "APPLICATION_ALREADY_PROCESSED": {
      "code": 40108,
      "message": "申请已被处理"
    }
  }
}
```

## 七、数据库表结构建议

### 7.1 讲师表（instructors）

```sql
CREATE TABLE instructors (
  id VARCHAR(50) PRIMARY KEY,
  name VARCHAR(50) NOT NULL,
  avatar VARCHAR(500) NOT NULL,
  bio TEXT NOT NULL,
  register_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  status ENUM('online', 'busy', 'offline') NOT NULL DEFAULT 'offline',
  cooperation_mode ENUM('partner', 'lease') NOT NULL,
  last_login_time TIMESTAMP NULL,
  student_count INT NOT NULL DEFAULT 0,
  follower_count INT NOT NULL DEFAULT 0,
  question_answer_rate DECIMAL(3,2) NOT NULL DEFAULT 0,
  course_like_rate DECIMAL(3,2) NOT NULL DEFAULT 0,
  course_share_rate DECIMAL(3,2) NOT NULL DEFAULT 0,
  average_rating DECIMAL(2,1) NOT NULL DEFAULT 0,
  reserved_course_count INT NOT NULL DEFAULT 0,
  completed_course_count INT NOT NULL DEFAULT 0,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

  INDEX idx_status (status),
  INDEX idx_cooperation_mode (cooperation_mode),
  INDEX idx_student_count (student_count),
  INDEX idx_average_rating (average_rating)
);
```

### 7.2 讲师学科关联表（instructor_subjects）

```sql
CREATE TABLE instructor_subjects (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  instructor_id VARCHAR(50) NOT NULL,
  subject VARCHAR(50) NOT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

  UNIQUE KEY uk_instructor_subject (instructor_id, subject),
  INDEX idx_instructor_id (instructor_id),
  FOREIGN KEY (instructor_id) REFERENCES instructors(id) ON DELETE CASCADE
);
```

### 7.3 资质证书表（qualification_certificates）

```sql
CREATE TABLE qualification_certificates (
  id VARCHAR(50) PRIMARY KEY,
  instructor_id VARCHAR(50) NOT NULL,
  name VARCHAR(100) NOT NULL,
  image_url VARCHAR(500) NOT NULL,
  issuing_organization VARCHAR(100) NOT NULL,
  issue_date TIMESTAMP NOT NULL,
  expiry_date TIMESTAMP NULL,
  certificate_number VARCHAR(50) NOT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

  INDEX idx_instructor_id (instructor_id),
  INDEX idx_certificate_number (certificate_number),
  INDEX idx_expiry_date (expiry_date),
  FOREIGN KEY (instructor_id) REFERENCES instructors(id) ON DELETE CASCADE
);
```

### 7.3 学员评价表（student_reviews）

```sql
CREATE TABLE student_reviews (
  id VARCHAR(50) PRIMARY KEY,
  instructor_id VARCHAR(50) NOT NULL,
  student_name VARCHAR(50) NOT NULL,
  content TEXT NOT NULL,
  rating DECIMAL(2,1) NOT NULL CHECK (rating >= 1 AND rating <= 5),
  create_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

  INDEX idx_instructor_id (instructor_id),
  INDEX idx_rating (rating),
  INDEX idx_create_time (create_time),
  FOREIGN KEY (instructor_id) REFERENCES instructors(id) ON DELETE CASCADE
);
```

## 八、性能优化建议

### 8.1 统计数据缓存

- 讲师统计数据变化不频繁，建议缓存5分钟
- 使用Redis缓存热门讲师数据

### 8.2 图片优化

- 头像图片使用CDN加速
- 支持多种尺寸：小图(60x60)、中图(200x200)、大图(400x400)

### 8.3 搜索优化

- 对姓名和学科建立全文索引
- 使用Elasticsearch提升搜索性能

### 8.4 分页优化

- 默认每页10条，最大支持100条
- 使用游标分页提升大数据量查询性能
