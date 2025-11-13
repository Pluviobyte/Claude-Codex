# Documentação de Referência da API

## 🔧 API dos Servidores MCP

### Sequential-thinking

**Funcionalidade**: Ferramenta de análise e raciocínio profundo

**Modo de chamada**:
```javascript
// Chamada de ferramenta MCP
sequential-thinking.prompt = "Problema que requer pensamento profundo"

// Chamada direta
npx -y @modelcontextprotocol/server-sequential-thinking
```

**Parâmetros de configuração**:
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

**Formato de saída**:
- Análise do processo de pensamento
- Identificação de riscos
- Sugestões de implementação
- Análise de condições de contorno

### Shrimp Task Manager

**Funcionalidade**: Ferramenta de planejamento e decomposição de tarefas

**Modo de chamada**:
```javascript
// Chamada de ferramenta MCP
shrimp-task-manager.create_task({
  name: "Nome da tarefa",
  description: "Descrição da tarefa",
  priority: "high|medium|low"
})
```

**Parâmetros de configuração**:
```json
{
  "command": "npx",
  "args": ["-y", "mcp-shrimp-task-manager"],
  "env": {
    "DATA_DIR": ".claude/shrimp",
    "TEMPLATES_USE": "pt",
    "ENABLE_GUI": "false"
  }
}
```

**Estrutura de dados**:
```json
{
  "task_id": "task-123",
  "name": "Nome da tarefa",
  "status": "pending|in_progress|completed",
  "priority": "high|medium|low",
  "created_at": "2025-11-05T10:30:00Z",
  "subtasks": []
}
```

### Codex

**Funcionalidade**: Análise profunda e geração de código

**Modo de chamada**:
```javascript
// Primeira chamada
mcp__codex__codex(
  model="gpt-5-codex",
  sandbox="danger-full-access",
  approval-policy="on-failure",
  prompt="[TASK_MARKER: AAAAMMDD-HHMMSS-XXXX]\nDescrição da tarefa"
)

// Continuar sessão
mcp__codex__codex-reply(conversationId="<ID>", prompt="Instrução subsequente")
```

**Parâmetros de configuração**:
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

**Tipos de análise suportados**:
- Varredura e recuperação de base de código
- Design de lógica complexa (>10 linhas de lógica principal)
- Revisão de qualidade e pontuação
- Coleta e análise de contexto

### Code Index

**Funcionalidade**: Indexação e pesquisa de código

**Modo de chamada**:
```bash
uvx code-index-mcp
```

**Parâmetros de configuração**:
```json
{
  "command": "uvx",
  "args": ["code-index-mcp"],
  "env": {
    "WORKING_DIR": ".claude"
  }
}
```

**Sintaxe de pesquisa**:
- Pesquisa de nome de arquivo: `filename:component`
- Pesquisa de conteúdo: `content:function_name`
- Pesquisa de tipo: `type:class|function|variable`

### Chrome DevTools

**Funcionalidade**: Integração de ferramentas de depuração de navegador

**Modo de chamada**:
```bash
npx chrome-devtools-mcp@latest
```

**Parâmetros de configuração**:
```json
{
  "command": "npx",
  "args": ["chrome-devtools-mcp@latest"],
  "env": {
    "WORKING_DIR": ".claude"
  }
}
```

**Operações suportadas**:
- Captura de tela de página
- Obtenção de logs do console
- Monitoramento de requisições de rede
- Manipulação DOM

### Exa Search

**Funcionalidade**: Pesquisa na web e recuperação de conteúdo

**Modo de chamada**:
```bash
npx -y exa-mcp-server
```

**Parâmetros de configuração**:
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

**Parâmetros de pesquisa**:
- `query`: Palavras-chave de pesquisa
- `num_results`: Número de resultados a retornar (padrão 10)
- `include_domains`: Limitar domínios de pesquisa
- `exclude_domains`: Excluir domínios de pesquisa

## 📁 API de Arquivos de Dados

### Arquivos de Contexto

**context-initial.json**:
```json
{
  "scan_type": "initial",
  "timestamp": "2025-11-05T10:30:00Z",
  "project_location": "Em qual módulo/arquivo está a funcionalidade",
  "current_implementation": "Como está implementado atualmente",
  "similar_cases": ["Caso similar 1", "Caso similar 2"],
  "tech_stack": ["Framework", "Linguagem", "Dependências"],
  "testing_info": "Arquivos de teste existentes e métodos de validação",
  "observations": {
    "anomalies": ["Anomalias encontradas"],
    "info_gaps": ["Áreas com informação insuficiente"],
    "suggestions": ["Direções sugeridas para aprofundamento"],
    "risks": ["Riscos potenciais"]
  }
}
```

**context-question-N.json**:
```json
{
  "question_id": "question-1",
  "target_question": "Dúvida específica a ser resolvida",
  "analysis_depth": "deep",
  "evidence": ["Evidência de trechos de código"],
  "conclusions": ["Conclusões da análise"],
  "recommendations": ["Ações recomendadas"],
  "timestamp": "2025-11-05T10:35:00Z"
}
```

### Arquivo de Progresso de Codificação

**coding-progress.json**:
```json
{
  "current_task_id": "task-123",
  "files_modified": ["src/foo.ts", "docs/bar.md"],
  "last_update": "2025-11-05T10:30:00Z",
  "status": "coding|review_needed|completed",
  "pending_questions": ["Como lidar com caso de contorno X?"],
  "complexity_estimate": "simple|moderate|complex",
  "progress_percentage": 75
}
```

### Arquivo de Gerenciamento de Sessão

**codex-sessions.json**:
```json
{
  "sessions": [
    {
      "task_marker": "20251105-1030-001",
      "conversation_id": "conv-123",
      "timestamp": "2025-11-05T10:30:00Z",
      "description": "Descrição da tarefa",
      "status": "active|completed|error"
    }
  ]
}
```

### Arquivo de Relatório de Revisão

**review-report.md**:
```markdown
# Relatório de Revisão de Código

## Metadados
- Horário da revisão: 2025-11-05 10:30
- Revisor: Codex
- ID da tarefa: task-123

## Detalhes da Pontuação
- Dimensão Técnica: 85/100
- Dimensão Estratégica: 90/100
- Pontuação Geral: 87/100

## Recomendação Clara
Aprovar / Devolver / Precisa Discussão

## Resultados da Verificação
- [x] Integridade dos campos de requisitos
- [x] Padrões de qualidade de código
- [ ] Cobertura completa de testes

## Riscos e Bloqueios
- Ponto de risco 1
- Problema de bloqueio 1

## Evidências de Suporte
1. Evidência 1
2. Evidência 2
```

### Arquivo de Log de Operações

**operations-log.md**:
```markdown
# Log de Operações

## 2025-11-05 10:30 - Início da Tarefa
- Operação: Iniciar nova tarefa
- Ferramenta: sequential-thinking
- Saída: Análise preliminar concluída

## 2025-11-05 10:35 - Coleta de Contexto
- Operação: Chamar Codex para varredura de código
- Ferramenta: mcp__codex__codex
- ID da sessão: conv-123
- Saída: context-initial.json gerado

## 2025-11-05 10:40 - Registro de Decisão
- Decisão: Adotar solução A
- Justificativa: Melhor desempenho, menor custo de manutenção
- Rejeitar sugestão do Codex: Sim
- Motivo: Requisitos especiais do projeto
```

## 🔄 API de Fluxo de Trabalho

### Chamada de Fluxo de Trabalho Padrão

```javascript
// 1. sequential-thinking
sequential_thinking("Analisar requisitos e riscos da tarefa")

// 2. Coleta de contexto do Codex
codex_context_collection({
  type: "structured_scan",
  output_file: ".claude/context-initial.json"
})

// 3. Planejamento com shrimp-task-manager
task_manager_create_plan({
  context: ".claude/context-initial.json",
  output_file: ".claude/task-plan.json"
})

// 4. Implementação da IA principal + Revisão do Codex
main_ai_implementation({
  plan: ".claude/task-plan.json"
})
codex_review({
  files: ["src/file1.ts", "src/file2.ts"],
  output_file: ".claude/review-report.md"
})
```

### Tratamento de Erros

```javascript
try {
  // Executar fluxo de trabalho
  await execute_workflow()
} catch (error) {
  // Registrar em operations-log.md
  log_operation("error", error.message)

  // Mecanismo de retry (máximo 3 vezes)
  if (retry_count < 3) {
    await retry_workflow()
  } else {
    // Relatar para IA principal
    report_to_main_ai(error)
  }
}
```

## 📊 API de Monitoramento

### Métricas de Desempenho

```javascript
// Obter tempo de resposta das ferramentas
const response_time = get_tool_metrics("sequential-thinking")

// Obter taxa de sucesso das sessões
const success_rate = get_session_metrics()

// Obter pontuação de qualidade de revisão de código
const quality_scores = get_review_metrics()
```

### Verificação de Saúde

```javascript
// Verificar status dos servidores MCP
const health_status = {
  "sequential-thinking": check_server_health("sequential-thinking"),
  "codex": check_server_health("codex"),
  "shrimp-task-manager": check_server_health("shrimp-task-manager")
}

// Verificar permissões do sistema de arquivos
const fs_permissions = check_permissions(".claude/")
```

## 🔧 API de Configuração

### Atualização Dinâmica de Configuração

```javascript
// Atualizar diretório de trabalho
update_config("working_directory", ".claude")

// Adicionar novo servidor MCP
add_mcp_server({
  name: "new-tool",
  config: {...}
})

// Atualizar ordem de chamada de ferramentas
update_execution_order([
  "sequential-thinking",
  "shrimp-task-manager",
  "codex",
  "new-tool"
])
```

### Validação de Configuração

```javascript
// Validar integridade da configuração
const validation_result = validate_config({
  required_fields: ["workflow", "mcpServers"],
  path_checks: [".claude"],
  permission_checks: ["read", "write"]
})
```
