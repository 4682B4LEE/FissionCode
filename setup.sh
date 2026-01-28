#!/bin/bash

# FissionCode 配置脚本
# 用于自动配置环境变量并测试服务运行

echo "===================================="
echo "FissionCode 配置脚本"
echo "===================================="
echo ""
echo "此脚本将帮助您配置 FissionCode 项目的环境变量"
echo "并测试服务是否正常运行。"
echo ""
echo "请确保您已完成以下前置准备："
echo "1. 注册并登录飞书开放平台"
echo "2. 创建飞书企业自建应用"
echo "3. 获取必要的应用凭证和配置信息"
echo "4. 安装 Node.js 14.0 或更高版本"
echo ""

# 检查 Node.js 是否安装
if ! command -v node &> /dev/null; then
    echo "错误：未检测到 Node.js，请先安装 Node.js 14.0 或更高版本。"
    exit 1
fi

# 检查 npm 是否安装
if ! command -v npm &> /dev/null; then
    echo "错误：未检测到 npm，请先安装 npm 6.0 或更高版本。"
    exit 1
fi

# 检查 Node.js 版本
NODE_VERSION=$(node -v | sed 's/v//')
REQUIRED_VERSION="14.0.0"

if [[ "$(printf '%s\n' "$REQUIRED_VERSION" "$NODE_VERSION" | sort -V | head -n1)" != "$REQUIRED_VERSION" ]]; then
    echo "警告：Node.js 版本可能过低，建议使用 14.0.0 或更高版本。"
    echo "当前版本：$NODE_VERSION"
fi

echo ""
echo "===================================="
echo "开始配置环境变量"
echo "===================================="
echo ""

# 服务器配置
read -p "请输入服务器端口 (默认: 3000): " PORT
PORT=${PORT:-3000}

echo ""
echo "===================================="
echo "飞书应用配置"
echo "===================================="
echo ""

# 飞书应用配置
read -p "请输入飞书 App ID: " FEISHU_APP_ID
while [ -z "$FEISHU_APP_ID" ]; do
    echo "错误：飞书 App ID 不能为空"
    read -p "请输入飞书 App ID: " FEISHU_APP_ID
done

read -p "请输入飞书 App Secret: " FEISHU_APP_SECRET
while [ -z "$FEISHU_APP_SECRET" ]; do
    echo "错误：飞书 App Secret 不能为空"
    read -p "请输入飞书 App Secret: " FEISHU_APP_SECRET
done

read -p "请输入飞书 Form ID: " FEISHU_FORM_ID
while [ -z "$FEISHU_FORM_ID" ]; do
    echo "错误：飞书 Form ID 不能为空"
    read -p "请输入飞书 Form ID: " FEISHU_FORM_ID
done

echo ""
echo "===================================="
echo "飞书表格配置"
echo "===================================="
echo ""

# 飞书表格配置
read -p "请输入飞书 App Token: " FEISHU_APP_TOKEN
while [ -z "$FEISHU_APP_TOKEN" ]; do
    echo "错误：飞书 App Token 不能为空"
    read -p "请输入飞书 App Token: " FEISHU_APP_TOKEN
done

read -p "请输入飞书 Table ID: " FEISHU_TABLE_ID
while [ -z "$FEISHU_TABLE_ID" ]; do
    echo "错误：飞书 Table ID 不能为空"
    read -p "请输入飞书 Table ID: " FEISHU_TABLE_ID
done

echo ""
echo "===================================="
echo "定时任务配置（源表单）"
echo "===================================="
echo ""

# 定时任务配置（源表单）
read -p "请输入源表单 App Token: " FEISHU_SOURCE_APP_TOKEN
while [ -z "$FEISHU_SOURCE_APP_TOKEN" ]; do
    echo "错误：源表单 App Token 不能为空"
    read -p "请输入源表单 App Token: " FEISHU_SOURCE_APP_TOKEN
done

read -p "请输入源表单 Table ID: " FEISHU_SOURCE_TABLE_ID
while [ -z "$FEISHU_SOURCE_TABLE_ID" ]; do
    echo "错误：源表单 Table ID 不能为空"
    read -p "请输入源表单 Table ID: " FEISHU_SOURCE_TABLE_ID
done

echo ""
echo "===================================="
echo "定时任务配置（目标表单）"
echo "===================================="
echo ""

# 定时任务配置（目标表单）
read -p "请输入目标表单 App Token: " FEISHU_TARGET_APP_TOKEN
while [ -z "$FEISHU_TARGET_APP_TOKEN" ]; do
    echo "错误：目标表单 App Token 不能为空"
    read -p "请输入目标表单 App Token: " FEISHU_TARGET_APP_TOKEN
done

read -p "请输入目标表单 Table ID: " FEISHU_TARGET_TABLE_ID
while [ -z "$FEISHU_TARGET_TABLE_ID" ]; do
    echo "错误：目标表单 Table ID 不能为空"
    read -p "请输入目标表单 Table ID: " FEISHU_TARGET_TABLE_ID
done

echo ""
echo "===================================="
echo "创建 .env 文件"
echo "===================================="
echo ""

# 创建 .env 文件
cat > .env << EOL
# 服务器配置
PORT=$PORT

# 飞书应用配置
FEISHU_APP_ID=$FEISHU_APP_ID
FEISHU_APP_SECRET=$FEISHU_APP_SECRET
FEISHU_FORM_ID=$FEISHU_FORM_ID

# 飞书表格配置
FEISHU_APP_TOKEN=$FEISHU_APP_TOKEN
FEISHU_TABLE_ID=$FEISHU_TABLE_ID

# 定时任务配置（源表单）
FEISHU_SOURCE_APP_TOKEN=$FEISHU_SOURCE_APP_TOKEN
FEISHU_SOURCE_TABLE_ID=$FEISHU_SOURCE_TABLE_ID

# 定时任务配置（目标表单）
FEISHU_TARGET_APP_TOKEN=$FEISHU_TARGET_APP_TOKEN
FEISHU_TARGET_TABLE_ID=$FEISHU_TARGET_TABLE_ID
EOL

echo "✅ .env 文件创建成功！"
echo ""

echo "===================================="
echo "安装依赖"
echo "===================================="
echo ""

# 检查 package.json 是否存在
if [ ! -f "package.json" ]; then
    echo "错误：package.json 文件不存在，正在创建..."
    cat > package.json << EOL
{
  "dependencies": {
    "express": "^4.18.2",
    "axios": "^1.6.2",
    "cors": "^2.8.5",
    "dotenv": "^16.3.1",
    "node-schedule": "^2.1.1"
  }
}
EOL
    echo "✅ package.json 文件创建成功！"
    echo ""
fi

# 安装依赖
npm install
echo ""
if [ $? -eq 0 ]; then
    echo "✅ 依赖安装成功！"
else
    echo "❌ 依赖安装失败，请检查网络连接或权限设置。"
    exit 1
fi

echo ""
echo "===================================="
echo "测试服务"
echo "===================================="
echo ""

# 询问用户是否启动服务进行测试
read -p "是否启动服务进行测试？ (y/n): " TEST_SERVICE

if [ "$TEST_SERVICE" = "y" ] || [ "$TEST_SERVICE" = "Y" ]; then
    echo ""
    echo "正在启动服务..."
    echo "服务将在后台运行，您可以通过以下命令查看日志："
    echo "  tail -f server.log"
    echo ""
    
    # 启动服务并将输出重定向到日志文件
    node server.js > server.log 2>&1 &
    
    # 保存进程 ID
    SERVER_PID=$!
    
    # 等待服务启动
    echo "等待服务启动..."
    sleep 3
    
    # 检查服务是否启动成功
    if ps -p $SERVER_PID > /dev/null; then
        echo "✅ 服务启动成功！"
        echo "服务运行在端口: $PORT"
        echo ""
        
        # 测试健康检查接口
        echo "测试健康检查接口..."
        HEALTH_CHECK_RESPONSE=$(curl -s http://localhost:$PORT/health)
        
        if [[ "$HEALTH_CHECK_RESPONSE" == *"status":"ok"* ]]; then
            echo "✅ 健康检查接口测试成功！"
            echo "服务运行正常，可以开始使用了。"
        else
            echo "❌ 健康检查接口测试失败，请查看日志了解详情。"
            echo "日志文件: server.log"
        fi
        
        echo ""
        echo "===================================="
        echo "服务管理命令"
        echo "===================================="
        echo "启动服务: node server.js"
        echo "停止服务: kill $SERVER_PID"
        echo "查看日志: tail -f server.log"
        echo "测试健康检查: curl http://localhost:$PORT/health"
        echo ""
    else
        echo "❌ 服务启动失败，请查看日志了解详情。"
        echo "日志文件: server.log"
    fi
else
    echo ""
    echo "服务配置已完成，但未启动。"
    echo "您可以通过以下命令手动启动服务："
    echo "  node server.js"
    echo ""
fi

echo "===================================="
echo "配置完成"
echo "===================================="
echo ""
echo "FissionCode 项目配置已完成！"
echo "您可以通过以下步骤开始使用："
echo "1. 启动服务: node server.js"
echo "2. 测试 API: curl http://localhost:$PORT/health"
echo "3. 使用 API 接口进行飞书表单数据的查询和管理"
echo ""
echo "详细的 API 文档请参考 README.md 文件。"
