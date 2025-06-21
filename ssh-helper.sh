#!/bin/bash

# 设置 SSH 密钥路径 (Windows 上的路径可以直接修改为适合你的路径)
KEY_PATH="$HOME/.ssh/id_rsa"
PUB_KEY_PATH="${KEY_PATH}.pub"

# 帮助功能
if [ "$1" == "help" ] || [ -z "$1" ]; then
    echo "可用命令："
    echo "    generate  - 生成 SSH 私钥和公钥"
    echo "    show      - 显示当前私钥和公钥内容"
    echo "    show-path - 显示当前私钥和公钥的路径"
    echo "    copy      - 将公钥复制到远程服务器"
    echo "    connect   - 使用 SSH 连接到远程服务器"
    echo "    test      - 测试 SSH 连接是否成功"
    echo "    config    - 配置 SSH 客户端设置"
    echo "    list      - 列出已知主机"
    echo "    help      - 显示帮助"
    exit 0
fi

# 显示当前私钥和公钥的路径
if [ "$1" == "show-path" ]; then
    echo "当前私钥路径：$KEY_PATH"
    echo "当前公钥路径：$PUB_KEY_PATH"
    exit 0
fi

# 生成 SSH 密钥
if [ "$1" == "generate" ]; then
    echo "正在生成 SSH 私钥和公钥..."
    if [ ! -f "$KEY_PATH" ]; then
        ssh-keygen -t rsa -b 4096 -f "$KEY_PATH" -N ""
        echo "密钥对生成完成：$KEY_PATH 和 $PUB_KEY_PATH"
    else
        echo "私钥已存在：$KEY_PATH，跳过生成步骤。"
    fi
    exit 0
fi

# 显示当前私钥和公钥内容
if [ "$1" == "show" ]; then
    echo "显示当前的私钥和公钥内容："
    if [ -f "$KEY_PATH" ]; then
        echo "私钥内容："
        cat "$KEY_PATH"
        echo
    else
        echo "私钥文件不存在。"
    fi
    if [ -f "$PUB_KEY_PATH" ]; then
        echo "公钥内容："
        cat "$PUB_KEY_PATH"
        echo
    else
        echo "公钥文件不存在。"
    fi
    exit 0
fi

# 将公钥复制到远程服务器
if [ "$1" == "copy" ]; then
    read -p "请输入远程服务器用户名: " REMOTE_USER
    read -p "请输入远程服务器IP地址: " REMOTE_SERVER
    echo "正在将公钥复制到远程服务器 $REMOTE_SERVER 上..."
    ssh-copy-id -i "$PUB_KEY_PATH" "$REMOTE_USER@$REMOTE_SERVER"
    if [ $? -eq 0 ]; then
        echo "公钥成功复制到服务器 $REMOTE_SERVER。"
    else
        echo "公钥复制失败。请检查用户名和服务器连接。"
    fi
    exit 0
fi

# 使用 SSH 连接到远程服务器
if [ "$1" == "connect" ]; then
    read -p "请输入远程服务器用户名: " REMOTE_USER
    read -p "请输入远程服务器IP地址: " REMOTE_SERVER
    echo "正在使用 SSH 连接到 $REMOTE_SERVER..."
    ssh -i "$KEY_PATH" "$REMOTE_USER@$REMOTE_SERVER"
    exit 0
fi

# 测试 SSH 连接是否成功
if [ "$1" == "test" ]; then
    read -p "请输入远程服务器用户名: " REMOTE_USER
    read -p "请输入远程服务器IP地址: " REMOTE_SERVER
    echo "正在测试与 $REMOTE_SERVER 的 SSH 连接..."
    ssh -o BatchMode=yes -o ConnectTimeout=5 "$REMOTE_USER@$REMOTE_SERVER" exit
    if [ $? -eq 0 ]; then
        echo "SSH 连接成功！"
    else
        echo "SSH 连接失败，请检查连接设置或服务器状态。"
    fi
    exit 0
fi

# 配置 SSH 客户端设置
if [ "$1" == "config" ]; then
    echo "配置 SSH 客户端设置..."
    echo "如果你想设置默认的 SSH 端口、用户名等配置，请修改以下文件中的设置："
    echo "$HOME/.ssh/config"
    echo "可以使用以下命令进行编辑："
    echo "nano $HOME/.ssh/config"
    exit 0
fi

# 列出已知主机
if [ "$1" == "list" ]; then
    echo "列出已知的 SSH 主机："
    echo "-----------------------------------"
    cat "$HOME/.ssh/known_hosts"
    echo "-----------------------------------"
    exit 0
fi

echo "错误：未知命令 $1。"
echo "使用 \"ssh-helper.sh help\" 查看命令帮助。"
exit 1
