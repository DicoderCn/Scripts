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

# 检查配置文件是否存在，若不存在则创建
if [ ! -f "$RC_FILE" ]; then
    echo "Configuration file $RC_FILE does not exist. Creating it now."
    touch "$RC_FILE"
fi

# 获取用户输入的环境变量名称和值
read -p "Enter environment variable name: " VAR_NAME
VAR_NAME=$(echo "$VAR_NAME" | sed 's/^ *//;s/ *$//')

if [[ -z "$VAR_NAME" ]]; then
    echo "Error: Variable name cannot be empty."
    exit 1
fi

read -p "Enter value for $VAR_NAME: " VAR_VALUE
VAR_VALUE=$(echo "$VAR_VALUE" | sed 's/^ *//;s/ *$//')

# 判断是否已经存在这个变量
VAR_EXISTS=$(grep -E "^export[[:space:]]+$VAR_NAME=" "$RC_FILE")

if [[ -n "$VAR_EXISTS" ]]; then
    echo "Variable '$VAR_NAME' already exists in $RC_FILE. Updating its value."
    # 删除旧的 export 行
    sed -i '' "/^export[[:space:]]\+$VAR_NAME=/d" "$RC_FILE"
fi

# 写入新的环境变量
echo "export $VAR_NAME=\"$VAR_VALUE\"" >> "$RC_FILE"

# 更新当前 shell 会话中的变量
export "$VAR_NAME"="$VAR_VALUE"

# 重新加载配置文件
source "$RC_FILE"

# 输出结果
echo "Environment variable '$VAR_NAME' has been set to: $VAR_VALUE"
echo "It is now available in the current session and saved to: $RC_FILE"