# Ambiente de Desenvolvimento Colaborativo Claude Code + Codex

## 📁 Estrutura do Projeto

```
claude+codex/
├── README.md                    # Guia principal de uso
├── README-config.md            # Explicação detalhada dos arquivos de configuração
├── troubleshooting.md          # Guia de solução de problemas
├── INDEX.md                    # Visão geral do projeto (este arquivo)
├── install.sh                  # Script de instalação automática
├── verify-config.sh            # Script de verificação de configuração
├── claude-desktop-config.json  # Template de configuração padrão
├── config-simple.json          # Template de configuração simples
└── config-advanced.json        # Template de configuração avançada
```

## 🚀 Início Rápido

### Configure em 3 passos, comece em 5 minutos

1. **Instalação Automática**
   ```bash
   curl -sSL https://raw.githubusercontent.com/tiagoalucard/Claude-Codex/main/install.sh | bash
   ```

2. **Configure chaves de API**
   - Prepare a chave de API OpenAI
   - Digite a chave durante o processo de instalação

3. **Reinicie e verifique**
   - Reinicie o Claude Code
   - Digite `/available-tools` para verificar

## 📋 Documentação

| Documento | Descrição | Público-alvo |
|-----------|-----------|--------------|
| [README.md](README.md) | Guia principal de uso | Todos os usuários |
| [README-config.md](README-config.md) | Explicação detalhada dos arquivos de configuração | Usuários que precisam de configuração personalizada |
| [troubleshooting.md](troubleshooting.md) | Guia de solução de problemas | Usuários com problemas |

## 🛠️ Scripts de Ferramentas

| Script | Funcionalidade | Modo de uso |
|--------|----------------|-------------|
| [install.sh](install.sh) | Instalação e configuração automática | `./install.sh` |
| [verify-config.sh](verify-config.sh) | Verificar se a configuração está correta | `./verify-config.sh` |

## ⚙️ Templates de Configuração

| Arquivo de configuração | Complexidade | Cenário de aplicação |
|-------------------------|--------------|----------------------|
| [config-simple.json](config-simple.json) | Simples | Experimentação rápida, desenvolvimento básico |
| [claude-desktop-config.json](claude-desktop-config.json) | Padrão | Trabalho de desenvolvimento diário |
| [config-advanced.json](config-advanced.json) | Avançado | Projetos complexos, aplicações empresariais |

## 🎯 Recursos Principais

- **Curva de Aprendizado Zero**: Baseado na interface familiar do Claude Code
- **Colaboração Inteligente**: Colaboração entre duas IAs - Claude Code e Codex
- **Configuração com Um Clique**: Instalação e configuração automatizadas
- **Múltiplos Níveis de Complexidade**: De simples a avançado, escolha conforme necessário
- **Suporte Multiplataforma**: Windows/macOS/Linux

## 🤝 Modo de Colaboração

### Claude Code (IA Principal)
- ✅ Gerenciamento de projeto e planejamento de tarefas
- ✅ Escrita e execução de código simples
- ✅ Interação com usuário e decisões finais
- ✅ Gerenciamento de configuração e configuração de ambiente

### Codex (IA de Suporte)
- ✅ Análise profunda de código e geração
- ✅ Design e otimização de algoritmos complexos
- ✅ Revisão e avaliação de qualidade de código
- ✅ Coleta de contexto e recuperação de conhecimento

## 📞 Obter Ajuda

Se encontrar problemas:

1. **Primeiro execute**: `./verify-config.sh` para verificar a configuração
2. **Consulte**: [troubleshooting.md](troubleshooting.md) guia de solução de problemas
3. **Envie**: GitHub Issue para obter suporte da comunidade

---

Comece sua jornada de desenvolvimento colaborativo com IA! 🚀
