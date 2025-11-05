# Claude Code + Codex 配置文件说明

## 📁 配置文件选择

### 1. 简单配置 (推荐新手)
- **文件**: `config-simple.json`
- **功能**: Claude Code + Codex 基础协作
- **包含**: Sequential-thinking (深度思考)
- **适用**: 快速体验和基础开发

### 2. 标准配置 (推荐日常使用)
- **文件**: `claude-desktop-config.json`
- **功能**: 完整的协作开发环境
- **包含**: 任务管理 + 代码索引
- **适用**: 日常开发工作

### 3. 高级配置 (推荐高级用户)
- **文件**: `config-advanced.json`
- **功能**: 企业级开发环境
- **包含**: 浏览器调试 + 网络搜索
- **适用**: 复杂项目和高级开发

## 🔧 配置步骤

### 第一步：选择配置文件
根据你的需求选择合适的配置文件。

### 第二步：设置API密钥
编辑配置文件，替换以下内容：
```json
"OPENAI_API_KEY": "your-openai-api-key-here"
```
替换为你的真实OpenAI API密钥。

可选配置：
```json
"EXA_API_KEY": "your-exa-api-key-here"
```
如果使用高级配置，可以添加Exa搜索API密钥。

### 第三步：复制到正确位置
**macOS**:
```bash
cp claude-desktop-config.json ~/Library/Application\ Support/Claude/claude_desktop_config.json
```

**Windows**:
```cmd
copy claude-desktop-config.json %APPDATA%\Claude\claude_desktop_config.json
```

**Linux**:
```bash
cp claude-desktop-config.json ~/.config/claude/claude_desktop_config.json
```

### 第四步：重启Claude Code
重启Claude Code应用，配置将自动生效。

## ✅ 验证配置

重启后，在Claude Code中输入：
```
/available-tools
```

如果看到codex相关的工具，说明配置成功！