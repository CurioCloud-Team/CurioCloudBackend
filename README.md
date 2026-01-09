# CurioCloud Backend

基于 FastAPI 的 课研云 CurioCloud 后端。

## 项目概述
课研云 CurioCloud 旨在打造一款AI驱动的教师备课辅助系统，通过集成先进的人工智能技术，解决传统备课方式效率低、创新性不足的痛点。项目旨在实现教学设计的自动化、教学资源的智能化生成与个性化推荐、以及深度的学情分析，从而革命性地提升教师的备课效率与教学质量。

## 功能特性

- ✅ 用户注册与登录
- ✅ 用户资料管理（获取/更新）
- ✅ JWT令牌认证
- ✅ 密码安全加密
- ✅ 数据验证和错误处理
- ✅ MySQL数据库集成
- ✅ RESTful API设计
- ✅ 完整的文档和注释
- ✅ 完善的测试套件
- ✅ **对话式教学设计自动化模块**
  - 智能对话流程引导
  - AI生成教学计划
  - OpenRouter集成
  - 完整的教案管理CRUD
  - **Tavily联网搜索集成** - AI生成教学计划时自动搜索最新教学资源和方法

## 技术栈

- **框架**: FastAPI 0.104.1
- **数据库**: MySQL + SQLAlchemy
- **认证**: JWT + bcrypt
- **数据验证**: Pydantic
- **服务器**: Uvicorn

## 项目结构

├── app/                    # 应用程序包
│   ├── core/              # 核心配置
│   │   ├── config.py      # 应用配置
│   │   └── database.py    # 数据库连接
│   ├── dependencies/      # 依赖注入
│   │   └── auth.py        # 认证依赖
│   ├── models/            # 数据库模型
│   │   ├── user.py        # 用户模型
│   │   ├── lesson_creation_session.py    # 教学会话模型
│   │   ├── lesson_plan.py               # 教学计划模型
│   │   └── lesson_plan_activity.py      # 教学活动模型
│   ├── schemas/           # 数据验证模式
│   │   └── user.py        # 用户相关schema
│   ├── services/          # 业务逻辑
│   │   ├── auth_service.py # 认证服务
│   │   └── teaching_service.py          # 教学服务
│   ├── routers/           # API路由
│   │   ├── auth.py        # 认证路由
│   │   ├── user.py        # 用户管理路由
│   │   └── teaching.py    # 教学模块路由
│   ├── utils/             # 工具函数
│   │   ├── security.py    # 密码工具
│   │   └── jwt.py         # JWT工具
│   ├── conversation_flow.py              # 对话流程配置
│   └── ai_service.py                     # AI服务集成
├── tests/                 # 测试套件
│   ├── conftest.py        # 测试配置
│   ├── test_auth.py       # 认证API测试
│   ├── test_models.py     # 数据模型测试
│   ├── test_services.py   # 业务逻辑测试
│   ├── test_user_profile.py # 用户资料测试
│   └── test_teaching.py   # 教学模块测试
├── main.py                # 应用入口
├── requirements.txt       # 依赖包
├── demo_teaching_module.py # 教学模块演示
└── .env                   # 环境变量

## 快速开始

### 1. 环境配置

```bash
# 安装依赖
pip install -r requirements.txt

# 配置环境变量
# 编辑 .env 文件，设置数据库连接信息
```

### 2. 数据库设置

确保MySQL服务正在运行，并创建数据库：

```sql
CREATE DATABASE curio_cloud;
```

### 3. 配置 .env 文件

```env
# 数据库配置
DATABASE_HOST=localhost
DATABASE_PORT=3306
DATABASE_USER=your_username
DATABASE_PASSWORD=your_password
DATABASE_NAME=curio_cloud

# JWT配置
JWT_SECRET_KEY=your_super_secret_jwt_key_here_change_this_in_production
JWT_ALGORITHM=HS256
JWT_ACCESS_TOKEN_EXPIRE_MINUTES=30
```

### 4. 启动应用

```bash
# 开发模式
python main.py

# 或使用uvicorn
uvicorn main:app --reload

# 生产模式
uvicorn main:app --host 0.0.0.0 --port 8000
```

### 5. 访问文档

启动后访问：
- API文档: http://localhost:8000/docs
- ReDoc文档: http://localhost:8000/redoc

## API接口

### 用户注册

```http
POST /api/auth/register
Content-Type: application/json

{
    "username": "testuser",
    "email": "test@example.com",
    "password": "Test123!@#",
    "confirm_password": "Test123!@#",
    "full_name": "测试用户"
}
```

**响应示例:**
```json
{
    "user": {
        "id": 1,
        "username": "testuser",
        "email": "test@example.com",
        "full_name": "测试用户",
        "is_active": true,
        "is_verified": false,
        "created_at": "2024-01-01T12:00:00Z",
        "updated_at": "2024-01-01T12:00:00Z"
    },
    "token": {
        "access_token": "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9...",
        "token_type": "bearer",
        "expires_in": 1800
    },
    "message": "注册成功"
}
```

### 用户登录

```http
POST /api/auth/login
Content-Type: application/json

{
    "username": "testuser",  // 支持用户名或邮箱
    "password": "Test123!@#"
}
```

**响应示例:**
```json
{
    "user": {
        "id": 1,
        "username": "testuser",
        "email": "test@example.com",
        "full_name": "测试用户",
        "is_active": true,
        "is_verified": false,
        "created_at": "2024-01-01T12:00:00Z",
        "updated_at": "2024-01-01T12:00:00Z"
    },
    "token": {
        "access_token": "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9...",
        "token_type": "bearer",
        "expires_in": 1800
    },
    "message": "登录成功"
}
```

### 获取用户资料

```http
GET /api/user/profile
Authorization: Bearer {access_token}
```

**响应示例:**
```json
{
    "id": 1,
    "username": "testuser",
    "email": "test@example.com",
    "full_name": "测试用户",
    "is_active": true,
    "is_verified": false,
    "created_at": "2024-01-01T12:00:00Z",
    "updated_at": "2024-01-01T12:00:00Z"
}
```

### 更新用户资料

```http
PUT /api/user/profile
Authorization: Bearer {access_token}
Content-Type: application/json

{
    "full_name": "更新后的用户名",  // 可选
    "email": "new@example.com"     // 可选
}
```

**响应示例:**
```json
{
    "id": 1,
    "username": "testuser",
    "email": "new@example.com",
    "full_name": "更新后的用户名",
    "is_active": true,
    "is_verified": false,
    "created_at": "2024-01-01T12:00:00Z",
    "updated_at": "2024-01-01T12:05:00Z"
}
```

### 获取用户状态

```http
GET /api/user/profile/status
Authorization: Bearer {access_token}
```

**响应示例:**
```json
{
    "message": "用户 testuser: 账户已激活, 邮箱未验证",
    "success": true
}
```

## 对话式教学设计模块

### 功能概述

对话式教学设计自动化模块通过智能问答流程，引导用户逐步提供教学设计所需信息，最终由AI生成完整的教学计划。

#### 核心特性
- 🤖 **智能对话流程**: 引导式问题设计，逐步收集教学信息
- 🎯 **AI生成教案**: 集成OpenRouter API，自动生成结构化教学计划
- 📚 **完整CRUD操作**: 教案的创建、读取、更新、删除
- 🔄 **状态管理**: 会话状态跟踪，确保流程完整性
- 🛡️ **权限控制**: 基于JWT的用户认证和授权

### 对话流程

1. **学科选择** → 2. **年级选择** → 3. **课题输入** → 4. **时长设置** → 5. **AI生成教案**

### API接口

#### 开始教学设计对话

```http
POST /api/teaching/conversational/start
Authorization: Bearer {access_token}
```

**响应示例:**
```json
{
    "session_id": "550e8400-e29b-41d4-a716-446655440000",
    "question_card": {
        "step_key": "ask_subject",
        "question": "您好！我们来一起准备一堂新课。首先，这堂课是关于哪个学科的？",
        "options": ["语文", "数学", "英语", "物理", "历史", "生物"],
        "allows_free_text": true
    }
}
```

#### 提交回答并获取下一步

```http
POST /api/teaching/conversational/next
Authorization: Bearer {access_token}
Content-Type: application/json

{
    "session_id": "550e8400-e29b-41d4-a716-446655440000",
    "answer": "生物"
}
```

**中间步骤响应:**
```json
{
    "session_id": "550e8400-e29b-41d4-a716-446655440000",
    "question_card": {
        "step_key": "ask_grade",
        "question": "好的，那么这堂课是针对哪个年级的学生？",
        "options": ["初中一年级", "初中二年级", "初中三年级"],
        "allows_free_text": true
    }
}
```

**完成响应:**
```json
{
    "session_id": "550e8400-e29b-41d4-a716-446655440000",
    "status": "completed",
    "lesson_plan": {
        "id": 1,
        "title": "探秘绿色工厂——光合作用",
        "subject": "生物",
        "grade": "初中二年级",
        "teaching_objective": "1. 理解光合作用的基本概念和过程\n2. 掌握光合作用的条件和产物",
        "teaching_outline": "本课程将带领学生探索植物如何将光能转化为化学能...",
        "activities": [
            {
                "activity_name": "课堂导入",
                "description": "通过观察绿色植物引出生长之谜",
                "duration": 5,
                "order_index": 1
            }
        ],
        "created_at": "2024-01-01T12:00:00Z"
    }
}
```

#### 获取教案列表

```http
GET /api/teaching/lesson-plans
Authorization: Bearer {access_token}
```

#### 获取单个教案

```http
GET /api/teaching/lesson-plans/{plan_id}
Authorization: Bearer {access_token}
```

#### 删除教案

```http
DELETE /api/teaching/lesson-plans/{plan_id}
Authorization: Bearer {access_token}
```

### 数据库表结构

#### lesson_creation_sessions 表

| 字段 | 类型 | 约束 | 描述 |
|------|------|------|------|
| session_id | VARCHAR(36) | PRIMARY KEY | 会话UUID |
| user_id | INT | FOREIGN KEY, NOT NULL | 用户ID |
| status | ENUM | DEFAULT 'in_progress' | 会话状态 |
| current_step | VARCHAR(50) | NULL | 当前步骤 |
| collected_data | JSON | DEFAULT {} | 收集的数据 |
| created_at | DATETIME | DEFAULT NOW() | 创建时间 |
| updated_at | DATETIME | DEFAULT NOW() ON UPDATE | 更新时间 |

#### lesson_plans 表

| 字段 | 类型 | 约束 | 描述 |
|------|------|------|------|
| id | INT | PRIMARY KEY, AUTO_INCREMENT | 教案ID |
| user_id | INT | FOREIGN KEY, NOT NULL | 用户ID |
| title | VARCHAR(255) | NOT NULL | 教案标题 |
| subject | VARCHAR(100) | NOT NULL | 学科 |
| grade | VARCHAR(100) | NOT NULL | 年级 |
| teaching_objective | TEXT | NULL | 教学目标 |
| teaching_outline | TEXT | NULL | 教学大纲 |
| created_at | DATETIME | DEFAULT NOW() | 创建时间 |
| updated_at | DATETIME | DEFAULT NOW() ON UPDATE | 更新时间 |

#### lesson_plan_activities 表

| 字段 | 类型 | 约束 | 描述 |
|------|------|------|------|
| id | INT | PRIMARY KEY, AUTO_INCREMENT | 活动ID |
| lesson_plan_id | INT | FOREIGN KEY, NOT NULL | 教案ID |
| activity_name | VARCHAR(255) | NOT NULL | 活动名称 |
| description | TEXT | NULL | 活动描述 |
| duration | INT | NULL | 活动时长(分钟) |
| order_index | INT | NOT NULL | 活动顺序 |

### 配置要求

在 `.env` 文件中添加以下配置：

```env
# OpenRouter LLM配置
openrouter_api_key=sk-or-v1-xxxxxxxxxxxxx
openrouter_base_url=https://openrouter.ai/api/v1
openrouter_default_model=google/gemini-2.5-flash
llm_max_retries=3
llm_timeout_seconds=120
```

## 密码要求

- 最少8个字符
- 至少包含一个字母
- 至少包含一个数字

## 安全特性

1. **密码加密**: 使用bcrypt进行密码哈希
2. **JWT认证**: 安全的令牌认证机制
3. **数据验证**: 严格的输入数据验证
4. **SQL注入防护**: 使用SQLAlchemy ORM
5. **CORS保护**: 配置跨域资源共享策略

## 数据库表结构

### users 表

| 字段 | 类型 | 约束 | 描述 |
|------|------|------|------|
| id | INT | PRIMARY KEY, AUTO_INCREMENT | 用户ID |
| username | VARCHAR(50) | UNIQUE, NOT NULL | 用户名 |
| email | VARCHAR(100) | UNIQUE, NOT NULL | 邮箱 |
| full_name | VARCHAR(100) | NULL | 全名 |
| hashed_password | VARCHAR(255) | NOT NULL | 加密密码 |
| is_active | BOOLEAN | DEFAULT TRUE | 是否激活 |
| is_verified | BOOLEAN | DEFAULT FALSE | 是否验证 |
| created_at | DATETIME | DEFAULT NOW() | 创建时间 |
| updated_at | DATETIME | DEFAULT NOW() ON UPDATE NOW() | 更新时间 |

## 开发指南

### 添加新的API路由

1. 在 `app/routers/` 中创建新的路由文件
2. 在 `main.py` 中注册路由
3. 创建对应的service和schema

### 数据库迁移

```bash
# 生成迁移文件
alembic revision --autogenerate -m "描述"

# 执行迁移
alembic upgrade head
```

### 运行测试

```bash
pytest
```

## 部署建议

1. 使用强密码和安全的JWT密钥
2. 启用HTTPS
3. 配置防火墙
4. 使用环境变量管理敏感信息
5. 定期备份数据库
6. 监控日志和性能

## Docker 部署

### 构建 Docker 镜像

```bash
# 构建镜像
docker build -t curiocloud-backend:latest .

# 查看构建的镜像
docker images | grep curiocloud-backend
```

### 本地运行容器

```bash
docker run -d \
  --name curiocloud-backend \
  --restart always \
  -p 8000:8000 \
  -e DATABASE_HOST=<your-db-host> \
  -e DATABASE_USER=<your-db-user> \
  -e DATABASE_PASSWORD=<your-db-password> \
  -e DATABASE_NAME=<your-db-name> \
  -e JWT_SECRET_KEY=<your-jwt-secret> \
  -e JWT_ALGORITHM=HS256 \
  -e JWT_ACCESS_TOKEN_EXPIRE_MINUTES=30 \
  -e openrouter_api_key=<your-openrouter-key> \
  -e openrouter_base_url=https://openrouter.ai/api/v1 \
  -e openrouter_default_model=google/gemini-2.5-flash \
  curiocloud-backend:latest
```

### 使用 Docker Compose（推荐）

创建 `docker-compose.yml` 文件：

```yaml
version: '3.8'

services:
  backend:
    image: curiocloud-backend:latest
    container_name: curiocloud-backend
    restart: always
    ports:
      - "8000:8000"
    environment:
      DATABASE_HOST: ${DATABASE_HOST}
      DATABASE_USER: ${DATABASE_USER}
      DATABASE_PASSWORD: ${DATABASE_PASSWORD}
      DATABASE_NAME: ${DATABASE_NAME}
      JWT_SECRET_KEY: ${JWT_SECRET_KEY}
      JWT_ALGORITHM: HS256
      JWT_ACCESS_TOKEN_EXPIRE_MINUTES: 30
      openrouter_api_key: ${openrouter_api_key}
      openrouter_base_url: https://openrouter.ai/api/v1
      openrouter_default_model: google/gemini-2.5-flash
```

运行：
```bash
# 启动服务
docker-compose up -d

# 查看日志
docker-compose logs -f

# 停止服务
docker-compose down
```

### 推送到私有 Docker Registry

```bash
# 登录到私有Registry
docker login <REGISTRY_URL> -u <USERNAME>

# 打标签
docker tag curiocloud-backend:latest <REGISTRY_URL>/curiocloud-backend:latest

# 推送镜像
docker push <REGISTRY_URL>/curiocloud-backend:latest
```

### GitHub Actions 自动化部署

本项目配置了 GitHub Actions 自动化流程，可以自动构建镜像并部署到远程服务器。

#### 配置步骤

1. 在 GitHub 仓库的 **Settings → Secrets and variables → Actions** 中配置以下 secrets：

**Docker Registry 相关：**
- `REGISTRY_URL` - 私有Registry地址（如 `registry.example.com`）
- `REGISTRY_USERNAME` - Registry登录用户名
- `REGISTRY_PASSWORD` - Registry登录密码

**远程服务器部署相关：**
- `REMOTE_HOST` - 部署服务器的IP或域名
- `REMOTE_USER` - SSH登录用户
- `REMOTE_SSH_KEY` - SSH私钥内容
- `REMOTE_PORT` - SSH端口
- `DOCKER_CONTAINER_NAME` - 容器名称（如 `curiocloud-backend`）

1. 推送代码到 `main` 分支即可自动触发构建和部署

2. 也可以在 GitHub Actions 页面手动触发 workflow

#### 部署流程

1. **构建阶段**：
   - 检出代码
   - 登录私有Docker Registry
   - 构建并推送多标签镜像（`latest`、分支名、commit hash）

2. **部署阶段**（仅main分支）：
   - SSH连接到远程服务器
   - 拉取最新镜像
   - 停止并删除旧容器
   - 启动新容器

## 故障排除

### 常见问题

1. **数据库连接失败**
   - 检查MySQL服务是否运行
   - 验证.env文件中的数据库配置
   - 确保数据库存在
   - Docker环境：确保容器能访问数据库（使用宿主机IP或容器网络）

2. **JWT令牌错误**
   - 检查JWT_SECRET_KEY配置
   - 验证令牌是否过期

3. **依赖安装失败**
   - 使用虚拟环境
   - 更新pip版本

4. **Docker容器无法启动**
   - 检查端口8000是否被占用：`netstat -ano | findstr :8000`（Windows）或 `lsof -i :8000`（Linux/Mac）
   - 查看容器日志：`docker logs curiocloud-backend`
   - 验证所有环境变量是否正确配置

5. **GitHub Actions部署失败**
   - 检查所有Secrets是否正确配置
   - 验证SSH连接是否正常
   - 查看Actions日志定位具体错误
   - 确保远程服务器Docker服务正常运行

