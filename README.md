# Claude Code + Codex 协作开发环境

> 🚀 3步配置，5分钟上手，让AI协作开发变得简单

## 📋 快速开始

### 🎯 第一步：运行一键安装
```bash
curl -sSL https://raw.githubusercontent.com/claude-codex/setup/main/install.sh | bash
```

或者手动下载并运行：
```bash
# 下载安装脚本
curl -O https://raw.githubusercontent.com/claude-codex/setup/main/install.sh
chmod +x install.sh
./install.sh
```

### 📋 第二步：选择配置类型
脚本会提供三种配置选项：
- 简单配置：基础协作功能
- 标准配置：完整开发环境
- 高级配置：企业级功能（可选Exa搜索需要API密钥）

### ✅ 第三步：重启并验证
1. 重启Claude Code应用
2. 在聊天中输入：`/available-tools`
3. 确认能看到codex相关工具

## 🛠️ 配置选项

### 简单配置 (推荐新手)
- Claude Code + Codex 基础协作
- Sequential-thinking 深度思考
- 适合快速体验和学习

### 标准配置 (推荐日常使用)
- 完整的协作开发环境
- 任务管理和代码索引
- 适合日常开发工作

### 高级配置 (推荐高级用户)
- 企业级开发环境
- 浏览器调试和网络搜索
- 适合复杂项目开发

## 🎯 核心功能

### 🤖 AI协作模式
- **Claude Code**: 项目管理和代码执行
- **Codex**: 深度代码分析和生成
- **智能分工**: 简单任务Claude直接处理，复杂逻辑委托Codex

### 🔧 智能工作流
1. **需求理解** → 深度思考分析
2. **上下文收集** → 全面代码检索
3. **任务规划** → 智能任务分解
4. **代码执行** → 小步迭代开发
5. **质量验证** → 自动化测试和审查

### ⚡ 核心优势
- **零学习成本**: 基于熟悉的Claude Code界面
- **智能默认**: 预配置最佳实践，减少配置决策
- **渐进增强**: 从简单到高级，按需扩展功能
- **高可靠性**: 完整的错误处理和自动恢复

## 📚 使用示例

### 基础对话
```
用户: 帮我创建一个React组件，显示用户列表

Claude: 我来帮你创建一个React组件显示用户列表。让我先调用Codex进行深度分析，然后实现这个功能。
```

### 复杂任务
```
用户: 实现一个完整的用户管理系统，包括认证、CRUD操作和权限管理

Claude: 这是一个复杂的多模块任务。让我使用sequential-thinking进行深度分析，然后制定详细的实施计划。
```

## 🔍 故障排除

### 常见问题

**Q: 看不到codex工具？**
A: 确保配置文件正确安装，然后重启Claude Code

**Q: Codex连接失败？**
A: 确保Codex已正确安装并可以运行 `codex mcp-server` 命令

**Q: MCP服务器连接失败？**
A: 运行安装脚本进行修复，或手动安装相关依赖

详细故障排除指南请查看：[troubleshooting.md](troubleshooting.md)

## 📖 更多文档

- [配置文件说明](README-config.md)
- [故障排除指南](troubleshooting.md)
- [高级配置指南](advanced.md)
- [API参考文档](api.md)

## 🤝 贡献

欢迎贡献代码和改进建议！

## 📄 许可证

MIT License - 详见 [LICENSE](LICENSE) 文件

---

**开始你的AI协作开发之旅吧！** 🚀