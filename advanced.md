# Guia de Configuração Avançada

## 🔧 Configuração de Fluxo de Trabalho

### Ordem Estrita de Chamada de Ferramentas

De acordo com os requisitos do CLAUDE.md, deve ser executado estritamente na seguinte ordem:

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

### Configuração de Separação de Responsabilidades

**Responsabilidades da IA Principal (Claude Code)**:
- ✅ Planejamento e decomposição de tarefas (usando shrimp-task-manager)
- ✅ Escrita direta de código (usando Read/Edit/Write)
- ✅ Implementação de lógica simples (<10 linhas de lógica principal)
- ✅ Confirmação de decisão final (baseado em sugestões do Codex)
- ✅ Registro de rastreamento de decisões (operations-log.md)

**Responsabilidades do Codex (IA de Suporte)**:
- ✅ Análise e raciocínio profundo (usando sequential-thinking)
- ✅ Pesquisa completa de código (tempo suficiente para varredura da base de código)
- ✅ Design de lógica complexa (>10 linhas de lógica principal)
- ✅ Coleta e análise de contexto (saída para `.claude/context-*.json`)
- ✅ Pontuação de revisão de qualidade (revisão de código, identificação de riscos)

## 📁 Especificação de Estrutura de Diretórios

Todos os arquivos de trabalho devem ser escritos no diretório local `.claude/` do projeto:

```
<project>/.claude/
├── context-initial.json        ← Coleta preliminar (saída do Codex)
├── context-question-N.json     ← Análise profunda (saída do Codex)
├── coding-progress.json        ← Estado de codificação em tempo real (saída da IA principal)
├── operations-log.md           ← Registro de decisões (saída da IA principal)
├── review-report.md            ← Relatório de revisão (saída do Codex)
├── codex-sessions.json         ← Gerenciamento de sessão (persistência do Codex)
├── shrimp/                     ← Dados de gerenciamento de tarefas
├── codex/                      ← Dados de trabalho do Codex
├── context/                    ← Dados de contexto
├── logs/                       ← Arquivos de log
└── cache/                      ← Dados em cache
```

## 🔄 Fluxo de Trabalho Padrão (6 etapas)

### 1. Analisar Requisitos
- Usar sequential-thinking para compreensão profunda dos requisitos
- Codex realiza coleta abrangente de contexto

### 2. Obter Contexto
- Codex executa varredura rápida estruturada
- Saída para `.claude/context-initial.json`
- IA principal identifica questões-chave

### 3. Selecionar Ferramentas
- Escolher combinação apropriada de ferramentas com base na complexidade da tarefa
- Seguir ordem estrita de chamada de ferramentas

### 4. Executar Tarefa
- IA principal codifica diretamente (lógica simples)
- Lógica complexa delegada ao Codex para design
- Atualização em tempo real de `coding-progress.json`

### 5. Verificar Qualidade
- Codex usa sequential-thinking para revisão profunda
- Gera pontuação e sugestões (escreve em `.claude/review-report.md`)
- IA principal toma decisões rápidas com base em sugestões

### 6. Armazenar Conhecimento
- Registrar processo de decisão em `operations-log.md`
- Atualizar arquivos de contexto
- Manter estado da sessão

## 🎯 Especificação de Chamada do Codex

### Primeira Chamada
```javascript
mcp__codex__codex(
  model="gpt-5-codex",
  sandbox="danger-full-access",
  approval-policy="on-failure",
  prompt="[TASK_MARKER: AAAAMMDD-HHMMSS-XXXX]\nObjetivo: [descrição da tarefa]\nSaída: [lista de entregas]"
)
```

### Continuar Sessão
```javascript
mcp__codex__codex-reply(conversationId="<ID>", prompt="[instrução]")
```

### Gerenciamento de conversationId
- IA principal gera task_marker: `[TASK_MARKER: AAAAMMDD-HHMMSS-XXXX]`
- Codex consulta e persiste em `.claude/codex-sessions.json`
- Retorna no final da resposta: `[CONVERSATION_ID]: <conversationId>`

## 📊 Sistema de Pontuação de Revisão de Qualidade

### Dimensões de Pontuação
- **Dimensão Técnica** (qualidade de código, cobertura de testes, conformidade com normas)
- **Dimensão Estratégica** (correspondência de requisitos, consistência de arquitetura, avaliação de riscos)
- **Pontuação Geral** (0-100)

### Regras de Decisão
- ≥90 pontos e sugestão "aprovar" → Confirmar aprovação diretamente
- <80 pontos e sugestão "devolver" → Confirmar devolução diretamente
- 80-89 pontos ou sugestão "precisa discussão" → Decidir após revisão cuidadosa

## ⚡ Estratégia de Execução Automatizada

### Execução Automática Padrão (sem confirmação)
- ✅ Todas as operações de leitura/escrita de arquivos
- ✅ Chamadas de ferramentas padrão (code-index, exa, grep, etc.)
- ✅ Escrita, modificação e refatoração de código
- ✅ Geração e atualização de documentação
- ✅ Execução de testes e scripts de validação
- ✅ Planejamento e decomposição de tarefas, coleta de contexto
- ✅ Chamada de mcp__codex__codex ou codex-reply

### Exceções que Requerem Confirmação
- ⚠️ Exclusão de arquivos de configuração principais
- ⚠️ Alterações destrutivas no schema do banco de dados
- ⚠️ Git push para repositório remoto
- ⚠️ Ajuste de estratégia necessário após 3 erros consecutivos idênticos

## 🔍 Configuração de Recursos Avançados

### Configuração de Pesquisa Exa
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

### Integração Chrome DevTools
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

### Configuração Code Index
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

## 🛠️ Solução de Problemas

### Problemas Comuns
1. **Erro na ordem de chamada de ferramentas** → Verificar configuração workflow.execution_order
2. **Problema de especificação de caminho** → Garantir que todas as ferramentas usem o diretório `.claude/`
3. **Falha no gerenciamento de sessão** → Verificar arquivo `.claude/codex-sessions.json`
4. **Problema de permissões** → Garantir que o diretório `.claude/` tenha permissões de escrita

### Comandos de Depuração
```bash
# Verificar configuração
./verify-config.sh

# Verificar ordem de chamada de ferramentas
grep -A 10 "execution_order" .claude/claude_desktop_config.json

# Ver estado da sessão
cat .claude/codex-sessions.json

# Verificar permissões do diretório de trabalho
ls -la .claude/
```

## 📈 Otimização de Desempenho

### Configurações Recomendadas
- Usar armazenamento SSD para melhorar desempenho de I/O
- Configurar memória suficiente (recomendado 8GB+)
- Limpar periodicamente o diretório `.claude/cache/`
- Usar cache local para reduzir cálculos repetidos

### Métricas de Monitoramento
- Tempo de resposta das ferramentas
- Taxa de sucesso das sessões
- Pontuação de qualidade de revisão de código
- Tempo de conclusão de tarefas
