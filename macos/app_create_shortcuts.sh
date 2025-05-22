#!/bin/bash

# 源路径：移动硬盘中的 Applications 文件夹
SOURCE_DIR="/Volumes/DK512/Applications"

# 目标路径：系统全局的 Applications 文件夹
TARGET_DIR="/Applications"

# 检查源目录是否存在
if [ ! -d "$SOURCE_DIR" ]; then
  echo "源目录不存在: $SOURCE_DIR"
  exit 1
fi

# 遍历所有 .app 应用
for app in "$SOURCE_DIR"/*.app; do
  # 获取应用名称
  app_name=$(basename "$app")

  # 构建目标链接路径
  target_link="$TARGET_DIR/$app_name"

  # 如果已存在同名链接或文件，跳过或提示是否覆盖
  if [ -e "$target_link" ]; then
    echo "已存在: $target_link，跳过..."
  else
    # 创建符号链接
    ln -s "$app" "$target_link"
    if [ $? -eq 0 ]; then
      echo "已创建快捷方式: $target_link"
    else
      echo "无法创建快捷方式: $target_link"
    fi
  fi
done

echo "操作完成。"