#!/bin/bash

# 部署脚本 - 用于一键更新文件到服务器

# 服务器配置
# 请根据实际情况填写
SERVER_IP="YOUR_SERVER_IP"
SERVER_USER="YOUR_SERVER_USER"
SERVER_PATH="YOUR_SERVER_PATH"
PEM_FILE="YOUR_PEM_FILE.pem"

# 要上传的文件和目录
FILES_TO_UPLOAD=(
    "images"
    "rules.html"
    "index.html"
    "claim.html"
)

# 显示开始信息
echo "===================================="
echo "TDengine TCP-BP 部署脚本"
echo "===================================="
echo "开始上传文件到服务器..."
echo ""

# 上传文件
for FILE in "${FILES_TO_UPLOAD[@]}"; do
    echo "上传: $FILE"
    scp -r -i "$PEM_FILE" "$FILE" "$SERVER_USER@$SERVER_IP:$SERVER_PATH/"
    if [ $? -eq 0 ]; then
        echo "✓ 上传成功"
    else
        echo "✗ 上传失败"
        exit 1
    fi
    echo ""
done

# 显示完成信息
echo "===================================="
echo "部署完成！"
echo "===================================="
echo "文件已成功上传到服务器。"
echo "您可以访问以下地址查看更新："
echo "http://$SERVER_IP:3000/rules.html"
echo "http://$SERVER_IP:3000/index.html"
echo "http://$SERVER_IP:3000/claim.html"
echo ""
echo "提示：如果看不到更新，请尝试清除浏览器缓存。"
