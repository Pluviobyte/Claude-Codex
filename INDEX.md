# Claude Code + Codex 协作开发环境

## 📁 项目结构

```
claude+codex/
├── README.md                    # 主要使用指南
├── README-config.md            # 配置文件详细说明
├── troubleshooting.md          # 故障排除指南
├── INDEX.md                    # 项目总览（本文件）
├── install.sh                  # 一键安装脚本
├── verify-config.sh            # 配置验证脚本
├── claude-desktop-config.json  # 标准配置模板
├── config-simple.json          # 简单配置模板
└── config-advanced.json        # 高级配置模板
```

## 🚀 快速开始

### 3步配置，5分钟上手

1. **一键安装**
   ```bash
   curl -sSL https://raw.githubusercontent.com/claude-codex/setup/main/install.sh | bash
   ```

2. **设置API密钥**
   - 准备OpenAI API密钥
   - 在安装过程中输入密钥

3. **重启验证**
   - 重启Claude Code
   - 输入 `/available-tools` 验证

## 📋 文档说明

| 文档 | 描述 | 适用人群 |
|------|------|----------|
| [README.md](README.md) | 主要使用指南 | 所有用户 |
| [README-config.md](README-config.md) | 配置文件详细说明 | 需要自定义配置的用户 |
| [troubleshooting.md](troubleshooting.md) | 故障排除指南 | 遇到问题的用户 |

## 🛠️ 工具脚本

| 脚本 | 功能 | 使用方法 |
|------|------|----------|
| [install.sh](install.sh) | 一键安装配置 | `./install.sh` |
| [verify-config.sh](verify-config.sh) | 验证配置正确性 | `./verify-config.sh` |

## ⚙️ 配置模板

| 配置文件 | 复杂度 | 适用场景 |
|----------|--------|----------|
| [config-simple.json](config-simple.json) | 简单 | 快速体验、基础开发 |
| [claude-desktop-config.json](claude-desktop-config.json) | 标准 | 日常开发工作 |
| [config-advanced.json](config-advanced.json) | 高级 | 复杂项目、企业级应用 |

## 🎯 核心特性

- **零学习成本**: 基于熟悉的Claude Code界面
- **智能协作**: Claude Code + Codex 双AI协作
- **一键配置**: 自动化安装和配置
- **多级复杂度**: 从简单到高级，按需选择
- **跨平台支持**: Windows/macOS/Linux

## 🤝 协作模式

### Claude Code (主AI)
- ✅ 项目管理和任务规划
- ✅ 简单代码编写和执行
- ✅ 用户交互和最终决策
- ✅ 配置管理和环境设置

### Codex (支持AI)
- ✅ 深度代码分析和生成
- ✅ 复杂算法设计和优化
- ✅ 代码质量审查和评估
- ✅ 上下文收集和知识检索

## 📞 获取帮助

如果遇到问题：

1. **首先运行**: `./verify-config.sh` 检查配置
2. **查看**: [troubleshooting.md](troubleshooting.md) 故障排除指南
3. **提交**: GitHub Issue 获取社区支持

---

开始你的AI协作开发之旅！🚀