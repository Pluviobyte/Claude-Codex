#!/bin/bash

# Claude Code + Codex 配置验证脚本
# 检查配置是否正确安装并可以正常工作

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# 计数器
TOTAL_CHECKS=0
PASSED_CHECKS=0
FAILED_CHECKS=0

# 打印带颜色的消息
print_success() {
    echo -e "${GREEN}✓${NC} $1"
    ((PASSED_CHECKS++))
}

print_error() {
    echo -e "${RED}✗${NC} $1"
    ((FAILED_CHECKS++))
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

print_info() {
    echo -e "${BLUE}ℹ${NC} $1"
}

# 检查函数
check_command() {
    local cmd=$1
    local description=$2
    ((TOTAL_CHECKS++))

    print_info "检查 $description..."
    if command -v "$cmd" >/dev/null 2>&1; then
        print_success "$description 已安装"
        return 0
    else
        print_error "$description 未找到"
        return 1
    fi
}

check_file() {
    local file=$1
    local description=$2
    ((TOTAL_CHECKS++))

    print_info "检查 $description..."
    if [ -f "$file" ]; then
        print_success "$description 存在"
        return 0
    else
        print_error "$description 不存在"
        return 1
    fi
}

check_directory() {
    local dir=$1
    local description=$2
    ((TOTAL_CHECKS++))

    print_info "检查 $description..."
    if [ -d "$dir" ]; then
        print_success "$description 存在"
        return 0
    else
        print_error "$description 不存在"
        return 1
    fi
}

validate_json() {
    local file=$1
    ((TOTAL_CHECKS++))

    print_info "验证JSON格式..."
    if python3 -m json.tool "$file" >/dev/null 2>&1; then
        print_success "JSON格式正确"
        return 0
    else
        print_error "JSON格式错误"
        return 1
    fi
}

# 获取Claude配置目录
get_claude_config_dir() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        echo "$HOME/Library/Application Support/Claude"
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        echo "$HOME/.config/claude"
    elif [[ "$OSTYPE" == "msys" ]] || [[ "$OSTYPE" == "cygwin" ]]; then
        echo "$APPDATA/Claude"
    else
        echo "$HOME/.config/claude"  # 默认Linux路径
    fi
}

# 检查API密钥格式
check_api_key() {
    local api_key=$1
    ((TOTAL_CHECKS++))

    print_info "检查API密钥格式..."
    if [[ "$api_key" =~ ^sk-[a-zA-Z0-9]{48}$ ]]; then
        print_success "API密钥格式正确"
        return 0
    elif [[ "$api_key" == "your-openai-api-key-here" ]]; then
        print_error "API密钥未设置"
        return 1
    elif [[ -z "$api_key" ]]; then
        print_error "API密钥为空"
        return 1
    else
        print_warning "API密钥格式可能不正确"
        return 1
    fi
}

# 测试网络连接
test_network() {
    ((TOTAL_CHECKS++))

    print_info "测试网络连接..."
    if curl -s --connect-timeout 5 https://api.openai.com/v1/models >/dev/null 2>&1; then
        print_success "网络连接正常"
        return 0
    else
        print_error "网络连接失败"
        return 1
    fi
}

# 检查MCP服务器
check_mcp_server() {
    local server_name=$1
    local command=$2
    ((TOTAL_CHECKS++))

    print_info "检查MCP服务器: $server_name..."
    if eval "$command" >/dev/null 2>&1; then
        print_success "MCP服务器 $server_name 可用"
        return 0
    else
        print_warning "MCP服务器 $server_name 不可用"
        return 1
    fi
}

# 主验证函数
main() {
    echo -e "${BLUE}================================${NC}"
    echo -e "${BLUE}  Claude Code + Codex 配置验证  ${NC}"
    echo -e "${BLUE}================================${NC}"
    echo ""

    # 检查基本依赖
    print_info "检查系统依赖..."
    check_command "node" "Node.js"
    check_command "npm" "npm"
    check_command "python3" "Python 3"
    check_command "pip" "pip"
    echo ""

    # 检查配置目录和文件
    print_info "检查配置文件..."
    local config_dir=$(get_claude_config_dir)
    check_directory "$config_dir" "Claude配置目录"

    local config_file="$config_dir/claude_desktop_config.json"
    check_file "$config_file" "Claude配置文件"
    echo ""

    # 验证配置文件格式
    if [ -f "$config_file" ]; then
        validate_json "$config_file"

        # 检查API密钥
        print_info "检查API配置..."
        local api_key=$(grep -o '"OPENAI_API_KEY": "[^"]*"' "$config_file" | cut -d'"' -f4)
        check_api_key "$api_key"
        echo ""
    fi

    # 检查网络连接
    print_info "检查网络连接..."
    test_network
    echo ""

    # 检查MCP服务器
    print_info "检查MCP服务器..."
    check_mcp_server "sequential-thinking" "npx -y @modelcontextprotocol/server-sequential-thinking --version"
    check_mcp_server "codex" "codex --version"
    check_mcp_server "shrimp-task-manager" "npx -y mcp-shrimp-task-manager --version"
    echo ""

    # 显示验证结果
    echo -e "${BLUE}================================${NC}"
    echo -e "${BLUE}        验证结果总结            ${NC}"
    echo -e "${BLUE}================================${NC}"
    echo ""
    echo -e "总检查项: ${BLUE}$TOTAL_CHECKS${NC}"
    echo -e "通过检查: ${GREEN}$PASSED_CHECKS${NC}"
    echo -e "失败检查: ${RED}$FAILED_CHECKS${NC}"
    echo ""

    if [ $FAILED_CHECKS -eq 0 ]; then
        print_success "🎉 所有检查通过！配置完全正确"
        echo ""
        print_info "下一步:"
        echo "1. 重启Claude Code应用"
        echo "2. 在聊天中输入: /available-tools"
        echo "3. 确认能看到codex相关工具"
        exit 0
    else
        print_error "发现 $FAILED_CHECKS 个问题需要修复"
        echo ""
        print_info "修复建议:"
        echo "1. 重新运行安装脚本: ./install.sh"
        echo "2. 查看故障排除指南: troubleshooting.md"
        echo "3. 检查API密钥是否正确"
        exit 1
    fi
}

# 运行主函数
main "$@"