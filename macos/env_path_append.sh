#!/bin/bash

# 自动检测当前 shell 类型（zsh 或 bash）
SHELL_TYPE=$(basename "$SHELL")
RC_FILE=""

if [[ "$SHELL_TYPE" == "zsh" ]]; then
    RC_FILE="$HOME/.zshrc"
elif [[ "$SHELL_TYPE" == "bash" ]]; then
    RC_FILE="$HOME/.bash_profile"
else
    echo "Unsupported shell: $SHELL"
    exit 1
fi

echo "Detected shell type: $SHELL_TYPE"
echo "Environment variables will be saved to: $RC_FILE"

# 检查该文件是否存在，若不存在则创建
if [ ! -f "$RC_FILE" ]; then
    echo "Configuration file $RC_FILE does not exist. Creating it now."
    touch "$RC_FILE"
fi

# 获取用户输入路径
read -p "Enter the path you want to add to PATH: " NEW_PATH

# 去除首尾空格
NEW_PATH=$(echo "$NEW_PATH" | sed 's/^ *//;s/ *$//')

# 检查是否为空
if [ -z "$NEW_PATH" ]; then
    echo "Error: Path cannot be empty."
    exit 1
fi

# 检查是否是绝对路径
if [ ! -d "$NEW_PATH" ]; then
    echo "Warning: The path '$NEW_PATH' does not exist or is not a directory."
    read -p "Are you sure you want to continue? (y/n): " CONFIRM
    if [[ "$CONFIRM" != "y" && "$CONFIRM" != "Y" ]]; then
        echo "Operation cancelled."
        exit 0
    fi
fi

# 判断路径是否已经在 PATH 中（精确匹配）
case ":$PATH:" in
  *":$NEW_PATH:"*)
    echo "The path '$NEW_PATH' is already in PATH. No changes made."
    exit 0
    ;;
esac

# 更新当前会话的 PATH
export PATH="$PATH:$NEW_PATH"

# 删除旧的 export PATH 行（如果存在）
grep -q "^export PATH=" "$RC_FILE" && sed -i '' "/^export PATH=/d" "$RC_FILE"

# 将新的 PATH 写入配置文件
echo "export PATH=\"\$PATH:$NEW_PATH\"" >> "$RC_FILE"

# 刷新配置
source "$RC_FILE"

# 输出结果
echo "Path '$NEW_PATH' has been added to PATH and saved to: $RC_FILE"
echo "Current PATH: $PATH"