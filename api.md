# API 参考文档

## 🔧 MCP 服务器 API

### Sequential-thinking

**功能**：深度推理分析工具

**调用方式**：
```javascript
// MCP 工具调用
sequential-thinking.prompt = "需要深度思考的问题"

// 直接调用
npx -y @modelcontextprotocol/server-sequential-thinking
```

**配置参数**：
```json
{
  "type": "stdio",
  "command": "npx",
  "args": ["-y", "@modelcontextprotocol/server-sequential-thinking"],
  "env": {
    "WORKING_DIR": ".claude"
  }
}
```

**输出格式**：
- 思考过程分析
- 风险识别
- 实现建议
- 边界条件分析

### Shrimp Task Manager

**功能**：任务规划和拆解工具

**调用方式**：
```javascript
// MCP 工具调用
shrimp-task-manager.create_task({
  name: "任务名称",
  description: "任务描述",
  priority: "high|medium|low"
})
```

**配置参数**：
```json
{
  "command": "npx",
  "args": ["-y", "mcp-shrimp-task-manager"],
  "env": {
    "DATA_DIR": ".claude/shrimp",
    "TEMPLATES_USE": "zh",
    "ENABLE_GUI": "false"
  }
}
```

**数据结构**：
```json
{
  "task_id": "task-123",
  "name": "任务名称",
  "status": "pending|in_progress|completed",
  "priority": "high|medium|low",
  "created_at": "2025-11-05T10:30:00Z",
  "subtasks": []
}
```

### Codex

**功能**：深度代码分析和生成

**调用方式**：
```javascript
// 首次调用
mcp__codex__codex(
  model="gpt-5-codex",
  sandbox="danger-full-access",
  approval-policy="on-failure",
  prompt="[TASK_MARKER: YYYYMMDD-HHMMSS-XXXX]\n任务描述"
)

// 继续会话
mcp__codex__codex-reply(conversationId="<ID>", prompt="后续指令")
```

**配置参数**：
```json
{
  "type": "stdio",
  "command": "codex",
  "args": ["mcp-server"],
  "env": {
    "WORKING_DIR": ".claude"
  }
}
```

**支持的分析类型**：
- 代码库扫描和检索
- 复杂逻辑设计（>10行核心逻辑）
- 质量审查和评分
- 上下文收集和分析

### Code Index

**功能**：代码索引和搜索

**调用方式**：
```bash
uvx code-index-mcp
```

**配置参数**：
```json
{
  "command": "uvx",
  "args": ["code-index-mcp"],
  "env": {
    "WORKING_DIR": ".claude"
  }
}
```

**搜索语法**：
- 文件名搜索：`filename:component`
- 内容搜索：`content:function_name`
- 类型搜索：`type:class|function|variable`

### Chrome DevTools

**功能**：浏览器调试工具集成

**调用方式**：
```bash
npx chrome-devtools-mcp@latest
```

**配置参数**：
```json
{
  "command": "npx",
  "args": ["chrome-devtools-mcp@latest"],
  "env": {
    "WORKING_DIR": ".claude"
  }
}
```

**支持的操作**：
- 页面截图
- 控制台日志获取
- 网络请求监控
- DOM 操作

### Exa Search

**功能**：网络搜索和内容检索

**调用方式**：
```bash
npx -y exa-mcp-server
```

**配置参数**：
```json
{
  "command": "npx",
  "args": ["-y", "exa-mcp-server"],
  "env": {
    "EXA_API_KEY": "your-api-key-here",
    "WORKING_DIR": ".claude"
  }
}
```

**搜索参数**：
- `query`: 搜索关键词
- `num_results`: 返回结果数量（默认10）
- `include_domains`: 限制搜索域名
- `exclude_domains`: 排除搜索域名

## 📁 数据文件 API

### 上下文文件

**context-initial.json**：
```json
{
  "scan_type": "initial",
  "timestamp": "2025-11-05T10:30:00Z",
  "project_location": "功能在哪个模块/文件",
  "current_implementation": "现在如何实现",
  "similar_cases": ["相似案例1", "相似案例2"],
  "tech_stack": ["框架", "语言", "依赖"],
  "testing_info": "现有测试文件和验证方式",
  "observations": {
    "anomalies": ["发现的异常"],
    "info_gaps": ["信息不足之处"],
    "suggestions": ["建议深入的方向"],
    "risks": ["潜在风险"]
  }
}
```

**context-question-N.json**：
```json
{
  "question_id": "question-1",
  "target_question": "要解决的具体疑问",
  "analysis_depth": "deep",
  "evidence": ["代码片段证据"],
  "conclusions": ["分析结论"],
  "recommendations": ["建议行动"],
  "timestamp": "2025-11-05T10:35:00Z"
}
```

### 编码进度文件

**coding-progress.json**：
```json
{
  "current_task_id": "task-123",
  "files_modified": ["src/foo.ts", "docs/bar.md"],
  "last_update": "2025-11-05T10:30:00Z",
  "status": "coding|review_needed|completed",
  "pending_questions": ["如何处理边界情况X？"],
  "complexity_estimate": "simple|moderate|complex",
  "progress_percentage": 75
}
```

### 会话管理文件

**codex-sessions.json**：
```json
{
  "sessions": [
    {
      "task_marker": "20251105-1030-001",
      "conversation_id": "conv-123",
      "timestamp": "2025-11-05T10:30:00Z",
      "description": "任务描述",
      "status": "active|completed|error"
    }
  ]
}
```

### 审查报告文件

**review-report.md**：
```markdown
# 代码审查报告

## 元数据
- 审查时间：2025-11-05 10:30
- 审查者：Codex
- 任务ID：task-123

## 评分详情
- 技术维度：85/100
- 战略维度：90/100
- 综合评分：87/100

## 明确建议
通过 / 退回 / 需讨论

## 核对结果
- [x] 需求字段完整性
- [x] 代码质量标准
- [ ] 测试覆盖完整

## 风险与阻塞
- 风险点1
- 阻塞问题1

## 支持论据
1. 论据1
2. 论据2
```

### 操作日志文件

**operations-log.md**：
```markdown
# 操作日志

## 2025-11-05 10:30 - 任务开始
- 操作：启动新任务
- 工具：sequential-thinking
- 输出：初步分析完成

## 2025-11-05 10:35 - 上下文收集
- 操作：调用Codex进行代码扫描
- 工具：mcp__codex__codex
- 会话ID：conv-123
- 输出：context-initial.json生成

## 2025-11-05 10:40 - 决策记录
- 决策：采用方案A
- 理由：性能更好，维护成本低
- 推翻Codex建议：是
- 原因：项目特殊需求
```

## 🔄 工作流程 API

### 标准工作流调用

```javascript
// 1. sequential-thinking
sequential_thinking("分析任务需求和风险")

// 2. Codex 上下文收集
codex_context_collection({
  type: "structured_scan",
  output_file: ".claude/context-initial.json"
})

// 3. shrimp-task-manager 规划
task_manager_create_plan({
  context: ".claude/context-initial.json",
  output_file: ".claude/task-plan.json"
})

// 4. 主AI编码 + Codex审查
main_ai_implementation({
  plan: ".claude/task-plan.json"
})
codex_review({
  files: ["src/file1.ts", "src/file2.ts"],
  output_file: ".claude/review-report.md"
})
```

### 错误处理

```javascript
try {
  // 执行工作流
  await execute_workflow()
} catch (error) {
  // 记录到 operations-log.md
  log_operation("error", error.message)

  // 重试机制（最多3次）
  if (retry_count < 3) {
    await retry_workflow()
  } else {
    // 上报主AI
    report_to_main_ai(error)
  }
}
```

## 📊 监控 API

### 性能指标

```javascript
// 获取工具响应时间
const response_time = get_tool_metrics("sequential-thinking")

// 获取会话成功率
const success_rate = get_session_metrics()

// 获取代码审查质量分数
const quality_scores = get_review_metrics()
```

### 健康检查

```javascript
// 检查MCP服务器状态
const health_status = {
  "sequential-thinking": check_server_health("sequential-thinking"),
  "codex": check_server_health("codex"),
  "shrimp-task-manager": check_server_health("shrimp-task-manager")
}

// 检查文件系统权限
const fs_permissions = check_permissions(".claude/")
```

## 🔧 配置 API

### 动态配置更新

```javascript
// 更新工作目录
update_config("working_directory", ".claude")

// 添加新的MCP服务器
add_mcp_server({
  name: "new-tool",
  config: {...}
})

// 更新工具调用顺序
update_execution_order([
  "sequential-thinking",
  "shrimp-task-manager",
  "codex",
  "new-tool"
])
```

### 配置验证

```javascript
// 验证配置完整性
const validation_result = validate_config({
  required_fields: ["workflow", "mcpServers"],
  path_checks: [".claude"],
  permission_checks: ["read", "write"]
})
```