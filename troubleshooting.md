# Guia de Solução de Problemas

## 🔧 Resolução de Problemas Comuns

### ❌ Não consigo ver as ferramentas do Codex

**Problema**: Ao digitar `/available-tools` no Claude Code, não aparecem as ferramentas relacionadas ao Codex

**Possíveis causas**:
1. Arquivo de configuração não foi instalado corretamente
2. Claude Code não foi reiniciado
3. Servidor MCP não foi iniciado

**Soluções**:
```bash
# 1. Verificar arquivo de configuração
./verify-config.sh

# 2. Verificar localização do arquivo de configuração
ls -la ~/Library/Application\ Support/Claude/claude_desktop_config.json  # macOS
ls -la ~/.config/claude/claude_desktop_config.json  # Linux
ls -la %APPDATA%/Claude/claude_desktop_config.json  # Windows

# 3. Reinstalar configuração
./install.sh
```

### 🔑 Problemas com chave de API

**Problema**: Falha nas chamadas de API, erro de autenticação

**Possíveis causas**:
1. Formato incorreto da chave de API
2. Chave de API expirada
3. Saldo insuficiente na conta

**Soluções**:
```bash
# 1. Verificar formato da chave de API
grep "OPENAI_API_KEY" ~/.config/claude/claude_desktop_config.json

# 2. Testar chave de API
curl -H "Authorization: Bearer YOUR_API_KEY" https://api.openai.com/v1/models

# 3. Atualizar chave de API
# Edite o arquivo de configuração e substitua a chave de API
```

**Requisitos de formato da chave de API**:
- Começa com `sk-`
- Comprimento total de 51 caracteres
- Contém letras e números

### 🌐 Problemas de conexão de rede

**Problema**: Não é possível conectar à API OpenAI

**Possíveis causas**:
1. Firewall bloqueando a conexão
2. Problemas de configuração de proxy
3. Problemas de resolução DNS

**Soluções**:
```bash
# 1. Testar conexão de rede
curl -I https://api.openai.com/v1/models

# 2. Verificar configurações de proxy
echo $HTTP_PROXY
echo $HTTPS_PROXY

# 3. Usar proxy (se necessário)
export HTTPS_PROXY=http://seu-proxy:porta
```

### 📦 Falha na instalação de dependências

**Problema**: Falha ao instalar pacotes npm ou pip

**Possíveis causas**:
1. Permissões insuficientes
2. Problemas de rede
3. Conflitos de versão

**Soluções**:
```bash
# 1. Usar sudo para instalar (Linux/macOS)
sudo npm install -g @modelcontextprotocol/server-sequential-thinking

# 2. Limpar cache do npm
npm cache clean --force

# 3. Usar espelho brasileiro
npm config set registry https://registry.npmjs.org

# 4. Instalar pacotes Python manualmente
pip3 install --user uv
```

### 🚀 Falha ao iniciar servidor MCP

**Problema**: Servidor MCP não inicia corretamente

**Possíveis causas**:
1. Versão incompatível do Node.js
2. Problemas no ambiente Python
3. Porta já em uso

**Soluções**:
```bash
# 1. Verificar versão do Node.js
node --version  # Necessário >= 16.0.0

# 2. Verificar versão do Python
python3 --version  # Necessário >= 3.8

# 3. Testar servidor MCP manualmente
npx @modelcontextprotocol/server-sequential-thinking --version
codex --version

# 4. Ver logs de erro
tail -f ~/.claude/logs/*.log
```

## 🔍 Ferramentas de Diagnóstico

### Script de verificação de configuração
```bash
# Executar verificação completa de configuração
./verify-config.sh
```

### Passos de verificação manual
```bash
# 1. Verificar sintaxe do arquivo de configuração
python3 -m json.tool ~/.config/claude/claude_desktop_config.json

# 2. Testar servidores MCP
npx -y @modelcontextprotocol/server-sequential-thinking --help
codex mcp-server --help

# 3. Verificar versão do Claude Code
# No Claude Code, digite: /version
```

## 📋 Requisitos do Sistema

### Requisitos Mínimos
- **Sistema Operacional**: Windows 10+, macOS 10.15+, Ubuntu 18.04+
- **Node.js**: 16.0.0+
- **Python**: 3.8+
- **Memória**: 4GB RAM
- **Armazenamento**: 1GB de espaço disponível

### Configuração Recomendada
- **Sistema Operacional**: Versão mais recente de Windows/macOS/Linux
- **Node.js**: 18.0.0+
- **Python**: 3.10+
- **Memória**: 8GB+ RAM
- **Armazenamento**: 2GB+ de espaço disponível
- **Rede**: Conexão estável à internet

## 🔄 Resetar Configuração

### Reset Completo
```bash
# 1. Fazer backup da configuração existente
cp ~/.config/claude/claude_desktop_config.json ~/.config/claude/claude_desktop_config.json.backup

# 2. Remover arquivo de configuração
rm ~/.config/claude/claude_desktop_config.json

# 3. Reinstalar
./install.sh
```

### Limpar Dependências
```bash
# Desinstalar pacotes npm
npm uninstall -g @modelcontextprotocol/server-sequential-thinking
npm uninstall -g mcp-shrimp-task-manager
npm uninstall -g chrome-devtools-mcp
npm uninstall -g exa-mcp-server

# Desinstalar pacotes Python
pip uninstall uv
```

## 📞 Obter Ajuda

### Suporte da Comunidade
- **GitHub Issues**: https://github.com/tiagoalucard/Claude-Codex/issues
- **Discussões**: https://github.com/tiagoalucard/Claude-Codex/discussions

### Coleta de Logs
```bash
# Coletar informações do sistema
./collect-logs.sh

# Coletar logs manualmente
echo "=== Informações do Sistema ===" > debug.log
uname -a >> debug.log
node --version >> debug.log
python3 --version >> debug.log
echo "" >> debug.log

echo "=== Arquivo de Configuração ===" >> debug.log
cat ~/.config/claude/claude_desktop_config.json >> debug.log
echo "" >> debug.log

echo "=== Teste de Rede ===" >> debug.log
curl -I https://api.openai.com/v1/models >> debug.log
```

## 🎯 Otimização de Desempenho

### Otimização de Chamadas de API
- Use o modelo apropriado (gpt-4 é mais caro mas mais preciso que gpt-3.5)
- Configure limites de chamada razoáveis
- Cache resultados usados frequentemente

### Otimização Local
- Garanta memória suficiente
- Use armazenamento SSD
- Feche aplicativos desnecessários em segundo plano

### Otimização de Rede
- Use conexão de rede estável
- Considere usar CDN para aceleração
- Configure timeouts razoáveis

---

Se as soluções acima não resolverem seu problema, por favor crie uma Issue no GitHub fornecendo informações detalhadas sobre o erro e ambiente do sistema.
