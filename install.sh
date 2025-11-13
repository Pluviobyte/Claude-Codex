#!/bin/bash

# Claude Code + Codex Script de Instalação Automática
# Suporta macOS, Linux, Windows (Git Bash)

set -e

# Definição de cores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # Sem Cor

# Imprimir mensagens com cores
print_message() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[AVISO]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERRO]${NC} $1"
}

print_header() {
    echo -e "${BLUE}================================${NC}"
    echo -e "${BLUE}  Assistente de Instalação      ${NC}"
    echo -e "${BLUE}  Claude Code + Codex           ${NC}"
    echo -e "${BLUE}================================${NC}"
}

# Detectar sistema operacional
detect_os() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        echo "macos"
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        echo "linux"
    elif [[ "$OSTYPE" == "msys" ]] || [[ "$OSTYPE" == "cygwin" ]]; then
        echo "windows"
    else
        echo "unknown"
    fi
}

# Verificar se comando existe
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Verificar dependências
check_dependencies() {
    print_message "Verificando dependências do sistema..."

    local missing_deps=()

    if ! command_exists node; then
        missing_deps+=("Node.js")
    fi

    if ! command_exists npm; then
        missing_deps+=("npm")
    fi

    if ! command_exists python3; then
        missing_deps+=("Python 3")
    fi

    if ! command_exists pip; then
        missing_deps+=("pip")
    fi

    if [ ${#missing_deps[@]} -ne 0 ]; then
        print_error "Faltam as seguintes dependências: ${missing_deps[*]}"
        print_message "Por favor, instale as dependências faltantes antes de executar este script"
        echo ""
        print_message "Sugestões de instalação:"
        echo "  Node.js: https://nodejs.org/"
        echo "  Python: https://www.python.org/"
        exit 1
    fi

    print_message "Todas as dependências verificadas ✓"
}

# Obter diretório de configuração do Claude
get_claude_config_dir() {
    local os=$(detect_os)
    case $os in
        "macos")
            echo "$HOME/Library/Application Support/Claude"
            ;;
        "linux")
            echo "$HOME/.config/claude"
            ;;
        "windows")
            echo "$APPDATA/Claude"
            ;;
        *)
            print_error "Sistema operacional não suportado: $os"
            exit 1
            ;;
    esac
}

# Criar diretório de configuração
create_config_dir() {
    local config_dir=$(get_claude_config_dir)

    if [ ! -d "$config_dir" ]; then
        print_message "Criando diretório de configuração do Claude: $config_dir"
        mkdir -p "$config_dir"
    fi

    echo "$config_dir"
}

# Escolher configuração
choose_config() {
    echo ""
    print_message "Por favor, escolha um modelo de configuração:"
    echo "1) Configuração Simples (recomendado para iniciantes) - Colaboração básica Claude + Codex"
    echo "2) Configuração Padrão (recomendado para uso diário) - Ambiente de desenvolvimento colaborativo completo"
    echo "3) Configuração Avançada (recomendado para usuários avançados) - Ambiente de desenvolvimento empresarial"
    echo ""

    while true; do
        read -p "Digite sua escolha (1-3): " choice
        case $choice in
            1)
                echo "config-simple.json"
                echo "simple"
                break
                ;;
            2)
                echo "claude-desktop-config.json"
                echo "standard"
                break
                ;;
            3)
                echo "config-advanced.json"
                echo "advanced"
                break
                ;;
            *)
                print_warning "Por favor, digite uma escolha válida (1-3)"
                ;;
        esac
    done
}


# Gerar arquivo de configuração
generate_config() {
    local template_file=$1
    local exa_api_key=$2
    local output_file=$3

    print_message "Gerando arquivo de configuração: $output_file"

    # Verificar se o arquivo template existe
    if [ ! -f "$template_file" ]; then
        print_error "Arquivo template não encontrado: $template_file"
        return 1
    fi

    # Se houver chave da API Exa, substitua; caso contrário, remova a configuração relacionada
    if [ -n "$exa_api_key" ]; then
        sed "s/your-exa-api-key-here/$exa_api_key/g" "$template_file" > "$output_file"
        print_message "Chave da API Exa configurada ✓"
    else
        # Remover configuração do Exa usando Python para manipulação JSON segura
        if command_exists python3; then
            python3 -c "
import json
import sys

try:
    with open('$template_file', 'r', encoding='utf-8') as f:
        config = json.load(f)

    # Remover servidor Exa se existir
    if 'mcpServers' in config and 'exa' in config['mcpServers']:
        del config['mcpServers']['exa']

    # Remover do execution_order se existir
    if 'workflow' in config and 'execution_order' in config['workflow']:
        if 'exa' in config['workflow']['execution_order']:
            config['workflow']['execution_order'].remove('exa')

    with open('$output_file', 'w', encoding='utf-8') as f:
        json.dump(config, f, indent=2, ensure_ascii=False)

    print('Configuração do Exa removida com sucesso')
except Exception as e:
    print(f'Erro ao processar configuração: {e}', file=sys.stderr)
    sys.exit(1)
" || {
                print_error "Falha ao processar arquivo de configuração"
                return 1
            }
        else
            # Fallback: copiar arquivo original se Python não estiver disponível
            cp "$template_file" "$output_file"
            print_warning "Python não disponível, copiando configuração original. Configure manualmente a chave da API Exa se necessário."
        fi
        print_message "Configuração do Exa ignorada"
    fi

    print_message "Arquivo de configuração gerado com sucesso ✓"
}

# Instalar pacotes baseado na configuração
install_packages_by_config() {
    local config_level=$1
    print_message "Instalando pacotes para configuração $config_level..."

    case $config_level in
        "simple")
            install_basic_packages
            ;;
        "standard")
            install_standard_packages
            ;;
        "advanced")
            install_all_packages
            ;;
        *)
            print_error "Nível de configuração desconhecido: $config_level"
            return 1
            ;;
    esac
}

# Instalar pacotes básicos (configuração simples)
install_basic_packages() {
    print_message "Instalando pacotes básicos (configuração simples)..."

    local packages=(
        "@modelcontextprotocol/server-sequential-thinking"
    )

    for package in "${packages[@]}"; do
        print_message "Instalando $package..."
        npm install -g "$package" || print_warning "Falha ao instalar $package, você pode instalá-lo manualmente mais tarde"
    done

    # Codex geralmente precisa ser instalado separadamente, verificar se está disponível
    if ! command_exists codex; then
        print_warning "Codex não encontrado, certifique-se de que o Codex está instalado corretamente"
        print_message "Guia de instalação do Codex: consulte a documentação oficial"
    else
        print_message "Codex instalado ✓"
    fi
}

# Instalar pacotes padrão (configuração padrão)
install_standard_packages() {
    print_message "Instalando pacotes padrão (configuração padrão)..."

    local packages=(
        "@modelcontextprotocol/server-sequential-thinking"
        "mcp-shrimp-task-manager"
    )

    for package in "${packages[@]}"; do
        print_message "Instalando $package..."
        npm install -g "$package" || print_warning "Falha ao instalar $package, você pode instalá-lo manualmente mais tarde"
    done

    # Verificar Codex
    if ! command_exists codex; then
        print_warning "Codex não encontrado, certifique-se de que o Codex está instalado corretamente"
    else
        print_message "Codex instalado ✓"
    fi

    # Instalar code-index-mcp
    install_code_index
}

# Instalar todos os pacotes (configuração avançada)
install_all_packages() {
    print_message "Instalando todos os pacotes (configuração avançada)..."

    local packages=(
        "@modelcontextprotocol/server-sequential-thinking"
        "mcp-shrimp-task-manager"
        "chrome-devtools-mcp@latest"
        "exa-mcp-server"
    )

    for package in "${packages[@]}"; do
        print_message "Instalando $package..."
        npm install -g "$package" || print_warning "Falha ao instalar $package, você pode instalá-lo manualmente mais tarde"
    done

    # Verificar Codex
    if ! command_exists codex; then
        print_warning "Codex não encontrado, certifique-se de que o Codex está instalado corretamente"
    else
        print_message "Codex instalado ✓"
    fi

    # Instalar code-index-mcp
    install_code_index
}

# Instalar code-index-mcp
install_code_index() {
    print_message "Instalando code-index-mcp..."

    # Verificar se uvx está disponível
    if ! command_exists uvx; then
        print_message "Instalando uvx..."
        pip install uv || print_warning "Falha ao instalar uvx, você pode instalá-lo manualmente mais tarde"
    fi

    # Testar code-index-mcp
    if command_exists uvx; then
        uvx code-index-mcp --help >/dev/null 2>&1 || print_warning "Teste do code-index-mcp falhou"
    fi
}

# Instalar pacotes Python
install_python_packages() {
    print_message "Instalando pacotes Python necessários..."

    # Instalar uvx (se ainda não estiver instalado)
    if ! command_exists uvx; then
        print_message "Instalando uvx..."
        pip install uv || print_warning "Falha ao instalar uvx, você pode instalá-lo manualmente mais tarde"
    fi

    # Instalar code-index-mcp
    print_message "Instalando code-index-mcp..."
    uvx code-index-mcp --help >/dev/null 2>&1 || print_warning "Falha ao instalar code-index-mcp, você pode instalá-lo manualmente mais tarde"
}

# Verificar instalação
verify_installation() {
    print_message "Verificando instalação..."

    local config_dir=$(get_claude_config_dir)
    local config_file="$config_dir/claude_desktop_config.json"

    if [ -f "$config_file" ]; then
        print_message "Arquivo de configuração instalado corretamente ✓"
    else
        print_error "Falha na instalação do arquivo de configuração"
        return 1
    fi

    print_message "Verificação de instalação concluída ✓"
}

# Mostrar informações de conclusão
show_completion() {
    local config_level=$1
    echo ""
    print_header
    print_message "🎉 Instalação do Claude Code + Codex concluída!"
    echo ""
    print_message "Nível de configuração instalado: $config_level"
    echo ""

    case $config_level in
        "simple")
            print_message "Recursos instalados:"
            echo "✓ Sequential-thinking (raciocínio profundo)"
            echo "✓ Codex (análise de código)"
            echo "✓ Fluxo de trabalho colaborativo básico"
            ;;
        "standard")
            print_message "Recursos instalados:"
            echo "✓ Sequential-thinking (raciocínio profundo)"
            echo "✓ Shrimp Task Manager (gerenciamento de tarefas)"
            echo "✓ Codex (análise de código)"
            echo "✓ Code Index (indexação de código)"
            echo "✓ Fluxo de trabalho colaborativo padrão"
            ;;
        "advanced")
            print_message "Recursos instalados:"
            echo "✓ Sequential-thinking (raciocínio profundo)"
            echo "✓ Shrimp Task Manager (gerenciamento de tarefas)"
            echo "✓ Codex (análise de código)"
            echo "✓ Code Index (indexação de código)"
            echo "✓ Chrome DevTools (depuração de navegador)"
            echo "✓ Exa Search (pesquisa na web)"
            echo "✓ Fluxo de trabalho colaborativo completo"
            ;;
    esac

    echo ""
    print_message "Próximas etapas:"
    echo "1. Reinicie o aplicativo Claude Code"
    echo "2. No Claude Code, digite: /available-tools"
    echo "3. Confirme que você pode ver as ferramentas MCP instaladas"
    echo ""
    print_message "Localização do arquivo de configuração:"
    echo "$(get_claude_config_dir)/claude_desktop_config.json"
    echo ""
    print_message "Estrutura do diretório de trabalho:"
    echo "$(dirname $(get_claude_config_dir))/.claude/"
    echo ""
    print_message "Se você encontrar problemas, consulte o guia de solução de problemas:"
    echo "https://github.com/tiagoalucard/Claude-Codex/blob/main/troubleshooting.md"
    echo ""
}

# Função principal
main() {
    print_header

    # Verificar dependências
    check_dependencies

    # Obter diretório de configuração
    local config_dir=$(create_config_dir)

    # Escolher modelo de configuração (retorna nome do arquivo e nível de configuração)
    local config_choice=$(choose_config)
    local template_file=$(echo "$config_choice" | head -n1)
    local config_level=$(echo "$config_choice" | tail -n1)

    # Verificar se é necessária chave de API (apenas configuração avançada)
    local api_key=""
    if [ "$config_level" = "advanced" ]; then
        print_message "A configuração avançada requer chave da API Exa (opcional)"
        read -p "Deseja configurar a chave da API Exa? (s/N): " setup_exa
        if [[ "$setup_exa" =~ ^[SsYy]$ ]]; then
            api_key=$(get_exa_api_key)
        fi
    fi

    # Gerar arquivo de configuração
    local config_file="$config_dir/claude_desktop_config.json"
    generate_config "$template_file" "$api_key" "$config_file"

    # Criar estrutura de diretórios de trabalho
    create_working_directories "$config_dir"

    # Instalar pacotes conforme o nível de configuração
    install_packages_by_config "$config_level"

    # Verificar instalação
    verify_installation

    # Mostrar informações de conclusão
    show_completion "$config_level"
}

# Criar estrutura de diretórios de trabalho
create_working_directories() {
    local config_dir=$1
    local project_dir=$(dirname "$config_dir")
    local claude_dir="$project_dir/.claude"

    print_message "Criando estrutura de diretórios de trabalho..."

    # Criar estrutura de diretórios .claude
    mkdir -p "$claude_dir"/{shrimp,codex,context,logs,cache}

    print_message "Estrutura de diretórios de trabalho criada ✓"
}

# Obter chave da API Exa
get_exa_api_key() {
    echo ""
    print_message "Por favor, insira sua chave da API Exa (opcional):"
    print_warning "Se você ainda não tem uma chave da API Exa, pode pular esta etapa"
    echo ""

    read -s -p "Chave da API Exa (opcional, pressione Enter para pular): " exa_key
    echo ""

    if [ -z "$exa_key" ]; then
        print_message "Configuração da chave da API Exa ignorada"
    fi

    echo "$exa_key"
}

# Executar função principal
main "$@"
