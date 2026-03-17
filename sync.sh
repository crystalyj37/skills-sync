#!/bin/bash
# sync.sh - Skills Synchronization Utility

# 确定脚本所在的目录 (SKILL_DIR)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# 假设此脚本位于 ~/.claude/skills/skills-sync/sync.sh
# 那么 SOURCE_DIR 应该是 ~/.claude/skills
SOURCE_DIR="$(dirname "$SCRIPT_DIR")"

echo "========================================"
echo "Skills Sync Manager"
echo "========================================"
echo "Source Directory: $SOURCE_DIR"

if [ ! -d "$SOURCE_DIR" ]; then
    echo "Error: Source directory not found!"
    exit 1
fi

# 定义目标平台 (Bash 3.2 兼容数组)
TOOLS=("Codex" "OpenCode" "Gemini" "Antigravity" "Cursor" "Agents")
# 对应的配置根目录
PATHS=("$HOME/.codex" "$HOME/.opencode" "$HOME/.gemini" "$HOME/.gemini/antigravity" "$HOME/.cursor" "$HOME/.agents")

# 获取数组长度
COUNT=${#TOOLS[@]}

for (( i=0; i<${COUNT}; i++ )); do
    tool="${TOOLS[$i]}"
    config_dir="${PATHS[$i]}"
    target_link="$config_dir/skills"
    
    echo "----------------------------------------"
    echo "Checking $tool..."
    
    # 1. 确保配置目录存在 (仅当目录已存在时才同步，避免创建空目录)
    if [ ! -d "$config_dir" ]; then
        echo "  [SKIP] Config directory not found: $config_dir"
        continue
    fi

    # 2. 检查链接状态
    if [ -L "$target_link" ]; then
        # 是软链接，检查指向
        current_target=$(readlink "$target_link")
        if [ "$current_target" == "$SOURCE_DIR" ]; then
            echo "  [OK] Linked correctly."
        else
            echo "  [FIX] Symlink points to wrong location ($current_target)."
            echo "  > Updating link..."
            rm "$target_link"
            ln -s "$SOURCE_DIR" "$target_link"
        fi
    elif [ -d "$target_link" ]; then
        # 是真实目录，需要备份并替换
        echo "  [WARN] Found existing directory, not a symlink."
        backup_name="${target_link}_backup_$(date +%Y%m%d_%H%M%S)"
        echo "  > Backing up to $backup_name"
        mv "$target_link" "$backup_name"
        echo "  > Creating symlink..."
        ln -s "$SOURCE_DIR" "$target_link"
    elif [ -e "$target_link" ]; then
        # 是文件，备份并替换
        echo "  [WARN] Found existing file."
        backup_name="${target_link}_backup_$(date +%Y%m%d_%H%M%S)"
        echo "  > Backing up to $backup_name"
        mv "$target_link" "$backup_name"
        echo "  > Creating symlink..."
        ln -s "$SOURCE_DIR" "$target_link"
    else
        # 不存在，直接创建
        echo "  [NEW] Creating link..."
        ln -s "$SOURCE_DIR" "$target_link"
    fi
done

echo "========================================"
echo "Synchronization Complete!"
echo "All tools are now sharing: $SOURCE_DIR"
