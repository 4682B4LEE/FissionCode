#!/bin/bash

# 静态文件服务路径切换脚本
# 用于在 public 目录和项目根目录之间切换静态文件服务路径

echo "===================================="
echo "静态文件服务路径切换脚本"
echo "===================================="
echo ""

# 检查 server.js 文件是否存在
if [ ! -f "server.js" ]; then
    echo "错误：server.js 文件不存在！"
    echo "请确保在项目根目录运行此脚本。"
    exit 1
fi

# 读取当前配置
CURRENT_CONFIG=$(grep -A 5 "静态文件服务" server.js)
echo "当前配置："
echo "$CURRENT_CONFIG"
echo ""

# 检测当前静态文件服务路径
if echo "$CURRENT_CONFIG" | grep -q "public"; then
    CURRENT_PATH="public"
    echo "当前静态文件服务路径：public 目录"
elif echo "$CURRENT_CONFIG" | grep -q "__dirname;"; then
    CURRENT_PATH="root"
    echo "当前静态文件服务路径：项目根目录"
else
    CURRENT_PATH="unknown"
    echo "当前静态文件服务路径：未知"
fi

echo ""
echo "===================================="
echo "选择要切换到的路径"
echo "===================================="
echo "1. 项目根目录（index.html 直接位于根目录）"
echo "2. public 目录（index.html 位于 public 目录）"
echo ""

read -p "请输入选项编号 (1/2): " OPTION

case $OPTION in
    1)
        echo ""
        echo "切换到项目根目录..."
        
        # 修改 server.js 文件
        sed -i '' 's|app.use(express.static(path.join(__dirname, "public")));|app.use(express.static(__dirname));|g' server.js
        sed -i '' 's|res.sendFile(path.join(__dirname, "public", "index.html"));|res.sendFile(path.join(__dirname, "index.html"));|g' server.js
        
        echo "✅ 已切换到项目根目录！"
        ;;
    
    2)
        echo ""
        echo "切换到 public 目录..."
        
        # 检查 public 目录是否存在
        if [ ! -d "public" ]; then
            echo "警告：public 目录不存在，将创建该目录..."
            mkdir -p public
            echo "✅ public 目录创建成功！"
        fi
        
        # 修改 server.js 文件
        sed -i '' 's|app.use(express.static(__dirname));|app.use(express.static(path.join(__dirname, "public")));|g' server.js
        sed -i '' 's|res.sendFile(path.join(__dirname, "index.html"));|res.sendFile(path.join(__dirname, "public", "index.html"));|g' server.js
        
        echo "✅ 已切换到 public 目录！"
        ;;
    
    *)
        echo ""
        echo "错误：无效的选项！"
        exit 1
        ;;
esac

echo ""
echo "===================================="
echo "新配置"
echo "===================================="
NEW_CONFIG=$(grep -A 5 "静态文件服务" server.js)
echo "$NEW_CONFIG"
echo ""

# 询问是否重启服务
read -p "是否重启服务以应用更改？ (y/n): " RESTART

if [ "$RESTART" = "y" ] || [ "$RESTART" = "Y" ]; then
    echo ""
    echo "正在重启服务..."
    
    # 停止正在运行的服务
    pkill -f server.js 2>/dev/null
    
    # 启动服务
    node server.js > server.log 2>&1 &
    
    # 保存进程 ID
    SERVER_PID=$!
    
    # 等待服务启动
    echo "等待服务启动..."
    sleep 3
    
    # 检查服务是否启动成功
    if ps -p $SERVER_PID > /dev/null; then
        echo "✅ 服务重启成功！"
        echo "服务运行在端口: $(grep -o "PORT.*3000" server.js | awk -F'=' '{print $2}' | tr -d ' ' | tr -d ';')"
        echo ""
        echo "查看日志：tail -f server.log"
    else
        echo "❌ 服务重启失败，请查看日志了解详情。"
        echo "日志文件: server.log"
    fi
else
    echo ""
    echo "服务未重启，请手动重启服务以应用更改："
    echo "  node server.js"
fi

echo ""
echo "===================================="
echo "操作完成"
echo "===================================="
