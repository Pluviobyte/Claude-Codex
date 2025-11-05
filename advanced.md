# 高级配置指南

## 🔧 工作流程配置

### 严格工具调用顺序

根据CLAUDE.md要求，必须严格按照以下顺序执行：

```json
{
  "workflow": {
    "execution_order": [
      "sequential-thinking",
      "shrimp-task-manager",
      "codex"
    ],
    "working_directory": ".claude"
  }
}
```

### 职责分离配置

**主AI（Claude Code）职责**：
- ✅ 任务规划和拆解（使用 shrimp-task-manager）
- ✅ 直接代码编写（使用 Read/Edit/Write）
- ✅ 简单逻辑实现（<10 行核心逻辑）
- ✅ 最终决策确认（基于 Codex 建议）
- ✅ 决策记录留痕（operations-log.md）

**Codex（支持AI）职责**：
- ✅ 深度推理分析（使用 sequential-thinking）
- ✅ 全面代码检索（充分时间进行代码库扫描）
- ✅ 复杂逻辑设计（>10 行核心逻辑）
- ✅ 上下文收集和分析（输出到 `.claude/context-*.json`）
- ✅ 质量审查评分（代码审查、风险识别）

## 📁 目录结构规范

所有工作文件必须写入项目本地 `.claude/` 目录：

```
<project>/.claude/
├── context-initial.json        ← 初步收集（Codex 输出）
├── context-question-N.json     ← 深度分析（Codex 输出）
├── coding-progress.json        ← 实时编码状态（主AI 输出）
├── operations-log.md           ← 决策记录（主AI 输出）
├── review-report.md            ← 审查报告（Codex 输出）
├── codex-sessions.json         ← 会话管理（Codex 持久化）
├── shrimp/                     ← 任务管理数据
├── codex/                      ← Codex 工作数据
├── context/                    ← 上下文数据
├── logs/                       ← 日志文件
└── cache/                      ← 缓存数据
```

## 🔄 标准工作流程（6步骤）

### 1. 分析需求
- 使用 sequential-thinking 深度理解需求
- Codex 进行全面上下文收集

### 2. 获取上下文
- Codex 执行结构化快速扫描
- 输出到 `.claude/context-initial.json`
- 主AI 识别关键疑问

### 3. 选择工具
- 根据任务复杂度选择合适的工具组合
- 遵循严格的工具调用顺序

### 4. 执行任务
- 主AI 直接编码（简单逻辑）
- 复杂逻辑委托 Codex 设计
- 实时更新 `coding-progress.json`

### 5. 验证质量
- Codex 使用 sequential-thinking 深度审查
- 生成评分和建议（写入 `.claude/review-report.md`）
- 主AI 基于建议快速决策

### 6. 存储知识
- 记录决策过程到 `operations-log.md`
- 更新上下文文件
- 维护会话状态

## 🎯 Codex 调用规范

### 首次调用
```javascript
mcp__codex__codex(
  model="gpt-5-codex",
  sandbox="danger-full-access",
  approval-policy="on-failure",
  prompt="[TASK_MARKER: YYYYMMDD-HHMMSS-XXXX]\n目标：[任务描述]\n输出：[交付物列表]"
)
```

### 继续会话
```javascript
mcp__codex__codex-reply(conversationId="<ID>", prompt="[指令]")
```

### conversationId 管理
- 主AI生成 task_marker：`[TASK_MARKER: YYYYMMDD-HHMMSS-XXXX]`
- Codex 查询并持久化到 `.claude/codex-sessions.json`
- 响应末尾返回：`[CONVERSATION_ID]: <conversationId>`

## 📊 质量审查评分系统

### 评分维度
- **技术维度**（代码质量、测试覆盖、规范遵循）
- **战略维度**（需求匹配、架构一致、风险评估）
- **综合评分**（0-100）

### 决策规则
- ≥90分且建议"通过" → 直接确认通过
- <80分且建议"退回" → 直接确认退回
- 80-89分或建议"需讨论" → 仔细审阅后决策

## ⚡ 自动化执行策略

### 默认自动执行（无需确认）
- ✅ 所有文件读写操作
- ✅ 标准工具调用（code-index、exa、grep等）
- ✅ 代码编写、修改、重构
- ✅ 文档生成和更新
- ✅ 测试执行和验证脚本运行
- ✅ 任务规划和分解、上下文收集
- ✅ 调用 mcp__codex__codex 或 codex-reply

### 需要确认的例外情况
- ⚠️ 删除核心配置文件
- ⚠️ 数据库 schema 的破坏性变更
- ⚠️ Git push 到远程仓库
- ⚠️ 连续3次相同错误后需要策略调整

## 🔍 高级功能配置

### Exa 搜索配置
```json
{
  "exa": {
    "command": "npx",
    "args": ["-y", "exa-mcp-server"],
    "env": {
      "EXA_API_KEY": "your-api-key-here",
      "WORKING_DIR": ".claude"
    }
  }
}
```

### Chrome DevTools 集成
```json
{
  "chrome-devtools": {
    "command": "npx",
    "args": ["chrome-devtools-mcp@latest"],
    "env": {
      "WORKING_DIR": ".claude"
    }
  }
}
```

### Code Index 配置
```json
{
  "code-index": {
    "command": "uvx",
    "args": ["code-index-mcp"],
    "env": {
      "WORKING_DIR": ".claude"
    }
  }
}
```

## 🛠️ 故障排除

### 常见问题
1. **工具调用顺序错误** → 检查 workflow.execution_order 配置
2. **路径规范问题** → 确保所有工具使用 `.claude/` 目录
3. **会话管理失败** → 检查 `.claude/codex-sessions.json` 文件
4. **权限问题** → 确保 `.claude/` 目录有写权限

### 调试命令
```bash
# 验证配置
./verify-config.sh

# 检查工具调用顺序
grep -A 10 "execution_order" .claude/claude_desktop_config.json

# 查看会话状态
cat .claude/codex-sessions.json

# 检查工作目录权限
ls -la .claude/
```

## 📈 性能优化

### 建议设置
- 使用 SSD 存储提高 I/O 性能
- 配置足够的内存（推荐 8GB+）
- 定期清理 `.claude/cache/` 目录
- 使用本地缓存减少重复计算

### 监控指标
- 工具响应时间
- 会话成功率
- 代码审查质量分数
- 任务完成时间