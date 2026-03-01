---
name: Skills Sync Manager
description: 用于在多个 AI 平台间同步 Claude Code Skills 的管理工具
---

# Skills Sync Manager

这是一个用于管理和同步 Claude Code Skills 的工具。它允许你将 `~/.claude/skills` 作为中心仓库，并自动将这些 Skills 同步（软链接）到其他支持的 AI 开发工具。

## 核心理念

1.  **单一数据源 (SSOT)**: 所有的 Skills 都存放在 `~/.claude/skills`。
2.  **共享使用**: 其他平台（如 Codex, OpenCode, Cursor 等）通过软链接直接使用同一份配置。
3.  **自动化维护**: 通过运行同步脚本自动修复断链或添加新平台的支持。

## 如何使用

### 1. 同步 Skills

当你添加了新的 Skill 或者想确保所有平台配置正确时，运行以下命令：

```bash
~/.claude/skills/skills-sync/sync.sh
```

或者如果你的环境支持，直接调用 Skill 命令（需配置）：
`/sync-skills`

### 2. 添加新 Skill

只需将 Skill 文件夹放入 `~/.claude/skills/` 目录下即可。无需对其他平台做任何操作，因为它们链接的是整个 `skills` 目录。

### 3. 支持的平台

目前脚本会自动检测以下平台，并仅在**配置目录已存在**时进行同步：
- Claude Code (`~/.claude`)
- Codex (`~/.codex`)
- OpenCode (`~/.opencode`)
- Gemini CLI (`~/.gemini`)
- Antigravity (`~/.gemini/antigravity`)
- Cursor (`~/.cursor`)

## 维护

如果脚本报错或需要添加新平台，请编辑 `sync.sh` 文件中的 `TOOLS` 和 `PATHS` 数组。
