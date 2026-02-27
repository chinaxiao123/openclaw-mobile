#!/data/data/com.termux/files/usr/bin/bash

# OpenClaw Termux 自动部署脚本
# 用于在安卓手机上自动安装配置 OpenClaw Gateway

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 日志函数
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# 输出 JSON 结果
output_json() {
    local success=$1
    local host=$2
    local port=$3
    local token=$4
    local status=$5
    local message=$6
    
    cat << EOF
{
  "success": $success,
  "gateway_host": "$host",
  "gateway_port": $port,
  "gateway_token": "$token",
  "status": "$status",
  "message": "$message"
}
EOF
}

# 清理函数
cleanup() {
    if [ $? -ne 0 ]; then
        log_error "安装失败，请检查错误信息"
        output_json "false" "null" "0" "null" "failed" "安装过程中出错"
    fi
}

trap cleanup EXIT

# 检查是否在 Termux 中运行
if [ ! -d "/data/data/com.termux" ]; then
    log_error "此脚本只能在 Termux 中运行"
    output_json "false" "null" "0" "null" "failed" "非 Termux 环境"
    exit 1
fi

log_info "=========================================="
log_info "  OpenClaw Termux 自动部署"
log_info "=========================================="
log_info ""

# 步骤 1: 更新包
log_info "[1/10] 更新 Termux 包..."
pkg update -y
pkg upgrade -y

# 步骤 2: 安装基础依赖
log_info "[2/10] 安装基础依赖..."
pkg install -y python nodejs-lts git curl wget proot proot-distro

# 步骤 3: 配置 Python
log_info "[3/10] 配置 Python 环境..."
pip install --upgrade pip
pip install --upgrade setuptools wheel

# 步骤 4: 安装 OpenClaw
log_info "[4/10] 安装 OpenClaw Gateway..."
pip install openclaw

# 步骤 5: 安装 Agent Reach
log_info "[5/10] 安装 Agent Reach..."
pip install https://github.com/Panniantong/agent-reach/archive/main.zip

# 步骤 6: 安装 mcporter
log_info "[6/10] 安装 mcporter..."
npm install -g mcporter

# 步骤 7: 创建配置目录
log_info "[7/10] 创建配置目录..."
mkdir -p ~/.openclaw
mkdir -p ~/.openclaw/workspace
mkdir -p ~/.openclaw/workspace/memory

# 步骤 8: 生成配置文件
log_info "[8/10] 生成配置文件..."

# 生成随机 Token
GATEWAY_TOKEN="oc-$(openssl rand -hex 16)"

# 创建 openclaw.json
cat > ~/.openclaw/openclaw.json << EOF
{
  "gateway": {
    "host": "127.0.0.1",
    "port": 18789,
    "token": "$GATEWAY_TOKEN"
  },
  "agent": {
    "model": "default",
    "thinking": "auto"
  },
  "workspace": "~/.openclaw/workspace"
}
EOF

# 创建 AGENTS.md
cat > ~/.openclaw/workspace/AGENTS.md << 'EOF'
# AGENTS.md - OpenClaw Mobile

欢迎使用 OpenClaw 手机版！

## 快速开始

您现在可以通过手机 APP 连接到此 Gateway。

## 连接信息

- 地址：127.0.0.1
- 端口：18789
- Token: 见 APP 显示

## 注意事项

- 手机需要保持屏幕常亮或开启后台运行权限
- 建议连接 WiFi 以节省流量
- 定期重启 Gateway 以保持最佳性能
EOF

# 创建 SOUL.md
cat > ~/.openclaw/workspace/SOUL.md << 'EOF'
# SOUL.md - 手机版 AI 员工

你是运行在用户手机上的 AI 助手，随时待命。

## 特点

- 📱 随时随地可用
- ⚡ 本地运行，响应快速
- 🔒 数据不出手机，隐私安全
- 💪 功能完整，支持所有工具

## 使命

帮助用户高效完成各种任务，成为真正的随身智能助手。
EOF

# 步骤 9: 配置 Agent Reach
log_info "[9/10] 配置 Agent Reach..."
agent-reach install --env=auto --safe 2>/dev/null || log_warn "Agent Reach 配置可能需要手动完成"

# 步骤 10: 启动 Gateway 服务
log_info "[10/10] 启动 Gateway 服务..."

# 创建启动脚本
cat > ~/.openclaw/start_gateway.sh << EOF
#!/data/data/com.termux/files/usr/bin/bash
cd ~/.openclaw
openclaw gateway start
EOF
chmod +x ~/.openclaw/start_gateway.sh

# 后台启动 Gateway
cd ~/.openclaw
nohup openclaw gateway start > ~/.openclaw/gateway.log 2>&1 &
GATEWAY_PID=$!

# 等待服务启动
sleep 3

# 检查服务状态
if ps -p $GATEWAY_PID > /dev/null; then
    STATUS="running"
    log_success "Gateway 服务已启动 (PID: $GATEWAY_PID)"
else
    STATUS="failed"
    log_error "Gateway 服务启动失败"
fi

# 获取本地 IP
LOCAL_IP=$(hostname -I | awk '{print $1}')
if [ -z "$LOCAL_IP" ]; then
    LOCAL_IP="127.0.0.1"
fi

log_info ""
log_success "=========================================="
log_success "  OpenClaw 部署完成！"
log_success "=========================================="
log_info ""
log_info "连接信息："
log_info "  地址：$LOCAL_IP"
log_info "  端口：18789"
log_info "  Token: $GATEWAY_TOKEN"
log_info ""
log_info "服务状态：$STATUS"
log_info "进程 ID: $GATEWAY_PID"
log_info ""
log_info "管理命令："
log_info "  查看日志：tail -f ~/.openclaw/gateway.log"
log_info "  重启服务：~/.openclaw/start_gateway.sh"
log_info "  停止服务：pkill -f 'openclaw gateway'"
log_info ""

# 输出 JSON 结果给 APP
output_json "true" "$LOCAL_IP" "18789" "$GATEWAY_TOKEN" "$STATUS" "部署成功"

# 禁用 trap
trap - EXIT
