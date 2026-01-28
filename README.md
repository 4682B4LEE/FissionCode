# FissionCode

## 项目简介

FissionCode 是一个基于飞书开放平台的表单数据管理工具，旨在简化飞书表单数据的查询、统计和同步流程。该项目通过 API 接口实现了飞书表单数据的快速访问和处理，为用户提供了便捷的数据管理解决方案。

## 核心功能

- **飞书表单数据查询**：通过手机号快速查询对应的邀请码
- **排行榜数据获取**：实时获取邀请人数排行榜数据
- **定时同步功能**：自动同步和更新邀请人数统计数据
- **健康检查接口**：提供服务健康状态检查
- **静态文件服务**：支持前端页面的访问和数据展示

## 快速开始

### 前置准备

在开始使用 FissionCode 之前，您需要准备以下内容：

1. **飞书开发者账号**：注册并登录 [飞书开放平台](https://open.feishu.cn/)
2. **飞书应用**：创建一个飞书企业自建应用，并获取以下信息：
   - App ID
   - App Secret
   - 应用 Token
3. **飞书表格**：创建或使用现有的飞书表格，并获取以下信息：
   - 表格 ID
   - 相关字段配置
4. **服务器环境**：安装 Node.js 14.0 或更高版本
5. **环境变量配置**：创建 `.env` 文件并配置必要的环境变量

### 环境要求

- Node.js 14.0+
- npm 6.0+

### 安装步骤

1. **克隆仓库**

   ```bash
   git clone https://github.com/yourusername/FissionCode.git
   cd FissionCode
   ```

2. **安装依赖**

   ```bash
   npm install
   ```

3. **配置环境变量**

   创建 `.env` 文件并添加以下配置：

   ```env
   # 服务器配置
   PORT=3000

   # 飞书应用配置
   FEISHU_APP_ID=your_feishu_app_id
   FEISHU_APP_SECRET=your_feishu_app_secret
   FEISHU_FORM_ID=your_feishu_form_id

   # 飞书表格配置
   FEISHU_APP_TOKEN=your_feishu_app_token
   FEISHU_TABLE_ID=your_feishu_table_id

   # 定时任务配置（源表单）
   FEISHU_SOURCE_APP_TOKEN=your_source_app_token
   FEISHU_SOURCE_TABLE_ID=your_source_table_id

   # 定时任务配置（目标表单）
   FEISHU_TARGET_APP_TOKEN=your_target_app_token
   FEISHU_TARGET_TABLE_ID=your_target_table_id
   ```

4. **启动服务**

   ```bash
   node server.js
   ```

   服务将在 `http://localhost:3000` 上运行。

### API 接口

- **查询邀请码**：`POST /feishu/search`
  - 请求体：`{"phone": "13800138000"}`
  - 响应：`{"success": true, "code": "ABC123"}`

- **获取排行榜**：`GET /feishu/ranking`
  - 响应：`{"success": true, "data": [{"name": "张三", "inviteCode": "ABC123", "inviteCount": 10}]}`

- **健康检查**：`GET /health`
  - 响应：`{"status": "ok"}`

- **手动同步邀请人数**：`GET /feishu/sync-invite-counts`
  - 响应：`{"success": true, "message": "邀请人数同步任务已启动，请查看服务器日志了解执行情况"}`

## 部署说明

项目提供了 `deploy.sh` 脚本用于一键部署到服务器。在使用前，请修改脚本中的服务器配置信息：

```bash
# 服务器配置
# 请根据实际情况填写
SERVER_IP="YOUR_SERVER_IP"
SERVER_USER="YOUR_SERVER_USER"
SERVER_PATH="YOUR_SERVER_PATH"
PEM_FILE="YOUR_PEM_FILE.pem"
```

然后执行部署脚本：

```bash
chmod +x deploy.sh
./deploy.sh
```

## 工具脚本

项目提供了以下工具脚本，用于简化配置和管理：

### 1. 自动配置脚本 (`setup.sh`)

用于自动配置环境变量并测试服务运行：

```bash
chmod +x setup.sh
./setup.sh
```

功能包括：
- 环境检查（Node.js 和 npm 版本）
- 配置信息收集（飞书应用、表格等配置）
- 自动创建 `.env` 文件
- 依赖管理（创建 package.json 并安装依赖）
- 服务测试（启动服务并测试健康检查接口）

### 2. 静态文件路径切换脚本 (`switch-static-path.sh`)

用于在 public 目录和项目根目录之间切换静态文件服务路径：

```bash
chmod +x switch-static-path.sh
./switch-static-path.sh
```

功能包括：
- 检测当前静态文件服务配置
- 提供切换选项（项目根目录或 public 目录）
- 自动修改 server.js 文件配置
- 自动创建 public 目录（如果不存在）
- 提供服务重启选项

## 贡献

欢迎提交 Issue 和 Pull Request 来帮助改进这个项目！

## 许可证

本项目采用 MIT 许可证 - 详见 [LICENSE](LICENSE) 文件
