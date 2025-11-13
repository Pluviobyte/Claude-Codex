# Explicação do Arquivo de Configuração Claude Code + Codex

## 📁 Seleção de Arquivo de Configuração

### 1. Configuração Simples (Recomendado para Iniciantes)
- **Arquivo**: `config-simple.json`
- **Funcionalidade**: Colaboração básica entre Claude Code e Codex
- **Inclui**: Sequential-thinking (pensamento profundo)
- **Adequado para**: Experimentação rápida e desenvolvimento básico

### 2. Configuração Padrão (Recomendado para Uso Diário)
- **Arquivo**: `claude-desktop-config.json`
- **Funcionalidade**: Ambiente de desenvolvimento colaborativo completo
- **Inclui**: Gerenciamento de tarefas + Indexação de código
- **Adequado para**: Trabalho de desenvolvimento diário

### 3. Configuração Avançada (Recomendado para Usuários Avançados)
- **Arquivo**: `config-advanced.json`
- **Funcionalidade**: Ambiente de desenvolvimento empresarial
- **Inclui**: Depuração de navegador + Pesquisa na web
- **Adequado para**: Projetos complexos e desenvolvimento avançado

## 🔧 Passos de Configuração

### Passo 1: Escolha o arquivo de configuração
Escolha o arquivo de configuração apropriado com base em suas necessidades.

### Passo 2: Configure as chaves de API
Edite o arquivo de configuração e substitua o seguinte conteúdo:
```json
"OPENAI_API_KEY": "your-openai-api-key-here"
```
Substitua pela sua chave de API OpenAI real.

Configuração opcional:
```json
"EXA_API_KEY": "your-exa-api-key-here"
```
Se estiver usando a configuração avançada, você pode adicionar a chave de API de pesquisa Exa.

### Passo 3: Copie para o local correto
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

### Passo 4: Reinicie o Claude Code
Reinicie o aplicativo Claude Code e a configuração entrará em vigor automaticamente.

## ✅ Verificar Configuração

Após reiniciar, no Claude Code digite:
```
/available-tools
```

Se você vir as ferramentas relacionadas ao Codex, a configuração foi bem-sucedida!
