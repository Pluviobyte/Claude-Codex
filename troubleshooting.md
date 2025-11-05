# 故障排除指南

## 🔧 常见问题解决

### ❌ 看不到codex工具

**问题**: 在Claude Code中输入 `/available-tools` 看不到codex相关工具

**可能原因**:
1. 配置文件未正确安装
2. Claude Code未重启
3. MCP服务器未启动

**解决方案**:
```bash
# 1. 验证配置文件
./verify-config.sh

# 2. 检查配置文件位置
ls -la ~/Library/Application\ Support/Claude/claude_desktop_config.json  # macOS
ls -la ~/.config/claude/claude_desktop_config.json  # Linux
ls -la %APPDATA%/Claude/claude_desktop_config.json  # Windows

# 3. 重新安装配置
./install.sh
```

### 🔑 API密钥问题

**问题**: API调用失败，提示认证错误

**可能原因**:
1. API密钥格式错误
2. API密钥已过期
3. 账户余额不足

**解决方案**:
```bash
# 1. 检查API密钥格式
grep "OPENAI_API_KEY" ~/.config/claude/claude_desktop_config.json

# 2. 测试API密钥
curl -H "Authorization: Bearer YOUR_API_KEY" https://api.openai.com/v1/models

# 3. 更新API密钥
# 编辑配置文件，替换API密钥
```

**API密钥格式要求**:
- 以 `sk-` 开头
- 总长度51个字符
- 包含字母和数字

### 🌐 网络连接问题

**问题**: 无法连接到OpenAI API

**可能原因**:
1. 网络防火墙阻止
2. 代理设置问题
3. DNS解析问题

**解决方案**:
```bash
# 1. 测试网络连接
curl -I https://api.openai.com/v1/models

# 2. 检查代理设置
echo $HTTP_PROXY
echo $HTTPS_PROXY

# 3. 使用代理（如果需要）
export HTTPS_PROXY=http://your-proxy:port
```

### 📦 依赖安装失败

**问题**: npm或pip包安装失败

**可能原因**:
1. 权限不足
2. 网络问题
3. 版本冲突

**解决方案**:
```bash
# 1. 使用sudo安装（Linux/macOS）
sudo npm install -g @modelcontextprotocol/server-sequential-thinking

# 2. 清除npm缓存
npm cache clean --force

# 3. 使用国内镜像源
npm config set registry https://registry.npmmirror.com

# 4. 手动安装Python包
pip3 install --user uv
```

### 🚀 MCP服务器启动失败

**问题**: MCP服务器无法正常启动

**可能原因**:
1. Node.js版本不兼容
2. Python环境问题
3. 端口被占用

**解决方案**:
```bash
# 1. 检查Node.js版本
node --version  # 需要 >= 16.0.0

# 2. 检查Python版本
python3 --version  # 需要 >= 3.8

# 3. 手动测试MCP服务器
npx @modelcontextprotocol/server-sequential-thinking --version
codex --version

# 4. 查看错误日志
tail -f ~/.claude/logs/*.log
```

## 🔍 诊断工具

### 配置验证脚本
```bash
# 运行完整配置检查
./verify-config.sh
```

### 手动检查步骤
```bash
# 1. 检查配置文件语法
python3 -m json.tool ~/.config/claude/claude_desktop_config.json

# 2. 测试MCP服务器
npx -y @modelcontextprotocol/server-sequential-thinking --help
codex mcp-server --help

# 3. 检查Claude Code版本
# 在Claude Code中输入: /version
```

## 📋 系统要求

### 最低要求
- **操作系统**: Windows 10+, macOS 10.15+, Ubuntu 18.04+
- **Node.js**: 16.0.0+
- **Python**: 3.8+
- **内存**: 4GB RAM
- **存储**: 1GB可用空间

### 推荐配置
- **操作系统**: 最新版本的Windows/macOS/Linux
- **Node.js**: 18.0.0+
- **Python**: 3.10+
- **内存**: 8GB+ RAM
- **存储**: 2GB+可用空间
- **网络**: 稳定的互联网连接

## 🔄 重置配置

### 完全重置
```bash
# 1. 备份现有配置
cp ~/.config/claude/claude_desktop_config.json ~/.config/claude/claude_desktop_config.json.backup

# 2. 删除配置文件
rm ~/.config/claude/claude_desktop_config.json

# 3. 重新安装
./install.sh
```

### 清理依赖
```bash
# 卸载npm包
npm uninstall -g @modelcontextprotocol/server-sequential-thinking
npm uninstall -g mcp-shrimp-task-manager
npm uninstall -g chrome-devtools-mcp
npm uninstall -g exa-mcp-server

# 卸载Python包
pip uninstall uv
```

## 📞 获取帮助

### 社区支持
- **GitHub Issues**: https://github.com/claude-codex/setup/issues
- **讨论区**: https://github.com/claude-codex/setup/discussions

### 日志收集
```bash
# 收集系统信息
./collect-logs.sh

# 手动收集日志
echo "=== 系统信息 ===" > debug.log
uname -a >> debug.log
node --version >> debug.log
python3 --version >> debug.log
echo "" >> debug.log

echo "=== 配置文件 ===" >> debug.log
cat ~/.config/claude/claude_desktop_config.json >> debug.log
echo "" >> debug.log

echo "=== 网络测试 ===" >> debug.log
curl -I https://api.openai.com/v1/models >> debug.log
```

## 🎯 性能优化

### API调用优化
- 使用适当的模型（gpt-4比gpt-3.5更贵但更准确）
- 设置合理的调用限制
- 缓存常用结果

### 本地优化
- 确保足够的内存
- 使用SSD存储
- 关闭不必要的后台应用

### 网络优化
- 使用稳定的网络连接
- 考虑使用CDN加速
- 设置合理的超时时间

---

如果以上解决方案都无法解决你的问题，请创建GitHub Issue并提供详细的错误信息和系统环境。