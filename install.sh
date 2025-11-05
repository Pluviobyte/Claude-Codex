#!/bin/bash

# Claude Code + Codex 一键安装脚本
# 支持 macOS, Linux, Windows (Git Bash)

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 打印带颜色的消息
print_message() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_header() {
    echo -e "${BLUE}================================${NC}"
    echo -e "${BLUE}  Claude Code + Codex 安装向导  ${NC}"
    echo -e "${BLUE}================================${NC}"
}

# 检测操作系统
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

# 检查命令是否存在
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# 检查依赖
check_dependencies() {
    print_message "检查系统依赖..."

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
        print_error "缺少以下依赖: ${missing_deps[*]}"
        print_message "请先安装缺少的依赖后再运行此脚本"
        echo ""
        print_message "安装建议:"
        echo "  Node.js: https://nodejs.org/"
        echo "  Python: https://www.python.org/"
        exit 1
    fi

    print_message "所有依赖检查通过 ✓"
}

# 获取Claude配置目录
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
            print_error "不支持的操作系统: $os"
            exit 1
            ;;
    esac
}

# 创建配置目录
create_config_dir() {
    local config_dir=$(get_claude_config_dir)

    if [ ! -d "$config_dir" ]; then
        print_message "创建Claude配置目录: $config_dir"
        mkdir -p "$config_dir"
    fi

    echo "$config_dir"
}

# 选择配置模板
choose_config() {
    echo ""
    print_message "请选择配置模板:"
    echo "1) 简单配置 (推荐新手) - Claude + Codex基础协作"
    echo "2) 标准配置 (推荐日常使用) - 完整协作开发环境"
    echo "3) 高级配置 (推荐高级用户) - 企业级开发环境"
    echo ""

    while true; do
        read -p "请输入选择 (1-3): " choice
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
                print_warning "请输入有效选择 (1-3)"
                ;;
        esac
    done
}


# 生成配置文件
generate_config() {
    local template_file=$1
    local exa_api_key=$2
    local output_file=$3

    print_message "生成配置文件: $output_file"

    # 如果有Exa API密钥，则替换；否则移除相关配置
    if [ -n "$exa_api_key" ]; then
        sed "s/your-exa-api-key-here/$exa_api_key/g" "$template_file" > "$output_file"
        print_message "Exa API密钥已设置 ✓"
    else
        # 移除Exa配置（如果存在）
        sed '/exa/,/}/d' "$template_file" > "$output_file"
        print_message "跳过Exa配置"
    fi

    print_message "配置文件生成完成 ✓"
}

# 根据配置级别安装对应的包
install_packages_by_config() {
    local config_level=$1
    print_message "为 $config_level 配置安装对应的包..."

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
            print_error "未知的配置级别: $config_level"
            return 1
            ;;
    esac
}

# 安装基础包（简单配置）
install_basic_packages() {
    print_message "安装基础包（简单配置）..."

    local packages=(
        "@modelcontextprotocol/server-sequential-thinking"
    )

    for package in "${packages[@]}"; do
        print_message "安装 $package..."
        npm install -g "$package" || print_warning "$package 安装失败，可稍后手动安装"
    done

    # Codex 通常需要单独安装，检查是否可用
    if ! command_exists codex; then
        print_warning "Codex 未找到，请确保已正确安装 Codex"
        print_info "Codex 安装指南：请参考官方文档"
    else
        print_message "Codex 已安装 ✓"
    fi
}

# 安装标准包（标准配置）
install_standard_packages() {
    print_message "安装标准包（标准配置）..."

    local packages=(
        "@modelcontextprotocol/server-sequential-thinking"
        "mcp-shrimp-task-manager"
    )

    for package in "${packages[@]}"; do
        print_message "安装 $package..."
        npm install -g "$package" || print_warning "$package 安装失败，可稍后手动安装"
    done

    # 检查 Codex
    if ! command_exists codex; then
        print_warning "Codex 未找到，请确保已正确安装 Codex"
    else
        print_message "Codex 已安装 ✓"
    fi

    # 安装 code-index-mcp
    install_code_index
}

# 安装所有包（高级配置）
install_all_packages() {
    print_message "安装所有包（高级配置）..."

    local packages=(
        "@modelcontextprotocol/server-sequential-thinking"
        "mcp-shrimp-task-manager"
        "chrome-devtools-mcp@latest"
        "exa-mcp-server"
    )

    for package in "${packages[@]}"; do
        print_message "安装 $package..."
        npm install -g "$package" || print_warning "$package 安装失败，可稍后手动安装"
    done

    # 检查 Codex
    if ! command_exists codex; then
        print_warning "Codex 未找到，请确保已正确安装 Codex"
    else
        print_message "Codex 已安装 ✓"
    fi

    # 安装 code-index-mcp
    install_code_index
}

# 安装 code-index-mcp
install_code_index() {
    print_message "安装 code-index-mcp..."

    # 检查 uvx 是否可用
    if ! command_exists uvx; then
        print_message "安装 uvx..."
        pip install uv || print_warning "uvx 安装失败，可稍后手动安装"
    fi

    # 测试 code-index-mcp
    if command_exists uvx; then
        uvx code-index-mcp --help >/dev/null 2>&1 || print_warning "code-index-mcp 测试失败"
    fi
}

# 安装Python包
install_python_packages() {
    print_message "安装必要的Python包..."

    # 安装uvx (如果还没有)
    if ! command_exists uvx; then
        print_message "安装uvx..."
        pip install uv || print_warning "uvx安装失败，可稍后手动安装"
    fi

    # 安装code-index-mcp
    print_message "安装code-index-mcp..."
    uvx code-index-mcp --help >/dev/null 2>&1 || print_warning "code-index-mcp安装失败，可稍后手动安装"
}

# 验证安装
verify_installation() {
    print_message "验证安装..."

    local config_dir=$(get_claude_config_dir)
    local config_file="$config_dir/claude_desktop_config.json"

    if [ -f "$config_file" ]; then
        print_message "配置文件已正确安装 ✓"
    else
        print_error "配置文件安装失败"
        return 1
    fi

    print_message "安装验证完成 ✓"
}

# 显示完成信息
show_completion() {
    local config_level=$1
    echo ""
    print_header
    print_message "🎉 Claude Code + Codex 安装完成！"
    echo ""
    print_message "安装配置级别: $config_level"
    echo ""

    case $config_level in
        "simple")
            print_message "已安装功能:"
            echo "✓ Sequential-thinking (深度推理)"
            echo "✓ Codex (代码分析)"
            echo "✓ 基础协作工作流"
            ;;
        "standard")
            print_message "已安装功能:"
            echo "✓ Sequential-thinking (深度推理)"
            echo "✓ Shrimp Task Manager (任务管理)"
            echo "✓ Codex (代码分析)"
            echo "✓ Code Index (代码索引)"
            echo "✓ 标准协作工作流"
            ;;
        "advanced")
            print_message "已安装功能:"
            echo "✓ Sequential-thinking (深度推理)"
            echo "✓ Shrimp Task Manager (任务管理)"
            echo "✓ Codex (代码分析)"
            echo "✓ Code Index (代码索引)"
            echo "✓ Chrome DevTools (浏览器调试)"
            echo "✓ Exa Search (网络搜索)"
            echo "✓ 完整协作工作流"
            ;;
    esac

    echo ""
    print_message "下一步操作:"
    echo "1. 重启Claude Code应用"
    echo "2. 在Claude Code中输入: /available-tools"
    echo "3. 确认能看到已安装的MCP工具"
    echo ""
    print_message "配置文件位置:"
    echo "$(get_claude_config_dir)/claude_desktop_config.json"
    echo ""
    print_message "工作目录结构:"
    echo "$(dirname $(get_claude_config_dir))/.claude/"
    echo ""
    print_message "如遇问题，请查看故障排除指南:"
    echo "https://github.com/claude-codex/setup/troubleshooting"
    echo ""
}

# 主函数
main() {
    print_header

    # 检查依赖
    check_dependencies

    # 获取配置目录
    local config_dir=$(create_config_dir)

    # 选择配置模板（返回文件名和配置级别）
    local config_choice=$(choose_config)
    local template_file=$(echo "$config_choice" | head -n1)
    local config_level=$(echo "$config_choice" | tail -n1)

    # 检查是否需要API密钥（仅高级配置需要）
    local api_key=""
    if [ "$config_level" = "advanced" ]; then
        print_message "高级配置需要Exa API密钥（可选）"
        read -p "是否要设置Exa API密钥？(y/N): " setup_exa
        if [[ "$setup_exa" =~ ^[Yy]$ ]]; then
            api_key=$(get_exa_api_key)
        fi
    fi

    # 生成配置文件
    local config_file="$config_dir/claude_desktop_config.json"
    generate_config "$template_file" "$api_key" "$config_file"

    # 创建工作目录结构
    create_working_directories "$config_dir"

    # 根据配置级别安装对应的包
    install_packages_by_config "$config_level"

    # 验证安装
    verify_installation

    # 显示完成信息
    show_completion "$config_level"
}

# 创建工作目录结构
create_working_directories() {
    local config_dir=$1
    local project_dir=$(dirname "$config_dir")
    local claude_dir="$project_dir/.claude"

    print_message "创建工作目录结构..."

    # 创建 .claude 目录结构
    mkdir -p "$claude_dir"/{shrimp,codex,context,logs,cache}

    print_message "工作目录结构创建完成 ✓"
}

# 获取Exa API密钥
get_exa_api_key() {
    echo ""
    print_message "请输入你的Exa API密钥（可选）："
    print_warning "如果还没有Exa API密钥，可以跳过此步骤"
    echo ""

    read -s -p "Exa API Key (可选，按Enter跳过): " exa_key
    echo ""

    if [ -z "$exa_key" ]; then
        print_message "跳过Exa API密钥设置"
    fi

    echo "$exa_key"
}

# 运行主函数
main "$@"