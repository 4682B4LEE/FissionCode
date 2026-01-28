#!/bin/bash

# 一键提交代码到 GitHub 脚本
echo "=== 开始提交代码到 GitHub ==="

# 检查当前目录是否为 git 仓库
if [ ! -d ".git" ]; then
    echo "错误：当前目录不是 git 仓库！"
    exit 1
fi

# 添加所有更改的文件，排除 .env 文件
echo "添加所有更改的文件..."
git add .
git reset HEAD -- .env
echo "已排除 .env 文件，不会上传敏感信息"


# 检查是否有更改
if git diff --cached --quiet; then
    echo "没有需要提交的更改！"
    exit 0
fi

# 提交更改
echo "提交更改..."
commit_message="更新内容 $(date '+%Y-%m-%d %H:%M:%S')"
git commit -m "$commit_message"

# 推送更改到 GitHub
echo "推送更改到 GitHub..."
git push origin main

# 检查推送是否成功
if [ $? -eq 0 ]; then
    echo "=== 提交成功！==="
else
    echo "=== 提交失败，请检查错误信息 ==="
    exit 1
fi
